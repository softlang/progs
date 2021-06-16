% A node shape consists of a shape name, (e.g., personShape), a node constraint
% (e.g, and(label(person),greaterEq(colleagueOf,personShape,1))) and
% a node target query (e.g., node(100)).
% We currently support the following target queries:
%   node(N)
%   label(L)
%   hasProperty(K)
%   bottom (i.e., no target)
% The abstract syntax of node constraints is as follows:
%   top
%   shapeRef(S)
%   nodeId(N)
%   label(L)
%   negate(C)
%   and(C1,C2)
%   greaterEq(L,S,I)
%   compare(P1,P2) -- NOT SUPPORTED
%   greaterEqE(C,I)
%   countProp(K,F,I)
%   compareValues(P1,K1,P2,K2) -- NOT SUPPORTED
%   equals(K1,K2)
% where S = shape name, C = constraint, L = label, I = integer,
%       P = path, K = property name, F = value predicate
% And the value predicates:
%   isString, isInteger
%   equals(V)

%nodeshape(employeeShape, and(label(employee),greaterEq(worksFor,organizationShape,1)), label(employee)).
%nodeshape(organizationShape, label(company), label(company)).
nodeshape(test, countProp(name, isString, 1), label(employee)).

% An edge shape consists of a shape name, (e.g., worksForShape), an edge constraint
% (e.g, label(worksFor)) and
% an edge target query (e.g., label(worksFor)).
% We currently support the following target queries:
%   edge(N)
%   label(L)
%   hasProperty(K)
%   bottom (i.e., no target)
% The abstract syntax of node constraints is as follows:
%   top
%   shapeRef(S)
%   edgeId(E)
%   label(L)
%   negate(C)
%   and(C1,C2)
%   countProp(K,F,I)
%   equals(K1,K2)
%   left(C)
%   right(C)
% where S = shape name, C = constraint, L = label, I = integer, 
%       P = path, K = property name, F = value predicate
% And the value predicates:
%   isString, isInteger
%   equals(V)

%edgeshape(worksForShape, and(countProp(since,isInteger,1),and(left(label(employee)),right(label(company)))), label(worksFor)).