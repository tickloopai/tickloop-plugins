#!/usr/bin/env python3
"""Send local files to a Tickloop Artifact through an ArtifactUploadTicket address.

Python standard library only; scripts/upload.mjs does the same with Node.

  python3 upload.py <upload_url> <page.html> [--allow-outside]
      Uploads every local image the page names (src, srcset, poster, CSS url()), writes each
      upload's ref (asset:<id>) in its place, then saves the page's source. Prints JSON:
      {"revision", "images": {reference: ref}, "remaining"}. An image outside the page's
      directory (an absolute path, one through .., or one through a link out of it) is refused
      unless --allow-outside is given.
  python3 upload.py <upload_url> --asset <local file> [--name <name>]
      Uploads one file the artifact keeps by id (an image, a Data file); prints its whole receipt,
      with its ref. The name's extension sets the file's type; the upload keeps no name.
  python3 upload.py <upload_url> --file <path> <local file>
      Writes one file of slides, a design, a design system or a site at <path>; prints its receipt.

On a refusal it prints the service's JSON error and exits 1.
"""

import json
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg"}
TARGET_SUFFIX = re.compile(r"/(?:page_source|asset/.*|file/.*)$")
NOT_LOCAL = re.compile(r"^(?:[a-zA-Z][a-zA-Z0-9+.-]*:|//|#)")
ATTRIBUTE = re.compile(r"""(\b(?:src|poster)\s*=\s*)(["'])(.*?)\2""", re.IGNORECASE | re.DOTALL)
SRCSET = re.compile(r"""(\bsrcset\s*=\s*)(["'])(.*?)\2""", re.IGNORECASE | re.DOTALL)
CSS_URL = re.compile(r"""(url\(\s*)(["']?)([^"')]*?)\2(\s*\))""", re.IGNORECASE)
ATTEMPTS = 3
RETRY_DELAY_SECONDS = 1
# Some CDNs refuse a bare HTTP library's default User-Agent (Cloudflare error 1010); the script names itself instead,
# without a Brand: every Brand serves these same bytes.
USER_AGENT = "artifacts-upload-script/1"


class Refused(Exception):
    def __init__(self, status, body):
        super().__init__(f"{status} {body}")
        self.status = status
        self.body = body


def put(url, data):
    """PUTs data, retrying a broken connection: the same file sent again answers the same receipt."""
    for attempt in range(ATTEMPTS):
        request = urllib.request.Request(url, data=data, method="PUT", headers={"User-Agent": USER_AGENT})
        try:
            with urllib.request.urlopen(request) as response:
                return json.loads(response.read().decode("utf-8"))
        except urllib.error.HTTPError as error:
            raise Refused(error.code, error.read().decode("utf-8", "replace")) from None
        except (urllib.error.URLError, ConnectionError, TimeoutError):
            if attempt == ATTEMPTS - 1:
                raise
            time.sleep(RETRY_DELAY_SECONDS * (1 + attempt))
    raise AssertionError("unreachable")


def base_of(upload_url):
    return TARGET_SUFFIX.sub("", upload_url.rstrip("/"))


def quoted(name):
    return urllib.parse.quote(name, safe="/")


def local_path(reference, page_directory):
    """The file a page's reference names on this machine, or None for any other reference."""
    reference = reference.strip()
    if not reference or NOT_LOCAL.match(reference):
        return None
    path = urllib.parse.unquote(reference.split("#", 1)[0].split("?", 1)[0])
    return os.path.normpath(os.path.join(page_directory, path))


def page_references(html):
    """Every image reference the page holds, in order."""
    references = [match.group(3) for match in ATTRIBUTE.finditer(html)]
    for match in SRCSET.finditer(html):
        references.extend(candidate.split()[0] for candidate in match.group(3).split(",") if candidate.split())
    references.extend(match.group(3) for match in CSS_URL.finditer(html))
    return references


