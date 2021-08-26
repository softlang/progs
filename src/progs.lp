% -- data model --

node(X) :- edge(X,_,_).
node(X) :- edge(_,_,X).
edge(X) :- edge(_,X,_).

labels(L) :- label(_, L).
properties(P) :- property(_, P, _).

% -- utility --

min(yes,yes,yes).
min(yes,no,no).
min(no,yes,no).
min(no,no,no).
min(yes,maybe,maybe).
min(maybe,yes,maybe).
min(maybe,maybe,maybe).
min(no,maybe,no).
min(maybe,no,no).

% -- core --

nodeshape(S) :- nodeshape(S,_,_).
edgeshape(S) :- edgeshape(S,_,_).

targetN(N,S) :- nodeshape(S,_,label(L)), label(N,L).
targetN(N,S) :- nodeshape(S,_,hasProperty(K)), property(N,K,_).
targetN(N,S) :- nodeshape(S,_,hasPropertyValue(K,V)), property(N,K,V).
targetN(N,S) :- nodeshape(S,_,node(N)).

targetE(E,S) :- edgeshape(S,_,label(L)), label(E,L).
targetE(E,S) :- edgeshape(S,_,hasProperty(K)), property(E,K,_).
targetE(E,S) :- edgeshape(S,_,hasPropertyValue(K,V), property(E,K,V)).
targetE(E,S) :- edgeshape(S,_,edge(E)).

:- targetN(N,S), not assignN(N,S,yes).
:- targetE(E,S), not assignE(E,S,yes).

assignN(N,S,R) :- nodeshape(S,C,_), satisfiesN(N,C,R).
assignE(E,S,R) :- edgeshape(S,C,_), satisfiesE(E,C,R).

assignN(N,S,yes) | assignN(N,S,no) | assignN(N,S,maybe) :- node(N), nodeshape(S).
assignE(E,S,yes) | assignE(E,S,no) | assignE(E,S,maybe) :- edge(E), edgeshape(S).

% -- paths --

path(N1,N2,label(P)) :- edge(N1,E,N2), label(E,P).
path(N1,N2,concatpath(P1,P2)) :- path(P1), path(P2), path(N1,N,P1), path(N,N2,P2).
path(N1,N2,negatepath(P)) :- path(P), path(N2,N1,P).
path(N1,N2,choicepath(P1,P2)) :- path(P1), path(P2), path(N1,N2,P1).
path(N1,N2,choicepath(P1,P2)) :- path(P1), path(P2), path(N1,N2,P2).
path(N1,N2,repeatpath(P)) :- path(P), path(N1,N2,P).
path(N1,N2,repeatpath(P)) :- path(P), path(N1,N,P), path(N,N2,repeatpath(P)).

% -- top --

satisfiesN(N,top,yes) :- node(N).
satisfiesE(E,top,yes) :- edge(E).

satisfiesN(N,bottom,no) :- node(N).
satisfiesE(E,bottom,no) :- edge(E).

% -- shapeRef --

satisfiesN(N,shapeRef(S),R) :- node(N), constraint(shapeRef(S)),
                              assignN(N,S,R).

satisfiesE(E,shapeRef(S),R) :- edge(E), constraint(shapeRef(S)),
                              assignE(E,S,R).

% -- nodeId/edgeID --

satisfiesN(N, nodeId(N2), yes) :- node(N), node(N2), N == N2.
satisfiesN(N, nodeId(N2), no) :- node(N), node(N2), N != N2.

satisfiesE(E, edgeId(E2), yes) :- edge(E), edge(E2), E == E2.
satisfiesE(E, edgeId(E2), no) :- edge(E), edge(E2), E != E2.

% -- label --

satisfiesN(N,label(L),yes) :- node(N), constraint(label(L)), label(N,L).
satisfiesN(N,label(L),no) :- node(N), constraint(label(L)), not label(N,L).

satisfiesE(E,label(L),yes) :- edge(E), constraint(label(L)), label(E,L).
satisfiesE(E,label(L),no) :- edge(E), constraint(label(L)), not label(E,L).

% -- negate --

satisfiesN(N, negate(C), yes) :- node(N), constraint(negate(C)),
                                 satisfiesN(N,C,no).
satisfiesN(N, negate(C), no) :- node(N), constraint(negate(C)),
                                satisfiesN(N,C,yes).
satisfiesN(N, negate(C), maybe) :- node(N), constraint(negate(C)),
                                   satisfiesN(N, C, maybe).

satisfiesE(E, negate(C), yes) :- edge(E), constraint(negate(C)),
                                 satisfiesE(E,C,no).
satisfiesE(E, negate(C), no) :- edge(E), constraint(negate(C)),
                                satisfiesE(E,C,yes).
satisfiesE(E, negate(C), maybe) :- edge(E), constraint(negate(C)),
                                   satisfiesE(E, C, maybe).

% -- and --

satisfiesN(N,and(C1,C2),R) :- node(N), constraint(and(C1,C2)),
                              satisfiesN(N,C1,R1), satisfiesN(N,C2,R2),
                              min(R1,R2,R).

satisfiesE(E,and(C1,C2),R) :- edge(E), constraint(and(C1,C2)),
                              satisfiesE(E,C1,R1), satisfiesE(E,C2,R2),
                              min(R1,R2,R).

% -- greaterEq --

satisfiesN(N,greaterEq(P,NC,I),yes) :- node(N), constraint(greaterEq(P,NC,I)),
                                      countNC(N,P,NC,C), C >= I.

