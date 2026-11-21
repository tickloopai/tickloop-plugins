# Images

This page explains how images reach a Slide, how to place them, and what to do when there is no image. Fonts are on [fonts](fonts.md).

## How images travel

Every image FILE goes into the deck as an Artifact image, uploaded with `ArtifactUpload` or `ArtifactUploadAttachment` (below). The Slide keeps only the `ref` that call returns, `asset:<id>`, written verbatim as the `src`: `<img src="asset:<id>" alt="…">`. The one exception is a design system's picture copied into the deck with its install ([the deck's files](deck-files.md#a-design-system-in-the-deck)): it is not uploaded, and its `src` is its path in the deck, `project/ds/<folder>/<path>`, with no leading `/`. The image data never goes through a Slide: never write a `data:` URI or an external URL in `src`, and never put base64 in a call or a reply.

- `png`, `jpg`, `webp` and `gif` files upload as they are. If a photo is much bigger than it will show, reduce it locally first, for example to a 3840px long edge, and crop a screenshot to the region that matters rather than shrinking a whole screen.
- An `svg` file uploads too, and is shown with `<img>`. A small drawing can go into the Slide as inline `<svg>` code instead, within the [format reference](format.md)'s limits; an SVG illustration too large for that goes in as an uploaded file.
- Any other type: convert it to png or webp first, then upload that.
- If you can't upload, or a file is refused, do not write the image into the Slide yourself. Keep its place with a `div` sized for it that holds a `[__]` caption saying what goes there, list it with the other placeholders, and let the person add the image in the web editor.

Before uploading, reuse the `ref` of an image the deck already shows (its Slide files name it as `asset:<id>`), and use one `ref` on every Slide that shows the same image instead of uploading the file again. Upload only images you will place, since they cannot be removed one at a time.

When you read a Slide's file, its `src` values are Artifact image refs or a design system's picture paths. Keep every `src` exactly as it is when you edit the Slide.

## Uploading

- An image the user attached in the Chat carries a URI after its label, as in `[Attached image #1] URI: "tickloop://attachments/<id>"`: the `ArtifactUploadAttachment` host tool takes that URI as `attachment` with the deck's `artifact_id` and copies the image into the deck server side, so its bytes never pass through you and nothing is saved to a file first.
- A local image file: the `ArtifactUpload` host tool takes `artifact_id` and a local `file_path`, reads the file under the same path rules and approvals as reading a file, and returns only `{asset_id, ref, content_type, bytes, width, height}`, never the image.
- After a timeout either tool recovers its result by operation; if the outcome is still unknown, upload the file once more and use the `ref` that returns.
- Without those tools (an app's MCP client), get an address with `ArtifactUploadTicket` (the deck's `artifact_id`, `files`, `bytes`) and send each image from where it is: `python3 upload.py '<upload_url>' --asset <file>` (or `node upload.mjs`, same arguments) prints its `ref`, as does the ticket's `curl` line; sending the same file again answers the same `ref`, and a file over its limit is refused with `upload_too_large`. The artifact-design Skill's "Files you already hold" gives the details, and the ticket's `scripts` links the scripts when you do not have them.

Each image is PNG, JPEG, GIF, WebP or SVG, at most 5 MiB (2 MiB for SVG), and each deck holds at most 100 images and 100 MiB, beyond which uploads fail with `asset_limit`. Uploading needs edit access.

The upload result does not describe the image: to know what it shows, look at the local file first when you can view images.

## Which images

Use the images the user supplied, the images already in the deck, a chosen design system's pictures, and images the user asked you to find. An image the user attached in the Chat goes onto a Slide with `ArtifactUploadAttachment`, never by saving it to a file first. Without those, build the Slides from type, shapes, diagrams and charts: Slides with no images and a clear structure are a complete deliverable. Fetching an image from the web needs the user's request and a license that allows it; download it to a local file, then upload that file. Never search for, download or generate an image nobody asked for, never make up an image, and never draw your own decorative art or use emoji unless the user asks for it; use icons (`<x-icon>`) sparingly.

## Display treatment

| Image | Fit | Notes |
| --- | --- | --- |
| Photo, texture, full-bleed background | `object-fit: cover` (the default) | Fills the box and crops the overflow; keep faces and subjects inside the box |
| Screenshot, logo, diagram, chart, anything with text | `object-fit: contain` | Shows the whole image; size the box to the image's aspect ratio to avoid empty bands; put it on a contrasting background |

Size the image box from the `width` and `height` the upload returns. `data-crop` holds a zoom and a focal point, as in `data-crop="1.5 50% 30%"`; when a person has cropped an image in the web editor, keep the crop. Write `alt` as what the image shows and why it is on this Slide, not the file name, or `alt=""` for a purely decorative image. Rarely put anything on top of a screenshot or diagram; text that the audience must read belongs in Slide text over or beside the image, as the [layout reference](layout.md) describes. If you put text on top of a photo, protect it the same way every time — a card or a scrim — and keep diagram labels out of the image, as real text over it.

`border`, `border-radius` and `box-shadow` work on an `<img>` as anywhere else; keep shadows soft and rare.

A content Slide with a screenshot beside its explanation, `project/slides/risk-panel.html`: the title keeps its usual top position, the image box has the screenshot's 16:10 aspect ratio, and the footer band stays in place:

```html
<section id="risk-panel" style="gap: 48px; padding: 128px 128px 160px; font-family: 'Inter', sans-serif; color: #f8fafc; background: #0f172a">
  <h2 style="font-size: 72px; line-height: 1.1">Risk is visible at a glance</h2>
  <div style="display: grid; grid-template-columns: 960px 1fr; gap: 64px; align-items: center">
    <img src="asset:dashboard-risk" alt="The portfolio dashboard with the risk panel open beside the holdings list" style="width: 960px; height: 600px; object-fit: contain; border-radius: 16px">
    <p style="font-size: 34px; color: #cbd5e1">Exposure by market and sector updates as positions change.</p>
  </div>
  <div style="position: absolute; left: 128px; right: 128px; bottom: 64px; display: flex; justify-content: space-between; font-size: 24px; color: #cbd5e1">
    <p>Product review</p>
    <p>Screenshot: staging build, [__]</p>
  </div>
</section>
```
