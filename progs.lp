% ---- Model (General) --------------------------------------------------------
% -----------------------------------------------------------------------------

node(X) :- edge(X,_,_).
node(X) :- edge(_,_,X).
edge(X) :- edge(_,X,_).

labels(L) :- label(_, L).
properties(P) :- property(_, P, _).



% ----- Shapes (General) ------------------------------------------------------
% -----------------------------------------------------------------------------

% -- Utility and Core

min(yes,yes,yes).
min(yes,no,no).
min(no,yes,no).
min(no,no,no).
min(yes,maybe,maybe).
min(maybe,yes,maybe).
min(maybe,maybe,maybe).
min(no,maybe,no).
min(maybe,no,no).

constraint(C) :- constraint(and(C,_)).
constraint(C) :- constraint(and(_,C)).
constraint(C) :- nodeshape(_,C,_).
constraint(C) :- edgeshape(_,C,_).

nodeshape(S) :- nodeshape(S,_,_).
edgeshape(S) :- edgeshape(S,_,_).

targetN(N,S) :- nodeshape(S,_,label(L)), label(N,L).
targetN(N,S) :- nodeshape(S,_,hasProperty(K)), property(N,K,_).
targetN(N,S) :- nodeshape(S,_,node(N)).

targetE(E,S) :- edgeshape(S,_,label(L)), label(E,L).
targetE(E,S) :- edgeshape(S,_,hasProperty(K)), property(E,K,_).
targetE(E,S) :- edgeshape(S,_,edge(E)).

:- targetN(N,S), not assignN(N,S,yes).
:- targetE(E,S), not assignE(E,S,yes).

assignN(N,S,R) :- nodeshape(S,C,_), satisfiesN(N,C,R).
assignE(E,S,R) :- edgeshape(S,C,_), satisfiesE(E,C,R).

assignN(N,S,yes) | assignN(N,S,no) | assignN(N,S,maybe) :- node(N), nodeshape(S).
assignE(E,S,yes) | assignE(E,S,no) | assignE(E,S,maybe) :- edge(E), edgeshape(S).

% -- Top --

satisfiesN(N,top,yes) :- node(N).
satisfiesE(E,top,yes) :- edge(E).

% -- ShapeRef --

satisfiesN(N,shapeRef(S),R) :- node(N), constraint(shapeRef(S)),
                              assignN(N,S,R).

satisfiesE(E,shapeRef(S),R) :- edge(E), constraint(shapeRef(S)),
                              assignN(E,S,R).

% -- NodeId/EdgeID --

satisfiesN(N, nodeId(N2), yes) :- node(N), node(N2), N == N2.
satisfiesN(N, nodeId(N2), no) :- node(N), node(N2), N != N2.

satisfiesE(E, edgeId(E2), yes) :- edge(E), edge(E2), E == E2.
satisfiesE(E, edgeId(E2), no) :- edge(E), edge(E2), E != E2.

% -- Label --

satisfiesN(N,label(L),yes) :- node(N), constraint(label(L)), label(N,L).
satisfiesN(N,label(L),no) :- node(N), constraint(label(L)), not label(N,L).

satisfiesE(E,label(L),yes) :- edge(E), constraint(label(L)), label(E,L).
satisfiesE(E,label(L),no) :- edge(E), constraint(label(L)), not label(E,L).

% -- Negate --

satisfiesN(N, negate(C), yes) :- node(N), constraint(negate(C)),
                                 satisfiesN(N,C,no).
satisfiesN(N, negate(C), no) :- node(N), constraint(negate(C)),
                                satisfiesN(N,C,yes).

satisfiesE(E, negate(C), yes) :- edge(E), constraint(negate(C)),
                                 satisfiesE(E,C,no).
satisfiesE(E, negate(C), no) :- edge(E), constraint(negate(C)),
                                satisfiesE(E,C,yes).

% -- And --

satisfiesN(N,and(C1,C2),R) :- node(N), constraint(and(C1,C2)),
                              satisfiesN(N,C1,R1), satisfiesN(N,C2,R2),
                              min(R1,R2,R).

satisfiesE(E,and(C1,C2),R) :- edge(E), constraint(and(C1,C2)),
                              satisfiesE(E,C1,R1), satisfiesE(E,C2,R2),
                              min(R1,R2,R).

% -- GreaterEq --

satisfiesN(N,greaterEq(L,S,I),yes) :- node(N), constraint(greaterEq(L,S,I)),
                                      countShape(N,L,S,C), C >= I.

satisfiesN(N,greaterEq(L,S,I),no) :- node(N), constraint(greaterEq(L,S,I)),
                                     countAll(N,L,C1), countNoShape(N,L,S,C2),
                                     C1 - C2 < I.

satisfiesN(N,greaterEq(P,S,I), maybe) :- node(N), constraint(greaterEq(P,S,I)),
                                         countShape(N,L,S,C), not C >= I,
                                         countAll(N,L,C1),
                                         countNoShape(N,L,S,C2), not C1 - C2 < I.

countAll(N,L,C) :- node(N), labels(L), #count { Y: any(N,L,Y) } = C.
any(N,L,Y) :- edge(N,E,Y), label(E,L).

countShape(N,L,S,C) :- node(N), labels(L), nodeshape(S),
                       #count { Y: withShape(N,L,S,Y) } = C.
withShape(N,L,S,Y) :- edge(N,E,Y), label(E,L), assignN(Y,S,yes).

countNoShape(N,L,S,C) :- node(N), labels(L), nodeshape(S),
                         #count { Y: withoutShape(N,L,S,Y) } = C.
withoutShape(N,L,S,Y) :- edge(N,E,Y), label(E,L), assignN(Y,S,no).