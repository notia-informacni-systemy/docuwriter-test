unit DZkouskaPlanSeznam;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, DataComboBox,
  Mask, rxToolEdit, Buttons, NotiaSpeedButton, EditEx, NGrids, NDBGrids,
  MSGrid, Db, Ora, udmODAC, ComCtrls, ToolWin, MemDS, DBAccess;

const
  DZKOUSKA_PLAN_PFO_ID = $0001;

Const
  CasovyPlanCelMinS:integer=60; // pocet minut na jedno pole

type
  TdlgZkouskaPlanSeznamParams = class(TFuncParams)
    fpTechnicka: Boolean;
    fpSubjekt: integer;
    fpTOD_ID: string;
    fpOdbornostID: integer; // xxxx
    fpPokus: integer; // xxxx
    fpPREDMET_ZK: string;
    fpMistnost: integer;
    fpDenList:boolean;
    fpTyp:Integer;
    fpSelSubjekt:Boolean;
    fpIDAkce:Integer;
    fpIDPozadavku:Integer;
    fpCas:Integer; // v minutach
    fpPracovnidobaStart:Boolean;
  public
    procedure CreateInitChild;override;
  end;
  
type
  TdlgZkouskaPlanSeznam = class(TacDialogOkStorno)
    pnCas: TPanel;
    pnForm: TPanel;
    pnTop: TPanel;
    Label1: TLabel;
    sbAktualizovat: TNotiaSpeedButton;
    btMistnost: TButton;
    eddatum: TDateEdit;
    cbMistnost: TDataComboBox;
    cbDen: TDataComboBox;
    grMaster: TMSDBGrid;
    dsMaster: TOraDataSource;
    qrMaster: TOraQuery;
    qrMasterDATUM: TDateTimeField;
    qrMasterOD: TWideStringField;
    qrMasterDO: TWideStringField;
    qrMasterSUBJEKT: TWideStringField;
    sbAdd: TSpeedButton;
    sbDel: TSpeedButton;
    sbModify: TSpeedButton;
    qrMasterAK_ID: TFloatField;
    qrMasterSUBJECT_SECTION: TFloatField;
    qrMasterPOKUS: TFloatField;
    qrMasterODBORNOST_ID: TFloatField;
    qrMasterTOD_ID: TWideStringField;
    qrMasterZDROJ: TWideStringField;
    qrMasterSUB_ID: TFloatField;
    qrMasterKOD: TWideStringField;
    qrMasterZDROJ_ID: TIntegerField;
    sbAddPred: TSpeedButton;
    sbAddPo: TSpeedButton;
    edMin: TEditEx;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btMistnostClick(Sender: TObject);
    procedure cbDenChange(Sender: TObject);
    procedure cbMistnostChange(Sender: TObject);
    procedure sbAktualizovatClick(Sender: TObject);
    procedure sbAddClick(Sender: TObject);
    procedure sbDelClick(Sender: TObject);
    procedure grMasterDblClick(Sender: TObject);
    procedure qrMasterAfterOpen(DataSet: TDataSet);
    procedure qrMasterBeforeOpen(DataSet: TDataSet);
    procedure sbModifyClick(Sender: TObject);
    procedure eddatumExit(Sender: TObject);
    procedure sbAddPredClick(Sender: TObject);
    procedure sbAddPoClick(Sender: TObject);
  private
    { Private declarations }
    FTechnicka:Boolean;
    FTyp: integer;
    FSubjekt: integer;
    FTOD_ID: string;
    FPredmet_ZK: string;
    FDenList:boolean;
    FMistnost: Integer;
    FMinDayHour:Word;
    FMaxDayHour:Word;
    FLastMouseRow: Integer;
    FLastMouseCol: Integer;
    FSelectedCels:TRect;
    FSelectedDatum:TDateTime;
    FCas:integer; // v minutach
    IsShowing:Boolean;
    FPracovnidobaStart:Boolean;
    FOdbornostID:integer; // xxx
    FPokus: integer; // xxxx
    procedure UpdateControlStates;
    procedure OnOK(var Accept: boolean); override;
    procedure InitComboMistnosti;
    procedure InitComboDny;
    procedure MasterRefresh;
  public
    FSelSubjekt:boolean;
  end;

var
  dlgZkouskaPlanSeznam: TdlgZkouskaPlanSeznam;

function dlgZkouskaPlanSeznamExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}
uses
  uUCLConsts, Tools, Caches, Utils, SysParam,uStoredProcs, uDBUtils, NConsts,
  FMistnosti, DCasovyPlanInfo, FAkce, FPozadavky, uObjUtils, RZkouskaTerminy,
  DSubjektExam, GridUtl;

function dlgZkouskaPlanSeznamExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgZkouskaPlanSeznam, dlgZkouskaPlanSeznam, true); {1}
  try
    with dlgZkouskaPlanSeznam do {2}
    begin
      Params := _Params;
      if Assigned(Params) then
        begin
          if Params is TdlgZkouskaPlanSeznamParams then
            With TdlgZkouskaPlanSeznamParams(Params) do
            begin
              FTechnicka:=fpTechnicka;
              FTyp:=fpTyp;
              FMistnost:=fpMistnost;
              FCas:=fpCas;
              FPracovnidobaStart:=fpPracovnidobaStart;
              if Abs(FTyp)=1 then
                begin
                  FSubjekt:=fpSubjekt;
                  FTOD_ID:=fpTOD_ID;
                  FPredmet_ZK:=fpPredmet_ZK;
                  FDenList:=fpDenList;
                end;
            end;
        end;
      cbDen.Visible:=FDenList;
      eddatum.Visible:=not cbDen.Visible;
      eddatum.enabled:=eddatum.visible;
      cbDen.enabled:=cbDen.visible;

      if FDenList and (SelectInt('SELECT COUNT(*) FROM EXAM_DNY')=0) then
        begin
          ErrorMsg('Není definován "povolený" seznam dnù');
          Abort;
        end;

      Result := (ShowModal = mrOK);
(*
      if Assigned(Params) then
        if Params is TdlgZkouskaPlanSeznamParams then
          With TdlgZkouskaPlanSeznamParams(Params) do
            fpSelSubjekt:=FDataSelSubjekt;
*)
    end; {with}
  finally
    dlgZkouskaPlanSeznam.Free;
    dlgZkouskaPlanSeznam:=nil;
  end;
end;


{ TdlgZkouskaPlanParams }
// ***************************************************************************
procedure TdlgZkouskaPlanSeznamParams.CreateInitChild;
begin
  inherited;
  fpTechnicka:=False;
  fpSelSubjekt:=False;
  fpDenList:=false;
  fpMistnost:=-1;
  fpSubjekt:=-1;
  fpTOD_ID:='';
  fpPredmet_ZK:='';
  fpTyp:=0;
  fpIDAkce:=-1;
  fpIDPozadavku:=-1;
  fpCas:=1;
  fpPracovnidobaStart:=False;
  fpOdbornostID:=-1;
  fpPokus:=-1;
end;

{ TdlgZkouskaPlanSeznam }
// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.FormCreate(Sender: TObject);
begin
  inherited;
  FTechnicka:=False;
  FTyp:=0;
  FSelSubjekt:=False;
  FLastMouseCol:=-1;
  FLastMouseRow:=-1;
  FSubjekt:=-1;
  FTOD_ID:='';
  FPredmet_ZK:='';
  FDenList:=false;
  FSelectedDatum:=Round(now*24)/24;
  FCas:=0;
  FPracovnidobaStart:=False;
  FOdbornostID:=-1;
  FPokus:=-1;

  eddatum.Top:=cbDen.Top;
  IsShowing:=False;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  IsShowing:=False;
  qrMaster.Close;
  inherited;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if assigned(Params) and (TdlgZkouskaPlanSeznamParams(Params).fpIDAkce>0) then
    modalresult:=mrOk;
  inherited;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.FormDestroy(Sender: TObject);
begin
//
  inherited;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.FormHide(Sender: TObject);
begin
  inherited;
  IsShowing:=False;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.FormShow(Sender: TObject);
var
  c:TColumn;
begin
  inherited;
  InitComboMistnosti;
  InitComboDny;
  MasterRefresh;

  UpdateControlStates;

  if cbDen.enabled then
    cbDenChange(nil)
  else
    eddatum.Date:=now;

  btOk.enabled:=False;
  if Abs(FTyp)=1 then
    begin
      btCancel.enabled:=True;
      sbAdd.enabled:=True;
    end;

  c:=grMaster.Columns[GetColumnIndex(grMaster, 'DATUM')];
  if c.Color=clWindow then
    c.Color:=$00E7FFCE;
  c:=grMaster.Columns[GetColumnIndex(grMaster, 'ZDROJ')];
  if c.Color=clWindow then
    c.Color:=$00E7FFCE;
