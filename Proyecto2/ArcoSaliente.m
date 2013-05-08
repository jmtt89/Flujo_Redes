function [ p,q,X,PI,TLU ] = ArcoSaliente( k,l,De,A,U,C,Ap,pred,depth,thread,Dir,TLU,Xv,PIv  )
%ARCOSALIENTE 
%   Devuelve los identificadores del arco saliente (p,q), ademas
%   Actualiza el Flujo, Los Potenciales y la estructura TLU
%   En caso que asi se requiera

X = Xv; %%El Nuevo Flujo Inicializado en el Anterior
PI = PIv; %% Los Nuevos Potenciales Inicializados en los anteriores

%% de donde sale (k,l)

%%Buscar en Estrella LA fila donde se encuentra el arco entrante (k,l)
i = Ap(k);
j = Ap(k+1);
encontrado=false;
while(i<j && ~encontrado)
   if(A(i)==l)
       direccion = TLU(i); %% -1 para L 1 para U
       encontrado = true;
       delta(1)=U(i);
       paseo(1)=i;
       orden(1)=direccion*-1;
       kl=i;
   end
   i=i+1;
end


%% Consigue el Apice y consigue los delta de los arcos involucrados
i=k; %% i sigue la rama de k
j=l; %% j sigue la rama de l
t=2;
while i ~= j
        if (direccion == 1) %%Viene de U
            if (depth(i)>depth(j))
                x = pred(i);
                if (De(Dir(i))==i && A(Dir(i))==x)%% Va a Favor
                        delta(t)=U(Dir(i))-X(Dir(i));
                        paseo(t)=Dir(i);
                        orden(t)=1;
                        t=t+1;                    
                else %% Va en contra
                        delta(t)=X(Dir(i));
                        paseo(t)=Dir(i);
                        orden(t)=-1;
                        t=t+1;                    
                end
                i=x;
             else if (depth(i)<depth(j))
                    x = pred(j);
                    if (De(Dir(j))==j && A(Dir(j))==x)%% Va en contra
                        delta(t)=X(Dir(j));
                        paseo(t)=Dir(j);
                        orden(t)=-1;
                        t=t+1;                    
                    else %% Va a favor
                        delta(t)=U(Dir(j))-X(Dir(j));
                        paseo(t)=Dir(j);
                        orden(t)=1;
                        t=t+1;                    
                    end
                    j=x;
                 else %% depth(i) == depth(j) se suben ambos a su pred
                    x = pred(i);
                    if (De(Dir(i))==i && A(Dir(i))==x)%% Va a Favor
                        delta(t)=U(Dir(i))-X(Dir(i));
                        paseo(t)=Dir(i);
                        orden(t)=1;
                        t=t+1;                    
                    else %% Va en contra
                        delta(t)=X(Dir(i));
                        paseo(t)=Dir(i);
                        orden(t)=-1;
                        t=t+1;                    
                    end
                    i=x;
                    
                    x = pred(j);
                    if (De(Dir(j))==j && A(Dir(j))==x)%% Va en contra
                        delta(t)=X(Dir(j));
                        paseo(t)=Dir(j);
                        orden(t)=-1;
                        t=t+1;
                    else %% Va a favor
                        delta(t)=U(Dir(j))-X(Dir(j));
                        paseo(t)=Dir(j);
                        orden(t)=1;
                        t=t+1;                        
                    end
                    j=x;                    
                    
                 end
                 
            end
        else %%Viene de L
            if (depth(i)>depth(j))
                x = pred(i);
                if (De(Dir(i))==i && A(Dir(i))==x)%% Va en contra
                    delta(t)=X(Dir(i));
                    paseo(t)=Dir(i);
                    orden(t)=-1;
                    t=t+1;                    
                else %% Va a favor
                        delta(t)=U(Dir(i))-X(Dir(i));
                        paseo(t)=Dir(i);
                        orden(t)=1;
                        t=t+1;                    
                end
                i=x;
             else if (depth(i)<depth(j))
                    x = pred(j);
                    if (De(Dir(j))==j && A(Dir(j))==x)%% Va a favor
                        delta(t)=U(Dir(j))-X(Dir(j));
                        paseo(t)=Dir(j);
                        orden(t)=1;
                        t=t+1;                    
                    else %% Va en contra
                        delta(t)=X(Dir(j));
                        paseo(t)=Dir(j);
                        orden(t)=-1;
                        t=t+1;
                    end
                    j=x;
                 else %% depth(i) == depth(j) se suben ambos a su pred
                    x = pred(i);
                    if (De(Dir(i))==i && A(Dir(i))==x)%% Va en contra
                        delta(t)=X(Dir(i));
                        paseo(t)=Dir(i);
                        orden(t)=-1;
                        t=t+1;                    
                    else %% Va a favor
                        delta(t)=U(Dir(i))-X(Dir(i));
                        paseo(t)=Dir(i);
                        orden(t)=1;
                        t=t+1;                    
                    end
                    i=x;
                    
                    x = pred(j);
                    if (De(Dir(j))==j && A(Dir(j))==x)%% Va a favor
                        delta(t)=U(Dir(j))-X(Dir(j));
                        paseo(t)=Dir(j);
                        orden(t)=1;
                        t=t+1;
                    else %% Va en contra
                        delta(t)=X(Dir(j));
                        paseo(t)=Dir(j);
                        orden(t)=-1;
                        t=t+1;
                    end
                    j=x;                     
                 end   
            end   
        end
        
%% Lo que tenemos en i y j al salir es el apice del ciclo
end
dt = min(delta); %% en dt tenemos el flujo que se va a ajustar

%%Actualiza flujos y consigue (p,q)
t = 1;
while t<=length(paseo)
    if(orden(t)==1)%%Va a favor
        X(paseo(t))=X(paseo(t))+dt;
    else%% va en encontra
        X(paseo(t))=X(paseo(t))-dt;
    end
    
    %% Si (p,q) Salen a U
    if(X(paseo(t))==U(paseo(t)))
        TLU(paseo(t))=1;
        p = De(paseo(t));
        q = A(paseo(t));
    end
    
    %% Si (p,q) Salen a L
    if(X(paseo(t))==0)
        TLU(paseo(t))=-1;
        p = De(paseo(t));
        q = A(paseo(t));        
    end
    t = t+1;
end

%%Actualiza Potenciales
if(depth(q)>depth(p))
    y = q;
else
    y=p;
end

if(depth(k)<depth(l))
    change = -1*(C(kl)-PI(k)+PI(l));
else
    change = (C(kl)-PI(k)+PI(l));
end


PI(y)=PI(y)+change;
z = thread(y);
while(depth(z)>depth(y))
    PI(z) = PI(z)+change;
    z = thread(z);
end

end