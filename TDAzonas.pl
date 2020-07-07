%Dominios
%NombreRepositorio = symbol; string
%ListaArchivos = lista

%Predicados
%nombreRep(NombreRepositorio). aridad=1
%workspace(ListaArchivos). aridad=1
%index(ListaArchivos). aridad=1
%localR(ListaArchivos). aridad=1
%remoteR(ListaArchivos). aridad=1
%zonas(NombreRepositorio,Fecha,Hora,WS,I,LR,RR). aridad=7

%Metas
%Primarias
%zonas(Nombre,Fecha,Hora,WS,I,LR,RR).

%Secundarias
%workspace(ListaArchivos).
%index(ListaArchivos).
%localR(ListaArchivos).
%remoteR(ListaArchivos).


%Clausulas de Horn
%Hechos
workspace([["arch.rkt","sdd"]]).
indexx([]).
localR([]).
remoteR([]).
% formato workspace e index[["file","contenido],["file2","contenido2"]]
% es una lista que contiene archivos
% formato LR y RR = una lista con commits=
% [["mensaje1",[["f1","c1],["f2","c2"]]],["mensaje2",[["arch1","ssd"],["arch2","wssa"]]]]

% Reglas
cuenta_elementos([],0).
cuenta_elementos([_|L],N):- cuenta_elementos(L,Tam), N is Tam+1.

is_file([Nombre|Contenido]):-
    cuenta_elementos([Nombre|Contenido],2),
    string(Nombre),
    Contenido=[Cabeza|_],
    string(Cabeza).

esListaArchivos([]).
esListaArchivos([Cabeza|Cola]):-
    is_list(Cabeza),
    is_file(Cabeza),
    esListaArchivos(Cola).

is_commit([Mensaje|Archivos]):-
    cuenta_elementos([Mensaje|Archivos],2),
    string(Mensaje),
    Archivos=[ArchivosAux|_],
    esListaArchivos(ArchivosAux).
esListaCommits([]).
esListaCommits([Cabeza|Cola]):-
    is_list(Cabeza),
    is_commit(Cabeza),
    esListaCommits(Cola).

%Constructor de zonas
zonasCons(Nombre,Autor,Fecha,WS,I,LR,RR,Zonas):-
    string(Nombre),
    string(Autor),
    string(Fecha),
    esListaArchivos(WS),
    esListaArchivos(I),
    esListaCommits(LR), esListaCommits(RR),
    Zonas=[Nombre,Autor,Fecha,WS,I,LR,RR].

%Predicado de Pertenencia
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
nombreSel(Zonas,NombreRepo):-esRepoZonas(Zonas),Zonas=[NombreRepo,_,_,_,_,_,_].
autorSel(Zonas,Autor):-esRepoZonas(Zonas),Zonas=[_,Autor,_,_,_,_,_].
fechaSel(Zonas,Fecha):-esRepoZonas(Zonas),Zonas=[_,_,Fecha,_,_,_,_].
workspaceSel(Zonas,WS):-esRepoZonas(Zonas),Zonas=[_,_,_,WS,_,_,_].
indexSel(Zonas,Index):-esRepoZonas(Zonas),Zonas=[_,_,_,_,Index,_,_].
localRSel(Zonas,LR):-esRepoZonas(Zonas),Zonas=[_,_,_,_,_,LR,_].
remoteRSel(Zonas,RR):-esRepoZonas(Zonas),Zonas=[_,_,_,_,_,_,RR].

%Modificadores
setWorkspace(Zonas,NewWS,NuevaZona):-
    esRepoZonas(Zonas),esListaArchivos(NewWS),
    nombreSel(Zonas,Nombre),
    autorSel(Zonas,Autor),
    fechaSel(Zonas,Fecha),
    indexSel(Zonas,Index),
    localRSel(Zonas,LR),
    remoteRSel(Zonas,RR),
    zonasCons(Nombre,Autor,Fecha,NewWS,Index,LR,RR,NuevaZona).

setIndex(Zonas,NewIndex,NuevaZona):-
    esRepoZonas(Zonas),esListaArchivos(NewIndex),
    nombreSel(Zonas,Nombre),
    autorSel(Zonas,Autor),
    fechaSel(Zonas,Fecha),
    workspaceSel(Zonas,WS),
    localRSel(Zonas,LR),
    remoteRSel(Zonas,RR),
    zonasCons(Nombre,Autor,Fecha,WS,NewIndex,LR,RR,NuevaZona).

setLocalR(Zonas,NewLR,NuevaZona):-
    esRepoZonas(Zonas),esListaCommits(NewLR),
    nombreSel(Zonas,Nombre),
    autorSel(Zonas,Autor),
    fechaSel(Zonas,Fecha),
    workspaceSel(Zonas,WS),
    indexSel(Zonas,Index),
    remoteRSel(Zonas,RR),
    zonasCons(Nombre,Autor,Fecha,WS,Index,NewLR,RR,NuevaZona).

setRemoteR(Zonas,NewRR,NuevaZona):-
    esRepoZonas(Zonas),esListaCommits(NewRR),
    nombreSel(Zonas,Nombre),
    autorSel(Zonas,Autor),
    fechaSel(Zonas,Fecha),
    workspaceSel(Zonas,WS),
    indexSel(Zonas,Index),
    localRSel(Zonas,LR),
    zonasCons(Nombre,Autor,Fecha,WS,Index,LR,NewRR,NuevaZona).











