unit DTiskStitkuObalky;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes;

const
  FTISK_STITKU_OBALKY_PFO_CK   = $00000001;
  FTISK_STITKU_OBALKY_PFO_TISK = $00000002;

type
  TdlgTiskStitkuObalkyParams = class(TFuncParams)
  public
    fpCK: Integer;
    fpTisk: Integer;
  end;

type
  TdlgTiskStitkuObalky = class(TacDialogOkStorno)
    grTisknout: TRadioGroup;
    pnStitek: TPanel;
    gbStitek: TGroupBox;
    ck1: TCheckBox;
    ck2: TCheckBox;
    ck3: TCheckBox;
    ck4: TCheckBox;
    ck5: TCheckBox;
    ck6: TCheckBox;
    ck7: TCheckBox;
    ck8: TCheckBox;
    ck9: TCheckBox;
    ck10: TCheckBox;
    ck11: TCheckBox;
    ck12: TCheckBox;
    ck13: TCheckBox;
    ck14: TCheckBox;
    ck15: TCheckBox;
    ck16: TCheckBox;
    ck17: TCheckBox;
    ck18: TCheckBox;
    procedure ck1Click(Sender: TObject);
    procedure grTisknoutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCK: Integer;
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgTiskStitkuObalky: TdlgTiskStitkuObalky;

function dlgTiskStitkuObalkyExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

Uses Tools;

function dlgTiskStitkuObalkyExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgTiskStitkuObalky, dlgTiskStitkuObalky, true); {1}

  with dlgTiskStitkuObalky do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

// ************************************************************************************
procedure TdlgTiskStitkuObalky.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgTiskStitkuObalkyParams(Params) do
  begin
    if (fpFlags and FTISK_STITKU_OBALKY_PFO_CK) <> 0 then fpCK:=FCK;
    if (fpFlags and FTISK_STITKU_OBALKY_PFO_TISK) <> 0 then fpTisk:=grTisknout.ItemIndex;
  end;
end;

// ************************************************************************************
procedure TdlgTiskStitkuObalky.ck1Click(Sender: TObject);
var i: Integer;
    aName: String;
begin
  aName:=(Sender as TCheckBox).Name;

  if (Sender as TCheckBox).Checked then
  begin
    for i:=0 to self.ComponentCount-1 do
    if (self.Components[i].GetParentComponent=gbStitek) then
    begin
      TCheckBox(self.Components[i]).Checked:=(TCheckBox(self.Components[i]).Name=aName);
      if TCheckBox(self.Components[i]).Checked then
        FCK:=TCheckBox(self.Components[i]).Tag;
    end;
  end;
end;

// ************************************************************************************
procedure TdlgTiskStitkuObalky.grTisknoutClick(Sender: TObject);
begin
  pnStitek.Visible:=grTisknout.ItemIndex=0;
end;

// ************************************************************************************
procedure TdlgTiskStitkuObalky.FormCreate(Sender: TObject);
begin
  inherited;
  ck1.Checked:=True;
end;

end.
