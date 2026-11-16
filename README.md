# Front Row Seat

Watch a video from the front row of a giant 1.43:1 screen (IMAX 70mm size), with real seat
geometry, sightline angles, and VR support.

**Live:** https://dglsconklin.github.io/front-row-seat/

It opens on a clip, muted (browsers don't allow sound until you interact). Click or tap anywhere
for sound. Drag to look around; the Seat & view panel changes the theater, row, seat and lens.

Pick the opening video with the address:
- `?v=<YouTube id>`, for example `https://dglsconklin.github.io/front-row-seat/?v=99Ptctl5_qQ`
- `?link=<any supported link>`, URL-encoded

## Getting video onto the screen

| Source | How | Curved screen, room glow, photos | VR |
|---|---|---|---|
| Video file | Load video, or drag a file onto the page | yes | yes |
| YouTube, Twitch, Vimeo | Paste link, or Ctrl+V anywhere | no: the screen goes flat, and the player can't be read or photographed | no |
| Direct .mp4 / .webm / .m3u8 stream | Paste link (the host must allow CORS) | yes | yes |
| Any tab (YouTube, etc.) | Share a tab (desktop Chrome / Edge / Firefox) | yes | PC VR only |

YouTube, Twitch and Vimeo run their own player inside the page, placed in 3D with CSS so it lines
up with the screen. Browsers don't let a page read pixels from another site's player, so the
screen can't curve, light the room, or show up in photos or VR. For all of that, use Share a tab.

## VR

Open the live link in a headset browser (for example Meta Quest Browser) and press Enter VR.
Trigger plays and pauses; the thumbstick changes rows and seats. Use a video file, since the
YouTube player can't be drawn inside VR.

## Working on it

`page.html` is the source. `index.html` is built from it and is what the site serves.

- Run locally: double-click `play.cmd` (serves http://localhost:8765/ and rebuilds `index.html`
  on every page load).
- Publish: run `play.cmd` once so `index.html` is current, then commit and push both files.
