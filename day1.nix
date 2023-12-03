{ pkgs, ... }:
  let
    input = builtins.readFile ./inputs/day1.txt;
  in pkgs.writeTextFile {
    name = "day1";
    text = input;
  }
