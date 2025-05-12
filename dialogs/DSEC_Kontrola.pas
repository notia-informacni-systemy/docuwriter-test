unit DSEC_Kontrola;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialog, NotiaMagic, Vcl.ExtCtrls,
  UCLTypes, Data.DB, MemDS, DBAccess, Ora, Vcl.StdCtrls, Vcl.Mask, rxToolEdit;

// TdlgSEC_KontrolaParams
{ ------------------------------------------------------------------------- }
type
  TdlgSEC_KontrolaParams = class(TMultiselectFuncParams)
  public
    fpSEC:Integer;
    fpCISLO:Integer;
    fpSubjekt:Integer;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSEC_Kontrola
type
  TdlgSEC_Kontrola = class(TacDialog)
    pnBottom: TPanel;
    btOK: TButton;
    btCancel: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Label4: TLabel;
    edNazev: TEdit;
    cbTyp: TComboBox;
    cbDruh: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label12: TLabel;
    edSubjekt: TEdit;
    lbCislo: TLabel;
    edCislo: TEdit;
    edDatum: TDateEdit;
    ckNalez: TCheckBox;
    ckSankce: TCheckBox;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    ckFAZE_ODESLANO: TCheckBox;
    ckFAZE_PLAN: TCheckBox;
    ckFAZE_KONEC: TCheckBox;
    ckFAZE_AKCE_CEKANI: TCheckBox;
    ckFAZE_AKCE_PLAN: TCheckBox;
    ckFAZE_SPLNENI: TCheckBox;
    ckFAZE_UZAVRENI: TCheckBox;
    mePoznamka: TMemo;
    Label6: TLabel;
    qrSubjekt: TOraQuery;
    qrSubjektID: TIntegerField;
    qrSubjektNAZEV: TWideStringField;
    qrKontrola: TOraQuery;
    qrKontrolaSEC_ID: TIntegerField;
    qrKontrolaCISLO: TIntegerField;
    qrKontrolaNAZEV: TWideStringField;
    qrKontrolaTYP: TWideStringField;
    qrKontrolaDRUH: TWideStringField;
    qrKontrolaDATUM: TDateTimeField;
    qrKontrolaNALEZ: TIntegerField;
    qrKontrolaSANKCE: TIntegerField;
    qrKontrolaFAZE_ODESLANO: TIntegerField;
    qrKontrolaFAZE_PLAN: TIntegerField;
    qrKontrolaFAZE_KONEC: TIntegerField;
    qrKontrolaFAZE_AKCE_CEKANI: TIntegerField;
    qrKontrolaFAZE_AKCE_PLAN: TIntegerField;
    qrKontrolaFAZE_SPLNENI: TIntegerField;
    qrKontrolaFAZE_UZAVRENI: TIntegerField;
    qrKontrolaZAPSAL: TWideStringField;
    qrKontrolaZAPSANO: TDateTimeField;
    qrKontrolaZMENIL: TWideStringField;
    qrKontrolaZMENENO: TDateTimeField;
    qrKontrolaPOZNAMKA: TWideStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure qrSubjektAfterOpen(DataSet: TDataSet);
    procedure qrSubjektBeforeOpen(DataSet: TDataSet);
    procedure edNazevExit(Sender: TObject);
    procedure qrKontrolaBeforeOpen(DataSet: TDataSet);
    procedure qrKontrolaAfterOpen(DataSet: TDataSet);
  private
    function UlozData:Boolean;
    procedure ClearForNew;
  protected
    Procedure WMSysCommand(var msg: TMessage); Override;
    procedure InitComboTypy;
    procedure InitComboDruhy;
    Function Druh_Nazev(_KOD:String):String;
    Function Druh_Kod(_Nazev:String):String;
    Function Typ_Nazev(_KOD:String):String;
    Function Typ_Kod(_Nazev:String):String;
  public
    fSEC:Integer;
    fCislo:Integer;
    fSubjekt:Integer;
    procedure KontrolaInit;
  end;

var
  dlgSEC_Kontrola: TdlgSEC_Kontrola;

function dlgSEC_KontrolaExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}
uses Tools, Utils, Caches, uUCLConsts, uStoredProcs, NConsts, NParam,uObjUtils,
     FSEC;

function dlgSEC_KontrolaExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSEC_Kontrola, dlgSEC_Kontrola, true);
  try
    with dlgSEC_Kontrola do
    begin
      borderStyle:=bsSizeable;
      Params := _Params;
      if WindowState = wsMinimized then
        WindowState := wsNormal;
      if assigned(Params) then
      begin
        fSEC:=TdlgSEC_KontrolaParams(Params).fpSEC;
        fCislo:=TdlgSEC_KontrolaParams(Params).fpCislo;
        fSubjekt:=TdlgSEC_KontrolaParams(Params).fpSubjekt;
      end;
      Result := (ShowModal = mrOK);
      Params := nil;
    end;
  finally
    dlgSEC_Kontrola.free;
    dlgSEC_Kontrola:=nil;
  end;
