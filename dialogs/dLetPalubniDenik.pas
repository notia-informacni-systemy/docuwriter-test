unit DLETPalubniDenik;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, Db, Ora, udmODAC, DBCtrls,
  Mask, rxToolEdit, RXDBCtrl, NotiaDBComboBox,UCLTypes, DBAccess;

const
  DLETZASTAVNI_PRAVO_PFI_QUERY       = $00000001;
  DLETZASTAVNI_PRAVO_PFI_READ_ONLY   = $00000002;

type
  TDlgLETPalubniDenikParams = class(TFuncParams)
  public
    fpDataSet:  TDataSet;
    fpReadOnly: Boolean;
  end;

type
  TDlgLETPalubniDenik = class(TacDialogOkStorno)
    Label1: TLabel;
    edVydano: TDBDateEdit;
    Label2: TLabel;
    edCislo: TDBEdit;
    cbLetKniha: TDBCheckBox;
    cbPalDenik: TDBCheckBox;
    dsMain: TOraDataSource;
    procedure FormShow(Sender: TObject);
  private
    FReadOnly:Boolean;
  protected
    procedure OnOK(var Accept: boolean); override;
  public
  end;

var
  DlgLETPalubniDenik: TDlgLETPalubniDenik;

function DlgLETPalubniDenikExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}
uses
  Tools, NConsts, Utils, Caches, uStoredProcs, Queries,
  SysParam, FSubjekty, uObjUtils, FLetadla;


function DlgLETPalubniDenikExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TDlgLETPalubniDenik, DlgLETPalubniDenik, true); {1}

  with DlgLETPalubniDenik do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ***************************************************************************
procedure TDlgLETPalubniDenik.FormShow(Sender: TObject);
begin
  inherited;
  FReadOnly:=False;

  if Assigned(Params) then
  with TDlgLETPalubniDenikParams(Params) do
  begin
    if FlagIsSet(DLETZASTAVNI_PRAVO_PFI_QUERY) then dsMain.DataSet := fpDataSet;
    if FlagIsSet(DLETZASTAVNI_PRAVO_PFI_READ_ONLY) then FReadOnly:=fpReadOnly;
  end;
  SetControlsReadOnly([edVydano, edCislo, cbLetKniha, cbPalDenik], FReadOnly);
  edVydano.SetFocus;
  btOK.Enabled:=not FReadOnly;
end;

// ***************************************************************************
procedure TDlgLETPalubniDenik.OnOK(var Accept: boolean);
var Pocet: Integer;
begin
  inherited;
  if dsMain.DataSet.FieldByName('VYDANO').AsDateTime=0 then
  begin
    ErrorMsg('Pole "Vydáno" musí být vyplnìno.');
    edVydano.SetFocus;
    Accept:=False;
    Abort;
  end;
  
  if dsMain.DataSet.State=dsInsert then
  begin
    if dsMain.DataSet.FieldByName('ID').AsInteger=0 then
      dsMain.DataSet.FieldByName('ID').AsInteger:=
        SelectInt('SELECT SEQ_LETADLA_PALUBNI_DENIK_ID.NEXTVAL FROM DUAL');
  end;

  if dsMain.DataSet.FieldByName('PALUBNI_DENIK').AsInteger=1 then
  begin
    Pocet:=SelectInt(
      Format('SELECT COUNT(*) FROM LETADLA_PALUBNI_DENIK WHERE PALUBNI_DENIK=1 AND ID<>%d '+
             'AND LET_ID=%d AND VYDANO=%s',
             [dsMain.DataSet.FieldByName('ID').AsInteger,
              dsMain.DataSet.FieldByName('LET_ID').AsInteger,
              Q(dsMain.DataSet.FieldByName('VYDANO').AsString)]));

    if Pocet<>0 then
    begin
      ErrorMsg('Toto letadlo již má k tomuto datu zadán Palubní deník.');
      Accept:=False;
      Abort;
    end;
  end;
  
  if dsMain.DataSet.FieldByName('LETADLOVA_KNIHA').AsInteger=1 then
  begin
    Pocet:=SelectInt(
      Format('SELECT COUNT(*) FROM LETADLA_PALUBNI_DENIK WHERE LETADLOVA_KNIHA=1 AND ID<>%d '+
             'AND LET_ID=%d AND VYDANO=%s',
             [dsMain.DataSet.FieldByName('ID').AsInteger,
              dsMain.DataSet.FieldByName('LET_ID').AsInteger,
              Q(dsMain.DataSet.FieldByName('VYDANO').AsString)]));
              
    if Pocet<>0 then
    begin
      ErrorMsg('Toto letadlo již má k tomuto datu zadánu Letadlovou knihu.');
      Accept:=False;
      Abort;
    end;
  end;

end;

end.

