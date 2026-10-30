{ config, pkgs, ... }:

{
  imports = [
  ./common.nix
  ./modules/filebrowser.nix
  ./modules/dashboard.nix
  ./modules/caddy.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "admin";
    # Optionally enable integration with Windows apps and Docker Desktop
    # startMenuLaunchers = true;
    # docker-desktop.enable = true;
  };

  # DO NOT enable NetworkManager, systemd-boot, or Disko here.
  
  system.stateVersion = "25.11";
}