---
name: batocera-onboarding
description: Use when the user says onboard, add, install, copy, or move a game or ROM to the Batocera box, or asks to inspect, configure, or troubleshoot Batocera emulators, BIOS files, ROMs, saves, NAS access, or game listings.
---

# Batocera Onboarding

Use this workflow for Kevin's Batocera box. Access both endpoints through the confirmed passwordless SSH aliases. Do not ask for the Batocera or Synology passwords unless key authentication has been tested and failed.

## Endpoints

- Batocera SSH alias: `batocera`
- Batocera LAN address: `192.168.50.40`
- Batocera version when configured: `43.1`
- Batocera ROM root: `/userdata/roms`
- Batocera BIOS root: `/userdata/bios`
- Batocera saves root: `/userdata/saves`
- Synology SSH alias: `nas`
- NAS ROM root: `/volume1/homes/kevin/Roms`

The Batocera address is currently static enough for the SSH alias but is LAN-only. The NAS alias uses Tailscale. Test both aliases with `BatchMode` before doing any work:

```sh
ssh -o BatchMode=yes -o ConnectTimeout=10 nas 'test -d /volume1/homes/kevin/Roms'
ssh -o BatchMode=yes -o ConnectTimeout=10 batocera 'batocera-version; df -h /userdata'
```

## System Mapping

Most NAS folders match Batocera directly. Apply these confirmed exceptions:

| NAS folder | Batocera folder |
| --- | --- |
| `atarilynx` | `lynx` |
| `sg-1000` | `sg1000` |

Confirmed NAS folders include `atari2600`, `atari7800`, `atarilynx`, `fds`, `gamegear`, `gb`, `gba`, `gbc`, `mastersystem`, `n64`, `nes`, `ngp`, `ngpc`, `pcengine`, `sega32x`, `sg-1000`, and `snes`.

Do not guess mappings for new folders. Compare the NAS folder with `/userdata/roms` and Batocera's `_info.txt`, then ask if still ambiguous.

## Onboarding Workflow

1. Resolve the requested title to exact files on the NAS. Search case-insensitively within the likely system folder. Exclude `.git`. If multiple regions, revisions, hacks, disc formats, or similarly named games match, show the choices and ask before copying.

2. Check Batocera before changing anything:

```sh
ssh batocera 'batocera-es-swissknife --emupid; df -h /userdata'
```

Do not modify ROMs while an emulator is running. Confirm the destination system directory exists. Inspect same-basename files under the destination, `/userdata/saves`, and `/userdata/system` before replacing anything.

3. Compare source size with available Batocera storage. Include companion files required by the format. For cue/bin and multi-disc games, inspect references and transfer the complete set. Never copy a lone `.cue`, `.m3u`, or metadata file without its referenced content.

4. Refuse silent overwrites. If the exact destination exists, compare hashes. Skip when identical; ask before replacing when different.

5. Stream selected files directly from NAS to Batocera. Do not stage ROMs on the Mac and do not store SMB credentials on Batocera:

```sh
ssh nas \
  "tar -C '/volume1/homes/kevin/Roms/<nas-system>' -cf - -- '<exact-file>'" \
| ssh batocera \
  "tar -C '/userdata/roms/<batocera-system>' -xf - && sync"
```

Quote every path and filename. For multiple files, pass each exact filename after `--`. Never interpolate unreviewed command substitutions or wildcard matches into the transfer command.

6. Verify every transferred file with SHA-256 on both endpoints:

```sh
ssh nas "sha256sum '/volume1/homes/kevin/Roms/<nas-system>/<exact-file>'"
ssh batocera "sha256sum '/userdata/roms/<batocera-system>/<exact-file>'"
```

Also verify destination free space and that existing saves remain present.

7. Restart EmulationStation only after successful verification and only when no emulator is active:

```sh
ssh batocera 'batocera-es-swissknife --restart'
```

Report the exact source, destination, hash result, and whether EmulationStation was restarted.

## Emulator And BIOS Rules

- Batocera includes its emulator stack. Do not install emulator packages merely because a new ROM system is added.
- Read the destination system's `_info.txt` and use Batocera's missing-BIOS information before adding BIOS files.
- BIOS files must come from user-controlled storage. Do not download copyrighted BIOS or ROM content.
- Verify BIOS filename and checksum against Batocera's expected values before copying.
- Preserve Batocera's system configuration unless a tested game requires a per-system or per-game override.
- Prefer Batocera defaults first. Make the smallest emulator configuration change that fixes a demonstrated issue.

## Safety

- Copy only titles the user explicitly selected.
- Never delete or archive unrelated Batocera ROMs as part of onboarding.
- Never move, rename, overwrite, or delete saves or save states without explicit approval.
- Never persist personal NAS passwords in skills, shell history, scripts, or Batocera configuration.
- Do not expose private SSH keys or copy them onto either target.
- Stop and ask if game identity, region, revision, destination system, overwrite behavior, or required companion files is ambiguous.
- Do not declare completion until source and destination hashes match.
