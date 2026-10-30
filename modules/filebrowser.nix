{ config, pkgs, ... }:

{
  # Ensure the directory exists
  system.activationScripts.filebrowserDir = {
    text = "mkdir -p /mnt/data";
  };

  services.filebrowser = {
    enable = true;
    settings = {
      address = "127.0.0.1";
      port = 8080;
      root = "/mnt/data"; 
      baseurl = "/files";
      # Store the database in a standard location
      database = "/var/lib/filebrowser.db";
    };
  };
}