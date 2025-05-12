unit DSEC_Kontakt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialog, NotiaMagic, Vcl.ExtCtrls,
  UCLTypes, Vcl.StdCtrls, Data.DB, MemDS, DBAccess, Ora, Vcl.NGrids,
  Vcl.NDBGrids, MSGrid, Vcl.Mask, rxToolEdit;

// TdlgSEC_KontaktParams
{ ------------------------------------------------------------------------- }
type
  TdlgSEC_KontaktParams = class(TMultiselectFuncParams)
  public
    fpSEC:Integer;
    fpCislo:Integer;
    fpTyp:String;
    fpSubjekt:Integer;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSEC_Kontakt
type
  TdlgSEC_Kontakt = class(TacDialog)
    pnSubjekt: TPanel;
    pnOsoba: TPanel;
    pnBottom: TPanel;
    btOK: TButton;
    btCancel: TButton;
    btOsoba: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    edJmeno: TEdit;
    edPrijmeni: TEdit;
    edTitul2: TEdit;
    edTitul: TEdit;
    lbFunkce: TLabel;
    edFunkce: TEdit;
    pnAdresa: TPanel;
    btAdresa: TButton;
    pnSpojeni: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edUlice: TEdit;
    edMesto: TEdit;
    edPSC: TEdit;
    btStat: TButton;
    cbStat: TComboBox;
    qrStat: TOraQuery;
    qrStatNAZEV: TWideStringField;
    Panel1: TPanel;
    qrSpojeni: TOraQuery;
    qrSpojeniCISLO: TIntegerField;
    qrSpojeniKOD: TWideStringField;
    qrSpojeniCISLO_ADRESY: TIntegerField;
    qrSpojeniCISLO_OSOBY: TIntegerField;
    qrSpojeniHODNOTA: TWideStringField;
    dsSpojeni: TOraDataSource;
    grSpojeni: TMSDBGrid;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edTel: TEdit;
    edMobil: TEdit;
    edEmail: TEdit;
    qrAdresa: TOraQuery;
    qrAdresaCISLO: TIntegerField;
    qrAdresaNAZEV_ADRESY: TWideStringField;
    qrAdresaULICE: TWideStringField;
    qrAdresaMESTO: TWideStringField;
    qrAdresaPSC: TWideStringField;
    qrAdresaSTAT: TWideStringField;
    qrAdresaSIDLO: TSmallintField;
    qrAdresaPOBOCKA: TSmallintField;
    qrAdresaDOPRAVA: TSmallintField;
    qrAdresaFAKTURACE: TSmallintField;
    qrAdresaVYCHOZI: TSmallintField;
    qrAdresaNAZEV_ADRESY_2: TWideStringField;
    qrAdresaPOTVRZENI_OBJP: TSmallintField;
    qrAdresaTISK_NAZEV2: TSmallintField;
    qrAdresaPOPIS: TWideStringField;
    qrAdresaEAN: TWideStringField;
    qrAdresaOBJEKT: TWideStringField;
    qrAdresaPRODEJCE: TWideStringField;
    qrAdresaSUBJEKT: TIntegerField;
    qrOsoba: TOraQuery;
    qrOsobaCISLO_ADRESY: TIntegerField;
    qrOsobaCISLO: TIntegerField;
    qrOsobaPRIJMENI: TWideStringField;
    qrOsobaJMENO: TWideStringField;
    qrOsobaTITUL: TWideStringField;
    qrOsobaFUNKCE: TWideStringField;
    qrOsobaTITUL2: TWideStringField;
    qrSubjekt: TOraQuery;
    qrSubjektID: TIntegerField;
    qrSubjektNAZEV: TWideStringField;
    qrOsobaTYP_SEC: TWideStringField;
    Label12: TLabel;
    edSubjekt: TEdit;
    btOsobaClear: TButton;
    btAdresaClear: TButton;
    cbFunkceSEC: TComboBox;
    Label13: TLabel;
    edDatumNar: TDateEdit;
    qrOsobaDAT_NAROZENI: TDateTimeField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btAdresaClick(Sender: TObject);
    procedure btOsobaClick(Sender: TObject);
    procedure btStatClick(Sender: TObject);
    procedure edMestoExit(Sender: TObject);
    procedure grSpojeniDblClick(Sender: TObject);
    procedure qrSpojeniBeforeOpen(DataSet: TDataSet);
    procedure qrSubjektBeforeOpen(DataSet: TDataSet);
    procedure qrOsobaBeforeOpen(DataSet: TDataSet);
    procedure qrAdresaBeforeOpen(DataSet: TDataSet);
    procedure qrAdresaAfterOpen(DataSet: TDataSet);
    procedure qrSubjektAfterOpen(DataSet: TDataSet);
    procedure qrOsobaAfterOpen(DataSet: TDataSet);
    procedure btOsobaClearClick(Sender: TObject);
    procedure btAdresaClearClick(Sender: TObject);
    procedure qrSpojeniCISLO_OSOBYGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    function UlozData:Boolean;
    procedure ClearForNew;
  protected
    procedure InitSecFunkce;
    Procedure WMSysCommand(var msg: TMessage); Override;
    procedure InitComboStaty;
    Function STAT_Nazev(_KOD:String):String;
    Function STAT_Kod(_Nazev:String):String;
  public
    fSec:Integer;
    fTyp:String;
    fSubjekt:Integer;
    fOsoba:Integer;
    fAdresa:Integer;
    fEmail:Integer;
    fMobil:Integer;
    fTel:Integer;
    procedure OsobaInit;
  end;

