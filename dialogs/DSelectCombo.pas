unit DSelectCombo;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, DataComboBox;

type
  TdlgSelectCombo = class(TForm)
    pnBottom: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    lbHodnota: TLabel;
    cbVal: TDataComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbValChange(Sender: TObject);
  private
    { Private declarations }
  public
    FSQL:String;
    FValue:string;
    FNull:Boolean;
    FComboValues:TStrings;
    procedure InitComboVal;
  end;

var
  dlgSelectCombo: TdlgSelectCombo;

function DlgSelectComboExecute(_SQL:String; _Value:String='';_Caption:String='';
                               _ValueInfo:String='';_Null:Boolean=True;_Style:TComboBoxStyle=csDropDown;
                               _ComboValues:TStrings=nil):boolean;

implementation

{$R *.DFM}
uses
  Tools, Utils, NConsts,uMultiLanguage;

function DlgSelectComboExecute(_SQL:String; _Value:String='';_Caption:String='';
                               _ValueInfo:String='';_Null:Boolean=True;_Style:TComboBoxStyle=csDropDown;
                               _ComboValues:TStrings=nil):boolean;
begin
  if Assigned(dlgSelectCombo) then
  try
    dlgSelectCombo.free;
    dlgSelectCombo:=nil;
  except
  end;

  try
    Screen.Cursor := crHourGlass;
    Application.CreateForm(TdlgSelectCombo, dlgSelectCombo);
    With dlgSelectCombo do
    begin
      FSQL:=_SQL;
      FValue:=_Value;
      FNull:=_Null;
      FComboValues:=_ComboValues;
      if _Caption<>'' then
        Caption:=_Caption;
      if _ValueInfo<>'' then
        lbHodnota.Caption:=_ValueInfo;
      cbVal.Style:=_Style;
      Result := ShowModal=mrOk;
    end;
  finally
    Screen.Cursor := crDefault;
  end
end;

{ TDlgSelectCombo }
// ..........................................................................
procedure TdlgSelectCombo.FormShow(Sender: TObject);
begin
  inherited;
  InitComboVal;
  if FValue<>'' then
    cbVal.ItemIndex:=cbVal.IndexOfData(FValue);
  if cbVal.ItemIndex<0 then
    cbVal.ItemIndex:=0;
  cbValChange(nil);
  ActiveControl:=cbVal;
end;

// ..........................................................................
procedure TDlgSelectCombo.InitComboVal;
begin
  cbVal.Clear;
  if FComboValues<>nil then
    cbVal.Items:=FComboValues
  else
    cbVal.AddQueryItems(FSQL, Database);

  if FNull or (cbVal.items.count=0) then
    cbVal.InsertItemValue(0, '', '');

  if cbVal.Items.count>0 then
    cbVal.ItemIndex:=0;

  cbValChange(nil);
end;

// ..........................................................................
procedure TdlgSelectCombo.FormCreate(Sender: TObject);
begin
  inherited;
  FSQL:='';
  FValue:='';
  FComboValues:=nil;
  FNull:=True;
end;

// ..........................................................................
procedure TdlgSelectCombo.cbValChange(Sender: TObject);
begin
  if FNull then
    OKBtn.Enabled:=cbVal.ItemIndex>0
  else
    OKBtn.Enabled:=cbVal.ItemIndex>=0;
end;

end.
