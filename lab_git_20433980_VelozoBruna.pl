:-[tdarepositorio].
:-[tdacommit].
:-[predicadosGenerales].
%Dominios
%NombreRepo = string que representa el nombre de un repositorio
%Autor = string que representa el nombre del autor de un repositorio
%RepoInput =  repositorio de entrada
%RepoOutput = repositorio de salida
%ListaArchivos = lista de archivos
%Archivos = lista de strings que representan nombre de archivos
%Mensaje = string que representa un mensaje descriptivo de un commit
%RepoAsString = string que representa el contenido de un repositorio
%Salida = lista de archivos
%Output = lista de archivos
%Cambios = lista de archivos que representa los cambios hechos en el index
%NuevaZona = repositorio con alguna de sus zonas modificadas
%Movidos = lista de archivos
%LocalR = lista de archivos que representa la zona de trabajo local repository
%StrAcum = string que se va acumulando
% StringFinal = string que representa el contenido de un commit, una
% lista de archivos o una lista de commits


%Predicados
%gitInit(NombreRepo,Autor,RepoOutput).
%llenarWorkspace(RepoInput,ListaArchivos,RepoOutput).
%gitAdd(RepoInput,Archivos,RepoOutput).
%gitCommit(RepoInput,Mensaje,RepoOutput).
%gitPush(RepoInput,RepoOutput).
%git2String(RepoInput,RepoAsString).
%gitAddAux(RepoInput,ListaArchivos,Salida,Output).
%gitCommitAux(RepoInput,Mensaje,Cambios,NuevaZona).
%gitPushAux(RepoInput,Movidos,LocalR,NuevaZona).
%listaArchivos_to_string(ListaArchivos,StrAcum,StringFinal).
%commit_to_string(Commit,StringFinal):
%listaCommits_to_string(ListaCommits,StrAcum,StringFinal).

%Metas
%Primarias
%gitInit(NombreRepo,Autor,RepoOutput).
%llenarWorkspace(RepoInput,ListaArchivos,RepoOutput).
%gitAdd(RepoInput,Archivos,RepoOutput).
%gitCommit(RepoInput,Mensaje,RepoOutput).
%gitPush(RepoInput,RepoOutput).
%git2String(RepoInput,RepoAsString).

%Secundarias
%gitAddAux(RepoInput,ListaArchivos,Salida,Output).
%gitCommitAux(RepoInput,Mensaje,Cambios,NuevaZona).
%gitPushAux(RepoInput,Movidos,LocalR,NuevaZona).
%listaArchivos_to_string(ListaArchivos,StrAcum,StringFinal).
%commit_to_string(Commit,StringFinal):
%listaCommits_to_string(ListaCommits,StrAcum,StringFinal).

%Clausulas de Horn
%Hechos
%Los hechos est�n comentados puesto que al momento de realizar una
%consulta, este arroja warnings indicando que los predicados no est�n
%juntos.
%gitAddAux(_,[],Movidos,Movidos).
%gitCommitAux(RepoInput,_,[],RepoInput).
%gitPushAux(RepoInput,_,[],RepoInput).
%listaArchivos_to_string([],StringFinal,StringFinal).
%listaCommits_to_string([],StringFinal,StringFinal).

%Reglas
/************************************************* GIT INIT ************************************************************************/
% Predicado que permite consultar el valor que debe tomar RepoOutput a
% partir de un nombre y autor.
% Entradas: 2 strings que representan el
% nombre del repositorio y el autor respectivamente.
% Salida: un repositorio sin archivos ni commits en sus zonas de
% trabajo.
gitInit(NombreRepo,Autor,RepoOutput):-
    workspace(WS),indexx(Index),
    localR(LR),remoteR(RR),
    get_time(Segundos),convert_time(Segundos,Fecha),
    repoCons(NombreRepo,Autor,Fecha,WS,Index,LR,RR,RepoOutput).

/************************************************* AGREGAR ARCHIVOS AL WORKSPACE ***************************************************/
% Predicado que permite consultar el valor que debe tomar RepoOutput a
% partir de un repositorio de entrada RepoInput y una lista de archivos
% (con contenido).
% Entrada: repositorio y una lista de archivos.
% Salida: repositorio con la zona de trabajo Workspace modificada, con
% los archivos agregados en esta.
llenarWorkspace(RepoInput,ListaArchivos,RepoOutput):-
    esRepoZonas(RepoInput),
    esListaArchivos(ListaArchivos),
    workspaceSel(RepoInput,WS),
    concatenar(ListaArchivos,WS,NuevoWorkspace),
    setWorkspace(RepoInput,NuevoWorkspace,RepoOutput).