var
  dlgSEC_Kontakt: TdlgSEC_Kontakt;

function dlgSEC_KontaktExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}
uses Tools, Utils, Caches, uUCLConsts, uStoredProcs, NConsts, NParam,uObjUtils,
     FSEC, FSubjekty, FOsoby, FStaty;

function dlgSEC_KontaktExec(_Params: TFuncParams): boolean;
begin
  try
    Screen.Cursor := crHourGlass;
    if assigned(dlgSEC_Kontakt) then
    begin
      dlgSEC_Kontakt.free;
      dlgSEC_Kontakt:=nil;
    end;
    PrepareForm(TdlgSEC_Kontakt, dlgSEC_Kontakt, true);
    with dlgSEC_Kontakt do
    begin
      borderStyle:=bsSizeable;
      Params := _Params;
      if WindowState = wsMinimized then
        WindowState := wsNormal;
      if assigned(Params) then
      begin
        fSec:=TdlgSEC_KontaktParams(Params).fpSec;
        fTyp:=TdlgSEC_KontaktParams(Params).fpTyp;
        fSubjekt:=TdlgSEC_KontaktParams(Params).fpSubjekt;
        fOsoba:=TdlgSEC_KontaktParams(Params).fpCislo;
      end;
      Screen.Cursor := crDefault;
      Result := (ShowModal = mrOK);
      Params := nil;
    end;
  finally
    dlgSEC_Kontakt.free;
    dlgSEC_Kontakt:=nil;
    Screen.Cursor := crDefault
  end;
end;


{ TdlgSEC_KontaktParams }
// ..........................................................................
constructor TdlgSEC_KontaktParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpTyp:='';
  fpSEC:=-1;
  fpCislo:=-1;
end;

{ TdlgSEC_Kontakt }
// ..........................................................................
procedure TdlgSEC_Kontakt.FormCreate(Sender: TObject);
begin
  inherited;
  fSec:=-1;
  fTyp:='';
  fSubjekt:=-1;
  ClearForNew;
  InitComboStaty;
  InitSecFunkce;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.FormShow(Sender: TObject);
begin
  inherited;
  osobaInit;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qrSubjekt.close;
  qrAdresa.close;
  qrOsoba.close;
  qrSpojeni.close;
  inherited;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.WMSysCommand(var msg: TMessage);
begin
  inherited;
  case Msg.wParam of
    SC_Close:if pnBottom.Visible then btCancel.Click;
  end;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.OsobaInit;
