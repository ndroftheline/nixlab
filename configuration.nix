{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./modules/filebrowser.nix
    ./modules/dashboard.nix
    ./modules/caddy.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" "xfs" "ext4" ];

  networking.hostName = "homeserver";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # SSH Access
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Append server-specific settings to the common admin user
  users.users.admin = {
    extraGroups = [ "networkmanager" "shared" ];
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAAC3NzaC1..."
    ];
  };

  # File Sharing Users & Groups
  users.users.household = {
    isNormalUser = true;
    description = "Household Network User";
    extraGroups = [ "shared" ];
    initialPassword = "household";
  };

  users.groups.shared.members = [
    "admin"
    "household"
  ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  system.activationScripts.sharedPermissions = {
    text = ''
      mkdir -p /var/lib/appdata
      mkdir -p /mnt/data
      chown -R root:shared /mnt/data
      chmod -R 775 /mnt/data
      find /mnt/data -type d -exec chmod g+s {} +
    '';
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "Home Server";
        "netbios name" = "homeserver";
      };
      "Data" = {
        "path" = "/mnt/data";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force group" = "shared";
        "valid users" = "household admin";
      };
    };
  };

  services.samba-wsdd = { enable = true; openFirewall = true; };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = { enable = true; addresses = true; domain = true; hinfo = true; userServices = true; workstation = true; };
  };

  # Windows Service Discovery & Multicast DNS
  services.samba-wsdd = { enable = true; openFirewall = true; };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = { enable = true; addresses = true; domain = true; };
  };

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
