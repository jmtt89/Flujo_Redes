%%Script que llama las demas Funciones e implementa un Menu

disp ('-- Proyecto 1 --');
disp ('      Menu ');
disp (' ');
archivo= input ('Introduzca el Nombre del Archivo Con la Red\nRecuerde que dicho nombre debe ser Agregado En Comillas Simples\n');
disp (' ');

Ejec = true;
while Ejec;
    resp = -1;
    while (resp~=0 && resp~=1 && resp~=2 && resp~=3 && resp~=4)
        disp ('Introduzca la opción de su elección');
        disp (' ');
        disp ('0. Si desea cambiar el Archivo de la Red')
        disp (' ');
        disp ('1. Si desea ver La representacion de')
        disp ('   la estructura Estrella Directa_Reversa');
        disp (' ');
        disp ('2. Si dese ver Los Arcos Salientes')
        disp ('   y entrantes de algun nodo');
        disp (' ');
        disp ('3. Si desea Ver La descomposision de Flujo');
        disp ('   de la red');
        disp (' ');
        disp ('4. Salir');
        disp (' ');
        resp = input('');
        disp (' ');
    end
    
    if resp == 0
        disp (' ');
        archivo= input ('Introduzca el Nombre del Archivo Con la Red\nRecuerde que dicho nombre debe ser Agregado En Comillas Simples\n');
        disp (' ');
    end
    
    if resp==1
        [ De,A,C,U,X,b,Ap,Ar,Tr ] = Lectura(archivo);
        Imp = [De,A,C,U,X,Tr];
        disp ('     De    A     C     U     X     Tr');
        disp (Imp);
        disp ('     b');
        disp (b);
        disp ('     Ap    Ar');
        Imp = [Ap,Ar];
        disp (Imp);
    end

    if resp==2
        [ De,A,~,~,~,~,Ap,Ar,Tr ] = Lectura(archivo);
        Nodo = input('Introdusca el Nodo Que desea Conseguir\nsus Arcos Entrantes y Salientes\n');
        disp (' ');
        [ LE,LS ] = EntrantesySalientes(Nodo , De, A, Ap, Ar, Tr );
        disp ('Arcos Entrantes');
        i=1;
        while i<=length(LE)
            str = sprintf('%d.- Arco ( %d , %d )', i,LE(i),Nodo);
            disp(str);
            i=i+1; 
        end
        disp (' ');
        disp ('Arcos Salientes');
        i=1;
        while i<=length(LS)
            str = sprintf('%d.- Arco ( %d , %d )', i,Nodo,LS(i));
            disp(str);
            i=i+1; 
        end
    end

    if resp == 3
        [ De,A,~,~,X,~,Ap,Ar,Tr ] = Lectura(archivo);
        disp ('Descomposicion del Flujo');
        disp (' ');
        disp ('Flujo Tope      Descomposicion');
        disp (' ');
        DescFlujo(De,A,X,Ap,Ar,Tr);
    end
    
    if resp == 4
        Ejec = false;
    end
    input('Pulse Enter Para Continuar');
end