unit unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Oracle, DB, OracleData, ComCtrls,StrUtils, ExtCtrls,DateUtils,
  CheckLst, Grids, Mask;
   const //razmas=60;
       ShortDateFormat='dd.mm.yyyy';   nsg=7; //кол-во полей для генератора
type
  TForm1 = class(TForm)
    ProgressBar1: TProgressBar;
    Button1: TButton;
    StaticText1: TStaticText;
    Label5: TLabel;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Label4: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    dcntr: TMaskEdit;
    ent: TMaskEdit;
    prod: TMaskEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label6: TLabel;
     procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);






  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  Form1: TForm1;
 

implementation
uses unit2;
{$R *.dfm}



 procedure TForm1.FormCreate(Sender: TObject);

 var
  i_np, i_HS,i,j : Integer;
  prm, name, psw, HString : string;
begin
     prm := ParamStr(1);
  i_np := Pos('/', prm);
  i_HS := Pos('@', prm);
   // есть имя/пароль из ком. строки ? (name/psw@HString)
  if Length(prm) <> 0 then begin
    if (i_np = 0) or (i_HS = 0) then begin
     Application.MessageBox('Неверно переданы параметры подключения к БД.' ,
                            'Ошибка', MB_OK + MB_ICONERROR);
     Halt;
    end;
    name :=    LeftStr(prm, i_np - 1);
    psw  :=    MidStr(prm,  i_np + 1, i_HS - i_np - 1);
    HString := RightStr(prm, Length(prm) - i_HS );
    DataModule2.OracleSession1.LogonDatabase := HString;
    DataModule2.OracleSession1.LogonPassword  := psw;
    DataModule2.OracleSession1.LogonUsername:= name;
    DataModule2.OracleSession1.Connected := true;

    if not DataModule2.OracleSession1.Connected then Halt;
    end
   else begin
         DataModule2.OracleLogon1.Execute;
         if not DataModule2.OracleSession1.Connected  then Halt;
   end;



 DateTimePicker1.Date:= EncodeDate(2016, 1, 1);
 DateTimePicker2.Date:= now; // EndOfAMonth(year, month);
 dcntr.Text:='';
 ent.text:='';
 prod.Text:='';



end;

procedure TForm1.Button1Click(Sender: TObject);

begin

  DataModule2.raschet;
  ProgressBar1.Max;
 { if pr_zap=0
   then  ShowMessage('Розрахунок закінчений')
   else  showmessage('Немає даних за запитом.');
        end
    else ShowMessage('Перевірте порядок сортування');
  }
   ProgressBar1.Min;
end;








end.
