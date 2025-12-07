file_to_lines(Path, Lines) :-
    read_file_to_string(Path, S, []),
    split_string(S, "\n", "\n", Lines).

% Convert "L68" into the tuple l-68
line_to_turn(Turn, Dir-Dist) :-
    sub_atom(Turn, 0, 1, Len, Dir0),
    sub_string(Turn, 1, Len, _, Dist0),
    number_string(Dist, Dist0),
    downcase_atom(Dir0, Dir).

main :-
    file_to_lines("data.txt", Lines),
    maplist(line_to_turn, Lines, Turns),
    part1(50, 0, Turns, Res),
    writeln(Res),
    part2(50, 0, Turns, Res2),
    writeln(Res2).

% PART 1

turn_knob(Start, Dir-Dist, Result) :-
    Dir = l
        -> Result is (Start - Dist) mod 100
        ; Result is (Start + Dist) mod 100.

% recursion base case, if list is empty, unify the NumZeros with the Result
part1(_, Res, [], Res).

% recurse through the list, turning the knob, counting zeros
part1(Start, NumZeros, [Turn|Rest], Res) :-
    turn_knob(Start, Turn, NewStart),
    (NewStart = 0
        -> NewNumZeros is NumZeros + 1,
        part1(NewStart, NewNumZeros, Rest, Res)
        ; part1(NewStart, NumZeros, Rest, Res)).

% PART 2

% 6225 too low
% 6323 too high
% 6238 wrong

turn_knob_count_zeros(Start, Dir-Dist, Result, Zeros) :-
    ( Dir = l -> Diff is -Dist ; Diff is Dist ),
    Next is Start + Diff,
    divmod(Next, 100, Zeros0, Result0),
    Result is ((Result0 mod 100) + 100) mod 100,  % normalize result
    Zeros1 is abs(Zeros0),
    (Start = 0, Dir = l, Dist < 100 -> Zeros2 is Zeros1 - 1 ; Zeros2 is Zeros1),
    (Next = 0 -> Zeros is Zeros2 + 1 ; Zeros = Zeros2),
    format('Start: ~w Dir: ~w Dist: ~w Next: ~w Result: ~w Zeros: ~w~n',
           [Start, Dir, Dist, Next, Result, Zeros]).

part2(_, Res, [], Res).
part2(Start, NumZeros, [Turn|Rest], Res) :-
    turn_knob_count_zeros(Start, Turn, NewStart, Zeros),
    NewNumZeros is Zeros + NumZeros,
    format('New Zeros ~w~n', NewNumZeros),
    part2(NewStart, NewNumZeros, Rest, Res).


/*
Start: 0 Dir: l Dist: 223 Next: -223 Result: 77 Zeros: 3
Start: 52 Dir: r Dist: 192 Next: 244 Result: 44 Zeros: 2
*/
