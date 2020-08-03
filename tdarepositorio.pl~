:-[predicadosGenerales].
%Estructura base del TDA repositorio
%Representación del TDA repositorio:
%lista de 7 elementos, de la siguiente manera
%[NombreRepo,Autor,Fecha,Workspace,Index,LocalRepository,RemoteRepository]

%Representación de un archivo: ["nombre_archivo","contenido"]

%Dominios
%NombreRepo = string que representa el nombre del repositorio
%Autor = string que representa el autor del repositorio
%Fecha = string que representa la fecha de creación del repositorio
%WS = lista de archivos
%Index = lista de archivos
%LR = lista de commits
%RR = lista de commits
%Repo = lista de 7 elementos que representa el repositorio:
% [NombreRepo,Autor,Fecha,WS,Index,LR, RR]
%NuevoRepo = lista de 7 elementos que representa un nuevo repositorio:
% [NombreRepo,Autor,Fecha,WS,Index,LR,RR]
%NewWS = lista de archivos
%NewIndex = lista de archivos
%NewLR = lista de commits
%NewRR = lista de commits

%Predicados
%zonasCons(NombreRepo,Autor,Fecha,WS,Index,LR,RR,Repo).
%esRepoZonas(Repo).
%nombreSel(Repo,NombreRepo)
%autorSel(Repo,Autor).
%fechaSel(Repo,Fecha).
%workspaceSel(Repo,WS).
%indexSel(Repo,Index).
%localRSel(Repo,LR).
%remoteRSel(Repo,RR).
%setWorkspace(Repo,NewWS,NuevoRepo).
%setIndex(Repo,NewIndex,NuevoRepo).
%setLocalR(Repo,NewLR,NuevoRepo).
%setRemoteR(Repo,NewRR,NuevoRepo).
%workspace(WS).
%indexx(Index).
%localR(LR).
%remoteR(RR).

%Metas
%Primarias
%zonasCons(NombreRepo,Autor,Fecha,WS,Index,LR,RR,Repo).
%esRepoZonas(Repo).

%Secundarias
%nombreSel(Repo,NombreRepo)
%autorSel(Repo,Autor).
%fechaSel(Repo,Fecha).
%workspaceSel(Repo,WS).
%indexSel(Repo,Index).
%localRSel(Repo,LR).
%remoteRSel(Repo,RR).
%setWorkspace(Repo,NewWS,NuevoRepo).
%setIndex(Repo,NewIndex,NuevoRepo).
%setLocalR(Repo,NewLR,NuevoRepo).
%setRemoteR(Repo,NewRR,NuevoRepo).
%workspace(WS).
%indexx(Index).
%localR(LR).
%remoteR(RR).

%Clausulas de Horn
%Hechos
%Puesto que las zonas de trabajo inician vacías, estos hechos
%son usado para el predicado gitInit
workspace([]).
indexx([]).
localR([]).
remoteR([]).

% Reglas
% Constructor de repositorio
% Predicado que permite consultar el valor que debe tomar la variable
% Repo a partir de 7 entradas
% Entradas: nombre, autor y fecha de creación del repositorio, zonas
% de trabajo Workspace, Index, Local Repository y Remote Repository
% Salida: Repositorio
repoCons(NombreRepo,Autor,Fecha,WS,Index,LR,RR,Repo):-
    string(NombreRepo),string(Autor),string(Fecha),
    esListaArchivos(WS),esListaArchivos(Index),
    esListaCommits(LR), esListaCommits(RR),
    Repo=[NombreRepo,Autor,Fecha,WS,Index,LR,RR].

% Predicado de Pertenencia
% Verifica si la variable Repo corresponde a un repositorio
% Entrada: repositorio
% Salida: true o false
esRepoZonas(Repo):-
    is_list(Repo),
    cuenta_elementos(Repo,7),
    Repo=[Nombre,Autor,Fecha,WS,Index,LR,RR],
    string(Nombre),string(Autor),string(Fecha),
    esListaArchivos(WS),esListaArchivos(Index),
    esListaCommits(LR),esListaCommits(RR).

%Selectores
% Predicado que permite consultar el valor que debe tomar la variable
% NombreRepo a partir de un repositorio de entrada
% Entrada: repositorio
% Salida: nombre del repositorio
nombreSel(Repo,NombreRepo):-esRepoZonas(Repo),Repo=[NombreRepo,_,_,_,_,_,_].

% Predicado que permite consultar el valor que debe tomar la variable
% Autor a partir de un repositorio de entrada
% Entrada: repositorio
% Salida: autor del repositorio
autorSel(Repo,Autor):-esRepoZonas(Repo),Repo=[_,Autor,_,_,_,_,_].

