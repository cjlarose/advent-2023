#!/usr/bin/env bash

main() {
  day=$1
  outpath=$(nix build ".#day${day}.solution" --print-out-paths)
  mkdir -p outputs
  rm -f "outputs/${day}.txt"
  cp "$outpath" "outputs/${day}.txt"
  echo "$(< "outputs/${day}.txt")"
}

main "$@"
