unit DSEC_Text;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialog, NotiaMagic, Vcl.ExtCtrls,
  UCLTypes, Data.DB, MemDS, DBAccess, Ora, Vcl.StdCtrls, Vcl.Mask, rxToolEdit;

// TdlgSEC_KontrolaParams
{ ------------------------------------------------------------------------- }
type
  TdlgSEC_TextParams = class(TMultiselectFuncParams)
  public
    fpID:Integer;
    fpSEC:Integer;
    fpSubjekt:Integer;
    fpDruh:String;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSEC_Text
{ ------------------------------------------------------------------------- }
type
  TdlgSEC_Text = class(TacDialog)
    pnBottom: TPanel;
    btOK: TButton;
    btCancel: TButton;
    Panel1: TPanel;
    Label12: TLabel;
    edSubjekt: TEdit;
    qrSubjekt: TOraQuery;
    qrSubjektID: TIntegerField;
    qrSubjektNAZEV: TWideStringField;
    qrText: TOraQuery;
    Panel2: TPanel;
    lbTyp: TLabel;
    cbTyp: TComboBox;
    lbID: TLabel;
    edID: TEdit;
    Label5: TLabel;
    edDatum: TDateEdit;
    Label6: TLabel;
    mePoznamka: TMemo;
    Label4: TLabel;
    edEvidCislo: TEdit;
    lbPlatnostDo: TLabel;
    edPlatnostDo: TDateEdit;
    qrTextID: TIntegerField;
    qrTextSEC_ID: TIntegerField;
    qrTextDRUH: TWideStringField;
    qrTextTYP: TWideStringField;
    qrTextDATUM: TDateTimeField;
    qrTextEVID_CISLO: TWideStringField;
    qrTextPLATNOST_DO: TDateTimeField;
    qrTextPOZNAMKA: TWideStringField;
    qrTextZAPSAL: TWideStringField;
    qrTextZAPSANO: TDateTimeField;
    qrTextZMENIL: TWideStringField;
    qrTextZMENENO: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure edDatumExit(Sender: TObject);
    procedure qrTextAfterOpen(DataSet: TDataSet);
    procedure qrTextBeforeOpen(DataSet: TDataSet);
    procedure qrSubjektAfterOpen(DataSet: TDataSet);
    procedure qrSubjektBeforeOpen(DataSet: TDataSet);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    function UlozData:Boolean;
    procedure ClearForNew;
  protected
    Procedure WMSysCommand(var msg: TMessage); Override;
    procedure InitComboTypy;
    Function Typ_Nazev(_KOD:String):String;
    Function Typ_Kod(_Nazev:String):String;
  public
    fSEC:Integer;
    fSubjekt:Integer;
    fID:Integer;
    fDruh:string;
    procedure TextInit;
  end;

var
  dlgSEC_Text: TdlgSEC_Text;

function dlgSEC_TextExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}
uses Tools, Utils, Caches, uUCLConsts, uStoredProcs, NConsts, NParam,uObjUtils,
     FSEC;

function dlgSEC_TextExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSEC_Text, dlgSEC_Text, true);
  try
    with dlgSEC_Text do
    begin
      borderStyle:=bsSizeable;
      Params := _Params;
      if WindowState = wsMinimized then
        WindowState := wsNormal;
      if assigned(Params) then
      begin
        fSEC:=TdlgSEC_TextParams(Params).fpSEC;
        fSubjekt:=TdlgSEC_TextParams(Params).fpSubjekt;
        fID:=TdlgSEC_TextParams(Params).fpID;
        fDruh:=TdlgSEC_TextParams(Params).fpDruh;
      end;
      Result := (ShowModal = mrOK);
      Params := nil;
    end;
  finally
    dlgSEC_Text.free;
    dlgSEC_Text:=nil;
  end;
end;


