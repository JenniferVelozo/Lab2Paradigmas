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
nombreRep("Laboratorio2Paradigmas").
workspace([["file1","contenido1"],["file2","contenido2"]]).
index([["file3","contenido3"],["file4","contenido4"]]).
localR([["file5","contenido5"],["file6","contenido6"]]).
remoteR([["file7","contenido7"],["file8","contenido8"]]).

%Reglas
zonas(Nombre,Fecha,Hora,WS,I,LR,RR):-nombreRep(Nombre),
                                     get_time(Hora), convert_time(Hora,Fecha),
                                     workspace(WS),
                                     index(I),
                                     localR(LR),
                                     remoteR(RR).







