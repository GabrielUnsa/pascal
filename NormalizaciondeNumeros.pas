unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ComCtrls, ExtDlgs, ExtCtrls, crt,math;

type

  { TventPrinc }

  TventPrinc = class(TForm)
    BaseLleg: TSpinEdit;
    BaseNumConv1: TSpinEdit;
    btnConv: TButton;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lblFormCNorm2: TLabel;
    lblFormCNorm3: TLabel;
    lblFormSinNorm2: TLabel;
    lblFormSNorm: TLabel;
    lblFormSinNorm1: TLabel;
    lblFormCNorm1: TLabel;
    lblNumConv: TLabel;
    lblMNumOr: TLabel;
    LBLmostNum: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblExpNumIngr: TLabel;
    lblNumConv1: TLabel;
    lblNumConv2: TLabel;
    lblNumero: TLabel;
    lblBasIngr: TLabel;
    NumIngr: TEdit;
    BaseNumIngr: TSpinEdit;
    ExpNumIngr: TSpinEdit;
    procedure btnConvClick(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

  const CaracteresExtra:String='0123456789ABCDEF';


  const numOr:string='Numero Original: ';
    NumConvSN:string='**Forma sin Normalizar: ';
    NumConvCN:string='**Forma Normalizada: ';



  type
    tNumero=record
      entero:string;
      decimal:String[32];
      base,exponente:integer;
      signo:boolean;
      end;
  TYPE cadena=String[32];


var
  ventPrinc: TventPrinc;
  numeroingr:tNumero;

implementation

{$R *.lfm}

{ TventPrinc }
//metodos usados para el control de entrada . .
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
                  else if(((numero[i]='.') and (i<>1)) and (f2=0))then
                     begin
                         i:=i+1;
                         f2:=1;
                     end
                  else if((numero[i]='.') OR ((numero[i]='+') ) OR ((numero[i]='-')) and (f3=1) and (f2=1))then
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
function Controla_Dig_32(num:tNumero):tNumero;
var i:integer;
  cant:integer;
begin
    if length(num.entero+num.decimal)>33 then
    begin
       if (length(num.entero)=1) and (num.entero[1]='0') then
       begin cant:=length(num.decimal)-32;end
       else  begin cant:=length(num.entero+num.decimal)-32; end;

      i:=1;
      while (length(num.decimal)<>0) and (i<=cant) do
         begin
           delete(num.decimal,length(num.decimal),1);
           i:=i+1;
         end;
      if (i<=cant) then
         begin
           num.decimal:='0';
           while(i<=cant) do
              begin delete(num.entero,length(num.entero),1); i:=i+1; end;
         end;
    end;
    Controla_Dig_32:=num;

end;

//metodos usados por la desnormalizacion y normalizacion de numeros
function eliminaCeros(num:tNumero):tNumero; //elimina los ceros de la derecha e izquierda
var i:integer;
begin
 //eliminando 0's de la derecha
 i:=length(num.decimal);
 while (i>=1) and (num.decimal[length(num.decimal)]='0') do
   begin delete(num.decimal,length(num.decimal),1); i:=i-1; end;
 if length(num.decimal)=0 then begin num.decimal := '0'; end;

 //eliminando 0's de la izquierda
 i:=1;
 while (i<=length(num.entero)) and (num.entero[1]='0') do
   begin delete(num.entero,1,1); i:=i+1; end;
 if length(num.entero)=0 then begin num.entero := '0'; end;

eliminaCeros := num;
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
              begin insert('0',NUMaux.entero,length(NUMaux.entero)+1);   end;
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
function convertPFsinN(num:tnumero):tnumero;  //devuelve numero en su forma original
var auxNUM:tnumero;
begin
  //verificamos que el numero no este normalizado, si lo esta convertirlo => exponente = 0
  if (num.exponente<>0) then begin auxNUM := DevuelveNumConExp0(num); end
  else begin auxNUM := num; end;
  auxNUM := eliminaCeros(auxNUM);
  //retorna estructura de numero
  convertPFsinN := auxNUM;
end;
function C_Punto_Flotante(num:tNumero):tNumero;
begin
    writeln(num.exponente);
    if (length(num.entero)=1) and (num.entero[1]='0') then
      begin
         while num.decimal[1]='0' do
           begin
             delete(num.decimal,1,1);
             num.exponente := num.exponente-1;
           end;
      end
    else
      begin
         num.exponente := num.exponente + length(num.entero);
         insert(num.entero,num.decimal,1);
         num.entero := '0';
      end;
      num := eliminaCeros(num);
      C_Punto_Flotante := num;
end;

//metodos usados por la division reiterada . .
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
	nro:longint;
  begin


           cad:='';
           nro:=strtoint(num);
           while (nro>0) do
             begin
               insert(numToChar(nro mod baseL),cad,1);
               nro:=nro div baseL;
             end;
           result:=cad;


  end;

//modulos usados por la multiplicacion reiterada . . .
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
          multReiterada:=num;
      end;
  end;
  multReiterada:=resultado;
end;

//metodos usados para el redondeo y corte . .
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
function Corte(num:tNumero;t_precis:integer):tNumero;//trabaja solo con numeros normalizados
begin
  if length(num.decimal)>t_precis then
    begin
      delete(num.decimal,t_precis+1,length(num.decimal)-t_precis);
    end;
  Corte := num;
end;
function Redondeo(num:tNumero;t_precis:integer):tNumero;
  var
    nro_caract: integer;
    cont: integer;
    cont1: integer;
    num1: tNumero;
begin

  nro_caract:=fn_auxRed(num.decimal[t_precis+1-length(num.entero)]);
  if(nro_caract>=(num.base div 2)) and (Length(num.decimal)>=t_precis-Length(num.entero)+1) then
  begin

    //Redondeo hacia arriba
    cont:=t_precis-Length(num.entero);
    nro_caract:=fn_auxRed(num.decimal[cont]);
    while (nro_caract=num.base-1) and (cont>=1) do begin
      cont:=cont-1;
      nro_caract:=fn_auxRed(num.decimal[cont]);
    end;
    if(cont=0) then
    begin
      //Parte decimal es de la forma: .kkkkkk..., k=Base
      cont1:=Length(num.entero);
      nro_caract:=fn_auxRed(num.entero[cont1]);
      while(nro_caract=num.base-1) and (cont1>=1) do begin
        cont1:=cont1-1;
        nro_caract:=fn_auxRed(num.entero[cont1]);
      end;
      if(cont1=0) then
      begin
        //la parte entera es de la misma forma que la decimal: ...nnnnn. ,n=Base
        num1.entero[1]:='1';
        for cont:=1 to Length(num.entero) do num1.entero[cont+1]:='0';
        //La parte decimal cambia a 0
        for cont:=1 to t_precis-Length(num.entero)-1 do num1.decimal[cont]:='0';
      end else begin
        //La parte entera es de la forma: ...pppnnnnn. ,p<>Base
        for cont:=1 to Length(num.entero) do
        begin
            if(cont=cont1) then
            begin
              nro_caract:=fn_auxRed(num.entero[cont]);
              num1.entero[cont]:=fn2_auxRed(nro_caract+1);
            end else begin
                if(cont<cont1) then num1.entero[cont]:=num.entero[cont]
                else num1.entero[cont]:='0';
            end;
        end;
        //La parte decimal cambia a 0
        for cont:=1 to t_precis-Length(num.entero) do num1.decimal:='0';
      end;
    end else begin
      //La parte decimal es de la forma .x1x2x3x4 , existe xi<>Base
      write('Formato por redondeo: ',num.entero);
      write('.');
      num1.entero:=num.entero;
      for cont1:=1 to t_precis-Length(num.entero) do begin
          nro_caract:=fn_auxRed(num.decimal[cont1]);
          if(cont1=cont) then begin
              num1.decimal[cont]:=fn2_auxRed(nro_caract+1);
          end else begin
              if(cont1<cont) then
                  num1.decimal[cont1]:=num.decimal[cont1]
              else
                  num1.decimal[cont1]:='0';
          end;
      end;
    end;
  end else begin
      num1:=Corte(num,t_precis);
  end;
  Redondeo := num1;
end;

//metodos usados para el signo del numero . .
function Carga_Signo(var numero:string):Boolean;
begin
   if(numero[1]='-')then
    begin
       Carga_Signo:=False;
       Delete(numero,1,1);
    end
    else
    begin
       Carga_Signo:=True;
       if(numero[1]='+') then Delete(numero,1,1);
    end;
end;
function Devuelve_Signo(signo:boolean):String;
begin
  if(signo=False) then
    Devuelve_Signo:='-'
  else
    Devuelve_Signo:='';
end;

//SumaPonderada
function CharToNum(caract:char):integer;
   begin
    case caract of
   'A': CharToNum:=10;
   'B': CharToNum:=11;
   'C': CharToNum:=12;
   'D': CharToNum:=13;
   'E': CharToNum:=14;
   'F': CharToNum:=15;
   else Val(caract,CharToNum);
 end;
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
      digitoDecimal := CharToNum(num.Entero[i]);
      peso := digitoDecimal * trunc(power(num.base, expo));
      numConvert.Entero := suma(numConvert.Entero, IntToStr(peso));
      dec(expo);
   end;

   // conversion parte decimal

   if(CharToNum(num.Decimal[1])=0) and (length(num.decimal)=1) then
   begin
   numConvert.Decimal:='0';
   end
   else
   begin
   expo := 1;
   pesoDecimal:=0;
   for i := 1 to Length(num.Decimal) do
   begin
     pesoDecimal:= pesoDecimal + power(num.base, -expo)*CharToNum(num.Decimal[i]);
     Inc(expo);
   end;
   numConvert.exponente:=0;
   numConvert.Decimal := FloatToStr(pesoDecimal);
   Delete(numConvert.Decimal, 1, 2);
   end;
   numConvert.signo:=num.signo;
   numConvert.exponente:=num.exponente;
   sumaPonderada := numConvert;
end;


procedure TventPrinc.btnConvClick(Sender: TObject);
var numero:string;i:integer;
  numSinNorm,numConNorm,NumConvertido:tNumero;
begin
  numero := NumIngr.Text;
  //cargando datos necesarios para el control . . .
  for i:=1 to Length(numero)do begin numero[i]:=Upcase(numero[i]); end;
  numeroingr.base:=BaseNumIngr.Value;
  numeroingr.exponente:=ExpNumIngr.Value;
  if (length(numero)>0) and (control(numero,numeroingr.base)<>0) then
    begin
         //cargando numerooo . . . .
         numeroingr.signo:=Carga_Signo(numero);
         if (Pos('.',numero)=0) then begin
            numeroingr.entero:=Copy(numero,0,Length(numero)); numeroingr.decimal:='0';
            end
         else  begin numeroingr.entero:=Copy(numero,0,Pos('.',numero)-1);
            numeroingr.decimal:=Copy(numero,Pos('.',numero)+1,Length(numero)); end;

          //convirtiendo numero a su forma original matematicamente . . . .

          //ShowMessage('El numero ingresado es matematicamente: '+numeroingr.entero+'.'+numeroingr.decimal);
          numeroingr := convertPFsinN(numeroingr);
         if (length(numeroingr.entero)<=10) then begin
            if (numeroingr.base <> 10)then begin
               NumConvertido:=NumeroIngr;
               NumConvertido:=SumaPonderada(NumConvertido);
               if(BaseLleg.Value <> 10)then
                 begin
                   NumConvertido.entero := divisionReiterada(NumConvertido.entero,BaseLleg.Value);
                   NumConvertido.decimal := multReiterada(NumConvertido.decimal,BaseLleg.Value);
                   NumConvertido.base := BaseLleg.Value;
                   NumConvertido := eliminaCeros(NumConvertido);
                   NumConvertido := Controla_Dig_32(NumConvertido);
                 end;
            end;
            if (numeroingr.base = 10) and (BaseLleg.Value<>10) then begin

              //convirtiendo numero con devision y multiplicacion reiterada. .
              NumConvertido := numeroingr;
              NumConvertido.entero := divisionReiterada(NumConvertido.entero,BaseLleg.Value);
              NumConvertido.decimal := multReiterada(NumConvertido.decimal,BaseLleg.Value);
              NumConvertido.base := BaseLleg.Value;
              NumConvertido := eliminaCeros(NumConvertido);
              NumConvertido := Controla_Dig_32(NumConvertido);
            end;
            if (BaseLleg.Value=10) and (numeroingr.base = 10) then begin //ShowMessage('Numero Convertido: '+numeroingr.entero+'.'+numeroingr.decimal);
                  NumConvertido := numeroingr end;
            ShowMessage('NUMERO CONVERTIDO: '+Devuelve_Signo(NumConvertido.signo)+NumConvertido.entero+'.'+NumConvertido.decimal);
            numConNorm := C_Punto_Flotante(NumConvertido);
            numSinNorm  := convertPFsinN(corte(numConNorm,32));
            //lebeles del numero convertido . .
            lblMNumOr.Caption := numOr+Devuelve_Signo(NumConvertido.signo)+numeroingr.entero+'.'+numeroingr.decimal;
            lblFormSNorm.Caption := NumConvSN+Devuelve_Signo(NumConvertido.signo)+numSinNorm.entero+'.'+numSinNorm.decimal;
            lblFormCNorm1.Caption := NumConvCN+Devuelve_Signo(NumConvertido.signo)+numConNorm.entero+'.'+numConNorm.decimal+'*'+IntToStr(NumConvertido.base)+'^'+inttostr(numConNorm.exponente);

            //lebeles del numero convertido truncado . .
            numConNorm := Corte(numConNorm,BaseNumConv1.Value);
            numSinNorm := convertPFsinN(numConNorm);
            lblFormSinNorm1.Caption := NumConvSN+Devuelve_Signo(NumConvertido.signo)+numSinNorm.entero+'.'+numSinNorm.decimal;
            lblFormCNorm2.Caption := NumConvCN+Devuelve_Signo(NumConvertido.signo)+numConNorm.entero+'.'+numConNorm.decimal+'*'+IntToStr(NumConvertido.base)+'^'+inttostr(numConNorm.exponente);

            //lebeles del numero convertido redondeado . .
            numConNorm := Redondeo(numConNorm,BaseNumConv1.Value);
            numSinNorm := convertPFsinN(numConNorm);
            lblFormSinNorm2.Caption:=NumConvSN+Devuelve_Signo(NumConvertido.signo)+numSinNorm.entero+'.'+numSinNorm.decimal;
            lblFormCNorm3.Caption:=NumConvCN+Devuelve_Signo(NumConvertido.signo)+numConNorm.entero+'.'+numConNorm.decimal+'*'+IntToStr(NumConvertido.base)+'^'+inttostr(numConNorm.exponente);
            end
          else begin ShowMessage('PERDON: el número es demasiado grande para convertir, Presione "Aceptar" para cerrar el programa'); Close; end;

    end
  else
    begin
        ShowMessage('El numero ingresado no es valido. Quizás no sea la base correcta para el numero. El programa se cerrara');
        Close;
    end;
end;
end.

