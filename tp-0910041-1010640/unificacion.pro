
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programación Lógica - Tarea       %
%                                       %
%   Carlos Aponte           09-10041    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4.- Unificación

% Caso donde U y V son variables.
unificacion(U,V) :- 
  var(U), 
  var(V),
  U = V.

% Caso donde U es variable y V tiene un valor unificado y viceversa
unificacion(U,V) :- 
   var(U), 
   ground(V),
   U = V.
unificacion(V,U) :- 
   var(U), 
   ground(V),
   U = V.

% Caso en donde U y V están unificados
unificacion(U,V) :- 
   ground(U), 
   ground(V),
   U == V.

% Caso donde U es un functor y V tiene un valor unificado y viceversa
unificacion(U,V) :- 
   \+var(U), 
   ground(V),
   functor(U,Functor,Arity),
   functor(V,Functor,Arity),
   unificarArgumentos(U,V,1,Arity).
unificacion(V,U) :- 
   \+var(U), 
   ground(V),
   functor(U,Functor,Arity),
   functor(V,Functor,Arity),
   unificarArgumentos(U,V,1,Arity).

% Caso en donde U y V son functores
unificacion(U,V):-
    \+var(U),
    \+var(V),
    functor(U,Functor,Arity),
    functor(V,Functor,Arity),
    unificarArgumentos(U,V,1,Arity).

%%%%%%%%%%%%%%%%%%%%%%%%%%% Predicados Auxiliares %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Caso para unificar los parametros de los 'functores'
unificarArgumentos(_,_,N,Arity) :- 
   N > Arity.
unificarArgumentos(U,V,N,Arity) :- 
   N =< Arity,
   arg(N,U,ArgU),
   arg(N,V,ArgV), 
   unificacion(ArgU,ArgV),
   N1 is N+1, 
   unificarArgumentos(U,V,N1,Arity).
unificarArgumentos(V,U,N,Arity) :- 
   N =< Arity,
   arg(N,U,ArgU),
   arg(N,V,ArgV), 
   unificacion(ArgU,ArgV),
   N1 is N+1, 
   unificarArgumentos(U,V,N1,Arity).