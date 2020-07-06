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

workspace([["f1","C1"],["f2","C2"]]).
indexx([]).
localR([]).
remoteR([]).
% formato workspace e index[["file","contenido],["file2","contenido2"]]
% es una lista que contiene archivos
% formato LR y RR = una lista con commits=
% [["mensaje1",[["f1","c1],["f2","c2"]]],["mensaje2",[["arch1","ssd"],["arch2","wssa"]]]]
% Reglas
%Constructor de zonas
zonasCons(Nombre,Autor,Fecha,WS,I,LR,RR,Zonas):-
    string(Nombre),
    string(Autor),
    get_time(Segundos),
    convert_time(Segundos,Fecha),
    Zonas=[Nombre,Autor,Fecha,WS,I,LR,RR].
%Selectores
nombreSel(Zonas,NombreRepo):-Zonas=[NombreRepo,_,_,_,_,_,_].
autorSel(Zonas,Autor):-Zonas=[_,Autor,_,_,_,_,_].
fechaSel(Zonas,Fecha):-Zonas=[_,_,Fecha,_,_,_,_].
workspaceSel(Zonas,WS):-Zonas=[_,_,_,WS,_,_,_].
indexSel(Zonas,Index):-Zonas=[_,_,_,_,Index,_,_].
localRSel(Zonas,LR):-Zonas=[_,_,_,_,_,LR,_].
remoteRSel(Zonas,RR):-Zonas=[_,_,_,_,_,_,RR].
%Modificadores
setIndex(Zonas,NewIndex,NuevaZona):-
    nombreSel(Zonas,Nombre),
    autorSel(Zonas,Autor),
    fechaSel(Zonas,Fecha),
    workspaceSel(Zonas,WS),
    localRSel(Zonas,LR),
    remoteRSel(Zonas,RR),
    zonasCons(Nombre,Autor,Fecha,WS,NewIndex,LR,RR,NuevaZona).
setLocalR(Zonas,NewLR,NuevaZona):-
    nombreSel(Zonas,Nombre),
    autorSel(Zonas,Autor),
    fechaSel(Zonas,Fecha),
    workspaceSel(Zonas,WS),
    indexSel(Zonas,Index),
    remoteRSel(Zonas,RR),
    zonasCons(Nombre,Autor,Fecha,WS,Index,NewLR,RR,NuevaZona).










