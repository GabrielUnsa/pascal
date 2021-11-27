program TrabajoNumerica;

uses crt,math,sysutils;
const CaracteresExtra:String='0123456789ABCDEF';
type
  tNumero=record
    entero:string[10];
    decimal:String[32];
    base,exponente:integer;
    signo:boolean;
    end;
TYPE cadena=String[32];
var
   numeroingr:tNumero;
   valor,error,opcion,t_precis:integer;

function busqueda(str,bus: String; b:Integer):Integer;
   var
      ini:Integer;
      fin:Integer;
      med:Integer;
   begin
     ini:=0;
     fin:=b;
     med:=(ini+fin)div 2;
     while((str[med]<>bus) and (ini<=fin))do
       begin
           if(bus<str[med])then
              fin:=med-1
           else
              ini:=med+1;
           med:=(ini+fin)div 2;
       end;
       if(ini<=fin) then
           busqueda:=1
       else
           busqueda:=0;
   end;
function control(numero: String;b:Integer):Integer;
   var f,f2,f3:Integer;
       i:LongInt;
   begin
     f:=0; i:=0; f3:=0;f2:=0;
     while((i<=length(numero))AND(f=0)) do
       begin
           if((b<=16) AND (b>=2)) then
               begin
                  if(busqueda(CaracteresExtra,numero[i],b)=1)then
                     i:=i+1
                  else if((i=1)and (((numero[i]='+'))OR (numero[i]='-')))then
                     begin
                        f3:=1;
                        i:=i+1
                     end
                  else if(((numero[i]=',')and (i<>1)) OR ((numero[i]='.') and (i<>1)) and (f2=0))then
                     begin
                         i:=i+1;
                         f2:=1;
                     end
                  else if((numero[i]=',') OR (numero[i]='.') OR ((numero[i]='+') ) OR ((numero[i]='-')) and (f3=1) and (f2=1))then
                     f:=1
                  else
                     f:=1;
               end
           else
               f:=1;
       end;

       if(f=1) then
           control:=0
       else
           control:=1;
   end;
function DevuelveNumConExp0(num:tnumero):tnumero;//funcion usada solo si exponente!=0
var i:integer; auxCad:string; NUMaux:tnumero;
begin
  NUMaux := num;
  if NUMaux.exponente>0 then //pasara por aqui solo si el exponente es mayor que 0
      begin
        if length(NUMaux.decimal)<NUMaux.exponente then
          begin
            insert(NUMaux.decimal,NUMaux.entero,length(NUMaux.entero)+1);NUMaux.decimal := '0';
            for i:=length(num.decimal)+1 to NUMaux.exponente do
               begin insert('0',NUMaux.entero,length(NUMaux.entero)+1); end;
          end
        else if length(NUMaux.decimal)>=NUMaux.exponente then
          begin
            auxCad := Copy( NUMaux.decimal, 1, NUMaux.exponente);
            insert(auxCad,NUMaux.entero,length(NUMaux.entero)+1);
            delete(NUMaux.decimal,1,NUMaux.exponente);
            if length(NUMaux.decimal)=0 then begin  NUMaux.decimal := '0'; end;
          end;
      end
  else if NUMaux.exponente <0 then  //pasara si el exponente es menor que cero
      begin
        if length(NUMaux.entero)<(-NUMaux.exponente) then
          begin
            insert(NUMaux.entero,NUMaux.decimal,1); NUMaux.entero := '0';
            for i:=length(num.entero)+1 to -NUMaux.exponente do
               begin insert('0',NUMaux.decimal,1); end;
          end
        else if length(NUMaux.entero)>=(-NUMaux.exponente) then
          begin
            auxCad := Copy( NUMaux.entero,length(NUMaux.entero)+1+NUMaux.exponente, length(NUMaux.entero));
            insert(auxCad,NUMaux.decimal,1);
            delete(NUMaux.entero,length(NUMaux.entero)+1+NUMaux.exponente, length(NUMaux.entero));
            if length(NUMaux.entero)=0 then begin  NUMaux.entero := '0'; end;
          end;
      end;

  NUMaux.exponente := 0; DevuelveNumConExp0 := NUMaux;