end;


// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.btMistnostClick(Sender: TObject);
var
  FormIOParams: TfrmMistnostiParams;
begin
  FormIOParams := TfrmMistnostiParams.Create(FMISTNOSTI_PFO_ID);
  try
    if frmMistnostiExec(FormIOParams, true) then
    begin
      FMistnost:=FormIOParams.fpID;
      MasterRefresh;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.cbDenChange(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  i:=StrToInt(cbDen.GetDataValue(cbDen.ItemIndex));
  if (i=0) and (cbDen.items.Count>0) then
    begin
      i:=StrToInt(cbDen.GetDataValue(cbDen.items.Count-1));
      cbDen.ItemIndex:=cbDen.items.Count-1;
    end;

  if i=0 then
    begin
      eddatum.clear;
      ErrorMsg('Nelze plánovat ani zobrazit');
      Close;
    end;

  eddatum.date:=SelectDat('SELECT DATUM FROM EXAM_DNY WHERE ID='+IntToStr(i));
  eddatumExit(nil);
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.cbMistnostChange(Sender: TObject);
begin
  FMistnost:=StrToInt(cbMistnost.GetDataValue(cbMistnost.ItemIndex));
  MasterRefresh;
end;


// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.eddatumExit(Sender: TObject);
begin
  cbDen.Color:=clWindow;
  edDatum.Color:=clWindow;

  if Trunc(eddatum.date)<Trunc(now) then
    begin
      cbDen.Color:=$006666DD;
      edDatum.Color:=$006666DD;
    end;

  FSelectedDatum:=edDatum.Date+FMinDayHour/24;
  MasterRefresh;
end;


// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.InitComboDny;
var
  t:String;
begin
  t:=cbDen.text;
  cbDen.Clear;
  cbDen.AddQueryItems('SELECT TO_CHAR(DATUM,''DD.MM.YYYY'') as DAT, ID FROM EXAM_DNY ORDER BY DATUM',database);
  if t='' then
    t:=SelectStr('SELECT TO_CHAR(MIN(DATUM),''DD.MM.YYYY'') as DAT FROM EXAM_DNY WHERE DATUM>SYSDATE');
  if (cbDen.Items.Count>0) and (t<>'') then
    begin
      cbDen.ItemIndex:=cbDen.IndexOfItems(t);
    end
  else
    begin
      cbDen.InsertItemValue(0, '', '0');
      cbDen.ItemIndex := 0;
    end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.InitComboMistnosti;
var
  t:String;
  i:Integer;
begin
  if FMistnost>0 then
    t:=SelectStr('SELECT NAZEV FROM MISTNOSTI WHERE ID='+IntToStr(FMistnost))
  else
    t:=cbMistnost.text;
  cbMistnost.Clear;
  cbMistnost.AddQueryItems('SELECT NAZEV, ID FROM MISTNOSTI WHERE STAV=0 ORDER BY NAZEV',database);
  cbMistnost.InsertItemValue(0, '', '0');
  if t<>'' then
    begin
      cbMistnost.ItemIndex:=cbMistnost.IndexOfItems(t);
    end
  else
    begin
      cbMistnost.ItemIndex := 0;
    end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.sbAktualizovatClick(Sender: TObject);
begin
  inherited;
  InitComboMistnosti;
  InitComboDny;
  MasterRefresh;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.UpdateControlStates;
var
 Par:TdlgZkouskaPlanSeznamParams;
begin
  sbAdd.enabled:=False;
//  btAddPozadavek.Visible:=False;
  pnCas.Visible:=False;
  edMin.asInteger:=0;
  SetControlsReadOnly([btMistnost, cbMistnost],false);
  Case Abs(FTyp) of
    1:Begin
        Self.caption:='Plánování zkoušky';
        SetControlsReadOnly([btMistnost, cbMistnost],FMistnost>0);
        sbAdd.Hint:='Naplán.zkoušku';
        sbAdd.Enabled:=True;
        if FCas>1 then
          begin
            edMin.asInteger:=FCas;
//            edMin.MaxValue:=FCas;
            pnCas.Visible:=True;
          end;
      end;
   else
      begin
        if Ftechnicka then
          Self.caption:='Plánování technické akce'
        else
          Self.caption:='Pøehled obsazenosti';

        sbAdd.Hint:='Pøidat akci';
        sbAdd.Enabled:=True;
      end;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.OnOK(var Accept: boolean);
begin
  inherited;
//
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.MasterRefresh;
begin
  qrMaster.Close;
  qrMaster.Open;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.grMasterDblClick(Sender: TObject);
begin
  inherited;
  if hasdata(qrMaster) and (qrMasterAK_ID.asInteger>0) then
    sbModifyClick(nil)
  else
    sbAddClick(nil);
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.qrMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  sbDel.enabled:=sbAdd.enabled and hasData(qrMaster);
  sbModify.enabled:=sbAdd.enabled and hasData(qrMaster);
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.qrMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  qrMaster.ParamByName('MISTNOST').asInteger:=FMistnost;
  if eddatum.text='  .  .    ' then
    qrMaster.ParamByName('DATUM').asDate:=date
  else
    qrMaster.ParamByName('DATUM').asString:=eddatum.text;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.sbDelClick(Sender: TObject);
var
  t:String;
begin
  if not hasdata(qrMaster) then
    EXIT;
  if Zrusit_Exam_Zkousku(qrMasterSUB_ID.asInteger,
                         qrMasterODBORNOST_ID.asInteger,
                         qrMasterTOD_ID.asString,
                         qrMasterKOD.asString,
                         '') then
    begin
      try
        Exam_Zkouska_kontrola(0,qrMasterSUB_ID.asInteger,
                                qrMasterODBORNOST_ID.asInteger,
                                qrMasterTOD_ID.asString,
                                qrMasterKOD.asString,
                                '', 1,1);
      except
      end;

      t:=qrMasterAK_ID.asString;
      MasterRefresh;
      if t<>'' then
        qrMaster.Locate('AK_ID',t,[]);
    end
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.sbModifyClick(Sender: TObject);
var
  t:String;
begin
  if qrMasterAK_ID.asInteger>0 then
    VyberAkci(qrMasterAK_ID.asString,'SELECT * FROM AKCE '+
                                      ' WHERE ID='+qrMasterAK_ID.asString, False);
  t:=qrMasterKOD.asString;
  MasterRefresh;
  qrMaster.Locate('KOD',t,[]);
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.sbAddClick(Sender: TObject);
var
  FormIOParams1: TdlgSubjektExamParams;
  FormIOParams: TfrmAkceParams;
  aID,i:Integer;
  t:String;
  PlanOk:Boolean;
begin
  PlanOk:=False;
  FormIOParams :=nil;
  FormIOParams1 :=nil;
  if (Abs(FTyp)=1) and ((FSubjekt<=0) or (FTOD_ID='') or (FPredmet_ZK='')) then
  begin
    If Warn('Nemáte vybraný subjekt, odbornost nebo pøedmìt.'+EOL+
            'Pøejete si pokraèovat výbìrem požadovaných dat') then
      begin
        FormIOParams1 := TdlgSubjektExamParams.Create(DZKOUSKA_PLAN_PFO_ID);
        try
          FormIOParams1.fpSubjekt:=FSubjekt;
          FormIOParams1.fpOdbornostID:=FOdbornostID;
          FormIOParams1.fpOdbornostTOD:=FTOD_ID;
          FormIOParams1.fpPokus:=FPokus;
          FormIOParams1.fpPredmet:=FPredmet_ZK;
          if dlgSubjektExamExec(FormIOParams1) then
          begin
            FSubjekt:=FormIOParams1.fpSubjekt;
            FOdbornostID:=FormIOParams1.fpOdbornostID;
            FTOD_ID:=FormIOParams1.fpOdbornostTOD;
            FPokus:=FormIOParams1.fpPokus;
            FPredmet_ZK:=FormIOParams1.fpPredmet;
            edMin.Text:=Copy(FormIOParams1.fpCas,1,Pos(' ',FormIOParams1.fpCas)-1);
            FCas:=edMin.asInteger;
          end;
        finally
          FormIOParams1.Free;
        end;
      end;
    if ((FSubjekt<=0) or (FTOD_ID='') or (FPredmet_ZK='')) then
      EXIT;
  end;

  if hasdata(qrMaster) then
  begin
    FSelectedDatum:=SelectDat('SELECT TO_DATE('''+FormatDateTime('DD.MM.YYYY',qrMasterDATUM.AsDateTime)+'  '+qrMasterOD.asString+''',''DD.MM.YYYY  HH24:MI'') FROM DUAL');
    i:=qrMasterZDROJ_ID.asInteger;
  end
  else
  begin
    ErrorMsg('Nemáte vybrané PC. Nelze plánovat.');
    Exit;
  end;


  FormIOParams := TfrmAkceParams.Create(PF_NOTHING, [ofoaInsert]);
  try
    aID:=0;
    if (grMaster.SelectedField= qrMasterDATUM) or  (grMaster.SelectedField= qrMasterZDROJ) then
    begin
      FSelectedDatum:=SelectDat('select Max(A.AK_DO) from exam_predmet_akce EA, Akce A '+
                                '  Where EA.AKCE=A.ID and EA.Sub_id='+IntToStr(FSubjekt)+
                                '  and TO_CHAR(Only_date(EA.datum),''DD.MM.YYYY'')='+Q(FormatDateTime('DD.MM.YYYY',qrMasterDATUM.AsDateTime)));
      if FSelectedDatum<qrMasterDATUM.AsDateTime then
        FSelectedDatum:=SelectDat('SELECT TO_DATE('''+FormatDateTime('DD.MM.YYYY',qrMasterDATUM.AsDateTime)+'  '+qrMasterOD.asString+''',''DD.MM.YYYY  HH24:MI'') FROM DUAL');
    end;    


    aID:=NovaAkce(FMistnost, FSubjekt, FTOD_ID, FPredmet_ZK,
                  FSelectedDatum, FSelectedDatum+(edMin.asInteger/(24*60)),
                  i);
    if aID=0 then
      begin
        ErrorMsg('Nepodaøilo se založit novou akci.');
        EXIT;
      end;
    FormIOParams.fpSearchFor := aID;
    FormIOParams.fpCasTrvani := edMin.asInteger;
    FormIOParams.fpTyp := Abs(FTyp);
    FormIOParams.fpSearch:=True;
    if frmAkceExec(FormIOParams, True) then
      begin
        sbAdd.enabled:=false;
        if assigned(Params) then
          begin
            aID:=SelectInt('SELECT ID FROM AKCE WHERE STAV=1 and ID='+IntToStr(aID));
            if aID>0 then
             TdlgZkouskaPlanSeznamParams(Params).fpIDAkce:=aID;
          end;
        MasterRefresh;
        if FTyp=1 then  // planovani ze subjekyu
        begin
          btOk.Visible:=True;
          btOk.enabled:=True;
(*
          btCancel.enabled:=False;
          sbAdd.enabled:=False;
          sbDel.enabled:=False;
          if aID>0 then
            Inform('Zkouška je zaevidována a pøipravena k naplánovaní.'+EOL+' Potvrïte "OK"');
*)
          btOKclick(nil);
        end;
        if FTyp=-1 then  //planovani z hlavniho okna
        begin
          btOk.Visible:=True;
          btOk.enabled:=True;
          btCancel.enabled:=True;
          sbAdd.enabled:=True;
          sbDel.enabled:=True;
          if (aID>0) then
        if Planovat_Exam_Zkousku(aID, FSubjekt,   // podobne je to i ve frmSubjekty
                                 FOdbornostID,
                                 FTOD_ID,
                                 FPredmet_ZK,
                                 '') then

          begin
            try
              Exam_Zkouska_kontrola(0,FSubjekt,
                                    FOdbornostID,
                                    FTOD_ID,
                                    FPredmet_ZK,
                                    '', 1,1);
              PlanOk:=True;
              FTOD_ID:='';
            finally
              t:=FPredmet_ZK;
              MasterRefresh;
              qrMaster.Locate('KOD',t,[]);
            end;

    if planOK and Confirm('Vytisknout doklad o naplánované zkoušce?')then
    try
      Application.CreateForm(TrptZkouskaTerminy,rptZkouskaTerminy);
      with rptZkouskaTerminy do
      begin
        qrSubjekt.Close;
        qrSubjekt.ParamByName('ID').AsString:= IntToStr(FSubjekt);
        qrSubjekt.ParamByName('ODBORNOST_ID').AsInteger:=FOdbornostID;
        if true then
          Tisk_Sestavy_Typ_0(Self,'','Termíny zkoušek '+IntToStr(FOdbornostID),QuickRep1,
                             false,false,false,1,0,0);
(*
        else
          Tisk_Sestavy_Typ_0(Self,'','Termíny zkoušek '+IntToStr(FOdbornostID),QuickRep1,
                             false,false,false,-1,0,0);
*)
        qrSubjekt.Close;
      end;
    finally
      rptZkouskaTerminy.Free;
      rptZkouskaTerminy:=nil;
    end;
       end;
          end;
       end
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.sbAddPredClick(Sender: TObject);
var
  FormIOParams1: TdlgSubjektExamParams;
  FormIOParams: TfrmAkceParams;
  aID,i:Integer;
  t:String;
  PlanOk:Boolean;
begin
  PlanOk:=False;
  FormIOParams :=nil;
  FormIOParams1 :=nil;
  if (Abs(FTyp)=1) and ((FSubjekt<=0) or (FTOD_ID='') or (FPredmet_ZK='')) then
  begin
    If Warn('Nemáte vybraný subjekt, odbornost nebo pøedmìt.'+EOL+
            'Pøejete si pokraèovat výbìrem požadovaných dat') then
      begin
        FormIOParams1 := TdlgSubjektExamParams.Create(DZKOUSKA_PLAN_PFO_ID);
        try
          FormIOParams1.fpSubjekt:=FSubjekt;
          FormIOParams1.fpOdbornostID:=FOdbornostID;
          FormIOParams1.fpOdbornostTOD:=FTOD_ID;
          FormIOParams1.fpPokus:=FPokus;
          FormIOParams1.fpPredmet:=FPredmet_ZK;
          if dlgSubjektExamExec(FormIOParams1) then
          begin
            FSubjekt:=FormIOParams1.fpSubjekt;
            FOdbornostID:=FormIOParams1.fpOdbornostID;
            FTOD_ID:=FormIOParams1.fpOdbornostTOD;
            FPokus:=FormIOParams1.fpPokus;
            FPredmet_ZK:=FormIOParams1.fpPredmet;
            edMin.Text:=Copy(FormIOParams1.fpCas,1,Pos(' ',FormIOParams1.fpCas)-1);
            FCas:=edMin.asInteger;
          end;
        finally
          FormIOParams1.Free;
        end;
      end;
    if ((FSubjekt<=0) or (FTOD_ID='') or (FPredmet_ZK='')) then
      EXIT;
  end;

  if hasdata(qrMaster) then
  begin
    FSelectedDatum:=SelectDat('SELECT TO_DATE('''+FormatDateTime('DD.MM.YYYY',qrMasterDATUM.AsDateTime)+'  '+qrMasterOD.asString+''',''DD.MM.YYYY  HH24:MI'') FROM DUAL');
    FSelectedDatum:=FSelectedDatum-(edMin.asInteger/(24*60));
    i:=qrMasterZDROJ_ID.asInteger;
  end
  else
  begin
    ErrorMsg('Nemáte vybrané PC. Nelze plánovat.');
    Exit;
  end;


  FormIOParams := TfrmAkceParams.Create(PF_NOTHING, [ofoaInsert]);
  try
    aID:=0;
    aID:=NovaAkce(FMistnost, FSubjekt, FTOD_ID, FPredmet_ZK,
                  FSelectedDatum, FSelectedDatum+(edMin.asInteger/(24*60)),
                  i);
    if aID=0 then
      begin
        ErrorMsg('Nepodaøilo se založit novou akci.');
        EXIT;
      end;
    FormIOParams.fpSearchFor := aID;
    FormIOParams.fpCasTrvani := edMin.asInteger;
    FormIOParams.fpTyp := Abs(FTyp);
    FormIOParams.fpSearch:=True;
    if frmAkceExec(FormIOParams, True) then
      begin
        sbAdd.enabled:=false;
        if assigned(Params) then
          begin
            aID:=SelectInt('SELECT ID FROM AKCE WHERE STAV=1 and ID='+IntToStr(aID));
            if aID>0 then
             TdlgZkouskaPlanSeznamParams(Params).fpIDAkce:=aID;
          end;
        MasterRefresh;
        if FTyp=1 then  // planovani ze subjekyu
        begin
          btOk.Visible:=True;
          btOk.enabled:=True;
(*
          btCancel.enabled:=False;
          sbAdd.enabled:=False;
          sbDel.enabled:=False;
          if aID>0 then
            Inform('Zkouška je zaevidována a pøipravena k naplánovaní.'+EOL+' Potvrïte "OK"');
*)
          btOKclick(nil);
        end;
        if FTyp=-1 then  //planovani z hlavniho okna
        begin
          btOk.Visible:=True;
          btOk.enabled:=True;
          btCancel.enabled:=True;
          sbAdd.enabled:=True;
          sbDel.enabled:=True;
          if (aID>0) then
        if Planovat_Exam_Zkousku(aID, FSubjekt,   // podobne je to i ve frmSubjekty
                                 FOdbornostID,
                                 FTOD_ID,
                                 FPredmet_ZK,
                                 '') then

          begin
            try
              Exam_Zkouska_kontrola(0,FSubjekt,
                                    FOdbornostID,
                                    FTOD_ID,
                                    FPredmet_ZK,
                                    '', 1,1);
              PlanOk:=True;
              FTOD_ID:='';
            finally
              t:=FPredmet_ZK;
              MasterRefresh;
              qrMaster.Locate('KOD',t,[]);
            end;

    if planOK and Confirm('Vytisknout doklad o naplánované zkoušce?')then
    try
      Application.CreateForm(TrptZkouskaTerminy,rptZkouskaTerminy);
      with rptZkouskaTerminy do
      begin
        qrSubjekt.Close;
        qrSubjekt.ParamByName('ID').AsString:= IntToStr(FSubjekt);
        qrSubjekt.ParamByName('ODBORNOST_ID').AsInteger:=FOdbornostID;
        if true then
          Tisk_Sestavy_Typ_0(Self,'','Termíny zkoušek '+IntToStr(FOdbornostID),QuickRep1,
                             false,false,false,1,0,0);
(*
        else
          Tisk_Sestavy_Typ_0(Self,'','Termíny zkoušek '+IntToStr(FOdbornostID),QuickRep1,
                             false,false,false,-1,0,0);
*)
        qrSubjekt.Close;
      end;
    finally
      rptZkouskaTerminy.Free;
      rptZkouskaTerminy:=nil;
    end;
       end;
          end;
       end
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlanSeznam.sbAddPoClick(Sender: TObject);
var
  FormIOParams1: TdlgSubjektExamParams;
  FormIOParams: TfrmAkceParams;
  aID,i:Integer;
  t:String;
  PlanOk:Boolean;
begin
  PlanOk:=False;
  FormIOParams :=nil;
  FormIOParams1 :=nil;
  if (Abs(FTyp)=1) and ((FSubjekt<=0) or (FTOD_ID='') or (FPredmet_ZK='')) then
  begin
    If Warn('Nemáte vybraný subjekt, odbornost nebo pøedmìt.'+EOL+
            'Pøejete si pokraèovat výbìrem požadovaných dat') then
      begin
        FormIOParams1 := TdlgSubjektExamParams.Create(DZKOUSKA_PLAN_PFO_ID);
        try
          FormIOParams1.fpSubjekt:=FSubjekt;
          FormIOParams1.fpOdbornostID:=FOdbornostID;
          FormIOParams1.fpOdbornostTOD:=FTOD_ID;
          FormIOParams1.fpPokus:=FPokus;
          FormIOParams1.fpPredmet:=FPredmet_ZK;
          if dlgSubjektExamExec(FormIOParams1) then
          begin
            FSubjekt:=FormIOParams1.fpSubjekt;
            FOdbornostID:=FormIOParams1.fpOdbornostID;
            FTOD_ID:=FormIOParams1.fpOdbornostTOD;
            FPokus:=FormIOParams1.fpPokus;
            FPredmet_ZK:=FormIOParams1.fpPredmet;
            edMin.Text:=Copy(FormIOParams1.fpCas,1,Pos(' ',FormIOParams1.fpCas)-1);
            FCas:=edMin.asInteger;
          end;
        finally
          FormIOParams1.Free;
        end;
      end;
    if ((FSubjekt<=0) or (FTOD_ID='') or (FPredmet_ZK='')) then
      EXIT;
  end;

  if hasdata(qrMaster) then
  begin
    FSelectedDatum:=SelectDat('SELECT TO_DATE('''+FormatDateTime('DD.MM.YYYY',qrMasterDATUM.AsDateTime)+'  '+qrMasterDO.asString+''',''DD.MM.YYYY  HH24:MI'') FROM DUAL');
    i:=qrMasterZDROJ_ID.asInteger;
  end
  else
  begin
    ErrorMsg('Nemáte vybrané PC. Nelze plánovat.');
    Exit;
  end;


  FormIOParams := TfrmAkceParams.Create(PF_NOTHING, [ofoaInsert]);
  try
    aID:=0;
    aID:=NovaAkce(FMistnost, FSubjekt, FTOD_ID, FPredmet_ZK,
                  FSelectedDatum, FSelectedDatum+(edMin.asInteger/(24*60)),
                  i);
    if aID=0 then
      begin
        ErrorMsg('Nepodaøilo se založit novou akci.');
        EXIT;
      end;
    FormIOParams.fpSearchFor := aID;
    FormIOParams.fpCasTrvani := edMin.asInteger;
    FormIOParams.fpTyp := Abs(FTyp);
    FormIOParams.fpSearch:=True;
    if frmAkceExec(FormIOParams, True) then
      begin
        sbAdd.enabled:=false;
        if assigned(Params) then
          begin
            aID:=SelectInt('SELECT ID FROM AKCE WHERE STAV=1 and ID='+IntToStr(aID));
            if aID>0 then
             TdlgZkouskaPlanSeznamParams(Params).fpIDAkce:=aID;
          end;
        MasterRefresh;
        if FTyp=1 then  // planovani ze subjekyu
        begin
          btOk.Visible:=True;
          btOk.enabled:=True;
(*
          btCancel.enabled:=False;
          sbAdd.enabled:=False;
          sbDel.enabled:=False;
          if aID>0 then
            Inform('Zkouška je zaevidována a pøipravena k naplánovaní.'+EOL+' Potvrïte "OK"');
*)
          btOKclick(nil);
        end;
        if FTyp=-1 then  //planovani z hlavniho okna
        begin
          btOk.Visible:=True;
          btOk.enabled:=True;
          btCancel.enabled:=True;
          sbAdd.enabled:=True;
          sbDel.enabled:=True;
          if (aID>0) then
        if Planovat_Exam_Zkousku(aID, FSubjekt,   // podobne je to i ve frmSubjekty
                                 FOdbornostID,
                                 FTOD_ID,
                                 FPredmet_ZK,
                                 '') then

          begin
            try
              Exam_Zkouska_kontrola(0,FSubjekt,
                                    FOdbornostID,
                                    FTOD_ID,
                                    FPredmet_ZK,
                                    '', 1,1);
              PlanOk:=True;
              FTOD_ID:='';
            finally
              t:=FPredmet_ZK;
              MasterRefresh;
              qrMaster.Locate('KOD',t,[]);
            end;

    if planOK and Confirm('Vytisknout doklad o naplánované zkoušce?')then
    try
      Application.CreateForm(TrptZkouskaTerminy,rptZkouskaTerminy);
      with rptZkouskaTerminy do
      begin
        qrSubjekt.Close;
        qrSubjekt.ParamByName('ID').AsString:= IntToStr(FSubjekt);
        qrSubjekt.ParamByName('ODBORNOST_ID').AsInteger:=FOdbornostID;
        if true then
          Tisk_Sestavy_Typ_0(Self,'','Termíny zkoušek '+IntToStr(FOdbornostID),QuickRep1,
                             false,false,false,1,0,0);
(*
        else
          Tisk_Sestavy_Typ_0(Self,'','Termíny zkoušek '+IntToStr(FOdbornostID),QuickRep1,
                             false,false,false,-1,0,0);
*)
        qrSubjekt.Close;
      end;
    finally
      rptZkouskaTerminy.Free;
      rptZkouskaTerminy:=nil;
    end;
       end;
          end;
       end
  finally
    FormIOParams.Free;
  end;
end;

end.
