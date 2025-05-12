unit DSubjektyOsoby;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB, Ora, udmODAC, Mask, NDBCtrls, EditEx, Grids,
  NDBGrids, MSGrid, uMultilanguage, AForm, NotiaMagic, DBCtrls, UCLTypes,
  ComCtrls, Buttons, ToolWin, NotiaControlBar, ActnList, rxToolEdit, MemDS,
  DBAccess, NGrids, RXDBCtrl, NotiaDBComboBox, NotiaComboBox, NotiaImageButton;

type
  TdlgSubjektyOsoby = class(TacForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    btCancel: TButton;
    btOK: TButton;
    pnOsoba: TPanel;
    edJmeno: TEdit;
    Label2: TLabel;
    cbPohlavi: TComboBox;
    Label5: TLabel;
    Label4: TLabel;
    edPrijmeni: TEdit;
    qrOsoby: TOraQuery;
    qrOsobyCISLO_ADRESY: TIntegerField;
    qrOsobyCISLO: TIntegerField;
    qrOsobyPRIJMENI: TWideStringField;
    qrOsobyJMENO: TWideStringField;
    qrOsobyTITUL: TWideStringField;
    qrOsobyFUNKCE: TWideStringField;
    qrOsobyPOZNAMKA: TWideStringField;
    qrOsobyTITUL2: TWideStringField;
    qrOsobyOSLOVENI: TWideStringField;
    qrOsobyPOHLAVI: TSmallintField;
    qrOsobySTAV: TSmallintField;
    qrOsobyHD_USER: TWideStringField;
    qrOsobyCRM_USER: TWideStringField;
    qrOsobyNAZEV_TISK: TWideStringField;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edSubjekt: TEdit;
    Label8: TLabel;
    edRodPrijm: TEdit;
    Label9: TLabel;
    edRC: TEdit;
    qrOsobySUBJEKT: TIntegerField;
    qrOsobyRODNE_PRIJM: TWideStringField;
    qrOsobyDAT_NAROZENI: TDateTimeField;
    qrOsobyMISTO_NAROZENI: TWideStringField;
    qrOsobyRC: TWideStringField;
    edTitul2: TEdit;
    edTitul: TEdit;
    btStat: TButton;
    cbStat: TComboBox;
    qrOsobyST_KOD: TWideStringField;
    qrOsobyCIZINEC_CZ: TSmallintField;
    qrOsobyOSOBA_PRO_WEB: TIntegerField;
    qrOsobyLOGIN_OSOBY: TWideStringField;
    pcDetail: TPageControl;
    tsWEB: TTabSheet;
    tsWebLog: TTabSheet;
    Label10: TLabel;
    ckWeb: TCheckBox;
    edLoginOsoby: TEdit;
    btZmeniOdeslatHeslo: TButton;
    btOdeslatHeslo: TButton;
    qrWebLog: TOraQuery;
    dsWebLog: TOraDataSource;
    grWebLog: TMSDBGrid;
    qrWebLogDATUM: TDateTimeField;
    qrWebLogOSOBA: TIntegerField;
    qrOsobyST_KOD2: TWideStringField;
    btStat2: TButton;
    cbStat2: TComboBox;
    qrOsobyDAT_UMRTI: TDateTimeField;
    qrOsobySTAT_NAROZENI: TWideStringField;
    qrOsobyOKRES_NAROZENI: TWideStringField;
    qrOsobyOBEC_NAROZENI: TWideStringField;
    qrOsobyEMAIL: TWideStringField;
    qrOsobyTEL: TWideStringField;
    qrOsobyMOBIL: TWideStringField;
    qrOsobyADRESA_NAZEV: TWideStringField;
    qrOsobyADRESA_ULICE: TWideStringField;
    qrOsobyADRESA_CP: TWideStringField;
    qrOsobyADRESA_CO: TWideStringField;
    qrOsobyADRESA_MESTO: TWideStringField;
    qrOsobyADRESA_PSC: TWideStringField;
    qrOsobyADRESA_STAT: TWideStringField;
    qrOsobySTATUTAR: TIntegerField;
    qrOsobyPASSWORD_OSOBY: TWideStringField;
    qrOsobyDATOVA_SCHRANKA: TWideStringField;
    qrOsobyOP_PAS: TWideStringField;
    qrOsobyOP_PAS2: TWideStringField;
    qrOsobyAIFO: TWideStringField;
    qrOsobyOP_PAS2_STAT: TWideStringField;
    gbMistoNarozeni: TGroupBox;
    lbNarozeni: TLabel;
    Label17: TLabel;
    cbStatNar: TNotiaComboBox;
    cbOkresNar: TNotiaComboBox;
    btOkresNar: TButton;
    btObecNar: TButton;
    btStatNar: TButton;
    edDatumNar: TDateEdit;
    edUmrti: TDateEdit;
    cbObecNar: TNotiaComboBox;
    edMistoNar: TEdit;
    Label1: TLabel;
    gbSpojeni: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    edMobil: TEdit;
    edTel: TEdit;
    edEmail: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    eddatSchr: TEdit;
    pcAdresy: TPageControl;
    tsAdresa1: TTabSheet;
    Label58: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    cbAdresaStat: TNotiaComboBox;
    btAdresaStat: TButton;
    edAdresaMesto: TEdit;
    edAdresaNazev: TEdit;
    edAdresaUlice: TEdit;
    edAdresaPSC: TEdit;
    edAdresaCP: TEdit;
    edAdresaCO: TEdit;
    btEiD: TNotiaImageButton;
    Label46: TLabel;
    Label47: TLabel;
    edOP_PAS: TEdit;
    edOP_PAS2: TEdit;
    cbPasStat: TComboBox;
    btPasStat: TButton;
    Label18: TLabel;
    edPasPlatnost: TDateEdit;
    tsSubjekt: TTabSheet;
    lbFunkce: TLabel;
    ckStatutar: TCheckBox;
    edFunkce: TEdit;
    mePoznamka: TMemo;
    Label11: TLabel;
    Label12: TLabel;
    edOsloveni: TEdit;
    qrOsobyOP_PAS2_PLATNOST: TDateTimeField;
    lbCislo: TLabel;
    tsInfoSave: TTabSheet;
    Label19: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qrOsobyBeforeOpen(DataSet: TDataSet);
    procedure edPrijmeniExit(Sender: TObject);
    procedure btStatClick(Sender: TObject);
    procedure btZmeniOdeslatHesloClick(Sender: TObject);
    procedure btOdeslatHesloClick(Sender: TObject);
    procedure ckWebClick(Sender: TObject);
    procedure qrWebLogBeforeOpen(DataSet: TDataSet);
    procedure qrOsobyBeforeClose(DataSet: TDataSet);
    procedure qrOsobyAfterOpen(DataSet: TDataSet);
    procedure btStat2Click(Sender: TObject);
    procedure btEiDClick(Sender: TObject);
    procedure btStatNarClick(Sender: TObject);
    procedure btPasStatClick(Sender: TObject);
    procedure btAdresaStatClick(Sender: TObject);
    procedure btObecNarClick(Sender: TObject);
    procedure btOkresNarClick(Sender: TObject);
    procedure btEiDMouseLeave(Sender: TObject);
    procedure btEiDMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    Function UlozitOsobu:Boolean;
    procedure ClearForNew;
    procedure initComboStaty;
    procedure InitOkresyNarCombo;
    procedure InitObceNarCombo;
    Function STAT_Nazev(_KOD:String):String;
    Function STAT_Kod(_Nazev:String):String;
    procedure EiDInit;
  public
    FAIFO:String;
    FSubjekt:String;
    FLocateID:Integer;
    procedure OsobaInit;
  end;

var
  dlgSubjektyOsoby: TdlgSubjektyOsoby;


function dlgSubjektyOsobyExecute(_Subjekt:Integer; _ID:Integer=0; _readonly:boolean=false):Boolean;

implementation

{$R *.DFM}

uses
  Tools, Utils, NConsts,uDMUCL, uStoredProcs, DSubjekty, Queries, Caches, FObce,
  FStaty, uDBUtils, uUCLConsts, FOkresy;

function dlgSubjektyOsobyExecute(_Subjekt:Integer; _ID:Integer=0; _readonly:boolean=false):Boolean;
begin
 result:=False;
 try
    Screen.Cursor := crHourGlass;
    PrepareModal(TdlgSubjektyOsoby, dlgSubjektyOsoby);
    With dlgSubjektyOsoby do
    begin
      FLocateID:=_ID;
      FSubjekt:=IntToStr(_Subjekt);
      result:=Showmodal=mrOk;
    end;
  finally
    Screen.Cursor := crDefault
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.FormCreate(Sender: TObject);
begin
  inherited;
  FSubjekt:='';
  fLocateID:=0;
  initComboStaty;
  InitObceNarCombo;
  InitOkresyNarCombo;

  tsInfoSave.Visible:=False;
  tsInfoSave.TabVisible:=False;
  pcAdresy.ActivePage:=tsAdresa1;
  pcDetail.ActivePage:=tsSubjekt;
  pcDetail.enabled:=true;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.ClearForNew;
var
  i : integer;
begin
  lbCislo.Caption:=' ';
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TEdit then TEdit(Components[i]).Text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
  pcDetail.ActivePage:=tsSubjekt;
  tsInfoSave.Visible:=true;
  tsInfoSave.TabVisible:=true;
  pcDetail.activePage:=tsInfoSave;
  pcDetail.enabled:=false;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.ckWebClick(Sender: TObject);
begin
  inherited;
  if ckWeb.Checked then
  begin
    if edLoginOsoby.text='' then
      edLoginOsoby.text:=SelectStr('SELECT DBMS_RANDOM.string(''x'', 8) FROM DUAL')
  end
  else
    edLoginOsoby.text:='';

  btZmeniOdeslatHeslo.enabled:=GetPermission(perm_fce_sub_zmena_loginu_osoby)
                               and ckWeb.Checked
                               and (FLocateID>0) and (edLoginOsoby.text<>'');
  btOdeslatHeslo.enabled:=btZmeniOdeslatHeslo.enabled;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.EiDInit;
begin
  btEiD.imageIndex:=3;
  if qrOsobyAIFO.isnull then
    btEiD.imageIndex:=1
  else
    btEiD.imageIndex:=2;
  if not btEiD.enabled then
    btEiD.imageIndex:=3;
  btEiD.repaint;
  Case btEiD.imageIndex of
    0:btEiD.hint:='Identita obèana - zmìna údajù';
    1:btEiD.hint:='Identita obèana - nezjištìna';
    2:btEiD.hint:='Identita obèana - ovìøena';
  else
    btEiD.hint:='Identita obèana';
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.OsobaInit;
var
 t:String;
begin
  qrOsoby.Close;
  qrOsoby.Open;

  t:=Stat_Nazev('CZ');
  if not HasData(qrOsoby) then  //Insert
    begin
      Caption:=SetCaption('Nová osoba');
      cbPohlavi.ItemIndex:=0;
      cbStat.ItemIndex:=cbStat.items.IndexOf(t);
      cbStat2.ItemIndex:=-1;
      cbAdresaStat.ItemIndex:=cbAdresaStat.items.IndexOf(t);
      cbPasStat.ItemIndex:=-1;
      cbStatNar.ItemIndex:=cbStatNar.items.IndexOf(t);
      ClearForNew;
      ClientHeight:=pnOsoba.Height+pnBottom.Height;
    end
  else     //update
    begin
      Caption:=SetCaption('Upravit osobu');
      edSubjekt.Text:=qrOsobySUBJEKT.AsString;
      FSubjekt:=edSubjekt.Text;
      lbCislo.Caption:='# '+qrOsobyCISLO.AsString;

      edTitul.text:=qrOsobyTITUL.AsString;
      edTitul2.text:=qrOsobyTITUL2.AsString;
      edJmeno.text:=qrOsobyJMENO.AsString;
      edPrijmeni.text:=qrOsobyPRIJMENI.AsString;
      edRodPrijm.text:=qrOsobyRODNE_PRIJM.AsString;
      cbPohlavi.ItemIndex :=qrOsobyPOHLAVI.asInteger;
      edRC.Text:=qrOsobyRC.asString;
      if qrOsobyST_KOD.AsString<>'' then
        cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev(qrOsobyST_KOD.AsString))
      else
        cbStat.ItemIndex:=cbStat.items.IndexOf(t);
      if qrOsobyST_KOD2.AsString<>'' then
        cbStat2.ItemIndex:=cbStat2.Items.IndexOf(Stat_Nazev(qrOsobyST_KOD2.AsString))
      else
        cbStat2.ItemIndex:=-1;


      edDatumNar.Date:=qrOsobyDAT_NAROZENI.AsDateTime;
      edUmrti.Date:=qrOsobyDAT_UMRTI.AsDateTime;
      if qrOsobySTAT_NAROZENI.AsString<>'' then
        cbStatNar.ItemIndex:=cbStatNar.Items.IndexOf(Stat_Nazev(qrOsobySTAT_NAROZENI.AsString))
      else
        cbStatNar.ItemIndex:=cbStatNar.items.IndexOf(t);

      if qrOsobyOBEC_NAROZENI.AsString<>'' then
        cbObecNar.ItemIndex:=cbObecNar.Items.IndexOf(CachedOBCE(qrOsobyOBEC_NAROZENI.AsString));
      if cbObecNar.Text='' then
        cbObecNar.Text:=qrOsobyOBEC_NAROZENI.AsString;
      if qrOsobyOKRES_NAROZENI.AsString<>'' then
        cbOkresNar.ItemIndex:=cbOkresNar.Items.IndexOf(CachedOKRESY(qrOsobyOKRES_NAROZENI.AsString));
      if cbOkresNar.Text='' then
        cbOkresNar.Text:=qrOsobyOKRES_NAROZENI.AsString;
      edMistoNar.Text:=qrOsobyMISTO_NAROZENI.asString;

      edOP_PAS.Text:=qrOsobyOP_PAS.asString;
      edOP_PAS2.Text:=qrOsobyOP_PAS2.asString;
      edPasPlatnost.Date:=qrOsobyOP_PAS2_PLATNOST.AsDateTime;
      if qrOsobyOP_PAS2_STAT.AsString<>'' then
        cbPasStat.ItemIndex:=cbPasStat.Items.IndexOf(Stat_Nazev(qrOsobyOP_PAS2_STAT.AsString))
      else
        cbPasStat.ItemIndex:=-1;

      edEmail.text:=qrOsobyEMAIL.AsString;
      edTel.text:=qrOsobyTEL.AsString;
      edMobil.text:=qrOsobyMOBIL.AsString;
      edDatSchr.text:=qrOsobyDATOVA_SCHRANKA.AsString;
      edOsloveni.text:=qrOsobyOSLOVENI.AsString;

      edAdresaNazev.text:=qrOsobyADRESA_NAZEV.AsString;
      edAdresaUlice.text:=qrOsobyADRESA_ULICE.AsString;
      edAdresaCP.text:=qrOsobyADRESA_CP.AsString;
      edAdresaCO.text:=qrOsobyADRESA_CO.AsString;
      edAdresaMesto.text:=qrOsobyADRESA_MESTO.AsString;
      edAdresaPSC.text:=qrOsobyADRESA_PSC.AsString;
      if qrOsobyADRESA_STAT.AsString<>'' then
        cbAdresaStat.ItemIndex:=cbAdresaStat.Items.IndexOf(Stat_Nazev(qrOsobyADRESA_STAT.AsString))
      else
        cbAdresaStat.ItemIndex:=cbAdresaStat.items.IndexOf(t);

      mePoznamka.text:=qrOsobyPOZNAMKA.AsString;

      edFunkce.text:=qrOsobyFUNKCE.AsString;
      ckStatutar.Checked:=(qrOsobySTATUTAR.AsInteger = 1);

      if pcDetail.activePage=tsInfoSave then
      begin
        tsInfoSave.Visible:=False;
        tsInfoSave.TabVisible:=False;
        pcDetail.activePage:=tsSubjekt;
      end;
      pcDetail.enabled:=true;
      ckWeb.Checked:=(qrOsobyOSOBA_PRO_WEB.AsInteger = 1);
      edLoginOsoby.text:=qrOsobyLOGIN_OSOBY.AsString;
      ckWebClick(nil);
    end;

  EiDInit;
  edPrijmeniExit(nil);

