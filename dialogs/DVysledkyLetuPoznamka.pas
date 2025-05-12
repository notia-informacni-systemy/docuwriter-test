unit DVysledkyLetuPoznamka;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, DBCtrls,
  NotiaDBComboBox, Db, Ora, udmODAC, Mask, NDBCtrls, EditEx;

const
  FVYSL_LETU_PFIO_LO              = $00000001;
  FVYSL_LETU_PFIO_POZNAMKA        = $00000002;
  FVYSL_LETU_PFI_ID_EVID_LPZ      = $00000004;
  FVYSL_LETU_PFIO_PROTOKOL        = $00000008;
  FVYSL_LETU_PFIO_MERITEL         = $00000016;
  FVYSL_LETU_PFI_PROVOZOVATEL     = $00000032;

type
  TdlgVysledkyLetuPoznamkaParams = class(TFuncParams)
  public
    fpLO: Integer;
    fpPOZNAMKA: String;
    fpID_LPZ: Integer;
    fpPROTOKOL: Integer;
    fpMeritel: Integer;
    fpProvozovatel: Integer;
  end;

type
  TdlgVysledkyLetuPoznamka = class(TacDialogOkStorno)
    btVysledekMereniLO: TButton;
    lbPoznamka: TLabel;
    cbVysledekMereniLO: TComboBox;
    mePoznamka: TMemo;
    qrMaster: TOraQuery;
    qrMasterID: TIntegerField;
    qrMasterIDENTIFIKACE: TWideStringField;
    qrMasterDRUH_LPZ: TIntegerField;
    qrMasterIDENTIFIKATOR: TWideStringField;
    qrMasterDRUH_LETISTE: TWideStringField;
    qrMasterLETISTE: TIntegerField;
    qrMasterNAZEV_LETISTE: TWideStringField;
    qrMasterRWY: TWideStringField;
    qrMasterSAZBA: TWideStringField;
    qrMasterSOURADNICE_SIRKA: TWideStringField;
    qrMasterSOURADNICE_SIRKA_STRANA: TWideStringField;
    qrMasterSOURADNICE_SIRKA_2: TFloatField;
    qrMasterSOURADNICE_DELKA: TWideStringField;
    qrMasterSOURADNICE_DELKA_STRANA: TWideStringField;
    qrMasterSOURADNICE_DELKA_2: TFloatField;
    qrMasterNADMORSKA_VYSKA_M: TFloatField;
    qrMasterNADMORSKA_VYSKA_FT: TFloatField;
    qrMasterELIPSOID_VYSKA_M: TFloatField;
    qrMasterELIPSOID_VYSKA_FT: TFloatField;
    qrMasterNADZEMNI_VYSKA_M: TFloatField;
    qrMasterNADZEMNI_VYSKA_FT: TFloatField;
    qrMasterPROVOZOVATEL: TIntegerField;
    qrMasterVYROBCE: TIntegerField;
    qrMasterTYP_RADARU: TWideStringField;
    qrMasterVYROBNI_CISLO: TWideStringField;
    qrMasterLOKALITA: TWideStringField;
    qrMasterFREKVENCE: TWideStringField;
    qrMasterFREKVENCE_JAKA: TWideStringField;
    qrMasterSTANOVISTE: TWideStringField;
    qrMasterPOZADOVANE_KRYTI_HORIZONT: TWideStringField;
    qrMasterPOZADOVANE_KRYTI_VERTIKALA: TWideStringField;
    qrMasterPLATNOST_DO: TDateTimeField;
    qrMasterDEADLINE: TDateTimeField;
    qrMasterAKTIVNI: TSmallintField;
    qrMasterTECHNIK_NA_ZEMI: TSmallintField;
    qrMasterOPZ: TWideStringField;
    qrMasterPLATNOST_OPZ: TDateTimeField;
    qrMasterVYSLEDEK_MERENI: TWideStringField;
    qrMasterPOZNAMKA: TWideStringField;
    lbProvozovatel: TLabel;
    lbLetiste: TLabel;
    lbDruhLPZ: TLabel;
    lbIdentifikace: TLabel;
    lbCisloProtokolu: TLabel;
    dbIdentifikace: TDBText;
    edProvozovatel: TDBEdit;
    edLetiste: TDBEdit;
    edDruhLPZ: TDBEdit;
    dsMaster: TOraDataSource;
    cbCisloProtokolu: TComboBox;
    btCisloProtokolu: TButton;
    lbMeritel: TLabel;
    cbMeritel: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrMasterPROVOZOVATELGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMasterLETISTEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMasterDRUH_LPZGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure btVysledekMereniLOClick(Sender: TObject);
    procedure btCisloProtokoluClick(Sender: TObject);
  private
    FProvozovatel: Integer;
    
    procedure InitDruhLOCombo;
    procedure InitCisloProtokoluCombo;
    procedure InitMeritelCombo;
  public
    { Public declarations }
  protected
    procedure FillParams; override;
  end;

var
  dlgVysledkyLetuPoznamka: TdlgVysledkyLetuPoznamka;

function dlgVysledkyLetuPoznamkaExec(_Params: TFuncParams): Boolean;

implementation

{$R *.DFM}

Uses Tools, Utils, Queries, Caches, FDruhyLO;

