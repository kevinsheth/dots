---
name: muos-emulator
description: Use when managing the muOS emulator handheld, rotating games, copying or archiving ROMs, preserving emulator saves, or troubleshooting access to muos-8e1cd2 over Tailscale.
---

# muOS Emulator

Use this workflow for Kevin's muOS handheld. Prefer confirmed commands and paths over researching the generic muOS layout again.

## Device And Sources

- Tailscale hostname: `muos-8e1cd2`
- Tailscale IP: `100.74.195.20`
- NAS ROM library: `/volume1/homes/kevin/Roms`
- Primary ROM storage: `/mnt/mmc/ROMS`
- Hidden archive root: `/mnt/mmc/ARCHIVE`
- muOS data root: `/mnt/mmc/MUOS`
- SD2 mount: `/mnt/sdcard` (it was empty when last inspected)
- GBA content directory: `/mnt/mmc/ROMS/Nintendo Game Boy Advance`
- GBA core in prior use: `mGBA`
- Battery saves: `/mnt/mmc/MUOS/save/file/mGBA`
- Save states: `/mnt/mmc/MUOS/save/state/mGBA`

Do not assume the LAN address is stable. It was `192.168.50.253` when confirmed, but use it only as a fallback after checking current Tailscale access.

## Access

Use Tailscale SSH as the primary path:

```sh
tailscale status
tailscale ping --timeout=5s muos-8e1cd2
tailscale ssh root@100.74.195.20 'id; hostname'
```

The tailnet uses Tailscale SSH browser checks. If the command prints an additional-authentication URL, immediately ask the user to open that exact URL and wait for confirmation, then retry. Do not conclude that muOS SSH is disabled.

Ordinary `ssh root@100.74.195.20` and SFTP/FileBrowser ports can time out because tailnet policy does not grant ordinary TCP access. This does not indicate a handheld-side fault. `tailscale ssh` is confirmed working with `RunSSH: true`.

Inside a Tailscale SSH session, the device's Tailscale binaries are not on `PATH`. Use:

```sh
/opt/muos/bin/tailscale status
/opt/muos/bin/tailscale debug prefs
```

Confirmed local services are:

- SSH: port `22`, account `root`
- SFTPGo: port `2022`, account `muos`
- FileBrowser: port `9090`, account `muos`

Do not persist default passwords in repository files or permanent helper scripts. If Tailscale SSH is unavailable and both machines are on the same LAN, discover the current peer endpoint from `tailscale ping` or `tailscale status`, then use LAN SSH as a temporary fallback.

## Tailscale Transfers

Because ordinary SCP over the Tailscale IP may be blocked, stream a tar archive through `tailscale ssh`. This safely handles filenames containing spaces and punctuation:

```sh
tar -C /volume1/homes/kevin/Roms/gba -cf - -- \
  'Game One (USA).gba' \
  'Game Two (USA).gba' \
| tailscale ssh root@100.74.195.20 \
  'tar -C "/mnt/mmc/ROMS/Nintendo Game Boy Advance" -xf - && sync'
```

Create and validate the destination directory before streaming. Keep source paths and remote destination paths quoted.

## Rotation Workflow

1. Confirm the device is reachable and no emulator is active:

```sh
tailscale ssh root@100.74.195.20 \
  'df -h /mnt/mmc; pgrep -a retroarch || true; find /mnt/mmc/ROMS -type f ! -path "*/.git/*" -print'
```

2. Locate every requested source ROM with exact filenames. Resolve revisions and regions with the user when multiple legitimate releases exist.

3. Inspect matching battery saves and states before changing ROMs. RetroArch associates saves with the ROM basename. A ROM named `Sonic Advance (USA) (En,Ja).gba` does not automatically use `Sonic Advance.srm`.

4. If an old save exists for a returning game, ask whether to resume it or start fresh:

- Resume: install the ROM with a basename matching the existing save.
- Fresh: keep the source-library filename and leave the old save untouched.

5. Create a dated archive outside `/ROMS`, preserving system directories:

```text
/mnt/mmc/ARCHIVE/ROMS-YYYY-MM-DD/<system>/
```

6. Move only current game files into the archive. Never move, rename, overwrite, or delete anything under `/mnt/mmc/MUOS/save` unless explicitly requested. Preserve `.git` and unrelated metadata in `/ROMS`.

7. Upload the requested ROMs into their correct system directory. Run `sync` afterward.

8. Verify all outcomes:

- Only the requested game files remain under the visible `/ROMS` tree.
- Every old ROM appears under the dated archive.
- Remote SHA-256 values equal source-library SHA-256 values.
- Relevant battery saves and save states still exist.
- Available storage remains healthy.

9. If the handheld UI was already showing content, use muOS Content Refresh (`SELECT` in Explore Content) after the filesystem work.

## Safety

- Never delete ROMs as part of a rotation; archive them outside `/ROMS`.
- Never treat moving a ROM as preserving a save unless the separate save directories have been checked.
- Do not alter saves just to make a new rotation work without asking about resume-versus-fresh behavior.
- Do not operate while RetroArch is active.
- Use a new dated archive path rather than merging rotations ambiguously.
- Hash transferred ROMs before declaring success.