def rewrite(html, refs):
    """The page with each reference in `refs` replaced by its upload's ref."""
    def attribute(match):
        value = match.group(3)
        return f"{match.group(1)}{match.group(2)}{refs.get(value, value)}{match.group(2)}"

    def srcset(match):
        candidates = []
        for candidate in match.group(3).split(","):
            parts = candidate.split()
            if parts and parts[0] in refs:
                candidate = candidate.replace(parts[0], refs[parts[0]], 1)
            candidates.append(candidate)
        return f"{match.group(1)}{match.group(2)}{','.join(candidates)}{match.group(2)}"

    def css_url(match):
        value = match.group(3)
        return f"{match.group(1)}{match.group(2)}{refs.get(value, value)}{match.group(2)}{match.group(4)}"

    html = ATTRIBUTE.sub(attribute, html)
    html = SRCSET.sub(srcset, html)
    return CSS_URL.sub(css_url, html)


def is_inside(path, directory):
    """Whether `path` lies in `directory` once links are followed, so a link out of it is outside."""
    real_directory = os.path.realpath(directory)
    try:
        return os.path.commonpath([os.path.realpath(path), real_directory]) == real_directory
    except ValueError:
        # Windows: a path on another drive shares no path with the directory.
        return False


def publish_page(upload_url, page_file, allow_outside=False):
    base = base_of(upload_url)
    try:
        # newline="" keeps the page's own line endings, as the page is sent byte for byte.
        with open(page_file, encoding="utf-8", newline="") as source:
            html = source.read()
    except UnicodeDecodeError:
        raise SystemExit(f"{page_file} is not UTF-8 text") from None
    page_directory = os.path.dirname(os.path.abspath(page_file))
    files = {}
    missing = []
    outside = []
    for reference in page_references(html):
        path = local_path(reference, page_directory)
        if path is None or reference in files:
            continue
        if os.path.splitext(path)[1].lower() not in IMAGE_EXTENSIONS:
            print(f"Left as written, not an image file: {reference}", file=sys.stderr)
            continue
        if not allow_outside and not is_inside(path, page_directory):
            outside.append(reference)
            continue
        if not os.path.isfile(path):
            missing.append(reference)
            continue
        files[reference] = path
    if outside:
        raise SystemExit(
            f"The page names images outside its directory: {', '.join(outside)}; "
            "add --allow-outside to send them"
        )
    if missing:
        raise SystemExit(f"The page names images that are not on this machine: {', '.join(missing)}")
    uploads = {}
    refs = {}
    for reference, path in files.items():
        if path not in uploads:
            with open(path, "rb") as image:
                receipt = put(f"{base}/asset/{quoted(os.path.basename(path))}", image.read())
            uploads[path] = receipt["ref"]
        refs[reference] = uploads[path]
    receipt = put(f"{base}/page_source", rewrite(html, refs).encode("utf-8"))
    return {"revision": receipt.get("revision"), "images": refs, "remaining": receipt.get("remaining")}


def main(arguments):
    if len(arguments) >= 3 and arguments[1] == "--asset":
        name = arguments[4] if len(arguments) == 5 and arguments[3] == "--name" else os.path.basename(arguments[2])
        with open(arguments[2], "rb") as file:
            return put(f"{base_of(arguments[0])}/asset/{quoted(name)}", file.read())
    if len(arguments) == 4 and arguments[1] == "--file":
        with open(arguments[3], "rb") as file:
            return put(f"{base_of(arguments[0])}/file/{quoted(arguments[2])}", file.read())
    if len(arguments) in (2, 3) and not arguments[1].startswith("--") and arguments[2:] in ([], ["--allow-outside"]):
        return publish_page(arguments[0], arguments[1], allow_outside=len(arguments) == 3)
    raise SystemExit(__doc__)


if __name__ == "__main__":
    try:
        print(json.dumps(main(sys.argv[1:]), indent=2))
    except Refused as refused:
        print(refused.body, file=sys.stderr)
        sys.exit(1)
