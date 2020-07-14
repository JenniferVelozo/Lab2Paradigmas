:-[tdarepositorio].
:-[tdacommit].
:-[predicadosGenerales].
/************** GIT INIT *****************/
% Predicado que permite consultar el valor que debe tomar RepoOutput a
% partir de un nombre y autor.
% Entradas: 2 strings que representan el
% nombre del repositorio y el autor respectivamente.
% Salida: un repositorio sin archivos ni commits en sus zonas de
% trabajo.
gitInit(NombreRepo,Autor,RepoOutput):-
    workspace(WS),
    indexx(Index),
    localR(LR),
    remoteR(RR),
    get_time(Segundos),
    convert_time(Segundos,Fecha),
    repoCons(NombreRepo,Autor,Fecha,WS,Index,LR,RR,RepoOutput).

/********* AGREGAR ARCHIVOS AL WS **********/
% Predicado que permite consultar el valor que debe tomar RepoOutput a
% partir de un repositorio de entrada RepoInput y una lista de archivos
% (con contenido).
% Entrada: repositorio y una lista de archivos
% Salida: repositorio con la zona de trabajo Workspace modificada, con
% los archivos agregados en esta.
llenarWorkspace(RepoInput,Archivos,RepoOutput):-
    esRepoZonas(RepoInput),
    esListaArchivos(Archivos),
    workspaceSel(RepoInput,WS),
    concatenar(Archivos,WS,NuevoWorkspace),
    setWorkspace(RepoInput,NuevoWorkspace,RepoOutput).

/*********** GIT ADD *******************/
% Predicado que permite consultar el valor que debe tomar Output a
% partir de un repositorio, una lista de archivos y una lista.
% Entradas: un repositorio, lista de archivos y una lista que se le debe
% entregar vacía al momento de usar este predicado
% Salida: una lista de archivos que están en la lista de entrada y en el
% workspace, sin repetir

gitAddAux(_,[],Movidos,Movidos):-!.
gitAddAux(RepoInput,[Cabeza|Cola],Salida,Output):-
    esRepoZonas(RepoInput),
    workspaceSel(RepoInput,WS),
    esMiembro(WS,Cabeza,Archivo),
    agregarElemento(Archivo,Salida,Movidos),
    deleteDup(Movidos,Movidos2),
    gitAddAux(RepoInput,Cola,Movidos2,Output).
%gitAddAux(Zonas,["file2","file1","file1"],[],Movidos).

%Predicado
%Entradas:
%Salida:
gitAdd(RepoInput,Archivos,RepoOutput):-
    esRepoZonas(RepoInput), %verifica que RepoInput corresponda a un repositorio zona
    esListaStrings(Archivos), %se verifica que la lista ingresada sea una lista de strings
    indexSel(RepoInput,Index),
    gitAddAux(RepoInput,Archivos,[],Movidos),
    concatenar(Movidos,Index,NuevoIndex),
    setIndex(RepoInput,NuevoIndex,RepoOutput).
%gitAdd(RepoInput,["file1","file1","file2"],RepoOutput).

/************** GIT COMMIT ***********************/

%Entradas:
%Salida:

nuevoLocalR(RepoInput,_,_,[],RepoInput):-!,write("No hay cambios en el index").
nuevoLocalR(RepoInput,LocalR,Mensaje,Cambios,NuevaZona2):-
    localRSel(RepoInput,LocalR), %se obtiene el local repository
    commitCons(Mensaje,Cambios,Commit), %se crea un commit en base a la fecha, mensaje y cambios
    agregarElemento(Commit,LocalR,NuevoLocalR), %se agrega el commit al local repository
    setLocalR(RepoInput,NuevoLocalR,NuevaZona), %se modifica el local repository
    setIndex(NuevaZona,[],NuevaZona2). %se modifica el index, quedando vacío

%Predicado que permite consultar el valor que debe tomar RepoOutput a partir de un repositorio de entrada RepoInput tal que en RepoOutput  hay un commit con los cambios almacenados en index y especificando un mensaje descriptivo (un string) para llevarlos al LocalRepository.
%Entradas: repositorio y un mensaje descriptivo
% Salida: repositorio actualizado con el index vacío y el local
% repository con un commit añadido
gitCommit(RepoInput,Mensaje,RepoOutput):-
    esRepoZonas(RepoInput),
    string(Mensaje), %se verifica que el mensaje sea un string
    indexSel(RepoInput,Cambios), %se obtiene el index, que corresponde a los cambios
    nuevoLocalR(RepoInput,_,Mensaje,Cambios,RepoOutput). %se modifica el local repository, quedando una nueva zona en RepoOutput

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
% Predicado que permite consultar el valor que debe tomar String Final a
% partir de una lista de archivos y un string
% Entradas: una lista de archivos y un string
% Salida: un string que permite visualizar de manera clara el contenido
% de una lista de archivos
wsAndIndex_to_string([],R,R):-!.
wsAndIndex_to_string([Archivo|Cola],Final,StringFinal):-
    atomics_to_string(Archivo,' : ',StringArch),
    string_concat("    ",StringArch,String),
    string_concat(Final,String,String2),
    string_concat(String2,'\n',String3),
    wsAndIndex_to_string(Cola,String3,StringFinal).

% Predicado que permite consultar el valor que debe tomar String a
% partir de un commit
% Entrada: un commit
% Salida: un string que permite visualizar de manera clara el contenido
% de un commit
commit_to_string(Commit,String):-
    esCommit(Commit),
    mensajeSel(Commit,Mensaje),
    text_to_string(Mensaje,MsjStr),
    string_concat("   Mensaje: ",MsjStr,Str),
    cambiosSel(Commit,Cambios),
    wsAndIndex_to_string(Cambios,"\n",Str2),
    string_concat(Str,Str2,String).

% Predicado que permite consultar el valor que debe tomar StringFinal a
% partir de una lista de commits y un string
% Entradas: una lista de commits y un string
% Salida: un string que permite visualizar de manera clara el contenido
% de una lista de commits
lRAndRR_to_string([],R,R):-!.
lRAndRR_to_string([Commit|Cola],Final,StringFinal):-
    commit_to_string(Commit,CommitStr),
    string_concat(Final,CommitStr,Str2),
    lRAndRR_to_string(Cola,Str2,StringFinal).

%Predicado que permite consultar el valor que debe tomar un String con una representación como un string posible de visualizar de forma comprensible al usuario a partir de una variable de entrada RepoInput.
%Entrada: un repositorio
%Salida: un string que permite visualizar el repositorio
git2String(RepoInput,RepoAsString):-
    esRepoZonas(RepoInput),
    string_concat("","#################    REPOSITORIO '",S1),nombreSel(RepoInput,Nombre),
    text_to_string(Nombre,NombreStr),string_concat(S1,NombreStr,S2),string_concat(S2,"'    ##################\n",S3),

    string_concat(S3,"Fecha de creación: ",S4),
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
    string_concat(S19,"\n##### FIN DE REPRESENTACIÓN COMO STRING DEL REPOSITORIO #####\n\n",RepoAsString).





