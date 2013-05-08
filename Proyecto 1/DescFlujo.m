function DescFlujo(De,A,X,Ap,Ar,Tr)
%DESCFLUJO Consigue la Descomposicion De Flujo en el orden dado por la
%estructura Estrella Directa_reversa
c=0;
p=0;
Fl = Flujos (X,Ap,Ar,Tr);
i=1;
while i<=length(Fl)
    if Fl(i)<0
        [Lnod,Caso] = Agregar(i,[],Fl);
        j = Ap(i);
        k = Ap(i+1);
        while j < k && Caso == 0;
            if X(j) ~= 0
                l = A(j);
                [Lnod,Caso] = Agregar(l,Lnod,Fl);
                j = Ap(l);
                k = Ap(l+1);
            else
                j = j+1;
            end
        end
        
        if Caso==1 %% Camino
            Min = MinimoFlujo(X,A,Ap,Lnod);
            Min = MinimoVertice(Fl,Min,Lnod);
            [X,Fl] = ActualizacionFlujos(Fl,A,X,Ap,Lnod,Min,Caso);
            p=p+1;
        else %% Ciclo
            Min = MinimoFlujo(X,A,Ap,Lnod);
            [X,Fl] = ActualizacionFlujos(Fl,A,X,Ap,Lnod,Min,Caso);
            c=c+1;
        end
        i=1;
        Respuesta (Lnod,Caso,Min,c,p);
    else
        i=i+1;
    end
end
%% Los Ciclos que queden
i=1;
while max(X)>0
    if (X(i)>0)
        [Lnod,Caso] = Agregar(De(i),[],Fl);
        j = Ap(De(i));
        k = Ap(De(i)+1);
        while j < k && Caso == 0;
            if X(j) ~= 0
                l = A(j);
                [Lnod,Caso] = Agregar(l,Lnod,Fl);
                j = Ap(l);
                k = Ap(l+1);
            else
                j = j+1;
            end
        end
        
        Min = MinimoFlujo(X,A,Ap,Lnod);
        [X,Fl] = ActualizacionFlujos(Fl,A,X,Ap,Lnod,Min,Caso);             
        i=1;
        c=c+1;
        Respuesta (Lnod,Caso,Min,c,p);
    else
        i=i+1;
    end
end

end

%%Funciones Auxiliares
function [Res] = Flujos (X,Ap,Ar,Tr)
%%Calcula TODA la demanda y oferta de los Nodos
    Res = zeros(length(Ap)-1,1);
    i=1;
    while i<=length(Res)
       j = Ap(i);
       while j<Ap(i+1) 
          Res(i)=Res(i) + (-1*X(j));
          j=j+1;
       end
       j = Ar(i);
       while j<Ar(i+1)
          Res(i)=Res(i) + X(Tr(j));
          j=j+1;
       end       
       i=i+1;
    end
end

function [X,Fl] = ActualizacionFlujos(Fl,A,X,Ap,Lnod,Min,Caso)
%% Actualiza los Flujos solo de los nodos y caminos Ubicados en el
%% Camino/Ciclo encontrado
    i=1;
    while i<length(Lnod)
       d = Lnod(i);
       a = Lnod(i+1);
       k = Ap(d);
       while 1
           if (A(k)==a)
                X(k) = X(k) - Min;
                break;
           end
           k=k+1;
       end
       i=i+1;
    end
    
    
    if Caso
        d = Lnod(1);
        a = Lnod(length(Lnod));
        Fl(d) = Fl(d)+Min;
        Fl(a) = Fl(a)-Min;
    end
end

function [Vmin] = MinimoFlujo(X,A,Ap,Lnod)
%% Calcula EL valor del delta solo contando los flujos de los Arcos
    i=1;
    Vmin = intmax;
    while i<length(Lnod)
       d = Lnod(i);
       a = Lnod(i+1);
       k = Ap(d);
       while 1
           if A(k)==a
               if Vmin > X(k)
                  Vmin=X(k);
               end
               break;
           end
           k=k+1;
       end
       i=i+1;
    end
end

function [Vmin] = MinimoVertice(Fl,Vmin,Lnod)
%%Calcula El minimo entre los Arcos y los nodos del principio y fin de la
%%lista de nodos
    i = -1*Fl(Lnod(1));
    f = Fl(Lnod(length(Lnod)));
    if(Vmin>i)
        Vmin = i;
    end
    if(Vmin>f)
        Vmin = f;
    end
end

function [Lnod,Caso] = Agregar(Nodo,Lnod,Fl)
%%Agrega Un nodo a la lista de nodos y verifica si ya encontro un ciclo o
%%un camino

%%Caso = -1 --> Ciclo
%%Caso =  0 --> Sigue Buscando
%%Caso =  1 --> Camino

Caso = 0;
if Fl(Nodo)>0
    Caso = 1;
end
i=1;
while i<=length(Lnod) && Caso == 0
    if(Lnod(i)==Nodo)
        Caso = -1;
        i=i-1;
        while (i>=1)
            Lnod(i)=[];
            i=i-1;
        end
    end
    i = i+1;
end
i = length(Lnod)+1;
Lnod(i)=Nodo;

end

function [Str] = Respuesta (Lnod,Caso,Min,c,p)
%% Imprimer el Camino o Ciclo Resultante en esta iteracion    
    if Caso == 1
        Str = strcat('F(P',int2str(p),'):',int2str(Min),'         Camino: P',int2str(p),': ');
        Str = strcat(Str,'   ',int2str(Lnod(1)));
        j=2;
        while j<=length(Lnod)
            Str = strcat(Str,'-',int2str(Lnod(j)));
            j=j+1;
        end
    else
        Str = strcat('F(W',int2str(c),'):',int2str(Min),'         Ciclo: W',int2str(c),': ');
        Str = strcat(Str,'   ',int2str(Lnod(1)));
        j=2;
        while j<=length(Lnod)
            Str = strcat(Str,'-',int2str(Lnod(j)));
            j=j+1;
        end
    end
    disp(Str);
    
end