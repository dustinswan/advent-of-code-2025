:- use_module(library(lists)).

main :-
    File = "data.txt",
    run(File, 2, Part1),
    writeln(Part1),
    run(File, 12, Part2),
    writeln(Part2).

file_bank(Path, Bank) :-
    read_file_to_string(Path, S, []),
    split_string(S, "\n", "\n", Lines),
    member(Line, Lines),
    number_string(Number, Line),
    number_chars(Number, Chars),
    maplist(atom_number, Chars, Bank).

run(Path, DigitSize, Sum) :-
    findall(N,
        (file_bank(Path, Bank), bank_max(Bank, DigitSize, N)),
        Ns),
    sumlist(Ns, Sum).

bank_max(Bank, DigitSize, Max) :-
    bank_max_acc(Bank, DigitSize, [], Answer),
    list_to_number(Answer, Max).

bank_max_acc(_, 0, NumList, NumList).
bank_max_acc(Bank, DigitsLeft, NumList, Answer) :-
    length(Bank, Len),
    SplitIndex is Len - DigitsLeft + 1,
    split_list_at_index(Bank, SplitIndex, Left, _),
    max_list(Left, Digit),
    nth0(FoundIndex, Left, Digit),
    DigitsLeft2 is DigitsLeft - 1,
    append(NumList, [Digit], NumList2),
    NewSplitIndex is FoundIndex + 1,
    split_list_at_index(Bank, NewSplitIndex, _, Rest),
    bank_max_acc(Rest, DigitsLeft2, NumList2, Answer),
    !.

% Helpers

split_list_at_index(List, Index, Left, Right) :-
    length(Left, Index),
    append(Left, Right, List).

list_to_number(Digits, Number) :- list_to_number_acc(Digits, 0, Number).
list_to_number_acc([], Acc, Acc).
list_to_number_acc([Digit|Rest], AccIn, Number) :-
    AccNext is AccIn * 10 + Digit,
    list_to_number_acc(Rest, AccNext, Number).
