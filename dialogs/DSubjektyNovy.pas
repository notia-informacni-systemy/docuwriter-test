unit DSubjektyNovy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AForm, NotiaMagic, Vcl.StdCtrls,
  Vcl.ExtCtrls, CheckGroupBox, Vcl.Mask, rxToolEdit, Vcl.Buttons, UCLTypes,
  NotiaSpeedButton, Vcl.DBCtrls, Data.DB, MemDS, DBAccess, Ora, RXDBCtrl,
  Vcl.ComCtrls, Vcl.NGrids, Vcl.NDBGrids, MSGrid;

type
  TdlgSubjektyNovy = class(TacForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    btCancel: TButton;
    btOK: TButton;
    qrSubjekt: TOraQuery;
    qrSubjektID: TIntegerField;
    qrSubjektPLATNY: TIntegerField;
    qrSubjektTZO_ID: TIntegerField;
    qrSubjektZAMESTNANEC: TIntegerField;
    qrSubjektTITUL_PRED: TWideStringField;
    qrSubjektJMENO: TWideStringField;
    qrSubjektPRIJMENI: TWideStringField;
    qrSubjektTITUL_ZA: TWideStringField;
    qrSubjektRC: TWideStringField;
    qrSubjektDAT_NAROZENI: TDateTimeField;
    qrSubjektMISTO_NAROZENI: TWideStringField;
    qrSubjektST_KOD: TWideStringField;
    qrSubjektPOHLAVI: TIntegerField;
    qrSubjektNAZEV: TWideStringField;
    qrSubjektREJCIS: TIntegerField;
    qrSubjektULICE: TWideStringField;
    qrSubjektMESTO: TWideStringField;
    qrSubjektPSC: TWideStringField;
    qrSubjektEMAIL: TWideStringField;
    qrSubjektTEL: TWideStringField;
    qrSubjektMOBIL: TWideStringField;
    qrSubjektFAX: TWideStringField;
    qrSubjektDIC: TWideStringField;
    qrSubjektBANKA: TWideStringField;
    qrSubjektBUCET: TWideStringField;
    qrSubjektNASTUP: TDateTimeField;
    qrSubjektPROPUSTENI: TDateTimeField;
    qrSubjektPROP_DUVOD: TWideStringField;
    qrSubjektPOZNAMKA: TWideStringField;
    qrSubjektPILOT: TIntegerField;
    qrSubjektTECHNIK: TIntegerField;
    qrSubjektSTEVARD: TIntegerField;
    qrSubjektZAK: TIntegerField;
    qrSubjektARCHIVOVAL: TWideStringField;
    qrSubjektARCHIVOVAN: TDateTimeField;
    qrSubjektZAPSAL: TWideStringField;
    qrSubjektZAPSANO: TDateTimeField;
    qrSubjektODD_ID: TIntegerField;
    qrSubjektDOC_ID: TIntegerField;
    qrSubjektAUTOGEN: TIntegerField;
    qrSubjektUDALOST: TWideStringField;
    qrSubjektUSER_ID: TFloatField;
    qrSubjektUSERNAME: TWideStringField;
    qrSubjektSUB_ID_BOSS: TIntegerField;
    qrSubjektSKUPINA: TIntegerField;
    qrSubjektDATUM_ZAPISU_LR: TDateTimeField;
    qrSubjektICO: TWideStringField;
    qrSubjektREJCIS_P: TIntegerField;
    qrSubjektREJCIS_T: TIntegerField;
    qrSubjektPROVOZOVATEL: TIntegerField;
    qrSubjektVYROBCE: TIntegerField;
    qrSubjektVLASTNIK: TIntegerField;
    qrSubjektCISLO_PRUKAZU: TWideStringField;
    qrSubjektUZNANY: TIntegerField;
    qrSubjektSUB_ID_PREDCHUDCE: TIntegerField;
    qrSubjektNABIZET_PRO_PPP: TIntegerField;
    qrSubjektUA_STAV: TIntegerField;
    qrSubjektLETECKA_SKOLA: TIntegerField;
    qrSubjektUDRZBA_JAR: TIntegerField;
    qrSubjektUDRZBA_NARODNI: TIntegerField;
    qrSubjektNAZEV_K_ZOBRAZENI: TWideStringField;
    qrSubjektZASTAVNI_VERITEL: TIntegerField;
    qrSubjektULICE_POD: TWideStringField;
    qrSubjektMESTO_POD: TWideStringField;
    qrSubjektPSC_POD: TWideStringField;
    qrSubjektSTAT_POD: TWideStringField;
    qrSubjektZKRATKA: TWideStringField;
    qrSubjektICO_OR: TWideStringField;
    qrSubjektSIDLO_OR: TWideStringField;
    qrSubjektSTAT: TWideStringField;
    qrSubjektLETADLOVA_ADRESA: TIntegerField;
    qrSubjektRODNE_PRIJM: TWideStringField;
    qrSubjektSUB_PRO_POPLATKY: TIntegerField;
    qrSubjektUSER_PRINTDOC_PATH: TWideStringField;
    qrSubjektINSTRUKTOR_PILOTU: TIntegerField;
    qrSubjektINSTRUKTOR_TECHNIKU: TIntegerField;
    qrSubjektEXAMINATOR: TIntegerField;
    qrSubjektLEKTOR: TIntegerField;
    qrSubjektPRACOVNI_POZICE: TWideStringField;
    qrSubjektSKUPINA_OOPP: TWideStringField;
    qrSubjektSTEJNOKROJ: TWideStringField;
    qrSubjektCIP: TWideStringField;
    qrSubjektTEMP_CLEAR: TIntegerField;
    qrSubjektDATUM_NAROKU_STEJNOKROJE: TDateTimeField;
    qrSubjektDATUM_NAROKU_OOPP: TDateTimeField;
    qrSubjektPARAGAN: TIntegerField;
    qrSubjektZMENENO: TDateTimeField;
    qrSubjektZMENIL: TWideStringField;
    qrSubjektTECHNIK_PARA: TIntegerField;
    qrSubjektST_KOD2: TWideStringField;
    qrSubjektDATOVA_SCHRANKA: TWideStringField;
    qrSubjektDAT_VZNIKU: TDateTimeField;
    qrSubjektDAT_UMRTI: TDateTimeField;
    qrSubjektOP_PAS: TWideStringField;
    qrSubjektOP_PAS2: TWideStringField;
    qrSubjektPRAVNI_FORMA: TWideStringField;
    qrSubjektOBSLUHA_CFME: TIntegerField;
    qrSubjektREJCIS_CFME: TIntegerField;
    qrSubjektSTATNI_SPRAVA: TIntegerField;
    qrSubjektCR_MODIFY: TDateTimeField;
    qrSubjektORGAN_SLOZKA: TWideStringField;
    qrSubjektESSL_HYBRID: TIntegerField;
    qrSubjektPOZNAMKA_ODBORNOST: TWideStringField;
    qrSubjektPOZNAMKA_INTERNI: TWideStringField;
    qrOsoba: TOraQuery;
    qrOsobaSUBJEKT: TIntegerField;
    qrOsobaCISLO_ADRESY: TIntegerField;
    qrOsobaCISLO: TIntegerField;
    qrOsobaPRIJMENI: TWideStringField;
    qrOsobaJMENO: TWideStringField;
    qrOsobaTITUL: TWideStringField;
    qrOsobaFUNKCE: TWideStringField;
    qrOsobaPOZNAMKA: TWideStringField;
    qrOsobaVYCHOZI: TIntegerField;
    qrOsobaFAKTURACE: TIntegerField;
    qrOsobaTITUL2: TWideStringField;
    qrOsobaOSLOVENI: TWideStringField;
    qrOsobaPOHLAVI: TIntegerField;
    qrOsobaSTAV: TIntegerField;
    qrOsobaHD_USER: TWideStringField;
    qrOsobaCRM_USER: TWideStringField;
    qrOsobaNAZEV_TISK: TWideStringField;
    qrOsobaRODNE_PRIJM: TWideStringField;
    qrOsobaDAT_NAROZENI: TDateTimeField;
    qrOsobaMISTO_NAROZENI: TWideStringField;
    qrOsobaRC: TWideStringField;
    qrOsobaREF_ID: TIntegerField;
    qrOsobaST_KOD: TWideStringField;
    qrOsobaSTAT_NAROZENI: TWideStringField;
    qrOsobaOKRES_NAROZENI: TWideStringField;
    qrOsobaOBEC_NAROZENI: TWideStringField;
    qrOsobaCIZINEC_CZ: TIntegerField;
    qrOsobaOSOBA_PRO_WEB: TIntegerField;
    qrOsobaLOGIN_OSOBY: TWideStringField;
    qrOsobaPASSWORD_OSOBY: TWideStringField;
    qrOsobaZMENENO: TDateTimeField;
    qrOsobaZMENIL: TWideStringField;
    qrOsobaST_KOD2: TWideStringField;
    qrOsobaDATOVA_SCHRANKA: TWideStringField;
    qrOsobaDAT_UMRTI: TDateTimeField;
    qrOsobaOP_PAS: TWideStringField;
    qrOsobaOP_PAS2: TWideStringField;
    qrOsobaCR_MODIFY: TDateTimeField;
    qrOsobaTYP_SEC: TWideStringField;
    qrAdresa: TOraQuery;
    qrAdresaSUBJEKT: TIntegerField;
    qrAdresaCISLO: TIntegerField;
    qrAdresaNAZEV_ADRESY: TWideStringField;
    qrAdresaULICE: TWideStringField;
    qrAdresaMESTO: TWideStringField;
    qrAdresaPSC: TWideStringField;
    qrAdresaSTAT: TWideStringField;
    qrAdresaSIDLO: TIntegerField;
    qrAdresaPOBOCKA: TIntegerField;
    qrAdresaDOPRAVA: TIntegerField;
    qrAdresaFAKTURACE: TIntegerField;
    qrAdresaVYCHOZI: TIntegerField;
    qrAdresaNAZEV_ADRESY_2: TWideStringField;
    qrAdresaPOTVRZENI_OBJP: TIntegerField;
    qrAdresaTISK_NAZEV2: TIntegerField;
    qrAdresaPOPIS: TWideStringField;
    qrAdresaEAN: TWideStringField;
    qrAdresaOBJEKT: TWideStringField;
    qrAdresaPRODEJCE: TWideStringField;
    qrAdresaZMENENO: TDateTimeField;
    qrAdresaZMENIL: TWideStringField;
    qrAdresaCR_MODIFY: TDateTimeField;
    qrAdresaSEC: TIntegerField;
    mePoznamka: TMemo;
    lbPoznamka: TLabel;
    qrSpojeni: TOraQuery;
    qrSpojeniSUBJEKT: TIntegerField;
    qrSpojeniCISLO: TIntegerField;
    qrSpojeniKOD: TWideStringField;
    qrSpojeniCISLO_ADRESY: TIntegerField;
    qrSpojeniCISLO_OSOBY: TIntegerField;
    qrSpojeniHODNOTA: TWideStringField;
    qrSpojeniSORT: TIntegerField;
    qrSpojeniPROVAZAT_S_ADRESOU: TIntegerField;
    qrSpojeniZMENENO: TDateTimeField;
    qrSpojeniZMENIL: TWideStringField;
    qrSpojeniSEC: TIntegerField;
    pcOsoba: TPageControl;
    tsOsoba: TTabSheet;
    tsOsobyNext: TTabSheet;
    gbFyzicka: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    lbDatum: TLabel;
    Label9: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    sbInfoHubNovyOsoba: TNotiaSpeedButton;
    Label47: TLabel;
    Label46: TLabel;
    Label18: TLabel;
    edJmeno: TEdit;
    cbPohlavi: TComboBox;
    edPrijmeni: TEdit;
    edRodPrijm: TEdit;
    edOsloveni: TEdit;
    edDatumNar: TDateEdit;
    edRC: TEdit;
    edTitul2: TEdit;
    edTitul: TEdit;
    edOP_PAS: TEdit;
    edOP_PAS2: TEdit;
    cbSTKod: TComboBox;
    btSTKod: TButton;
    btSTKod2: TButton;
    cbSTKod2: TComboBox;
    edMistoNar: TEdit;
    pcSubjekt: TPageControl;
    tsSubjekt: TTabSheet;
    pcAdresa: TPageControl;
    tsAdresa: TTabSheet;
    tsAdresyNext: TTabSheet;
    gbAdresa: TGroupBox;
    Label1: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    edNazevAdresy: TEdit;
    edNazevAdresy2: TEdit;
    edUlice: TEdit;
    edMesto: TEdit;
    edPSC: TEdit;
    btStat: TButton;
    cbStat: TComboBox;
    edObjekt: TEdit;
    ckSidloAdresa: TCheckBox;
    ckVychoziAdresa: TCheckBox;
    pcSpojeni: TPageControl;
    tsSpojeni: TTabSheet;
    GroupBox1: TGroupBox;
    Label15: TLabel;
    Label14: TLabel;
    Label13: TLabel;
    Label45: TLabel;
    lbBankovniUcet: TLabel;
    edMobil: TEdit;
    edEmail: TEdit;
    edTel: TEdit;
    edDatSchr: TEdit;
    edBankovniUcet: TEdit;
    edBanka: TEdit;
    qrOsoby: TOraQuery;
    qrOsobyTITUL: TWideStringField;
    qrOsobyFUNKCE: TWideStringField;
    qrOsobyPOZNAMKA: TWideStringField;
    qrOsobyVYCHOZI: TSmallintField;
    qrOsobyFAKTURACE: TSmallintField;
    qrOsobyPRIJMENI: TWideStringField;
    qrOsobyJMENO: TWideStringField;
    qrOsobyTITUL2: TWideStringField;
    qrOsobyOSLOVENI: TWideStringField;
    qrOsobyPOHLAVI: TSmallintField;
    qrOsobyHD_USER: TWideStringField;
    qrOsobyCISLO_ADRESY: TIntegerField;
    qrOsobyCISLO: TIntegerField;
    qrOsobySTAV: TSmallintField;
    qrOsobyRODNE_PRIJM: TWideStringField;
    qrOsobyMISTO_NAROZENI: TWideStringField;
    qrOsobyRC: TWideStringField;
    qrOsobyST_KOD: TWideStringField;
    qrOsobySUBJEKT: TIntegerField;
    qrOsobyCRM_USER: TWideStringField;
    qrOsobyNAZEV_TISK: TWideStringField;
    qrOsobyDAT_NAROZENI: TDateTimeField;
    qrOsobyREF_ID: TIntegerField;
    qrOsobySTAT_NAROZENI: TWideStringField;
    qrOsobyOKRES_NAROZENI: TWideStringField;
    qrOsobyOBEC_NAROZENI: TWideStringField;
    qrOsobyOSOBA_PRO_WEB: TIntegerField;
    qrOsobyLOGIN_OSOBY: TWideStringField;
    qrOsobyDAT_UMRTI: TDateTimeField;
    dsOsoby: TOraDataSource;
    qrAdresy: TOraQuery;
    qrAdresyULICE: TWideStringField;
    qrAdresyMESTO: TWideStringField;
    qrAdresyPSC: TWideStringField;
    qrAdresySTAT: TWideStringField;
    qrAdresySIDLO: TSmallintField;
    qrAdresyPOBOCKA: TSmallintField;
    qrAdresyDOPRAVA: TSmallintField;
    qrAdresyFAKTURACE: TSmallintField;
    qrAdresyNAZEV_ADRESY: TWideStringField;
    qrAdresyVYCHOZI: TSmallintField;
    qrAdresyNAZEV_ADRESY_2: TWideStringField;
    qrAdresyPOTVRZENI_OBJP: TSmallintField;
    qrAdresyTISK_NAZEV2: TSmallintField;
    qrAdresyCISLO: TIntegerField;
    dsAdresy: TOraDataSource;
    Panel17: TPanel;
    Panel18: TPanel;
    NavigatorOsoby: TDBNavigator;
    Panel9: TPanel;
    Panel12: TPanel;
    NavigatorAdresy: TDBNavigator;
    grAdresy: TMSDBGrid;
    Panel1: TPanel;
    gbPravnicka: TCheckGroupBox;
    sbInfoHubNovyICO: TNotiaSpeedButton;
    lbNazevPravOsoby: TLabel;
    lbDic: TLabel;
    lbICO_OR: TLabel;
    lbSidlo_OR: TLabel;
    lbZkratka: TLabel;
    Label42: TLabel;
    Label50: TLabel;
    lbICO: TLabel;
    Label43: TLabel;
    edNazevPravOsoby: TEdit;
    edDic: TEdit;
    edICO_OR: TEdit;
    edSidloOR: TEdit;
    edZkratka: TEdit;
    edPravForma: TEdit;
    edOrgSlozka: TEdit;
    edICO: TEdit;
    edDatVzniku: TDateEdit;
    grOsoby: TMSDBGrid;
    sbAres: TNotiaSpeedButton;
    lbDuplicitaOsoby: TLabel;
    lbDuplicitaSubjektu: TLabel;
    ckVychoziOsoba: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure sbInfoHubNovyICOClick(Sender: TObject);
    procedure gbPravnickaCheckBoxClick(Sender: TObject);
    procedure sbInfoHubNovyOsobaClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure qrSubjektBeforeOpen(DataSet: TDataSet);
    procedure qrOsobaBeforeOpen(DataSet: TDataSet);
    procedure qrAdresaBeforeOpen(DataSet: TDataSet);
    procedure qrSpojeniBeforeOpen(DataSet: TDataSet);
    procedure btSTKodClick(Sender: TObject);
    procedure btSTKod2Click(Sender: TObject);
    procedure btStatClick(Sender: TObject);
    procedure qrOsobyBeforeOpen(DataSet: TDataSet);
    procedure qrAdresyBeforeOpen(DataSet: TDataSet);
    procedure pcOsobaChange(Sender: TObject);
    procedure pcAdresaChange(Sender: TObject);
    procedure qrSubjektNewRecord(DataSet: TDataSet);
    procedure sbAresClick(Sender: TObject);
    procedure edPrijmeniExit(Sender: TObject);
    procedure edICOExit(Sender: TObject);
    procedure edNazevPravOsobyExit(Sender: TObject);
  private
    FyzPrav_Changed:Boolean;
    Function UlozitSubjekt:Boolean;
    Function UlozitOsobu:Boolean;
    Function UlozitAdresu:Boolean;
    Function UlozitSpojeni:Boolean;
    procedure ClearForNew;
    procedure initComboStaty;
    procedure LoadData(_Pravnicka:Boolean);
    procedure LoadDataSpojeni;
    Function STAT_Nazev(_KOD:String):String;
    Function STAT_Kod(_Nazev:String):String;
    function Get_ARES(aICO : String) : boolean;
  public
    FFixId:Integer; // docasne ID subjektu
    FICO:String;
    FSubID:Integer;
    FAdresaID:Integer;
    FOsobaID:Integer;

    FARES_ErrMsg, FARES_ObchodniFirma, FARES_NazevOkresu, FARES_NazevObce, FARES_NazevCastiObce, FARES_NazevMestskeCasti,
    FARES_NazevUlice, FARES_CisloDomovni, FARES_CisloOrientacni, FARES_PSC, FARES_PriznakySubjektu, FARES_DIC : String;
    FARES_OR, FARES_RES, FARES_ZR, FARES_DPH, FARES_SD, FARES_Konkurz, FARES_Vyrovnani, FARES_ISIR : Integer;
    function KontrolaDuplicity(_warn:Boolean): Boolean;
  end;

var
  dlgSubjektyNovy: TdlgSubjektyNovy;

function dlgSubjektyNovyExecute:Integer;

implementation

{$R *.dfm}

uses
  Tools, Utils, NConsts,uDMUCL, uStoredProcs, FAdresy, DSubjekty, Queries,
  FStaty, uDBUtils, uUCLConsts, FInfohub, Caches;

function dlgSubjektyNovyExecute:Integer;
begin
 result:=0;
 try
    Screen.Cursor := crHourGlass;
    if assigned(dlgSubjektyNovy) then
    begin
      dlgSubjektyNovy.free;
      dlgSubjektyNovy:=nil;
    end;
    PrepareModal(TdlgSubjektyNovy, dlgSubjektyNovy);
    With DlgSubjektyNovy do
    begin
      Screen.Cursor := crDefault;
      if Showmodal=mrOk then
        result:=FSubID;
    end;
  finally
    Screen.Cursor := crDefault
  end;
end;

{ TdlgSubjektyNovy }
// ..........................................................................
procedure TdlgSubjektyNovy.FormCreate(Sender: TObject);
begin
  FFixId:=0;
  inherited;
  ClearForNew;
  pcOsoba.activepageIndex:=0;
  pcAdresa.activepageIndex:=0;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.FormShow(Sender: TObject);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgSubjektyNovy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ExecQuery('DELETE FROM SUBJEKTY WHERE ID='+Q(IntToStr(FFixId)));
  qrSubjekt.close;
  qrOsoba.close;
  qrOsoby.close;
  qrAdresa.close;
  qrAdresy.close;
  qrSpojeni.close;
  inherited;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.gbPravnickaCheckBoxClick(Sender: TObject);
begin
  try
    if gbPravnicka.checked then
    begin
      tsOsoba.caption :=' Kontaktní osoba ';
      ckSidloAdresa.Caption:=' Sídlo ';
      ckVychoziOsoba.checked:=false;
    end
    else
    begin
      tsOsoba.caption :=' Fyzická osoba ';
      ckSidloAdresa.Caption:=' Sídlo - trvalý pobyt ';
      ckVychoziOsoba.checked:=true;
    end
  finally
    edICOExit(nil);
  end;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.ClearForNew;
var
  i:Integer;
  t:String;
begin
  t:='9'+Copy(GetSessionid,1,8);
//  t:='999999999';
  FFixId:=StrToInt(t);
  ExecQuery('DELETE FROM SUBJEKTY WHERE ID='+Q(IntToStr(FFixId)));
  FSubID:=0;
  FAdresaID:=0;
  FOsobaID:=0;
  FICO:='';
  gbPravnicka.checked:=False;
  tsOsoba.caption :=' Fyzická osoba ';
  lbDuplicitaOsoby.visible:=false;
  lbDuplicitaSubjektu.visible:=false;
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TEdit then TEdit(Components[i]).Text:='';
    if Components[i] is TMemo then TMemo(Components[i]).Text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
  initComboStaty;
  cbPohlavi.ItemIndex:=0;
  ckSidloAdresa.checked:=true;
  ckVychoziAdresa.checked:=true;
  ckVychoziOsoba.checked:=true;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.edICOExit(Sender: TObject);
begin
  edNazevPravOsobyExit(nil);
  edPrijmeniExit(nil);
end;

// ..........................................................................
procedure TdlgSubjektyNovy.edNazevPravOsobyExit(Sender: TObject);
begin
  inherited;
  lbDuplicitaSubjektu.visible:=false;
  if gbPravnicka.checked and (trim(edICO.text)='') and (activeControl.name<>'') then
  begin
    ErrorMsg('Právnická osoba musí mít vyplnìno IÈO.');
    ActiveControl:=edICO;
    EXIT;
  end;
  if edICO.text<>'' then
    lbDuplicitaSubjektu.visible:=SelectInt('Select count(*) from subjekty '+
                                           ' where ICO is not null '+
                                           '   and Replace(ICO,'' '','''')=Replace('+Q(edICO.text)+','' '','''')')>0;
  if (edNazevPravOsoby.text<>'') and not lbDuplicitaSubjektu.visible then
    lbDuplicitaSubjektu.visible:=SelectInt('Select count(*) from subjekty '+
                                           ' where NAZEV is not null '+
                                           '   and GETPACKSTRING(NAZEV)=GETPACKSTRING('+Q(edNazevPravOsoby.text)+')')>0;
  if lbDuplicitaSubjektu.visible then
    beep;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.edPrijmeniExit(Sender: TObject);
begin
  lbDuplicitaOsoby.visible:=false;
  if gbPravnicka.checked then
    EXIT;

  if (edJmeno.text<>'') and (edPrijmeni.text<>'') and (edDatumNar.Date>0) then
  begin
    lbDuplicitaOsoby.visible:=SelectInt('Select count(*) from subjekty '+
                                           ' where ICO is null '+
                                           '   and GETPACKSTRING(PRIJMENI)=GETPACKSTRING('+Q(edPrijmeni.text)+') '+
                                           '   and GETPACKSTRING(JMENO)=GETPACKSTRING('+Q(edJmeno.text)+') '+
                                           '   and TO_CHAR(DAT_NAROZENI,''YYYY-MM-DD'')='+Q((FormatDateTime('YYYY-MM-DD',edDatumNar.Date))))>0;
  end;
  if lbDuplicitaOsoby.visible then
    beep;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.initComboStaty;
begin
  InitComboSql(cbStat, QS_Staty_Kod_Combo);
  cbSTKod.items.assign(cbStat.items);
  cbSTKod2.items.assign(cbStat.items);
  cbStat.ItemIndex:=cbStat.items.IndexOf('Èeská republika');
  cbSTKod.ItemIndex:=cbStat.items.IndexOf('Èeská republika');
  cbSTKod2.ItemIndex:=-1
end;

// ..........................................................................
procedure TdlgSubjektyNovy.btCancelClick(Sender: TObject);
begin
  ExecQuery('DELETE FROM SUBJEKTY WHERE ID='+Q(IntToStr(FFixId)));
  inherited;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.btOKClick(Sender: TObject);
begin
 ModalResult:=mrNone;
 if Not UlozitSubjekt then
   EXIT;
 ExecQuery('DELETE FROM SUBJEKTY WHERE ID='+Q(IntToStr(FFixId)));
 ModalResult:=mrOk;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.btStatClick(Sender: TObject);
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
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.btSTKod2Click(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], initComboStaty);
  try
    FormIOParams.fpSearch := cbSTKod2.text<>'';
    FormIOParams.fpSearchFor := STAT_Kod(cbSTKod2.text);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbSTKod2.ItemIndex:=cbSTKod2.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.btSTKodClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], initComboStaty);
  try
    FormIOParams.fpSearch := cbSTKod.text<>'';
    FormIOParams.fpSearchFor := STAT_Kod(cbSTKod.text);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbSTKod.ItemIndex:=cbSTKod.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
