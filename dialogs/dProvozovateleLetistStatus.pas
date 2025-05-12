unit dProvozovateleLetistStatus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, db, Ora, udmODAC,
  DBCtrls, Mask, rxToolEdit, RXDBCtrl;

const
  D_PROVLET_STATUS_PFI_DATASET = $1;

type
  TdlgProvozovateleLetistStatusParams = class(TFuncParams)
    fpDataSet: TDataSet;
  end;

  TdlgProvozovateleLetistStatus = class(TacDialogOkStorno)
    cbStatus: TDBComboBox;
    dsMaster: TOraDataSource;
    btStatus: TButton;
    edOd: TDBDateEdit;
    edDO: TDBDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    chkPlatny: TDBCheckBox;
    chkZobrazit: TDBCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btStatusClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitSelectors;
    procedure InitStatusCombo;
  public
    { Public declarations }
  end;

var
  dlgProvozovateleLetistStatus: TdlgProvozovateleLetistStatus;

function dlgProvozovateleLetistStatusExec(_Params: TFuncParams): boolean;

implementation

uses
  Tools, Queries, FStatutLetiste;

{$R *.DFM}

{ Exec }

function dlgProvozovateleLetistStatusExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgProvozovateleLetistStatus, dlgProvozovateleLetistStatus, true); {1}

  with dlgProvozovateleLetistStatus do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

{ TdlgProvozovateleLetistStatus }

procedure TdlgProvozovateleLetistStatus.FormShow(Sender: TObject);
begin
  inherited;

  InitSelectors;

  if Assigned(Params) then
  begin
    if Params.FlagIsSet(D_PROVLET_STATUS_PFI_DATASET) then
      dsMaster.DataSet := TdlgProvozovateleLetistStatusParams(Params).fpDataSet;
  end;

end;

procedure TdlgProvozovateleLetistStatus.InitSelectors;
begin
  InitStatusCombo;
end;

procedure TdlgProvozovateleLetistStatus.InitStatusCombo;
begin
  InitComboSQL(cbStatus, QS_Status_Letiste_Combo);
end;

procedure TdlgProvozovateleLetistStatus.btStatusClick(Sender: TObject);
var
  FormIOParams: TfrmStatutLetisteParams;
  DataField: TField;
begin
  DataField := dsMaster.DataSet.FieldByName('ID_STATUS');

  FormIOParams := TfrmStatutLetisteParams.Create(FSTATUT_LETISTE_PFO_ID, [ofoaFilter]);
  try
    FormIOParams.fpFilterCondition := 'LETISTE = 1';

    FormIOParams.fpSearch := not DataField.IsNull;
    FormIOParams.fpSearchFor := DataField.AsInteger;

    if frmStatutLetisteExec(FormIOParams, true) then
    begin
      DataField.AsInteger := FormIOParams.fpID;
    end;
  finally
    FormIOParams.Free;
  end;

end;

procedure TdlgProvozovateleLetistStatus.btOKClick(Sender: TObject);
begin
  try
    dsMaster.DataSet.Post;
    inherited;
  finally
  end;
end;

end.
