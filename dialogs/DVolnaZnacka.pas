unit DVolnaZnacka;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOk, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Db, Ora, udmODAC;

type
  TdlgVolnaZnacka = class(TacDialogOk)
    Label2: TLabel;
    edZnacka: TEdit;
    btZjistit: TButton;
    Bevel1: TBevel;
    lbStatus: TLabel;
    qrZakazanaZnacka: TOraQuery;
    qrZakazanaZnackaZNACKA: TWideStringField;
    qrZakazanaZnackaDUVOD_ZABLOKOVANI: TWideStringField;
    Shape1: TShape;
    procedure btZjistitClick(Sender: TObject);
    procedure edZnackaChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgVolnaZnacka: TdlgVolnaZnacka;

function dlgVolnaZnackaExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses
  Tools, Queries, uUCLConsts, Utils;

{ Exec }

function dlgVolnaZnackaExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgVolnaZnacka, dlgVolnaZnacka, true); {1}

  with dlgVolnaZnacka do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;


procedure TdlgVolnaZnacka.btZjistitClick(Sender: TObject);
var
  ZnackaJeVolna: boolean;
  pocet1, pocet2: Integer;
begin
  edZnacka.Text := UpperCase(edZnacka.Text);

  edZnacka.SelectAll;
  edZnacka.SetFocus;

  ZnackaJeVolna := false;

  if Trim(edZnacka.Text) <> '' then
  begin
    qrZakazanaZnacka.ParamByName('ZNACKA').AsString := edZnacka.Text;

    qrZakazanaZnacka.Open;
    try
      if HasData(qrZakazanaZnacka) then
      begin
        lbStatus.Caption := Format('Zna�ka "%s" je v seznamu zablokovan�ch zna�ek (%s).', [edZnacka.Text, qrZakazanaZnackaDUVOD_ZABLOKOVANI.AsString]);
      end
      else
      begin
        pocet1:=SelectInt(Format(QS_KolizeZnacek, [edZnacka.Text, 0]));
        if pocet1<>0 then
        begin
          lbStatus.Caption := Format('Zna�ka "%s" je obsazena nebo je rezervov�na.', [edZnacka.Text]);
        end
        else
        begin
          lbStatus.Caption := Format('Zna�ka "%s" je voln�.', [edZnacka.Text]);
          ZnackaJeVolna := true;
        end;
      end;

    finally
      qrZakazanaZnacka.Close;
    end;

  end
  else
    lbStatus.Caption := 'Zadejte zna�ku!';

  lbStatus.Show;
  if ZnackaJeVolna then Shape1.Brush.Color := clLime else Shape1.Brush.Color := clRed;

end;

procedure TdlgVolnaZnacka.edZnackaChange(Sender: TObject);
begin
  lbStatus.Hide;
  Shape1.Brush.Color := clYellow;
end;

end.