function TdlgSubjektyNovy.KontrolaDuplicity(_warn:Boolean): Boolean;
var
  s:String;
begin
  result:=false;
  if gbPravnicka.checked then
  begin
    FICO:=StringReplace(edICO.text,' ','',[rfReplaceAll]);
    if (FICO<>'') then
    begin
      s:=SelectStr('SELECT max(ID) FROM SUBJEKTY '+
                   ' WHERE replace(ICO,'' '','''')='+Q(FICO)+
                   '   AND ID<>'+Q(IntToStr(FFixID)));
      if s<>'' then
      begin
        s:=SelectStr('SELECT NAZEV_K_ZOBRAZENI FROM SUBJEKTY WHERE ID='+Q(s));
        ErrorMsg('Subjekt dle IÈO již existuje. '+EOL+s);
        EXIT;
      end;
    end;
    if _warn then
    begin
      if edNazevPravOsoby.text<>'' then
      begin
        s:=SelectStr('SELECT max(ID) FROM SUBJEKTY '+
                     ' WHERE NVL(UPPER(NAZEV),''##$$@@'')=NVL(UPPER('+Q(edNazevPravOsoby.text)+'),''##$$@@'') '+
                     '   AND ID<>'+Q(IntToStr(FFixID)));
        if s<>'' then
        begin
         s:=SelectStr('SELECT NAZEV_K_ZOBRAZENI FROM SUBJEKTY WHERE ID='+Q(s));
         if not warnCancel('Tento název subjektu již existuje u subjektu '+EOL+Q(s)+' '+EOL+'Pokraèovat?') then
            EXIT;
        end;
      end;
    end;
  end
  else
  begin
    if (edPrijmeni.text<>'') and (edJmeno.text<>'') and (edDatumNar.date>(now-37000))  then
    begin
      s:=SelectStr(Format('SELECT max(ID) FROM SUBJEKTY '+
                          ' WHERE NVL(UPPER(JMENO),''##$$@@'')=NVL(UPPER(%s),''##$$@@'') '+
                          '   AND NVL(UPPER(PRIJMENI),''##$$@@'')=NVL(UPPER(%s),''##$$@@'') '+
                          '   AND NVL(TRUNC(DAT_NAROZENI),TRUNC(SYSDATE))=NVL(TO_DATE(%s,''DD.MM.YYYY''),TRUNC(SYSDATE)) '+
                          '   AND ID<>'+Q(IntToStr(FFixID)),
                        [Q(edJmeno.text),Q(edPrijmeni.text),Q(FormatDateTime('DD.MM.YYYY',edDatumNar.date))]));
      if s<>'' then
      begin
        s:=SelectStr('SELECT NAZEV_K_ZOBRAZENI FROM SUBJEKTY WHERE ID='+Q(s));
        ErrorMsg('Tato osoba (Jméno, Pøíjmení, Dat.narození) již jako subjekt existuje. '+EOL+s);
        EXIT;
      end;

      if _warn then
      begin
        s:=SelectStr(Format('SELECT max(SUBJEKT) FROM SUBJEKTY_OSOBY '+
                            ' WHERE NVL(UPPER(JMENO),''##$$@@'')=NVL(UPPER(%s),''##$$@@'') '+
                            '   AND NVL(UPPER(PRIJMENI),''##$$@@'')=NVL(UPPER(%s),''##$$@@'') '+
                            '   AND NVL(TRUNC(DAT_NAROZENI),TRUNC(SYSDATE))=NVL(TO_DATE(%s,''DD.MM.YYYY''),TRUNC(SYSDATE)) '+
                            '   AND ID<>'+Q(IntToStr(FFixID)),
                           [Q(edJmeno.text),Q(edPrijmeni.text),
                            Q(FormatDateTime('DD.MM.YYYY',edDatumNar.date))]));
        if s<>'' then
        begin
          s:=SelectStr('SELECT NAZEV_K_ZOBRAZENI FROM SUBJEKTY WHERE ID='+Q(s));
          if not warnCancel('Tato osoba (Jméno, Pøíjmení, Dat.narození) již existuje u subjektu '+Q(s)+'. '+EOL+'Pokraèovat?') then
            EXIT;
        end;
      end;
    end;
  end;

  if (edMobil.text<>'') and (SelectInt('SELECT validace_telcislo('+Q(edMobil.text)+') FROM DUAL')=0) then
  begin
    ErrorMsg('Hodnota v poli Mobil není správná.'+EOL+
             'Opravte ji nebo odstraòte.');
    ActiveControl:=edMobil;
    EXIT;
  end;
  if (edTel.text<>'') and (SelectInt('SELECT validace_telcislo('+Q(edTel.text)+') FROM DUAL')=0) then
  begin
    ErrorMsg('Hodnota v poli Telefon není správná.'+EOL+
             'Opravte ji nebo odstraòte.');
    ActiveControl:=edTel;
    EXIT;
  end;
  if (edEmail.text<>'') and (SelectInt('SELECT validace_emailadr('+Q(edEmail.text)+') FROM DUAL')=0) then
  begin
    ErrorMsg('Hodnota v poli E-mail není správná.'+EOL+
             'Opravte ji nebo odstraòte.');
    ActiveControl:=edEmail;
    EXIT;
  end;

  result:=true;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.qrAdresaBeforeOpen(DataSet: TDataSet);
begin
  qrAdresa.ParamByName('ID').asInteger:=FFixId;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.qrAdresyBeforeOpen(DataSet: TDataSet);
begin
  qrAdresy.ParamByName('ID').asInteger:=FFixId;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.pcAdresaChange(Sender: TObject);
begin
  qrAdresy.active:=pcAdresa.activePage=tsAdresyNext;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.qrOsobaBeforeOpen(DataSet: TDataSet);
begin
  qrOsoba.ParamByName('ID').asInteger:=FFixId;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.qrOsobyBeforeOpen(DataSet: TDataSet);
begin
  qrOsoby.ParamByName('ID').asInteger:=FFixId;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.pcOsobaChange(Sender: TObject);
begin
  qrOsoby.active:=pcOsoba.activePage=tsOsobyNext;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.qrSpojeniBeforeOpen(DataSet: TDataSet);
begin
  qrSpojeni.ParamByName('ID').asInteger:=FFixId;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.qrSubjektBeforeOpen(DataSet: TDataSet);
begin
  qrSubjekt.ParamByName('ID').asInteger:=FFixId;
end;

// ..........................................................................
procedure TdlgSubjektyNovy.qrSubjektNewRecord(DataSet: TDataSet);
begin
// jako v subjektech
  qrSubjektZAMESTNANEC.AsInteger:=0;
  qrSubjektPLATNY.AsInteger := 1;
  qrSubjektZAK.AsInteger := 0;
  qrSubjektPILOT.AsInteger := 0;
  qrSubjektAUTOGEN.AsInteger := 0;
  qrSubjektSTEVARD.AsInteger := 0;
  qrSubjektSKUPINA.AsInteger := 0;
  qrSubjektTechnik.AsInteger:=0;
  qrSubjektPROVOZOVATEL.AsInteger:=0;
  qrSubjektVYROBCE.AsInteger:=0;
  qrSubjektVLASTNIK.AsInteger:=0;
  qrSubjektUZNANY.AsInteger:=0;
  qrSubjektNABIZET_PRO_PPP.AsInteger:=0;
  qrSubjektLETECKA_SKOLA.AsInteger:=0;
  qrSubjektUDRZBA_JAR.AsInteger:=0;
  qrSubjektUDRZBA_NARODNI.AsInteger:=0;
  qrSubjektZASTAVNI_VERITEL.AsInteger:=0;
  qrSubjektINSTRUKTOR_PILOTU.AsInteger:=0;
  qrSubjektINSTRUKTOR_TECHNIKU.AsInteger:=0;
  qrSubjektEXAMINATOR.AsInteger:=0;
  qrSubjektLEKTOR.AsInteger:=0;
  qrSubjektPARAGAN.AsInteger:=0;
  qrSubjektTECHNIK_PARA.AsInteger:=0;
  qrSubjektOBSLUHA_CFME.AsInteger:=0;
  qrSubjektST_KOD.AsString:='CZ';
end;

// ..........................................................................
function TdlgSubjektyNovy.Get_ARES(aICO: String): boolean;
var
  i:integer;
begin
  result:=ARES_NBS(aICO,
       FARES_ErrMsg, FARES_ObchodniFirma, FARES_NazevOkresu, FARES_NazevObce, FARES_NazevCastiObce, FARES_NazevMestskeCasti,
       FARES_NazevUlice, FARES_CisloDomovni, FARES_CisloOrientacni, FARES_PSC, FARES_PriznakySubjektu,
       FARES_OR, FARES_RES, FARES_ZR, FARES_DPH, FARES_SD, FARES_Konkurz, FARES_Vyrovnani, FARES_ISIR, FARES_DIC)=0;
  if not result then
    ErrorMsg(FARES_ErrMsg);
end;

// ..........................................................................
procedure TdlgSubjektyNovy.sbAresClick(Sender: TObject);
begin
  if not KontrolaDuplicity(true) then
    EXIT;
  if length(trim(FICO))<6 then
    begin
      ErrorMsg('Zadejte IÈO. '+EOL+'IÈO musí mít min. 6 znakù.');
      EXIT;
    end;

  if not Get_ARES(FICO) then
    EXIT;
   if edDIC.text='' then
     edDIC.text:=FARES_DIC;
   if edNazevPravOsoby.text='' then
     edNazevPravOsoby.text:=FARES_ObchodniFirma;

   if edUlice.text='' then
      edUlice.text:=FARES_NazevUlice+' '+FARES_CisloDomovni+'/'+FARES_CisloOrientacni;
   if edMesto.text='' then
      edMesto.text:=FARES_NazevObce;
   if edPSC.text='' then
      edPSC.text:=FARES_PSC;
end;

procedure TdlgSubjektyNovy.sbInfoHubNovyICOClick(Sender: TObject);
var
  i:integer;
begin
  if not KontrolaDuplicity(true) then
    EXIT;
  if length(trim(FICO))<6 then
    begin
      ErrorMsg('Zadejte IÈO. '+EOL+'IÈO musí mít min. 6 znakù.');
      EXIT;
    end;
// podobne jako v subjektech
  PrepareForm(TfrmInfohub,frmInfohub);
  frmInfohub.Init;

  frmInfohub.Firma:=true;
  frmInfohub.btTest.tag:=1;
  frmInfohub.btTestClick(nil);

  frmInfohub.edICO.text:=FICO;
  frmInfohub.edICOChange(nil);

  frmInfohub.agenda:='SUBJEKTY';
  frmInfohub.RegistryLoadFirma;


  i:=SelectInt('Select max(id) from zurnal '+
               ' where typ=''SZR'' and NOVA_HODNOTA=''Firma'' '+
               '  and zapsano>(sysdate-0.0007) '+ // as minuta
               '  and zapsal=user');
  if (i>0)  then
  begin
    frmInfohub.meResjtrikDataOut.text:=SelectStr('SELECT POPIS FROM ZURNAL WHERE ID='+IntToStr(i));
    frmInfohub.meResjtrikDataIn.text:=SelectStr('SELECT TEXT FROM ZURNAL WHERE ID='+IntToStr(i));
  end;

//  if not Registry_Parse_Data(1,frmInfohub.meResjtrikDataIn.text,-1,0) then
//    EXIT;

  frmInfohub.pnVyhledanoLeft.activePage:=frmInfohub.tsSubjektyFirma;
  frmInfohub.pnVyhledanoLeftChange(nil);
  frmInfohub.qrSZR_INFO_HUB.active:=true;

  if (not HasData(frmInfohub.qrSZR_INFO_HUB)) and
     Confirm('Na základì zapsaných údajù nebyl dohledán žádný záznam v základních registrech.'+EOL+
             'Pøejete si zobrazit detailní informace?','Informace z Infohubu') then
    begin
      frmInfohub.Show;
      Exit;
    end;

  if (frmInfohub.qrSZR_INFO_HUB.RecordCount>1) and // eee to by nemelo nastat
     Confirm ('Na základì zapsaných údajù bylo dohledáno více záznamù v základních registrech.'+EOL+
              'Pøejete si zobrazit detailní informace?','Informace z Infohubu') then
    begin
      frmInfohub.Show;
      Exit;
    end;

  if (frmInfohub.qrSZR_INFO_HUB.RecordCount=0)
      or (frmInfohub.qrSZR_INFO_HUBJMENO.asString+
          frmInfohub.qrSZR_INFO_HUBPRIJMENI.asString+
          frmInfohub.qrSZR_INFO_HUBNAZEV.asString='') then
  begin
    WarnInfo('Nenalazena žádná data. Zkontrolujte zapisované údaje.');
    EXIT;
  end;

  ExecQuery('DELETE FROM SUBJEKTY WHERE ID='+Q(IntToStr(FFixId)));
  frmInfohub.qrSZR_INFO_HUB.close;
  frmInfohub.qrSZR_INFO_HUB.open;
  Subjekt_from_INFO_HUB(frmInfohub.qrSZR_INFO_HUBID.asInteger,
                        0,
                        0,
                        FFixID);
  LoadData(true);
  sbAresClick(nil);
end;


// ..........................................................................
procedure TdlgSubjektyNovy.sbInfoHubNovyOsobaClick(Sender: TObject);
var
  i:integer;
begin
  if not KontrolaDuplicity(true) then
    EXIT;

  if (edPrijmeni.text='') or (edJmeno.text='') or (edDatumNar.date<(now-37000)) then
  begin
    ErrorMsg('Zadejte jméno, pøíjmeni a datum narození.');
    Exit;
  end;
// podobne jako v subjektech
  PrepareForm(TfrmInfohub,frmInfohub);
  frmInfohub.Init;

  frmInfohub.Firma:=false;
  frmInfohub.btTest.tag:=1;
  frmInfohub.btTestClick(nil);
  frmInfohub.edPrijmeni.text:=edPrijmeni.text;
  frmInfohub.edJmeno.text:=edJmeno.text;
  frmInfohub.edDatumNarozeni.text:=edDatumNar.text;
  frmInfohub.edPrijmeniChange(nil);

  frmInfohub.agenda:='SUBJEKTY';
  frmInfohub.RegistryLoadOsoba('');

  i:=SelectInt('Select max(id) from zurnal '+
               ' where typ=''SZR'' and STARA_HODNOTA=''Osoba'' '+
               '  and zapsano>(sysdate-0.0007) '+ // as minuta
               '  and zapsal=user');
  if (i>0)  then
  begin
    frmInfohub.meResjtrikDataOut.text:=SelectStr('SELECT POPIS FROM ZURNAL WHERE ID='+IntToStr(i));
    frmInfohub.meResjtrikDataIn.text:=SelectStr('SELECT TEXT FROM ZURNAL WHERE ID='+IntToStr(i));
  end;

//  if not Registry_Parse_Data(0,frmInfohub.meResjtrikDataIn.text,-1,0) then
//    EXIT;

  if edICO.text<>'' then
    frmInfohub.pnVyhledanoLeft.activePage:=frmInfohub.tsSubjektyFirma
  else
    frmInfohub.pnVyhledanoLeft.activePage:=frmInfohub.tsSubjektyOsoba;
  frmInfohub.pnVyhledanoLeftChange(nil);
  frmInfohub.qrSZR_INFO_HUB.active:=true;

  if (not HasData(frmInfohub.qrSZR_INFO_HUB)) and
     Confirm('Na základì zapsaných údajù nebyl dohledán žádný záznam v základních registrech.'+EOL+
             'Pøejete si zobrazit detailní informace?','Informace z Infohubu') then
    begin
      frmInfohub.Show;
      Exit;
    end;

  if (frmInfohub.qrSZR_INFO_HUB.RecordCount>1) and // eee to by nemelo nastat
     Confirm ('Na základì zapsaných údajù bylo dohledáno více záznamù v základních registrech.'+EOL+
              'Pøejete si zobrazit detailní informace?','Informace z Infohubu') then
    begin
      frmInfohub.Show;
      Exit;
    end;

  if (frmInfohub.qrSZR_INFO_HUB.RecordCount=0)
      or (frmInfohub.qrSZR_INFO_HUBJMENO.asString+
          frmInfohub.qrSZR_INFO_HUBPRIJMENI.asString+
          frmInfohub.qrSZR_INFO_HUBNAZEV.asString='') then
  begin
    WarnInfo('Nenalazena žádná data. Zkontrolujte zapisované údaje.');
    EXIT;
  end;

  ExecQuery('DELETE FROM SUBJEKTY WHERE ID='+Q(IntToStr(FFixId)));
  frmInfohub.qrSZR_INFO_HUB.close;
  frmInfohub.qrSZR_INFO_HUB.open;
  Subjekt_from_INFO_HUB(frmInfohub.qrSZR_INFO_HUBID.asInteger,
                        0,
                        0,
                        FFixID);

  LoadData(false);
end;

// ..........................................................................
function TdlgSubjektyNovy.STAT_Kod(_Nazev: String): String;
begin
  result:=SelectStr('SELECT KOD FROM STATY WHERE ROWNUM<2 AND NAZEV='+Q(_Nazev));
end;

// ..........................................................................
function TdlgSubjektyNovy.STAT_Nazev(_KOD: String): String;
begin
  result:=SelectStr('SELECT NAZEV FROM STATY WHERE ROWNUM<2 AND KOD='+Q(_KOD));
end;

// ..........................................................................
procedure TdlgSubjektyNovy.LoadDataSpojeni;
var
  s,o,a:String;
begin
  s:='null';
  o:='null';
  a:='null';
  if FFixId>0 then
    s:=IntToStr(FFixId);
  if FOsobaID>0 then
    o:=IntToStr(FOsobaID);
  if FAdresaID>0 then
    a:=IntToStr(FAdresaID);
  edTel.text:=SelectStr('SELECT Get_Spojeni_Quick('+s+','+o+','+a+',0,0) FROM DUAL');
  edMobil.text:=SelectStr('SELECT Get_Spojeni_Quick('+s+','+o+','+a+',1,0) FROM DUAL');
  edEmail.text:=SelectStr('SELECT Get_Spojeni_Quick('+s+','+o+','+a+',2,0) FROM DUAL');
  edDatSchr.text:=qrSubjektDATOVA_SCHRANKA.AsString;
//  edBankovniUcet.text:=qrSubjektBUCET.AsString;  .. ten tam neni
//  edBanka.text:=qrSubjektBANKA.AsString;
end;


// ..........................................................................
procedure TdlgSubjektyNovy.LoadData(_Pravnicka:Boolean);
var
  i:Integer;
begin
  qrSubjekt.close;
  qrSubjekt.Open;
  if Hasdata(qrSubjekt) then
  begin
(*
    for i:=0 to gbPravnicka.Componentcount-1 do
    begin
      if Components[i] is TEdit then TEdit(Components[i]).Text:='';
      if Components[i] is TMemo then TMemo(Components[i]).Text:='';
      if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
    end;
*)

    edICO.text:=qrSubjektICO.AsString;
    edDIC.text:=qrSubjektDIC.AsString;
    edNazevPravOsoby.text:=qrSubjektNAZEV.AsString;
    edPravForma.text:=qrSubjektPRAVNI_FORMA.AsString;
    edDatVzniku.text:=qrSubjektDAT_VZNIKU.AsString;
    edZkratka.text:=qrSubjektZKRATKA.AsString;
    edOrgSlozka.text:=qrSubjektORGAN_SLOZKA.AsString;
    edICO_OR.text:=qrSubjektICO_OR.AsString;
    edSidloOR.text:=qrSubjektSIDLO_OR.AsString;
  end;

  qrOsoba.close;
  qrOsoba.Open;
  FOsobaID:=0;
  edJmeno.text:=qrSubjektJMENO.AsString;
  edPrijmeni.text:=qrSubjektPRIJMENI.AsString;
  edDatumNar.Date:=qrSubjektDAT_NAROZENI.AsDateTime;
  edMistoNar.Text:=qrSubjektMISTO_NAROZENI.asString;
  cbSTKod.ItemIndex:=cbSTKod.Items.IndexOf(Stat_Nazev(qrSubjektST_KOD.AsString));
  cbSTKod2.ItemIndex:=cbSTKod2.Items.IndexOf(Stat_Nazev(qrSubjektST_KOD2.AsString));
  if Hasdata(qrOsoba) then
  begin
(*
    for i:=0 to gbFyzicka.Componentcount-1 do
    begin
      if Components[i] is TEdit then TEdit(Components[i]).Text:='';
      if Components[i] is TMemo then TMemo(Components[i]).Text:='';
      if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
    end;
*)
    FOsobaID:=qrOsobaCISLO.asInteger;
    edJmeno.text:=qrOsobaJMENO.AsString;
    edPrijmeni.text:=qrOsobaPRIJMENI.AsString;
    edDatumNar.Date:=qrOsobaDAT_NAROZENI.AsDateTime;
    edRC.Text:=qrOsobaRC.asString;
    edTitul.text:=qrOsobaTITUL.AsString;
    edTitul2.text:=qrOsobaTITUL2.AsString;
    cbPohlavi.ItemIndex :=qrOsobaPOHLAVI.asInteger;
    edRodPrijm.text:=qrOsobaRODNE_PRIJM.AsString;
    edMistoNar.Text:=qrOsobaMISTO_NAROZENI.asString;
    cbSTKod.ItemIndex:=cbSTKod.Items.IndexOf(Stat_Nazev(qrOsobaST_KOD.AsString));
    cbSTKod2.ItemIndex:=cbSTKod2.Items.IndexOf(Stat_Nazev(qrOsobaST_KOD2.AsString));
  end;
  edOP_PAS.text:=qrSubjektOP_PAS.AsString;
  edOP_PAS2.text:=qrSubjektOP_PAS2.AsString;

  qrAdresa.close;
  if (gbPravnicka.checked and _Pravnicka) // bud je to pravnicka a adresa je dle ICO
     or not (gbPravnicka.checked or _Pravnicka) then // nebo to neni pravnicka a adresa je dle osoby
  begin
    qrAdresa.Open;
    if Hasdata(qrAdresa) then
    begin
(*
      for i:=0 to gbAdresa.Componentcount-1 do
      begin
        if Components[i] is TEdit then TEdit(Components[i]).Text:='';
        if Components[i] is TMemo then TMemo(Components[i]).Text:='';
        if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
      end;
*)
      FAdresaID:=qrAdresaCISLO.asInteger;
      edUlice.text:=qrAdresaULICE.AsString;
      edMesto.text:=qrAdresaMESTO.AsString;
      edPSC.text:=qrAdresaPSC.AsString;
      cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev(qrAdresaSTAT.AsString));
      edNazevAdresy.text:=qrAdresaNAZEV_ADRESY.AsString;
      edNazevAdresy2.text:=qrAdresaNAZEV_ADRESY_2.AsString;
      edObjekt.text:=qrAdresaOBJEKT.AsString;
    end;
  end;
  LoadDataSpojeni;
end;

// ..........................................................................
function TdlgSubjektyNovy.UlozitSpojeni: Boolean;
var
  o,a:String;
begin
  result:=false;
  o:='null';
  a:='null';
  if FOsobaID>0 then
    o:=IntToStr(FOsobaID);
  if FAdresaID>0 then
    a:=IntToStr(FAdresaID);

  if edMobil.text<>'' then
  begin
    ExecQuery('INSERT INTO SUBJEKTY_SPOJENI(SUBJEKT, KOD, CISLO_OSOBY, CISLO_ADRESY, HODNOTA)'+
              'VALUES('+Q(IntToStr(FSubID))+',''MOBIL'','+o+','+a+','+Q(edMobil.text)+')')
  end;

  if edTel.text<>'' then
  begin
    ExecQuery('INSERT INTO SUBJEKTY_SPOJENI(SUBJEKT, KOD, CISLO_OSOBY, CISLO_ADRESY, HODNOTA)'+
              'VALUES('+Q(IntToStr(FSubID))+',''TELEFON'','+o+','+a+','+Q(edTel.text)+')')
  end;

  if edEmail.text<>'' then
  begin
    ExecQuery('INSERT INTO SUBJEKTY_SPOJENI(SUBJEKT, KOD, CISLO_OSOBY, CISLO_ADRESY, HODNOTA)'+
              'VALUES('+Q(IntToStr(FSubID))+',''E-MAIL'','+o+','+a+','+Q(edEmail.text)+')')
  end;

  result:=true;
end;

// ..........................................................................
function TdlgSubjektyNovy.UlozitOsobu: Boolean;
begin
  result:=false;
  qrOsoba.active:=true;
  if hasData(qrOsoba) then
    qrOsoba.Edit
  else
  begin
    qrOsoba.Insert;
    qrOsobaCISLO.AsInteger:=SelectInt('SELECT SEQ_SUBJEKTY_OSOBY_CISLO.NEXTVAL FROM dual');
  end;
  qrOsobaSUBJEKT.AsInteger:=FSubID;
  FOsobaID:=qrOsobaCISLO.AsInteger;

  if qrOsobaCISLO_ADRESY.isNull then
    qrOsobaCISLO_ADRESY.AsInteger:=FAdresaID;

  qrOsobaTITUL.AsString:=edTitul.Text;
  qrOsobaJMENO.AsString:=edJmeno.text;
  qrOsobaPRIJMENI.AsString:=edPrijmeni.text;
  qrOsobaTITUL2.AsString:=edTitul2.Text;
//  qrOsobaUNKCE.AsString:=edFunkce.Text;
  qrOsobaOSLOVENI.AsString:=edOsloveni.Text;

  qrOsobaPOHLAVI.asInteger:=cbPohlavi.ItemIndex;
//  qrOsobaYCHOZI.AsInteger:=Byte(cbVychozi.Checked);
  qrOsobaVYCHOZI.AsInteger:=Byte(ckVychoziOsoba.Checked);

  qrOsobaRODNE_PRIJM.AsString:=edRodPrijm.text;
  qrOsobaDAT_NAROZENI.AsDateTime:=edDatumNar.Date;
  qrOsobaMISTO_NAROZENI.asString:=edMistoNar.Text;
  qrOsobaRC.asString:=edRC.Text;
  qrOsobaST_KOD.asString:=STAT_Kod(cbSTKod.Text);
  qrOsobaST_KOD2.asString:=STAT_Kod(cbSTKod2.Text);
  qrOsobaDATOVA_SCHRANKA.AsString:=edDatSchr.text;

  qrOsoba.post;
// tak uz nevim proc to tu je
  ExecQuery('UPDATE SUBJEKTY_OSOBY SET SUBJEKT='+Q(IntToStr(FSubID))+   // Ostatni osoby
            ' WHERE SUBJEKT='+Q(IntToStr(FFixId))+
            '   AND CISLO<>'+Q(IntToStr(FOsobaID)));
  result:=true;
end;

// ..........................................................................
function TdlgSubjektyNovy.UlozitAdresu: Boolean;
begin
  result:=false;
  qrAdresa.active:=true;
  if hasData(qrAdresa) then
    qrAdresa.Edit
  else
  begin
    qrAdresa.Insert;
    qrAdresaCISLO.AsInteger:=SelectInt('SELECT SEQ_SUBJEKTY_ADRESY_CISLO.NEXTVAL FROM dual');
  end;
  qrAdresaSUBJEKT.AsInteger:=FSubID;
  FAdresaID:=qrAdresaCISLO.AsInteger;

  qrAdresaNAZEV_ADRESY.AsString:=edNazevAdresy.text;
  qrAdresaNAZEV_ADRESY_2.AsString:=edNazevAdresy2.text;
  qrAdresaULICE.AsString:=edUlice.text;
  qrAdresaMESTO.AsString:=edMesto.text;
  qrAdresaPSC.AsString:=edPSC.text;
  qrAdresaSTAT.AsString:=Stat_Kod(cbStat.Text);
  qrAdresaOBJEKT.AsString:=edOBJEKT.text;
  qrAdresaSIDLO.AsInteger:=Byte(ckSidloAdresa.Checked);
  qrAdresaVYCHOZI.AsInteger:=Byte(ckVychoziAdresa.Checked);

  qrAdresa.post;
// tak uz nevim proc to tu je
  ExecQuery('UPDATE SUBJEKTY_ADRESY SET SUBJEKT='+Q(IntToStr(FSubID))+   // Ostatni adresy
            ' WHERE SUBJEKT='+Q(IntToStr(FFixId))+
            '   AND CISLO<>'+Q(IntToStr(FAdresaID)));
  result:=true;
end;

// ..........................................................................
function TdlgSubjektyNovy.UlozitSubjekt: Boolean;
begin
  result:=false;
  if not KontrolaDuplicity(false) then
    EXIT;

  if gbPravnicka.checked and (FICO='') then
  begin
    ErrorMsg('Právnická osoba musí mít vyplnìno IÈO.');
    ActiveControl:=edICO;
    EXIT;
  end;

  if not gbPravnicka.checked
     and ((edPrijmeni.text='') or (edJmeno.text='') and (edDatumNar.date<(now-37000))) then
  begin
    ErrorMsg('Fyzická osoba musí mít vyplnìno Jméno, Pøíjmení a Dat.narození.');
    ActiveControl:=edJmeno;
    EXIT;
  end;

  try
    FSubID:=FFixId; // zatim
    ExecQuery('UPDATE SUBJEKTY SET ICO=NULL WHERE ID='+Q(IntToStr(FFixId)));// UNIQUE INDEX
    qrSubjekt.active:=true;
    qrSubjekt.Session.StartTransaction;

    qrSubjekt.Insert; // vzdy musi byt insert
    qrSubjektID.AsInteger:=Get_Next_Ciselnik_ID;
    FSubID:=qrSubjektID.AsInteger;

    qrSubjektICO.AsString:=edICO.text;
    qrSubjektDIC.AsString:=edDic.text;
    qrSubjektNAZEV.AsString:=edNazevPravOsoby.text;
    qrSubjektPRAVNI_FORMA.AsString:=edPravForma.text;
    qrSubjektZKRATKA.AsString:=edZkratka.text;
    if edDatVzniku.date>(now-37000) then
      qrSubjektDAT_VZNIKU.AsDateTime:=edDatVzniku.date
    else
      qrSubjektDAT_VZNIKU.Clear;
    qrSubjektORGAN_SLOZKA.AsString:=edOrgSlozka.text;
    qrSubjektICO_OR.AsString:=edICO_OR.text;
    qrSubjektSIDLO_OR.AsString:=edSidloOR.text;

    qrSubjektST_KOD.asString:=STAT_Kod(cbSTKod.Text);
    qrSubjektST_KOD2.asString:=STAT_Kod(cbSTKod2.Text);

    qrSubjektDATOVA_SCHRANKA.AsString:=edDatSchr.text;
    qrSubjektBUCET.AsString:=edBankovniUcet.text;
    qrSubjektBANKA.AsString:=edBanka.text;

    qrSubjektPOZNAMKA.AsString:=mePoznamka.text;

    qrSubjekt.post;
    ExecSqlText('UPDATE SUBJEKTY SET '+  // zjebana zmrdka v oracle meni #13#10 na #10#10
                '  POZNAMKA=Replace(POZNAMKA,CHR(10)||CHR(10),CHR(13)||CHR(10)) '+
                ' WHERE ID='+Q(IntToStr(FSubID)));

    result:=UlozitAdresu and UlozitOsobu and UlozitSpojeni;
    if result then
    begin
      qrSubjekt.Session.Commit;
      Aktualizuj_subjekty_adresy(FSubID);
      Aktualizuj_subjekty_osoby(FSubID);
      Aktualizuj_subjekty_spojeni(FSubID);
      ExecQuery('DELETE FROM SUBJEKTY WHERE ID='+Q(IntToStr(FFixId)));
    end
    else
      qrSubjekt.Session.Rollback;
  except
    qrSubjekt.Session.Rollback;
    raise;
  end;

end;


end.
