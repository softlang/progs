% ---- Model (Instance) -------------------------------------------------------
% -----------------------------------------------------------------------------

% Define all edges in the graph, where
% the middle element is the edge id.

edge(100, 200, 101).
edge(100, 201, 102).
edge(102, 202, 100).
edge(102, 203, 101).

% Define labels for nodes and edges.

label(100, person).
label(102, person).
label(100, employee).
label(102, employee).
label(101, company).
label(200, worksFor).
label(201, colleagueOf).
label(202, colleagueOf).
label(203, worksFor).

% Define properties for nodes and edges.
% This prototype only supports singleton sets
% and the data types string/1, integer/1 and year/1.

property(100, name, string("Tim Canterbury")).
property(100, age, integer(30)).
property(101, name, string("Wernham Hogg")).
property(101, name, string("Gareth Keenan")).
property(203, since, year(2020)).
property(200, since, year(1970)).



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

% ----- Output ----------------------------------------------------------------
% -----------------------------------------------------------------------------

% Only show assign/3, i.e., a faithful assignment (or UNSATISFIABLE, otherwise)

#show assignN/3.
#show assignE/3.