:-[predicadosGenerales].
%Dominios
%NombreRepo = string que representa el nombre del repositorio
%Autor = string que representa el autor del repositorio
%Fecha = string que representa la fecha de creación del repositorio
%WS = lista de archivos
%Index = lista de archivos
%LR = lista de commits
%RR = lista de commits
%Repo = lista de 7 elementos: NombreRepo,Autor,Fecha,WS,Index,LR, RR
%NuevoRepo = lista de 7 elementos:NombreRepo,Autor,Fecha,WS,Index,LR,RR
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


%Clausulas de Horn
%Hechos
workspace([]).
indexx([]).
localR([]).
remoteR([]).
%[["mensaje",[["file.c","sdds"],["s.rkt","sd"]]]]
%formato workspace e index:
% [["file","contenido"],["file2","contenido2"]];
% es una lista que contiene archivos
%formato LR y RR
% [["mensaje1",[["f1","c1],["f2","c2"]]],["mensaje2",[["arch1","ssd"],["arch2","asd"]]]];
% es una lista que contiene commits


% Reglas
% Constructor de repositorio
% En la variable Repo se crea una lista con los 7 elementos
zonasCons(NombreRepo,Autor,Fecha,WS,Index,LR,RR,Repo):-
    string(NombreRepo),string(Autor),string(Fecha),
    esListaArchivos(WS),esListaArchivos(Index),
    esListaCommits(LR), esListaCommits(RR),
    Repo=[NombreRepo,Autor,Fecha,WS,Index,LR,RR].

% Predicado de Pertenencia
% Verifica si la variable Repo corresponde a un repositorio
esRepoZonas(Repo):-
    is_list(Repo),
    cuenta_elementos(Repo,7),
    Repo=[Nombre,Autor,Fecha,WS,Index,LR,RR],
    string(Nombre),
    string(Autor),
    string(Fecha),
    esListaArchivos(WS),
    esListaArchivos(Index),
    esListaCommits(LR),
    esListaCommits(RR).

%Selectores
nombreSel(Repo,NombreRepo):-esRepoZonas(Repo),Repo=[NombreRepo,_,_,_,_,_,_].
autorSel(Repo,Autor):-esRepoZonas(Repo),Repo=[_,Autor,_,_,_,_,_].
fechaSel(Repo,Fecha):-esRepoZonas(Repo),Repo=[_,_,Fecha,_,_,_,_].
workspaceSel(Repo,WS):-esRepoZonas(Repo),Repo=[_,_,_,WS,_,_,_].
indexSel(Repo,Index):-esRepoZonas(Repo),Repo=[_,_,_,_,Index,_,_].
localRSel(Repo,LR):-esRepoZonas(Repo),Repo=[_,_,_,_,_,LR,_].
remoteRSel(Repo,RR):-esRepoZonas(Repo),Repo=[_,_,_,_,_,_,RR].

%Modificadores
% Predicado que construye un nuevo repositorio, con el Workspace
% modificado
setWorkspace(Repo,NewWS,NuevoRepo):-
    esRepoZonas(Repo),esListaArchivos(NewWS),
    nombreSel(Repo,Nombre),
    autorSel(Repo,Autor),
    fechaSel(Repo,Fecha),
    indexSel(Repo,Index),
    localRSel(Repo,LR),
    remoteRSel(Repo,RR),
    zonasCons(Nombre,Autor,Fecha,NewWS,Index,LR,RR,NuevoRepo).

% Predicado que construye un nuevo repositorio, con el Index
% modificado
setIndex(Repo,NewIndex,NuevoRepo):-
    esRepoZonas(Repo),esListaArchivos(NewIndex),
    nombreSel(Repo,Nombre),
    autorSel(Repo,Autor),
    fechaSel(Repo,Fecha),
    workspaceSel(Repo,WS),
    localRSel(Repo,LR),
    remoteRSel(Repo,RR),
    zonasCons(Nombre,Autor,Fecha,WS,NewIndex,LR,RR,NuevoRepo).

% Predicado que construye un nuevo repositorio, con el Local
% Repository modificado
setLocalR(Repo,NewLR,NuevoRepo):-
    esRepoZonas(Repo),esListaCommits(NewLR),
    nombreSel(Repo,Nombre),
    autorSel(Repo,Autor),
    fechaSel(Repo,Fecha),
    workspaceSel(Repo,WS),
    indexSel(Repo,Index),
    remoteRSel(Repo,RR),
    zonasCons(Nombre,Autor,Fecha,WS,Index,NewLR,RR,NuevoRepo).

% Predicado que construye un nuevo repositorio, con el Remote
% Repository modificado
setRemoteR(Repo,NewRR,NuevoRepo):-
    esRepoZonas(Repo),esListaCommits(NewRR),
    nombreSel(Repo,Nombre),
    autorSel(Repo,Autor),
    fechaSel(Repo,Fecha),
    workspaceSel(Repo,WS),
    indexSel(Repo,Index),
    localRSel(Repo,LR),
    zonasCons(Nombre,Autor,Fecha,WS,Index,LR,NewRR,NuevoRepo).











