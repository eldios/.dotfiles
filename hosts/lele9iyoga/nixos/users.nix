{ inputs, config, ... }:
let
  secretspath = builtins.toString inputs.secrets;
in
{
  sops.secrets = {
    "passwords/lele9iyoga/eldios" = {
      sopsFile = "${secretspath}/lele9iyoga.yaml";
      neededForUsers = true;
    };
  };

  users.users.eldios = {
    hashedPasswordFile = config.sops.secrets."passwords/lele9iyoga/eldios".path;

    extraGroups = [
      "input" # needed by xRemap
      "uinput" # needed by xRemap
    ];
  };
}

# vim: set ts=2 sw=2 et ai list nu */