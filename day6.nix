{ pkgs, ... }:
  rec {
    strings = pkgs.lib.strings;
    lists = pkgs.lib.lists;

    input = builtins.readFile ./inputs/6.txt;
    matches = builtins.match "Time:([[:digit:] ]+)\nDistance:([[:digit:] ]+)\n" input;
    parseNumbers = str:
      let
        matches = builtins.filter (x: builtins.isString x && x != "") (builtins.split " +" str);
      in
        map strings.toInt matches;
    times = parseNumbers (builtins.elemAt matches 0);
    distances = parseNumbers (builtins.elemAt matches 1);

    totalDistanceMm = raceDurationMs: buttonHoldMs: 
      let
        movingMs = raceDurationMs - buttonHoldMs;
        speedMmPerMs = buttonHoldMs;
      in
        movingMs * speedMmPerMs;

    possibleDistances = raceDurationMs:
      map (totalDistanceMm raceDurationMs) (lists.range 0 raceDurationMs);

    numberOfPossibleWins = raceDurationMs: recordDistanceMm:
      builtins.length (builtins.filter (x: x > recordDistanceMm) (possibleDistances raceDurationMs));

    races = lists.zipListsWith (raceDurationMs: recordDistanceMm: { inherit raceDurationMs recordDistanceMm; }) times distances;
    numPossibleWinsForEachRace = map ({ raceDurationMs, recordDistanceMm }: numberOfPossibleWins raceDurationMs recordDistanceMm) races;
    product = builtins.foldl' (acc: x: acc * x) 1;

    solution = pkgs.writeTextFile {
      name = "day6";
      text = "${builtins.toString (product numPossibleWinsForEachRace)}\n";
    };
  }
