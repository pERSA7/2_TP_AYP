program BibliotecaAbierta;

uses sysutils;
uses crt;

(*
    podriamos usar leer, que solo lee un caracter, y hace que lea mientras caracter <> , porque eso es lo que separa cada palabra, aunque no podriamos definir bien que dato es cada uno    
*)
const
    CSV = 'BIBLIOTECA.csv';
    RUTA_BIBLIOTECA = 'biblioteca.dat';
type
    tRegFecha = record
      dia: 1..31;
      mes: 1..12;
      anio: integer; // o podria ser un rango efectivo [1..9999]
    end;
    tLibro = record
      Codigo: integer;
      titulo: string;
      autor: string;
      fechaPublicacion: tRegFecha;
      cantDisponible: integer;
      precio: real;
      disponible: boolean;
    end;
    tArchivoBiblioteca = file of tLibro;
var
    miArchivo: text;
    biblioteca: tArchivoBiblioteca;
    Aux: tLibro; //se usa como local en cada opcion
    filtro_autor: string; 
    opcion, posicion, cod_ingresante, libros_encontrados : integer;
    

//---------------------------------------------------------------------------------

function ValorDigito (numero: char): integer;
(*
    que hace: recibe un caracter y si pertenece a los digitos del 0 al 9 devuelve su valor numerico, si no pertenece a ese conjunto devuelve -1
    pre: numero = n
    post: ValorDigito = v, v >= 0 si n es un digito del 0 al 9, sino v = -1    
*)
begin
    case (numero) of
        '1': ValorDigito := 1;
        '2': ValorDigito := 2;
        '3': valorDigito := 3;
        '4': ValorDigito := 4;
        '5': ValorDigito := 5;
        '6': ValorDigito := 6;
        '7': ValorDigito := 7;
        '8': valorDigito := 8;
        '9': ValorDigito := 9;
        '0': ValorDigito := 0;
        else
             valorDigito := -1;
    end
end;

//---------------------------------------------------------------------------------

function enteroEnRango(tope1, tope2: integer; msj: string): integer;
var
    n: integer;
begin
    repeat
        writeln(msj);
        readln(n);
    until (n >= tope1) and (n <= tope2);
    enteroEnRango := n;
end;

//---------------------------------------------------------------------------------

function enteroPositivo(msg: string): integer;
(*
    que hace: devuelve un numero >= 0
    pre: msg = m
    post: EnteroPositivo = e, e >= 0    
*)
var
    numero: integer;
begin
    repeat
        writeln(msg);
        readln(numero);
    until numero >= 0;
    enteroPositivo := numero;
end;

//---------------------------------------------------------------------------------

function esMesValido(mes:integer): boolean;
{* Qué hace: Determina si el número de mes recibido corresponde a un mes válido y retorna Verdadero si lo es o Falso en caso contrario.
 Pre: mes = M.
 Pos: esMesValida = Verdadero si M pertenece [1..12]; en caso contrario, esMesValida = Falso. *}
begin
    esMesValido := (mes >= 1) and (mes <= 12);
end;

//---------------------------------------------------------------------------------

function esBisiesto(anio: integer): boolean;
begin
    esBisiesto := (anio mod 400 = 0) or ((anio mod 4 = 0) and (anio mod 100 <> 0));
end;

//---------------------------------------------------------------------------------

function esFechaValida(dia, mes, anio: integer): boolean;
var
    maxDias: integer;
begin
    if not esMesValido(mes) then
    begin
        esFechaValida := false;
    end
    else
    begin
        case mes of
            2:
                if esBisiesto(anio) then
                begin
                    maxDias := 29;
                end
                else
                begin
                    maxDias := 28;
                end;
            4:
                maxDias := 30;
            6:
                maxDias := 30;
            9: 
                maxDias := 30;
            11:
                maxDias := 30;
            else
                maxDias := 31;
        end;
        esFechaValida := (dia >= 1) and (dia <= maxDias);
    end;
end;


//---------------------------------------------------------------------------------

function realPositivo(msg: string): real;
(*
    que hace: devuelve un numero >= 0
    pre: msg = m
    post: EnteroPositivo = e, e >= 0    
*)
var 
    numero: real;
begin
    repeat
        writeln(msg);
        readln(numero);
    until numero >= 0;
    realPositivo := numero;
end;


//----------------------------------------------------------------------------

function ingrese_cadena(msg:string): string;
begin
    writeln(msg);
    readln(ingrese_cadena);
