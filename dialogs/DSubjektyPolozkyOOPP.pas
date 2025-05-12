unit DSubjektyPolozkyOOPP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, NGrids, NDBGrids, MSGrid,
  Db, Ora, udmODAC, UCLTypes;

const
  DSUBJEKTY_POLOZKY_OOPP_PFI_OOPP        = $00000001;
  DSUBJEKTY_POLOZKY_OOPP_PFI_POHLAVI     = $00000002;
  DSUBJEKTY_POLOZKY_OOPP_PFO_MULTISELECT = $00000004;

type
  TdlgSubjektyPolozkyOOPPParams = class(TMultiselectFuncParams)
  public
    fpOOPP: Integer;
    fpPohlavi: Integer;
  end;

type
  TdlgSubjektyPolozkyOOPP = class(TacDialogOkStorno)
    qrOOPP: TOraQuery;
    dsOOPP: TOraDataSource;
    qrOOPPID: TIntegerField;
    qrOOPPNAZEV: TWideStringField;
    qrOOPPVYNASECI_DOBA: TIntegerField;
    qrOOPPCENA: TFloatField;
    qrOOPPPRO_ZENY: TIntegerField;
    nbMain: TNotebook;
    grOOPP: TMSDBGrid;
    qrOOPPKOD_SKUPINY: TWideStringField;
    qrStejnokroje: TOraQuery;
    dsStejnokroje: TOraDataSource;
    qrStejnokrojeKOD_STEJNOKROJE: TWideStringField;
    qrStejnokrojeID: TIntegerField;
    qrStejnokrojeNAZEV: TWideStringField;
    qrStejnokrojeVYNASECI_DOBA: TIntegerField;
    qrStejnokrojeCENA: TFloatField;
    qrStejnokrojePRO_ZENY: TIntegerField;
    grStejnokroje: TMSDBGrid;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grStejnokrojeDblClick(Sender: TObject);
    procedure grOOPPDblClick(Sender: TObject);
  private
    FOOPP: Integer;
    FPohlavi: Integer;

    function CopyToTargetList(D : TDataSet): boolean;
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgSubjektyPolozkyOOPP: TdlgSubjektyPolozkyOOPP;

function dlgSubjektyPolozkyOOPPExecModal(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

Uses Tools, Utils;

function dlgSubjektyPolozkyOOPPExecModal(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektyPolozkyOOPP, dlgSubjektyPolozkyOOPP, true);

  with dlgSubjektyPolozkyOOPP do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyPolozkyOOPP.FormShow(Sender: TObject);
begin
  inherited;
  FOOPP:=1;
  FPohlavi:=0;
  if Assigned(Params) then
  with TdlgSubjektyPolozkyOOPPParams(Params) do
  begin
    if FlagIsSet(DSUBJEKTY_POLOZKY_OOPP_PFI_OOPP) then FOOPP:=fpOOPP;
    if FlagIsSet(DSUBJEKTY_POLOZKY_OOPP_PFI_POHLAVI) then FPohlavi:=fpPohlavi;
  end;

  if FOOPP=1 then
  begin
    nbMain.ActivePage:='OOPP';
    qrOOPP.Close;
    qrOOPP.ParamByName('POHLAVI').AsInteger:=FPohlavi;
    qrOOPP.Open;
    btOK.Enabled:=HasData(qrOOPP);
  end
  else
  begin
    nbMain.ActivePage:='Stejnokroje';
    qrStejnokroje.Close;
    qrStejnokroje.ParamByName('POHLAVI').AsInteger:=FPohlavi;
    qrStejnokroje.Open;
    btOK.Enabled:=HasData(qrStejnokroje);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyPolozkyOOPP.FillParams;
var ID: Integer;
    Grid: TMSDBGrid;
begin
  inherited;
  if Assigned(Params) then
  with TdlgSubjektyPolozkyOOPPParams(Params) do
  begin
    if FOOPP=1 then
      Grid:=grOOPP
    else
      Grid:=grStejnokroje;

    if FlagIsSet(DSUBJEKTY_POLOZKY_OOPP_PFO_MULTISELECT) and Assigned(fpMultiSelectList) then
    try
      fpMultiSelectList.BeginUpdate;
      Grid.DoWithSelected(CopyToTargetList);
    finally
      fpMultiSelectList.EndUpdate;
    end;
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyPolozkyOOPP.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  qrOOPP.Close;
  qrStejnokroje.Close;
end;

// ***************************************************************************
procedure TdlgSubjektyPolozkyOOPP.grStejnokrojeDblClick(Sender: TObject);
begin
  btOK.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyPolozkyOOPP.grOOPPDblClick(Sender: TObject);
begin
  btOK.Click;
end;

// ***************************************************************************
function TdlgSubjektyPolozkyOOPP.CopyToTargetList(D: TDataSet): boolean;
begin
  Result := Assigned(Params) and Assigned(TdlgSubjektyPolozkyOOPPParams(Params).fpMultiSelectList);
  if Result then TdlgSubjektyPolozkyOOPPParams(Params).fpMultiSelectList.Append(D.FieldByName('ID').AsString);
end;

end.
