unit DZadaniVysledkuMereni;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, Mask, rxToolEdit, RXDBCtrl,
  NotiaDBComboBox, DBCtrls, FEvidenceLPZ, Db, UCLTypes, NDBCtrls, EditEx;

const
  DZADANI_VYSLEDKU_MERENI_PFI_QUERY     = $0001;

type
  TdlgZadaniVysledkuMereniParams = class(TfuncParams)
    fpDataSet:  TDataSet;
  end;

type
  TdlgZadaniVysledkuMereni = class(TacDialogOkStorno)
    lbDatumLO: TLabel;
    btDruhLO: TButton;
    btProvedl: TButton;
    lbCisloProtokolu: TLabel;
    btVysledekMereniLO: TButton;
    btVysledekMereniLPZ: TButton;
    lbPoznamka: TLabel;
    edDatumLO: TDBDateEdit;
    cbDruhLO: TNotiaDBComboBox;
    cbProvedl: TNotiaDBComboBox;
    cbVysledekMereniLO: TNotiaDBComboBox;
    cbVysledekMereniLPZ: TNotiaDBComboBox;
    mePoznamka: TDBMemo;
    dsMain: TOraDataSource;
    lbSazba: TLabel;
    edSazba: TDBEdit;
    lbKlasifikaceLO: TLabel;
    edKlasifikaceLO: TDBEdit;
    edCisloProtokolu: TDBEditEx;
    lbPlatnost: TLabel;
    edPlatnost: TDBDateEdit;
    btIDLetu: TButton;
    cbIDLetu: TNotiaDBComboBox;
    procedure FormShow(Sender: TObject);
    procedure btVysledekMereniLPZClick(Sender: TObject);
    procedure btVysledekMereniLOClick(Sender: TObject);
    procedure btDruhLOClick(Sender: TObject);
    procedure cbVysledekMereniLPZChange(Sender: TObject);
    procedure btProvedlClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btIDLetuClick(Sender: TObject);
  private
    procedure InitDruhLOCombo;
//    procedure InitKlasifikaceLOCombo;
    procedure InitProvedlCombo;
    procedure InitMereniLPZCombo;
    procedure InitIDLetuCombo;
  public
    { Public declarations }
  end;

var
  dlgZadaniVysledkuMereni: TdlgZadaniVysledkuMereni;

function dlgZadaniVysledkuMereniExec(_Params: TFuncParams): boolean;
  
implementation

{$R *.DFM}

uses Tools, Utils, Queries, FDruhyLPZ, FDruhyLO, Caches, FKodyJmen, DSeznamDenikuLetadla;

function dlgZadaniVysledkuMereniExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgZadaniVysledkuMereni, dlgZadaniVysledkuMereni, true); {1}

  with dlgZadaniVysledkuMereni do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.FormShow(Sender: TObject);
begin
  inherited;
  InitDruhLOCombo;
//  InitKlasifikaceLOCombo;
  InitProvedlCombo;
  InitMereniLPZCombo;
  InitIDLetuCombo;

  if Assigned(Params) then
  with TdlgZadaniVysledkuMereniParams(Params) do
  begin
    if FlagIsSet(DZADANI_VYSLEDKU_MERENI_PFI_QUERY) then dsMain.DataSet := fpDataSet;
  end;
  edDatumLO.SetFocus;
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.InitDruhLOCombo;
begin
  InitComboSQL(cbDruhLO, QS_Druhy_LO_Combo);
  cbVysledekMereniLO.Items.Assign(cbDruhLO.Items);
end;
{
// ..........................................................................
procedure TdlgZadaniVysledkuMereni.InitKlasifikaceLOCombo;
begin
  InitComboSQL(cbCrew, QS_Kody_Jmen_Combo);
end;
}
// ..........................................................................
procedure TdlgZadaniVysledkuMereni.InitProvedlCombo;
begin
  InitComboSQL(cbProvedl, QS_Kody_Jmen_Combo);
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.InitMereniLPZCombo;
begin
  InitComboSQL(cbVysledekMereniLPZ, QS_Druhy_LPZ_Combo);
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.btVysledekMereniLPZClick(
  Sender: TObject);
