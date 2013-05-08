function [ LE,LS ] = EntrantesySalientes( Nodo , De, A, Ap, Ar, Tr )
%ENTRANTESYSALIENTES Consigue La Lista de Los Arcos que entran y salen del
%Nodo que se Pida
%   Los Argumentos de entrada son
%   El Nodo que se desea saber 
%   Los Arreglos que forman la Estructura Estrella Directa_Reversa 
%   en ese orde

    Li = Ap(Nodo);
    Ls = Ap(Nodo+1);

    LS = zeros(Ls-Li,1);

    k = 1;
    j = Li;
    while (k<=length(LS))

        LS(k) = A(j);
        k=k+1;
        j=j+1;

    end

    Li = Ar(Nodo);
    Ls = Ar(Nodo+1);

    LE = zeros(Ls-Li,1);

    k = 1;
    j = Li;
    while (k<=length(LE))

        h = Tr(j);
        LE(k) = De(h);
        k=k+1;
        j= j+1;

    end



end