% Predicado que permite consultar el valor que debe tomar la variable
% Fecha a partir de un repositorio de entrada
% Entrada: repositorio
% Salida: fecha de creación del repositorio
fechaSel(Repo,Fecha):-esRepoZonas(Repo),Repo=[_,_,Fecha,_,_,_,_].

% Predicado que permite consultar el valor que debe tomar la variable
% WS a partir de un repositorio de entrada
% Entrada: repositorio
% Salida: zona de trabajo Workspace
workspaceSel(Repo,WS):-esRepoZonas(Repo),Repo=[_,_,_,WS,_,_,_].

% Predicado que permite consultar el valor que debe tomar la variable
% Index a partir de un repositorio de entrada
% Entrada: repositorio
% Salida: zona de trabajo Index
indexSel(Repo,Index):-esRepoZonas(Repo),Repo=[_,_,_,_,Index,_,_].

% Predicado que permite consultar el valor que debe tomar la variable
% LR a partir de un repositorio de entrada
% Entrada: repositorio
% Salida: zona de trabajo Local Repository
localRSel(Repo,LR):-esRepoZonas(Repo),Repo=[_,_,_,_,_,LR,_].

% Predicado que permite consultar el valor que debe tomar la variable
% RR a partir de un repositorio de entrada
% Entrada: repositorio
% Salida: zona de trabajo Local Repository
remoteRSel(Repo,RR):-esRepoZonas(Repo),Repo=[_,_,_,_,_,_,RR].

%Modificadores
% Predicado que permite consultar el valor que debe tomar la variable
% NuevoRepo a partir de un repositorio de entrada y un nuevo Workspace
% Entrada: repositorio, nuevo Workspace
% Salida: nuevo repositorio con la zona de trabajo Workspace modificada
setWorkspace(Repo,NewWS,NuevoRepo):-
    esRepoZonas(Repo),esListaArchivos(NewWS),
    nombreSel(Repo,Nombre),
    autorSel(Repo,Autor),
    fechaSel(Repo,Fecha),
    indexSel(Repo,Index),
    localRSel(Repo,LR),
    remoteRSel(Repo,RR),
    repoCons(Nombre,Autor,Fecha,NewWS,Index,LR,RR,NuevoRepo).

% Predicado que permite consultar el valor que debe tomar la variable
% NuevoRepo a partir de un repositorio de entrada y un nuevo Index
% Entrada: repositorio, nuevo Index
% Salida: nuevo repositorio con la zona de trabajo Index modificada
setIndex(Repo,NewIndex,NuevoRepo):-
    esRepoZonas(Repo),esListaArchivos(NewIndex),
    nombreSel(Repo,Nombre),
    autorSel(Repo,Autor),
    fechaSel(Repo,Fecha),
    workspaceSel(Repo,WS),
    localRSel(Repo,LR),
    remoteRSel(Repo,RR),
    repoCons(Nombre,Autor,Fecha,WS,NewIndex,LR,RR,NuevoRepo).

% Predicado que permite consultar el valor que debe tomar la variable
% NuevoRepo a partir de un repositorio de entrada y un nuevo Local
% Repository
% Entrada: repositorio, nuevo Local Repository
% Salida: nuevo repositorio con la zona de trabajo Local Repository
% modificada
setLocalR(Repo,NewLR,NuevoRepo):-
    esRepoZonas(Repo),esListaCommits(NewLR),
    nombreSel(Repo,Nombre),
    autorSel(Repo,Autor),
    fechaSel(Repo,Fecha),
    workspaceSel(Repo,WS),
    indexSel(Repo,Index),
    remoteRSel(Repo,RR),
    repoCons(Nombre,Autor,Fecha,WS,Index,NewLR,RR,NuevoRepo).

% Predicado que permite consultar el valor que debe tomar la variable
% NuevoRepo a partir de un repositorio de entrada y un nuevo Remote
% Repository
% Entrada: repositorio, nuevo Local Repository
% Salida: nuevo repositorio con la zona de trabajo Remote Repository
% modificada
setRemoteR(Repo,NewRR,NuevoRepo):-
    esRepoZonas(Repo),esListaCommits(NewRR),
    nombreSel(Repo,Nombre),
    autorSel(Repo,Autor),
    fechaSel(Repo,Fecha),
    workspaceSel(Repo,WS),
    indexSel(Repo,Index),
    localRSel(Repo,LR),
    repoCons(Nombre,Autor,Fecha,WS,Index,LR,NewRR,NuevoRepo).











