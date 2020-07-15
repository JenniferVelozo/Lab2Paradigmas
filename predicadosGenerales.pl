%Dominios
%ListaArchivos = lista de archivos
%ListaCommits = lista de commits
%Lista = lista
%Cantidad = numero que representa la cantidad de elementos de una lista
%Archivo = lista de 2 elementos, donde ambos son un string
%Commit = lista de 2 elementos, donde el primero es un string y el
%segundo es una lista de archivos
%NombreArchivo = string
%Elemento = lista, string, numero o atomo

%Predicados
%esListaArchivos(ListaArchivos).
%esListaCommits(ListaCommits).
%cuenta_elementos(Lista,Cantidad).
%is_file(Archivo).
%esMiembro(NombreArchivo,ListaArchivos,Archivo).
%agregarElemento(Elemento,Lista,Lista).
%concatenar(Lista,Lista,Lista).
%deleteDup(Lista,Lista).
%esListaStrings(Lista).


%Metas
%Primarias
%esListaArchivos(ListaArchivos).
%esListaCommits(ListaCommits).
%esMiembro(NombreArchivo,ListaArchivos,Archivo).
%agregarElemento(Elemento,Lista,Lista).
%concatenar(Lista,Lista,Lista).
%deleteDup(Lista,Lista).
%esListaStrings(Lista).


%Secundarias
%cuenta_elementos(Lista,Cantidad).
%is_file(Archivo).

%Clausulas de Horn
%Hechos
%Los hechos están comentados puesto que al momento de realizar una
%consulta, este arroja warnings indicando que los predicados no están
%juntos
%cuenta_elementos([],0).
%esListaArchivos([]).
%esListaCommits([]).
%esMiembro(Nombre,[[Nombre|Contenido]|_],[Nombre|Contenido]):-!.
%concatenar([],L2,L2).
%deleteDup([], []).
%esListaStrings([]).

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
is_file(Archivo):-
    is_list(Archivo),
    cuenta_elementos(Archivo,2),
    Archivo=[Nombre,Contenido],
    string(Nombre),string(Contenido).

% Predicado que verifica si una lista corresponde a una lista de
% archivos
% Entrada:lista
% Salida: true o false
% Tipo de recursión: de cola
esListaArchivos([]).
esListaArchivos([Cabeza|Cola]):-
    is_file(Cabeza),
    esListaArchivos(Cola).

%Predicado que verifica si un elemento correponde a una lista de commits
%Entrada: lista
%Salida: true o false
%Tipo de recursión: de cola
esListaCommits([]).
esListaCommits([Cabeza|Cola]):-
    esCommit(Cabeza),
    esListaCommits(Cola).


% Verifica si un determinado archivo(sólo nombre) está dentro de una lista
% En la variable ConContenido entrega el archivo con su contenido
% Predicado que permite consultar el valor que debe tomar ConContenido a
% partir de un nombre de archivo y una lista
% Entrada: nombre del archivo (string) y una lista
% Salida: archivo
% Tipo de recursión: de cola
esMiembro(_,[],_):-!,fail.
esMiembro(Nombre,[[Nombre|Contenido]|_],[Nombre|Contenido]):-!.
esMiembro(Nombre,[_|Cola],Archivo):- string(Nombre), esMiembro(Nombre,Cola,Archivo).

%Predicado que permite agregar un elemento en la cabeza de una lista
%Entrada: elemento y una lista
%Salida: lista con el elemento agregado en la cabeza de la lista
agregarElemento(Elemento,Lista,[Elemento|Lista]).

%Predicado que permite concatenar 2 listas
%Entrada: 2 listas
%Salida: lista (ambas unidas)
%Tipo de recursión: natural
concatenar([],L2,L2).
concatenar([Cabeza|Cola],L2,[Cabeza|R]):-
    concatenar(Cola,L2,R).

%Predicado que permite eliminar elementos duplicados en una lista
%Entrada:lista
%Salida: lista (sin elementos duplicados)
%Tipo de recursión: natural
deleteDup([], []).
deleteDup([Elemento|Lista], [Elemento|Lista3]) :- subtract(Lista, [Elemento], Lista2), deleteDup(Lista2, Lista3).

% Predicado que verifica que una lista tenga elementos de tipo
% string
% Entrada: lista
% Salida: true o false
% Tipo de recursión: de cola
esListaStrings([]).
esListaStrings([Cabeza|Cola]):-
    string(Cabeza),
    esListaStrings(Cola).
