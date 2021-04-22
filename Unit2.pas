unit Unit2;

interface

uses
  SysUtils, Classes, Oracle, DB, OracleData,Windows,Dialogs ,
  Messages,  Variants,  Controls, Math,  Forms,
  StdCtrls,  ComCtrls ,ComObj;
 const razmas=60;
       ShortDateFormat='dd.mm.yyyy'; nsg=7; //кол-во полей для генератора
       kol_p=10; //кол-во суммируемых  полей
type
  TDataModule2 = class(TDataModule)
    OracleLogon1: TOracleLogon;
    OracleSession1: TOracleSession;
    ODS: TOracleDataSet;
    ODs2: TOracleDataSet;
    ODSDCLR_D: TStringField;
    ODSYEAR: TStringField;
    ODSDCLR: TStringField;
    ODSDCLDATE: TDateTimeField;
    ODSSUPPLIER: TIntegerField;
    ODSENTNAME: TStringField;
    ODSCNTR: TStringField;
    ODSCNTRZ: TIntegerField;
    ODSCNTRDATE: TDateTimeField;
    ODSCNTR1: TStringField;
    ODSSELDATE: TDateTimeField;
    ODSSPCFREAL: TIntegerField;
    ODSPROD: TIntegerField;
    ODSPRODNAME: TStringField;
    ODSCUR: TStringField;
    ODSQTY: TFloatField;
    ODSNAME_SHIP: TStringField;
    ODSSUPLREG: TStringField;
    ODSSUM: TFloatField;


  private


  public
   procedure raschet;




    { Public declarations }
     end;



var
  DataModule2: TDataModule2;
   XLApp,Sheet,Colum,Row:Variant;
  index,i,j: integer;
   sum_sum,sum_qty:Real;


implementation
 uses unit1;

