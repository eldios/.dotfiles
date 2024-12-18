{ lib, inputs, config, ... }:
let
  secretspath = builtins.toString inputs.secrets;

  binDir = "/etc/profiles/per-user/eldios/bin";
in
{
  sops = {
    secrets = {
      "keys/peerix/private" = {
        sopsFile = "${secretspath}/lele8845ace.yaml";
      };
      "keys/peerix/public" = {
        sopsFile = "${secretspath}/lele8845ace.yaml";
      };

      "passwords/lele8845ace/eldios" = {
        sopsFile = "${secretspath}/lele8845ace.yaml";
        neededForUsers = true;
      };
    };
  };

  users.users.eldios = {
    hashedPasswordFile = config.sops.secrets."passwords/lele8845ace/eldios".path;

    shell = lib.mkForce "${binDir}/zsh";

    extraGroups = [
      "input" # needed by xRemap
      "uinput" # needed by xRemap
    ];
  };
}

# vim: set ts=2 sw=2 et ai list nu */
