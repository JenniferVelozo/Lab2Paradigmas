%Dominios
%ListaArchivos = lista de archivos
%ListaCommits = lista de commits
%Lista = lista
%Cantidad = numero
%Archivo = lista de 2 elementos, donde ambos son un string
%Commit = lista de 2 elementos, donde el primero es un string y el
%segundo es una lista de archivos
%NombreArchivo = string
%Elemento = lista o string

%Predicados
%esListaArchivos(ListaArchivos).
%esListaCommits(ListaCommits).
%cuenta_elementos(Lista,Cantidad).
%is_file(Archivo).
%esMiembro(Lista,Archivo,ConContenido).
%buscarArchivo(NombreArchivo,ListaArchivos,Archivo).
%agregarElemento(Elemento,Lista,Lista).
%concatenar(Lista,Lista,Lista).
%deleteDup(Lista,Lista).
%esListaStrings(Lista).


%Metas
%Primarias
%esListaArchivos(ListaArchivos).
%esListaCommits(ListaCommits).
%esMiembro(Lista,Archivo,ConContenido).
%agregarElemento(Elemento,Lista,Lista).
%concatenar(Lista,Lista,Lista).

%Secundarias
%cuenta_elementos(Lista,Cantidad).
%is_file(Archivo).
%deleteDup(Lista,Lista).
%esListaStrings(Lista).

%Clausulas de Horn
%Reglas
%Predicado que permite obtener el numero de elementos de una lista
cuenta_elementos([],0).
cuenta_elementos([_|Lista],Cantidad):- cuenta_elementos(Lista,Tam), Cantidad is Tam+1.

%Predicado que verifica si un elemento corresponde a un archivo
is_file([Nombre|Contenido]):-
    cuenta_elementos([Nombre|Contenido],2),
    string(Nombre),
    Contenido=[Cabeza|_],
    string(Cabeza).
% Predicado que verifica si un elemento corresponde a una lista de
% archivos
esListaArchivos([]).
esListaArchivos([Cabeza|Cola]):-
    is_list(Cabeza),
    is_file(Cabeza),
    esListaArchivos(Cola).
%Predicado que verifica si un elemento correponde a una lista de commits
esListaCommits([]).
esListaCommits([Cabeza|Cola]):-
    is_list(Cabeza),
    esCommit(Cabeza),
    esListaCommits(Cola).


% Verifica si un determinado archivo(s�lo nombre) est� dentro de una lista
% en la variable ConContenido entrega el archivo con su contenido
esMiembro(Lista,Archivo,ConContenido):-buscarArchivo(Archivo,Lista,ConContenido).
buscarArchivo(_,[],[]):-!,fail.
buscarArchivo(Archivo,[[Archivo|Contenido]|_],[Archivo|Contenido]):-!,true.
buscarArchivo(Archivo,[_|Cola],[Archivo|Contenido]):-buscarArchivo(Archivo,Cola,[Archivo|Contenido]).

%Agrega un elemento en la cabeza de una lista
agregarElemento(Elemento,Lista,[Elemento|Lista]).
%Concatena 2 listas
concatenar([],L2,L2).
concatenar([Cabeza|Cola],L2,[Cabeza|R]):-
    concatenar(Cola,L2,R).
%Elimina elementos duplicados
deleteDup([], []).
deleteDup([Elemento|Lista], [Elemento|Lista3]) :- subtract(Lista, [Elemento], Lista2), deleteDup(Lista2, Lista3).

%verifica que una lista tenga elementos de tipo string
esListaStrings([]).
esListaStrings([Cabeza|Cola]):-
    string(Cabeza),
    esListaStrings(Cola).
