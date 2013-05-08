function [ enL,PIrL,enU,PIrU ] = CostosReducidos( De,A,C,PI,TLU )
%CostosReducidos 
%   Devuelve las direcciones a estrella donde se encuentran los arcos
%   Que estan el L y en U y tambien calcula los costos reducidos de
%   Estos Arcos

enL=[];
PIrL=[];
enU=[];
PIrU=[];
cL=1;
cU=1;
k=1;
while k<=length(TLU)
    if(TLU(k)==-1) %%EN L
        enL(cL)=k;
        PIrL(cL)= C(k)-PI(De(k))+PI(A(k));
        cL=cL+1;
    else if (TLU(k)==1) %% EN U
            enU(cU)=k;
            PIrU(cU)= C(k)-PI(De(k))+PI(A(k));
            cU=cU+1;
        end
    end
    k=k+1;
end