{$R *.dfm}



  procedure TDataModule2.raschet;

   var j,i :integer;
       ss,ss_dept,ss_docno,ss_docdate, cntr_old,suplreg_old,prod_old,ship_old:string;
      sum_sum, sum_qty:real;

    begin

       ss:='';
       ods.Close;
     if  Length(Trim(Form1.ent.Text))=0
         then  ODs.SetVariable('ent',0)
         else  begin  ODs.SetVariable('ent',StrToInt(Trim(Form1.ent.text)));
                      ss:='за контрагентом '+Trim(Form1.ent.text);
               end;


      if  Length(Trim(Form1.prod.Text))=0
         then  ODs.SetVariable('prod',0)
         else begin   ODs.SetVariable('prod',StrToInt(Trim(Form1.prod.text)));
                      ss:=ss+' за номенклатурою '+Trim(Form1.prod.text);
              end;

      if  Length(Trim(Form1.dcntr.Text))=0
         then  ODs.SetVariable('cntr','*')
         else begin ODs.SetVariable('cntr',Trim(Form1.dcntr.text));
                ss:=ss+' за контрактом '+Trim(Form1.dcntr.text);
              end;

     ODs.SetVariable('d1',datetostr(Form1.DateTimePicker1.Date));
     ODS.SetVariable('d2',datetostr(Form1.DateTimePicker2.Date));

  ODS.Open;
  ODS.First;



  if ODS.RecordCount=0

  then begin
    ODS.Close;
    showmessage('Данні відсутні.');
  end;
         form1.ProgressBar1.Max := ODS.RecordCount;
         Form1.StaticText2.Caption:='0';
         Form1.StaticText2.Repaint;
         Form1.StaticText3.Caption:=Inttostr(ODS.RecordCount);
         Form1.StaticText3.Repaint;

       XLApp:=CreateOleObject('Excel.Application');
       XlApp.Workbooks.Add(ExtractFilePath(ParamStr(0))+'ved_gtd_ship.xls');


       Colum:=XLApp.Workbooks[1].WorkSheets[1].Columns;
       Row:=XLApp.Workbooks[1].WorkSheets[1].Rows;
       Sheet:=XLApp.Workbooks[1].WorkSheets[1];


    // XLApp.Visible:=true;


       Sheet.Cells[2,5]:='за період з '+datetostr(Form1.DateTimePicker1.Date)+' по '+datetostr(Form1.DateTimePicker2.Date);

       Sheet.Cells[3,5]:=ss;

        index:=5;

          ODS.First;
          cntr_old:=DataModule2.ODSCNTR.Value;    suplreg_old:=DataModule2.ODSsuplreg.asstring ;   prod_old:=DataModule2.ODSprod.asstring ;
           ship_old:=datamodule2.ODSNAME_SHIP.Value;

          sum_sum:=0; sum_qty:=0;
          for i:=1 to ODS.RecordCount do
            begin
             Form1.StaticText2.Caption:=inttostr(i);
             Form1.StaticText2.Repaint;
             Form1.ProgressBar1.StepIt;

             Sheet.Cells[index,1]:=670353;
             Sheet.Cells[index,2]:=DataModule2.ODSSUPPLIER.Value;
             Sheet.Cells[index,3]:=DataModule2.ODSENTNAME.Value;
             Sheet.Cells[index,4]:=DataModule2.ODSPROD.Value;
             Sheet.Cells[index,5]:=DataModule2.ODSPRODNAME.Value;
             Sheet.Cells[index,6]:=DataModule2.ODSCNTR.Value;
             Sheet.Cells[index,7]:=DataModule2.ODSCNTRDATE.Value;
             Sheet.Cells[index,8]:=DataModule2.ODSCNTR1.Value;
             Sheet.Cells[index,9]:=DataModule2.ODSSELDATE.Value;
             Sheet.Cells[index,10]:=DataModule2.ODSNAME_SHIP.Value;
             if  DataModule2.ODSsuplreg.Value<>'*' then
             Sheet.Cells[index,11]:=DataModule2.ODSsuplreg.asstring;


             Sheet.Cells[index,14]:=DataModule2.ODSYEAR.Value+'/'+datamodule2.ODSDCLR.Value;
             Sheet.Cells[index,15]:=DataModule2.ODSDCLDATE.Value;
             Sheet.Cells[index,16]:=DataModule2.ODSqty.Value;
             Sheet.Cells[index,17]:=DataModule2.ODSSUM.Value;

             sum_sum:=sum_sum+DataModule2.ODSSUM.Value;
             sum_qty:=sum_qty+DataModule2.ODSqty.Value;


             if  DataModule2.ODSsuplreg.Value<>'*'
               then begin
             ODs2.Close;
             ODs2.SQL.Clear;
             ODs2.SQL.Add('select  distinct nvl(docnop,to_char(i.docno)) docno,  i.docdate,d.waredept');
             ODs2.SQL.Add(' from suplin i,supldoc d where i.suplreg in ('+trim(DataModule2.ODSsuplreg.asstring)+')');
             ODs2.SQL.Add(' and  d.suplreg(+)=i.suplreg');
             ODs2.Open;

             if ODs2.RecordCount=1
                then begin
                     Sheet.Cells[index,1]:=ods2.Fields[2].Value;
                     Sheet.Cells[index,12]:=ods2.Fields[0].Value;
                     Sheet.Cells[index,13]:=ods2.Fields[1].Value;
                end
               else  begin
                   ODs2.First;
                   ss_dept:=''; ss_docno:=''; ss_docdate:='';
                   for j:=1 to DataModule2.ODs2.RecordCount do
                      begin
                        if Pos(ods2.Fields[2].asstring,ss_dept)=0
                           then ss_dept:=ss_dept+ods2.Fields[2].asstring+' ';

                         if Pos(ods2.Fields[0].asstring,ss_docno)=0
                           then ss_docno:=ss_docno+ods2.Fields[0].Value+' ';

                         if Pos(DateToStr(ods2.Fields[1].Value),ss_docdate)=0
                           then ss_docdate:=ss_docdate+DateToStr(ods2.Fields[1].Value)+' ';

                         DataModule2.ODs2.Next;
                      end;

                     Sheet.Cells[index,1]:=ss_dept;
                     Sheet.Cells[index,12]:=ss_docno;
                     Sheet.Cells[index,13]:=ss_docdate;


               end;

                 ODs2.Close;
                 end;


                ods.Next;
                  inc(index);
                 if ( cntr_old<>DataModule2.ODSCNTR.Value) or (ship_old<>DataModule2.ODSNAME_SHIP.Value)
                    or (suplreg_old<>DataModule2.ODSsuplreg.asstring) or  (prod_old<>DataModule2.ODSprod.asstring )
                    then begin
                        Sheet.rows[index].font.bold := true;
                        Sheet.Cells[index,16]:=sum_qty;
                       Sheet.Cells[index,17]:=sum_sum;
                        if suplreg_old<>'*'
                           then begin
                              ODs2.Close;
                              ODs2.SQL.Clear;
                              ODs2.SQL.Add('select nvl(sum(qty),0), nvl(sum(sum$),0) ');
                              ODs2.SQL.Add(' from suplsum  where suplreg in ('+suplreg_old+')');
                              ODs2.SQL.Add(' and  opr#=1 and prod#='+prod_old);
                              ODs2.Open;

                              if  ods2.RecordCount<>0
                                 then begin

                                     Sheet.Cells[index,18]:=ods2.Fields[0].Value;
                                     Sheet.Cells[index,19]:=ods2.Fields[1].Value;

                                      Sheet.Cells[index,20]:=roundto(sum_qty-ods2.Fields[0].Value,-2);
                                      Sheet.Cells[index,21]:=roundto(sum_sum-ods2.Fields[1].Value,-2);

                                 end;
                                 ODs2.Close;

                           end;

                        prod_old:=DataModule2.ODSprod.asstring ;
                        cntr_old:=DataModule2.ODSCNTR.Value;
                        ship_old:=DataModule2.ODSNAME_SHIP.Value ;


                        suplreg_old:=DataModule2.ODSsuplreg.asstring ;
                         sum_sum:=0; sum_qty:=0;
                           inc(index);
                        end;

                Application.ProcessMessages;

              end ;//


                     Sheet.rows[index].font.bold := true;
                        Sheet.Cells[index,16]:=sum_qty;
                       Sheet.Cells[index,17]:=sum_sum;

                        if suplreg_old<>'*'
                           then begin
                              ODs2.Close;
                              ODs2.SQL.Clear;
                              ODs2.SQL.Add('select nvl(sum(qty),0), nvl(sum(sum$),0)');
                              ODs2.SQL.Add(' from suplsum  where suplreg in ('+suplreg_old+')');
                              ODs2.SQL.Add(' and  opr#=1 and prod#='+prod_old);
                              ODs2.Open;

                              if  ods2.RecordCount<>0
                                 then begin

                                     Sheet.Cells[index,18]:=ods2.Fields[0].Value;
                                     Sheet.Cells[index,19]:=ods2.Fields[1].Value;

                                      Sheet.Cells[index,20]:=roundto(sum_qty-ods2.Fields[0].Value,-2);
                                      Sheet.Cells[index,21]:=roundto(sum_sum-ods2.Fields[1].Value,-2);

                                 end;
                                 ODs2.Close;

                          end;


       ShowMessage('Розрахунок закінчено') ;

       XLApp.Visible:=true;


   end;



end.
