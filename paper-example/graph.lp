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