/*************************************************** GIT ADD ***********************************************************************/
% Predicado que permite consultar el valor que debe tomar Output a
% partir de un repositorio, una lista de archivos y una lista.
% Entradas: un repositorio, lista de archivos y una lista que se le debe
% entregar vac�a al momento de usar este predicado.
% Salida: una lista de archivos que est�n en la lista de entrada y en el
% workspace, sin repetir.
% Tipo de recursi�n: de cola
gitAddAux(_,[],Movidos,Movidos):-!.
gitAddAux(RepoInput,[Cabeza|Cola],Salida,Output):-
    esRepoZonas(RepoInput),
    workspaceSel(RepoInput,WS),
    %se verifica si el archivo ubicado en la cabeza de lista est� dentro del workspace
    esMiembro(Cabeza,WS,Archivo),
    agregarElemento(Archivo,Salida,Movidos),
    %se eliminan archivos duplicados en caso de haber
    deleteDup(Movidos,Movidos2),
    gitAddAux(RepoInput,Cola,Movidos2,Output).

%Predicado que permite consultar el valor que debe tomar RepoOutput a partir de un repositorio de entrada RepoInput tal que en RepoOutput se mueven los archivos desde la zona Workspace a la zona Index.
%Entradas: repositorio y una lista de nombres de archivo.
%Salida: un repositorio con el Index modificado.
gitAdd(RepoInput,Archivos,RepoOutput):-
    esRepoZonas(RepoInput), %verifica que RepoInput corresponda a un repositorio zona
    esListaStrings(Archivos), %se verifica que la lista ingresada sea una lista de strings
    indexSel(RepoInput,Index),
    gitAddAux(RepoInput,Archivos,[],Movidos),
    concatenar(Movidos,Index,NuevoIndex),
    setIndex(RepoInput,NuevoIndex,RepoOutput).

/***************************************************** GIT COMMIT ******************************************************************/
% Predicado que permite consultar el valor que debe tomar NuevaZona a
% partir de un repositorio de entrada, un mensaje descriptivo y una
% lista de archivos que representa los cambios hechos en el index.
% Entradas: repositorio,mensaje(string), y cambios(lista de archivos)
% Salida: nuevo repositorio, con el local repository y el index
% modificados
% Si los cambios son una lista vac�a, quiere decir que no hay cambios en
% el index, por lo que el repositorio de entrada no se modifica.
gitCommitAux(RepoInput,_,[],RepoInput):-!,write("No hay cambios en el index").
gitCommitAux(RepoInput,Mensaje,Cambios,NuevaZona):-
    localRSel(RepoInput,LocalR), %se obtiene el local repository
    commitCons(Mensaje,Cambios,Commit), %se crea un commit en base a la fecha, mensaje y cambios
    agregarElemento(Commit,LocalR,NuevoLocalR), %se agrega el commit al local repository
    setLocalR(RepoInput,NuevoLocalR,NuevaZona2), %se modifica el local repository
    setIndex(NuevaZona2,[],NuevaZona). %se modifica el index, quedando vac�o

%Predicado que permite consultar el valor que debe tomar RepoOutput a partir de un repositorio de entrada RepoInput tal que en RepoOutput  hay un commit con los cambios almacenados en index y especificando un mensaje descriptivo (un string) para llevarlos al LocalRepository.
% Entradas: repositorio y un mensaje descriptivo (string)
% Salida: repositorio actualizado con el index vac�o y el local
% repository con un commit a�adido
gitCommit(RepoInput,Mensaje,RepoOutput):-
    esRepoZonas(RepoInput),
    string(Mensaje), %se verifica que el mensaje sea un string
    indexSel(RepoInput,Cambios), %se obtiene el index, que corresponde a los cambios
    gitCommitAux(RepoInput,Mensaje,Cambios,RepoOutput). %se modifica el local repository, quedando una nueva zona en RepoOutput

/***********************************************+**** GIT PUSH ********************************************************************/
% Predicado que permite consultar el valor que debe tomar NuevaZona a
% partir de un repositorio de entrada, una lista (vac�a), y el local
% Repository
% Entrada:repositorio, una lista (vac�a), local repository
% Salida: repositorio con la zona Remote Repository modificada
% Si el local repository est� vac�o se indica que no hay commits en
% este, y el repositorio de entrada no se modifica
gitPushAux(RepoInput,_,[],RepoInput):-!,write("No hay commits en el Local Repository").
gitPushAux(RepoInput,Movidos,LocalR,NuevaZona):-
    remoteRSel(RepoInput,RemoteR),
    concatenar(Movidos,LocalR,Movidos2),
    concatenar(Movidos2,RemoteR,NuevoRemoteR),
    setRemoteR(RepoInput,NuevoRemoteR,NuevaZona).
