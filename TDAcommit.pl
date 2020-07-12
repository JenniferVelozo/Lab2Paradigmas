:-[predicadosGenerales].
%Representación de un commit: [Mensaje,Cambios]
%Representación de cambios: lista de archivos
%Representación de un archivo: ["archivo","contenido"]

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
%esCommit(Commit).

%Secundarias
%mensajeSel(Commit,Mensaje).
%cambiosSel(Commit,Cambios).

%Clausulas de Horn
%Reglas
%Constructor de commit
%Entradas: mensaje descriptivo y los cambios
%Salida: una lista de 2 elementos, donde el primero es el mensaje y el
% segundo es una lista de archivos
commitCons(Mensaje,Cambios,Commit):-
    string(Mensaje),
    esListaArchivos(Cambios),
    Commit=[Mensaje,Cambios].

%Predicado de pertenencia
%Predicado que verifica si un elemento corresponde a un commit
%Entrada: Commit
%Salida: true o false
esCommit(Commit):-
    is_list(Commit),
    cuenta_elementos(Commit,2),
    Commit=[Mensaje,Cambios],
    string(Mensaje),
    esListaArchivos(Cambios).

%Selectores
% Predicado que permite consultar el valor que debe tomar Mensaje a
% partir de un commit
% Entrada: Commit
% Salida: un string que representa el mensaje descirptivo
mensajeSel(Commit,Mensaje):- esCommit(Commit),Commit=[Mensaje,_].
% Predicado que permite consultar el valor que debe tomar Cambios a
% partir de un commit
% Entrada: Commit
% Salida: una lista de archivos que representa los cambios
cambiosSel(Commit,Cambios):- esCommit(Commit),Commit=[_,Cambios].


