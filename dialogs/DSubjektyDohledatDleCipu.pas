unit DSubjektyDohledatDleCipu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes;

const
  DSUBJKETY_DOHLEDAT_DLE_CIPU_PFO_CIP = $00000001;
  DSUBJKETY_DOHLEDAT_DLE_CIPU_PFI_CK  = $00000002;

type
  TdlgSubjektyDohledatDleCipuParams = class(TFuncParams)
  public
    fpCIP: String;
    fpCK: Integer;
  end;

type
  TdlgSubjektyDohledatDleCipu = class(TacDialogOkStorno)
    lbCip: TLabel;
    edCip: TEdit;
    procedure FormShow(Sender: TObject);
  private
    FCK: Boolean;
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgSubjektyDohledatDleCipu: TdlgSubjektyDohledatDleCipu;

function dlgSubjektyDohledatDleCipuExecModal(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

Uses Tools;

function dlgSubjektyDohledatDleCipuExecModal(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektyDohledatDleCipu, dlgSubjektyDohledatDleCipu, true);

  with dlgSubjektyDohledatDleCipu do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyDohledatDleCipu.FormShow(Sender: TObject);
begin
  inherited;
  FCK:=False;
  if Assigned(Params) then
  with TdlgSubjektyDohledatDleCipuParams(Params) do
  begin
    if FlagIsSet(DSUBJKETY_DOHLEDAT_DLE_CIPU_PFI_CK) then FCK := (fpCK=1);
  end;
  if FCK then
  begin
    Caption:='Dohledat položku';
    lbCip.Caption:='Kód';
  end
  else
  begin
    Caption:='Dohledat Subjekt dle èipu';
    lbCip.Caption:='Èip';
  end;
  edCip.Text:='';
  edCip.SetFocus;
end;

// ***************************************************************************
procedure TdlgSubjektyDohledatDleCipu.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgSubjektyDohledatDleCipuParams(Params) do
  begin
    if (fpFlags and DSUBJKETY_DOHLEDAT_DLE_CIPU_PFO_CIP) <> 0 then fpCIP := edCip.Text;
  end;
end;

end.
