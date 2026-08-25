---
name: retroid-pocket-classic
description: Use when managing the Retroid Pocket Classic, transferring or archiving ROMs, diagnosing ES-DE game listings, preserving emulator saves, or troubleshooting Retroid access over Tailscale, SSH, or ADB.
---

# Retroid Pocket Classic

Use the confirmed passwordless SimpleSSHD connection for routine work. Do not ask Kevin to pair wireless ADB unless SSH is unavailable and repairing the SSH installation genuinely requires ADB.

## Device And Sources

- Tailscale hostname: `retroid-pocket-classic`
- Tailscale IP: `100.116.136.38`
- Confirmed LAN IP on 2026-08-21: `192.168.50.128` (dynamic; do not assume it remains stable)
- NAS ROM library: `/volume1/homes/kevin/Roms`
- SD-card root: `/storage/FA7F-9A46`
- Active ROM root: `/storage/FA7F-9A46/ROMs`
- ROM archive root: `/storage/FA7F-9A46/ROM-Archive`
- ES-DE data: `/storage/emulated/0/ES-DE`
- RetroArch data and saves: `/storage/emulated/0/RetroArch`
- ES-DE package: `org.es_de.frontend`
- RetroArch package: `com.retroarch.aarch64`

The SD-card UUID can change after reformatting or replacing the card. If the confirmed path is absent, inspect `/storage` and update commands rather than recreating the old UUID path.

## Primary Access

The NAS runs Tailscale in userspace mode (`TUN: false`), so direct TCP connections to the `100.x` address time out. Always route SSH and SCP through `tailscale nc`.

- SimpleSSHD package: `org.galexander.sshd`
- SSH port: `2222`
- SSH username: `user` (SimpleSSHD accepts arbitrary usernames)
- Private key: `/volume1/homes/kevin/.ssh/retroid_pocket_classic`
- SimpleSSHD home: `/storage/FA7F-9A46`
- SimpleSSHD is configured for foreground operation and start on boot.
- SimpleSSHD and Tailscale are exempted from Android device-idle restrictions.

Check reachability and connect:

```sh
tailscale ping --timeout=5s retroid-pocket-classic
ssh \
  -i /volume1/homes/kevin/.ssh/retroid_pocket_classic \
  -o IdentitiesOnly=yes \
  -o 'ProxyCommand=tailscale nc %h %p' \
  -p 2222 user@100.116.136.38 \
  'id; pwd; ls -la ROMs'
```

Transfer a ROM through Tailscale:

```sh
scp \
  -i /volume1/homes/kevin/.ssh/retroid_pocket_classic \
  -o IdentitiesOnly=yes \
  -o 'ProxyCommand=tailscale nc %h %p' \
  -P 2222 -- \
  '/volume1/homes/kevin/Roms/snes/Game (USA).sfc' \
  'user@100.116.136.38:ROMs/snes/'
```

If Tailscale is temporarily unavailable but the Retroid and NAS are on the same LAN, discover the current address and use direct SSH on port `2222`:

```sh
avahi-browse -art
ssh -i /volume1/homes/kevin/.ssh/retroid_pocket_classic \
  -o IdentitiesOnly=yes -p 2222 user@192.168.50.128
```

## ROM Workflow

1. Confirm no game is running before moving ROMs. SimpleSSHD cannot inspect other apps' private data, but it can inspect shared storage. If ADB is already connected, use `adb shell pidof com.retroarch.aarch64`.
2. Locate exact source ROMs and resolve region or revision ambiguity before transferring.
3. Check for saves and states under `/storage/emulated/0/RetroArch/saves` and `/storage/emulated/0/RetroArch/states`. Never move, rename, overwrite, or delete saves unless explicitly requested.
4. Archive removed ROMs by system under `ROM-Archive/<system>/`; do not delete them.
5. Copy requested ROMs to `ROMs/<ES-DE system>/`.
6. Compare source and device hashes before declaring success.
7. Restart ES-DE or use its reload-game-list action so its in-memory list reflects filesystem changes. Missing entries are skipped on the next scan.

Example remote verification:

```sh
ssh \
  -i /volume1/homes/kevin/.ssh/retroid_pocket_classic \
  -o IdentitiesOnly=yes \
  -o 'ProxyCommand=tailscale nc %h %p' \
  -p 2222 user@100.116.136.38 \
  'md5sum "ROMs/snes/Game (USA).sfc"'
```

## ES-DE Listings

ES-DE scans the files under `ROMs` and stores metadata in:

- Gamelists: `/storage/emulated/0/ES-DE/gamelists/<system>/gamelist.xml`
- Downloaded artwork: `/storage/emulated/0/ES-DE/downloaded_media/<system>`
- Logs: `/storage/emulated/0/ES-DE/logs/es_log.txt`

When a supposedly removed game still appears, search the active ROM root first. A gamelist entry or artwork alone does not make a game load when `ParseGamelistOnly` is false; a ROM left in the active directory does. Preserve downloaded media unless the user explicitly asks to remove it.

## ADB Recovery Only

Wireless ADB is a recovery path, not the normal transfer method. The NAS ADB key is persistent at `/volume1/homes/kevin/.android/adbkey`, but the Retroid has repeatedly dropped Android's pairing authorization.

Discover the changing ADB connect port on the LAN:

```sh
avahi-browse -art
adb connect <lan-ip>:<advertised-_adb-tls-connect-port>
```

If authorization is gone, the user must briefly open **Developer options > Wireless debugging > Pair device with pairing code** and provide the pairing port and code:

```sh
adb pair <lan-ip>:<pairing-port> <six-digit-code>
adb connect <lan-ip>:<connect-port>
```

After ADB recovery, restore SimpleSSHD rather than relying on repeated pairing. Version 27 is available from:

`https://f-droid.org/repo/org.galexander.sshd_27.apk`

SimpleSSHD's private `authorized_keys` must contain the public key from `/volume1/homes/kevin/.ssh/retroid_pocket_classic.pub`. Its preference `onboot` should remain `true`, and port `2222` must be listening.

## Safety

- Never delete ROMs as part of normal rotation; archive them outside `ROMs`.
- Never treat ROM metadata or artwork as the ROM itself.
- Never modify RetroArch saves merely to make a rotation work.
- Avoid ADB pairing when passwordless SSH is reachable.
- Do not expose or replace the private SSH key.
- Verify remote hashes and final active/archive paths after every transfer.
