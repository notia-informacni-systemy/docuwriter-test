unit DVyporadani;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Db, Ora, udmODAC,
  rxToolEdit, RXDBCtrl, DBCtrls, Mask, NDBCtrls, SIIDBEditEx, ComCtrls,
  Buttons, DBAccess, MemDS;

  type
  TdlgVyporadaniParams = class(TFuncParams)
  public
    fpID: Integer;
  end;

{ ------------------------------------------------------------------------- }

type
  TdlgVyporadani = class(TacDialogOkStorno)
    qrVyporadani: TOraQuery;
    qrVyporadaniID: TIntegerField;
    qrVyporadaniPOHL_ID: TIntegerField;
    qrVyporadaniKOD_VYPORADANI: TWideStringField;
    qrVyporadaniTYP_VYPORADANI: TSmallintField;
    qrVyporadaniZAL_ID: TIntegerField;
    qrVyporadaniCASTKA_KC: TFloatField;
    qrVyporadaniDATUM: TDateTimeField;
    qrVyporadaniSLOZ_POD_POSTA: TWideStringField;
    qrVyporadaniSLOZ_POD_CISLO: TWideStringField;
    qrVyporadaniBANKA_UCET_PLATCE: TWideStringField;
    qrVyporadaniBANKA_PLATCE: TWideStringField;
    qrVyporadaniPOZNAMKA: TWideStringField;
    qrVyporadaniZAPSANO: TDateTimeField;
    qrVyporadaniZAPSAL: TWideStringField;
    qrVyporadaniBANKA_CNB: TWideStringField;
    qrVyporadaniBV_DATUM: TDateTimeField;
    dsVyporadani: TOraDataSource;
    edPohledavka: TDBEdit;
    edPohlVarSym: TDBEdit;
    lbPohlVarSym: TLabel;
    lbPoznamka: TLabel;
    lbDatumUhrady: TLabel;
    lbCastka: TLabel;
    mePoznamka: TDBMemo;
    edCastka: TSIIDBEditEx;
    lbBankaUcetPlatce: TLabel;
    edBankaUcetPlatce: TDBEdit;
    edBankaPlatce: TDBEdit;
    lbPodPosta: TLabel;
    lbPodCislo: TLabel;
    lbSlozZeDne: TLabel;
    edPodPosta: TDBEdit;
    edPodCislo: TDBEdit;
    edSlozZeDne: TDBDateEdit;
    pnUhrada: TPanel;
    rgZpusobUhrady: TRadioGroup;
    qrVyporadaniPohlVarSym: TStringField;
    qrVyporadaniBANKA_VYPIS_CIS: TWideStringField;
    qrVyporadaniBANKA_VAR_SYM: TWideStringField;
    qrVyporadaniSTAT_UCET: TWideStringField;
    Label3: TLabel;
    edUcet: TDBEdit;
    lbZapsal: TLabel;
    edZapsal: TDBEdit;
    edZapsano: TDBDateEdit;
    lbZapsano: TLabel;
    lbCJ: TLabel;
    edCJ: TDBEdit;
    qrVyporadaniCISLO_JEDNACI: TWideStringField;
    edDatum: TDBEdit;
    lbCislo_PD: TLabel;
    edCislo_PD: TDBEdit;
    qrVyporadaniCISLO_PD: TWideStringField;
    lbSubjekt: TLabel;
    edSubjekt: TDBEdit;
    qrVyporadaniID_BANKA: TIntegerField;
    qrVyporadaniCISLO_BANKA: TIntegerField;
    qrVyporadaniSUB_ID: TIntegerField;
    lbCisloPolozky: TLabel;
    edCisloPolozky: TDBEdit;
    edID_Banky: TDBEdit;
    lbMylnaPlatba: TLabel;
    edMylnaPlatba: TSIIDBEditEx;
    qrVyporadaniZPUSOB_PLATBY: TSmallintField;
    qrVyporadaniMYLNE_PLATBY: TFloatField;
    lbCisloPrichVypisu: TLabel;
    edCisloPrichVypisu: TDBEdit;
    qrVyporadaniCISLO_PRICH_VYPISU: TWideStringField;
    btPohledavka: TButton;
    btBanka: TButton;
    procedure FormShow(Sender: TObject);
    procedure qrVyporadaniBeforeOpen(DataSet: TDataSet);
    procedure qrVyporadaniAfterOpen(DataSet: TDataSet);
    procedure btCancelClick(Sender: TObject);
    procedure qrVyporadaniCalcFields(DataSet: TDataSet);
    procedure qrVyporadaniSUB_IDGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure btPohledavkaClick(Sender: TObject);
    procedure btBankaClick(Sender: TObject);
  private
    VypID:Integer;
  public
  protected
    procedure OnOK(var Accept: boolean); override;
  end;

