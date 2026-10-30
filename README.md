# Homelab - Deployment & Operations Manual

This document acts as the definitive operational manual for the nixlab home server, detailing deployment, day-to-day operations, and infrastructure extensions.

---

## 1. System Overview & Capabilities

- **Hostname:** `homeserver`
- **OS/Architecture:** NixOS Unstable (Flakes enabled) / x86_64
- **Local FQDN:** `homeserver.local`

### Core Capabilities
This declarative home lab is designed to provide robust, containerless infrastructure capable of:
- **Centralized File Management:** Cross-platform file access via SMB for desktop clients and Filebrowser for mobile/remote web access.
- **Declarative Reproducibility:** The entire OS state, packages, and services are defined in a few text files, allowing instant bare-metal disaster recovery without manual reconfiguration.
- **Secure Remote Access:** Native integration with mesh VPN routing allows secure administration and media access from anywhere without port forwarding.
- **AI-Assisted Operations:** Built-in context bundling scripts allow seamless collaboration with Large Language Models (LLMs) to iterate, troubleshoot, and expand the server's capabilities.

### Disk Layout & Storage Topology
This deployment utilizes a declarative hybrid disk management layout via `disko`.

| Drive | Purpose | Filesystem | Managed By | Mount Point |
| :--- | :--- | :--- | :--- | :--- |
| **Boot Drive** | Root OS & Nix Store | BTRFS (Subvolumes) | `disko.nix` | `/`, `/nix`, `/var/lib/appdata` |
| **Data Drives** | Auxiliary Storage | EXT4 / BTRFS | `configuration.nix`| `/mnt/data` |

### Architecture & Modularity
This repository uses a modular design to support multiple deployment targets without duplicating code.

* **`common.nix`**: The baseline "DNA" of your environment (users, CLI tools, Nix settings). This is imported by every machine to ensure a consistent developer experience.
* **`modules/*.nix`**: Self-contained, opt-in services (e.g., Caddy, Filebrowser, Dashboard). These define *what a machine does*.
* **Target Manifests (`configuration.nix`, `wsl.nix`)**: The entry points. They define the hardware/bootloader and import a specific mix of modules.

### WSL Development Environment
The `wsl` target allows you to test new services locally on a Windows machine before pushing them to the bare-metal server. 

Because WSL abstracts networking and shares the Windows kernel, hardware-level services (Samba, Disko, Avahi) only belong in the bare-metal `configuration.nix`. However, web-based services (Caddy, Filebrowser, Dashboard) can be imported into `wsl.nix`, allowing you to safely test HTTP routing and UI changes on `http://localhost` before deploying to production.

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
   ```

---

## Operational Runbooks (Process Docs)

These guides outline the standard operating procedures for extending and managing the server.

### Runbook A: Accessing the Server web UI (Remote & Local)

- **Main Dashboard (Local):** `http://homeserver.local/` 
- **Main Dashboard (Tailscale):** `http://homeserver.tailnet-xyz.ts.net/`
- **Network SMB Share:** `\\homeserver\Data` or `smb://homeserver.local/Data` (Default credentials: `household` / `household`)

---

### Runbook B: Using the Web File Manager (Filebrowser)

While you can access your files locally via the network SMB share, you can also access them from any web browser using Filebrowser. 

**Why this is useful:**
* **Mobile & Tablet Access:** SMB is notoriously unreliable on iOS and Android. Filebrowser provides a sleek, responsive web UI for managing files on mobile devices.
* **Ad-Hoc Sharing:** Allows users to generate temporary sharing links for specific files without giving out system credentials.
* **Remote File Drops:** Allows family members to easily upload photos, documents, or media remotely without configuring VPN clients on their specific devices.
* **In-Browser Previews:** Supports native streaming of video files and previewing of PDFs and images directly in the browser.

**Access Instructions:**
1. Navigate to the **Filebrowser** app from the main dashboard (or go to `http://homeserver.local/files/`).
2. Log in using the administrator credentials:
   * **Username:** `admin`
   * **Password:** is randomly generated, check with journalctl
