{ pkgs, ... }:
  let
    inherit (pkgs.lib.strings) concatStrings hasPrefix splitString stringToCharacters toInt;
    inherit (pkgs.lib.lists) drop last range reverseList;
  in rec {
    input = builtins.readFile ./inputs/1.txt;
    lines = builtins.filter (line: builtins.isString line && line != "") (splitString "\n" input);

    calibrationValue = line:
      let
        chars = stringToCharacters line;
        onlyDigits = builtins.filter (c: builtins.match "[[:digit:]]" c != null) chars;
        firstDigit = builtins.head onlyDigits;
        lastDigit = last onlyDigits;
        valueAsString = firstDigit + lastDigit;
      in
        toInt valueAsString;
    calibrationValues = map calibrationValue lines;
    sumOfCalibrationValues = builtins.foldl' (acc: x: acc + x) 0 calibrationValues;

    suffixesOf = str: let
      chars = stringToCharacters str;
      indexes = range 0 (builtins.length chars - 1);
    in map (i: concatStrings (drop i chars)) indexes;

    numberToken = builtins.attrNames intMapping;
    extractNumericPrefix = str:
      let
        matches = map (prefix: if hasPrefix prefix str then prefix else null) numberToken;
        nonNullMatches = builtins.filter (x: x != null) matches;
      in
        if nonNullMatches == [] then null else builtins.head nonNullMatches;

    intMapping = {
      "1" = 1;
      "2" = 2;
      "3" = 3;
      "4" = 4;
      "5" = 5;
      "6" = 6;
      "7" = 7;
      "8" = 8;
      "9" = 9;

      one = 1;
      two = 2;
      three = 3;
      four = 4;
      five = 5;
      six = 6;
      seven = 7;
      eight = 8;
      nine = 9;
    };
    firstDigit = str: builtins.head (builtins.filter (x: x != null) (map extractNumericPrefix (suffixesOf str)));
    lastDigit = str: builtins.head (builtins.filter (x: x != null) (map extractNumericPrefix (reverseList (suffixesOf str))));
    calibrationValue' = str:
      let
        first = intMapping."${firstDigit str}";
        last = intMapping."${lastDigit str}";
      in toInt (concatStrings (map builtins.toString [ first last ]));

    calibrationValues' = map calibrationValue' lines;
    sumOfCalibrationValues' = builtins.foldl' (acc: x: acc + x) 0 calibrationValues';
    solution = pkgs.writeTextFile {
      name = "day1";
      text = "${builtins.toString sumOfCalibrationValues}\n${builtins.toString sumOfCalibrationValues'}\n";
    };
  }