var
  dlgVyporadani: TdlgVyporadani;

function dlgVyporadaniExec(_Params: TFuncParams): Boolean;

implementation

{$R *.DFM}

uses
  Tools, Caches, uStoredProcs,FPohledavky,uUclConsts, FSubjekty,
  uDBUtils, Utils, uObjUtils, FBanka;


function dlgVyporadaniExec(_Params: TFuncParams): Boolean;
begin
  PrepareForm(TdlgVyporadani, dlgVyporadani, TRUE);

  with dlgVyporadani do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

// ***************************************************************************
procedure TdlgVyporadani.FormShow(Sender: TObject);
begin
  inherited;
  VypID:=0;
  if Assigned(Params) then
    with TdlgVyporadaniParams(Params) do
      VypID:=fpID;
  qrVyporadani.Open;
end;

// ***************************************************************************
procedure TdlgVyporadani.qrVyporadaniBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  if Assigned(qrVyporadani.Params.FindParam('ID')) then
    qrVyporadani.ParamByName('ID').AsInteger:=VypID;
end;

// ***************************************************************************
procedure TdlgVyporadani.qrVyporadaniAfterOpen(DataSet: TDataSet);
begin
  inherited;
  if not HasData(qrVyporadani) then EXIT;
  rgZpusobUhrady.ItemIndex:=
    rgZpusobUhrady.Items.IndexOf(qrVyporadaniKOD_VYPORADANI.AsString);
end;

// ***************************************************************************
procedure TdlgVyporadani.OnOK(var Accept: boolean);
begin
  Accept:=True;
  qrVyporadani.Active:=False;
end;

// ***************************************************************************
procedure TdlgVyporadani.btCancelClick(Sender: TObject);
begin
  inherited;
  if qrVyporadani.state in [dsEdit] then
    qrVyporadani.Cancel;
  qrVyporadani.Active:=False;
end;

// ***************************************************************************
procedure TdlgVyporadani.qrVyporadaniCalcFields(DataSet: TDataSet);
begin
  inherited;
  if qrVyporadaniPOHL_ID.isNull then
    qrVyporadaniPohlVarSym.AsString:=''
  else
    qrVyporadaniPohlVarSym.AsString:=SelectStr('Select VAR_SYM from POHLEDAVKY where ID='+qrVyporadaniPOHL_ID.AsString);
end;

// ***************************************************************************
procedure TdlgVyporadani.qrVyporadaniSUB_IDGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedSUBJEKTY( Sender.AsInteger );
end;

// ***************************************************************************
procedure TdlgVyporadani.btPohledavkaClick(Sender: TObject);
var
  FormIOParams: TfrmPohledavkyParams;
begin
  if not qrVyporadaniPOHL_ID.IsNull then
  try
    FormIOParams := TfrmPohledavkyParams.Create(PF_NOTHING, [ofoaFilter]);
    FormIOParams.fpFilterCondition := 'ID=' + qrVyporadaniPOHL_ID.AsString;
    frmPohledavkyExec(FormIOParams, True);
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgVyporadani.btBankaClick(Sender: TObject);
var
  FormIOParams: TfrmBankaParams;
begin
  if not qrVyporadaniID_BANKA.IsNull then
  try
    FormIOParams := TfrmBankaParams.Create(PF_NOTHING, [ofoaFilter]);
    FormIOParams.fpFilterCondition := 'ID=' + qrVyporadaniID_BANKA.AsString;
    frmBankaExec(FormIOParams, True);
  finally
    FormIOParams.Free;
  end;
end;

end.
