% Suppress warning (input predicates).
%#input edgeshape/3. % why is this not working?
%#input nodeshape/3. % why is this not working?
%#input path/1.      % why is this not working?

% Only show assign/3, i.e., a faithful assignment (or UNSATISFIABLE, otherwise)
#show assignN/3.
#show assignE/3.