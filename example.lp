% ---- Model (Instance) -------------------------------------------------------
% -----------------------------------------------------------------------------

edge(100, 200, 101).
edge(100, 201, 102).
edge(102, 202, 100).
edge(102, 203, 101).

property(100, name, string("Tim Canterbury")).
property(100, age, integer(30)).
property(101, name, string("Wernham Hogg")).
property(101, name, string("Gareth Keenan")).
property(203, since, date(2020)).
property(200, since, date(1970)).

label(100, person).
label(102, person).
label(100, employee).
label(102, employee).
label(101, company).
label(200, worksFor).
label(201, colleagueOf).
label(202, colleagueOf).
label(203, worksFor).



% ----- Shapes (Instance) -----------------------------------------------------
% -----------------------------------------------------------------------------

nodeshape(personShape,
          and(label(person),greaterEq(colleagueOf,personShape,1)),
          node(100)).

nodeshape(employeeShape,
          and(label(employee),greaterEq(worksFor,organizationShape,1)),
          label(employee)).

nodeshape(organizationShape, label(company), label(company)).



% ----- Output ----------------------------------------------------------------
% -----------------------------------------------------------------------------

% Only show assign/3, i.e., a faithful assignment (or UNSATISFIABLE, otherwise)

#show assign/3.