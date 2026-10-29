# HomeLab - Deployment & Operations Manual

This document acts as the definitive operational manual for the homelab appliance.

---

## 1. System Overview

- **Hostname:** `homeserver`
- **OS/Architecture:** NixOS Unstable (Flakes enabled) / x86_64
- **Local FQDN:** `homeserver.local`

### Disk Layout & Storage Topology
This deployment utilizes a declarative hybrid disk management layout via `disko`.

| Drive | Purpose | Filesystem | Managed By | Mount Point |
| :--- | :--- | :--- | :--- | :--- |
| **Boot Drive** | Root OS & Nix Store | BTRFS (Subvolumes) | `disko.nix` | `/`, `/nix`, `/var/lib/appdata` |
| **Data Drives** | Auxiliary Storage | EXT4 / BTRFS | `configuration.nix`| `/mnt/data` |

---

## Initial Deployment Instructions

1. Boot the target hardware from a standard NixOS installation USB.
2. Obtain the target machine's IP address.
3. Obtain the exact `/dev/disk/by-id/` string of the drive you intend to install the OS to.
4. On your local machine, update this repository:
   - Insert the target disk ID into `disko.nix`.
   - Update `configuration.nix` with the target network's static IP scheme, your SSH public keys, and intended local/Tailscale FQDNs in the Caddy block.
5. Deploy over SSH using `nixos-anywhere`:
   ```bash
   nix run github:nix-community/nixos-anywhere -- --flake .#homeserver root@<TARGET-IP>
