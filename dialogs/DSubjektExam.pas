unit DSubjektExam;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes,
  NotiaDBComboBox, NotiaComboBox, Db, Ora, udmODAC, DBAccess, MemDS;

type
  TdlgSubjektExamParams = class(TFuncParams)
    fpSubjekt: integer;
    fpOdbornostID: integer;
    fpOdbornostTOD: string;
    fpPokus: integer;
    fpPredmet: string;
    fpCas: string;
  public
    procedure CreateInitChild;override;
  end;

type
  TdlgSubjektExam = class(TacDialogOkStorno)
    Panel1: TPanel;
    btSubjekt: TButton;
    cbSubjekty: TNotiaComboBox;
    cbOdbornosti: TNotiaComboBox;
    cbPredmety: TNotiaComboBox;
    gbShrnuti: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lbMD: TLabel;
    lbPk: TLabel;
    lbJZ: TLabel;
    lbLDP: TLabel;
    lbMaxDatum: TLabel;
    lbLastDatumP: TLabel;
    lbPokus: TLabel;
    lbJazyk: TLabel;
    qrPredmety: TOraQuery;
    qrPredmetyTOD_ID: TWideStringField;
    qrPredmetySUB_ID: TIntegerField;
    qrPredmetyKOD: TWideStringField;
    qrPredmetyZAPSAL: TWideStringField;
    qrPredmetyZAPSANO: TDateTimeField;
    qrPredmetyEXAM_KOD: TWideStringField;
    qrPredmetyLANG: TSmallintField;
    qrPredmetyEXAM_CAS: TSmallintField;
    qrPredmetyNAZEV: TWideStringField;
    qrPredmetySUBJECT_SECTION: TSmallintField;
    qrPredmetyUZNAL: TWideStringField;
    qrPredmetyUZNANO: TDateTimeField;
    qrPredmetyUZNANO_DUVOD: TWideStringField;
    qrPredmetyDATUM_01: TDateTimeField;
    qrPredmetyPOPL_01: TFloatField;
    qrPredmetyUSP_01: TFloatField;
    qrPredmetyAKCE_ID_01: TIntegerField;
    qrPredmetyDATUM_02: TDateTimeField;
    qrPredmetyPOPL_02: TFloatField;
    qrPredmetyUSP_02: TFloatField;
    qrPredmetyAKCE_ID_02: TIntegerField;
    qrPredmetyDATUM_03: TDateTimeField;
    qrPredmetyPOPL_03: TFloatField;
    qrPredmetyUSP_03: TFloatField;
    qrPredmetyAKCE_ID_03: TIntegerField;
    qrPredmetyDATUM_04: TDateTimeField;
    qrPredmetyPOPL_04: TFloatField;
    qrPredmetyUSP_04: TFloatField;
    qrPredmetyAKCE_ID_04: TIntegerField;
    qrPredmetyDATUM_05: TDateTimeField;
    qrPredmetyPOPL_05: TFloatField;
    qrPredmetyUSP_05: TFloatField;
    qrPredmetyAKCE_ID_05: TIntegerField;
    qrPredmetyDATUM_06: TDateTimeField;
    qrPredmetyPOPL_06: TFloatField;
    qrPredmetyUSP_06: TFloatField;
    qrPredmetyAKCE_ID_06: TIntegerField;
    qrPredmetyDATUM_07: TDateTimeField;
    qrPredmetyPOPL_07: TFloatField;
    qrPredmetyUSP_07: TFloatField;
    qrPredmetyAKCE_ID_07: TIntegerField;
    qrPredmetyDATUM_08: TDateTimeField;
    qrPredmetyPOPL_08: TFloatField;
    qrPredmetyUSP_08: TFloatField;
    qrPredmetyAKCE_ID_08: TIntegerField;
    qrPredmetyDATUM_09: TDateTimeField;
    qrPredmetyPOPL_09: TFloatField;
    qrPredmetyUSP_09: TFloatField;
    qrPredmetyAKCE_ID_09: TIntegerField;
    qrPredmetyDATUM_10: TDateTimeField;
    qrPredmetyPOPL_10: TFloatField;
    qrPredmetyUSP_10: TFloatField;
    qrPredmetyAKCE_ID_10: TIntegerField;
    qrPredmetyHOTOVO: TSmallintField;
    qrPredmetySUBJECT_SECTION_01: TSmallintField;
    qrPredmetySUBJECT_SECTION_02: TSmallintField;
    qrPredmetySUBJECT_SECTION_03: TSmallintField;
    qrPredmetySUBJECT_SECTION_04: TSmallintField;
    qrPredmetySUBJECT_SECTION_05: TSmallintField;
    qrPredmetySUBJECT_SECTION_06: TSmallintField;
    qrPredmetySUBJECT_SECTION_07: TSmallintField;
    qrPredmetySUBJECT_SECTION_08: TSmallintField;
    qrPredmetySUBJECT_SECTION_09: TSmallintField;
    qrPredmetySUBJECT_SECTION_10: TSmallintField;
    qrPredmetyODBORNOST_ID: TIntegerField;
    qrPredmetyODLOZENO: TDateTimeField;
    qrPredmetyREKLAMACE: TSmallintField;
    qrPredmetyODLOZENO_DUVOD: TWideStringField;
    dsPredmety: TOraDataSource;
    lbLDO: TLabel;
    lbLastDatumO: TLabel;
    lbTZ: TLabel;
    lbTrvZkousky: TLabel;
    procedure btSubjektClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbSubjektyChange(Sender: TObject);
    procedure cbOdbornostiChange(Sender: TObject);
    procedure cbPredmetyChange(Sender: TObject);
    procedure qrPredmetyBeforeOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
     FPokus:Integer;
     FPredmet:String;
     FSubjekt:Integer;
     FOdbornostID:Integer;
     FOdbornostTOD:String;
     procedure InitSubjektyCombo;
     procedure InitOdbornostiCombo;
     procedure InitPredmetyCombo;
     procedure InitPrehled;
     procedure btOkValidate;
  public
  end;

