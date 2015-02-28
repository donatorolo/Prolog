
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programación Lógica - Tarea       %
%                                       %
%   Carlos Aponte           09-10041    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3.- Laberintos Rectangulares

% Predicado que lee de un laberinto del archivo de texto indicado.
leer(L,M,N):- 
    write('Por favor, introduzca el nombre del archivo a leer:  '),
        read(Archivo),
        atom_codes(Archivo2,Archivo),
        open(Archivo2,read,Stream),
        read_integer(Stream,N),
        write(N),
        get_char(Stream,_), %elimina el primer salto de linea
        get_char(Stream,Caracter),
        procesar_lectura(Caracter, Stream, 0, 0, M,N, L, []),
        write(M),
        close(Stream).

% Predicado que resuelve el laberinto dando como resultado TODOS los caminos a
% cada salida.
resolver(Abiertos,M,N, Camino):-
    salida(Xs,Ys,N,Abiertos),
    camino(0,0, Xs,Ys, M,N, Abiertos, Camino),
    \+ length(Camino,0).

% Predicado que escribe por salida estándar un laberinto y su solución.
escribir(Solucion,Original,M,N):-
    write('\n'),
    procesar_escritura(0,0,Solucion,Original,M,N), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%% PREDICADOS AUXILIARES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Predicado que resuelve el laberinto dando como resultado solamente el mejor 
% camino a cada salida.
resolver_optimo(Abiertos,M,N, Camino):-
    salida(Xs,Ys,N,Abiertos),
    bfs(0,0, Xs,Ys, M,N, Abiertos, Camino),
    \+ length(Camino,0).

% Predicados que dan las coordenadas luego de moverse en determinada dirección
% desde el punto de inicio.
arriba(X,Y,X,Y2):- Y2 is Y-1.
abajo(X,Y,X,Y2):- Y2 is Y+1.
derecha(X,Y,X2,Y):- X2 is X+1.
izquierda(X,Y,X2,Y):- X2 is X-1.

% Predicado que determina si un punto esta dentro del laberinto.
valido(X,Y,M,N):-
     X >= 0,
     X < M, 
     Y>=0, 
     Y < N.

% Predicado que determina todos los movimientos desde un punto de inicio.
moverse(X,Y,X2,Y2):- 
    arriba(X,Y,X2,Y2); 
    abajo(X,Y,X2,Y2);
    derecha(X,Y,X2,Y2); 
    izquierda(X,Y,X2,Y2).

% Predicado que determina si un punto es vecino de otro.
vecino(X,Y,VX,VY,M,N,A):- 
    member(punto(VX,VY),A), valido(VX,VY, M,N),
    moverse(X,Y,VX,VY).

% Predicado que determina si un punto es salida del laberinto.
salida(X,Y,N,L):- 
    (Y is N-1),
    member(punto(X,Y),L).

% Predicado que calcula un camino desde el (Xini,Yini) hasta un (Xfin,Yfin).
camino(Xini,Yini,Xfin,Yfin,M,N,Abiertos,Camino):-
    calcular(Xini, Yini, Xfin,Yfin,M,N,Camino,Abiertos,[]).
    
% Caso en que quiera un camino de un punto a sí mismo.
calcular(Xini, Yini, Xini,Yini,_,_,_,_,_):- !, fail.

% Caso en que el punto actual es vecino del destino.
calcular(Xini, Yini, Xfin,Yfin,M,N,Camino,Abiertos,Visitados) :- 
    vecino(Xini, Yini, Xfin,Yfin,M,N,Abiertos),
    reverse([punto(Xfin,Yfin),punto(Xini,Yini)|Visitados],Camino).
    
% Caso en que debo buscar uno o mas puntos intermedios.    
calcular(Xini,Yini,Xfin,Yfin,M,N,Camino,Abiertos,Visitados) :- 
    vecino(Xini,Yini,Xi,Yi,M,N,Abiertos),
    \+ member(punto(Xi,Yi),Visitados),
    calcular(Xi,Yi,Xfin,Yfin,M,N,Camino,Abiertos,[punto(Xini,Yini)|Visitados]). 


% Predicado que calcula un camino óptimo (más corto) desde (Xini,Yini) hasta un 
% (Xfin,Yfin) usando el algoritmo de BFS.
bfs(Xini,Yini,Xfin,Yfin,M,N,Abiertos,Camino) :- 
    bfs_helper(Xini,Yini,Xfin,Yfin,M,N,Abiertos,[],[],[],Camino).

% Caso en que quiera un camino de un punto a sí mismo.
bfs_helper(Xini,Yini,Xini,Yini,_,_,_,_,_,_,_):- !, fail.

% Caso en que el punto actual es vecino del destino.
bfs_helper(Xini,Yini,Xfin,Yfin,M,N,Abiertos,Ruta,_,_,Camino):- 
    vecino(Xini,Yini,Xfin,Yfin,M,N,Abiertos),
    armar_camino(Xini,Yini,Ruta,Camino, [punto(Xini,Yini),punto(Xfin,Yfin)]), !.

