#!/usr/bin/env bash

main() {
  day=$1
  outpath=$(nix build ".#day${day}.solution" --print-out-paths)
  mkdir -p outputs
  cp "$outpath" "outputs/${day}.txt"
}

main "$@"
