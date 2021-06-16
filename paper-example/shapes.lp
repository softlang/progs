% ----- Shapes (Instance) -----------------------------------------------------
% -----------------------------------------------------------------------------

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
%   compare(P1,P2)
%   ... TODO

nodeshape(personShape,
          and(label(person),greaterEq(colleagueOf,personShape,1)),
          node(100)).

nodeshape(employeeShape,
          and(label(employee),greaterEq(worksFor,organizationShape,1)),
          label(employee)).

nodeshape(organizationShape, label(company), label(company)).

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
%   ... TODO

edgeshape(worksForShape, label(worksFor), label(worksFor)).
