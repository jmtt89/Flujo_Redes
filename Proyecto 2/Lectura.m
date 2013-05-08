function [ De,A,C,U,b,Ap,Ar,Tr,pr,dp,trd,Dir,TLU ] = Lectura(archivo)
%LECTURA Esta Funcion Lee un Archivo de Texto que contiene una red y
%devuelve la red guardada en una estructura Directa_Reversa

    handler = fopen(archivo);

    line = fgetl(handler);

    while 1
        if(line(1)=='c')
                line = fgetl(handler);
        elseif (line(1) == 'p')
                N = sscanf(line,'%*6c %d');  %Cantidad de Nodos
                M = sscanf(line,'%*6c %*d %d'); %Cantidad de Arcos
                line = fgetl(handler);
                break;
        end
    end

    De = zeros(M,1);
    A  = zeros(M,1);
    C  = zeros(M,1);
    U  = zeros(M,1);
    b  = zeros(N,1);
    Ap = zeros(N+1,1);
    Ar = zeros(N+1,1);
    pr  =zeros(N,1);
    dp  =zeros(N,1);
    trd =zeros(N,1);
    TLU =zeros(M,1);

    while 1
        if(line(1)=='c')
                line = fgetl(handler);
        elseif (line(1) == 'n')
                N = sscanf(line,'%*c %d');
                n = N(1);%numero del nodo
                m = N(2);%oferta/demanda
                p = N(3);%Pred
                d = N(4);%Depth
                t = N(5);%Thread
                b(n) = m;
                pr(n) = p;
                dp(n) = d;
                trd(n) = t;
                line = fgetl(handler);
        else
            break;
        end
    end

k=1;
    while 1
        if(line(1)=='c')
                line = fgetl(handler);
        elseif (line(1) == 'a')
                N = sscanf(line,'%*c %d');
                De(k) = N(1);  %en Cola
                A(k) = N(2);  %en Cabeza
                U(k) = N(3);  %en Capacidad
                C(k) = N(4);  %en Costo
                TLU(k)=N(5);  %Ubicacion en TLU
                k=k+1;
                line = fgetl(handler);
        else
            break;
        end
    end

%%Ahora a ordenar
    
    [De,Indx] = sort(De);
    [A] = OrdenamientoIndexado(A,Indx);
    [C] = OrdenamientoIndexado(C,Indx);
    [U] = OrdenamientoIndexado(U,Indx);
    [TLU] = OrdenamientoIndexado(TLU,Indx);
    
    
%Armar Ap

    Ap = Apuntador_Directo (De,Ap);
    
%%Armar Ar

    Ar = Apuntador_Directo(sort(A),Ar);
    
%%Ordenar Lexicograficamente los A    

    i=1;
    while (i < length(Ap))
        j = Ap(i);
        f = Ap(i+1);
        aOrd = zeros(f-j,1);
        k=1;
        while(j<f)
           aOrd(k)=A(j);
           k=k+1;
           j=j+1;
        end
        [NoUsado,Ind] = sort(aOrd);
        k=1;
        while k<=length(Ind)
            Indx(k+(Ap(i)-1))=Ind(k)+(Ap(i)-1);
            k=k+1;
        end
        i=i+1;
        
    end
    
    [A] = OrdenamientoIndexado(A,Indx);
    [C] = OrdenamientoIndexado(C,Indx);
    [U] = OrdenamientoIndexado(U,Indx);
    [TLU] = OrdenamientoIndexado(TLU,Indx);
    
%%Traza

    [Tr] = Traza(De,A,Ap);
    
%% Dir

    [Dir]= DireccionArcoEstrella(pr,trd,A,Ap);
    
end

%%Funciones Auxiliares 
function [ VectorB ] = Apuntador_Directo ( VectorA,VectorB)
    
    first = VectorA(1);
    k=1;
    while k<=first
        VectorB(k)=1;
        k=k+1;
    end
    j=k;
    k=1;
    while (k<length(VectorA))
        if(VectorA(k)==VectorA(k+1))
           k=k+1;
        else
            if(VectorA(k+1)~=(VectorA(k))+1)
                VectorB(j)=k+1;
                j=j+1;
            end
            VectorB(j)=k+1;
            j=j+1;
            k=k+1;
        end
    end
    VectorB(j)=k+1;
    j=j+1;
    while (j<=length(VectorB))
       VectorB(j) = k+1;
       j=j+1;
    end

end

function [ Tr ] = Traza(De,A,Ap)
    Tr = zeros(length(De),1);
    [RA,Ind ]= sort(A);
    RDe = OrdenamientoIndexado(De,Ind);
    i=1;
    while(i<=length(RDe))
        k1=RDe(i);
        k2=RA(i);
        j=Ap(RDe(i));
        while(j<Ap(RDe(i)+1))
            if((k1==De(j))&&(k2==A(j)))
               Tr(i)= j;
               break;
            else
                j=j+1;
            end
        end
        i=i+1;
    end
    
    
end

function [ RES ] = OrdenamientoIndexado(Vector,Index)
     RES = Vector;     
     k = 1;
     while (k<=length(Index))
        RES(k) = Vector(Index(k));
        k=k+1;
     end
end

function [ Dir ] = DireccionArcoEstrella(pred,thread,A,Ap)

Dir = zeros(length(pred),1);
i = thread(1);
while(i ~= 1)
    j= pred(i);
    Op=Ap(i); %%Opcion 1 es arco (i , j)
    fOp=Ap(i+1);
    encontrado = false;
    
    while( Op < fOp && ~encontrado)
        if(A(Op)==j)
        encontrado = true;
        Dir(i)=Op;
        end
        Op=Op+1;
    end
    
    Op=Ap(j); %%Opcion 2 es arco (j , i)
    fOp=Ap(j+1);
    while( Op < fOp && ~encontrado)
        if(A(Op)==i)
        encontrado = true;
        Dir(i)=Op;
        end
        Op=Op+1;
    end
    i= thread(i);
end

end