var FormIOParams: TfrmDruhyLPZParams;
begin
  FormIOParams := TfrmDruhyLPZParams.Create(FDRUHY_LPZ_PFO_ID, [], InitMereniLPZCombo);
  try
    if frmDruhyLPZExec(FormIOParams, true) then
    begin
      dsMain.DataSet.FieldByName('VYSLEDEK_MERENI_LPZ').AsInteger := FormIOParams.fpID;
      dsMain.DataSet.FieldByName('CENA').AsString:=SelectStr('SELECT SAZBA FROM DRUHY_LPZ WHERE ID='+
                                            dsMain.DataSet.FieldByName('VYSLEDEK_MERENI_LPZ').AsString);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.btVysledekMereniLOClick(
  Sender: TObject);
var FormIOParams: TfrmDruhyLOParams;
begin
  FormIOParams := TfrmDruhyLOParams.Create(FDRUHY_LO_PFO_ID, [], InitDruhLOCombo);
  try
    if frmDruhyLOExec(FormIOParams, true) then
    begin
      dsMain.DataSet.FieldByName('VYSLEDEK_MERENI_LO').AsInteger := FormIOParams.fpID;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.btDruhLOClick(Sender: TObject);
var FormIOParams: TfrmDruhyLOParams;
begin
  FormIOParams := TfrmDruhyLOParams.Create(FDRUHY_LO_PFO_ID, [], InitDruhLOCombo);
  try
    if frmDruhyLOExec(FormIOParams, true) then
    begin
      dsMain.DataSet.FieldByName('DRUH_MERENI').AsInteger := FormIOParams.fpID;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.cbVysledekMereniLPZChange(
  Sender: TObject);
begin
  inherited;
  dsMain.DataSet.FieldByName('CENA').AsString:=SelectStr('SELECT SAZBA FROM DRUHY_LPZ WHERE ID='+
                                        IntToStr(CachedDRUHY_LPZnum(cbVysledekMereniLPZ.Text)));
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.btProvedlClick(Sender: TObject);
var
  FormIOParams: TfrmKodyJmenParams;
begin
  FormIOParams := TfrmKodyJmenParams.Create(FKODY_JMEN_PFO_ID, [], InitProvedlCombo);
  try
    if frmKodyJmenExec(FormIOParams, true) then
    begin
      dsMain.DataSet.FieldByName('MERITEL').AsInteger := FormIOParams.fpID;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.btOKClick(Sender: TObject);
begin
  if dsMain.DataSet.FieldByName('DATUM_LETU').IsNull then
  begin
    ErrorMsg('"Datum LO" musí být zadáno!');
    edDatumLO.SetFocus;
    Abort;
  end;
  if dsMain.DataSet.FieldByName('CISLO_PROTOKOLU').IsNull then
  begin
    ErrorMsg('"Èíslo protokolu" musí být vyplnìno!');
    edCisloProtokolu.SetFocus;
    Abort;
  end;
  if dsMain.DataSet.FieldByName('PLATNOST').IsNull then
  begin
    ErrorMsg('"Platnost do" musí být vyplnìna!');
    edPlatnost.SetFocus;
    Abort;
  end;

  if (dsMain.DataSet.State=dsInsert) and (SelectInt('SELECT CISLO_PROTOKOLU FROM PROTOKOLY WHERE CISLO_PROTOKOLU='+edCisloProtokolu.Text)>0) then
  begin
    ErrorMsg('Protokol s tímto èíslem již existuje.Zadejte jiné èíslo!');
    edCisloProtokolu.SetFocus;
    Abort;
  end
  else
    try
      dsMain.DataSet.Post;
    except
      Exit;
    end;

  inherited;
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.btCancelClick(Sender: TObject);
begin
  inherited;      
    dsMain.DataSet.Cancel;
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.btIDLetuClick(Sender: TObject);
var
  FormIOParams: TdlgSeznamDenikuLetadlaParams;
begin
  FormIOParams := TdlgSeznamDenikuLetadlaParams.Create(DSEZNAM_DENIKU_LETADLA_PFO_ID, [], InitIDLetuCombo);
  try
    if dlgSeznamDenikuLetadlaExec(FormIOParams) then
    begin
      dsMain.DataSet.FieldByName('ID_LETU').AsInteger := FormIOParams.fpID;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgZadaniVysledkuMereni.InitIDLetuCombo;
begin
  InitComboSQL(cbIDLetu, QS_Denik_Letadla_ID_Combo);
end;

end.
