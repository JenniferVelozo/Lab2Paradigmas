:-[tdacommit].
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
nombreRepo("Lab2").
workspaceInit([]).
indexInit([]).
localRInit([]).
remoteRInit([]).

workspace([["f1","c1"],["f2","c2"]]).
indexx([]).
localR([["JV","05/07/2020 18:40","Ediciones",[["f5","c5"],["f6","c6"]]]]).
remoteR([["JV", "04/07/2020 13:20", "My commit",[["file7","c7"]]]]).

%Reglas
%Constructor de zonas
zonasCons(Nombre,Autor,Fecha,WS,I,LR,RR,Zonas):-nombreRepo(Nombre),
                                     autor(Autor),
                                     get_time(Segundos),
                                     convert_time(Segundos,Fecha),
                                     workspace(WS),
                                     indexx(I),
                                     localR(LR),
                                     remoteR(RR),
                                     Zonas=[Nombre,Autor,Fecha,WS,I,LR,RR].
%Selectores
zonas(Zonas):-zonasCons(_,_,_,_,_,_,_,Zonas).
nombreRepSel(Nombre):-zonasCons(Nombre,_,_,_,_,_,_,_).
workspaceSel(WS):-zonasCons(_,_,_,WS,_,_,_,_).
indexSel(Index):-zonasCons(_,_,_,_,Index,_,_,_).
localRSel(LR):-zonasCons(_,_,_,_,_,LR,_,_).
remoteRSel(RR):-zonasCons(_,_,_,_,_,_,RR,_).

%Modificadores
setIndex(Nombre,Autor,Fecha,WS,NewIndex,LR,RR,Zonas):-nombreRepo(Nombre),
                                     autor(Autor),
                                     get_time(Segundos),
                                     convert_time(Segundos,Fecha),
                                     workspace(WS),
                                     is_list(NewIndex),
                                     localR(LR),
                                     remoteR(RR),
                                     Zonas=[Nombre,Autor,Fecha,WS,NewIndex,LR,RR].

setLocalR(Nombre,Autor,Fecha,WS,I,NewLR,RR,Zonas):-nombreRepo(Nombre),
                                     autor(Autor),
                                     get_time(Segundos),
                                     convert_time(Segundos,Fecha),
                                     workspace(WS),
                                     indexx(I),
                                     is_list(NewLR),
                                     remoteR(RR),
                                     Zonas=[Nombre,Autor,Fecha,WS,I,NewLR,RR].









