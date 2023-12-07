{ pkgs, ... }:
  rec {
    inherit (pkgs.lib.strings) concatStrings toInt;
    inherit (pkgs.lib.lists) zipListsWith;

    input = builtins.readFile ./inputs/6.txt;
    matches = builtins.match "Time:([[:digit:] ]+)\nDistance:([[:digit:] ]+)\n" input;
    parseNumbers = str:
      let
        matches = builtins.filter (x: builtins.isString x && x != "") (builtins.split " +" str);
      in
        map toInt matches;
    times = parseNumbers (builtins.elemAt matches 0);
    distances = parseNumbers (builtins.elemAt matches 1);
    races = let
      f = raceDurationMs: recordDistanceMm: { inherit raceDurationMs recordDistanceMm; };
    in zipListsWith f times distances;

    abs = x: if x < 0 then - x else x;
    heronsMethod = (x: guess:
      let
        nextGuess = (guess + x / guess) / 2;
      in
      if abs (guess - nextGuess) < 1.0e-6 then nextGuess else heronsMethod x nextGuess
    );
    sqrt = x: heronsMethod x 1.0;

    # distance = (duration - buttonHold) * buttonHold
    # to find intersections with record, solve for buttonHold
    # record = (c - x) * x
    # 0 = (c - x) * x - record
    # 0 = -x^2 + cx - record
    # standard form
    # 0 = -x^2 + bx + -c
    # x = (-b +- sqrt(b^2 - 4ac)) / 2a
    # x = (-b +- sqrt(b^2 - 4c)) / -2, where b is the race duration and c is the record

    # if b = 7 and c = 9,
    # x = (-7 +- sqrt(49 - 36)) / -2
    # x = (-7 +- sqrt(13)) / -2
    # x = 5.3, x = 1.7
    # integral solutions exist where x>= 2 and x <= 5, so the total number of wins in 5 - 2 + 1 = 4
    numberOfPossibleWins = { raceDurationMs, recordDistanceMm }:
      let
        discriminant = sqrt (raceDurationMs * raceDurationMs - 4 * recordDistanceMm);
        maxWinningButtonHoldDuration = (raceDurationMs + discriminant) / 2;
        minWinningButtonHoldDuration = (raceDurationMs - discriminant) / 2;
      in builtins.floor maxWinningButtonHoldDuration - builtins.ceil minWinningButtonHoldDuration + 1;

    numPossibleWinsForEachRace = map numberOfPossibleWins races;
    product = builtins.foldl' (acc: x: acc * x) 1;

    bigRace = let
      concatAsStrings = nums: toInt (concatStrings (map builtins.toString nums));
    in {
      raceDurationMs = concatAsStrings times;
      recordDistanceMm = concatAsStrings distances;
    };
    numPossibleWinsForBigRace = numberOfPossibleWins bigRace;

    solution = pkgs.writeTextFile {
      name = "day6";
      text = "${builtins.toString (product numPossibleWinsForEachRace)}\n${builtins.toString numPossibleWinsForBigRace}\n";
    };
  }
