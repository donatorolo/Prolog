f(1).
f(2).
f(3).

unificacion(X,Y):-
	X = Y.
	

match(U,V) :- 
   var(U), 
   ground(V),
   U = V.  % U assigned value V

% match grounded terms
match(U,V) :- 
   ground(U), 
   ground(V),
   U == V.

% match compound terms
match(U,V) :- 
   \+var(U), 
   ground(V),
   functor(U,Functor,Arity),
   functor(V,Functor,Arity),
   matchargs(U,V,1,Arity).

% match arguments, left-to-right
matchargs(_,_,N,Arity) :- 
   N > Arity.
matchargs(U,V,N,Arity) :- 
   N =< Arity,
   arg(N,U,ArgU),
   arg(N,V,ArgV), 
   match(ArgU,ArgV), 
   N1 is N+1, 
   matchargs(U,V,N1,Arity).