end;
function convertPFsinN(num:tnumero):tnumero;
var i:integer; auxNUM:tnumero;
begin
  //verificamos que el numero no este normalizado, si lo esta convertirlo => exponente = 0
  if (num.exponente<>0) then begin auxNUM := DevuelveNumConExp0(num); end
  else begin auxNUM := num; end;

  //eliminando 0's de la derecha
  i:=length(auxNUM.decimal);
  while (i>=1) and (auxNUM.decimal[length(auxNUM.decimal)]='0') do
    begin delete(auxNUM.decimal,length(auxNUM.decimal),1); i:=i-1; end;
  if length(auxNUM.decimal)=0 then begin auxNUM.decimal := '0'; end;

  //eliminando 0's de la izquierda
  i:=1;
  while (i<=length(auxNUM.entero)) and (auxNUM.entero[1]='0') do
    begin delete(auxNUM.entero,1,1); i:=i+1; end;
  if length(auxNUM.entero)=0 then begin auxNUM.entero := '0'; end;

  //retorna estructura de numero
  convertPFsinN := auxNUM;
end;
function conversion_2(numero:integer):string;
  begin
       case numero of
            10:result:='A';
            11:result:='B';
            12:result:='C';
            13:result:='D';
            14:result:='E';
            15:result:='F';
            0..9:result:=inttostr(numero);
       end;
  end;
function conversion(digito:string):integer;
  begin
     case digito of
          'A':result:=10;
          'B':result:=11;
          'C':result:=12;
          'D':result:=13;
          'E':result:=14;
          'F':result:=15;
          else Val(digito,conversion);
     end;
  end;
procedure C_Punto_Flotante(var numero:tNumero);
var
   i:integer;
begin
    Val(numero.entero[1],valor,error);
    i:=1;
    if (valor=0) then
    begin
        while i<=Length(numero.decimal) do
        begin
          Val(numero.decimal[i],valor,error);
          if(valor=0) then
          begin
            i:=i+1
          end
          else
              begin
             delete(numero.decimal,1,i-1);
              numero.exponente:=numero.exponente-(i-1);
              i:=Length(numero.decimal)+1;
              end;
        end;
    end
        else
        begin
             numero.exponente:=numero.exponente+Length(numero.entero);
             numero.decimal:=numero.entero+numero.decimal;
             numero.entero:='0';
        end;
end;
function retNum(s: char): integer;
  var
    num: integer;
  begin
    case s of
         '0' : num:=0;
         '1' : num:=1;
         '2' : num:=2;
         '3' : num:=3;
         '4' : num:=4;
         '5' : num:=5;
         '6' : num:=6;
         '7' : num:=7;
         '8' : num:=8;
         '9' : num:=9;
         'A' : num:=10;
         'B' : num:=11;
         'C' : num:=12;
         'D' : num:=13;
         'E' : num:=14;
         'F' : num:=15
    end;
    retNum:=num;
  end;
function retLet(s: string): string;
  begin
    case s of
         '0': retLet:='0';
         '1': retLet:='1';
         '2': retLet:='2';
         '3': retLet:='3';
         '4': retLet:='4';
         '5': retLet:='5';
         '6': retLet:='6';
         '7': retLet:='7';
         '8': retLet:='8';
         '9': retLet:='9';
         '10': retLet:='A';
         '11': retLet:='B';
         '12': retLet:='C';
         '13': retLet:='D';
         '14': retLet:='E';
         '15': retLet:='F'
         end;
  end;
function multiplica(n: char; m: integer): integer;
  begin
    multiplica:=retNum(n)*m;
  end;
function multiplica2(num: string; base: integer): string;
var
  ind, x, y: integer;
  res: string;
begin
  x:=0;
  y:=0;
  for ind:=length(num) downto 1 do
  begin

        x:=multiplica(num[ind],base);
        x:=x+y;
        res:=IntToStr(x mod 10)+res;
        y:=x div 10;
  end;
  if y>0 then res:=IntToStr(y)+res;
  multiplica2:=res;
end;
function suma(n: string; m: string): string;
var
  resultado: string;
  i, j, k, s, d : integer;
begin
  i:=length(n);
  j:=length(m);
  if i<=j then begin
    k:=j;
    j:=j-i;
    d:=0;
    for i:=i downto 1 do begin
          s:=retNum(n[i])+retNum(m[k]);
          k:=k-1;
          s:=s+d;
          d:=0;
          if s>9 then begin
            d:=s div 10;
            s:=s mod 10;
          end;
          resultado:=IntToStr(s)+resultado;
    end;
    if j>0 then begin
      for j:=j downto 1 do begin
            s:=retNum(m[j])+d;
            d:=0;
            if s>9 then begin
               d:=s div 10;
               s:=s mod 10;
            end;
            resultado:=IntToStr(s)+resultado
      end;
    end
    else begin
          if d>9 then begin
            d:=d div 10;
            s:=d mod 10;
            resultado:=IntToStr(s)+resultado;
          end
    end;
    if d>0 then resultado:=IntToStr(d)+resultado;
    suma:=resultado;
  end
  else suma:=suma(m,n);
