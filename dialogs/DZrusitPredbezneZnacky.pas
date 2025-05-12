unit DZrusitPredbezneZnacky;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, Mask, rxToolEdit, UCLTypes;

const
  D_ZRUS_PFO_DATUM  = $1;

type
  TdlgZrusitPredbezneZnackyParams = class(TFuncParams)
  public
    fpDatum:TDateTime;
  end;

type
  TdlgZrusitPredbezneZnacky = class(TacDialogOkStorno)
    edDatum: TDateEdit;
    lbKDatu: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgZrusitPredbezneZnacky: TdlgZrusitPredbezneZnacky;

function dlgZrusitPredbezneZnackyExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses
  Tools;


function dlgZrusitPredbezneZnackyExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgZrusitPredbezneZnacky, dlgZrusitPredbezneZnacky, true);
  with dlgZrusitPredbezneZnacky do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

procedure TdlgZrusitPredbezneZnacky.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgZrusitPredbezneZnackyParams(Params) do
  begin
    if FlagIsSet(D_ZRUS_PFO_DATUM) then
      fpDatum:=Trunc(edDatum.Date);
  end;
end;

procedure TdlgZrusitPredbezneZnacky.FormShow(Sender: TObject);
begin
  inherited;
  edDatum.Date:=Date;
end;


end.
