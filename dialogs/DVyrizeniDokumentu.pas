unit DVyrizeniDokumentu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Mask, rxToolEdit;

const
  D_VYRIZENI_DOKUMENTU_PFO_TYP    = $00000001;

type
  TdlgVyrizeniDokumentuParams = class(TFuncParams)
  public
    fpZPUSOB: String;
    fpDate: TDateTime;
  end;

type
  TdlgVyrizeniDokumentu = class(TacDialogOkStorno)
    lbZpusobVyrizeni: TLabel;
    cbZpusobVyrizeni: TComboBox;
    edDatum: TDateEdit;
    lbMessage: TLabel;
    procedure FormShow(Sender: TObject);
  private
    procedure InitComboZpusobVyrizeni;
  protected
    procedure FillParams; override;
  public
  end;

var
  dlgVyrizeniDokumentu: TdlgVyrizeniDokumentu;

function dlgVyrizeniDokumentuExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses
  Tools, uUclConsts;

function dlgVyrizeniDokumentuExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgVyrizeniDokumentu, dlgVyrizeniDokumentu, true); {1}

  with dlgVyrizeniDokumentu do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

{ TdlgVyrizeniDokumentu }
// ..........................................................................
procedure TdlgVyrizeniDokumentu.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgVyrizeniDokumentuParams(Params) do
  begin
    if FlagIsSet(D_VYRIZENI_DOKUMENTU_PFO_TYP) then
      begin
//        fpZPUSOB := cbZpusobVyrizeni.Text; // - MK 25.6.2002
        fpZPUSOB := IntToStr(cbZpusobVyrizeni.ItemIndex); // + MK 25.6.2002  zachovava se typ string
      end;
    fpDate:=edDatum.Date;
  end;
end;

// ..........................................................................
procedure TdlgVyrizeniDokumentu.FormShow(Sender: TObject);
begin
  inherited;
  InitComboZpusobVyrizeni;
  cbZpusobVyrizeni.ItemIndex:=0;
  edDatum.Date:=Trunc(Date)+1;
  if DayOfWeek(edDatum.Date)=7 then // je pristi den sobota?
    edDatum.Date:=edDatum.Date+2;
end;

// ..........................................................................
procedure TdlgVyrizeniDokumentu.InitComboZpusobVyrizeni;
var
  i:Integer;
begin
  cbZpusobVyrizeni.Clear;
  For i:=Low(ZpusobyVyrizeniDokumentu) to High(ZpusobyVyrizeniDokumentu) do
    cbZpusobVyrizeni.Items.add(ZpusobyVyrizeniDokumentu[i])
end;

end.
