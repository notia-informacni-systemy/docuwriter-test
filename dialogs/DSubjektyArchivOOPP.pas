unit DSubjektyArchivOOPP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOk, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Db, Ora, udmODAC,
  NGrids, NDBGrids, MSGrid;

const
  DSUBJEKTY_ARCHIV_OOPP_PFI_OOPP   = $00000001;
  DSUBJEKTY_ARCHIV_OOPP_PFI_SUB_ID = $00000002;

type
  TdlgSubjektyArchivOOPPParams = class(TFuncParams)
  public
    fpOOPP: Integer;
    fpSUB_ID: Integer;
  end;

type
  TdlgSubjektyArchivOOPP = class(TacDialogOk)
    pnTop: TPanel;
    nbMain: TNotebook;
    qrOOPP: TOraQuery;
    qrStejnokroje: TOraQuery;
    grOOPP: TMSDBGrid;
    dsOOPP: TOraDataSource;
    grStejnokroje: TMSDBGrid;
    dsStejnokroje: TOraDataSource;
    qrOOPPSUB_ID: TIntegerField;
    qrOOPPID_POL: TIntegerField;
    qrOOPPNAZEV: TWideStringField;
    qrOOPPVELIKOST: TWideStringField;
    qrOOPPPOCET_VYDANYCH: TIntegerField;
    qrOOPPCENA: TFloatField;
    qrOOPPDATUM_NAROKU: TDateTimeField;
    qrOOPPDATUM_VYDEJE: TDateTimeField;
    qrOOPPDATUM_PRISTIHO_NAROKU: TDateTimeField;
    qrOOPPCAROVY_KOD: TWideStringField;
    qrOOPPPREVZAL: TWideStringField;
    qrOOPPPOTVRZENI_CIP: TWideStringField;
    qrOOPPID: TWideStringField;
    qrOOPPJMENO: TWideStringField;
    qrOOPPPRIJMENI: TWideStringField;
    qrOOPPDATUM_ARCHIVACE: TDateTimeField;
    qrOOPPPOZNAMKA: TWideStringField;
    qrOOPPREALNY_POCET: TSmallintField;
    qrOOPPODMITNUL: TSmallintField;
    qrStejnokrojeSUB_ID: TIntegerField;
    qrStejnokrojeID_POL: TIntegerField;
    qrStejnokrojeNAZEV: TWideStringField;
    qrStejnokrojeVELIKOST: TWideStringField;
    qrStejnokrojePOCET_VYDANYCH: TIntegerField;
    qrStejnokrojeCENA: TFloatField;
    qrStejnokrojeDATUM_NAROKU: TDateTimeField;
    qrStejnokrojeDATUM_VYDEJE: TDateTimeField;
    qrStejnokrojeDATUM_PRISTIHO_NAROKU: TDateTimeField;
    qrStejnokrojeCAROVY_KOD: TWideStringField;
    qrStejnokrojePREVZAL: TWideStringField;
    qrStejnokrojePOTVRZENI_CIP: TWideStringField;
    qrStejnokrojeID: TWideStringField;
    qrStejnokrojeJMENO: TWideStringField;
    qrStejnokrojePRIJMENI: TWideStringField;
    qrStejnokrojeDATUM_ARCHIVACE: TDateTimeField;
    qrStejnokrojePOZNAMKA: TWideStringField;
    qrStejnokrojePREDCHOZI_UTVAR: TWideStringField;
    qrStejnokrojeREALNY_POCET: TSmallintField;
    qrStejnokrojeODMITNUL: TSmallintField;
    qrOOPPPREDCHOZI_OOPP: TWideStringField;
    btZpet: TButton;
    procedure FormShow(Sender: TObject);
    procedure qrOOPPODMITNULGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure btZpetClick(Sender: TObject);
  private
    FOOPP: Integer;
    FSUB_ID: Integer;
  public
    { Public declarations }
  end;

var
  dlgSubjektyArchivOOPP: TdlgSubjektyArchivOOPP;

function dlgSubjektyArchivOOPPExecModal(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

Uses Tools, Utils;

function dlgSubjektyArchivOOPPExecModal(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektyArchivOOPP, dlgSubjektyArchivOOPP, true);

  with dlgSubjektyArchivOOPP do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyArchivOOPP.FormShow(Sender: TObject);
begin
  inherited;
  FOOPP:=1;
  if Assigned(Params) then
  with TdlgSubjektyArchivOOPPParams(Params) do
  begin
    if FlagIsSet(DSUBJEKTY_ARCHIV_OOPP_PFI_OOPP) then FOOPP:=fpOOPP;
    if FlagIsSet(DSUBJEKTY_ARCHIV_OOPP_PFI_SUB_ID) then FSUB_ID:=fpSUB_ID;
  end;

  if FOOPP=1 then
  begin
    nbMain.ActivePage:='OOPP';
    dlgSubjektyArchivOOPP.Caption:='Archiv OOPP';
    qrOOPP.Close;
    qrOOPP.ParamByName('ID').AsInteger:=FSUB_ID;
    qrOOPP.Open;
  end
  else
  begin
    nbMain.ActivePage:='Stejnokroje';
    dlgSubjektyArchivOOPP.Caption:='Archiv stejnokroje';
    qrStejnokroje.Close;
    qrStejnokroje.ParamByName('ID').AsInteger:=FSUB_ID;
    qrStejnokroje.Open;
  end;
  
end;

// ***************************************************************************
procedure TdlgSubjektyArchivOOPP.qrOOPPODMITNULGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.AsInteger>0 then
    Text:='Ano'
  else
    Text:='';
end;

// ************************************************************************************
function ZrusArchivaciStejnokroj(D : TDataSet) : boolean;
begin
  with dlgSubjektyArchivOOPP do
  begin
    ExecQuery('UPDATE SUBJEKTY_POLOZKY_STEJNOKROJE SET DATUM_ARCHIVACE=NULL WHERE ID='+qrStejnokrojeID.AsString);
  end;
  result:=True;
end;

// ************************************************************************************
function ZrusArchivaciOOPP(D : TDataSet) : boolean;
begin
  with dlgSubjektyArchivOOPP do
  begin
    ExecQuery('UPDATE SUBJEKTY_POLOZKY_OOPP SET DATUM_ARCHIVACE=NULL WHERE ID='+qrOOPPID.AsString);
  end;
  result:=True;
end;

// ***************************************************************************
procedure TdlgSubjektyArchivOOPP.btZpetClick(Sender: TObject);
begin
  if FOOPP=1 then
  begin
    if HasData(qrOOPP) then
    begin
      if Confirm('Opravdu chcete zrušit archivaci u vybraných položek OOPP?') then
      try
        grOOPP.DoWithSelected(ZrusArchivaciOOPP);
      finally
        RefreshQuery(qrOOPP, qrOOPPID);
      end;
    end;
  end
  else
  begin
    if HasData(qrStejnokroje) then
    begin
      if Confirm('Opravdu chcete zrušit archivaci u vybraných položek stejnokroje?') then
      try
        grStejnokroje.DoWithSelected(ZrusArchivaciStejnokroj);
      finally
        RefreshQuery(qrStejnokroje, qrStejnokrojeID);
      end;
    end;
  end;
end;

end.
