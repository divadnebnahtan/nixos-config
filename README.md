# One repository, three NixOS machines

Publish this directory as the root of your new GitHub repository. The v1 archive
contains embedded credentials and should stay out of that repository. You can
also work locally from `v2` within this checkout. No v2 configuration imports v1.
Each device has its own checkout; commit and push changes, then pull and rebuild
on the other devices. One committed `flake.lock` gives them the same package
versions. Rebuilding does not update packages or pull Git changes implicitly.

## Where to edit

| Scope | File |
| --- | --- |
| Laptop and NUC: user, locale, Nix settings | `shared/base.nix` |
| Laptop and NUC: packages | `shared/packages.nix` |
| Laptop or NUC: packages | `hosts/<name>/packages.nix` |
| Laptop: Plasma, display manager and desktop settings | `hosts/laptop/desktop.nix` |
| Laptop or NUC: services | `hosts/<name>/services/` |
| One machine: hardware, settings and imports | `hosts/<name>/default.nix` |
| Disks, encryption, hardware | `hosts/<name>/hardware-configuration.nix` |
| NUC services and their public configuration | `hosts/nuc/` |

For one device, add a package to its `packages.nix`. For both configured devices,
add it to `shared/packages.nix`. Service
modules live under each host's `services/` directory; import a new service module
from that host's `default.nix` (or `services/default.nix` on the NUC). Nix merges
settings across imports. The desktop
is an empty placeholder and does not import the shared base or shared packages.
Use `unstable.packageName` selectively; the default `pkgs` stays on stable 26.05.

There is no Home Manager or Flatpak layer to maintain: the supplied Home Manager
config only set Git identity and a token include. Git is now configured once in
the base. User application preferences remain in your home directory.

## Daily commands

From the flake directory, before the first rebuild use
`bash shared/scripts/nix-config.sh <command>`; afterward `nix-config` is installed.
It finds the configuration from the current directory (including subdirectories),
or from `NIX_CONFIG_DIR=/absolute/path/to/v2` if you prefer running it anywhere.
It recognises `NathanLaptop`, `NathanDesktop` and `NathanNuc`, as well as the
old hostnames `NTop` and `nucthan` for the first migration rebuild.

```sh
nix-config check           # Evaluate this host, including assertions
nix-config build           # Build without activating
nix-config test            # Activate until reboot; no boot entry change
nix-config switch          # Activate and set the next boot generation
nix-config boot            # Apply at next reboot only
nix-config pull            # git pull --ff-only; does not rebuild
nix-config update          # Update the shared lock; does not rebuild
nix-config rollback        # Activate the previous system generation
nix-config build laptop    # Build another host without activating it
```

Edit, `git add` new files, build/test, then commit and push. Git flakes ignore
untracked files; the helper deliberately never stages files for you. On another
device, pull and switch. Finish or commit local changes before pulling. For a
package update, run `update` once, build/test the affected hosts, then commit
`flake.lock` and distribute that commit. Keep the lock in Git; do not regenerate
it independently on each device. A shared change may need builds on multiple
devices, even if you initially test it on only one.

## Laptop migration