end;

//----------------------------------------------------------------------------

function ingrese_fecha (msg1, msg2, msg3: string): tRegFecha;
var
    anio, mes, dia: integer;
begin
    repeat
        writeln(msg1);
        readln(anio);
        writeln(msg2);
        readln(mes);
        writeln(msg3);
        readln(dia);
        if not(esFechaValida(dia, mes, anio)) then
            writeln('Ingrese una fecha valida.');
    until esFechaValida(dia, mes, anio);
    ingrese_fecha.dia := dia;
    ingrese_fecha.mes := mes;
    ingrese_fecha.anio := anio;
end;

//----------------------------------------------------------------------------

function comparar(prod1, prod2: tLibro): integer;
(*
 qué hace: Compara dos tArchivoBiblioteca.
 Pre: P1= prod1, P2=prod2.
 Pos: comparar=R; R<0 si P1<P2; R=0 si P1=P2; R>0 si P1>P2.
 *)
begin
    comparar := prod1.Codigo - prod2.Codigo; 
end;    


//-----------------------------------------------------------------------
function confirma(msj: string): Boolean;
var
  resp: string;
begin
  repeat
    Write(msj);
    Readln(resp);
    resp := UpCase(resp); // convierte a mayúscula

    if length(resp) = 0 then
    begin
        writeln('ERROR: debe ingresar una respuesta.');
        writeln;
    end
    else if length(resp) > 1 then
    begin
        writeln('ERROR: debe ingresar solamente S o N.');
        writeln;
    end
    else if (resp <> 'S') and (resp <> 'N') then
    begin
        writeln('ERROR: debe ingresar S para continuar o N para finalizar.');
        writeln;
    end;

  until (length(resp) = 1) and ((resp = 'S') or (resp = 'N'));

  confirma := (resp = 'S');
end;

//------------------------------------------------------------------------------

function CalcularPotencia (base, potencia: integer): integer;
(*
    que hace: multiplica base n cantidad de veces
    pre: base = b, potencia = p, p <= 0
    post: CalcularPotencia = c, c = b^p
*)
var
    i, resultado: integer;
begin
    resultado := 1;
    for i := 1 to (potencia) do
        resultado := resultado * base;

    CalcularPotencia := (resultado);
end;

//------------------------------------------------------------------------------

function ValorNumerico (cad: string): integer;
(*
    que hace: recibe una cadena y si todos los caracteres de la misma son digitos del 0 al 9 entonces devuelve su valor numerico, si no devuelve -1
    pre:    cad = c
    post: valor numerico = v, v >= 0 si todos los caracteres de c son digitos del 0 al 9, sino v = -1
*)
const
    BASE = 10;
var
    i, numero, potencia, resultado, digito: integer;
    CodigoError: boolean;
begin
    i := 1;
    CodigoError := false;
    resultado := 0;
    repeat
        digito := ValorDigito(cad[i]);

        if digito = -1 then
        begin
            CodigoError := true;
            resultado := -1;
        end
        else
        begin
            potencia := length(cad) - i;
            numero := digito * (CalcularPotencia(BASE, potencia));
            resultado := (resultado) + (numero);
        end;
        i := i + 1;
    until ((i > length(cad)) or (CodigoError = true));
    ValorNumerico := resultado;
end;

//------------------------------------------------------------------------------

procedure pedirCampo(var reg:tLibro; campo:integer);
(*
  que hace: pide al usuario el valor del campo indicado y lo asigna en reg
  pre: reg = r, campo = c, 1 <= c <= 6
  post: reg = r', igual a r salvo el campo c, que tiene el valor ingresado;
        r'.codigo = r.codigo
*)
begin
    case campo of
        1: reg.titulo := ingrese_cadena('ingrese el titulo');
        2: reg.autor := ingrese_cadena('ingrese el autor');
        3: reg.fechaPublicacion := ingrese_fecha('Ingrese el año', 'Ingrese el mes', 'Ingrese el dia');
        4: reg.cantDisponible := EnteroPositivo('Ingrese la cantidad disponible');
        5: reg.precio := RealPositivo('Ingrese el precio de reposicion');
    end 
end;


//------------------------------------------------------------------------------

procedure insertarProducto(var arch: tArchivoBiblioteca; nuevo: tLibro);
(*
 Qué hace: agrega un nuevo registro respetando el orden.
 Pre: F=Arch, N=nuevo; F está abierto y ordenado.
 Pos: F=F' y F' esta ordenado y F' = F U {N}
 *)
 var 
    pos: integer;
    p: tLibro;
    encontroLugar: boolean;
