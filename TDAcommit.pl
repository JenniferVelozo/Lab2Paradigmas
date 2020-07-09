:-[predicadosGenerales].
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
%Reglas
%Constructor de commit
commitCons(Mensaje,Cambios,Commit):-
    string(Mensaje),
    esListaArchivos(Cambios),
    Commit=[Mensaje,Cambios].

%Predicado de pertenencia
%Predicado que verifica si un elemento corresponde a un commit
esCommit(Commit):-
    is_list(Commit),
    cuenta_elementos(Commit,2),
    Commit=[Mensaje,Cambios],
    string(Mensaje),
    esListaArchivos(Cambios).

%Selectores
mensajeSel(Commit,Mensaje):- esCommit(Commit),Commit=[Mensaje,_].
cambiosSel(Commit,Cambios):- esCommit(Commit),Commit=[_,Cambios].


