unit DVymazZLR;
// + <PCH> 28.2.2002

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Db, DBCtrls,
  NotiaDBComboBox, ORA, DBAccess;

const
  DVYMAZ_Z_LR_PFI_DATASET = 1;

type
  TdlgVymazZLRParams = class(TFuncParams)
  public
    fpDataset: TDataSet;
    fpExport: boolean;
  end;

  TdlgVymazZLR = class(TacDialogOkStorno)
    Label1: TLabel;
    rbArchivovat: TRadioButton;
    rbExportovat: TRadioButton;
    gbExport: TGroupBox;
    btStatExport: TButton;
    cbStatExport: TNotiaDBComboBox;
    mePoznamkaKExportu: TDBMemo;
    Label2: TLabel;
    dsLetadlo: TOraDataSource;
    ckZnackaReservovana: TDBCheckBox;
    ckAdresaReservovana: TDBCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btStatExportClick(Sender: TObject);
    procedure rbExportovatClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitStatyCombo;

  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgVymazZLR: TdlgVymazZLR;

function dlgVymazZLRExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses
  Tools, Utils, FStaty, Queries, uObjUtils;

{ Exec }

function dlgVymazZLRExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgVymazZLR, dlgVymazZLR, true); {1}

  with dlgVymazZLR do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

procedure TdlgVymazZLR.FillParams;
begin
  inherited;

  if Assigned(Params) then
  with TdlgVymazZLRParams(Params) do
  begin
    fpExport := rbExportovat.Checked;
  end;

end;

procedure TdlgVymazZLR.FormShow(Sender: TObject);
begin
  inherited;

  InitStatyCombo;

  rbExportovatClick(rbExportovat);

  if Assigned(Params) then
  with TdlgVymazZLRParams(Params) do
  begin
    if FlagIsSet(DVYMAZ_Z_LR_PFI_DATASET) and Assigned(fpDataSet) then
      dsLetadlo.DataSet := fpDataSet;
  end;
end;

procedure TdlgVymazZLR.btStatExportClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create( FSTATY_PFO_KOD, [], InitStatyCombo);

  try
    if Assigned(Params) then
      if Assigned(TdlgVymazZLRParams(Params)) then
      begin
        FormIOParams.fpSearch := TdlgVymazZLRParams(Params).fpDataSet.FieldByName('ST_KOD_EXPORT').AsString <> '';
        FormIOParams.fpSearchFor := TdlgVymazZLRParams(Params).fpDataSet.FieldByName('ST_KOD_EXPORT').AsString;
      end;

    if frmStatyExec(FormIOParams, true) then
    begin
      TdlgVymazZLRParams(Params).fpDataSet.FieldByName('ST_KOD_EXPORT').AsString := FormIOParams.fpKOD;
    end;
  finally
    FormIOParams.Free;
  end;
end;

procedure TdlgVymazZLR.InitStatyCombo;
begin
  InitComboSQL(cbStatExport, QS_Staty_Kod_Combo);
end;

procedure TdlgVymazZLR.rbExportovatClick(Sender: TObject);
begin
  SetControlsReadOnly([btStatExport, cbStatExport, mePoznamkaKExportu], not rbExportovat.Checked);
end;

end.
