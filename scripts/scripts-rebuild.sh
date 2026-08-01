#!/usr/bin/env bash

cd ~/nixos-config

git add .
sudo nixos-rebuild switch --flake .#nucthan