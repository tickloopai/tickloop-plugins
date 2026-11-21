#!/usr/bin/env node
// Send local files to a Tickloop Artifact through an ArtifactUploadTicket address.
// Node 18+ standard library only; scripts/upload.py does the same with Python.
//
//   node upload.mjs <upload_url> <page.html> [--allow-outside]
//       Uploads every local image the page names (src, srcset, poster, CSS url()), writes each
//       upload's ref (asset:<id>) in its place, then saves the page's source. Prints JSON:
//       {"revision", "images": {reference: ref}, "remaining"}. An image outside the page's
//       directory (an absolute path, one through .., or one through a link out of it) is refused
//       unless --allow-outside is given.
//   node upload.mjs <upload_url> --asset <local file> [--name <name>]
//       Uploads one file the artifact keeps by id (an image, a Data file); prints its whole receipt,
//       with its ref. The name's extension sets the file's type; the upload keeps no name.
//   node upload.mjs <upload_url> --file <path> <local file>
//       Writes one file of slides, a design, a design system or a site at <path>; prints its receipt.
//
// On a refusal it prints the service's JSON error and exits 1.
import { existsSync, readFileSync, realpathSync, statSync } from "node:fs";
import path from "node:path";

const USAGE = `Usage:
  node upload.mjs <upload_url> <page.html> [--allow-outside]
  node upload.mjs <upload_url> --asset <local file> [--name <name>]
  node upload.mjs <upload_url> --file <path> <local file>`;
