{ config, pkgs, ... }:

{
  # Core user profile for you (the administrator)
  users.users.admin = {
    isNormalUser = true;
    # Extra groups like "networkmanager" or "shared" belong in the server config, 
    # not here, since they don't exist/apply in WSL.
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
  };

  # CLI Tools you expect to have everywhere
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    tmux
    wget
  ];

  # Enables VS Code Remote Server execution natively
  programs.nix-ld.enable = true;

  # Enable Flakes globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Keep state version synced across all targets
  system.stateVersion = "25.11";
}