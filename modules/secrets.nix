{ config, pkgs, ... }:

{
  # Secrets management - API keys and credentials
  # Keys are loaded from ~/.secrets/ at shell startup

  home.file.".secrets/.gitkeep".text = "";

  # Ensure secrets dir has restricted permissions
  home.activation.secretsPermissions = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.secrets
    chmod 700 $HOME/.secrets
    # Set restrictive perms on all secret files
    find $HOME/.secrets -type f -exec chmod 600 {} \; 2>/dev/null || true
  '';

  # Shell integration - load secrets as env vars
  programs.zsh.initContent = ''
    # Load API keys from secrets
    for f in ~/.secrets/*_api_key ~/.secrets/*-api-key.txt; do
      if [[ -f "$f" ]]; then
        varname=$(basename "$f" | sed 's/[-.]/_/g; s/_txt$//; s/_api_key$//' | tr '[:lower:]' '[:upper:]')
        export "''${varname}_API_KEY"="$(cat "$f")"
      fi
    done
  '';

  # GPG for encryption
  home.packages = with pkgs; [
    gnupg
    age
    pass
  ];

  # Pass password manager
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };
}
