unit DVyberTiskarny;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, UCLTypes, NotiaComboBox;

const
  DVYBER_TISKARNY_PFO_TISKARNA = $00000001;

type
  TdlgVyberTiskarnyParams = class(TFuncParams)
  public
    fpTiskarna: String;
  end;

type
  TdlgVyberTiskarny = class(TacDialogOkStorno)
    lbTiskarna: TLabel;
    cbTiskarna: TNotiaComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTiskarnaChange(Sender: TObject);
  private
    procedure InitComboTiskarny;
    procedure SetDefaultPrinter;
    procedure CheckOK;
    procedure SaveToRegistry;
    function LoadFromRegistry: String;
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgVyberTiskarny: TdlgVyberTiskarny;

function dlgVyberTiskarnyExec(_Params: TFuncParams): Boolean;

implementation

{$R *.dfm}

Uses Tools, Utils, NConsts, uUCLConsts, NParam, Printers, Registry, uRegUtils;

function dlgVyberTiskarnyExec(_Params: TFuncParams): Boolean;
begin
  PrepareForm(TdlgVyberTiskarny, dlgVyberTiskarny, TRUE);

  with dlgVyberTiskarny do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ..........................................................................
procedure TdlgVyberTiskarny.cbTiskarnaChange(Sender: TObject);
begin
  inherited;
  CheckOK;
end;

// ..........................................................................
procedure TdlgVyberTiskarny.CheckOK;
begin
  btOK.Enabled:=cbTiskarna.Text<>'';
end;

// ..........................................................................
procedure TdlgVyberTiskarny.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgVyberTiskarnyParams(Params) do
  begin
    if FlagIsSet(DVYBER_TISKARNY_PFO_TISKARNA) then
      fpTiskarna:=cbTiskarna.Text;
  end;
  SaveToRegistry;
end;

// ..........................................................................
procedure TdlgVyberTiskarny.FormCreate(Sender: TObject);
begin
  inherited;
  InitComboTiskarny;
end;

// ..........................................................................
procedure TdlgVyberTiskarny.FormShow(Sender: TObject);
begin
  inherited;
  SetDefaultPrinter;
  CheckOK;
end;

// ..........................................................................
procedure TdlgVyberTiskarny.InitComboTiskarny;
var i: Integer;
    SQL: String;
    st: TStringList;
begin
  st:=nil;
  try
    st:=TStringList.Create;
    st.Sorted:=True;
    for i:=0 to Printer.Printers.Count-1 do    // nejprve do TStringList kvùli setøídìní
    begin
      st.Add(Printer.Printers[i]);
    end;

    for i:=0 to st.Count-1 do
    begin
      if SQL<>'' then
        SQL:=SQL+' UNION ALL ';
      SQL:=SQL+'SELECT '+Q(st[i])+' FROM DUAL';
    end;
    InitComboSql(cbTiskarna, SQL);
  finally
    st.free;
  end;
end;

// ..........................................................................
function TdlgVyberTiskarny.LoadFromRegistry: String;
var tmp: String;
begin
  if ReadRegKey(UCLINIKey + Uzivatel, LastPrinter, tmp ) then
    Result:=tmp;
end;

// ..........................................................................
procedure TdlgVyberTiskarny.SaveToRegistry;
begin
  with TRegistry.Create do
  try
    if OpenKey(UCLINIKey + Uzivatel, true) then
      WriteString(LastPrinter, cbTiskarna.Text);
  finally
    Free;
  end;
end;

// ..........................................................................
procedure TdlgVyberTiskarny.SetDefaultPrinter;
var RegistryPrinter, DefaultPrinter, tmp: String;
begin
  DefaultPrinter:=Printer.Printers[Printer.PrinterIndex];
  RegistryPrinter:=LoadFromRegistry;

  if RegistryPrinter<>'' then
    DefaultPrinter:=RegistryPrinter;

  cbTiskarna.ItemIndex:=cbTiskarna.Items.IndexOf(DefaultPrinter);
end;

end.
