
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programación Lógica - Tarea       %
%                                       %
%   Carlos Aponte     		09-10041    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2.- Estrellas Mágicas

% Caso para generar Estrellas Mágicas
estrella(X) :-
	var(X),
	generate(X).

% Caso para comprobar si la estrella es mágica
estrella(X) :-
	length(X,Y),
	Y is 16,
	checkValues(X),
	checkGreen(X),
	checkBlue(X),
	checkYellow(X),
	checkOrange(X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AUXILIAR RULES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Regla que verifica si los elementos de la linea suman 34 (4 * N + 2)
check(A,B,C,D) :-
	34 is A + B + C + D.

% Regla que calcula si todos los valores de los vertices estan entre 1 y 16
checkValues([]).
checkValues([X|T]) :-
	\+ member(X,T),
	X >= 1, X =< 16,
	checkValues(T).

% Regla que chequea el lado izquierdo de ambos cuadrados
checkGreen([A,B,C,_,_,F,_,H,_,J,_,L,_,_,_,_]):- 
	check(H,F,C,A),
	check(B,F,J,L).

% Regla que chequea el lado superior de ambos cuadrados
checkBlue([A,B,C,D,E,_,G,_,I,_,_,_,_,_,_,_]):- 
	check(B,C,D,E),
	check(A,D,G,I).

% Regla que chequea el lado inferior de ambos cuadrados
checkYellow([_,_,_,_,_,_,_,H,_,J,_,L,M,N,O,P]):- 
	check(H,J,M,P),
	check(L,M,N,O).

% Regla que chequea el lado derecho de ambos cuadrados
checkOrange([_,_,_,_,E,_,G,_,I,_,K,_,_,N,O,P]):- 
	check(E,G,K,O),
	check(I,K,N,P).

% Regla que genera las estrellas mágicas
generate([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P]):-
	
	genNumeros(16,NN),
	reverse(NN,G0),
	
	select(B,G0,G1),
	select(C,G1,G2),
	select(D,G2,G3),
	B + C + D < 34,
	select(E,G3,G4),
	
	check(B,C,D,E), % Check Blue 2
	
	select(A,G4,G5),
	select(F,G5,G6),
	A + C + F < 34,	% Pre-check Green 1

	select(G,G6,G7),
	A + D + G < 34, % Pre-check Blue 1

	select(H,G7,G8),
	check(A,C,F,H), % Check Green 1
	

	select(I,G8,G9),
	check(A,D,G,I), % Check Blue 1
	

	select(J,G9,G10),
	B + F + J < 34, % Pre-check Green 2

	select(K,G10,G11),
	E + G + K < 34, % Pre-check Orange 1

	select(L,G11,G12),
	check(B,F,J,L), % Check Green 2

	select(O,G12,G13),
	check(E,G,K,O), % Check Orange 1

	select(M,G13,G14),
	H + J + M < 34, 	% Pre-check Yellow 1

	select(N,G14,G15),
	I + K + N < 34,	% Pre-check Orange 2

	check(L,M,N,O),	% Check Yellow 2

	select(P,G15,_),

	check(H,J,M,P),	% Check Yellow 1
	check(I,K,N,P).	% Check Orange 2
	

% Este procedimiento genera los números del 1 hasta N y los guarda en una lista
genNumeros(0,H) :- H = [].
genNumeros(N,[H|T]) :-
	N > 0,
	H is N,
	NN is N - 1,
	genNumeros(NN,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%