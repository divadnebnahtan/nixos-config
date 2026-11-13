#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo 'Usage: nix-config {build|test|boot|switch|check|update|pull|rollback} [laptop|desktop|nuc]'
  echo 'Run from anywhere inside this checkout, or set NIX_CONFIG_DIR to its v2 directory.'
}

command=${1:-help}
host=${2:-}
if [[ $# -gt 2 ]]; then usage >&2; exit 2; fi
if [[ $command == help || $command == --help || $command == -h ]]; then usage; exit 0; fi
case "$command" in
  build|test|boot|switch|check|update|pull|rollback) ;;
  *) usage >&2; exit 2 ;;
esac

# Find the flake without assuming the checkout lives in /etc/nixos.
repo=${NIX_CONFIG_DIR:-$PWD}
repo=$(realpath "$repo")
while [[ ! -f "$repo/flake.nix" ]]; do
  if [[ -f "$repo/v2/flake.nix" ]]; then repo="$repo/v2"; break; fi
  if [[ $repo == / ]]; then echo 'Cannot find v2/flake.nix; set NIX_CONFIG_DIR.' >&2; exit 1; fi
  repo=$(dirname "$repo")
done
cd "$repo"

machine=$(hostname)
machine=${machine,,}
if [[ -z $host ]]; then
  case "$machine" in
    nathanlaptop|ntop|laptop) host=laptop ;;
    nathannuc|nucthan) host=nuc ;;
    nathandesktop|desktop) host=desktop ;;
    *) echo 'Unknown machine; specify laptop, desktop or nuc.' >&2; exit 2 ;;
  esac
fi
case "$host" in laptop|desktop|nuc) ;; *) usage >&2; exit 2 ;; esac

case "$command" in
  pull)
    git pull --ff-only
    ;;
  update)
    nix flake update
    echo 'Lock updated. Build/test before committing flake.lock and pushing.'
    ;;
  check)
    nix eval --no-update-lock-file --raw ".#nixosConfigurations.$host.config.system.build.toplevel.drvPath"
    echo
    ;;
  rollback)
    sudo nixos-rebuild switch --rollback
    ;;
  build|test|boot|switch)
    if [[ $command != build ]]; then
      case "$machine:$host" in
        nathanlaptop:laptop|ntop:laptop|laptop:laptop|nathannuc:nuc|nucthan:nuc|nathandesktop:desktop|desktop:desktop) ;;
        *) echo 'Refusing to activate another machine configuration. Use build, or nixos-install for a fresh install.' >&2; exit 1 ;;
      esac
    fi
    # Never stage files, pull, or change the lock implicitly.
    if [[ $command == build ]]; then
      nixos-rebuild build --flake ".#$host" --no-update-lock-file
    else
      sudo nixos-rebuild "$command" --flake ".#$host" --no-update-lock-file
    fi
    ;;
esac
