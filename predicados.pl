:-[tdarepositorio].
:-[tdacommit].
:-[predicadosGenerales].
/************** GIT INIT *****************/

gitInit(NombreRepo,Autor,RepoOutput):-
    workspace(WS),
    indexx(Index),
    localR(LR),
    remoteR(RR),
    get_time(Segundos),
    convert_time(Segundos,Fecha),
    repoCons(NombreRepo,Autor,Fecha,WS,Index,LR,RR,RepoOutput).

/********* AGREGAR ARCHIVOS AL WS **********/
%Predicado que agrega archivos al Workspace
llenarWorkspace(RepoInput,Archivos,RepoOutput):-
    esRepoZonas(RepoInput),
    esListaArchivos(Archivos),
    workspaceSel(RepoInput,WS),
    concatenar(Archivos,WS,NuevoWorkspace),
    setWorkspace(RepoInput,NuevoWorkspace,RepoOutput).

/*********** GIT ADD *******************/

% En Output se guardan los archivos que que est�n dentro el Workspace,sin repetir
gitAddAux(_,[],Movidos,Movidos):-!.
gitAddAux(RepoInput,[Cabeza|Cola],Salida,Output):-
    esRepoZonas(RepoInput),
    workspaceSel(RepoInput,WS),
    esMiembro(WS,Cabeza,Archivo),
    agregarElemento(Archivo,Salida,Movidos),
    deleteDup(Movidos,Movidos2),
    gitAddAux(RepoInput,Cola,Movidos2,Output).
%gitAddAux(Zonas,["file2","file1","file1"],[],Movidos).


gitAdd(RepoInput,Archivos,RepoOutput):-
    esRepoZonas(RepoInput), %verifica que RepoInput corresponda a un repositorio zona
    esListaStrings(Archivos), %se verifica que la lista ingresada sea una lista de strings
    indexSel(RepoInput,Index),
    gitAddAux(RepoInput,Archivos,[],Movidos),
    concatenar(Movidos,Index,NuevoIndex),
    setIndex(RepoInput,NuevoIndex,RepoOutput).
%gitAdd(RepoInput,["file1","file1","file2"],RepoOutput).

/************** GIT COMMIT ***********************/

% si los cambios entregados est�n vac�os, quiere decir que no hay
% cambios en el index
nuevoLocalR(RepoInput,_,_,[],_,RepoInput):-!,write("No hay cambios en el index").
nuevoLocalR(RepoInput,LocalR,Mensaje,Cambios,NuevoLocalR,NuevaZona2):-
    localRSel(RepoInput,LocalR), %se obtiene el local repository
    commitCons(Mensaje,Cambios,Commit), %se crea un commit en base a la fecha, mensaje y cambios
    agregarElemento(Commit,LocalR,NuevoLocalR), %se agrega el commit al local repository
    setLocalR(RepoInput,NuevoLocalR,NuevaZona), %se modifica el local repository
    setIndex(NuevaZona,[],NuevaZona2). %se modifica el index, quedando vac�o

gitCommit(RepoInput,Mensaje,RepoOutput):-
    esRepoZonas(RepoInput),
    string(Mensaje), %se verifica que el mensaje sea un string
    indexSel(RepoInput,Cambios), %se obtiene el index, que corresponde a los cambios
    nuevoLocalR(RepoInput,_,Mensaje,Cambios,_,RepoOutput). %se modifica el local repository, quedando una nueva zona en RepoOutput

/*************** GIT PUSH ************/
nuevoRemoteR(RepoInput,_,_,[],_,RepoInput):-!,write("No hay commits en el Local Repository").
nuevoRemoteR(RepoInput,Movidos,RemoteR,LocalR,NuevoRemoteR,NuevaZona):-
    remoteRSel(RepoInput,RemoteR),
    concatenar(Movidos,LocalR,Movidos2),
    concatenar(Movidos2,RemoteR,NuevoRemoteR),
    setRemoteR(RepoInput,NuevoRemoteR,NuevaZona).

gitPush(RepoInput,RepoOutput):-
    esRepoZonas(RepoInput),
    localRSel(RepoInput,LR),
    nuevoRemoteR(RepoInput,[],_,LR,_,RepoOutput).

/******************** GIT 2 STRING **********************/

wsAndIndex_to_string([],R,R):-!.
wsAndIndex_to_string([Archivo|Cola],Final,StringFinal):-
    atomics_to_string(Archivo,' : ',StringArch),
    string_concat("    ",StringArch,String),
    string_concat(Final,String,String2),
    string_concat(String2,'\n',String3),
    wsAndIndex_to_string(Cola,String3,StringFinal).

commit_to_string(Commit,String):-
    esCommit(Commit),
    mensajeSel(Commit,Mensaje),
    text_to_string(Mensaje,MsjStr),
    string_concat("   Mensaje: ",MsjStr,Str),
    cambiosSel(Commit,Cambios),
    wsAndIndex_to_string(Cambios,"\n",Str2),
    string_concat(Str,Str2,String).

lRAndRR_to_string([],R,R):-!.
lRAndRR_to_string([Commit|Cola],Final,StringFinal):-
    commit_to_string(Commit,CommitStr),
    string_concat(Final,CommitStr,Str2),
    lRAndRR_to_string(Cola,Str2,StringFinal).

git2String(RepoInput,RepoAsString):-
    esRepoZonas(RepoInput),
    string_concat("","#################    REPOSITORIO '",S1),nombreSel(RepoInput,Nombre),
    text_to_string(Nombre,NombreStr),string_concat(S1,NombreStr,S2),string_concat(S2,"'    ##################\n",S3),

    string_concat(S3,"Fecha de creaci�n: ",S4),
    fechaSel(RepoInput,Fecha),
    text_to_string(Fecha,FechaStr),
    string_concat(S4,FechaStr,S5),

    string_concat(S5,"\nAutor: ",S6),
    autorSel(RepoInput,Autor),
    text_to_string(Autor,AutorStr),
    string_concat(S6,AutorStr,S7),

    string_concat(S7,"\nArchivos en Workspace:\n",S8),
    workspaceSel(RepoInput,Workspace),wsAndIndex_to_string(Workspace,"",S9),string_concat(S8,S9,S10),

    string_concat(S10,"Archivos en Index:\n",S11),
    indexSel(RepoInput,Index),wsAndIndex_to_string(Index,"",S12),string_concat(S11,S12,S13),

    string_concat(S13,"Commits en Local Repository:\n",S14),
    localRSel(RepoInput,LR),lRAndRR_to_string(LR,"",S15),string_concat(S14,S15,S16),

    string_concat(S16,"Commits en Remote Repository:\n",S17),
    remoteRSel(RepoInput,RR),lRAndRR_to_string(RR,"",S18),string_concat(S17,S18,S19),
    string_concat(S19,"\n##### FIN DE REPRESENTACI�N COMO STRING DEL REPOSITORIO #####\n\n",RepoAsString).