var
  dlgSubjektExam: TdlgSubjektExam;

function dlgSubjektExamExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}
uses
  uUCLConsts, Tools, Utils, SysParam,uStoredProcs, uDBUtils, NConsts, uObjUtils,
    FSubjekty;

function dlgSubjektExamExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektExam, dlgSubjektExam, true); {1}
  try
    with dlgSubjektExam do {2}
    begin
      Params := _Params;
      if Assigned(Params) then
        begin
          if Params is TdlgSubjektExamParams then
            With TdlgSubjektExamParams(Params) do
            begin
              FPokus:=fpPokus;
              FPredmet:=fpPredmet;
              FSubjekt:=fpSubjekt;
              FOdbornostID:=fpOdbornostID;
              FOdbornostTOD:=fpOdbornostTOD;
            end;
        end;
      Result := (ShowModal = mrOK) ;
      if Assigned(Params) then
        if Params is TdlgSubjektExamParams then
          With TdlgSubjektExamParams(Params) do
            begin
              fpPokus:=FPokus;
              fpPredmet:=FPredmet;
              fpSubjekt:=FSubjekt;
              fpOdbornostID:=FOdbornostID;
              fpOdbornostTOD:=FOdbornostTOD;
              fpCas:=lbTrvZkousky.caption;
            end;
    end; {with}
  finally
    dlgSubjektExam.Free;
    dlgSubjektExam:=nil;
  end;
end;

// ************************************************************************************
procedure TdlgSubjektExam.FormCreate(Sender: TObject);
begin
  inherited;
  FPredmet:='';
  FSubjekt:=-1;
  FOdbornostID:=-1;
end;

// ************************************************************************************
procedure TdlgSubjektExam.FormShow(Sender: TObject);
begin
  inherited;
  InitSubjektyCombo;
  cbSubjekty.ItemIndex:=0;
  InitOdbornostiCombo;
  cbOdbornosti.ItemIndex:=0;
  InitPredmetyCombo;
  cbPredmety.ItemIndex:=0;
  InitPrehled;
end;

// ************************************************************************************
procedure TdlgSubjektExam.btSubjektClick(Sender: TObject);
var
  FormIOParams: TfrmSubjektyParams;
  t:String;
begin
  FormIOParams := TfrmSubjektyParams.Create( FSUBJEKTY_PFO_ID, [], InitSubjektyCombo );
  try
    FormIOParams.fpSearch := FSubjekt>0;
    FormIOParams.fpSearchFor := FSubjekt;
    FormIOParams.fpUseTemporaryQuery:=True;
    FormIOParams.fpTemporaryQuery:='SELECT * FROM SUBJEKTY WHERE ID IN (select SUB_ID from EXAM_PREDMET)';
    FormIOParams.fpReadOnlyTemporaryQuery:=True;
    if frmSubjektyExec(FormIOParams, true) then
    begin
      FSubjekt:=FormIOParams.fpID;
      t:=SelectStr('SELECT nazev_k_zobrazeni FROM SUBJEKTY WHERE ID='+IntToStr(FSubjekt));
      cbSubjekty.itemIndex:=cbSubjekty.Items.indexof(t);
      InitOdbornostiCombo;
      InitPredmetyCombo;
      InitPrehled;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ************************************************************************************
