
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programación Lógica - Tarea       %
%                                       %
%   Carlos Aponte           09-10041    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1.- Estaciones

% Predicado que determina cuáles son las mejores ciudades.
estacion(X):- mejor(X).


%%%%%%%%%%%%%%%%%%%%%%%%%%% PREDICADOS AUXILIARES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Predicado que determina si una ciudad es pequena (tiene a lo sumo 2 
% conexiones).
pequena(X) :- 
    setof(Y, (carril(X,Y);carril(Y,X)), L), 
    length(L, Conexiones),
    Conexiones < 3,
    Conexiones > 0.

% Predicado que determina si una ciudad es grande (tiene 3 o más conexiones).
grande(X) :- 
    setof(Y, (carril(X,Y);carril(Y,X)), L), 
    length(L, Conexiones),
    Conexiones >=3.
          
% Predicado que averigüa un camino óptimo desde "Inicio" hasta "Fin".
camino(Inicio,Fin,Camino,Costo) :-
    bfs(Inicio,Fin,Camino), 
    length(Camino,Costo).

% Predicado que determina un camino óptimo mediante el algoritmo de BFS.
bfs(Inicio,Fin,Camino) :- bfs_helper(Inicio,Fin,[],[],[],Camino).

% Caso en que quiera un camino de un punto a sí mismo.
bfs_helper(Inicio,Inicio,_,_,_,_):- !, fail.

% Caso en que el nodo actual actual es adyacente al destino.
bfs_helper(Inicio,Fin,Ruta,_,_,Camino):- 
    (carril(Inicio,Fin); carril(Fin,Inicio)),
    armar_camino(Inicio,Ruta,Camino,[Inicio,Fin]), !.

% Caso en que debo buscar uno o más nodos intermedios.    
bfs_helper(Inicio,Fin,Ruta,Candidatos,Visitados,Camino):- 
    findall((Inicio,Y),
            ((carril(Inicio,Y);carril(Y,Inicio)),
            \+ member(Y,Visitados), 
            \+ member((_,Y),Candidatos)),L),
    append(Candidatos,L,Candidatos2),
    append(Ruta,L,Ruta2),
    append(Visitados,[Inicio],Visitados2),
    Candidatos2 = [(_,Y)|Zs],
    bfs_helper(Y,Fin,Ruta2,Zs,Visitados2,Camino), !.

% Predicado que arma el camino desde el inicio hasta el fin basado en la
% ejecucion del BFS.      
% Caso en que estoy en el nodo inicial y por ende no hay antecesor.      
armar_camino(Inicio,Ruta,Temp,Temp):-
    \+ member((_,Inicio),Ruta).

% Caso para detectar el antecesor del nodo actual.
armar_camino(Inicio,Ruta,Camino,Temp):-
    member((Padre,Inicio),Ruta),
    armar_camino(Padre,Ruta,Camino,[Padre|Temp]).

% Predicado que determina si una ciudad es pequeña y su distancia a las dos 
% ciudades grandes más cercanas es la misma.
buena(X,Costo):- 
    pequena(X), 
    grande(Y), grande(Z), Y \= Z, 
    camino(X,Y,[_,E1|_],Costo), 
    camino(X,Z,[_,E2|_],Costo2),
    Costo =:= Costo2,
    E1 \= E2.

% Predicado que determina cuales son las ciudades "buena" más cercana a sus 
% ciudades grandes.
mejor(X):- 
    setof((Costo,Ciudad), buena(Ciudad,Costo), L), L =[(Min,_)|_],
    todos_mejores(Min,L,X).

% Predicado que retorna todas las ciudades buenas que tiene la menor distancia
% a sus ciudades grandes.
todos_mejores(M,L,X):- member((M,X),L).