{ pkgs }:
let
  marge = pkgs.callPackage ./marge.nix {};
  version = marge.version;
  basicShadow =
    # minimal user setup, so ssh won't whine 'No user exists for uid 0'
    pkgs.runCommand "basic-shadow-setup" {}
      ''
        mkdir -p $out
        cd $out
        mkdir -p root/.ssh
        mkdir -p etc/pam.d
        echo "root:x:0:0::/root:/bin/sh" >etc/passwd
        echo "root:!x:::::::" >etc/shadow
        echo "root:x:0:" >etc/group
        echo "root:x::" >etc/gshadow
        cat >etc/pam.d/other <<\EOF
        account sufficient pam_unix.so
        auth sufficient pam_rootok.so
        password requisite pam_unix.so nullok sha512
        session required pam_unix.so
        EOF
      '';
in
  pkgs.dockerTools.buildImage {
    name = "docker.pkg.github.com/detecttechnologies/marge-bot/docker-marge";
    tag = "${version}";
    contents =
      with pkgs; [
        basicShadow
        busybox
        gitMinimal
        openssh
      ] ++ [ marge ];
    config = {
      Entrypoint = [ "/bin/marge.app" ];
      Env = ["LANG=en_US.UTF-8" ''LOCALE_ARCHIVE=/lib/locale/locale-archive''];
    };
  }
