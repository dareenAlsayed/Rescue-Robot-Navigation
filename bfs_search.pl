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
initialState(state(R, C, [(R,C)], 100)):-
    grid(Gr),
    findRobotPos(Gr, R, C).
goalState(state(R, C, _, _)):-
    grid(Gr),
    getValofCell(Gr, R, C, s).
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
expansion(state(R,C,Path,Battery), Children):-
    grid(G),
    findall(
        state(NewR,NewC,[(NewR,NewC)|Path],NewBattery),
        (
            nextMovement(G, R, C, Path, NewR, NewC),
            NewBattery is Battery - 10,
            NewBattery >= 0
        ),
        Children
    ).
getValidChildren(State, O, C, ValidChildren):-
    expansion(State, Children),
    findall(
        Child,
        (
            member(Child, Children),
            \+ member(Child, O),
            \+ member(Child, C)
        ),
        ValidChildren
    ).
breadthfirstsearch([State|_], _, State):-
    goalState(State).
breadthfirstsearch([State|RestO], C, Sol):-
    getValidChildren(State, RestO, C, Children),
    append(RestO, Children, NewO),
    breadthfirstsearch(NewO, [State|C], Sol).
solve:-
    initialState(Init),
    breadthfirstsearch([Init], [], Sol),
    printing(Sol).
printing(state(_,_,Path,Battery)):-
    reverse(Path, Correct),
    length(Correct, L),
    Steps is L - 1,
    write('Path found: '),
    print_path(Correct), nl,
    write('Number of steps: '), write(Steps), nl,
    write('Remaining Battery: '), write(Battery), write('%'), nl.
print_path([]).
print_path([(R,C)]) :- format("(~w,~w)", [R,C]).
print_path([(R,C)|T]) :- format("(~w,~w) -> ", [R,C]), print_path(T).
