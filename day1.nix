{ pkgs, ... }:
  let
    strings = pkgs.lib.strings;
    lists = pkgs.lib.lists;

    input = builtins.readFile ./inputs/day1.txt;
    lines = builtins.filter (line: builtins.isString line && line != "") (strings.splitString "\n" input);
    calibrationValue = line:
      let
        chars = strings.stringToCharacters line;
        onlyDigits = builtins.filter (c: builtins.match "[[:digit:]]" c != null) chars;
        firstDigit = builtins.head onlyDigits;
        lastDigit = lists.last onlyDigits;
        valueAsString = firstDigit + lastDigit;
      in
        strings.toInt valueAsString;
    calibrationValues = map calibrationValue lines;
    sumOfCalibrationVales = builtins.foldl' (acc: x: acc + x) 0 calibrationValues;
  in {
    inherit input;
    solution = pkgs.writeTextFile {
      name = "day1";
      text = "${builtins.toString sumOfCalibrationVales}\n";
    };
  }