end;
function sinCero(n: string): string;
var
   tam, band: integer;
   resultado: string;
begin
  band:=1;
  tam:=length(n);
  while band=1 do begin
        if leftStr(n,1)='0' then n:=copy(n,2)
        else band:=0;
  end;
  sinCero:=n;
end;

function multReiterada(num: string ; base: integer): string;
var
  x, y, i, j, k, cont: integer;
  aux, aux2, aux3, resultado: string;
begin
  x:=0;
  cont:=0;
  if base<10 then begin
    aux:=num;
    y:=length(num);
    for i:=1 to 32 do begin
          aux:=multiplica2(aux,base);
          if length(aux)>y then begin
             resultado:=resultado+LeftStr(aux,1);
             aux:=copy(aux,2,length(aux));
          end
          else resultado:=resultado+'0';
    end;
  end
  else begin
      if base>10 then begin
        k:=length(num);
        for i:=1 to 32 do begin
            y:=base mod 10;
            x:= base div 10;
            num:=sinCero(num);
            aux:=multiplica2(num,x);
            aux2:=multiplica2(num,y);
            aux:=aux+'0';
            aux:=sinCero(aux);
            aux2:=sinCero(aux2);
            aux3:=suma(aux,aux2);
            j:=length(aux3)-k;
            if 2=j then begin
              resultado:=resultado+retLet(leftStr(aux3,2));
              num:=copy(aux3,3,length(aux3));
            end
            else begin
                if j=1 then begin
                   resultado:=resultado+retLet(leftStr(aux3,1));
                   num:=copy(aux3,2,length(aux3));
                end
                else begin
                  resultado:=resultado+'0';
                  num:=aux3;
                end;
            end;
        end;
      end
      else begin
          resultado:=num;
      end;
  end;
  multReiterada:=resultado;
end;
function numToChar(num:integer):string;
  begin
       case num of
            10:result:='A';
            11:result:='B';
            12:result:='C';
            13:result:='D';
            14:result:='E';
            15:result:='F';
            0..9:result:=inttostr(num);
       end;
  end;
function divisionReiterada(num:string;baseL:integer):string;
var
	cad:string;
	nro:integer;
  begin
       if(length(num)>=10) then
       begin
          writeln('No puedo convertir este numero, es demasiado grande: ');
          result:=num;
       end
       else begin
             cad:='';
             nro:=strtoint(num);
             while (nro>0) do
                begin
                  insert(numToChar(nro mod baseL),cad,1);
                  nro:=nro div baseL;
                end;
       result:=cad;
       end;
       divisionReiterada:= result;
  end;
function fn_auxRed(caract:char):integer;
var
  nro_caract: integer;
begin
  case caract of
       'A': nro_caract:=10;
       'B': nro_caract:=11;
       'C': nro_caract:=12;
       'D': nro_caract:=13;
       'E': nro_caract:=14;
       'F': nro_caract:=15;
       else Val(caract,nro_caract);
  end;
  fn_auxRed:=nro_caract;
end;
function fn2_auxRed(nro_caract:integer):char;
begin
  case nro_caract of
       10: fn2_auxRed:='A';
       11: fn2_auxRed:='B';
       12: fn2_auxRed:='C';
       13: fn2_auxRed:='D';
       14: fn2_auxRed:='E';
       15: fn2_auxRed:='F';
       else fn2_auxRed:='0';
  end;
end;
procedure Redondeo(part_Int,part_Dec:cadena;Base,t_precis:integer);
  var
    nro_caract: integer;
    cont: integer;
    cont1: integer;