% Caso en que debo buscar uno o más puntos intermedios.
bfs_helper(Xini,Yini,Xfin,Yfin,M,N,Abiertos,Ruta,Candidatos,Visitados,Camino):- 
    findall((punto(Xini,Yini),punto(Xi,Yi)),
            (vecino(Xini, Yini, Xi,Yi,M,N,Abiertos),
            \+ member(punto(Xi,Yi),Visitados), 
            \+ member(punto(Xi,Yi),Candidatos)),L),
    append(Candidatos,L,Candidatos2),
    append(Ruta,L,Ruta2),
    append(Visitados,[punto(Xini,Yini)],Visitados2),
    Candidatos2 = [(_,punto(Xy,Yy))|Zs],
    bfs_helper(Xy,Yy,Xfin,Yfin,M,N,Abiertos,Ruta2,Zs,Visitados2,Camino), !.
             
% Predicado que arma el camino desde el inicio hasta el fin basado en la
% ejecución del BFS.
% Caso en que estoy en el nodo inicial y por tanto no hay antecesor.
armar_camino(Xini,Yini,Ruta,Temp,Temp):-
    \+ member((_,punto(Xini,Yini)),Ruta).

%% Caso para detectar el antecesor del nodo actual.
armar_camino(Xini,Yini,Ruta,Camino,Temp):-
    member((punto(XPadre,YPadre),punto(Xini,Yini)),Ruta),
    armar_camino(XPadre,YPadre,Ruta,Camino,[punto(XPadre,YPadre)|Temp]).

% Predicado que se encarga de interpretar los caracteres leidos del archivo.
% Caso que procesa la lectura en el Fin del Archivo.
procesar_lectura(end_of_file,_,X,_,M,_,Abiertos,Temp):-
    M is X+1,
    reverse(Temp,Abiertos), !.

% Procesa la lectura cuando el caracter es un espacio en blanco.
procesar_lectura(' ',Stream,X,Y,M,N,Abiertos,Temp):- 
    get_char(Stream,Caracter2), 
    Y2 is Y+1,
    procesar_lectura(Caracter2,Stream,X,Y2,M,N,Abiertos,[punto(X,Y)|Temp]).

% Caso que procesa la lectura cuando el caracter es un #.
procesar_lectura('#',Stream,X,Y,M,N,Abiertos,Temp):- 
    get_char(Stream,Caracter2),  
    Y2 is Y+1,
    procesar_lectura(Caracter2,Stream,X,Y2,M,N,Abiertos,Temp).

% Caso que procesa la lectura cuando el caracter es salto de línea.
procesar_lectura('\n',Stream,X,_,M,N,Abiertos,Temp):- 
    get_char(Stream,Caracter2), 
    X2 is X+1,
    procesar_lectura(Caracter2,Stream,X2,0,M,N,Abiertos,Temp).


% Predicado que se encarga de imprimir un laberinto dada una lista de espacios
% abiertos y un camino/solución.

% Caso que se detiene al haber impreso todo el laberinto.
procesar_escritura(M,N,_,_,M,N):-!.

% Caso que verifica si el punto es parte de la solución.
procesar_escritura(X,Y,Solucion,Original,M,N):- 
    member(punto(X,Y), Solucion),
    delete(Solucion, punto(X,Y), Sol2),
    delete(Original, punto(X,Y), Ori2),
    write('.'),
    siguiente(X,Y,XN,YN,M,N),
    procesar_escritura(XN,YN,Sol2,Ori2,M,N).

% Caso que verifica si el punto es parte de los puntos abiertos originales.
procesar_escritura(X,Y,Solucion,Original,M,N):- 
    member(punto(X,Y), Original),
    delete(Solucion, punto(X,Y), Sol2),
    delete(Original, punto(X,Y), Ori2),
    write(' '),
    siguiente(X,Y,XN,YN,M,N),
    procesar_escritura(XN,YN,Sol2,Ori2,M,N).    

% Caso en que el punto es un punto cerrado/pared.
procesar_escritura(X,Y,Solucion,Original,M,N):- 
    write('#'),
    siguiente(X,Y,XN,YN,M,N),
    procesar_escritura(XN,YN,Solucion,Original,M,N).

% Predicado que determina cuál es el siguiente punto a imprimir dentro del 
% laberinto asumiendo que este se recorre de izquierda a derecha y de arriba 
% abajo.
% Caso en el que el siguiente pto no pertenece al laberinto.
siguiente(X,Y,M,N,M,N):-  Z is Y+1, Z=N, W is X+1, W is M, !.

% Caso en el que se imrpimio una fila completa y se procede a la de abajo.
siguiente(X,Y,XN,YN,M,N):- 
    Z is Y+1, Z = N, XN is X+1, XN<M, YN is 0,
    write('\n'), !.

% Caso en el que se imprimió un elemento de una fila y se procede al siguiente.
siguiente(X,Y,X,YN,M,N):-  Z is Y+1, Z < N, YN is Y+1, X <M, !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%