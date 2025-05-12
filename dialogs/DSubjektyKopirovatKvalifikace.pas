unit DSubjektyKopirovatKvalifikace;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  ADialogOkStorno, NotiaMagic, UCLTypes, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, NotiaDBComboBox, NotiaComboBox;

type
  TdlgSubjektyKopirovatKvalifikaceParams = class(TFuncParams)
  public
    fpSubjekt: Integer;
    fpOdbornost: String;
  end;

type
  TdlgSubjektyKopirovatKvalifikace = class(TacDialogOkStorno)
    lbKvalifikace: TLabel;
    cbKvalifikace: TNotiaComboBox;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgSubjektyKopirovatKvalifikace: TdlgSubjektyKopirovatKvalifikace;

function dlgSubjektyKopirovatKvalifikaceExec(_Params: TFuncParams): boolean;

implementation

uses Tools, Utils, Caches;

{$R *.dfm}

function dlgSubjektyKopirovatKvalifikaceExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektyKopirovatKvalifikace, dlgSubjektyKopirovatKvalifikace, true); {1}

  with dlgSubjektyKopirovatKvalifikace do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

// ***************************************************************************
procedure TdlgSubjektyKopirovatKvalifikace.FillParams;
begin
  inherited;

  if Assigned(Params) then
  with TdlgSubjektyKopirovatKvalifikaceParams(Params) do
  begin
    fpOdbornost := CachedTYPY_ODBORNOSTInum(cbKvalifikace.Text);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyKopirovatKvalifikace.FormShow(Sender: TObject);
begin
  inherited;

  if Assigned(Params) then
  with TdlgSubjektyKopirovatKvalifikaceParams(Params) do
  begin
    cbKvalifikace.Items.Clear;
    InitComboSql(cbKvalifikace, 'SELECT NAZEV FROM TYPY_ODBORNOSTI WHERE ID IN (SELECT TOD_ID FROM ODBORNOSTI WHERE SUB_ID='+IntToStr(fpSubjekt)+' AND TOD_ID<>'+Q(fpOdbornost)+') ORDER BY NAZEV');
  end;
end;

end.
