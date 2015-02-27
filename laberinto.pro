
%%  X es la fila 
%%  Y es la columna

arriba(X,Y,X,Y2):- Y2 is Y-1.
abajo(X,Y,X,Y2):- Y2 is Y+1.
derecha(X,Y,X2,Y):- X2 is X+1.
izquierda(X,Y,X2,Y):- X2 is X-1.

valido(X,Y,M,N):- X >= 0, X < M, Y>=0, Y < N.

moverse(X,Y,X2,Y2):- 
		arriba(X,Y,X2,Y2); abajo(X,Y,X2,Y2);
		derecha(X,Y,X2,Y2);  izquierda(X,Y,X2,Y2).

vecino(X,Y,VX,VY,M,N,A):- 
		member(punto(VX,VY),A), valido(VX,VY, M,N),
		moverse(X,Y,VX,VY).


salida(X,Y,N,L):- 
		(Y is N-1), member(punto(X,Y),L).

camino(Xini,Yini,Xfin,Yfin,M,N,Abiertos,Camino):-
		calcular(Xini, Yini, Xfin,Yfin,M,N,Camino,Abiertos,[]).
								
calcular(Xini, Yini, Xini,Yini,_,_,_,_,_):- !, fail.

calcular(Xini, Yini, Xfin,Yfin,M,N,Camino,Abiertos,Visitados) :- 
		vecino(Xini, Yini, Xfin,Yfin,M,N,Abiertos),
		reverse([punto(Xfin,Yfin), punto(Xini,Yini)|Visitados],Camino).
			    
calcular(Xini, Yini, Xfin,Yfin,M,N,Camino,Abiertos,Visitados) :- 
		vecino(Xini, Yini, Xi,Yi,M,N,Abiertos),
   		\+ member(punto(Xi,Yi),Visitados),
   		calcular(Xi,Yi,Xfin,Yfin,M,N,Camino,Abiertos,[punto(Xini,Yini)|Visitados]). 


resolver(Abiertos,M,N, Camino):-
		salida(Xs,Ys,N,Abiertos),
		camino(0,0, Xs,Ys, M,N, Abiertos, Camino),
		\+ length(Camino,0).


leer(L,M,N):- 
		write('Por favor, introduzca el nombre del archivo a leer:  '),
 	    read(Archivo),
 	    open(Archivo,read,Stream),
	    read_integer(Stream,N),
	    get_char(Stream,_), %elimina el salto de linea
	    get_char(Stream,Caracter),
	    procesar_lectura(Caracter, Stream, 0, 0, M,N, L, []),
        close(Stream).


%% Fin del Archivo
procesar_lectura(end_of_file,_,_,Y,Y,_,Abiertos,Temp):-
		reverse(Temp,Abiertos), !.

%% El caracter es un espacio en blanco
procesar_lectura(' ',Stream,X,Y,M,N,Abiertos,Temp):- 
		get_char(Stream,Caracter2), 
    	Y2 is Y+1,
    	procesar_lectura(Caracter2,Stream,X,Y2,M,N,Abiertos,[punto(X,Y)|Temp]).


%% El caracter es un #
procesar_lectura('#',Stream,X,Y,M,N,Abiertos,Temp):- 
		get_char(Stream,Caracter2),  
		Y2 is Y+1,
    	procesar_lectura(Caracter2,Stream,X,Y2,M,N,Abiertos,Temp).

%%  El caracter es salto de linea
procesar_lectura('\n',Stream,X,_,M,N,Abiertos,Temp):- 
		get_char(Stream,Caracter2), 
    	X2 is X+1,
    	procesar_lectura(Caracter2,Stream,X2,0,M,N,Abiertos,Temp).


escribir(Solucion,Original,M,N):-
		write('Por favor, introduzca el nombre del archivo destino:  '),
 	    read(Archivo),
 	    open(Archivo,write,Stream),
 	    procesar_escritura(Stream,0,0,Solucion,Original,M,N),
        close(Stream), !.


procesar_escritura(Stream,M,N,Solucion,Original,M,N):-!.

 %% Verifica Si el pto es parte de la solucion.
procesar_escritura(Stream,X,Y,Solucion,Original,M,N):- 
	    member(punto(X,Y), Solucion),
	    delete(Solucion, punto(X,Y), Sol2),
	    delete(Original, punto(X,Y), Ori2),
		write(Stream,'.'),
		siguiente(Stream, X,Y,XN,YN,M,N),
		procesar_escritura(Stream,XN,YN,Sol2,Ori2,M,N).

%% Verifica si el pto es parte de los ptos abiertos originales.
procesar_escritura(Stream,X,Y,Solucion,Original,M,N):- 
	    member(punto(X,Y), Original),
	    delete(Solucion, punto(X,Y), Sol2),
	    delete(Original, punto(X,Y), Ori2),
		write(Stream,' '),
		siguiente(Stream, X,Y,XN,YN,M,N),
		procesar_escritura(Stream,XN,YN,Sol2,Ori2,M,N).		

%% Verifica si el pto es parte de los ptos abiertos originales.
procesar_escritura(Stream,X,Y,Solucion,Original,M,N):- 
	    write(Stream,'#'),
		siguiente(Stream, X,Y,XN,YN,M,N),
		procesar_escritura(Stream,XN,YN,Solucion,Original,M,N).

siguiente(_,X,Y,M,N,M,N):-  Z is Y+1, Z=N, W is X+1, W is M, !.

siguiente(Stream,X,Y,XN,YN,M,N):- 
			Z is Y+1, Z = N, XN is X+1, XN<M, YN is 0,
			write(Stream,'\n'), !.

siguiente(_,X,Y,X,YN,M,N):-  Z is Y+1, Z < N, YN is Y+1, X <M, !.