procedure TdlgSubjektExam.cbSubjektyChange(Sender: TObject);
begin
  inherited;
  FSubjekt:=SelectInt('SELECT ID FROM SUBJEKTY '+
                      ' WHERE nazev_k_zobrazeni='+Q(cbSubjekty.text));
  InitOdbornostiCombo;
  InitPredmetyCombo;
  InitPrehled;
end;

// ************************************************************************************
procedure TdlgSubjektExam.cbOdbornostiChange(Sender: TObject);
begin
  FOdbornostID:=SelectInt('SELECT O.ID FROM TYPY_ODBORNOSTI TOD, ODBORNOSTI O '+
                          ' WHERE TOD.ID=O.TOD_ID '+
                          '   AND O.STAV=1 '+
                          '   AND O.UKONCENI_ZKOUSEK is null '+
                          '   AND NVL(O.MAX_DATUM_ZKOUSKY,(SYSDATE+1))>SYSDATE '+
                          '   AND O.SUB_ID= '+IntToStr(FSubjekt)+
                          '   AND TOD.NAZEV||'' (''||TOD.ID||'')''='+Q(cbOdbornosti.text));
  InitPredmetyCombo;
  InitPrehled;
end;

// ************************************************************************************
procedure TdlgSubjektExam.cbPredmetyChange(Sender: TObject);
begin
  FPredmet:=SelectStr('SELECT P.KOD FROM EXAM_PREDMET P, EXAM_TYPY_PREDMETU TP '+
                      ' WHERE P.SUBJECT_SECTION=TP.SUBJECT_SECTION '+
                      '   AND P.USP_10 is null '+
                      '   AND P.ODLOZENO is null '+
                      '   AND P.UZNANO is null '+
                      '   AND P.HOTOVO<=0 '+
                      '   AND P.HOTOVO<>-2 '+
                      '   AND P.ODBORNOST_ID='+IntToStr(FOdbornostID)+
                      '   AND P.SUB_ID='+IntToStr(FSubjekt)+
                      '   AND TP.NAZEV||'' (''||P.KOD||'')''='+Q(cbPredmety.text) );
  InitPrehled;
end;

// ************************************************************************************
procedure TdlgSubjektExam.InitSubjektyCombo;
begin
  InitComboSql(cbSubjekty, 'SELECT nazev_k_zobrazeni FROM SUBJEKTY '+
                           ' WHERE PLATNY=1 AND ARCHIVOVAN IS NULL '+
                           '   AND ID IN (select SUB_ID from EXAM_PREDMET) '+
                           ' ORDER BY nazev_k_zobrazeni ');
  cbSubjekty.items.Insert(0,'');
end;


// ************************************************************************************
procedure TdlgSubjektExam.InitOdbornostiCombo;
begin
  FOdbornostID:=-1;
  FOdbornostTOD:='';
  if (cbSubjekty.ItemIndex=0) or (FSubjekt<=0)then
    cbOdbornosti.Clear
  else
    InitComboSql(cbOdbornosti, 'SELECT TOD.NAZEV||'' (''||TOD.ID||'')'' as NAZEV '+
                               '  FROM TYPY_ODBORNOSTI TOD, ODBORNOSTI O '+
                               ' WHERE TOD.ID=O.TOD_ID '+
                               '   AND O.STAV=1 '+
                               '   AND O.UKONCENI_ZKOUSEK is null '+
                               '   AND NVL(O.MAX_DATUM_ZKOUSKY,(SYSDATE+1))>SYSDATE '+
                               '   AND SUB_ID= '+IntToStr(FSubjekt)+
                               ' ORDER BY TOD.NAZEV');

  cbOdbornosti.items.Insert(0,'');
  cbOdbornosti.itemIndex:=0;
end;

// ************************************************************************************
procedure TdlgSubjektExam.InitPredmetyCombo;
begin
  FPredmet:='';
  if (cbOdbornosti.ItemIndex=0) or (FOdbornostID<=0)then
    cbPredmety.Clear
  else
    InitComboSql(cbPredmety, 'SELECT TP.NAZEV||'' (''||P.KOD||'')'' as NAZEV '+
                             '  FROM EXAM_PREDMET P, EXAM_TYPY_PREDMETU TP  '+
                             ' WHERE P.SUBJECT_SECTION=TP.SUBJECT_SECTION '+
                             '   AND P.USP_10 is null '+
                             '   AND P.ODLOZENO is null '+
                             '   AND P.UZNANO is null '+
                             '   AND P.HOTOVO<=0 '+
                             '   AND P.HOTOVO<>-2 '+
                             '   AND P.ODBORNOST_ID='+IntToStr(FOdbornostID)+
                             '   AND P.SUB_ID='+IntToStr(FSubjekt)+
                             ' ORDER BY TP.NAZEV');
  cbPredmety.items.Insert(0,'');
  cbPredmety.ItemIndex:=0;
