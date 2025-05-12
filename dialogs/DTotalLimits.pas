unit DTotalLimits;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Mask,
  rxToolEdit, RXDBCtrl, Db, FLetadlaUCL, DBCtrls, DBAccess, Ora;

const
  DTOTAL_LIMITS_PFI_QUERY     = $0001;

type
  TdlgTotalLimitsParams = class(TfuncParams)
    fpDataSet:  TDataSet;
  end;

type
  TdlgTotalLimits = class(TacDialogOkStorno)
    lbDatum: TLabel;
    lbPristiDatum: TLabel;
    lbPristiAirTime: TLabel;
    lbDruhLimitu: TLabel;
    edDatum: TDBDateEdit;
    dsMain: TOraDataSource;
    edPristiDatum: TDBDateEdit;
    edPristiAirTime: TDBEdit;
    meDruhLimitu: TMemo;
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    FIsInserting: Boolean;
  public
    { Public declarations }
  end;

var
  dlgTotalLimits: TdlgTotalLimits;

function dlgTotalLimitsExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses Tools, Utils;

function dlgTotalLimitsExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgTotalLimits, dlgTotalLimits, true); {1}

  with dlgTotalLimits do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;


// ..........................................................................
procedure TdlgTotalLimits.FormShow(Sender: TObject);
begin
  inherited;
  if Assigned(Params) then
  with TdlgTotalLimitsParams(Params) do
  begin
    if FlagIsSet(DTOTAL_LIMITS_PFI_QUERY) then dsMain.DataSet := fpDataSet;
    FIsInserting:=frmLetadlaUCL.qrTotalLimits.State=dsInsert;
  end;

  if FIsInserting then
    meDruhLimitu.lines.Text := ''
  else
    meDruhLimitu.lines.Text := SelectStr('SELECT DRUH_LIMITU FROM TOTAL_LIMITS WHERE ID='+frmLetadlaUCL.qrTotalLimitsID.AsString);

  edPristiDatum.SetFocus;    
end;

// ..........................................................................
procedure TdlgTotalLimits.btOKClick(Sender: TObject);
begin
  inherited;
  frmLetadlaUCL.qrTotalLimitsDRUH_LIMITU.AsString:=dlgTotalLimits.meDruhLimitu.Lines.text;
end;

end.
