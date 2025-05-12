unit DVysledkyLetu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOk, NotiaMagic, StdCtrls, ExtCtrls, Mask, rxToolEdit, Grids,
  NDBGrids, MSGrid, DBCtrls, Db, Ora, udmODAC;

type
  TdlgVysledkyLetu = class(TacDialogOk)
    lbDatum: TLabel;
    edDatum: TDateEdit;
    btDohledatMise: TButton;
    gbMise: TMSDBGrid;
    lbMise: TLabel;
    lbZarizeni: TLabel;
    NavigatorZarizeni: TDBNavigator;
    grZarizeni: TMSDBGrid;
    qrMise: TOraQuery;
    dsMise: TOraDataSource;
    qrZarizeni: TOraQuery;
    dsZarizeni: TOraDataSource;
    qrMiseID: TIntegerField;
    qrMiseDATUM: TDateTimeField;
    qrMiseCISLO_MISE: TIntegerField;
    qrMiseROK: TSmallintField;
    qrMiseID_LET_UCL: TIntegerField;
    qrMiseODLET: TDateTimeField;
    qrMisePRILET: TDateTimeField;
    qrMisePALIVO: TWideStringField;
    qrMiseSLUZBA: TIntegerField;
    qrMiseUDRZBA_LPZ: TWideStringField;
    qrMisePOZNAMKA: TWideStringField;
    qrMisePIC: TIntegerField;
    qrMiseF_O: TIntegerField;
    qrMiseINSPEKTOR_1: TIntegerField;
    qrMiseINSPEKTOR_2: TIntegerField;
    qrMiseINSPEKTOR_3: TIntegerField;
    qrMiseTUL_1: TIntegerField;
    qrMiseTUL_2: TIntegerField;
    qrMisePAX: TSmallintField;
    btSeskupit: TButton;
    btOdskupit: TButton;
    qrZarizeniNAZEV: TWideStringField;
    qrZarizeniID_EVID_LPZ: TFloatField;
    qrZarizeniVYSLEDEK_MERENI_LO: TFloatField;
    qrZarizeniPOZNAMKA: TWideStringField;
    qrZarizeniID_MISE: TFloatField;
    btPotvrdit: TButton;
    qrZarizeniDRUH_LPZ: TIntegerField;
    qrZarizeniLETISTE: TIntegerField;
    qrZarizeniPROVOZOVATEL: TIntegerField;
    qrZarizeniID_PROTOKOLU: TFloatField;
    qrZarizeniMERITEL: TFloatField;
    procedure btDohledatMiseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrZarizeniAfterInsert(DataSet: TDataSet);
    procedure qrZarizeniBeforeDelete(DataSet: TDataSet);
    procedure btSeskupitClick(Sender: TObject);
    procedure btOdskupitClick(Sender: TObject);
    procedure grZarizeniDblClick(Sender: TObject);
    procedure qrZarizeniVYSLEDEK_MERENI_LOGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure btPotvrditClick(Sender: TObject);
    procedure qrZarizeniCalcFields(DataSet: TDataSet);
    procedure qrZarizeniDRUH_LPZGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrZarizeniLETISTEGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrZarizeniPROVOZOVATELGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qrZarizeniID_PROTOKOLUGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qrZarizeniMERITELGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgVysledkyLetu: TdlgVysledkyLetu;

function dlgVysledkyLetuExec: Boolean;

implementation

{$R *.DFM}

Uses Tools, Utils, FEvidenceLPZ, DNazevSeskupeni, DVysledkyLetuPoznamka, uUCLConsts,
     Caches, uStoredProcs, DPoznamka;

function dlgVysledkyLetuExec: Boolean;
begin
  PrepareForm(TdlgVysledkyLetu, dlgVysledkyLetu, TRUE);

  with dlgVysledkyLetu do
  begin
    Result := (ShowModal = mrOK);
  end;
end;

// ..........................................................................
procedure TdlgVysledkyLetu.btDohledatMiseClick(Sender: TObject);
begin
  if edDatum.Text<>'  .  .    ' then
  begin
    qrMise.Close;
    qrMise.ParamByName('DATUM').AsDateTime:=edDatum.Date;
    qrMise.Open;
    RefreshQuery(qrZarizeni);
  end;
end;

