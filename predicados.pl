:-[tdazonas].
:-[tdacommit].

/************** GIT INIT *****************/

gitInit(NombreRepo,Autor,RepoOutput):-
    workspace(WS),
    indexx(Index),
    localR(LR),
    remoteR(RR),
    zonasCons(NombreRepo,Autor,_,WS,Index,LR,RR,RepoOutput).

/*********** GIT ADD *******************/

% Verifica si un determinado archivo est� dentro del Workspace
miembroWorkspace(WS,Archivo,ConContenido):-buscarArchivo(Archivo,WS,ConContenido).
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
    is_list(RepoInput),
    workspaceSel(RepoInput,WS),
    miembroWorkspace(WS,Cabeza,Archivo),
    agregarArchivo(Archivo,Salida,Movidos),
    deleteDup(Movidos,Movidos2),
    gitAddAux(RepoInput,Cola,WS,Movidos2,Output).
%gitAdd(Zonas,["file2","file1","file1"],WS,[],Movidos).

%Entrega una nueva versi�n de Zonas con el Index modificado
nuevoIndex(RepoInput,Index,[Cabeza|Cola],Movidos,NuevoIndex,NuevaZona):-
    indexSel(RepoInput,Index),
    gitAddAux(RepoInput,[Cabeza|Cola],_,[],Movidos),
    concatenar(Index,Movidos,NuevoIndex),
    setIndex(RepoInput,NuevoIndex,NuevaZona).
%nuevoIndex(Index,["file1","file2","file2"],Movidos,Nuevo,Zonas).

gitAdd(RepoInput,Archivos,RepoOutput):-
    is_list(RepoInput),
    is_list(Archivos), %se verifica que los archivos ingresados correspondan a una lista
    nuevoIndex(RepoInput,_,Archivos,_,_,RepoOutput).
%gitAdd(RepoInput,["file1","file1","file2"],RepoOutput).

/************** GIT COMMIT ***********************/

% si los cambios entregados est�n vac�os, quiere decir que no hay
% cambios en el index
nuevoLocalR(RepoInput,_,_,[],_,RepoInput):-!,write("No hay cambios en el index").
nuevoLocalR(RepoInput,LocalR,Mensaje,Cambios,NuevoLocalR,NuevaZona2):-
    localRSel(RepoInput,LocalR), %se obtiene el local repository
    commitCons(_,Mensaje,Cambios,Commit), %se crea un commit en base a la fecha, mensaje y cambios
    agregarArchivo(Commit,LocalR,NuevoLocalR), %se agrega el commit al local repository
    setLocalR(RepoInput,NuevoLocalR,NuevaZona), %se modifica el local repository
    setIndex(NuevaZona,[],NuevaZona2). %se modifica el index, quedando vac�o

gitCommit(RepoInput,Mensaje,RepoOutput):-
    is_list(RepoInput),
    string(Mensaje), %se verifica que el mensaje sea un string
    indexSel(RepoInput,Cambios), %se obtiene el index, que corresponde a los cambios
    nuevoLocalR(RepoInput,_,Mensaje,Cambios,_,RepoOutput). %se modifica el local repository, quedando una nueva zona en RepoOutput


/*gitPush(RepoInput,RepoOutput):-
    zonas(RepoInput).*/

git2String(RepoInput,RepoAsString):-
    is_list(RepoInput),
    string_concat("","###### Repositorio '",S1),
    nombreSel(RepoInput,Nombre),
    text_to_string(Nombre,NombreStr),
    string_concat(S1,NombreStr,S2),
    string_concat(S2,"' ######\n",S3),
    string_concat(S3,"Fecha de creaci�n: ",S4),
    fechaSel(RepoInput,Fecha),
    text_to_string(Fecha,FechaStr),
    string_concat(S4,FechaStr,S5),
    string_concat(S5,"\nAutor: ",S6),
    autorSel(RepoInput,Autor),
    text_to_string(Autor,AutorStr),
    string_concat(S6,AutorStr,RepoAsString).





