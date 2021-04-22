object DataModule2: TDataModule2
  OldCreateOrder = False
  Left = 475
  Top = 297
  Height = 395
  Width = 817
  object OracleLogon1: TOracleLogon
    Session = OracleSession1
    Options = [ldAuto, ldDatabase, ldDatabaseList, ldLogonHistory, ldConnectAs]
    HistoryIniFile = 'c:\history.ini'
    Left = 696
    Top = 24
  end
  object OracleSession1: TOracleSession
    Left = 696
    Top = 90
  end
  object ODS: TOracleDataSet
    SQL.Strings = (
      
        'select g.dclr_d,g.year,g.dclr#,g.dcldate,g.supplier,e.entname,g.' +
        'cntr#,c.cntrz,c.cntrdate,c.cntr1,c.seldate,g.spcfreal,g.prod#,p.' +
        'prodname,'
      
        'g.cur$,g.qty,decode(s.licence,null,g.entnamed,s.licence) name_sh' +
        'ip, nvl(g.prodname,'#39'*'#39') suplreg ,g.sum$'
      ''
      'from suplgtd g,spcfz s,prod p, ent e,contractz c'
      
        'where nvl(g.dclreg,0)=0 and  g.cntr#=to_char(s.cntrz(+)) and g.s' +
        'pcfreal=s.spcfreal(+) and g.prod#=s.prod#(+)'
      'and p.prod#(+)=g.prod# and e.ent#(+)=nvl(g.supplier,0) '
      
        'and to_char(c.cntrz(+))=g.cntr# and  c.dopcntr(+)=0 --and g.dclr' +
        'eg is null '
      'and (g.prod#=:prod or :prod=0)'
      'and (g.cntr#=:cntr or  :cntr='#39'*'#39')'
      'and (g.supplier=:ent or :ent=0)'
      
        'and g.dcldate between to_date(:d1,'#39'dd.mm.yyyy'#39') and to_date(:d2,' +
        #39'dd.mm.yyyy'#39')'
      
        'order by    g.cntr#, decode(s.licence,null,g.entnamed,s.licence)' +
        ', g.year,g.dcldate')
    Variables.Data = {
      0300000005000000050000003A434E5452050000000000000000000000040000
      003A454E54030000000000000000000000050000003A50524F44030000000000
      000000000000030000003A4431050000000000000000000000030000003A4432
      050000000000000000000000}
    QBEDefinition.QBEFieldDefs = {
      04000000130000000600000044434C525F440100000000000400000059454152
      0100000000000500000044434C52230100000000000700000044434C44415445
      01000000000007000000454E544E414D4501000000000005000000434E545223
      01000000000005000000434E54525A01000000000008000000434E5452444154
      4501000000000005000000434E5452310100000000000700000053454C444154
      4501000000000008000000535043465245414C0100000000000500000050524F
      44230100000000000800000050524F444E414D45010000000000040000004355
      522401000000000003000000515459010000000000090000004E414D455F5348
      49500100000000000400000053554D24010000000000070000005355504C5245
      4701000000000008000000535550504C494552010000000000}
    Cursor = crSQLWait
    Session = OracleSession1
    Left = 32
    Top = 32
    object ODSDCLR_D: TStringField
      FieldName = 'DCLR_D'
      Size = 9
    end
    object ODSYEAR: TStringField
      FieldName = 'YEAR'
      Size = 4
    end
    object ODSDCLR: TStringField
      FieldName = 'DCLR#'
      Size = 6
    end
    object ODSDCLDATE: TDateTimeField
      FieldName = 'DCLDATE'
    end
    object ODSSUPPLIER: TIntegerField
      FieldName = 'SUPPLIER'
    end
    object ODSENTNAME: TStringField
      FieldName = 'ENTNAME'
      Size = 40
    end
    object ODSCNTR: TStringField
      FieldName = 'CNTR#'
      Size = 15
    end
    object ODSCNTRZ: TIntegerField
      FieldName = 'CNTRZ'
    end
    object ODSCNTRDATE: TDateTimeField
      FieldName = 'CNTRDATE'
    end
    object ODSCNTR1: TStringField
      FieldName = 'CNTR1'
      Size = 15
    end
    object ODSSELDATE: TDateTimeField
      FieldName = 'SELDATE'
    end
    object ODSSPCFREAL: TIntegerField
      FieldName = 'SPCFREAL'
    end
    object ODSPROD: TIntegerField
      FieldName = 'PROD#'
    end
    object ODSPRODNAME: TStringField
      FieldName = 'PRODNAME'
      Size = 40
    end
    object ODSCUR: TStringField
      FieldName = 'CUR$'
      Size = 3
    end
    object ODSQTY: TFloatField
      FieldName = 'QTY'
    end
    object ODSNAME_SHIP: TStringField
      FieldName = 'NAME_SHIP'
      Size = 100
    end
    object ODSSUPLREG: TStringField
      FieldName = 'SUPLREG'
      Size = 100
    end
    object ODSSUM: TFloatField
      FieldName = 'SUM$'
    end
  end
  object ODs2: TOracleDataSet
    SQL.Strings = (
      
        'select nvl(docnop,to_char(i.docno)) docno,  i.docdate, sum(s.sum' +
        '$),sum(s.qty),i.suplreg'
      
        ' from suplin i, suplsum s where  (i.cntr#=:cntr or i.cntr#=:cntr' +
        '1)'
      'and i.suplreg=s.suplreg and s.opr#=1 '
      'group by nvl(docnop,to_char(i.docno)) ,  i.docdate ,i.suplreg')
    Session = OracleSession1
    Left = 96
    Top = 144
  end
end
