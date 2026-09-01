# Connexion eduroam — Ecole Centrale Méditerranée (NixOS)

Guide pour connecter un système NixOS au réseau eduroam de l'ECM.

## Problèmes connus sur NixOS

Deux obstacles spécifiques à NixOS empêchent la connexion standard :

1. **`dbus-python` absent** — le script d'installation officiel ne trouve pas le module Python nécessaire pour configurer NetworkManager.
2. **Certificat CA trop faible** — le vieux certificat CA de l'ECM (2013, RSA 1024 bits) est rejeté par OpenSSL 3.x embarqué dans NixOS.

## Script d'installation

Le script `eduroam-linux-ECM.py` est fourni officiellement par l'ECM via le portail [eduroam CAT](https://cat.eduroam.org/). Il est pré-configuré pour l'Ecole Centrale Méditerranée.

## Prérequis

- NetworkManager activé sur le système
- `nix-shell` disponible (inclus dans NixOS)

## Installation

### 1. Lancer le script d'installation dans un environnement Nix

Depuis ce dossier :

```bash
nix-shell
```

Le `shell.nix` fournit automatiquement `dbus-python` et `cryptography`, puis lance le script.

Entrer son identifiant sous la forme `prenom.nom@centrale-med.fr` et son mot de passe ENT.

### 2. Corriger le niveau de sécurité TLS

Le certificat CA de 2013 utilise une clé RSA 1024 bits, considérée trop faible par OpenSSL 3.x. Sans cette correction, la connexion échoue silencieusement.

```bash
sudo nmcli connection modify eduroam 802-1x.openssl-ciphers "DEFAULT@SECLEVEL=0"
```

### 3. Se connecter

```bash
sudo nmcli connection up eduroam
```

## Reconnexion

La connexion est mémorisée par NetworkManager. Pour se reconnecter manuellement :

```bash
nmcli connection up eduroam
```

Ou via l'interface graphique de gestion du réseau.

## Pourquoi `nix-shell` et pas `nix shell` ?

La nouvelle syntaxe `nix shell nixpkgs#python3Packages.dbus-python` ne monte pas correctement le module dans le `PYTHONPATH` de Python. L'ancienne syntaxe `nix-shell` avec `python3.withPackages` fonctionne correctement.
