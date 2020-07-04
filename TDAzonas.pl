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
%nombreRep(NombreRepositorio).
%workspace(ListaArchivos).
%index(ListaArchivos).
%localR(ListaArchivos).
%remoteR(ListaArchivos).


%Clausulas de Horn
%Hechos
nombreRep("Lab2").
workspace([["file1","cont1"],["file2","cont"]]).
indexx([]).
localR([["file5","cont5"],["file6","cont6"]]).
remoteR([["file7","cont7"],["file8","cont8"]]).
fecha("01/07/2020").
hora("22:56").

newIndex(_).
%Reglas
%Constructor de zonas
zonasCons(Nombre,Fecha,Hora,WS,I,LR,RR,Zonas):-nombreRep(Nombre),
                                     fecha(Fecha), hora(Hora),
                                     workspace(WS),
                                     indexx(I),
                                     localR(LR),
                                     remoteR(RR),
                                     Zonas=[Nombre,Fecha,Hora,WS,I,LR,RR].
%Selectores
zonas(Zonas):-zonasCons(_,_,_,_,_,_,_,Zonas).
nombreRepSel(Nombre):-zonasCons(Nombre,_,_,_,_,_,_,_).
workspaceSel(WS):-zonasCons(_,_,_,WS,_,_,_,_).
indexSel(Index):-zonasCons(_,_,_,_,Index,_,_,_).
localRSel(LR):-zonasCons(_,_,_,_,_,LR,_,_).
remoteRSel(RR):-zonasCons(_,_,_,_,_,_,RR,_).

%Modificadores
setIndex(Nombre,Fecha,Hora,WS,NewIndex,LR,RR,Zonas):-nombreRep(Nombre),
                                     fecha(Fecha), hora(Hora),
                                     workspace(WS),
                                     newIndex(NewIndex),
                                     localR(LR),
                                     remoteR(RR),
                                     Zonas=[Nombre,Fecha,Hora,WS,NewIndex,LR,RR].









