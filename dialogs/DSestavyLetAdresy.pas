unit DSestavyLetAdresy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, Mask, rxToolEdit, UCLTypes;

const
  DSESTAVY_LET_ADRESY_PFI_SESTAVA      = $00000001;      
  DSESTAVY_LET_ADRESY_PFO_CJ           = $00000002;
  DSESTAVY_LET_ADRESY_PFO_VLASTNIK     = $00000004;
  DSESTAVY_LET_ADRESY_PFO_PROVOZOVATEL = $00000008;
  DSESTAVY_LET_ADRESY_PFO_DATUM        = $00000016;
  DSESTAVY_LET_ADRESY_PFO_POZN_ZNACKA  = $00000032;    
  DSESTAVY_LET_ADRESY_PFO_TYP_LETADLA  = $00000064;

type
  TdlgSestavyLetAdresyParams = class(TFuncParams)
  public
    fpSestava:      Integer;
    fpCJ:           String;
    fpVlastnik:     String;
    fpProvozovatel: String;
    fpDatum:        String;
    fpPoznZnacka:   String;
    fpTypLetadla:   String;
  end;

type
  TdlgSestavyLetAdresy = class(TacDialogOkStorno)
    lbCJ: TLabel;
    edCJ: TEdit;
    lbVlastnik: TLabel;
    edVlastnik: TEdit;
    lbProvozovatel: TLabel;
    edProvozovatel: TEdit;
    lbDatum: TLabel;
    edDatum: TDateEdit;
    lbPoznaZnacka: TLabel;
    edPoznaZnacka: TEdit;
    lbTyp: TLabel;
    edTyp: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgSestavyLetAdresy: TdlgSestavyLetAdresy;

function dlgSestavyLetAdresyExec(_Params: TFuncParams): Boolean;

implementation

{$R *.DFM}

Uses Tools;

function dlgSestavyLetAdresyExec(_Params: TFuncParams): Boolean;
begin
  PrepareForm(TdlgSestavyLetAdresy, dlgSestavyLetAdresy, TRUE);

  with dlgSestavyLetAdresy do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; 
end;

// ***************************************************************************
procedure TdlgSestavyLetAdresy.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgSestavyLetAdresyParams(Params) do
  begin
    if FlagIsSet(DSESTAVY_LET_ADRESY_PFO_CJ) then
      fpCJ:=edCJ.Text;
    if FlagIsSet(DSESTAVY_LET_ADRESY_PFO_VLASTNIK) then
      fpVlastnik:=edVlastnik.Text;
    if FlagIsSet(DSESTAVY_LET_ADRESY_PFO_PROVOZOVATEL) then
      fpProvozovatel:=edProvozovatel.Text;
    if FlagIsSet(DSESTAVY_LET_ADRESY_PFO_DATUM) then
      fpDatum:=edDatum.Text;
    if FlagIsSet(DSESTAVY_LET_ADRESY_PFO_POZN_ZNACKA) then
      fpPoznZnacka:=edPoznaZnacka.Text;
    if FlagIsSet(DSESTAVY_LET_ADRESY_PFO_TYP_LETADLA) then
      fpTypLetadla:=edTyp.Text;
  end;
end;

// ***************************************************************************
procedure TdlgSestavyLetAdresy.FormShow(Sender: TObject);
begin
  inherited;
  edCJ.Text:='';
  edVlastnik.Text:='';
  edProvozovatel.Text:='';
  edDatum.Date:=Date;
  edCJ.SetFocus;
  if Assigned(Params) then
    with TdlgSestavyLetAdresyParams(Params) do
    begin
      if FlagIsSet(DSESTAVY_LET_ADRESY_PFI_SESTAVA) then
        if FlagIsSet(DSESTAVY_LET_ADRESY_PFO_TYP_LETADLA) then edTyp.Text := fpTypLetadla;
        lbPoznaZnacka.Visible:=False; edPoznaZnacka.Visible:=False;
        lbTyp.Visible:=False; edTyp.Visible:=False;
        dlgSestavyLetAdresy.Height:=190;
        case fpSestava of
          0: begin
               lbVlastnik.Caption:='Budoucí vlastník letadla';
               lbProvozovatel.Caption:='Budoucí provozovatel letadla';
             end;
          1: begin
               lbVlastnik.Caption:='Vlastník pozemního kódovacího zaøízení';
               lbProvozovatel.Caption:='Provozovatel pozemního kódovacího zaøízení';
             end;
          2: begin
               lbVlastnik.Caption:='Vlastník sportovního létajícího zaøízení';
               lbProvozovatel.Caption:='Provozovatel/pilot sportovního létajícího zaøízení';
             end;
          3: begin      // volá se z okna Letadla
               lbVlastnik.Caption:='Budoucí vlastník letadla';
               lbProvozovatel.Caption:='Budoucí provozovatel letadla';
               lbPoznaZnacka.Visible:=True; edPoznaZnacka.Visible:=True;
               lbTyp.Visible:=True; edTyp.Visible:=True;
               dlgSestavyLetAdresy.Height:=240;
             end;
          4: begin
               lbVlastnik.Caption:='Vlastník bezpilotního letadla';
               lbProvozovatel.Caption:='Provozovatel bezpilotního letadla';
             end;
         end;
    end;
end;

end.