The existing hardware file and `system.stateVersion = "25.11"` are preserved.
The hostname changes from `NTop` to `NathanLaptop`. The packages move to 26.05;
this is an OS upgrade, so review the
[release notes](https://nixos.org/manual/nixos/stable/release-notes.html) and back
up your data before activation. Keep a working boot generation.

Clone the repository as Nathan, enter the flake directory, then:

```sh
bash shared/scripts/nix-config.sh build laptop
bash shared/scripts/nix-config.sh test laptop
bash shared/scripts/nix-config.sh switch laptop
```

Passwords remain on the existing machine; none are embedded in Git. Tailscale
uses its existing authentication state, or `sudo tailscale up` if needed. DNS now
uses systemd-resolved rather than hardcoded tailnet DNS. The broken global PATH
override is removed; configure development tools in project shells as needed.
Waydroid and Steam remain laptop-only through the selected modules; obsolete
Chromium is removed. Tail-tray is installed but no longer forced into autostart.

Syncthing is now a service running as Nathan, with its config in
`~/.local/state/syncthing`. Before first activation, stop any manually launched
or user-service instance and verify its config directory (`syncthing paths`). If
it differs, change `configDir` in `hosts/laptop/services/syncthing.nix` to the existing location or migrate
the config including its identity keys. Otherwise a new identity may be created.
Existing folder/device settings are left GUI-managed; the GUI stays on loopback.

## NUC migration

All seven server modules are included under `hosts/nuc/services/`. The hostname
changes from `nucthan` to `NathanNuc`; hardware, state version `26.05`, service users, media groups,
data paths, SSH public keys, Syncthing folders/devices, Tailscale routing and
existing firewall rules are preserved. Application state stays on the server.

Two credentials previously embedded in v1 now come from runtime files. Before
first activation, create these files **on the server**, outside the checkout:

| File | Contents | Owner and mode |
| --- | --- | --- |
| `/var/lib/secrets/now-playing.env` | `NAVIDROME_PASSWORD=` followed by the existing Now Playing password (use systemd EnvironmentFile quoting when needed) | `root:root`, `0600` |
| `/var/lib/secrets/qbittorrent-password` | The existing qBittorrent `@ByteArray(...)` password hash, one line | `root:root`, `0600` |

Use a root editor to populate them; do not put credentials into shell history.
qBittorrent receives its hash via systemd LoadCredential and inserts it after
NixOS generates its configuration. Now Playing reads its password through
EnvironmentFile. Missing files cause those services to fail to start, rather
than silently choosing another password. Rotate the old embedded credentials
if v1 has ever been published or shared. Do not publish v1 alongside v2 without
removing its credentials from the repository and any Git history first.

These existing runtime files must also remain available:

- `/var/lib/secrets/navidrome.env`: existing Navidrome environment settings.
- `/var/lib/secrets/radarr-api-key` and `/var/lib/secrets/sonarr-api-key`:
  existing API keys, readable by the Recyclarr service.

Back up databases and service data before activation. Keep the old checkout for
rollback and replace any external scripts that still assume its path. The old
home-level GitHub token include is not copied; if needed, configure an on-device
Nix token file outside Git.

From the flake directory on the server:

```sh
bash shared/scripts/nix-config.sh build nuc
bash shared/scripts/nix-config.sh test nuc
# Verify services and a second SSH connection before making it persistent.
bash shared/scripts/nix-config.sh switch nuc
```

SSH remains key-only and its firewall port stays closed outside the trusted
Tailscale interface. Other service exposure follows v1, including Immich's open
TCP port 2283 and Syncthing's default sync ports. The Syncthing GUI still listens
on all addresses at port 8384, with access governed by the existing firewall.
The Tailscale server continues advertising `192.168.0.0/24` and exit-node support;
retain the existing authentication and tailnet route approval.
Check SSH aliases, DNS records, Tailscale device naming and any other references
to the old hostname when migrating. The helper accepts both old and new names.

## Desktop installation

The desktop currently contains only its intended hostname, state version and a
hardware placeholder. It imports neither the common settings nor any personal
packages or services. It is not ready to install: when planning the installation,
generate its hardware file and configure a bootloader, user, networking and any
desired packages and services. You can then opt into the shared base and packages
in `flake.nix` if desired. Set `system.stateVersion` to the release used for the
desktop's first installation, and keep it unchanged during routine updates.

## Verification and recovery

`nix-config check` evaluates a host; `build` also builds its system closure.
The desktop check fails deliberately until its hardware configuration is generated.
Use the boot menu's previous generation if a new configuration will not boot.
Rollback restores system configuration, not application databases or user data.
Keep database backups independent of Git and Nix generations.

References: [NixOS manual](https://nixos.org/manual/nixos/stable/),
[flake lock updates](https://nix.dev/manual/nix/2.22/command-ref/new-cli/nix3-flake-update).
