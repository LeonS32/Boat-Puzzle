% Representa el estado con canibales izquierda, misioneros izquierda, bote, canibales derecha, misioneros derecha
:- dynamic state/5.

% Estado seguro: no hay más caníbales que misioneros en ningún lado
safe(CL, ML, CR, MR) :-
    % No hay más caníbales que misioneros en la izquierda o no hay misioneros en la izquierda
    (ML >= CL ; ML = 0),
    % No hay más caníbales que misioneros en la derecha o no hay misioneros en la derecha
    (MR >= CR ; MR = 0).

% Movimiento del bote con M misioneros y C caníbales
move(CL, ML, CR, MR, B, CL1, ML1, CR1, MR1, B1) :-
    % Determina el número de misioneros y caníbales a mover
    member((C, M), [(0, 1), (1, 0), (1, 1), (0, 2), (2, 0)]),
    % Determina la dirección del movimiento y actualiza la posición del bote
    (B = left -> (CL1 is CL - C, ML1 is ML - M, CR1 is CR + C, MR1 is MR + M, B1 = right);
     (CL1 is CL + C, ML1 is ML + M, CR1 is CR - C, MR1 is MR - M, B1 = left)),
    % Asegúrate de que el movimiento sea seguro
    safe(CL1, ML1, CR1, MR1),
    % Asegúrate de que los números no sean negativos
    CL1 >= 0, ML1 >= 0, CR1 >= 0, MR1 >= 0,
    % Asegúrate de que los números no excedan el total de caníbales y misioneros
    CL1 =< 3, ML1 =< 3, CR1 =< 3, MR1 =< 3.

% Resolver el problema desde un estado hasta el estado final
solve(State, [State|Visited], Solution) :-
    % El estado final es 0 caníbales y 0 misioneros en la izquierda, el bote en la derecha
    State = state(0, 0, right, 3, 3),
    % Invierte el orden de los estados visitados para obtener la solución
    reverse([State|Visited], Solution).

solve(State, Visited, Solution) :-
    State = state(CL, ML, B, CR, MR),
    move(CL, ML, CR, MR, B, CL1, ML1, CR1, MR1, B1),
    NextState = state(CL1, ML1, B1, CR1, MR1),
    % Asegúrate de no visitar el mismo estado dos veces
    \+ member(NextState, Visited),
    solve(NextState, [NextState|Visited], Solution).

% Iniciar la solución
find_solution(Solution) :-
    % Estado inicial es 3 caníbales y 3 misioneros en la izquierda, bote en la izquierda
    InitialState = state(3, 3, left, 0, 0),
    solve(InitialState, [], Solution).

% Para ejecutar la solución, utiliza la consulta: ?- find_solution(Solution).