end;

// ..........................................................................
procedure TdlgSubjektyOsoby.FormShow(Sender: TObject);
begin
  OsobaInit;
  if (MultiLanguage<>nil) then //Multilanguage
    begin
      MultiLanguage.ActivateLanguage(MultiLanguage.LanguageIndex,Self.Name,False);
      MultiLanguage.TranslateComponent(self,self);
    end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.edPrijmeniExit(Sender: TObject);
begin
  inherited;
  btOk.Enabled:=(Trim(edPrijmeni.text)<>'');
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.qrOsobyBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  qrOsoby.ParamByName('CISLO').asInteger:=FLocateID;
end;

// ..........................................................................
function TdlgSubjektyOsoby.UlozitOsobu: Boolean;
var
  cis,i:Integer;
begin
  result:=False;
  try
    qrOsoby.Session.StartTransaction;
    if FLocateID=0 then
      Begin
        qrOsoby.Insert;
        FLocateID:=SelectInt('SELECT SEQ_SUBJEKTY_OSOBY_CISLO.NEXTVAL FROM dual');
        qrOsobyCISLO.AsInteger:=FLocateID;
      end
    else
      begin
        refreshQuery(qrOsoby);
        qrOsoby.Edit;
      end;
    cis:=qrOsobyCISLO.AsInteger;
    qrOsobySUBJEKT.AsString:=FSubjekt;

    qrOsobyTITUL.AsString:=edTitul.Text;
    qrOsobyTITUL2.AsString:=edTitul2.Text;
    qrOsobyJMENO.AsString:=edJmeno.text;
    qrOsobyPRIJMENI.AsString:=edPrijmeni.text;
    qrOsobyRODNE_PRIJM.AsString:=edRodPrijm.text;
    qrOsobyPOHLAVI.asInteger:=cbPohlavi.ItemIndex;
    qrOsobyRC.asString:=edRC.Text;
    qrOsobyST_KOD.asString:=STAT_Kod(cbStat.Text);
    qrOsobyST_KOD2.asString:=STAT_Kod(cbStat2.Text);

    qrOsobyDAT_NAROZENI.AsDateTime:=edDatumNar.Date;

    if edUmrti.Date>1000 then
      qrOsobyDAT_UMRTI.AsDateTime:=edUmrti.Date
    else
      qrOsobyDAT_UMRTI.clear;

    qrOsobySTAT_NAROZENI.asString:=STAT_Kod(cbStatNar.Text);
    qrOsobyOBEC_NAROZENI.AsString:=CachedOBCEnum(cbObecNar.Text);
    if qrOsobyOBEC_NAROZENI.AsString='' then
      qrOsobyOBEC_NAROZENI.AsString:=cbObecNar.text;
    qrOsobyOKRES_NAROZENI.AsString:=CachedOKRESYnum(cbOkresNar.Text);
    if qrOsobyOKRES_NAROZENI.AsString='' then
      qrOsobyOKRES_NAROZENI.AsString:=cbOkresNar.text;
    if qrOsobyOBEC_NAROZENI.AsString+qrOsobyOKRES_NAROZENI.AsString<>'' then
      qrOsobyMISTO_NAROZENI.asString:=cbObecNar.text+', '+cbOkresNar.text;

    qrOsobyOP_PAS.asString:=edOP_PAS.Text;
    qrOsobyOP_PAS2.asString:=edOP_PAS2.Text;
    if edPasPlatnost.date>1000 then
      qrOsobyOP_PAS2_PLATNOST.AsDateTime:=edPasPlatnost.Date
    else
      qrOsobyOP_PAS2_PLATNOST.clear;
    qrOsobyOP_PAS2_STAT.asString:=STAT_Kod(cbPasStat.Text);

    qrOsobyEMAIL.AsString:=edEmail.text;
    qrOsobyTEL.AsString:=edTel.text;
    qrOsobyMOBIL.AsString:=edMobil.text;
    qrOsobyDATOVA_SCHRANKA.AsString:=edDatSchr.text;
    qrOsobyOSLOVENI.AsString:=edOsloveni.text;


    qrOsobyADRESA_NAZEV.AsString:=edAdresaNazev.text;
    qrOsobyADRESA_ULICE.AsString:=edAdresaUlice.text;
    qrOsobyADRESA_CP.AsString:=edAdresaCP.text;
    qrOsobyADRESA_CO.AsString:=edAdresaCO.text;
    qrOsobyADRESA_MESTO.AsString:=edAdresaMesto.text;
    qrOsobyADRESA_PSC.AsString:=edAdresaPSC.text;
    qrOsobyADRESA_STAT.asString:=STAT_Kod(cbAdresaStat.Text);

    qrOsobyPOZNAMKA.AsString:=mePoznamka.text;

    qrOsobySTATUTAR.AsInteger:=Byte(ckSTATUTAR.Checked);
    qrOsobyFUNKCE.AsString:=edFunkce.Text;

    qrOsobyOSOBA_PRO_WEB.AsInteger:=Byte(ckWeb.Checked);
    qrOsobyLOGIN_OSOBY.AsString:=edLoginOsoby.text;

    qrOsoby.post;
    ExecSqlText('UPDATE SUBJEKTY_OSOBY SET '+  // zjebana zmrdka v oracle meni #13#10 na #10#10
                '  POZNAMKA=Replace(POZNAMKA,CHR(10)||CHR(10),CHR(13)||CHR(10)) '+
                ' WHERE CISLO='+IntToStr(cis));
    qrOsoby.Session.Commit;

    result:=True;
  except
    qrOsoby.Session.Rollback;
    raise;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btOKClick(Sender: TObject);