%Predicado que permite consultar el valor que debe tomar RepoOutput a partir de un repositorio de entrada RepoInput tal que en RepoOutput se env�an los commit desde el repositorio local al repositorio remoto registrado en las zonas de trabajo.
%Entrada: repositorio
%Salida: un repositorio con la zona de trabajo Remote Repository
% modificada
gitPush(RepoInput,RepoOutput):-
    esRepoZonas(RepoInput),
    localRSel(RepoInput,LR),
    gitPushAux(RepoInput,[],LR,RepoOutput).

/**********************+*************************** GIT 2 STRING *******************************************************************/
% Predicado que permite consultar el valor que debe tomar String Final a
% partir de una lista de archivos y un string
% Entradas: una lista de archivos y un string (que se debe entregar
% vac�o al momento de usar este predicado).
% Salida: un string que permite visualizar de manera clara el contenido
% de una lista de archivos
% Tipo de recursi�n: de cola
listaArchivos_to_string([],StringFinal,StringFinal):-!.
listaArchivos_to_string([Archivo|Cola],StrAcum,StringFinal):-
    atomics_to_string(Archivo,' : ',StringArch),
    string_concat("    ",StringArch,String),
    string_concat(StrAcum,String,String2),
    string_concat(String2,'\n',String3),
    listaArchivos_to_string(Cola,String3,StringFinal).

% Predicado que permite consultar el valor que debe tomar String a
% partir de un commit
% Entrada: un commit
% Salida: un string que permite visualizar de manera clara el contenido
% de un commit
commit_to_string(Commit,StringFinal):-
    esCommit(Commit),
    mensajeSel(Commit,Mensaje),
    text_to_string(Mensaje,MsjStr),
    string_concat("   Mensaje: ",MsjStr,Str),
    cambiosSel(Commit,Cambios),
    listaArchivos_to_string(Cambios,"\n",Str2),
    string_concat(Str,Str2,StringFinal).

% Predicado que permite consultar el valor que debe tomar StringFinal a
% partir de una lista de commits y un string.
% Entradas: una lista de commits y un string (que se debe entregar vac�o
% al momento de usar este predicado)
% Salida: un string que permite visualizar de manera clara el
% contenido de una lista de commits
% Tipo de recursi�n: de cola
listaCommits_to_string([],StringFinal,StringFinal):-!.
listaCommits_to_string([Commit|Cola],StrAcum,StringFinal):-
    commit_to_string(Commit,CommitStr),
    string_concat(StrAcum,CommitStr,Str2),
    listaCommits_to_string(Cola,Str2,StringFinal).

% Predicado que permite consultar el valor que debe tomar un String como
% una representaci�n posible de visualizar de forma comprensible al
% usuario a partir de una variable de entrada RepoInput.
% Entrada: un repositorio
% Salida: un string que permite visualizar el repositorio
git2String(RepoInput,RepoAsString):-
    esRepoZonas(RepoInput),
    string_concat("","\n\n#################    REPOSITORIO '",S1),nombreSel(RepoInput,Nombre),
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
    workspaceSel(RepoInput,Workspace),listaArchivos_to_string(Workspace,"",S9),string_concat(S8,S9,S10),

    string_concat(S10,"Archivos en Index:\n",S11),
    indexSel(RepoInput,Index),listaArchivos_to_string(Index,"",S12),string_concat(S11,S12,S13),

    string_concat(S13,"Commits en Local Repository:\n",S14),
    localRSel(RepoInput,LR),listaCommits_to_string(LR,"",S15),string_concat(S14,S15,S16),

    string_concat(S16,"Commits en Remote Repository:\n",S17),
    remoteRSel(RepoInput,RR),listaCommits_to_string(RR,"",S18),string_concat(S17,S18,S19),
    string_concat(S19,"\n##### FIN DE REPRESENTACI�N COMO STRING DEL REPOSITORIO #####\n\n",RepoAsString).


/***************************************************** EJEMPLOS DE USO *************************************************************/
/*Predicado gitInit

1.-gitInit("Lab2","Jennifer Velozo",RepoOutput).

2.-gitInit("Lab1","Juan P�rez",RepoOutput).

3.-gitInit("Laboratorio 3","Miguel Correa",RepoOutput).

*/

