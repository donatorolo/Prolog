%% Pequena: determina si una ciudad es pequena, es decir si tiene a lo sumo
%% 			dos conexiones.
pequena(X) :- 
		setof(Y, (carril(X,Y);carril(Y,X)), L), 
	    length(L, Conexiones),
	    Conexiones < 3,
	    Conexiones > 0.

%% Grande: determina si una ciudad es grande, es decir si tiene al menos
%% 			tres conexiones.    
grande(X) :- setof(Y, (carril(X,Y);carril(Y,X)), L), 
	    length(L, Conexiones),
	    Conexiones >=3.
	      
%% Camino: avergiua TODOS los caminos desde "Inicio" hasta "Fin".
camino(Inicio,Fin,Camino,Costo) :-
		bfs(Inicio,Fin,Camino), 
		length(Camino,Costo).

%% Calcula el camino mas corto mediante el algoritmo de BFS.
bfs(Inicio,Fin,Camino) :- bfs_helper(Inicio,Fin,[],[],[],Camino).

bfs_helper(Inicio,Inicio,_,_,_,_):- !, fail.

bfs_helper(Inicio,Fin,Ruta,_,_,Camino):- 
        (carril(Inicio,Fin); carril(Fin,Inicio)),
         armar_camino(Inicio,Ruta,Camino,[Inicio,Fin]), !.

bfs_helper(Inicio,Fin,Ruta,Candidatos,Visitados,Camino):- 
        findall((Inicio,Y),((carril(Inicio,Y);carril(Y,Inicio)),
                    \+ member(Y,Visitados), \+ member((_,Y),Candidatos)),L),

        append(Candidatos,L,Candidatos2),
        append(Ruta,L,Ruta2),
        append(Visitados,[Inicio],Visitados2),
        Candidatos2 = [(_,Y)|Zs],
        bfs_helper(Y,Fin,Ruta2,Zs,Visitados2,Camino), !.
       
%% Funcion auxiliar que arma el camino desde inicio hasta el fin basado en la
%% ruta recorrida por el bfs.             
armar_camino(Inicio,Ruta,Temp,Temp):-
        \+ member((_,Inicio),Ruta).

armar_camino(Inicio,Ruta,Camino,Temp):-
        member((Padre,Inicio),Ruta),
        armar_camino(Padre,Ruta,Camino,[Padre|Temp]).


%% Buena: determina si una ciudad es pequena y su distancia a las dos ciudades 
%% 		  grandes mas cercanas es la misma.
buena(X,Costo):- pequena(X), grande(Y), grande(Z), Y \= Z, 
		camino(X,Y,[_,E1|_],Costo), camino(X,Z,[_,E2|_],Costo2),
		Costo =:= Costo2,
		E1 \= E2.

%% Mejor: determina cual es la mejor entre todas las ciudades buenas. 
mejor(X):- setof((Costo,Ciudad), buena(Ciudad,Costo), L), L =[(Min,_)|Ls],
		todos_mejores(Min,L,X).

todos_mejores(M,L,X):- member((M,X),L).

estacion(X):- mejor(X).