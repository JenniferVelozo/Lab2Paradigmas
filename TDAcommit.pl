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
autor("Jennifer").

%Reglas
commitCons(Autor,Fecha,Mensaje,Cambios,Commit):-
    autor(Autor),
    get_time(Segundos),convert_time(Segundos,Fecha),
    string(Mensaje),
    is_list(Cambios),
    Commit=[Autor,Fecha,Mensaje,Cambios].

commit(Commit):- commitCons(_,_,_,_,Commit).
autorSel(Autor):-commitCons(Autor,_,_,_,_).
mensajeSel(Mensaje):- commitCons(_,_,Mensaje,_,_).
cambiosSel(Cambios):-commitCons(_,_,_,Cambios,_).