{ TdlgSEC_TextParams }
// ..........................................................................
constructor TdlgSEC_TextParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpSEC:=-1;
  fpSubjekt:=-1;
  fpID:=-1;
  fpDruh:='';
end;

{ TdlgSEC_Text }
// ..........................................................................
procedure TdlgSEC_Text.FormCreate(Sender: TObject);
begin
  inherited;
  fSEC:=-1;
  fSubjekt:=-1;
  fID:=-1;
  fDruh:='';
  ClearForNew;
end;

// ..........................................................................
procedure TdlgSEC_Text.FormShow(Sender: TObject);
begin
  inherited;
  InitComboTypy; // uz musi byt vyplne fDruh
  TextInit;
end;

// ..........................................................................
procedure TdlgSEC_Text.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qrText.close;
  qrSubjekt.close;
  inherited;
end;

// ..........................................................................
procedure TdlgSEC_Text.WMSysCommand(var msg: TMessage);
begin
  inherited;
  case Msg.wParam of
    SC_Close:if pnBottom.Visible then btCancel.Click;
  end;
end;

// ..........................................................................
procedure TdlgSEC_Text.ClearForNew;
var
  i : integer;
begin
  fID:=-1;
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TMemo then TMemo(Components[i]).text:='';
    if Components[i] is TEdit then TEdit(Components[i]).text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
  TextInit;
end;

// ..........................................................................
procedure TdlgSEC_Text.InitComboTypy;
var
 t:String;
begin
  t:=cbTyp.Items[cbTyp.ItemIndex];
  InitComboSql(cbTyp, 'SELECT NAZEV||'' (''||KOD||'')'' FROM SEC_TEXTY_TYPY WHERE DRUH='+Q(fDruh)+' ORDER BY NAZEV ');
  if t<>'' then                              // obnoveni puvodni hodnoty
    cbTyp.ItemIndex:=cbTyp.Items.IndexOf(t);
end;

// ..........................................................................
function TdlgSEC_Text.Typ_Kod(_Nazev: String): String;
begin
  result:=SelectStr('SELECT KOD FROM SEC_TEXTY_TYPY '+
                    ' WHERE DRUH='+Q(fDruh)+' AND ROWNUM<2 AND NAZEV||'' (''||KOD||'')''='+Q(_Nazev));
end;

// ..........................................................................
function TdlgSEC_Text.Typ_Nazev(_KOD: String): String;
begin
  result:=SelectStr('SELECT NAZEV||'' (''||KOD||'')'' FROM SEC_TEXTY_TYPY '+
                    ' WHERE DRUH='+Q(fDruh)+' AND ROWNUM<2 AND KOD='+Q(_KOD));
end;

// ..........................................................................
procedure TdlgSEC_Text.qrSubjektAfterOpen(DataSet: TDataSet);
begin
  edSubjekt.text:=qrSubjektNAZEV.AsString+'('+qrSubjektID.AsString+')';
end;

// ..........................................................................
procedure TdlgSEC_Text.qrSubjektBeforeOpen(DataSet: TDataSet);
begin
  qrSubjekt.ParamByName('SUBJEKT').asInteger:=FSubjekt;
end;

// ..........................................................................
procedure TdlgSEC_Text.qrTextAfterOpen(DataSet: TDataSet);
begin
  if not hasdata(qrText) then EXIT;

  if not qrTextDATUM.isnull then
    edDatum.date:=qrTextDATUM.asDateTime
  else
    edDatum.clear;

  if edPlatnostDo.visible and not qrTextPLATNOST_DO.isnull then
    edPlatnostDo.date:=qrTextPLATNOST_DO.asDateTime
  else
    edPlatnostDo.clear;

  edEvidCislo.text:=qrTextEVID_CISLO.asString;
  mePoznamka.text:=qrTextPOZNAMKA.asString;
  edID.text:=qrTextID.asString;

  cbTyp.ItemIndex:=cbTyp.Items.IndexOf(Typ_Nazev(qrTextTYP.asString));
