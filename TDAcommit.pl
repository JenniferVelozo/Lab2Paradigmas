%Dominios
%Nombre = symbol; string
%Mensaje = symbol; string
%ListaArchivos = lista

%Predicados
%commit(A,Fecha,Hora,M,C). aridad = 5
%autor(Nombre). aridad = 1
%mensaje(Mensaje). aridad = 1
%cambios(ListaArchivos). aridad = 1

%Metas
%Primarias
%commit(A,Fecha,Hora,M,C) aridad = 5

%Secundarias
%autor(Nombre).
%mensaje(Mensaje).
%cambios(ListaArchivos).

%Clausulas de Horn
%Hechos
autor("Jennifer Velozo").
mensaje("Ediciones").
cambios([["file3","contenido3"],["file4","contenido4"]]).

%Reglas
commitCons(A,Fecha,Hora,M,C,Commit):-autor(A),get_time(Hora), convert_time(Hora,Fecha),mensaje(M),cambios(C),
                          Cabeza=A,
                          Cola=[Fecha,M,C],
                          Commit=[Cabeza|Cola].

commit(Commit):- commitCons(_,_,_,_,_,Commit).
autorSel(Autor):-commitCons(Autor,_,_,_,_,_).
mensajeSel(Mensaje):- commitCons(_,_,_,Mensaje,_,_).
cambiosSel(Cambios):-commitCons(_,_,_,_,Cambios,_).