begin
  qrSubjekt.close;
  qrAdresa.close;
  qrOsoba.close;
  qrSpojeni.close;
  qrSubjekt.open;
  qrOsoba.open;
  qrAdresa.open;
  qrSpojeni.Open;
  fTel:=SelectInt('SELECT NVL(min(CISLO),-1) FROM SUBJEKTY_SPOJENI '+
                        ' WHERE KOD=''TELEFON'' AND SEC=1 '+
                        '   AND SUBJEKT='+IntToStr(fSubjekt)+
                        '   AND CISLO_OSOBY='+IntToStr(fOsoba));
  edTel.Text:=SelectStr('SELECT HODNOTA FROM SUBJEKTY_SPOJENI '+
                        ' WHERE CISLO='+IntToStr(fTel));

  fMobil:=SelectInt('SELECT NVL(min(CISLO),-1) FROM SUBJEKTY_SPOJENI '+
                        ' WHERE KOD=''MOBIL'' AND SEC=1 '+
                        '   AND SUBJEKT='+IntToStr(fSubjekt)+
                        '   AND CISLO_OSOBY='+IntToStr(fOsoba));
  edMobil.Text:=SelectStr('SELECT HODNOTA FROM SUBJEKTY_SPOJENI '+
                        ' WHERE CISLO='+IntToStr(fMobil));

  fEmail:=SelectInt('SELECT NVL(min(CISLO),-1) FROM SUBJEKTY_SPOJENI '+
                        ' WHERE KOD=''E-MAIL'' AND SEC=1 '+
                        '   AND SUBJEKT='+IntToStr(fSubjekt)+
                        '   AND CISLO_OSOBY='+IntToStr(fOsoba));
  edEmail.Text:=SelectStr('SELECT HODNOTA FROM SUBJEKTY_SPOJENI '+
                        ' WHERE CISLO='+IntToStr(fEmail));
  if cbStat.ItemIndex<1 then
    cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev('CZ')); // default
  edMestoExit(nil);
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.qrAdresaAfterOpen(DataSet: TDataSet);
begin
  edUlice.text:=qrAdresaULICE.AsString;
  edMesto.text:=qrAdresaMESTO.AsString;
  edPSC.text:=qrAdresaPSC.AsString;
  cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev(qrAdresaSTAT.AsString));
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.qrAdresaBeforeOpen(DataSet: TDataSet);
begin
  qrAdresa.ParamByName('ADRESA').asInteger:=FAdresa;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.qrOsobaAfterOpen(DataSet: TDataSet);
begin
  edTitul.text:=qrOsobaTITUL.AsString;
  edJmeno.text:=qrOsobaJMENO.AsString;
  edPrijmeni.text:=qrOsobaPRIJMENI.AsString;
  edDatumNar.date:=qrOsobaDAT_NAROZENI.asDateTime;
  edTitul2.text:=qrOsobaTITUL2.AsString;
  edFunkce.text:=qrOsobaFUNKCE.AsString;
  cbFunkceSEC.itemIndex:=cbFunkceSEC.items.indexOf(qrOsobaTYP_SEC.AsString);
  if cbFunkceSEC.itemIndex<0 then
    cbFunkceSEC.text:=qrOsobaTYP_SEC.AsString;
  if qrOsobaCISLO_ADRESY.asInteger>0 then
    FAdresa:=qrOsobaCISLO_ADRESY.asInteger
  else
  begin
    FAdresa:=-1;
    if (FOsoba>0) then
      FAdresa:=SelectInt('SELECT NVL(min(CISLO),-1) FROM SUBJEKTY_ADRESY '+
                          ' WHERE SEC=1 '+
                          '   AND SUBJEKT='+IntToStr(fSubjekt));
    if (FOsoba>0) and (FAdresa<0) then
      FAdresa:=SelectInt('SELECT NVL(min(CISLO),-1) FROM SUBJEKTY_ADRESY '+
                          ' WHERE SIDLO=1 '+
                          '   AND SUBJEKT='+IntToStr(fSubjekt));
  end
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.qrOsobaBeforeOpen(DataSet: TDataSet);
begin
  qrOsoba.ParamByName('OSOBA').asInteger:=FOsoba;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.qrSpojeniBeforeOpen(DataSet: TDataSet);
begin
  qrSpojeni.ParamByName('OSOBA').asInteger:=FOsoba;
  qrSpojeni.ParamByName('SUBJEKT').asInteger:=FSubjekt;
end;

procedure TdlgSEC_Kontakt.qrSpojeniCISLO_OSOBYGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:='';
  if not Sender.IsNull then
    Text := SelectStr('SELECT CISLO||''=''||OSOBA_JMENO(Prijmeni,Jmeno,Titul,Titul2) '+
                      ' FROM SUBJEKTY_OSOBY '+
                      ' WHERE CISLO='+Q(Sender.AsString));
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.qrSubjektAfterOpen(DataSet: TDataSet);
begin
  edSubjekt.text:=qrSubjektNAZEV.AsString+'('+qrSubjektID.AsString+')';
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.qrSubjektBeforeOpen(DataSet: TDataSet);
begin
  qrSubjekt.ParamByName('SUBJEKT').asInteger:=FSubjekt;
