% Define all edges in the graph, where
% the middle element is the edge id.

edge(100, 200, 101).
edge(100, 201, 102).
edge(102, 202, 100).
edge(102, 203, 101).

% Define labels for nodes and edges.

label(100, person).
label(100, employee).
label(102, employee).
label(101, company).
label(200, worksFor).
label(201, colleagueOf).
label(202, colleagueOf).
label(203, worksFor).

% Define properties for nodes and edges.
% We support the data types string/1 and integer/1.
% To annotate multiple values, use multiple property/3
% with different values.

property(100, name, string("Tim Canterbury")).
property(100, age, integer(30)).
property(101, name, string("Wernham Hogg")).
property(102, name, string("Gareth Keenan")).
property(102, role, string("sales")).
property(102, role, string("team leader")).
property(203, since, integer(2020)).
property(200, since, integer(1970)).