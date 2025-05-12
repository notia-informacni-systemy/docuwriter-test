unit DVychoziStavy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, Mask, DBCtrls, FLetadlaUCL, UCLTypes,
  NDBCtrls, SIIDBEditEx;

type
  TdlgVychoziStavy = class(TacDialogOkStorno)
    lbVychPocetHodin: TLabel;
    lbVychPocetPristani: TLabel;
    lbPopis: TLabel;
    lbStr1: TLabel;
    edVychPocetHodin: TSIIDBEditEx;
    edVychPocetMinut: TSIIDBEditEx;
    edVychPocetPristani: TSIIDBEditEx;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgVychoziStavy: TdlgVychoziStavy;

function dlgVychoziStavyExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses Tools;

function dlgVychoziStavyExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgVychoziStavy, dlgVychoziStavy, true); {1}

  with dlgVychoziStavy do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

// ..........................................................................
procedure TdlgVychoziStavy.FormShow(Sender: TObject);
begin
  inherited;
  edVychPocetHodin.SetFocus;
end;

end.