end;

// ..........................................................................
function TdlgSEC_Kontakt.STAT_Kod(_Nazev: String): String;
begin
  result:=SelectStr('SELECT KOD FROM STATY WHERE ROWNUM<2 AND NAZEV='+Q(_Nazev));
end;

function TdlgSEC_Kontakt.STAT_Nazev(_KOD: String): String;
begin
  result:=SelectStr('SELECT NAZEV FROM STATY WHERE ROWNUM<2 AND KOD='+Q(_KOD));
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.btAdresaClearClick(Sender: TObject);
begin
  FAdresa:=-1;
  qrAdresa.close;
  cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev('CZ')); // default
  qrAdresa.Open;
  edMestoExit(nil);
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.btAdresaClick(Sender: TObject);
begin
(* MK
 if frmAdresyExecute(FAdresa, FSubjekt) then
  begin
    qrAdresa.close;
    cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev('CZ')); // default
    qrAdresa.Open;
    edMestoExit(nil);
  end;
*)
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.btOsobaClearClick(Sender: TObject);
begin
  inherited;
  FOsoba:=-1;
  OsobaInit;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.btOsobaClick(Sender: TObject);
begin
  if frmOsobyExecute(FOsoba, FSubjekt) then
    OsobaInit;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.InitComboStaty;
begin
 InitCombo(cbStat,qrStat);
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.InitSecFunkce;
var
 t:String;
begin
  t:=cbFunkceSec.Items[cbFunkceSec.ItemIndex];
  InitComboSql(cbFunkceSec, 'select distinct TYP_SEC FROM SUBJEKTY_OSOBY WHERE TYP_SEC is not null order by TYP_SEC ');
  if t<>'' then                              // obnoveni puvodni hodnoty
    cbFunkceSec.ItemIndex:=cbFunkceSec.Items.IndexOf(t);
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.btStatClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], InitComboStaty);
  try
    FormIOParams.fpSearch := cbStat.TEXT<>'';
    FormIOParams.fpSearchFor := Stat_kod(cbStat.TEXT);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
      edMestoExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.ClearForNew;
var
  i : integer;
begin
  fOsoba:=-1;
  fAdresa:=-1;
  fEmail:=-1;
  fMobil:=-1;
  fTel:=-1;
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TEdit then TEdit(Components[i]).text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
  osobaInit;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.btOKClick(Sender: TObject);
begin
  if not UlozData then
    exit;

  inherited;
  ModalResult := mrOK;
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.edMestoExit(Sender: TObject);
begin
  btOk.Enabled:=(Trim(edPrijmeni.text)<>'') and (Trim(cbFunkceSEC.text)<>'');
//                 and (Trim(edMesto.text)<>'') and (Trim(cbStat.text)<>'');
end;

// ..........................................................................
procedure TdlgSEC_Kontakt.grSpojeniDblClick(Sender: TObject);
begin
  inherited;
  if qrSpojeniKOD.asString='TELEFON' then
  begin
    edTel.text:=qrSpojeniHODNOTA.asString;
    FTel:=qrSpojeniCISLO.asInteger;
  end;
  if qrSpojeniKOD.asString='MOBIL' then
  begin
    edMobil.text:=qrSpojeniHODNOTA.asString;
    FMobil:=qrSpojeniCISLO.asInteger;
  end;
  if qrSpojeniKOD.asString='E-MAIL' then
  begin
    edEmail.text:=qrSpojeniHODNOTA.asString;
    FEmail:=qrSpojeniCISLO.asInteger;
  end;
end;

// ..........................................................................
function TdlgSEC_Kontakt.UlozData: Boolean;
var
  qrTemp:TOraQuery;
  t:String;
  i:Integer;
begin
  qrTemp:=nil;
  result:=false;
  if cbFunkceSEC.text='' then
  begin
    ErrorMsg('"Funkce SEC" musí být vyplnìna.');
    Exit;
  end;
  if edPrijmeni.text='' then
  begin
    ErrorMsg('"Pøíjmení" musí být vyplnìno.');
    Exit;
  end;

  t:='';
  if edMesto.text='' then
    t:=t+'Není vyplnìno "Mìsto" adresy.';
  if (t<>'') and not confirm(t+EOL+'Pokraèovat?') then
    EXIT;


