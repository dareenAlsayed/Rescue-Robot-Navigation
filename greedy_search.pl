grid([
  [r, e, d, e, e],
  [e, e, f, e, s],
  [d, e, e, e, e],
  [e, s, e, f, e]
]).
getValofCell(G, R, C, V):-
    nth1(R, G, RL),
    nth1(C, RL, V).
findRobotPos(G, R, C):-
    nth1(R, G, RL),
    nth1(C, RL, r).
initialState(state(R, C, [(R,C)], Rescued)):-
    grid(G),
    findRobotPos(G, R, C),
    Rescued = [].
moveUp(R, C, NewR, C):-
    NewR is R - 1.
moveDown(R, C, NewR, C):-
    NewR is R + 1.
moveLeft(R, C, R, NewC):-
    NewC is C - 1.
moveRight(R, C, R, NewC):-
    NewC is C + 1.
validMovement(G, R, C, Path):-
    length(G, MaxR),
    R >= 1, R =< MaxR,
    nth1(1, G, FirstR),
    length(FirstR, MaxC),
    C >= 1, C =< MaxC,
    getValofCell(G, R, C, V),
    V \= d,
    V \= f,
    \+ member((R,C), Path).
nextMovement(G, R, C, Path, NewR, NewC):-
    (
        moveUp(R, C, NewR, NewC);
        moveDown(R, C, NewR, NewC);
        moveLeft(R, C, NewR, NewC);
        moveRight(R, C, NewR, NewC)
    ),
    validMovement(G, NewR, NewC, Path).
expansion(state(R,C,Path,Rescued), Children):-
    grid(G),
    findall(
        state(NewR,NewC,[(NewR,NewC)|Path],NewRescued),
        (
            nextMovement(G, R, C, Path, NewR, NewC),
            getValofCell(G, NewR, NewC, V),
            (
                V = s,
                \+ member((NewR,NewC), Rescued)
            ->
                NewRescued = [(NewR,NewC)|Rescued]
            ;
                NewRescued = Rescued
            )
        ),
        Children
    ).
heuristic(state(R,C,_,Rescued), H):-
    grid(G),
    findall(
        (SR,SC),
        (
            nth1(SR,G,Row),
            nth1(SC,Row,s),
            \+ member((SR,SC), Rescued)
        ),
        Remaining
    ),
    length(Rescued, NR),
    (
        Remaining = []
    ->
        H is -(100 + NR)
    ;
        findall(
            D,
            (
                member((SR,SC), Remaining),
                D is abs(R-SR)+abs(C-SC)
            ),
            Ds
        ),
        min_list(Ds, MinD),
        H is MinD - 10*NR
).
inClosed(R, C, Rescued, Closed):-
    member((R,C,Rescued), Closed).
getValidChildren(State, O, C, ValidChildren):-
    expansion(State, Children),
    findall(
        H-Child,
        (
            member(Child, Children),
            Child = state(R,C1,_,Rescued),
            \+ inClosed(R,C1,Rescued,C),
            \+ member(_-state(R,C1,_,Rescued), O),
            heuristic(Child, H)
        ),
        ValidChildren
    ).
greedyBFS([], _, Best, Best).
greedyBFS([_-State|RestO], C, CurrentBest, FinalSol):-
    State = state(_,_,_,Res1),
    CurrentBest = state(_,_,_,Res2),
    length(Res1, L1),
    length(Res2, L2),
    (
        L1 > L2
    ->
        NewBest = State
    ;
        NewBest = CurrentBest
    ),
    State = state(R,C1,_,Rescued),
    NewClosed = [(R,C1,Rescued)|C],
    getValidChildren(State, RestO, NewClosed, NewChildren),
    append(RestO, NewChildren, NewO),
    msort(NewO, SortedO),
    greedyBFS(SortedO, NewClosed, NewBest, FinalSol).
solve:-
    initialState(Init),
    heuristic(Init, H),
    greedyBFS([H-Init], [], Init, Sol),
    printing(Sol).
printing(state(_,_,Path,Rescued)):-
    reverse(Path, Correct),
    length(Correct, L),
    Steps is L - 1,
    length(Rescued, N),
    write('Path found: '),
    print_path(Correct), nl,
    write('Survivors rescued: '),
    write(N), nl,
    write('Number of steps: '),
    write(Steps), nl.
print_path([]).
print_path([(R,C)]):-
    format("(~w,~w)", [R,C]).
print_path([(R,C)|T]):-
    format("(~w,~w) -> ", [R,C]),
    print_path(T).