// ..........................................................................
procedure TdlgVysledkyLetu.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  qrZarizeni.Close;
  qrMise.Close;
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniAfterInsert(DataSet: TDataSet);
var
  FormIOParams: TfrmEvidenceLPZParams;
begin
  if HasData(qrMise) then
  try
    FormIOParams := TfrmEvidenceLPZParams.Create(FEVIDENCE_LPZ_PFO_ID);
    if frmEvidenceLPZExec(FormIOParams, True) then
    try
      ExecQuery(Format('INSERT INTO MISE_EVID_LPZ(ID_MISE, ID_EVID_LPZ) VALUES(%d,%d)',
                       [qrMiseID.AsInteger, FormIOParams.fpID]));
    except
    end;
  finally
    FormIOParams.Free;
    RefreshQuery(qrZarizeni);
  end;
  Abort;
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniBeforeDelete(DataSet: TDataSet);
var FormIOParams: TdlgPoznamkaParams;
begin
  if qrZarizeniID_EVID_LPZ.IsNull then
  begin
    ErrorMsg('Nejprve musíte odskupit daná zaøízení.');
    Abort;
  end
  else
  try
    FormIOParams := TdlgPoznamkaParams.Create(DPOZNAMKA_PFO_POZNAMKA);
    if dlgPoznamkaExec(FormIOParams) then
      Mes_Let_Plan_Odstranit_Zarizeni(qrZarizeniID_EVID_LPZ.AsInteger, FormIOParams.fpPoznamka,
                                      edDatum.Date);
  finally
    FormIOParams.Free;
    RefreshQuery(qrZarizeni);
    Abort;
  end;
end;

var NazevSeskupeni: String;
// ..........................................................................
function SeskupitZarizeni(D : TDataSet) : boolean;
begin
  with dlgVysledkyLetu do
  begin
    if not qrZarizeniID_EVID_LPZ.IsNull then
      ExecQuery(Format('UPDATE MISE_EVID_LPZ SET NAZEV_SESKUPENI=%s WHERE ID_MISE=%s '+
                       'AND ID_EVID_LPZ=%s',
                       [Q(NazevSeskupeni),qrZarizeniID_MISE.AsString,qrZarizeniID_EVID_LPZ.AsString]));
  end;
  result:=True;
end;

// ..........................................................................
procedure TdlgVysledkyLetu.btSeskupitClick(Sender: TObject);
var
  FormIOParams: TdlgNazevSeskupeniParams;
begin
  if HasData(qrZarizeni) then
  begin
    FormIOParams := TdlgNazevSeskupeniParams.Create(FSESKUPENI_PF0_ID);
    try
      if dlgNazevSeskupeniExec(FormIOParams) then
      begin
        NazevSeskupeni:=FormIOParams.fpNAZEV;
        grZarizeni.DoWithSelected(SeskupitZarizeni);
      end;
    finally
      RefreshQuery(qrZarizeni);
    end;
  end;
end;

// ..........................................................................
function OdskupitZarizeni(D : TDataSet) : boolean;
begin
  with dlgVysledkyLetu do
  begin
    ExecQuery(Format('UPDATE MISE_EVID_LPZ SET NAZEV_SESKUPENI=NULL'+
                     ' WHERE ID_MISE=%s AND NAZEV_SESKUPENI=%s',
                     [qrZarizeniID_MISE.AsString,Q(qrZarizeniNAZEV.AsString)]));
  end;
  result:=True;
end;

// ..........................................................................
procedure TdlgVysledkyLetu.btOdskupitClick(Sender: TObject);
begin
  if HasData(qrZarizeni) then
  begin
    if Confirm('Opravdu chcete odskupit vybraná zaøízení?') then
    try
      grZarizeni.DoWithSelected(OdskupitZarizeni);
    finally
      RefreshQuery(qrZarizeni);
    end;
  end;
end;

// ..........................................................................
procedure TdlgVysledkyLetu.grZarizeniDblClick(Sender: TObject);
var
  FormIOParams: TdlgVysledkyLetuPoznamkaParams;
  Vysledek, Protokol, Meritel: String;