end;


{ TdlgSEC_KontrolaParams }
// ..........................................................................
constructor TdlgSEC_KontrolaParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpSEC:=-1;
  fpCislo:=-1;
  fpSubjekt:=-1;
end;

{ TdlgSEC_Kontrola }
// ..........................................................................
procedure TdlgSEC_Kontrola.FormCreate(Sender: TObject);
begin
  inherited;
  fSEC:=-1;
  fCislo:=-1;
  fSubjekt:=-1;
  ClearForNew;
  InitComboTypy;
  InitComboDruhy;
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.FormShow(Sender: TObject);
begin
  inherited;
  KontrolaInit;
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qrKontrola.close;
  qrSubjekt.close;
  inherited;
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.WMSysCommand(var msg: TMessage);
begin
  inherited;
  case Msg.wParam of
    SC_Close:if pnBottom.Visible then btCancel.Click;
  end;
end;


// ..........................................................................
procedure TdlgSEC_Kontrola.InitComboDruhy;
var
 t:String;
begin
  t:=cbDruh.Items[cbDruh.ItemIndex];
  InitComboSql(cbDruh, 'SELECT NAZEV||'' (''||KOD||'')'' FROM SEC_KONTROLY_DRUHY ORDER BY NAZEV ');
  if t<>'' then                              // obnoveni puvodni hodnoty
    cbDruh.ItemIndex:=cbDruh.Items.IndexOf(t);
end;

// ..........................................................................
function TdlgSEC_Kontrola.Druh_Kod(_Nazev: String): String;
begin
  result:=SelectStr('SELECT KOD FROM SEC_KONTROLY_DRUHY WHERE ROWNUM<2 AND NAZEV||'' (''||KOD||'')''='+Q(_Nazev));
end;

// ..........................................................................
function TdlgSEC_Kontrola.Druh_Nazev(_KOD: String): String;
begin
  result:=SelectStr('SELECT NAZEV||'' (''||KOD||'')'' FROM SEC_KONTROLY_DRUHY WHERE ROWNUM<2 AND KOD='+Q(_KOD));
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.edNazevExit(Sender: TObject);
begin
  btOk.Enabled:=(Trim(edNazev.text)<>'');
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.InitComboTypy;
var
 t:String;
begin
  t:=cbTyp.Items[cbTyp.ItemIndex];
  InitComboSql(cbTyp, 'SELECT NAZEV||'' (''||KOD||'')'' FROM SEC_KONTROLY_TYPY ORDER BY NAZEV ');
  if t<>'' then                              // obnoveni puvodni hodnoty
    cbTyp.ItemIndex:=cbTyp.Items.IndexOf(t);
end;

// ..........................................................................
function TdlgSEC_Kontrola.Typ_Kod(_Nazev: String): String;
begin
  result:=SelectStr('SELECT KOD FROM SEC_KONTROLY_TYPY WHERE ROWNUM<2 AND NAZEV||'' (''||KOD||'')''='+Q(_Nazev));
end;

// ..........................................................................
function TdlgSEC_Kontrola.Typ_Nazev(_KOD: String): String;
begin
  result:=SelectStr('SELECT NAZEV||'' (''||KOD||'')'' FROM SEC_KONTROLY_TYPY WHERE ROWNUM<2 AND KOD='+Q(_KOD));
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.qrKontrolaAfterOpen(DataSet: TDataSet);
begin
  if not hasdata(qrKontrola) then EXIT;

  edNazev.text:=qrKontrolaNAZEV.asString;
  mePoznamka.text:=qrKontrolaPOZNAMKA.asString;
  edCislo.text:=qrKontrolaCISLO.asString;

  cbTyp.ItemIndex:=cbTyp.Items.IndexOf(Typ_Nazev(qrKontrolaTYP.asString));
  cbDruh.ItemIndex:=cbDruh.Items.IndexOf(Druh_Nazev(qrKontrolaDRUH.asString));

  if not qrKontrolaDATUM.isnull then
    edDatum.date:=qrKontrolaDATUM.asDateTime
  else
    edDatum.clear;

  ckNalez.checked:=qrKontrolaNALEZ.asInteger=1;
  ckSankce.checked:=qrKontrolaSANKCE.asInteger=1;

  ckFAZE_ODESLANO.checked:=qrKontrolaFAZE_ODESLANO.asInteger=1;
  ckFAZE_PLAN.checked:=qrKontrolaFAZE_PLAN.asInteger=1;
  ckFAZE_KONEC.checked:=qrKontrolaFAZE_KONEC.asInteger=1;
  ckFAZE_AKCE_CEKANI.checked:=qrKontrolaFAZE_AKCE_CEKANI.asInteger=1;
  ckFAZE_AKCE_PLAN.checked:=qrKontrolaFAZE_AKCE_PLAN.asInteger=1;
  ckFAZE_SPLNENI.checked:=qrKontrolaFAZE_SPLNENI.asInteger=1;
  ckFAZE_UZAVRENI.checked:=qrKontrolaFAZE_UZAVRENI.asInteger=1;


