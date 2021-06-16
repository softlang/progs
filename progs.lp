% -----------------------------------------------------------------------------
% Copyright [2021] Philipp Seifer
% Software Languages Team, Universität Koblenz-Landau
% Associated paper: ProGS - Property Graph Shapes Language [ISWC 2021]
% URL: <TODO>
% Co-authors: Ralf Lämmel, Steffen Staab
% -----------------------------------------------------------------------------

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

shape(S) :- nodeshape(S,_,_).

targetquery(label(L)) :- labels(L).
targetquery(node(N)) :- node(N).
targetquery(hasProperty(K)) :- properties(K).
targetquery(bottom).

target(N,S) :- nodeshape(S,_,label(L)), label(N,L).
target(N,S) :- nodeshape(S,_,hasProperty(K)), property(N,K,_).
target(N,S) :- nodeshape(S,_,node(N)).

:- target(X,S), not assign(X,S,yes).

assign(X,S,R) :- nodeshape(S,C,_), satisfies(X,C,R).

assign(X,S,yes) | assign(X,S,no) | assign(X,S,maybe) :- node(X), shape(S).

% -- Top --

satisfies(N,top,yes) :- node(N).

% -- ShapeRef --

satisfies(N,shapeRef(S),R) :- node(N), constraint(shapeRef(S)),
                              assign(N,S,R).

% -- NodeId --

satisfies(N, nodeId(N2), yes) :- node(N), node(N2), N == N2.
satisfies(N, nodeId(N2), no) :- node(N), node(N2), N != N2.

% -- Label --

satisfies(N,label(L),yes) :- node(N), constraint(label(L)), label(N,L).
satisfies(N,label(L),no) :- node(N), constraint(label(L)), not label(N,L).

% -- Negate --

satisfies(N, negate(C), yes) :- node(N), constraint(negate(C)),
                                satisfies(N,C,no).
satisfies(N, negate(C), no) :- node(N), constraint(negate(C)),
                               satisfies(N,C,yes).

% -- And --

satisfies(N,and(S1,S2),R) :- node(N), constraint(and(S1,S2)),
                             satisfies(N,S1,R1), satisfies(N,S2,R2),
                             min(R1,R2,R).

% -- GreaterEq --

satisfies(N,greaterEq(L,S,I),yes) :- node(N), constraint(greaterEq(L,S,I)),
                                     countShape(N,L,S,C), C >= I.

satisfies(N,greaterEq(L,S,I),no) :- node(N), constraint(greaterEq(L,S,I)),
                                    countAll(N,L,C1), countNoShape(N,L,S,C2),
                                    C1 - C2 < I.

satisfies(N,greaterEq(P,S,I), maybe) :- node(N), constraint(greaterEq(P,S,I)),
                                        countShape(N,L,S,C), not C >= I,
                                        countAll(N,L,C1),
                                        countNoShape(N,L,S,C2), not C1 - C2 < I.

countAll(N,L,C) :- node(N), labels(L), #count { Y: any(N,L,Y) } = C.
any(N,L,Y) :- edge(N,E,Y), label(E,L).

countShape(N,L,S,C) :- node(N), labels(L), shape(S),
                       #count { Y: withShape(N,L,S,Y) } = C.
withShape(N,L,S,Y) :- edge(N,E,Y), label(E,L), assign(Y,S,yes).

countNoShape(N,L,S,C) :- node(N), labels(L), shape(S),
                         #count { Y: withoutShape(N,L,S,Y) } = C.
withoutShape(N,L,S,Y) :- edge(N,E,Y), label(E,L), assign(Y,S,no).



% ----- Output ----------------------------------------------------------------
% -----------------------------------------------------------------------------

#show assign/3.



% ----- References-------------------------------------------------------------
% -----------------------------------------------------------------------------
%
% Implementation inspired by the following resources:
%
% [1] https://labra.weso.es/pdf/2018_SlidesNegationRecursionValidatingRDF.pdf
% [2] https://github.com/weso/shaclex/blob/master/examples/clingo/negation.pl