begin
 ModalResult:=mrNone;
 if Not UlozitOsobu then
   EXIT;
 ModalResult:=mrOk;
end;

procedure TdlgSubjektyOsoby.btPasStatClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], initComboStaty);
  try
    FormIOParams.fpSearch := cbPasStat.text<>'';
    FormIOParams.fpSearchFor := STAT_Kod(cbPasStat.text);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbPasStat.ItemIndex:=cbPasStat.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
      edPrijmeniExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.initComboStaty;
var
  t:string;
begin
  t:=Stat_Nazev('CZ');
  InitComboSql(cbStat, QS_Staty_Kod_Combo);
  InitComboSql(cbStat2, QS_Staty_Kod_Combo);
  InitComboSql(cbStatNar, QS_Staty_Kod_Combo);
  InitComboSql(cbPasStat, QS_Staty_Kod_Combo);

  InitComboSql(cbAdresaStat, QS_Staty_Kod_Combo);
//  InitComboSql(cbAdresa2Stat, QS_Staty_Kod_Combo);

  cbStat.ItemIndex:=cbStat.items.IndexOf(t);
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.InitObceNarCombo;
begin
  InitComboSql(cbObecNar, QS_Obce_Nazev_Combo);
  cbObecNar.Items.Add('');
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.InitOkresyNarCombo;
begin
  InitComboSql(cbOkresNar, QS_Okresy_Nazev_Combo);
  cbOkresNar.Items.Add('');
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btStatClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], initComboStaty);
  try
    FormIOParams.fpSearch := cbStat.text<>'';
    FormIOParams.fpSearchFor := STAT_Kod(cbStat.text);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
      edPrijmeniExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