3. **Important:** Change your password immediately by clicking the Settings (gear) icon in the sidebar, navigating to Global Settings, and updating the admin user profile.

---

### Runbook C: Remote Administration & Mesh VPNs

To securely manage this server and access its services from outside the local network, you should utilize a Mesh VPN rather than opening traditional port forwards on your router.

**Mesh VPN Recommendations:**
* **Tailscale (Pre-configured):** The recommended solution. It requires zero configuration on the router, easily bypasses Carrier-Grade NAT (CGNAT) often used by mobile networks and Starlink, and routes traffic peer-to-peer using Wireguard. 
* **Nebula or Zerotier:** Excellent open-source alternatives if you prefer to host your own lighthouse/coordination nodes without relying on a third-party control plane.

**Development Environment (VS Code):**
Rather than writing configurations in `nano` or `vim` via a standard terminal, use Visual Studio Code for infrastructure-as-code management:
1. Install the **Remote - SSH** extension in VS Code.
2. Connect to the server using `ssh admin@homeserver.local` (or via its Tailscale IP).
3. Open the `/etc/nixos` directory directly in the editor. You will benefit from syntax highlighting, integrated terminal access, and side-by-side file editing.

**Version Control:**
NixOS is fully declarative, meaning the entire system state lives in text files. You should version control these files to track changes and easily revert mistakes.
1. Initialize a git repository in `/etc/nixos`: `git init`
2. Commit functional states: `git commit -am "chore: added filebrowser service"`
3. Push to a secure remote host (such as a self-hosted Gitea instance) to ensure you have an off-site backup of your infrastructure configuration.

---

### Runbook D: LLM-Assisted Operations (Context Bundler)

NixOS can be syntactically complex. This repository includes a `context-bundler.sh` script designed to rapidly package your entire server configuration into an LLM-friendly text prompt.

**How to use the bundler:**
1. From the `/etc/nixos` directory, run `./bundle-context.sh`.
2. The script will generate a `context-bundle.txt` file containing your directory tree and the contents of all your `.nix` and script files.
3. Open `context_bundle.txt`, copy its entire contents, and paste it into Gemini, ChatGPT, or Claude.
4. Append your actual request, such as: *"I want to add a self-hosted password manager (Vaultwarden) to this server. Based on my existing Caddy reverse proxy setup and subvolume architecture, write the NixOS configuration block I need to add."*

Because the LLM sees exactly how your firewall, proxy, and users are configured, it will generate highly accurate, drop-in code rather than generic Docker tutorials.

---

### Runbook E: Adding New Services (Integration Checklist)

When expanding the server with a new service or application, follow this checklist to ensure it is properly routed, secured, and documented within the declarative ecosystem:

1. **Service Declaration**: Define the new application in `configuration.nix` (or an imported module) as a systemd service or NixOS module. Ensure it binds to `127.0.0.1` locally, rather than exposing its port globally, to force traffic through the Caddy proxy.
2. **Permissions**: If the service needs access to shared files, ensure its dedicated service user is added to the `shared` group.
3. **Authentication & Security**: Ensure the service has built-in authentication enabled to prevent unauthorized access.
4. **Caddy Reverse Proxy (Routing)**: To make the service accessible without typing port numbers, add proxy routing rules to the unified Caddy virtual host block in `configuration.nix`:
   * Add a `redir /servicename /servicename/` to cleanly enforce trailing slashes.
   * Add a `handle /servicename* { reverse_proxy 127.0.0.1:PORT }` block to route the traffic.
   *(Note: If the application uses a subpath instead of a subdomain, you must also set the 'URL Base' or 'Subpath' parameter in the application's internal settings).*
5. **Dashboard Integration**: Add a visual card and shortcut link to the native HTML dashboard by updating the `environment.etc."dashboard/index.html".text` block inside `configuration.nix`. Use FontAwesome classes for icons.
6. **Documentation**: Add a brief description of the new service, what it does, and its direct access links to a new Runbook section in this `readme.md`.