begin

  nro_caract:=fn_auxRed(part_Dec[t_precis+1]);
  if(nro_caract>=(Base div 2)) and (Length(part_Dec)>=t_precis+1) then
  begin

    //Redondeo hacia arriba
    cont:=t_precis;
    nro_caract:=fn_auxRed(part_Dec[cont]);
    while (nro_caract=Base-1) and (cont>=1) do begin
      cont:=cont-1;
      nro_caract:=fn_auxRed(part_Dec[cont]);
    end;
    if(cont=0) then
    begin
      //Parte decimal es de la forma: .kkkkkk..., k=Base
      cont1:=Length(part_Int);
      nro_caract:=fn_auxRed(part_Int[cont1]);
      while(nro_caract=Base-1) and (cont1>=1) do begin
        cont1:=cont1-1;
        nro_caract:=fn_auxRed(part_Int[cont1]);
      end;
      if(cont1=0) then
      begin
        //la parte entera es de la misma forma que la decimal: ...nnnnn. ,n=Base
        write('Formato por redondeo: ',1);
        for cont:=1 to Length(part_Int) do write(0);
        //La parte decimal cambia a 0
        write('.');
        for cont:=1 to t_precis-1 do write(0);
      end else begin
        //La parte entera es de la forma: ...pppnnnnn. ,p<>Base
        write('Formato por redondeo: ');
        for cont:=1 to Length(part_Int) do
        begin
            if(cont=cont1) then
            begin
              nro_caract:=fn_auxRed(part_Int[cont]);
              if(nro_caract>=9) then begin
              write(fn2_auxRed(nro_caract+1));
              end else begin
              write(nro_caract+1)
              end;
            end else begin
                if(cont<cont1) then write(part_Int[cont])
                else write(0);
            end;
        end;
        //La parte decimal cambia a 0
        write('.');
        for cont:=1 to t_precis do write(0);

      end;

    end else begin
      //La parte decimal es de la forma .x1x2x3x4 , existe xi<>Base
      write('Formato por redondeo: ',part_Int);
      write('.');
      for cont1:=1 to t_precis do begin
          nro_caract:=fn_auxRed(part_Dec[cont1]);
          if(cont1=cont) then begin
              if(nro_caract>=9) then
                  write(fn2_auxRed(nro_caract+1))
              else
                  write(nro_caract+1);
          end else begin
              if(cont1<cont) then
                  write(part_Dec[cont1])
              else
                  write(0);
          end;

      end;

    end;

  end else begin
      //El redondeo es hacia abajo
      if(Length(part_Dec)>=t_precis+1) then
      delete(part_Dec,t_precis+1,32);
      write('Formato por Redondeo: ',part_Int,'.',part_Dec);
  end;

  writeln(' en Base ',Base,' con una precision de ',t_precis,' digitos');

end;
procedure Corte(part_Int,part_Dec:cadena;t_precis:integer);

begin
  if(Length(part_Dec)>=t_precis+1) then
  delete(part_Dec,t_precis+1,32);
  writeln('Formato por Corte: ',part_Int,'.',part_Dec,' con una presicion de ',t_precis,' digitos');
end;
function Carga_Numero():integer;
var                                //devolvera 1 si se ingresaron los datos correctos y 0 si no quiso ingresar los datos correctos
    numero:String[66];
    i:integer;
    seguir:boolean;
begin
  writeln('ADVERTENCIA: El numero ingresado debe tener como maximo 10 digitos como parte entera 32 digitos como parte decimal, sin contar el signo');
  seguir:=true;
  writeln('Ingresar Numero: ');
  readln(numero);
  for i:=1 to Length(numero)do
      numero[i]:=Upcase(numero[i]);
  writeln('Ingresar Base: ');
  readln(numeroingr.base);
  writeln('Ingresar Exponente: ');
  readln(numeroingr.exponente);
  while (control(numero,numeroingr.base)=0) and seguir do
    begin
       writeln('El numero ingresado no es valido');
       writeln('Por favor ingrese un nuevo numero: ');
       writeln('Si no desea ingresar ningun numero ponga SALIR');
       readln(numero);
       if (numero[1]='S') or (numero[1]='s') then
       begin
          seguir:=false;
       end
       else
       begin
         for i:=1 to Length(numero)do
           numero[i]:=Upcase(numero[i]);
         writeln('Ingresar Base: ');
         readln(numeroingr.base);
         writeln('Ingresar Exponente: ');
         readln(numeroingr.exponente);
       end;
    end;
  if (seguir=true) then
  begin
    Carga_Numero:=1;
   if (Pos('.',numero)=0) then
   begin
       numeroingr.entero:=Copy(numero,0,Length(numero));
       numeroingr.decimal:='0';
   end
   else
   begin
       numeroingr.entero:=Copy(numero,0,Pos('.',numero)-1);
       numeroingr.decimal:=Copy(numero,Pos('.',numero)+1,Length(numero));
   end;
  end
  else
  begin
    Carga_Numero:=0;
    writeln('Adios');
  end;
  end;