procedure TdlgSubjektyOsoby.btStatNarClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], initComboStaty);
  try
    FormIOParams.fpSearch := cbStatNar.text<>'';
    FormIOParams.fpSearchFor := STAT_Kod(cbStatNar.text);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbStatNar.ItemIndex:=cbStatNar.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
      edPrijmeniExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
function TdlgSubjektyOsoby.STAT_Kod(_Nazev: String): String;
begin
  result:=SelectStr('SELECT KOD FROM ('+QS_Staty_Kod_Combo+') WHERE ROWNUM<2 AND NAZEV_KOD='+Q(_Nazev));
end;

// ..........................................................................
function TdlgSubjektyOsoby.STAT_Nazev(_KOD: String): String;
begin
  result:=SelectStr('SELECT NAZEV_KOD FROM ('+QS_Staty_Kod_Combo+') WHERE ROWNUM<2 AND KOD = '+Q(_KOD))
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btZmeniOdeslatHesloClick(Sender: TObject);
var Heslo, Sablona: String;
    em, sub: String;
    nm: Integer;
begin
// to same je i v okne FSbjekty
  if Not UlozitOsobu then
  begin
    ErrorMsg('Údaje osoby musí být nejdøíve uloženy.');
    EXIT;
  end;

  if Confirm('Opravdu chcete této osobì zmìnit heslo a odeslat pøihlašovací údaje na e-mail?') then
  try
    em:=SelectStr('SELECT GET_SPOJENI_QUICK(null, '+IntToStr(FLocateID)+', 0, 2,1) FROM DUAL');

    if Trim(em)='' then
      ErrorMsg('Tato osoba nemá vyplnìný e-mail!')
    else
    begin
