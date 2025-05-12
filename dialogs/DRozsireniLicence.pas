unit DRozsireniLicence;
{
        projekt:        ISUCL.dpr
        vytvoøil:       Pavel Chmelaø, 15.11.2001
        úèel:           Slouží k pøidávání a editaci záznamù qrRozsireniLicence
                        v oknì Dokumenty.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Mask, rxToolEdit;

const
  DROZS_LIC_PFI_DATUM = $00000001;
  DROZS_LIC_PFI_PREDMET = $00000002;

  DROZS_LIC_PFO_DATUM = $00010000;
  DROZS_LIC_PFO_PREDMET = $00020000;

type
  TdlgRozsireniLicenceParams = class(TFuncParams)
    fpDatum: TDateTime;
    fpPredmetCinnosti: string;
  end;

  TdlgRozsireniLicence = class(TacDialogOkStorno)
    edPredmet: TEdit;
    edDatum: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgRozsireniLicence: TdlgRozsireniLicence;

function dlgRozsireniLicenceExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses
  Tools, Caches, uUCLConsts;

{ Exec }

function dlgRozsireniLicenceExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgRozsireniLicence, dlgRozsireniLicence, true); {1}

  with dlgRozsireniLicence do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

{ TdlgRozsireniLicence }

procedure TdlgRozsireniLicence.FillParams;
begin
  inherited;

  if Assigned(Params) then
  with TdlgRozsireniLicenceParams(Params) do
  begin
    if FlagIsSet(DROZS_LIC_PFO_DATUM) then
      fpDatum := edDatum.Date;

    if FlagIsSet(DROZS_LIC_PFO_PREDMET) then
      fpPredmetCinnosti := edPredmet.Text;
  end;
end;

procedure TdlgRozsireniLicence.FormShow(Sender: TObject);
begin
  inherited;


  if Assigned(Params) then
  with TdlgRozsireniLicenceParams(Params) do
  begin
    if FlagIsSet(DROZS_LIC_PFI_DATUM) then
      edDatum.Date := fpDatum;

    if FlagIsSet(DROZS_LIC_PFI_PREDMET) then
      edPredmet.Text := fpPredmetCinnosti;
  end;

end;

end.