// Adresa
  if edMesto.text<>'' then
  try
    i:=selectInt('SELECT count(*) from SUBJEKTY_ADRESY WHERE SUBJEKT='+IntToStr(fSubjekt));
    ExecSqlText('UPDATE SUBJEKTY_ADRESY SET SEC=0 '+
                ' WHERE SUBJEKT='+IntToStr(fSubjekt));
    qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_ADRESY WHERE CISLO='+IntToStr(FAdresa),true);
    qrTemp.open;
    if FAdresa>0 then
      qrTemp.edit
    else
    begin
      qrTemp.insert;
      FAdresa:=SelectInt('SELECT SEQ_SUBJEKTY_ADRESY_CISLO.NEXTVAL FROM dual');
      qrTemp.FieldByName('SUBJEKT').asInteger:=fSubjekt;
      qrTemp.FieldByName('CISLO').asInteger:=FAdresa;
    end;
    qrTemp.FieldByName('SEC').asInteger:=1;
    qrTemp.FieldByName('ULICE').asString:=edUlice.text;
    qrTemp.FieldByName('MESTO').asString:=edMesto.text;
    qrTemp.FieldByName('PSC').asString:=edPSC.text;
    qrTemp.FieldByName('STAT').asString:=Stat_Kod(cbStat.Text);
    if i=0 then
    begin
      qrTemp.FieldByName('VYCHOZI').asInteger:=1;
      qrTemp.FieldByName('SIDLO').asInteger:=1;
    end;
    qrTemp.post;
    qrTemp.close;
  finally
     qrTemp.free;
     qrTemp:=nil;
     Aktualizuj_Subjekty_Adresy(fSubjekt);
  end;
// Osoba
  if edPrijmeni.text<>'' then
  try
    i:=selectInt('SELECT count(*) from SUBJEKTY_OSOBY WHERE SUBJEKT='+IntToStr(fSubjekt));
    qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_OSOBY WHERE CISLO='+IntToStr(FOsoba),true);
    qrTemp.open;
    if FOsoba>0 then
      qrTemp.edit
    else
    begin
      qrTemp.insert;
      FOsoba:=SelectInt('SELECT SEQ_SUBJEKTY_OSOBY_CISLO.NEXTVAL FROM dual');
      qrTemp.FieldByName('SUBJEKT').asInteger:=fSubjekt;
      qrTemp.FieldByName('CISLO').asInteger:=FOsoba;
    end;
    if FAdresa>0 then
      qrTemp.FieldByName('CISLO_ADRESY').asString:=IntToStr(FAdresa);
    qrTemp.FieldByName('TITUL').asString:=edTitul.text;
    qrTemp.FieldByName('JMENO').asString:=edJmeno.text;
    qrTemp.FieldByName('PRIJMENI').asString:=edPrijmeni.text;
    if edDatumNar.date>0 then
      qrTemp.FieldByName('DAT_NAROZENI').asDateTime:=edDatumNar.date
    else
      qrTemp.FieldByName('DAT_NAROZENI').clear;
    qrTemp.FieldByName('TITUL2').asString:=edTitul2.text;
    qrTemp.FieldByName('FUNKCE').asString:=edFunkce.text;
    qrTemp.FieldByName('TYP_SEC').asString:=cbFunkceSEC.text;
    if (i=0) and (fTyp='SKOLITEL') then
      qrTemp.FieldByName('VYCHOZI').asInteger:=1;
    qrTemp.post;
    qrTemp.close;
  finally
     qrTemp.free;
     qrTemp:=nil;
     Aktualizuj_Subjekty_Osoby(FSubjekt);
  end;