//      Sablona:=SelectStr('SELECT SABLONA FROM WEB_HTML_SABLONY WHERE KOD=''EMAIL_ZMENA_A_ODESLANI_PRIHLASOVACICH_UDAJU_OSOBY''');
      Heslo:=SelectStr('SELECT DBMS_RANDOM.string(''x'', 8) FROM DUAL');
      ExecSqlText('UPDATE SUBJEKTY_OSOBY SET '+
                  '  OSOBA_PRO_WEB=1, '+
                  '  LOGIN_OSOBY='+Q(edLoginOsoby.text)+','+
                  '  PASSWORD_OSOBY='+Q(Heslo)+
                  ' WHERE CISLO='+IntToStr(FLocateID));
      ExecSQLText('begin WEB_Login_odeslat('+IntToStr(FLocateID)+',null,1); end;');
(*
      sub:='Zmìna pøihlašovacích údajù';
      Sablona:=StringReplace(Sablona, '@@NAZEV@@', Trim(edPrijmeni.text+' '+edJmeno.text),[rfReplaceAll, rfIgnoreCase]);
      Sablona:=StringReplace(Sablona, '@@JMENO@@', edLoginOsoby.text,[rfReplaceAll, rfIgnoreCase]);
      Sablona:=StringReplace(Sablona, '@@HESLO@@', Heslo,[rfReplaceAll, rfIgnoreCase]);

//      if GetStringParam('SMTP_SEND_WIN_ORA')='1' then
      begin
        nm:=new_message('NT_INFO', 'EMAIL', sub, Sablona, 0, 1, em, '', '', '');

//        ExecSqlText('begin WEB_ELKOM_RECORD_GETKONTAKT('+IntToStr(nm)+'); end;'); // dotazeni kontaktu dle emailu
        ExecSqlText('UPDATE MESSAGES_QUEUE SET STAV=1 WHERE ID='+IntToStr(nm)); // aktivace zpravy
//      end
//      else
//      begin
//        DMSII.PosliEmail(em, '', '', sub, Sablona, DMSII.FromUser,DMSII.SMTPHost,nil);
      end;
*)
      Inform('Zpráva byla odeslána.');
    end;
  finally
    OsobaInit;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btOdeslatHesloClick(Sender: TObject);