begin
    pos := filesize(arch) - 1;
    encontroLugar := false;
    while (pos >= 0) and (not encontroLugar) do
    begin
        seek(arch, pos);
        read(arch, p);
        if comparar(nuevo, p) < 0 then
        begin
            write(arch, p);
            pos := pos - 1;
        end
        else
        begin
            encontroLugar := true;
        end
    end;
    seek(arch, pos + 1);
    write(arch, nuevo);
end;

//-------------------------------------------------------------------------------

procedure ingresoNuevoLibro(var biblioteca: tArchivoBiblioteca; cod: integer);
{ que hace: pide los datos de un libro nuevo y lo da de alta en el archivo
  pre: biblioteca = b, abierto y ordenado por codigo; cod no existe en b
  post: biblioteca = b', ordenado por codigo, con el libro de codigo cod dado de alta }
var
  nuevo: tLibro;
  campo: integer;
begin
    nuevo.codigo := cod;
    for campo := 1 to 5 do
        pedirCampo(nuevo, campo);
    nuevo.disponible := true;
    insertarProducto(biblioteca, nuevo);
end;

//-----------------------------------------------------------------------------

function buscar(var elementos:tArchivoBiblioteca;  p,f: integer; elemento: integer ): integer;
(*
 Qué hace: busca la posición de un elemento en un arreglo.
 Pre-condición: A=elementos, P=p, F=f, E=elemento; [P..F] ⊆ rango(tLista); A esta ordenada.
 Pos-condición: buscar = Pos;  Pos = -1 si no el elemento no está,  Pos = i, si A[i] = E
*)

Var
    m : integer;
    aux: tLibro;
begin
    if f < p then
    begin
        buscar := -1;
    end
    else
    begin
        m := (p+f) div 2;
        seek(elementos, m);
        read(elementos, aux);
        if aux.codigo = elemento then
        begin
            buscar := m;
        end
        else
        begin
            if elemento < aux.codigo then
            begin
                buscar := buscar(elementos, p, m - 1, elemento);
            end
            else
            begin
                buscar := buscar(elementos, m + 1, f, elemento);
            end
        end
    end
end;

//-----------------------------------------------------------------------------

function ArmarCampo(var miArchivo: text): string;
(*
    que hace: recorre un archivo de tipo texto concatenando caracteres distintos de coma en una variable de tipo cadena
    pre: miArchivo = m
    post: ArmarCampo = a
*)
var
    caracter_leido: char;
    aux_cadena: string;
begin
    caracter_leido := ' ';
    aux_cadena := '';
    while not(eoln(miArchivo)) and (caracter_leido <> ',') and (caracter_leido <> '/') do
    begin
        read(miArchivo, caracter_leido);
        if (caracter_leido <> ',') and (caracter_leido <> '/') then
            aux_cadena := concat(aux_cadena, caracter_leido);
    end;
    ArmarCampo := aux_cadena;
end;

//---------------------------------------------------------------------------------

procedure ArmarFecha(var miArchivo: text; var fecha: tRegFecha);
(*
    que hace: arma el campo de la fecha de publicacion de un registro tipo tLibro
    pre: miArchivo = m
    post: aux_registro.fechaPublicacion = a   
*)
var
    code: integer;
    tempStr: string;
begin
    tempStr := ArmarCampo(miArchivo);
    val(tempStr, fecha.dia, code);

    tempStr := ArmarCampo(miArchivo);
    val(tempStr, fecha.mes, code);

    tempStr := ArmarCampo(miArchivo);
    val(tempStr, fecha.anio, code);
end;

//------------------------------------------------------------------------------

procedure editarRegistro(var reg: tLibro);
(*
  que hace: permite modificar los campos de un libro (excepto codigo y disponible)
  pre: reg = r
  post: reg = r', r'.codigo = r.codigo; el resto de los campos tiene el valor que eligió el usuario
*)
var 
    campo: integer;
begin
    repeat
        writeln('1: Titulo');
        writeln('2: Autor ');
        writeln('3: Fecha');
        writeln('4: Cantidad');
        writeln('5: Precio');
        campo := enteroEnRango(1, 5, '¿Que campo desea modificar?');
        pedirCampo(reg, campo);
    until not(confirma('¿Desea modificar otro campo?'))
end;

//------------------------------------------------------------------------------

procedure MostrarMenu(var opcion: integer);
begin
        writeln('=================================');
        writeln('1. Ingresar un ejemplar');
        writeln('2. Modificar un ejemplar ');
        writeln('3. Dar de baja un ejemplar');
        writeln('4. Dar de alta un ejemplar');
        writeln('5. Mostrar un ejemplar por su codigo');
        writeln('6. Listar ejemplares por autor');
        writeln('7. Listar ejemplares dados de alta');
        writeln('8. Listar ejemplares dados de baja');
        writeln('0. Salir');
        opcion := enteroEnRango(0, 8, 'Seleccione la opcion que desea llevar a cabo');
end;

//------------------------------------------------------------------------

procedure mostrarRegistro(reg: tLibro);
(*
    que hace: muestra en pantalla los campos de un libro
    pre: reg = r
    post: -
*)
begin
    writeln('===============================================');
    writeln('Código: ', reg.codigo);
    writeln('Título: ', reg.titulo);
    writeln('Autor: ', reg.autor);
    writeln('Fecha Publicacion: ', reg.fechaPublicacion.dia, '/', reg.fechaPublicacion.mes, '/', reg.fechaPublicacion.anio);
    writeln('Cant. Disponible: ', reg.cantDisponible);
    writeln('Precio: ', reg.precio);
    if reg.disponible then
    begin
        writeln('Estado: ALTA (Disponible)');
    end
    else
    begin
        writeln('Estado: BAJA');
    end;
    writeln('===============================================');
end;

//------------------------------------------------------------------------

//procedure opcionIngresar(var biblioteca: tArchivoBiblioteca);
(*
    que hace: pide un codigo y, si no esta registrado (ni de alta ni de baja), pide el resto de los datos y lo ingresa
    pre: biblioteca = b, cerrado
    post: biblioteca = b', con un ejemplar mas si el codigo no estaba en b; sino b' = b

var
    cod, pos: integer;
    aux: tLibro;
begin
    reset(biblioteca);
    cod_ingresante := enteroPositivo('ingrese el codigo del libro que desea ingresar'); //devuelve un positivo sin tener una cota superior
    posicion := buscar(biblioteca, 0, filesize(biblioteca) - 1, cod_ingresante);
    if posicion = -1 then
    begin
        ingresoNuevoLibro(biblioteca, cod_ingresante); //pedira todo lo necesario para ingresar un nuevo libro
    end
        else
        begin
            writeln('Ese codigo ya esta registrado');
            if (confirma('¿Desea editar el libro asociado a ese codigo?')) then
            begin
                seek(biblioteca, posicion);
                read(biblioteca, Aux);
                if Aux.disponible then
                begin
                    editarRegistro(Aux); // a prori el cabezal ya esta posicionado en donde debe modificar
                    seek(biblioteca, posicion);
                    write(biblioteca, Aux);
                end
            end;
        end;
    close(biblioteca);
*)
                

//------------------------------------------------------------------------

//rocedure opcionModificar(var biblioteca: tArchivoBiblioteca);
(*
    que hace: pide un codigo y, si el ejemplar existe y esta de alta, permite modificar sus datos (menos el codigo)
    pre: biblioteca = b, cerrado
    post: biblioteca = b'; solo cambia el registro elegido, y solo si estaba de alta
*)

//------------------------------------------------------------------------

//procedure cambiarEstado(var biblioteca: tArchivoBiblioteca);
(*
    que hace: da de alta (activar = verdadero) o de baja (activar = falso) un ejemplar existente
    pre: biblioteca = b, cerrado; activar = a
    post: biblioteca = b'; si el codigo existe y su estado era distinto de a, ahora disponible = a; sino b' = b
*)

//------------------------------------------------------------------------

//procedure opcionMostrar(var biblioteca: tArchivoBiblioteca);
(*
    que hace: pide un codigo y muestra el ejemplar, este de alta o de baja
    pre: biblioteca = b, cerrado
    post: biblioteca = b' = b
*)

//------------------------------------------------------------------------

//procedure listarPorAutor(var biblioteca:tArchivoBiblioteca; alta: boolean);
(*
    que hace: pide un autor y muestra los ejemplares dados de alta de ese autor
    pre: biblioteca = b, cerrado
    post: biblioteca = b' = b
*)

//------------------------------------------------------------------------

//procedure listarPorEstado(var biblioteca:tArchivoBiblioteca; baja: Boolean);
(*
    que hace: muestra los ejemplares dados de alta (alta = verdadero) o de baja (alta = falso)
    pre: biblioteca = b, cerrado; alta = a
    post: biblioteca = b' = b
*)

//------------------------------------------------------------------------




//------------------------------------------------------------------------

procedure importar(var miArchivo: text; var biblioteca: tArchivoBiblioteca);
(*
    que hace: importa y clasifica la informacion de un archivo tipo texto a otro archivo de tLibro
    pre: miArchivo = m, m debe tener una cabecera en la primer fila, biblioteca = b
    post: biblioteca = b'
*)
var
    aux_registro: tLibro;
    descarte, aux_cadena: string;
    code, posicion, registrados: integer;
begin
    registrados := 0;
    readln(miArchivo, descarte);   // descarta la cabecera, UNA sola ve
    while not eof(miArchivo) do
    begin
        aux_cadena := ArmarCampo(miArchivo);
        val(aux_cadena, aux_registro.codigo, code);

        aux_registro.titulo := ArmarCampo(miArchivo);
        aux_registro.autor  := ArmarCampo(miArchivo);

        ArmarFecha(miArchivo, aux_registro.fechaPublicacion);  // lee dia/mes/ano separados por '/'

        aux_cadena := ArmarCampo(miArchivo);
        val(aux_cadena, aux_registro.cantDisponible, code);

        aux_cadena := ArmarCampo(miArchivo);          // <<  precio_reposicion
        val(aux_cadena, aux_registro.precio, code);   //    val también funciona para reales 

        aux_registro.disponible := (uppercase(ArmarCampo(miArchivo)) = 'TRUE');

        posicion := buscar(biblioteca, 0, filesize(biblioteca) - 1, aux_registro.codigo);
        if posicion = -1 then
            insertarProducto(biblioteca, aux_registro)      // mantiene el orden por codigo
        else
            registrados := registrados + 1;

        readln(miArchivo, descarte);   // consume el fin de línea de cada registro
    end;
    if registrados > 0 then
        writeln('Cantidad de ejemplares omitidos por repeticion de codigo: ', registrados);
        
end;

//---------------------------------------------------------------------------------

begin

    if FileExists(CSV) then
    begin
        if not(FileExists(RUTA_BIBLIOTECA)) then //comprobamos primero que no exista y recien ahi creamos, sino siempre q se ejecute va a crearlo y sobreescribir lo anterior
        begin
            assign(biblioteca, RUTA_BIBLIOTECA); 
            rewrite(biblioteca);  
        end
        else
        begin
            assign(biblioteca, RUTA_BIBLIOTECA);
            reset(biblioteca);
        end;
        assign(miArchivo, CSV); 
        reset(miArchivo);
        importar(miArchivo, biblioteca); // importar(fuente, destino)     
    end;
    close(miArchivo);     
    close(biblioteca);
    repeat
        MostrarMenu(opcion); 
        case opcion of
            1: //opcion de ingresar
            begin
                assign(biblioteca, RUTA_BIBLIOTECA);
                reset(biblioteca);
                cod_ingresante := enteroPositivo('ingrese el codigo del libro que desea ingresar'); //devuelve un positivo sin tener una cota superior
                posicion := buscar(biblioteca, 0, filesize(biblioteca) - 1, cod_ingresante);
                if posicion = -1 then
                begin
                    ingresoNuevoLibro(biblioteca, cod_ingresante); //pedira todo lo necesario para ingresar un nuevo libro
                end
                    else
                    begin
                        writeln('Ese codigo ya esta registrado');
                        if (confirma('¿Desea editar el libro asociado a ese codigo?')) then
                        begin
                            seek(biblioteca, posicion);
                            read(biblioteca, Aux);
                            if Aux.disponible then
                            begin
                                editarRegistro(Aux); // a prori el cabezal ya esta posicionado en donde debe modificar
                                seek(biblioteca, posicion);
                                write(biblioteca, Aux);
                            end
                        end;
                    end;
                close(biblioteca);
            end;
            2: //opcion de modificar
            begin
                assign(biblioteca, RUTA_BIBLIOTECA);
                reset(biblioteca);
                cod_ingresante := enteroPositivo('ingrese el codigo del libro que desea modificar');
                posicion := buscar(biblioteca, 0, filesize(biblioteca) - 1, cod_ingresante);
                if posicion <> -1 then
                begin
                    seek(biblioteca, posicion);
                    read(biblioteca, Aux);
                    if Aux.disponible then 
                    begin
                        editarRegistro(Aux);
                        seek(biblioteca, posicion);
                        write(biblioteca, Aux);
                    end;
                end;
                close(biblioteca);
            end;
            3: //opcion de eliminar
            begin
                assign(biblioteca, RUTA_BIBLIOTECA);
                reset(biblioteca);
                cod_ingresante := enteroPositivo('ingrese el codigo del libro que desea dar de baja');
                posicion := buscar(biblioteca, 0, filesize(biblioteca) - 1, cod_ingresante);
                if posicion <> -1 then
                begin
                    seek(biblioteca, posicion);
                    read(biblioteca, Aux);
                    if Aux.disponible then
                    begin
                        Aux.disponible := false;
                        seek(biblioteca, posicion);
                        write(biblioteca, Aux);
                        writeln('Dado de baja exitosamente.');
                    end
                        else
                            writeln('El libro ya se encuentra dado de baja');
                end
                    else
                        writeln('El libro no se encuentra registrado');
                close(biblioteca);
            end;
            4: //opcion de activar ejemplar
            begin
                assign(biblioteca, RUTA_BIBLIOTECA);
                reset(biblioteca);
                cod_ingresante := enteroPositivo('ingrese el codigo del libro que desea dar de alta');
                posicion := buscar(biblioteca, 0, filesize(biblioteca) - 1, cod_ingresante);
                if posicion <> -1 then
                begin
                    seek(biblioteca, posicion);
                    read(biblioteca, Aux);
                    if not(Aux.disponible) then
                    begin
                        Aux.disponible := true;
                        seek(biblioteca, posicion);
                        write(biblioteca, Aux);
                    end
                        else
                            writeln('El libro ya esta dado de alta');
                end
                    else
                        writeln('El libro no se encuentra registrado');
                close(biblioteca);
            end;
            5: //mostrar ejemplar
            begin
                assign(biblioteca, RUTA_BIBLIOTECA);
                reset(biblioteca);
                cod_ingresante := enteroPositivo('ingrese el codigo del libro que desea ver');
                posicion := buscar(biblioteca, 0, filesize(biblioteca) - 1, cod_ingresante);
                if posicion <> -1 then
                begin
                    seek(biblioteca, posicion);
                    read(biblioteca, Aux);
                    mostrarRegistro(Aux);
                end
                    else
                        writeln('El libro no se encuentra registrado');
                close(biblioteca);
            end;
            6: //muestra libros por autor
            begin
                assign(biblioteca, RUTA_BIBLIOTECA);
                reset(biblioteca);
                writeln('ingrese el nombre del autor por el cual se debe filtrar');
                readln(filtro_autor);
                seek(biblioteca, 0);
                libros_encontrados := 0;
                while not(eof(biblioteca)) do
                begin
                    read(biblioteca, Aux);
                    if Aux.autor = filtro_autor then
                    begin
                        mostrarRegistro(Aux);
                        libros_encontrados := libros_encontrados + 1;
                    end;
                end;
                if libros_encontrados = 0 then
                begin
                    writeln('No se encontraron libros registrados de ese autor');
                end;
                close(biblioteca);
            end;
            7: //muestra llibros dados de alta
            begin
                assign(biblioteca, RUTA_BIBLIOTECA);
                reset(biblioteca);
                seek(biblioteca, 0);
                libros_encontrados := 0;
                while not(eof(biblioteca)) do
                begin
                    read(biblioteca, Aux);
                    if Aux.disponible then
                    begin
                        mostrarRegistro(Aux);
                        libros_encontrados := libros_encontrados + 1;
                    end;
                end;
                if libros_encontrados = 0 then
                begin
                    writeln('No se encontraron libros registrados que esten dados de alta');
                end;
                close(biblioteca);
            end;
            8:
            begin
                assign(biblioteca, RUTA_BIBLIOTECA);
                reset(biblioteca);
                seek(biblioteca, 0);
                libros_encontrados := 0;
                while not(eof(biblioteca)) do
                begin
                    read(biblioteca, Aux);
                    if not(Aux.disponible) then
                    begin
                        mostrarRegistro(Aux);
                        libros_encontrados := libros_encontrados + 1;
                    end;
                end;
                if libros_encontrados = 0 then
                begin
                    writeln('No se encontraron libros registrados que esten dados de baja');
                end;
                close(biblioteca);
            end;
        end;
    until opcion = 0;
end.