:-[tdazonas].
:-[tdacommit].

/*gitInit(NombreRepo,Autor,RepoOutput):-
    nombreRep(NombreRepo),
    autor(Autor),
    zonas().*/
%
%
/*********** GIT ADD *******************/

% Verifica si un determinado archivo est� dentro del Workspace
miembroWorkspace(WS,Archivo,ConContenido):-workspaceSel(WS),buscarArchivo(Archivo,WS,ConContenido).
buscarArchivo(_,[],[]):-!,fail.
buscarArchivo(Archivo,[[Archivo|Contenido]|_],[Archivo|Contenido]):-!,true.
buscarArchivo(Archivo,[_|Cola],[Archivo|Contenido]):-buscarArchivo(Archivo,Cola,[Archivo|Contenido]).

%Agrega un archivo en la cabeza de una lista
agregarArchivo(Archivo,Lista,[Archivo|Lista]).
%Concatena 2 listas
concatenar([],L2,L2).
concatenar([Cabeza|Cola],L2,[Cabeza|R]):-
    concatenar(Cola,L2,R).
%Elimina elementos duplicados
deleteDup([], []).
deleteDup([Elemento|Lista], [Elemento|Lista3]) :- subtract(Lista, [Elemento], Lista2), deleteDup(Lista2, Lista3).
% En Output se guardan los archivos que que est�n dentro el Workspace,
% sin repetir
gitAddAux(_,[],_,Movidos,Movidos):-!.
gitAddAux(RepoInput,[Cabeza|Cola],WS,Salida,Output):-
    zonas(RepoInput),
    workspaceSel(WS),
    miembroWorkspace(WS,Cabeza,Archivo),
    agregarArchivo(Archivo,Salida,Movidos),
    deleteDup(Movidos,Movidos2),
    gitAddAux(RepoInput,Cola,WS,Movidos2,Output).
%gitAdd(Zonas,["file2","file1","file1"],WS,[],Movidos).

%Entrega una nueva versi�n de Zonas con el Index modificado
nuevoIndex(Index,[Cabeza|Cola],Movidos,NuevoIndex,NuevaZona):-
    indexSel(Index),
    gitAddAux(_,[Cabeza|Cola],_,[],Movidos),
    concatenar(Index,Movidos,NuevoIndex),
    setIndex(_,_,_,_,NuevoIndex,_,_,NuevaZona).
%nuevoIndex(Index,["file1","file2","file2"],Movidos,Nuevo,Zonas).

gitAdd(RepoInput,Archivos,RepoOutput):-
    zonas(RepoInput),
    is_list(Archivos),
    nuevoIndex(_,Archivos,_,_,RepoOutput).
%gitAdd(RepoInput,["file1","file1","file2"],RepoOutput).


/*gitCommit(RepoInput,Mensaje,RepoOutput):-
    zonas(RepoInput).


gitPush(RepoInput,RepoOutput):-
    zonas(RepoInput).

git2String(RepoInput,RepoAstring):-
    zonas(RepoInput).*/
