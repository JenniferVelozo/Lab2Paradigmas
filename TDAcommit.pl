:-[predicadosGenerales].
%Dominios
%Mensaje = string que representa en mensaje descriptivo del commit
%Cambios = lista de archivos
%Commit = lista de 2 elementos, donde el primero corresponde al mensaje
%y el segundo es una lista de archivos

%Predicados
%commitCons(Mensaje,Cambios,Commit).
%esCommit(Commit).
%mensajeSel(Commit,Mensaje).
%cambiosSel(Commit,Cambios).

%Metas
%Primarias
%commitCons(Mensaje,Cambios,Commit).

%Secundarias
%esCommit(Commit).
%mensajeSel(Commit,Mensaje).
%cambiosSel(Commit,Cambios).

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