end;

// ..........................................................................
procedure TdlgSEC_Text.qrTextBeforeOpen(DataSet: TDataSet);
begin
  qrText.ParamByName('ID').asInteger:=FID;
end;

// ..........................................................................
procedure TdlgSEC_Text.TextInit;
begin
  lbID.visible:=FID>0;
  edID.visible:=lbID.visible;
  lbPlatnostDo.visible:=(FDruh<>'ZAKLADNI') and (FDruh<>'SANKCE') and (Copy(FDruh,1,5)<>'ZMENY');
  edPlatnostDo.visible:=lbPlatnostDo.visible;
  lbTyp.Visible:=(FDruh<>'SANKCE') and (Copy(FDruh,1,5)<>'ZMENY');
  cbTyp.Visible:=lbTyp.Visible;


  if (Copy(FDruh,1,5)='ZMENY') then
    caption:='SEC - Zmìna bezp.programu'
  else if FDruh='SANKCE' then
    caption:='SEC - Sankce'
  else if FDruh='ZAKLADNI' then
    caption:='SEC - Základní opatøení'
  else if FDruh='ZVLASTNI' then
    caption:='SEC - Zvláštní opatøení '
  else if FDruh='MIMORADNE' then
    caption:='SEC - Mimoøádné opatøení'
  else if FDruh='VYJIMKA' then
    caption:='SEC - Výjimka'
  else
    caption:='SEC - text';


  qrSubjekt.close;
  qrText.close;
  qrSubjekt.open;
  qrText.open;

  if (edDatum.Text='') or (edDatum.Text='  .  .    ') then
    edDatum.date:=now; // default
  edDatumExit(nil);
end;

// ..........................................................................
procedure TdlgSEC_Text.edDatumExit(Sender: TObject);
begin
//  btOk.Enabled:=edDatum.date>now-100;
  btOk.Enabled:=True;
end;

// ..........................................................................
procedure TdlgSEC_Text.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgSEC_Text.btOKClick(Sender: TObject);
begin
  if not UlozData then
    exit;

  inherited;
  ModalResult := mrOK;
end;

// ..........................................................................
function TdlgSEC_Text.UlozData: Boolean;
var
  qrTemp:TOraQuery;
begin
  qrTemp:=nil;
  result:=false;
  if edDatum.date=0 then
  begin
    ErrorMsg('"Datum" musí být vyplnìn.');
    Exit;
  end;

  try
    qrTemp:=CreateQueryWithText('SELECT * FROM SEC_TEXTY '+
                                ' WHERE ID='+IntToStr(fID),true);
    qrTemp.open;
    if FID>0 then
      qrTemp.edit
    else
    begin
      qrTemp.insert;
      FID:=SelectInt('SELECT SEQ_SEC_TEXTY_ID.NEXTVAL FROM DUAL');
      qrTemp.FieldByName('SEC_ID').asInteger:=fSec;
      qrTemp.FieldByName('DRUH').asString:=fDruh;
      qrTemp.FieldByName('ID').asInteger:=FID;
    end;
    qrTemp.FieldByName('DATUM').asDateTime:=edDatum.date;
    if edPlatnostDo.visible and (edPlatnostDo.Date>0) then
      qrTemp.FieldByName('PLATNOST_DO').asDateTime:=edPlatnostDo.date
    else
      qrTemp.FieldByName('PLATNOST_DO').clear;

    if cbTyp.visible  then
      qrTemp.FieldByName('TYP').asString:=Typ_kod(cbTyp.Text)
    else
      qrTemp.FieldByName('TYP').clear;
    qrTemp.FieldByName('EVID_CISLO').asString:=edEvidCislo.text;
    qrTemp.FieldByName('POZNAMKA').asString:=mePoznamka.text;

    qrTemp.post;
    qrTemp.close;
  finally
     qrTemp.free;
     qrTemp:=nil;
  end;


  result:=true;
end;


end.
