%Dominios
%ListaArchivos = lista de archivos
%ListaCommits = lista de commits
%Lista = lista
%Cantidad = numero que representa la cantidad de elementos de una lista
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
%buscarArchivo(NombreArchivo,ListaArchivos,Archivo).
%is_file(Archivo).
%deleteDup(Lista,Lista).
%esListaStrings(Lista).

%Clausulas de Horn
%Hechos

%Reglas
%Predicado que permite obtener el numero de elementos de una lista
%Entrada: lista
%Salida: numero que representa la cantidad de elementos de la lista
%Tipo de recursión: natural
cuenta_elementos([],0).
cuenta_elementos([_|Lista],Cantidad):-cuenta_elementos(Lista,Tam), Cantidad is Tam+1.

%Predicado que verifica si un elemento corresponde a un archivo
%Entrada: archivo
%Salida: true o false
is_file([Nombre|Contenido]):-
    cuenta_elementos([Nombre|Contenido],2),
    string(Nombre),
    Contenido=[Cabeza|_],
    string(Cabeza).

% Predicado que verifica si un elemento corresponde a una lista de
% archivos
% Entrada:lista
% Salida: true o false
esListaArchivos([]).
esListaArchivos([Cabeza|Cola]):-
    is_list(Cabeza),
    is_file(Cabeza),
    esListaArchivos(Cola).

%Predicado que verifica si un elemento correponde a una lista de commits
%Entrada: lista
%Salida: true o false
esListaCommits([]).
esListaCommits([Cabeza|Cola]):-
    is_list(Cabeza),
    esCommit(Cabeza),
    esListaCommits(Cola).


% Verifica si un determinado archivo(sólo nombre) está dentro de una lista
% en la variable ConContenido entrega el archivo con su contenido
esMiembro(Lista,Archivo,ConContenido):-buscarArchivo(Archivo,Lista,ConContenido).
buscarArchivo(_,[],_):-!,fail.
buscarArchivo(Archivo,[[Archivo|Contenido]|_],[Archivo|Contenido]):-!,true.
buscarArchivo(Archivo,[_|Cola],ConContenido):-buscarArchivo(Archivo,Cola,ConContenido).

%Predicado que permite agregar un elemento en la cabeza de una lista
%Entrada: elemento y una lista
%Salida: lista con el elemento agregado en la cabeza de la lista
agregarElemento(Elemento,Lista,[Elemento|Lista]).

%Predicado que permite concatenar 2 listas
%Entrada: 2 listas
%Salida: lista (ambas unidas)
concatenar([],L2,L2).
concatenar([Cabeza|Cola],L2,[Cabeza|R]):-
    concatenar(Cola,L2,R).

%Predicado que permite eliminar elementos duplicados en una lista
%Entrada:lista
%Salida: lista (sin elementos duplicados)
deleteDup([], []).
deleteDup([Elemento|Lista], [Elemento|Lista3]) :- subtract(Lista, [Elemento], Lista2), deleteDup(Lista2, Lista3).

% Predicado que verifica que una lista tenga elementos de tipo
% string
% Entrada: lista
% Salida: true o false
esListaStrings([]).
esListaStrings([Cabeza|Cola]):-
    string(Cabeza),
    esListaStrings(Cola).
