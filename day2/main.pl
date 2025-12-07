file_to_ranges(Path, Ranges) :-
    read_file_to_string(Path, S, []),
    split_string(S, ",", ",", Ranges).

range_to_tuple(Range, Start-End) :-
    split_string(Range, "-", "\n", [Start0|[End0]]),
    number_string(Start, Start0),
    number_string(End, End0).

is_even(N) :- integer(N), mod(N, 2) =:= 0.

main :-
    file_to_ranges("data.txt", Ranges),
    maplist(range_to_tuple, Ranges, Tuples),

    % Part 1
    maplist(find_invalids_part1, Tuples, InvalidsPart1Unflattened),
    flatten(InvalidsPart1Unflattened, InvalidsPart1),
    sumlist(InvalidsPart1, Part1Sum),
    write("Part 1: "),
    writeln(Part1Sum),

    % Part 2
    maplist(find_invalids_part2, Tuples, InvalidsPart2Unflattened),
    flatten(InvalidsPart2Unflattened, InvalidsPart2),
    sumlist(InvalidsPart2, Part2Sum),
    write("Part 2: "),
    writeln(Part2Sum).

% Part 1

find_invalids_part1(Start-End, Invalids) :-
    numlist(Start, End, Numbers),
    include(is_invalid_part1, Numbers, Invalids).

is_invalid_part1(Number) :-
    number_string(Number, String),
    string_length(String, Len),
    (is_even(Len) ->
        Len2 is Len / 2,
        sub_string(String, 0, Len2, _, Start),
        sub_string(String, Len2, Len2, _, End),
        Start = End
    ; false).

% Part 2

find_invalids_part2(Start-End, Invalids) :-
    numlist(Start, End, Numbers),
    include(is_invalid_part2, Numbers, Invalids).

is_invalid_part2(Number) :-
    number_string(Number, String),
    string_length(String, FullLength),
    SubLenMax is floor(FullLength / 2),
    numlist(1, SubLenMax, Lengths),
    maplist(generate_substrings(String), Lengths, Subs),
    include(is_made_of_subs(String), Subs, Results),
    length(Results, L),
    L > 0.

generate_substrings(S, Len, Sub) :- sub_string(S, 0, Len, _, Sub).

% don't want to try to do this smartly, let's just check a bunch
is_made_of_subs(String, Sub) :-
    string_concat(Sub, Sub, Twice),
    string_concat(Twice, Sub, Thrice),
    string_concat(Thrice, Sub, FourTimes),
    string_concat(FourTimes, Sub, FiveTimes),
    string_concat(FiveTimes, Sub, SixTimes),
    string_concat(SixTimes, Sub, SevenTimes),
    (
    String = Twice;
    String = Thrice;
    String = FourTimes;
    String = FiveTimes;
    String = SixTimes;
    String = SevenTimes
    ).