const IMAGE_EXTENSIONS = new Set([".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg"]);
const TARGET_SUFFIX = /\/(?:page_source|asset\/.*|file\/.*)$/;
const NOT_LOCAL = /^(?:[a-zA-Z][a-zA-Z0-9+.-]*:|\/\/|#)/;
const ATTRIBUTE = /(\b(?:src|poster)\s*=\s*)(["'])([\s\S]*?)\2/gi;
const SRCSET = /(\bsrcset\s*=\s*)(["'])([\s\S]*?)\2/gi;
const CSS_URL = /(url\(\s*)(["']?)([^"')]*?)\2(\s*\))/gi;
const ATTEMPTS = 3;
const RETRY_DELAY_MS = 1000;

class Refused extends Error {
  constructor(status, body) {
    super(`${status} ${body}`);
    this.body = body;
  }
}

/** PUTs data, retrying a broken connection: the same file sent again answers the same receipt. */
async function put(url, data) {
  for (let attempt = 0; ; attempt++) {
    let response;
    try {
      response = await fetch(url, { method: "PUT", body: data });
    } catch (error) {
      if (attempt === ATTEMPTS - 1) throw error;
      await new Promise(resolve => setTimeout(resolve, RETRY_DELAY_MS * (1 + attempt)));
      continue;
    }
    const text = await response.text();
    if (!response.ok) throw new Refused(response.status, text);
    return JSON.parse(text);
  }
}

const baseOf = uploadUrl => uploadUrl.replace(/\/+$/, "").replace(TARGET_SUFFIX, "");
const quoted = name => name.split("/").map(encodeURIComponent).join("/");

/** The file a page's reference names on this machine, or null for any other reference. */
function localPath(reference, pageDirectory) {
  const trimmed = reference.trim();
  if (!trimmed || NOT_LOCAL.test(trimmed)) return null;
  const written = trimmed.split("#")[0].split("?")[0];
  return path.resolve(pageDirectory, decodedReference(written));
}

/** A reference with its %-escapes decoded; one whose % is no escape (`50%off.png`) is kept as written, as Python's `unquote` keeps it. */
function decodedReference(reference) {
  try {
    return decodeURIComponent(reference);
  } catch (error) {
    if (error instanceof URIError) return reference;
    throw error;
  }
}

/** The path with its links followed; a file that is not there keeps its name below its nearest real directory. */
function realPath(file) {
  try {
    return realpathSync(file);
  } catch {
    const parent = path.dirname(file);
    return parent === file ? file : path.join(realPath(parent), path.basename(file));
  }
}

/** Whether `file` lies in `directory` once links are followed; a name that only starts with `..` stays inside. */
const isInside = (file, directory) => {
  const relative = path.relative(realPath(directory), realPath(file));
  return relative !== ".." && !relative.startsWith(`..${path.sep}`) && !path.isAbsolute(relative);
};

/** Every image reference the page holds, in order. */
function pageReferences(html) {
  const references = [...html.matchAll(ATTRIBUTE)].map(match => match[3]);
  for (const match of html.matchAll(SRCSET)) {
    for (const candidate of match[3].split(",")) {
      const [url] = candidate.trim().split(/\s+/);
      if (url) references.push(url);
    }
  }
  references.push(...[...html.matchAll(CSS_URL)].map(match => match[3]));
  return references;
}

/** The page with each reference in `refs` replaced by its upload's ref. */
function rewrite(html, refs) {
  const swap = value => refs.get(value) ?? value;
  return html
    .replace(ATTRIBUTE, (_, before, quote, value) => `${before}${quote}${swap(value)}${quote}`)
    .replace(SRCSET, (_, before, quote, value) => {
      const candidates = value.split(",").map(candidate => {
        const [url] = candidate.trim().split(/\s+/);
        return url && refs.has(url) ? candidate.replace(url, refs.get(url)) : candidate;
      });
      return `${before}${quote}${candidates.join(",")}${quote}`;
    })
    .replace(CSS_URL, (_, before, quote, value, after) => `${before}${quote}${swap(value)}${quote}${after}`);
}

/** The page's text, refused unless it is UTF-8 (a byte-order mark is kept, as Python keeps it). */
function pageText(pageFile) {
  try {
    return new TextDecoder("utf-8", { fatal: true, ignoreBOM: true }).decode(readFileSync(pageFile));
  } catch (error) {
    if (!(error instanceof TypeError)) throw error;
    console.error(`${pageFile} is not UTF-8 text`);
    process.exit(1);
  }
}

async function publishPage(uploadUrl, pageFile, allowOutside) {
  const base = baseOf(uploadUrl);
  const html = pageText(pageFile);
  const pageDirectory = path.dirname(path.resolve(pageFile));
  const files = new Map();
  const missing = [];
  const outside = [];
  for (const reference of pageReferences(html)) {
    const file = localPath(reference, pageDirectory);
    if (file === null || files.has(reference)) continue;
    if (!IMAGE_EXTENSIONS.has(path.extname(file).toLowerCase())) {
      console.error(`Left as written, not an image file: ${reference}`);
      continue;
    }
    if (!allowOutside && !isInside(file, pageDirectory)) {
      outside.push(reference);
      continue;
    }
    if (!existsSync(file) || !statSync(file).isFile()) {
      missing.push(reference);
      continue;
    }
    files.set(reference, file);
  }
  if (outside.length) {
    console.error(`The page names images outside its directory: ${outside.join(", ")}; add --allow-outside to send them`);
    process.exit(1);
  }
  if (missing.length) {
    console.error(`The page names images that are not on this machine: ${missing.join(", ")}`);
    process.exit(1);
  }
  const uploads = new Map();
  const refs = new Map();
  for (const [reference, file] of files) {
    if (!uploads.has(file)) {
      const receipt = await put(`${base}/asset/${quoted(path.basename(file))}`, readFileSync(file));
      uploads.set(file, receipt.ref);
    }
    refs.set(reference, uploads.get(file));
  }
  const receipt = await put(`${base}/page_source`, Buffer.from(rewrite(html, refs), "utf8"));
  return { revision: receipt.revision, images: Object.fromEntries(refs), remaining: receipt.remaining };
}

async function main(args) {
  if (args.length >= 3 && args[1] === "--asset") {
    const name = args.length === 5 && args[3] === "--name" ? args[4] : path.basename(args[2]);
    return put(`${baseOf(args[0])}/asset/${quoted(name)}`, readFileSync(args[2]));
  }
  if (args.length === 4 && args[1] === "--file") {
    return put(`${baseOf(args[0])}/file/${quoted(args[2])}`, readFileSync(args[3]));
  }
  const allowOutside = args.length === 3 && args[2] === "--allow-outside";
  if ((args.length === 2 || allowOutside) && !args[1].startsWith("--")) return publishPage(args[0], args[1], allowOutside);
  console.error(USAGE);
  process.exit(1);
}

try {
  console.log(JSON.stringify(await main(process.argv.slice(2)), null, 2));
} catch (error) {
  if (!(error instanceof Refused)) throw error;
  console.error(error.body);
  process.exit(1);
}
