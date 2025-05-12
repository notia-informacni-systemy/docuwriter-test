unit DXMLExport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls;

// TdlgXMLExport
// --------------------------------------------------------------------------
type
  TdlgXMLExport = class(TacDialogOkStorno)
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ResultChecks:TStringList;
    procedure CheckBoxClick(Sender: TObject);
  public
    procedure SetChecks(_Checks:TStringList);
    function GetResult:word;
  end;

var
  dlgXMLExport: TdlgXMLExport;

Function dlgXMLExportExecute(_Checks:TStringList) :  word;

implementation

{$R *.DFM}

Function dlgXMLExportExecute(_Checks:TStringList) :  word;
begin
  Result := 0;
  Application.CreateForm(TdlgXMLExport, dlgXMLExport);
  With dlgXMLExport do
    try
      SetChecks(_Checks);
      if ShowModal=mrOk then
        result:=GetResult;
    finally
      Free;
    end;
end;

// TdlgXMLExport
// --------------------------------------------------------------------------
procedure TdlgXMLExport.FormCreate(Sender: TObject);
begin
  inherited;
  ResultChecks:=TStringList.Create;
end;

// ..........................................................................
procedure TdlgXMLExport.FormDestroy(Sender: TObject);
begin
  ResultChecks.Free;
  inherited;
end;


// ..........................................................................
function TdlgXMLExport.GetResult:word;
var
  i:integer;
begin
  result:=0;
  i:=0;
  while i<ResultChecks.Count do
  begin
    if ResultChecks[i]='ANO' then
      result:=result or (1 shl i);   // vraci ve forme bitove masky
    inc(i);
  end;
end;

// ..........................................................................
procedure TdlgXMLExport.SetChecks(_Checks:TStringList);
var
  i:integer;
  C:TCheckbox;
begin
  i:=0;
  ResultChecks.Clear;
  while i<_Checks.Count do
  begin
    C:=TCheckbox.Create(self);
    C.Parent:=self;
    C.Name:='CK_'+IntToStr(i);
    C.Caption:=_Checks[i];
    C.Top:=i*20+5;
    C.Left:=8;
    C.Width:=200;
    if i>0 then
      begin
        C.Checked:=False;
        ResultChecks.add('NE');
      end
    else
      begin
        C.Checked:=True;
        C.Enabled:=False;
        ResultChecks.add('ANO');  // prvni je defaultne checknuty
      end;
    C.OnClick:=CheckBoxClick;
    inc(i);
  end;
  ClientHeight:=35+(_Checks.Count)*20+10;
end;

// ..........................................................................
procedure TdlgXMLExport.CheckBoxClick(Sender: TObject);
var
  i:integer;
  C:TCheckbox;
begin
  C:=TCheckbox(Sender);
  i:=StrToInt(Copy(C.Name,4,MaxInt));
  if C.Checked then
    ResultChecks[i]:='ANO'
  else
    ResultChecks[i]:='NE'
end;


end.