var Heslo, Sablona: String;
    em, sub: String;
    nm: Integer;
begin
  if Not UlozitOsobu then
  begin
    ErrorMsg('Údaje osoby musí být nejdøíve uloženy.');
    EXIT;
  end;

  if Confirm('Opravdu chcete této osobì odeslat pøihlašovací údaje na e-mail?') then
  try
    em:=SelectStr('SELECT GET_SPOJENI_QUICK(null, '+IntToStr(FLocateID)+', 0, 2,1) FROM DUAL');
    Heslo:=SelectStr('SELECT CR_NBS.decryptPassword(PASSWORD_OSOBY) FROM SUBJEKTY_OSOBY WHERE CISLO='+IntToStr(FLocateID));

    if Trim(em)='' then
      ErrorMsg('Tato osoba nemá vyplnìný e-mail!')
    else
    if Trim(Heslo)='' then
      ErrorMsg('Tato osoba nemá vyplnìné heslo!')
    else
    begin
      ExecSqlText('UPDATE SUBJEKTY_OSOBY SET '+
                  '  OSOBA_PRO_WEB=1 '+
                  ' WHERE CISLO='+IntToStr(FLocateID));
      ExecSQLText('begin WEB_Login_odeslat('+IntToStr(FLocateID)+'); end;');
