# prologProject

--------------------------------------------------------------------------------
-- Proyecto: HProlog		                                                  --
--                                                                            --
-- Fecha: 27/02/2015                                                          --
--                                                                            --
-- Autor:                                                                     --
--         Carlos Aponte 09-10041                                             --
--         Donato Rolo   10-10640                                             --
--------------------------------------------------------------------------------

------------------------------------
    Introducción:
------------------------------------

    Con este archivo Readme se busca aclarar posibles dudas sobre el contenido 
de los archivos del proyectom de las funciones que se implementaron, su 
accionar, como se interrelacionan entre sí y las decisiones de diseno que se 
tomaron.


------------------------------------
    Problemas: 
------------------------------------

--------------
| Problema 1 |
--------------

	estaciones.pro -> se desea un predicato "estacion(X)" que unifique su 
		argumento las posibilidades de la mejor estación/ciudad. Para esto se
		toma en cuenta que:

		- Mejor Ciudad: la ciudad buena mas cercana a sus ciudades grandes.
		- Buena Ciudad: una ciudad pequena euidistante a sus dos ciudades
						grandes mas cercanas.
		- Pequena: una ciudad a lo sumo dos conexiones.
		- Grande: una ciudad con al menos tres conexiones.

			
	Los predicados elaborados para resolver dicho problema son:

		- estacion/1: unifica X con todas las ciudades/soluciones
		 	que pueden considerarse como "mejor".

		- pequena/1: tiene exito si unifica X con una ciudad pequena.

		- grande/1: tiene exito si unifica X con una ciudad grande.

		- bfs/3: tiene exito si unifica Camino con un
			camino optimo desde inicio hasta fin. 

		- bfs_helper/6: ejecutando el algoritmo de BFS recorre el grafo buscando
			la ruta optima desde el nodo I hasta el nodo F, tiene éxito si 
			unifica Cam con dicha ruta. 

		- armar_camino/4: recorre la ruta que tomo el BFS de Fin a inicio 
			armando el camino óptimo. Tiene éxito si unifica C con dicho camino.

		- buena/2: determina si una ciudad es buena y el costo a sus ciudades 
			grandes más cercanas. Tiene éxito si unifica X con esa ciudad y C 
			con dicho costo.

		- mejor/1: predicado que unifica X con una ciudad que cumpla las 
			condiciones necesarias.

		- todos_mejores/3: predicado auxiliar que unifica X con cada una de las 
			ciudades de la lista de buenas que pueden ser 
			consideradas como "mejor".

--------------
| Problema 2 |
--------------

	estrellas.pro -> se desea un predicado "estrella(X)" que sea capaz de 
		unificar X con una estrella mágica o que dado un X verifique si es una 
		estrella mágica. Se entiende por estrella mágica de N puntas a una 
		estrella polígono en la cual hay un número en cada vértice e intersección 
		y la suma de estos en cada línea es igual a 4N + 2. Una estrella mágica 
		contiene números en el rango 1..2N sin repeticiones.

		Para nustro problema en particular resovleremos el problema para N = 8,
		es decir una estrella de 8 puntas.

	Los predicados elaborados para resolver dicho problema son:

		- estrella/1: predicado capaz de unificar X con una estrella mágica o
			dado un X ya unificado verificar si este es una estrella mágica.

		- check/4: regla que verifica si los elementos de la linea suman 
			34 (4 * N + 2).

		- checkValues/1: predicado que verifica si los valores de L estan entre
			el 1 y 16 (2*N).

		-checkGreen/1: predicado que chequea el lado izquierdo de ambos 
			cuadrados (esta línea la llamamos línea verde, sírvase de ver la 
			imagen "estrella" ubicada en esta misma carpeta para más claridad).

		-checkBlue/1: predicado que chequea el lado superior de ambos cuadrados 
			(esta línea la llamamos línea azul, sírvase de ver la imagen 
			"estrella" ubicada en esta misma carpeta para más claridad).

		-checkYellow/1: predicado que chequea el lado inferior de ambos 
			cuadrados (esta línea la llamamos línea amarilla, sírvase de ver la 
			imagen "estrella" ubicada en esta misma	carpeta para más claridad).

		-checkOrange/1: predicado que chequea el lado derecho de ambos cuadrados 
			(esta línea la llamamos línea naranja, sírvase de ver la imagen 
			"estrella" ubicada en esta misma carpeta para más claridad).

		-generate/1: predicado que genera las estrellas mágicas asegurándose de 
			que cumplan todas las condiciones previamente establecidas.

		-genNumeros/2: predicado que genera los numeros de 1 hasta N.
		  
