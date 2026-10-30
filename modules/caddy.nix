{ config, pkgs, ... }:

{
  # ---------------------------------------------------------
  # CADDY REVERSE PROXY (Multi-Host Routing)
  # ---------------------------------------------------------
  services.caddy = {
    enable = true;
    virtualHosts = {
      # TODO: Update with the target household's local FQDN, static IP, and Tailscale FQDN
      "http://homeserver.local, http://192.168.1.10, http://homeserver.tailnet-xyz.ts.net, http://localhost, http://127.0.0.1".extraConfig = ''
        redir /manual /manual/
        redir /files /files/     # <--- Example: Redirect to trailing slash

        # Intercept the README query and dynamically serve the live file on the disk
        handle /manual/README.md {
            root * /etc/nixos
            rewrite * /readme.md
            file_server
        }

        # Example Service: Route traffic to the Filebrowser backend
        handle /files* {
            reverse_proxy 127.0.0.1:8080
        }

        # Catch-all fallthrough serves the native dashboard & manual assets
        handle {
            root * /etc/dashboard
            file_server
        }
      ''; 
    }; 
  };

  # Ensure the web ports are open
  networking.firewall.allowedTCPPorts = [ 80 443 ];

};