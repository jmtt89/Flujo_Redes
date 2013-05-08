%%Script que llama las demas Funciones e implementa un Menu

disp ('-- Proyecto 2 --');
disp ('      Menu ');
disp (' ');
disp ('Introduzca el Nombre del Archivo Con la Red');
disp ('Recuerde que dicho nombre debe ser Agregado En Comillas Simples');
archivo= input ('->');
disp (' ');

Ejec = true;
while Ejec;
    resp = -1;
    while (resp~=0 && resp~=1 && resp~=2 && resp~=3)
        disp ('Introduzca la opción de su elección');
        disp (' ');
        disp ('0. Si desea cambiar el Archivo de la Red')
        disp (' ');
        disp ('1. Si desea ver La representacion de')
        disp ('   la estructura Estrella Directa_Reversa');
        disp (' ');
        disp ('2. Realizar una iteracion de FMC mostrando')
        disp ('   potenciales, flujos, costos reducidos');
        disp (' ');
        disp ('3. Salir');
        disp (' ');
        resp = input('->');
        disp (' ');
    end
    
    if resp == 0
        disp (' ');
		disp ('Introduzca el Nombre del Archivo Con la Red');
		disp ('Recuerde que dicho nombre debe ser Agregado En Comillas Simples');
        archivo= input ('->');
        disp (' ');
    end
    
    if resp==1
        [ De,A,C,U,b,Ap,Ar,Tr,pred,depth,thread,Dir,TLU ] = Lectura(archivo);
        Imp = [De,A,C,U,Tr,TLU];
		disp(' ');
        disp ('     De    A     C     U    Tr    TLU');
		disp(' ');
        disp (Imp);
        Imp = [b,pred,depth,thread,Dir];
        disp ('     b   pred  depth thread Direccion');
		disp(' ');
        disp (Imp);
        Imp = [Ap,Ar];
        disp ('     Ap    Ar');
		disp(' ');
        disp (Imp);
    end
    
    
    if resp==2
        [ De,A,C,U,b,Ap,Ar,Tr,pred,depth,thread,Dir,TLU ] = Lectura(archivo);
        [ PI , X ] = PotyFlu(  De,A,C,U,b,pred,thread,Dir,TLU );
        disp ('Potenciales = Pi');
        disp ('Flujos = X');
		disp(' ');
        disp ('     X');
		disp(' ');
        disp (X);
		disp(' ');
        disp ('     Pi');
		disp(' ');
        disp (PI);
        [ enL,PIrL,enU,PIrU ] = CostosReducidos( De,A,C,PI,TLU );
        disp ('Costos Reducidos Arcos en L')
        ViL=[];
        for i=1:length(enL)
            x = enL(i);        
            str = sprintf('(%d,%d) Cr(%d)=%d', De(x),A(x),x,PIrL(i));
            disp(str);
            if(PIrL(i)<0)
                ViL(length(ViL)+1)=i;
            end
        end
        disp ('Costos Reducidos Arcos en U')
        ViU=[];
        for i=1:length(enU)
            x = enU(i);
            str = sprintf('(%d,%d) Cr(%d)=%d', De(x),A(x),x,PIrU(i));
            disp(str);
            if(PIrU(i)>0)
                ViU(length(ViU)+1)=i;
            end
        end
        
        
        disp(' ');
        disp('Los arcos que violan las condiciones de Optimalidad son:');
        desidido = false;
        
        while(~desidido)
            disp('En L');
            for i=1:length(ViL)
                x = ViL(i);
                str = sprintf('%d.-(%d,%d)', i,De(enL(x)),A(enL(x)));
                disp(str);
            end
            disp('En U');
            for j=1:length(ViU)
                x = ViU(j);
                str = sprintf('%d.-(%d,%d)', i+j,De(enU(x)),A(enU(x)));
                disp(str);
            end
            
			disp ('Introdusca el numero del Arco de su eleccion');
            number= input ('->');
                        
            if(number > 0 && number <= i+j)
                if(number>length(ViL))
                    number=number-i;
                    k = De(enU(ViU(number)));
                    l = A(enU(ViU(number)));
                else
                    k = De(enL(ViL(number)));
                    l = A(enL(ViL(number)));
                end
                desidido = true;                
            else
                disp ('error, arco no valido')
                desidido = false;
            end
            
        end
        
        str = sprintf('Arco Entrante (%d,%d)',k,l);
        disp(str);
        [ p,q,Xn,PIn,asd ] = ArcoSaliente( k,l,De,A,U,C,Ap,pred,depth,thread,Dir,TLU,X,PI);
        
        str = sprintf('Arco Saliente (%d,%d)',p,q);
        disp(str);
        
        Imp=[X,Xn];
        disp('Flujos Actualizados = Xnew')
		disp(' ');
        disp('     X    Xnew');
		disp(' ');
        disp(Imp);
        Imp=[PI,PIn];
        disp('Potenciales Actualizados = PInew')
		disp(' ');
        disp('     PI   PInew');
		disp(' ');
        disp(Imp);
        
    end
    
    if resp == 3
        Ejec = false;
    end
    input('Pulse Enter Para Continuar');    
end