(*
      Sablona:=SelectStr('SELECT SABLONA FROM WEB_HTML_SABLONY WHERE KOD=''EMAIL_ODESLANI_PRIHLASOVACICH_UDAJU_OSOBY''');
      sub:='Pøihlašovací údaje';
      Sablona:=StringReplace(Sablona, '@@JMENO@@', edLoginOsoby.text,[rfReplaceAll, rfIgnoreCase]);
      Sablona:=StringReplace(Sablona, '@@HESLO@@', Heslo,[rfReplaceAll, rfIgnoreCase]);

//      if GetStringParam('SMTP_SEND_WIN_ORA')='1' then
      begin
        nm:=new_message('NT_INFO', 'EMAIL', sub, Sablona, 0, 1, em, '', '', '');

//        ExecSqlText('begin WEB_ELKOM_RECORD_GETKONTAKT('+IntToStr(nm)+'); end;'); // dotazeni kontaktu dle emailu
        ExecSqlText('UPDATE MESSAGES_QUEUE SET STAV=1 WHERE ID='+IntToStr(nm)); // aktivace zpravy
//      end
//      else
//      begin
//        DMSII.PosliEmail(em, '', '', sub, Sablona, DMSII.FromUser,DMSII.SMTPHost,nil);
      end;
*)
      Inform('Zpráva byla odeslána.');
    end;
  finally
    OsobaInit;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.qrWebLogBeforeOpen(DataSet: TDataSet);