end;


// ************************************************************************************
procedure TdlgSubjektExam.InitPrehled;
var
  aAkce:Integer;
  aDatum:TDateTime;
  aUsp:Double;
begin
  FPokus:=-1;
  qrPredmety.Close;
  if (cbOdbornosti.ItemIndex=0) or (FOdbornostID<=0) then
    begin
      lbMaxDatum.caption:='';
      lbLastDatumP.caption:='';
      lbLastDatumO.caption:='';
    end
  else
    begin
      aDatum:=Selectdat('SELECT FROM ODBORNOSTI '+
                        ' WHERE ID='+IntToStr(FOdbornostID));
      if aDatum>(date-10000) then
        lbMaxDatum.caption:=FormatDateTime('dd.mm.yyyy',aDatum);
      aDatum:=Selectdat('SELECT max(datum) FROM EXAM_PREDMET_V '+
                        ' WHERE ODBORNOST_ID='+IntToStr(FOdbornostID)+
                        '   AND SUB_ID='+IntToStr(FSubjekt));
      if aDatum>(date-10000) then
        lbLastDatumO.caption:=FormatDateTime('dd.mm.yyyy',aDatum);
      if (cbPredmety.ItemIndex=0) or (FPredmet='') then
        lbLastDatumP.caption:=''
      else
        begin
          aDatum:=Selectdat('SELECT max(datum) FROM EXAM_PREDMET_V '+
                            ' WHERE ODBORNOST_ID='+IntToStr(FOdbornostID)+
                            '   AND SUB_ID='+IntToStr(FSubjekt)+
                            '   AND KOD='+Q(FPredmet));
          if aDatum>(date-10000) then
            lbLastDatumP.caption:=FormatDateTime('dd.mm.yyyy',aDatum);
        end;
    end;
  lbPokus.caption:='';
  lbJazyk.caption:='';
  FOdbornostTOD:='';
  lbTrvZkousky.caption:='';


  qrPredmety.open;
  if hasData(qrPredmety) then // pouze jeden zaznam
  begin
    FOdbornostTOD:=qrPredmetyTOD_ID.asString;
    if qrPredmetyREKLAMACE.asInteger>0 then
     lbPokus.caption:='Aktivní reklamace. Nelze plánovat.'
    else
      begin
        FPokus:=Get_Exam_Pokus(0, FSubjekt, FOdbornostID,
                               qrPredmetyTOD_ID.asString, FPredmet,
                               aAkce,aDatum,aUsp);
        lbPokus.caption:=IntToStr(FPokus);
      end;
    if qrPredmetyLANG.asInteger=0 then
      lbJazyk.caption:='Anglicky'
    else
      lbJazyk.caption:='Èesky';
    lbTrvZkousky.caption:=qrPredmetyEXAM_CAS.asString+' min.';
  end;

  qrPredmety.Close;
  btOkValidate;
end;

// ************************************************************************************
procedure TdlgSubjektExam.qrPredmetyBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  qrPredmety.ParamByName('ID').asInteger:=FOdbornostID;
  qrPredmety.ParamByName('KOD').asString:=FPredmet;
end;

// ************************************************************************************
procedure TdlgSubjektExam.btOKClick(Sender: TObject);
begin
  inherited;
  modalresult:=mrNone;
  Exam_Zkouska_kontrola(1,FSubjekt,
                          FOdbornostID,
                          FOdbornostTOD,
                          FPredmet,
                          '',1,1);
  modalresult:=mrOk;
end;

// ************************************************************************************
procedure TdlgSubjektExam.btOkValidate;
begin
  modalresult:=mrNone;
  btOk.enabled:=(FOdbornostID>0) and (FSubjekt>0) and (FPokus>0) and (FPredmet<>'');
end;

{ TdlgZkouskaPlanSeznamParams }
// ************************************************************************************
procedure TdlgSubjektExamParams.CreateInitChild;
begin
  inherited;
  fpSubjekt:=-1;
  fpOdbornostID:=-1;
  fpOdbornostTOD:='';
  fpPokus:=-1;
  fpPredmet:='';
  fpCas:='0';
end;

end.