end;

// ..........................................................................
procedure TdlgSEC_Kontrola.qrKontrolaBeforeOpen(DataSet: TDataSet);
begin
  qrKontrola.ParamByName('SEC_ID').asInteger:=FSec;
  qrKontrola.ParamByName('CISLO').asInteger:=FCislo;
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.KontrolaInit;
begin
  lbCislo.visible:=FCislo>0;
  edCislo.visible:=lbCislo.visible;

  qrSubjekt.close;
  qrKontrola.close;
  qrSubjekt.open;
  qrKontrola.open;
  edNazevExit(nil);
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.qrSubjektAfterOpen(DataSet: TDataSet);
begin
  edSubjekt.text:=qrSubjektNAZEV.AsString+'('+qrSubjektID.AsString+')';
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.qrSubjektBeforeOpen(DataSet: TDataSet);
begin
  qrSubjekt.ParamByName('SUBJEKT').asInteger:=FSubjekt;
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.ClearForNew;
var
  i : integer;
begin
  fCislo:=-1;
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TMemo then TMemo(Components[i]).text:='';
    if Components[i] is TEdit then TEdit(Components[i]).text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
  KontrolaInit;
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgSEC_Kontrola.btOKClick(Sender: TObject);
begin
  if not UlozData then
    exit;

  inherited;
  ModalResult := mrOK;
end;

// ..........................................................................
function TdlgSEC_Kontrola.UlozData: Boolean;
var
  qrTemp:TOraQuery;
begin
  qrTemp:=nil;
  result:=false;
  if edNazev.text='' then
  begin
    ErrorMsg('"Název" musí být vyplnìn.');
    Exit;
  end;

  try
    qrTemp:=CreateQueryWithText('SELECT * FROM SEC_KONTROLY '+
                                ' WHERE SEC_ID='+IntToStr(fSEC)+
                                '   AND CISLO='+IntToStr(FCislo),true);
    qrTemp.open;
    if FCislo>0 then
      qrTemp.edit
    else
    begin
      qrTemp.insert;
      FCislo:=SelectInt('SELECT NVL(Max(Cislo),0)+1 FROM SEC_KONTROLY WHERE SEC_ID='+IntToStr(fSEC));
      qrTemp.FieldByName('SEC_ID').asInteger:=fSec;
      qrTemp.FieldByName('CISLO').asInteger:=FCislo;
    end;
    qrTemp.FieldByName('NAZEV').asString:=edNazev.text;
    qrTemp.FieldByName('TYP').asString:=Typ_kod(cbTyp.Text);
    qrTemp.FieldByName('DRUH').asString:=Druh_Kod(cbDruh.Text);
    if edDatum.Date>0 then
      qrTemp.FieldByName('DATUM').asDateTime:=edDatum.date
    else
      qrTemp.FieldByName('DATUM').clear;
    qrTemp.FieldByName('POZNAMKA').asString:=mePoznamka.text;


    qrTemp.FieldByName('NALEZ').asInteger:=byte(ckNalez.checked);
    qrTemp.FieldByName('SANKCE').asInteger:=byte(ckSankce.checked);

    qrTemp.FieldByName('FAZE_ODESLANO').asInteger:=byte(ckFAZE_ODESLANO.checked);
    qrTemp.FieldByName('FAZE_PLAN').asInteger:=byte(ckFAZE_PLAN.checked);
    qrTemp.FieldByName('FAZE_KONEC').asInteger:=byte(ckFAZE_KONEC.checked);
    qrTemp.FieldByName('FAZE_AKCE_CEKANI').asInteger:=byte(ckFAZE_AKCE_CEKANI.checked);
    qrTemp.FieldByName('FAZE_AKCE_PLAN').asInteger:=byte(ckFAZE_AKCE_PLAN.checked);
    qrTemp.FieldByName('FAZE_SPLNENI').asInteger:=byte(ckFAZE_SPLNENI.checked);
    qrTemp.FieldByName('FAZE_UZAVRENI').asInteger:=byte(ckFAZE_UZAVRENI.checked);


    qrTemp.post;
    qrTemp.close;
  finally
     qrTemp.free;
     qrTemp:=nil;
  end;


  result:=true;
end;

end.
