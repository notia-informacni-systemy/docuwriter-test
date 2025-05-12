unit DSubjekty;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogGrid, Db, Ora, udmODAC, NotiaMagic, StdCtrls, ExtCtrls, Grids,
  NDBGrids, MSGrid, UCLTypes, DBCtrls, ToolWin, ComCtrls;

const
  DSUBJEKTY_PFO_ID = $00010000;
  DSUBJEKTY_PFO_MULTISELECT = $00020000;

type
  TdlgSubjektyParams = class(TMultiselectFuncParams)
  public
    fpID: integer;
  end;

  TdlgSubjekty = class(TadDialogGrid)
    qrMasterID: TIntegerField;
    qrMasterSKUPINA: TSmallintField;
    qrMasterSUBJEKT_NAZEV: TWideStringField;
    procedure qrMasterSKUPINAGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    { Private declarations }
    function CopyToTargetList(D : TDataSet): boolean;
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgSubjekty: TdlgSubjekty;

function dlgSubjektyExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses
  Tools, Caches, uUCLConsts;

{ Exec }

function dlgSubjektyExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjekty, dlgSubjekty, true); {1}

  with dlgSubjekty do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

{ TdlgSubjekty }

function TdlgSubjekty.CopyToTargetList(D: TDataSet): boolean;
begin
  Result := Assigned(Params) and Assigned(TdlgsubjektyParams(Params).fpMultiSelectList);
  if Result then TdlgsubjektyParams(Params).fpMultiSelectList.Append(D.FieldByName('ID').AsString);
end;

procedure TdlgSubjekty.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgSubjektyParams(Params) do
  begin
    if FlagIsSet(DSUBJEKTY_PFO_ID) then
      fpID := qrMasterID.AsInteger;

    if FlagIsSet(DSUBJEKTY_PFO_MULTISELECT) and Assigned(fpMultiSelectList) then
    try
      fpMultiSelectList.BeginUpdate;
      grMaster.DoWithSelected(CopyToTargetList);
    finally
      fpMultiSelectList.EndUpdate;
    end;
  end;
end;

procedure TdlgSubjekty.qrMasterSKUPINAGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := AnoNe[false]
  else
    Text := AnoNe[boolean(Sender.AsInteger)];
end;

end.