--------------
| Problema 3 |
--------------
	
	laberinto.pro -> se desea ser capaz de leer, resolver y escribir un laberinto
		rectangular de tamano MxN, siendo estos el numero de filas y columnas
		respectivamente. En este laberinto tenemos que:

		- Los espacios abiertos estan representados por espacios " ".
		- Los espacios cerrados/muros estan representados por numerales "#".
		- Los puntos de la solucion estan representados por puntos ".".

	Los predicados elaborados para resolver dicho problema son:

		- leer/3: predicado que se encarga de recibir un nombre de archivo,
			leer su contenido,interpretarlo y unificarlo con una lista "L" de
			puntos abiertos. Asi mismo, se encarga de unificar M y N con el 
			numero de filas y columnas respectivamente.

		- resolver/4: predicado que toma las medidas M y N del laberinto así 
			como la lista de puntos abiertos "A" y de determinar todos los 
			caminos "C" que lleven del inicio (0,0) a las salida.

		- escribir/4: pedicado que toma las medidad M y N del laberinto	así como 
			una lista de puntos abiertos "A" y una solución "C" del laberinto y 
			escribe por salida estándar dicho laberinto con su respectiva 
			solución.

		- resolver_optimo/4: predicado extra que retorna una solución óptima 
			para cada salida que exista en el grafo. Esto, mediante el uso del 
			algoritmo BFS.

		- arriba/4: predicados que da las cordenadas resultantes luego de 
			moverse hacia arriba en el eje Y (una fila menos).

		- abajo/4: predicados que da las cordenadas resultantes luego de moverse 
			hacia abajo en el eje Y (una fila más).

		- derecha/4: predicados que da las cordenadas resultantes luego de 
			moverse hacia la derecha en el eje X (una columna más).

		- izquierda/4: predicados que da las coordenadas resultantes luego de 
			moverse hacia la izquierda en el eje X (una columna menos).

		- valido/4: predicado que determina si un punto está dentro del 
			laberinto.

		- moverse/4: predicado que determina todos los movimientos desde un 
			punto de inicio (x,y).

		- vecino/7: predicado que determina si un punto es vecino de otro.

		- salida/4: predicado que determina si un punto es salida del laberinto. 
			Para esto se ve si es un punto abierto y esta en la última columna.

		- camino/8: predicado que calcula los caminos "C" desde el punto 
			(Xini,Yini) hasta (Xfin,Yfin) a traves de los puntos abiertos en la 
			lista "A".

		- calcular/9: predicado	que recorre el laberinto en busca de la salida 
			tomando la decisión de hacia donde moverse dependiendo de los casos 
			presentados. Tiene éxito si logra unificar "C" con un camino hasta 
			la salida.

		- bfs/8: tiene éxito si unifica Camino con un camino óptimo desde inicio 
			hasta fin. 

		- bfs_helper/11: ejecutando el algoritmo de BFS recorre el laberinto 
			buscando la ruta óptima desde la entrada a cada una de las salidas 
			existentes. Tiene éxito si logra unificar "Cam" con dicha solución.

		- armar_camino/5: recorre la ruta que tomo el BFS de Fin a inicio 
			armando el camino óptimo. Tiene éxito si unifica C con dicho camino.

		- procesar_lectura/8: predicado que se encarga de interpretar los 
			caracteres leídos del archiv "S". Determinando las dimensiones M y 
			N, así como la lista "A" de puntos abiertos.

		- procesar_escritura/6: predicado que se encarga de imprimir en salida 
			estándar un laberinto dada una lista de espacios abiertos y un 
			camino/solucion.

		- siguiente/6: predicado que determina cual es el siguiente punto a 
			imprimir dentro del laberinto asumiendo que este se recorre de 
			izquierda a derecha y de arriba abajo.

--------------
| Problema 4 |
--------------
	
	unificacion.pro -> se desea implantar el Algoritmo de Unificación de Prolog
		 con “Occurs Check” para garantizar terminación. Para esto se debe 
		 dar un predicado unifica(X,Y) que tendrá éxito en el caso que sus 
		 argumentos de entrada unifiquen y falle en caso contrario.

    Los predicados elaborados para resolver dicho problema son:

    	- unificacion/2: este predicado, se encarga de realizar la unificacion
    	entre dos términos U y V.

    	- unificarArgumentos/5: este predicado recibe dos functores, un contador
    	para ayudar a unificar los parámetros de los mismos, y el número de 
    	parámetros de dichos functores (ambos functores deben tener la misma
    	cantidad de parámetros).

------------------------------------   
      Decisiones de Diseño
------------------------------------ 
     
    1) Implementación de BFS: se decidio implementar el algoritmo de BFS para 
    		el problema 1 ya que esto mejora considerablemente la velocidad
    		con que se consigue la respuesta del mismo. Al usar este algoritmo
    		garantizamos que las dos primeras ciudades grandes que encontremos
    		serán las más cercanas y en ese momento podemos comparar sus 
    		distancias y no tener que buscar otras posibilidades, las cuales no
    		serian útiles.

    2) Generar Estrellas Mágicas: para verificar si una estrella es mágica, es 
    		una simple verificación de suma de valores. Ahora para generar todas 
    		las estrellas mágicas, se van probando los valores uno a uno, y se 
    		descartan aquellas las soluciones erróneas lo más pronto posible.

     
	3) Puntos del Laberinto --> Se toman los puntos como tuplan de coordenadas
			(X,Y), siendo "X" la referente a la fila y "Y" a la columna.

	4) Resolucion Optima del Laberinto -> se decidio implementar un predicado
			extra llamado "resolver_optimo" el cual optiene una ruta optima para 
			cada posible salida del laberinto, siendo necesario para esto que se
			modificara el algoritmo de BFS implementado para el problema 1.
        