begin
{
  if HasData(qrZarizeni) then
  try
    FormIOParams:=TdlgVysledkyLetuPoznamkaParams.Create(PF_ALL);
    FormIOParams.fpLO:=qrZarizeniVYSLEDEK_MERENI_LO.AsInteger;
    FormIOParams.fpPOZNAMKA:=qrZarizeniPOZNAMKA.AsString;
    FormIOParams.fpID_LPZ:=qrZarizeniID_EVID_LPZ.AsInteger;
    FormIOParams.fpPROTOKOL:=qrZarizeniID_PROTOKOLU.AsInteger;
    FormIOParams.fpMeritel:=qrZarizeniMERITEL.AsInteger;
    FormIOParams.fpProvozovatel:=qrZarizeniPROVOZOVATEL.AsInteger;

    if dlgVysledkyLetuPoznamkaExec(FormIOParams) then
    try
      Vysledek:='NULL';
      Protokol:='NULL';
      Meritel:='NULL';
      if FormIOParams.fpLO<>0 then
        Vysledek:=IntToStr(FormIOParams.fpLO);
      if FormIOParams.fpPROTOKOL<>0 then
        Protokol:=IntToStr(FormIOParams.fpPROTOKOL);
      if FormIOParams.fpMeritel<>0 then
        Meritel:=IntToStr(FormIOParams.fpMeritel);

      if qrZarizeniID_EVID_LPZ.IsNull then
        ExecQuery(Format('UPDATE MISE_EVID_LPZ SET VYSLEDEK_MERENI_LO=%s, POZNAMKA=%s, '+
                         'ID_PROTOKOLU=%s, MERITEL=%s WHERE '+
                         'ID_MISE=%d AND NAZEV_SESKUPENI=%s',
                         [Vysledek, Q(FormIOParams.fpPOZNAMKA), Protokol, Meritel,
                          qrZarizeniID_MISE.AsInteger, Q(qrZarizeniNAZEV.AsString)]))
      else
        ExecQuery(Format('UPDATE MISE_EVID_LPZ SET VYSLEDEK_MERENI_LO=%s, POZNAMKA=%s, '+
                         'ID_PROTOKOLU=%s, MERITEL=%s WHERE '+
                         'ID_MISE=%d AND ID_EVID_LPZ=%d',
                         [Vysledek, Q(FormIOParams.fpPOZNAMKA), Protokol, Meritel,
                          qrZarizeniID_MISE.AsInteger, qrZarizeniID_EVID_LPZ.AsInteger]));
    except
    end;
  finally
    FormIOParams.Free;
    RefreshQuery(qrZarizeni);
  end;
}  
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniVYSLEDEK_MERENI_LOGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedDRUHY_LO( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVysledkyLetu.btPotvrditClick(Sender: TObject);
begin
{
  if HasData(qrZarizeni) then
  begin
    if Confirm('Opravdu chcete potvrdit výsledky mìøení u dané mise?') then
    begin
      if Potvrdit_Vysledky_Letu(qrMiseID.AsInteger) then
      begin
        Inform('Výsledky letu byly zapsány do Mìøení a vymazány z Týdenního plánu.');
        RefreshQuery(qrMise);
      end;
    end;
  end;
}  
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniCalcFields(DataSet: TDataSet);
begin
  inherited;
  qrZarizeniDRUH_LPZ.AsInteger:=SelectInt('SELECT DRUH_LPZ FROM EVIDENCE_LPZ WHERE ID='+qrZarizeniID_EVID_LPZ.AsString);
  qrZarizeniLETISTE.AsInteger:=SelectInt('SELECT LETISTE FROM EVIDENCE_LPZ WHERE ID='+qrZarizeniID_EVID_LPZ.AsString);
  qrZarizeniPROVOZOVATEL.AsInteger:=SelectInt('SELECT PROVOZOVATEL FROM EVIDENCE_LPZ WHERE ID='+qrZarizeniID_EVID_LPZ.AsString);
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniDRUH_LPZGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedDRUHY_LPZ( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniLETISTEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedPROVOZOVATELE_LETIST( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniPROVOZOVATELGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedSUBJEKTY( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniID_PROTOKOLUGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := IntToStr(CachedPROTOKOLY_CISLO( Sender.AsInteger ));
end;

// ..........................................................................
procedure TdlgVysledkyLetu.qrZarizeniMERITELGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedKODY_JMEN( Sender.AsInteger );
end;

end.
