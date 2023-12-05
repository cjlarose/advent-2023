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
    sumOfCalibrationValues = builtins.foldl' (acc: x: acc + x) 0 calibrationValues;

    suffixesOf = str: let
      chars = strings.stringToCharacters str;
      indexes = lists.range 0 (builtins.length chars - 1);
    in map (i: strings.concatStrings (lists.drop i chars)) indexes;

    numberToken = [
      "1" "2" "3" "4" "5" "6" "7" "8" "9"
      "one" "two" "three" "four" "five" "six" "seven" "eight" "nine"
    ];
    extractNumericPrefix = str:
      let
        matches = map (prefix: if strings.hasPrefix prefix str then prefix else null) numberToken;
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
    lastDigit = str: builtins.head (builtins.filter (x: x != null) (map extractNumericPrefix (lists.reverseList (suffixesOf str))));
    calibrationValue' = str:
      let
        first = intMapping."${firstDigit str}";
        last = intMapping."${lastDigit str}";
      in strings.toInt (strings.concatStrings (map builtins.toString [ first last ]));

    calibrationValues' = map calibrationValue' lines;
    sumOfCalibrationValues' = builtins.foldl' (acc: x: acc + x) 0 calibrationValues';
  in {
    inherit input suffixesOf extractNumericPrefix firstDigit lastDigit calibrationValue' sumOfCalibrationValues';
    solution = pkgs.writeTextFile {
      name = "day1";
      text = "${builtins.toString sumOfCalibrationValues}\n${builtins.toString sumOfCalibrationValues'}\n";
    };
  }
