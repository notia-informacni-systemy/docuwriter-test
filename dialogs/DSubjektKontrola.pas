unit DSubjektKontrola;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UCLTypes, ADialogOk, NotiaMagic, StdCtrls, ExtCtrls;

const
  DSUB_KONTROLA_PFO_SEL    = $00010000; // 0000,0000,0000,0001,0000,0000,0000,0000

// TdlgSubjektKontrolaParams
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektKontrolaParams = class(TFuncParams)
  public
    fpCaption:string;
    fpSel:Integer;
  end;


// TdlgSubjektKontrola
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektKontrola = class(TacDialogOk)
    rgSel: TRadioGroup;
    procedure FormShow(Sender: TObject);
  private
  protected
    procedure FillParams; override;
  public
  end;

var
  dlgSubjektKontrola: TdlgSubjektKontrola;

function dlgSubjektKontrolaExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses
  Tools, Caches,  NParam, uStoredProcs, Utils;


function dlgSubjektKontrolaExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektKontrola, dlgSubjektKontrola, true);
  with dlgSubjektKontrola do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;


// TdlgSubjektKontrola
{ ------------------------------------------------------------------------- }

procedure TdlgSubjektKontrola.FillParams;
begin
  if Assigned(Params) then
    with TdlgSubjektKontrolaParams(Params) do
    begin
       if FlagIsSet(DSUB_KONTROLA_PFO_SEL) then
         fpSel:=rgSel.ItemIndex;
    end;
end;


{ ......................................................................... }
procedure TdlgSubjektKontrola.FormShow(Sender: TObject);
begin
  rgSel.ItemIndex:=0;
  if Assigned(Params) then
    with TdlgSubjektKontrolaParams(Params) do
    begin
      if fpCaption<>'' then Caption:=fpCaption;
    end;
end;

end.