satisfiesN(N,greaterEq(P,NC,I),no) :- node(N), constraint(greaterEq(P,NC,I)),
                                     countAll(N,P,C1), countNoNC(N,P,NC,C2),
                                     C1 - C2 < I.

satisfiesN(N,greaterEq(P,NC,I), maybe) :- node(N), constraint(greaterEq(P,NC,I)),
                                         not satisfiesN(N,greaterEq(P,NC,I),yes),
                                         not satisfiesN(N,greaterEq(P,NC,I),no).

countAll(N,P,C) :- node(N), path(P), 
                   #count { Y: path(N,Y,P) } = C.

countNC(N,P,NC,C) :- node(N), path(P), constraint(NC), 
                     #count { Y: path(N,Y,P), satisfiesN(Y,NC,yes) } = C.

countNoNC(N,P,NC,C) :- node(N), path(P), constraint(NC), 
                       #count { Y: path(N,Y,P), satisfiesN(Y,NC,no) } = C.

% -- compare -- 

% not yet supported

% -- greaterEqE --

satisfiesN(N,greaterEqE(E,I),yes) :- node(N), constraint(greaterEqE(E,I)),
                                     countSatisfiedEdges(N,E,C), C >= I.

satisfiesN(N,greaterEqE(E,I),no) :- node(N), constraint(greaterEqE(E,I)),
                                    countAllEdges(N,C1), countUnsatisfiedEdges(N,E,C2), 
                                    C1 - C2 < I.

satisfiesN(N,greaterEqE(E,I),yes) :- node(N), constraint(greaterEqE(E,I)),
                                     not satisfiesN(N,greaterEqE(E,I),yes), 
                                     not satisfiesN(N,greaterEqE(E,I),no).

countSatisfiedEdges(N,EC,C) :- node(N), constraint(EC), 
                               #count { E: edge(N,E,_), satisfiesE(E,EC,yes) } = C.

countUnsatisfiedEdges(N,EC,C) :- node(N), constraint(EC), 
                                 #count { E: edge(N,E,_), satisfiesE(E,EC,no) } = C.

countAllEdges(N, C) :- node(N), #count { E: edge(N,E,_) } = C.

% -- countProp --

satisfiesN(N,countProp(K,isString,I),yes) :- node(N), constraint(countProp(K,isString,I)), #count { V: property(N,K,string(V)) } >= I.
satisfiesN(N,countProp(K,isString,I),no) :- node(N), constraint(countProp(K,isString,I)),  #count { V: property(N,K,string(V)) } < I.

satisfiesN(N,countProp(K,isInteger,I),yes) :- node(N), constraint(countProp(K,isInteger,I)), #count { V: property(N,K,integer(V)) } >= I.
satisfiesN(N,countProp(K,isInteger,I),no) :- node(N), constraint(countProp(K,isInteger,I)), #count { V: property(N,K,integer(V)) } < I.

satisfiesE(E,countProp(K,isString,I),yes) :- edge(E), constraint(countProp(K,isString,I)), #count { V: property(E,K,string(V)) } >= I.
satisfiesE(E,countProp(K,isString,I),no) :- edge(E), constraint(countProp(K,isString,I)), #count { V: property(E,K,string(V)) } < I.

satisfiesE(E,countProp(K,isInteger,I),yes) :- edge(E), constraint(countProp(K,isInteger,I)), #count { V: property(E,K,integer(V)) } >= I.
satisfiesE(E,countProp(K,isInteger,I),no) :- edge(E), constraint(countProp(K,isInteger,I)), #count { V: property(E,K,integer(V)) } < I.

% -

satisfiesN(N,countProp(K,eq(R),I),yes) :- node(N), constraint(countProp(K,eq(R),I)), #count { V: property(N,K,V), V == R } >= I.
satisfiesN(N,countProp(K,eq(R),I),no) :- node(N), constraint(countProp(K,eq(R),I)), #count { V: property(N,K,V), V == R } < I.

satisfiesE(E,countProp(K,eq(R),I),yes) :- edge(E), constraint(countProp(K,eq(R),I)), #count { V: property(E,K,V), V == R } >= I.
satisfiesE(E,countProp(K,eq(R),I),no) :- edge(E), constraint(countProp(K,eq(R),I)), #count { V: property(E,K,V), V == R } < I.

% -- compareValues --

% not yet supported

% -- equals --

satisfiesN(N,equals(K1,K2),yes) :- node(N), constraint(equals(K1,K2)),
                                   property(N,K1,V1), property(N,K2,V2),
                                   V1 == V2.

satisfiesN(N,equals(K1,K2),no) :- node(N), constraint(equals(K1,K2)),
                                  property(N,K1,V1), property(N,K2,V2),
                                  V1 != V2.

satisfiesE(E,equals(K1,K2),yes) :- edge(E), constraint(equals(K1,K2)),
                                   property(E,K1,V1), property(E,K2,V2),
                                   V1 == V2.

satisfiesE(E,equals(K1,K2),no) :- edge(E), constraint(equals(K1,K2)),
                                  property(E,K1,V1), property(E,K2,V2),
                                  V1 != V2.

% -- left/right --

satisfiesE(E,left(NC),R) :- edge(E), edge(N,E,_), constraint(left(NC)), satisfiesN(N,NC,R).
satisfiesE(E,right(NC),R) :- edge(E), edge(_,E,N), constraint(right(NC)), satisfiesN(N,NC,R).