function dlgVysledkyLetuPoznamkaExec(_Params: TFuncParams): Boolean;
begin
  PrepareForm(TdlgVysledkyLetuPoznamka, dlgVysledkyLetuPoznamka, TRUE);

  with dlgVysledkyLetuPoznamka do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.FormShow(Sender: TObject);
begin
  inherited;
  InitDruhLOCombo;
  InitCisloProtokoluCombo;
  InitMeritelCombo;
  cbVysledekMereniLO.ItemIndex:=-1;
  mePoznamka.Text:='';
  qrMaster.Close;
  if Assigned(Params) then
  with TdlgVysledkyLetuPoznamkaParams(Params) do
  begin
    if FlagIsSet(FVYSL_LETU_PFIO_LO) then cbVysledekMereniLO.ItemIndex:= cbVysledekMereniLO.Items.IndexOf(CachedDRUHY_LO(fpLO));
    if FlagIsSet(FVYSL_LETU_PFIO_POZNAMKA) then mePoznamka.Text := fpPOZNAMKA;
    if FlagIsSet(FVYSL_LETU_PFI_ID_EVID_LPZ) then qrMaster.ParamByName('ID').AsInteger:= fpID_LPZ;
    if FlagIsSet(FVYSL_LETU_PFIO_PROTOKOL) then
      cbCisloProtokolu.ItemIndex:=
        cbCisloProtokolu.Items.IndexOf(SelectStr('SELECT CISLO_PROTOKOLU FROM PROTOKOLY WHERE ID='+IntToStr(fpPROTOKOL)));
    if FlagIsSet(FVYSL_LETU_PFIO_MERITEL) then
      cbMeritel.ItemIndex:= cbMeritel.Items.IndexOf(CachedKODY_JMEN(fpMeritel));
    if FlagIsSet(FVYSL_LETU_PFI_PROVOZOVATEL) then FProvozovatel := fpProvozovatel;
  end;
  qrMaster.Open;
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgVysledkyLetuPoznamkaParams(Params) do
  begin
    if FlagIsSet(FVYSL_LETU_PFIO_LO) then fpLO := CachedDRUHY_LOnum(cbVysledekMereniLO.Text);
    if FlagIsSet(FVYSL_LETU_PFIO_POZNAMKA) then fpPOZNAMKA := mePoznamka.Text;
    if FlagIsSet(FVYSL_LETU_PFIO_PROTOKOL) then fpPROTOKOL :=
      SelectInt('SELECT ID FROM PROTOKOLY WHERE CISLO_PROTOKOLU='+cbCisloProtokolu.Text);
    if FlagIsSet(FVYSL_LETU_PFIO_MERITEL) then fpMeritel := CachedKODY_JMENnum(cbMeritel.Text);
  end;
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  qrMaster.Close;
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.qrMasterPROVOZOVATELGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedSUBJEKTY( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.qrMasterLETISTEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedPROVOZOVATELE_LETIST( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.qrMasterDRUH_LPZGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedDRUHY_LPZ( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.btVysledekMereniLOClick(
  Sender: TObject);
var FormIOParams: TfrmDruhyLOParams;
begin
  FormIOParams := TfrmDruhyLOParams.Create(FDRUHY_LO_PFO_ID, [], InitDruhLOCombo);
  try
    if frmDruhyLOExec(FormIOParams, true) then
    begin
      cbVysledekMereniLO.ItemIndex := cbVysledekMereniLO.Items.IndexOf(CachedDRUHY_LO(FormIOParams.fpID));
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.InitDruhLOCombo;
begin
  InitComboSQL(cbVysledekMereniLO, QS_Druhy_LO_Combo);
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.InitCisloProtokoluCombo;
begin
  InitComboSQL(cbCisloProtokolu, 'SELECT CISLO_PROTOKOLU FROM PROTOKOLY '+
                                 'WHERE ODESLAN<>1 ORDER BY CISLO_PROTOKOLU');
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.btCisloProtokoluClick(Sender: TObject);
var NoveCislo, ID_Meritel: Integer;
    Meritel, Provozovatel: String;
begin
  inherited;
  if Confirm('Opravdu chcete vygenerovat nové èíslo protokolu?') then
  begin
    NoveCislo:=SelectInt('SELECT NVL(MAX(CISLO_PROTOKOLU),0)+1 FROM PROTOKOLY');
    Meritel:='NULL';
    Provozovatel:='NULL';
    ID_Meritel:=CachedKODY_JMENnum(cbMeritel.Text);
    if ID_Meritel<>0 then
      Meritel:=IntToStr(ID_Meritel);
    if FProvozovatel<>0 then
      Provozovatel:=IntToStr(FProvozovatel);
      
    ExecQuery(Format('INSERT INTO PROTOKOLY (CISLO_PROTOKOLU, MERITEL, PROVOZOVATEL) VALUES (%d,%s,%s)',
              [NoveCislo, Meritel, Provozovatel]));
    InitCisloProtokoluCombo;
    cbCisloProtokolu.ItemIndex:=cbCisloProtokolu.Items.IndexOf(IntToStr(NoveCislo));
  end;
end;

// ..........................................................................
procedure TdlgVysledkyLetuPoznamka.InitMeritelCombo;
begin
  InitComboSQL(cbMeritel, QS_Kody_Jmen_Combo);
end;

end.
