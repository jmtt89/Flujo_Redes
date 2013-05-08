function [ PI , X ] = PotyFlu(  De,A,C,U,b,pr,trd,Dir,TLU )
%PotyFlu
%   Calcula los potenciales y los Flujos de TODOS los arcos del Grafo

[X ] = Flujos(De,A,b,U,pr,trd,Dir,TLU);
[PI] = Potenciales(trd,pr,C,Dir,De);


end
%%Funciones Auxiliares

%% Calcula los potenciales
function [ PI ] = Potenciales(trd,prd,C,Dir,De)

PI = zeros(length(trd),1);
j = trd(1);
while(j~=1)
    i=prd(j);
    if (De(Dir(j))==i)
        PI(j)= PI(i)-C(Dir(j));
    end
    if (De(Dir(j))==j)
        PI(j)= PI(i)+C(Dir(j));
    end 
    j=trd(j);
end
end

%%Calcula los Flujos
function [ X ] = Flujos(De,A,b,U,pred,thread,Dir,TLU)
    b2 = b;
    X = zeros(length(TLU),1);
    k=1;
    while(k<=length(X))
        if(TLU(k)==1)
            X(k) = U(k);
            b2(De(k)) = b2(De(k))-U(k);
            b2(A(k)) = b2(A(k))+U(k);
        end
        k=k+1;
    end
    
    T = zeros(length(pred)-1,1);
    k=1;
    i=thread(1);
    while(k<=length(T))
        T(k)= i;
        k=k+1;
        i=thread(i);
    end
    
    k=length(T);
    
    while(k>0)
        j = T(k);
        i = pred(j);
        
        if(De(Dir(j))==i)
            X(Dir(j)) = -1*b2(j);
        else
            X(Dir(j)) = b2(j);    
        end
        
        b2(i) = b2(i)+ b2(j);
        T(k)=[];
        k=k-1;
    end
    
end

