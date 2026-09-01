{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (ps: [
      ps.dbus-python
      ps.cryptography
    ]))
  ];

  shellHook = ''
    python3 eduroam-linux-ECM.py
  '';
}