/*Predicado llenarWorkspace

1.-gitInit("Lab2","Jennifer Velozo",Repo),llenarWorkspace(Repo,[["file1.txt","Instrucciones especiales"],["f2.pl","Predicados Git"],["archivo3.docx","Informe de proyecto"]],RepoOutput).

2.-llenarWorkspace(["Lab2", "Jennifer Velozo", "Fri Jul 17 18:12:54 2020", [["file1.txt", "Instrucciones especiales"], ["f2.pl", "Predicados Git"], ["archivo3.docx", "Informe de proyecto"]], [], [], []],[["file2.txt","contenido file2"]],RepoOutput).

3.-gitInit("Lab2","Jennifer Velozo",Repo),llenarWorkspace(Repo,[["file1.pl","codigo principal"]],RepoOutput).

*/

/*Predicado gitAdd

1.-gitInit("Lab2","Jennifer Velozo",Repo),llenarWorkspace(Repo,[["file1.txt","Instrucciones especiales"],["f2.pl","Predicados Git"],["archivo3.docx","Informe de proyecto"]],Repo2),gitAdd(Repo2,["file1.txt","archivo3.docx"],RepoOutput).

2.-gitAdd(["Lab2", "Jennifer Velozo", "Fri Jul 17 18:21:28 2020", [["file1.txt", "Instrucciones especiales"], ["f2.pl", "Predicados Git"], ["archivo3.docx", "Informe de proyecto"]], [], [], []],["f2.pl","file1.txt"],RepoOutput).

3.-gitAdd(["Lab2", "Jennifer Velozo", "Fri Jul 17 18:21:28 2020", [["file1.txt", "Instrucciones especiales"], ["f2.pl", "Predicados Git"]], [], [], []],["f2.pl"],RepoOutput).

*/

/*Predicado gitCommit

1.-gitCommit(["Lab2", "Jennifer Velozo", "Fri Jul 17 18:21:28 2020", [["file1.txt", "Instrucciones especiales"], ["f2.pl", "Predicados Git"], ["archivo3.docx", "Informe de proyecto"]], [], [], []],"Ediciones",RepoOutput).

2.-gitCommit(["Lab2", "Jennifer Velozo", "Fri Jul 17 18:21:28 2020", [["file1.txt", "Instrucciones especiales"], ["f2.pl", "Predicados Git"], ["archivo3.docx", "Informe de proyecto"]], [["f2.pl", "Predicados Git"]], [], []],"Ediciones",RepoOutput).

3.-gitCommit(["Lab2", "Jennifer Velozo", "Fri Jul 17 18:21:28 2020", [["file1.txt", "Instrucciones especiales"], ["f2.pl", "Predicados Git"], ["archivo3.docx", "Informe de proyecto"]], [["f2.pl", "Predicados Git"],["file1.txt", "Instrucciones especiales"]], [], []],"Ediciones 2",RepoOutput).

*/

/*Predicado gitPush
1.- gitPush(["Lab2","Jennifer","17/07/2020 18:33",[["file1.c","contenido"]],[],[["Ediciones",[["file1.c","contenido"]]]],[]],RepoOutput).

2.-gitInit("Lab2","Jennifer",Inicial),llenarWorkspace(Inicial,[["file1.pl", "contenido"], ["ejercicios.pl", "contenido"]],R),gitAdd(R,["file1.pl"],R2),gitCommit(R2,"Ediciones varias",R3),gitPush(R3,RepoOutput).

3.-gitPush(["Lab2","Jennifer","17/07/2020 18:33",[["file1.c","contenido"]],[],[["Ediciones",[["file1.c","contenido"]]]],[["Corecci�n de errores",[["archivo.pl","contenido"],["archivo2.pl","contenido2"]]]]],RepoOutput).
*/

/*Predicado git2String

1.- git2String(["Lab2","Jennifer","17/07/2020 18:33",[["file1.c","contenido"]],[],[["Ediciones",[["file1.c","contenido"]]]],[["Corecci�n de errores",[["archivo.pl","contenido"],["archivo2.pl","contenido2"]]]]],RepoAsString).

2.-git2String(["Lab2","Jennifer","17/07/2020 18:33",[],[],[],[]],RepoAsString).

3.-gitInit("lab2","Jennifer",R),llenarWorkspace(R,[["file1","c1"],["file.rkt","c2"]],R2),gitAdd(R2,["file.rkt"],R3),git2String(R3,RepoAsString).
*/




















