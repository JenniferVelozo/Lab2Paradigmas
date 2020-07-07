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


%Reglas
commitCons(Mensaje,Cambios,Commit):-
    string(Mensaje),
    esListaArchivos(Cambios),
    Commit=[Mensaje,Cambios].

commit(Commit):- commitCons(_,_,Commit).
mensajeSel(Mensaje):- commitCons(Mensaje,_,_).
cambiosSel(Cambios):-commitCons(_,Cambios,_).