function Menu():Integer;
var
    op:Integer;
   begin
      writeln('Desea convertir su numero?');
      writeln('1-Si');
      writeln('2-No');
      readln(op);
      Menu:=op;
   end;

function sumaPonderada(num: tNumero): tNumero;
var
expo: Byte;
peso: Int64;
i, digitoDecimal: Byte;
numConvert: tNumero;
pesoDecimal: Extended;
begin
   numConvert.Entero:='';
   numConvert.Decimal:='';
   numConvert.base := 10;

   // conversion parte entera
   expo := Length(num.Entero) - 1;
   for i:=1 to Length(num.Entero) do
   begin
      digitoDecimal := fn_auxRed(num.Entero[i]);
      peso := digitoDecimal * trunc(power(num.base, expo));
      numConvert.Entero := suma(numConvert.Entero, IntToStr(peso));
      dec(expo);
   end;

   // conversion parte decimal

   if(StrToInt(num.Decimal[1])=0) and (length(num.decimal)=1) then
   begin
   numConvert.Decimal:='0';
   end
   else
   begin
   expo := 1;
   pesoDecimal:=0;
   for i := 1 to Length(num.Decimal) do
   begin
     pesoDecimal:= pesoDecimal + power(num.base, -expo)*fn_auxRed(num.Decimal[i]);
     Inc(expo);
   end;
   numConvert.exponente:=0;
   numConvert.Decimal := FloatToStr(pesoDecimal);
   Delete(numConvert.Decimal, 1, 2);
   end;
   sumaPonderada := numConvert;
end;

function Menu1():Integer;
var op,b:Integer;
   begin
     writeln('Seleccione una base ([2;16]): ');
     readln(op);
     b:=0;
    while(b=0) do
      begin
           if(op>=2) and (op<=16) then
            begin
             Menu1:=op;
             b:=1;
            end
           else
               begin
                 writeln('Desea ingresar otra base?:1-Si ,<>1-No');
                 readln(op);
                 if(op<>1) then
                 begin
                   b:=1;
                   menu1:=0;
                 end;
               end;
      end;
   end;




var
    numeroConv:tNumero;
begin
  opcion:=Carga_Numero();

  if(opcion=1) then
   begin
    if(Menu()=1) then
    begin
     opcion:=Menu1();
      if(opcion<>1) then
        begin
          numeroingr:=convertPFsinN(numeroingr);  //Obtengo el Numero ingresado sin tipo de notacion y procedo a Convertirlo
          writeln('1.Entero: ',numeroingr.entero);
          writeln('1.Decimal: ',numeroingr.decimal);
          numeroConv.base:=opcion;
          writeln('Base de numeroConv: ',numeroConv.base);
          if(numeroingr.base<>10) then
             begin
                  //numeroingr:=sumaPonderada(numeroingr);
                  writeln('2.Entero: ',numeroingr.entero);
                  writeln('2.Decimal: ',numeroingr.decimal);
             end;
          if(numeroConv.base<>10)then
            begin
             if(numeroConv.entero <> divisionReiterada(numeroingr.entero,numeroConv.base)) then
             begin
             numeroConv.entero := divisionReiterada(numeroingr.entero,numeroConv.base);
             numeroConv.decimal:=multReiterada(numeroingr.decimal,numeroConv.base);
             writeln('3.Entero: ',numeroConv.entero);
             writeln('3.Decimal: ',numeroConv.decimal);

             writeln('****Numero en B`: ****');
             writeln('*-Forma Sin Normalizar: '+numeroConv.entero+'.'+numeroConv.decimal);
             C_Punto_Flotante(numeroConv);
             write('*-Forma Normalizada: ');
             write('0.',(numeroConv.decimal));
             write('10^ ',(numeroConv.exponente));
             writeln('----------------------------------------');
             opcion:=-1;
             end
             else begin writeln('proceda el programa con mismo numero ingresado...!'); end;
            end;


           while(opcion<0) or (opcion>32) do
             begin
             writeln('Ingrese un t para Realizar el Redondeo Simetrico y Truncamiento t>0');
             readln(opcion);
             end;
           C_Punto_Flotante(numeroConv);
           writeln('*-Con Redondeo Simetrico: ');
           Redondeo(numeroConv.entero,numeroConv.decimal,numeroConv.base,opcion);
           writeln('*-Con Truncamiento: ');
           Corte(numeroConv.entero,numeroConv.decimal,opcion);
        end;

    end;

    end;
  readln();
end.