begin
  qrWebLog.ParamByName('OSOBA').asInteger:=FLocateID;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.qrOsobyBeforeClose(DataSet: TDataSet);
begin
  inherited;
  qrWebLog.close;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.qrOsobyAfterOpen(DataSet: TDataSet);
begin
  inherited;
  qrWebLog.open;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btStat2Click(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], initComboStaty);
  try
    FormIOParams.fpSearch := cbStat2.text<>'';
    FormIOParams.fpSearchFor := STAT_Kod(cbStat2.text);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbStat2.ItemIndex:=cbStat2.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
      edPrijmeniExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btAdresaStatClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], initComboStaty);
  try
    FormIOParams.fpSearch := cbAdresaStat.text<>'';
    FormIOParams.fpSearchFor := STAT_Kod(cbAdresaStat.text);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbAdresaStat.ItemIndex:=cbAdresaStat.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
      edPrijmeniExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btEiDClick(Sender: TObject);
var
  c:Integer;
  t,tt:String;
begin
  if btEiD.enabled then
    if FAIFO='' then
    begin
      c:=GET_REGISTRY_AIFO(FLocateID, 'SUBJEKTY_OSOBY');
      if c=1 then
      begin
        FAIFO:=SelectStr('SELECT AIFO FROM SUBJEKTY_OSOBY '+
                         ' WHERE CISLO='+IntToStr(FLocateID));
        EiDInit;
        Inform('Došlo k propojení s identitou obèana.')
      end
      else
        begin
          tt:='Propojení s identitou obèana se nepodaøilo.'+EOL;
          t:=SelectStr('SELECT S1 FROM SESSIONID_TEMP WHERE KOD=''INFOHUB'' AND S2=''VysledekKod'' AND SESSIONID=USERENV(''SESSIONID'')');
          if t<>'' then
            tt:=tt+EOL+t;
          t:=SelectStr('SELECT S1 FROM SESSIONID_TEMP WHERE KOD=''INFOHUB'' AND S2=''VysledekSubKod'' AND SESSIONID=USERENV(''SESSIONID'')');
          if t<>'' then
            tt:=tt+EOL+t;
          t:=SelectStr('SELECT S1 FROM SESSIONID_TEMP WHERE KOD=''INFOHUB'' AND S2=''VysledekPopis'' AND SESSIONID=USERENV(''SESSIONID'')');
          if t<>'' then
            tt:=tt+EOL+t;
          ErrorMsg(tt);
         end;
    end
    else
       Inform('Záznam je již propojen s identitou obèana.')
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btEiDMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
  inherited;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btEiDMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if qrOsobyAIFO.isnull then
    Screen.Cursor := crHandPoint;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btObecNarClick(Sender: TObject);
var
  FormIOParams: TfrmObceParams;
begin
  FormIOParams := TfrmObceParams.Create(FOBCE_PFO_KOD, [], InitObceNarCombo );
  try
    FormIOParams.fpSearch :=  cbObecNar.Text <> '' ;
    FormIOParams.fpSearchFor := STAT_Kod(cbObecNar.Text);
    if frmObceExec(FormIOParams, true) then
    begin
      cbObecNar.ItemIndex:=cbObecNar.Items.IndexOf(CachedOBCE(FormIOParams.fpKOD));
      edPrijmeniExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsoby.btOkresNarClick(Sender: TObject);
var
  FormIOParams: TfrmObceParams;
begin
  FormIOParams := TfrmObceParams.Create(FOBCE_PFO_KOD, [], InitObceNarCombo );
  try
    FormIOParams.fpSearch :=  cbOkresNar.Text <> '' ;
    FormIOParams.fpSearchFor := CachedOKRESYnum(cbOkresNar.Text);
    if frmOkresyExec(FormIOParams, true) then
    begin
      cbOkresNar.ItemIndex:=cbOkresNar.Items.IndexOf(CachedOKRESY(FormIOParams.fpKOD));
      edPrijmeniExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

end.