// Tel
  if edTel.text<>'' then
  try
    ExecSqlText('UPDATE SUBJEKTY_SPOJENI SET SEC=0 '+
                ' WHERE KOD=''TELEFON'' '+
                '   AND SUBJEKT='+IntToStr(fSubjekt)+
                '   AND CISLO_OSOBY='+IntToStr(fOsoba));
    qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_SPOJENI WHERE CISLO='+IntToStr(FTel),true);
    qrTemp.open;
    if FTel>0 then
      qrTemp.edit
    else
    begin
      qrTemp.insert;
      FTel:=SelectInt('SELECT SEQ_SUBJEKTY_SPOJENI_CISLO.NEXTVAL FROM dual');
      qrTemp.FieldByName('SUBJEKT').asInteger:=fSubjekt;
      qrTemp.FieldByName('CISLO').asInteger:=FTel;
    end;
    qrTemp.FieldByName('CISLO_OSOBY').asString:=IntToStr(FOsoba);
    if FAdresa>0 then
      qrTemp.FieldByName('CISLO_ADRESY').asString:=IntToStr(FAdresa);
    qrTemp.FieldByName('SEC').asInteger:=1;
    qrTemp.FieldByName('KOD').asString:='TELEFON';
    qrTemp.FieldByName('HODNOTA').asString:=edTel.text;
    qrTemp.post;
    qrTemp.close;
  finally
     qrTemp.free;
     qrTemp:=nil;
  end;

// Mobil
  if edMobil.text<>'' then
  try
    ExecSqlText('UPDATE SUBJEKTY_SPOJENI SET SEC=0 '+
                ' WHERE KOD=''MOBIL'' '+
                '   AND SUBJEKT='+IntToStr(fSubjekt)+
                '   AND CISLO_OSOBY='+IntToStr(fOsoba));
    qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_SPOJENI WHERE CISLO='+IntToStr(FMobil),true);
    qrTemp.open;
    if FMobil>0 then
      qrTemp.edit
    else
    begin
      qrTemp.insert;
      FMobil:=SelectInt('SELECT SEQ_SUBJEKTY_SPOJENI_CISLO.NEXTVAL FROM dual');
      qrTemp.FieldByName('SUBJEKT').asInteger:=fSubjekt;
      qrTemp.FieldByName('CISLO').asInteger:=FMobil;
    end;
    qrTemp.FieldByName('CISLO_OSOBY').asString:=IntToStr(FOsoba);
    if FAdresa>0 then
      qrTemp.FieldByName('CISLO_ADRESY').asString:=IntToStr(FAdresa);
    qrTemp.FieldByName('SEC').asInteger:=1;
    qrTemp.FieldByName('KOD').asString:='MOBIL';
    qrTemp.FieldByName('HODNOTA').asString:=edMobil.text;
    qrTemp.post;
    qrTemp.close;
  finally
     qrTemp.free;
     qrTemp:=nil;
  end;

// Email
  if edEmail.text<>'' then
  try
    ExecSqlText('UPDATE SUBJEKTY_SPOJENI SET SEC=0 '+
                ' WHERE KOD=''E-MAIL'' '+
                '   AND SUBJEKT='+IntToStr(fSubjekt)+
                '   AND CISLO_OSOBY='+IntToStr(fOsoba));
    qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_SPOJENI WHERE CISLO='+IntToStr(FEmail),true);
    qrTemp.open;
    if FEmail>0 then
      qrTemp.edit
    else
    begin
      qrTemp.insert;
      FEmail:=SelectInt('SELECT SEQ_SUBJEKTY_SPOJENI_CISLO.NEXTVAL FROM dual');
      qrTemp.FieldByName('SUBJEKT').asInteger:=fSubjekt;
      qrTemp.FieldByName('CISLO').asInteger:=FEmail;
    end;
    qrTemp.FieldByName('CISLO_OSOBY').asString:=IntToStr(FOsoba);
    if FAdresa>0 then
      qrTemp.FieldByName('CISLO_ADRESY').asString:=IntToStr(FAdresa);
    qrTemp.FieldByName('SEC').asInteger:=1;
    qrTemp.FieldByName('KOD').asString:='E-MAIL';
    qrTemp.FieldByName('HODNOTA').asString:=edEmail.text;
    qrTemp.post;
    qrTemp.close;
  finally
     qrTemp.free;
     qrTemp:=nil;
  end;
  if (edTel.text<>'') or (edMobil.text<>'') or (edEmail.text<>'') then
    Aktualizuj_Subjekty_Spojeni(FSubjekt);

  if fSec>0 then
    try
      ExecQuery('INSERT INTO SUBJEKTY_OSOBY_SEC (CISLO_OSOBY, ID_SEC) '+
                ' VALUES ('+Q(IntToStr(FOsoba))+','+Q(IntToStr(fSec))+')');
    except
    end;



  result:=true;
end;


end.
