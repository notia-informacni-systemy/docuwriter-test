unit DSubjektyObjednavkaOOPP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, Mask, rxToolEdit, NGrids,
  NDBGrids, MSGrid, UCLTypes, Db, Ora, udmODAC;

const
  DSUBJEKTY_OBJEDNAVKA_OOPP_PFI_OOPP = $00000001;
  DSUBJEKTY_OBJEDNAVKA_OOPP_PFO_OD   = $00000002;
  DSUBJEKTY_OBJEDNAVKA_OOPP_PFO_DO   = $00000004;

type
  TdlgSubjektyObjednavkaOOPPParams = class(TFuncParams)
  public
    fpOOPP: Integer;
    fpOd: TDateTime;
    fpDo: TDateTime;
  end;

type
  TdlgSubjektyObjednavkaOOPP = class(TacDialogOkStorno)
    nbMain: TNotebook;
    pnTop: TPanel;
    lbDatumOd: TLabel;
    lbDatumDo: TLabel;
    edDatumOd: TDateEdit;
    edDatumDo: TDateEdit;
    lbNabizene: TLabel;
    lbVybrane: TLabel;
    lbSkupinyOOPP: TLabel;
    lbPolozkyOOPP: TLabel;
    grSkupinyOOPPNab: TMSDBGrid;
    grSkupinyOOPPVyb: TMSDBGrid;
    grPolozkyOOPPNab: TMSDBGrid;
    grPolozkyOOPPVyb: TMSDBGrid;
    btSkupinyOOPPRem: TButton;
    btSkupinyOOPPAdd: TButton;
    btSkupinyOOPPRemAll: TButton;
    btSkupinyOOPPAddAll: TButton;
    btPolozkyOOPPRem: TButton;
    btPolozkyOOPPAdd: TButton;
    btPolozkyOOPPRemAll: TButton;
    btPolozkyOOPPAddAll: TButton;
    qrSkupinyOOPPNab: TOraQuery;
    qrPolozkyOOPPNab: TOraQuery;
    dsSkupinyOOPPNab: TOraDataSource;
    dsSkupinyOOPPVyb: TOraDataSource;
    dsPolozkyOOPPNab: TOraDataSource;
    lbNabizene2: TLabel;
    lbVybrane2: TLabel;
    lbSkupinyStej: TLabel;
    lbPolozkyStej: TLabel;
    grStejnokrojeNab: TMSDBGrid;
    grStejnokrojeVyb: TMSDBGrid;
    grPolozkyStejNab: TMSDBGrid;
    grPolozkyStejVyb: TMSDBGrid;
    btSkupinyStejRem: TButton;
    btSkupinyStejAdd: TButton;
    btSkupinyStejRemAll: TButton;
    btSkupinyStejAddAll: TButton;
    btPolozkyStejRem: TButton;
    btPolozkyStejAdd: TButton;
    btPolozkyStejRemAll: TButton;
    btPolozkyStejAddAll: TButton;
    qrSkupinyOOPPVyb: TOraQuery;
    qrStejnokrojeNab: TOraQuery;
    qrPolozkyStejNab: TOraQuery;
    dsPolozkyStejNab: TOraDataSource;
    dsStejnokrojeNab: TOraDataSource;
    qrSkupinyOOPPNabKOD: TWideStringField;
    qrSkupinyOOPPNabNAZEV: TWideStringField;
    qrPolozkyOOPPNabKOD_SKUPINY: TWideStringField;
    qrPolozkyOOPPNabID: TIntegerField;
    qrPolozkyOOPPNabNAZEV: TWideStringField;
    qrPolozkyOOPPNabVYNASECI_DOBA: TIntegerField;
    qrPolozkyOOPPNabCENA: TFloatField;
    qrPolozkyOOPPNabPRO_ZENY: TIntegerField;
    qrPolozkyStejNabKOD_STEJNOKROJE: TWideStringField;
    qrPolozkyStejNabID: TIntegerField;
    qrPolozkyStejNabNAZEV: TWideStringField;
    qrPolozkyStejNabVYNASECI_DOBA: TIntegerField;
    qrPolozkyStejNabCENA: TFloatField;
    qrPolozkyStejNabPRO_ZENY: TIntegerField;
    qrStejnokrojeNabKOD: TWideStringField;
    qrStejnokrojeNabNAZEV: TWideStringField;
    qrStejnokrojeVyb: TOraQuery;
    dsStejnokrojeVyb: TOraDataSource;
    qrPolozkyStejVyb: TOraQuery;
    dsPolozkyStejVyb: TOraDataSource;
    qrPolozkyOOPPVyb: TOraQuery;
    dsPolozkyOOPPVyb: TOraDataSource;
    qrSkupinyOOPPVybKOD: TWideStringField;
    qrSkupinyOOPPVybNAZEV: TWideStringField;
    qrStejnokrojeVybKOD: TWideStringField;
    qrStejnokrojeVybNAZEV: TWideStringField;
    qrPolozkyStejVybKOD_STEJNOKROJE: TWideStringField;
    qrPolozkyStejVybID: TIntegerField;
    qrPolozkyStejVybNAZEV: TWideStringField;
    qrPolozkyStejVybVYNASECI_DOBA: TIntegerField;
    qrPolozkyStejVybCENA: TFloatField;
    qrPolozkyStejVybPRO_ZENY: TIntegerField;
    qrPolozkyOOPPVybKOD_SKUPINY: TWideStringField;
    qrPolozkyOOPPVybID: TIntegerField;
    qrPolozkyOOPPVybNAZEV: TWideStringField;
    qrPolozkyOOPPVybVYNASECI_DOBA: TIntegerField;
    qrPolozkyOOPPVybCENA: TFloatField;
    qrPolozkyOOPPVybPRO_ZENY: TIntegerField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrPolozkyStejNabPRO_ZENYGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure btSkupinyOOPPAddClick(Sender: TObject);
    procedure btSkupinyOOPPAddAllClick(Sender: TObject);
    procedure grSkupinyOOPPNabDblClick(Sender: TObject);
    procedure btSkupinyOOPPRemClick(Sender: TObject);
    procedure btSkupinyOOPPRemAllClick(Sender: TObject);
    procedure grSkupinyOOPPVybDblClick(Sender: TObject);
    procedure btPolozkyOOPPAddClick(Sender: TObject);
    procedure btPolozkyOOPPAddAllClick(Sender: TObject);
    procedure grPolozkyOOPPNabDblClick(Sender: TObject);
    procedure btPolozkyOOPPRemClick(Sender: TObject);
    procedure btPolozkyOOPPRemAllClick(Sender: TObject);
    procedure grPolozkyOOPPVybDblClick(Sender: TObject);
    procedure btSkupinyStejAddClick(Sender: TObject);
    procedure btSkupinyStejAddAllClick(Sender: TObject);
    procedure grStejnokrojeNabDblClick(Sender: TObject);
    procedure btSkupinyStejRemClick(Sender: TObject);
    procedure btSkupinyStejRemAllClick(Sender: TObject);
    procedure grStejnokrojeVybDblClick(Sender: TObject);
    procedure btPolozkyStejAddClick(Sender: TObject);
    procedure btPolozkyStejAddAllClick(Sender: TObject);
    procedure grPolozkyStejNabDblClick(Sender: TObject);
    procedure btPolozkyStejRemClick(Sender: TObject);
    procedure btPolozkyStejRemAllClick(Sender: TObject);
    procedure grPolozkyStejVybDblClick(Sender: TObject);
    procedure edDatumOdChange(Sender: TObject);
  private
    FOOPP: Integer;

    procedure EnableOK;
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgSubjektyObjednavkaOOPP: TdlgSubjektyObjednavkaOOPP;

function dlgSubjektyObjednavkaOOPPExecModal(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

Uses Tools, Utils, uStoredProcs;

Const cMuz_Zena: array[0..1] of string = ('Muž', 'Žena');

function dlgSubjektyObjednavkaOOPPExecModal(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektyObjednavkaOOPP, dlgSubjektyObjednavkaOOPP, true);

  with dlgSubjektyObjednavkaOOPP do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.FormShow(Sender: TObject);
begin
  inherited;
  FOOPP:=1;
  if Assigned(Params) then
  with TdlgSubjektyObjednavkaOOPPParams(Params) do
  begin
    if FlagIsSet(DSUBJEKTY_OBJEDNAVKA_OOPP_PFI_OOPP) then FOOPP:=fpOOPP;
  end;

  DestroySessionid('SESSIONID_OOPP_STEJNOKROJE');
  
  if FOOPP=1 then
  begin
    nbMain.ActivePage:='OOPP';
    dlgSubjektyObjednavkaOOPP.Caption:='Objednávka OOPP';

    qrSkupinyOOPPNab.Close;
    qrSkupinyOOPPNab.Open;
    qrSkupinyOOPPVyb.Close;
    qrSkupinyOOPPVyb.Open;
    qrPolozkyOOPPNab.Close;
    qrPolozkyOOPPNab.Open;
    qrPolozkyOOPPVyb.Close;
    qrPolozkyOOPPVyb.Open;
  end
  else
  begin
    nbMain.ActivePage:='Stejnokroje';
    dlgSubjektyObjednavkaOOPP.Caption:='Objednávka stejnokroje';

    qrStejnokrojeNab.Close;
    qrStejnokrojeNab.Open;
    qrStejnokrojeVyb.Close;
    qrStejnokrojeVyb.Open;
    qrPolozkyStejNab.Close;
    qrPolozkyStejNab.Open;
    qrPolozkyStejVyb.Close;
    qrPolozkyStejVyb.Open;
  end;
  EnableOK;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  qrSkupinyOOPPNab.Close;
  qrSkupinyOOPPVyb.Close;
  qrPolozkyOOPPNab.Close;
  qrPolozkyOOPPVyb.Close;
  qrStejnokrojeNab.Close;
  qrStejnokrojeVyb.Close;
  qrPolozkyStejNab.Close;
  qrPolozkyStejVyb.Close;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.qrPolozkyStejNabPRO_ZENYGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := cMuz_Zena[Sender.AsInteger];
end;

// ***************************************************************************
function PridatSkupinuOOPP(D : TDataSet) : boolean;
begin
  with dlgSubjektyObjednavkaOOPP do
  begin
    ExecQuery('INSERT INTO SESSIONID_OOPP_STEJNOKROJE(KOD) VALUES('+Q(qrSkupinyOOPPNabKOD.AsString)+')');
  end;
  result:=True;
end;

// ***************************************************************************
function OdebratSkupinuOOPP(D : TDataSet) : boolean;
begin
  with dlgSubjektyObjednavkaOOPP do
  begin
    ExecQuery('DELETE SESSIONID_OOPP_STEJNOKROJE WHERE SESSIONID=USERENV(''SESSIONID'') AND KOD='+Q(qrSkupinyOOPPVybKOD.AsString));
  end;
  result:=True;
end;

// ***************************************************************************
function PridatPolSkupinyOOPP(D : TDataSet) : boolean;
begin
  with dlgSubjektyObjednavkaOOPP do
  begin
    ExecQuery('INSERT INTO SESSIONID_OOPP_STEJNOKROJE(ID_POL) VALUES('+qrPolozkyOOPPNabID.AsString+')');
  end;
  result:=True;
end;

// ***************************************************************************
function OdebratPolSkupinyOOPP(D : TDataSet) : boolean;
begin
  with dlgSubjektyObjednavkaOOPP do
  begin
    ExecQuery('DELETE SESSIONID_OOPP_STEJNOKROJE WHERE SESSIONID=USERENV(''SESSIONID'') AND ID_POL='+qrPolozkyOOPPVybID.AsString);
  end;
  result:=True;
end;

// ***************************************************************************
function PridatStejnokroj(D : TDataSet) : boolean;
begin
  with dlgSubjektyObjednavkaOOPP do
  begin
    ExecQuery('INSERT INTO SESSIONID_OOPP_STEJNOKROJE(KOD) VALUES('+Q(qrStejnokrojeNabKOD.AsString)+')');
  end;
  result:=True;
end;

// ***************************************************************************
function OdebratStejnokroj(D : TDataSet) : boolean;
begin
  with dlgSubjektyObjednavkaOOPP do
  begin
    ExecQuery('DELETE SESSIONID_OOPP_STEJNOKROJE WHERE SESSIONID=USERENV(''SESSIONID'') AND KOD='+Q(qrStejnokrojeVybKOD.AsString));
  end;
  result:=True;
end;

// ***************************************************************************
function PridatPolStejnokrojeOOPP(D : TDataSet) : boolean;
begin
  with dlgSubjektyObjednavkaOOPP do
  begin
    ExecQuery('INSERT INTO SESSIONID_OOPP_STEJNOKROJE(ID_POL) VALUES('+qrPolozkyStejNabID.AsString+')');
  end;
  result:=True;
end;

// ***************************************************************************
function OdebratPolStejnokrojeOOPP(D : TDataSet) : boolean;
begin
  with dlgSubjektyObjednavkaOOPP do
  begin
    ExecQuery('DELETE SESSIONID_OOPP_STEJNOKROJE WHERE SESSIONID=USERENV(''SESSIONID'') AND ID_POL='+qrPolozkyStejVybID.AsString);
  end;
  result:=True;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btSkupinyOOPPAddClick(
  Sender: TObject);
begin
  if HasData(qrSkupinyOOPPNab) then
  try
    grSkupinyOOPPNab.DoWithSelected(PridatSkupinuOOPP);
  finally
    RefreshQuery(qrSkupinyOOPPNab);
    RefreshQuery(qrSkupinyOOPPVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btSkupinyOOPPAddAllClick(
  Sender: TObject);
begin
  if HasData(qrSkupinyOOPPNab) then
  try
    grSkupinyOOPPNab.SelectAll(True);
    grSkupinyOOPPNab.DoWithSelected(PridatSkupinuOOPP);
  finally
    RefreshQuery(qrSkupinyOOPPNab);
    RefreshQuery(qrSkupinyOOPPVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.grSkupinyOOPPNabDblClick(
  Sender: TObject);
begin
  btSkupinyOOPPAdd.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btSkupinyOOPPRemClick(
  Sender: TObject);
begin
  if HasData(qrSkupinyOOPPVyb) then
  try
    grSkupinyOOPPVyb.DoWithSelected(OdebratSkupinuOOPP);
  finally
    RefreshQuery(qrSkupinyOOPPNab);
    RefreshQuery(qrSkupinyOOPPVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btSkupinyOOPPRemAllClick(
  Sender: TObject);
begin
  if HasData(qrSkupinyOOPPVyb) then
  try
    grSkupinyOOPPVyb.SelectAll(True);
    grSkupinyOOPPVyb.DoWithSelected(OdebratSkupinuOOPP);
  finally
    RefreshQuery(qrSkupinyOOPPNab);
    RefreshQuery(qrSkupinyOOPPVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.grSkupinyOOPPVybDblClick(
  Sender: TObject);
begin
  btSkupinyOOPPRem.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btPolozkyOOPPAddClick(
  Sender: TObject);
begin
  if HasData(qrPolozkyOOPPNab) then
  try
    grPolozkyOOPPNab.DoWithSelected(PridatPolSkupinyOOPP);
  finally
    RefreshQuery(qrPolozkyOOPPNab);
    RefreshQuery(qrPolozkyOOPPVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btPolozkyOOPPAddAllClick(
  Sender: TObject);
begin
  if HasData(qrPolozkyOOPPNab) then
  try
    grPolozkyOOPPNab.SelectAll(True);
    grPolozkyOOPPNab.DoWithSelected(PridatPolSkupinyOOPP);
  finally
    RefreshQuery(qrPolozkyOOPPNab);
    RefreshQuery(qrPolozkyOOPPVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.grPolozkyOOPPNabDblClick(
  Sender: TObject);
begin
  btPolozkyOOPPAdd.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btPolozkyOOPPRemClick(
  Sender: TObject);
begin
  if HasData(qrPolozkyOOPPVyb) then
  try
    grPolozkyOOPPVyb.DoWithSelected(OdebratPolSkupinyOOPP);
  finally
    RefreshQuery(qrPolozkyOOPPNab);
    RefreshQuery(qrPolozkyOOPPVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btPolozkyOOPPRemAllClick(
  Sender: TObject);
begin
  if HasData(qrPolozkyOOPPVyb) then
  try
    grPolozkyOOPPVyb.SelectAll(True);
    grPolozkyOOPPVyb.DoWithSelected(OdebratPolSkupinyOOPP);
  finally
    RefreshQuery(qrPolozkyOOPPNab);
    RefreshQuery(qrPolozkyOOPPVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.grPolozkyOOPPVybDblClick(
  Sender: TObject);
begin
  btPolozkyOOPPRem.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btSkupinyStejAddClick(
  Sender: TObject);
begin
  if HasData(qrStejnokrojeNab) then
  try
    grStejnokrojeNab.DoWithSelected(PridatStejnokroj);
  finally
    RefreshQuery(qrStejnokrojeNab);
    RefreshQuery(qrStejnokrojeVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btSkupinyStejAddAllClick(
  Sender: TObject);
begin
  if HasData(qrStejnokrojeNab) then
  try
    grStejnokrojeNab.SelectAll(True);
    grStejnokrojeNab.DoWithSelected(PridatStejnokroj);
  finally
    RefreshQuery(qrStejnokrojeNab);
    RefreshQuery(qrStejnokrojeVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.grStejnokrojeNabDblClick(
  Sender: TObject);
begin
  btSkupinyStejAdd.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btSkupinyStejRemClick(
  Sender: TObject);
begin
  if HasData(qrStejnokrojeVyb) then
  try
    grStejnokrojeVyb.DoWithSelected(OdebratStejnokroj);
  finally
    RefreshQuery(qrStejnokrojeNab);
    RefreshQuery(qrStejnokrojeVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btSkupinyStejRemAllClick(
  Sender: TObject);
begin
  if HasData(qrStejnokrojeVyb) then
  try
    grStejnokrojeVyb.SelectAll(True);
    grStejnokrojeVyb.DoWithSelected(OdebratStejnokroj);
  finally
    RefreshQuery(qrStejnokrojeNab);
    RefreshQuery(qrStejnokrojeVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.grStejnokrojeVybDblClick(
  Sender: TObject);
begin
  btSkupinyStejRem.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btPolozkyStejAddClick(
  Sender: TObject);
begin
  if HasData(qrPolozkyStejNab) then
  try
    grPolozkyStejNab.DoWithSelected(PridatPolStejnokrojeOOPP);
  finally
    RefreshQuery(qrPolozkyStejNab);
    RefreshQuery(qrPolozkyStejVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btPolozkyStejAddAllClick(
  Sender: TObject);
begin
  if HasData(qrPolozkyStejNab) then
  try
    grPolozkyStejNab.SelectAll(True);
    grPolozkyStejNab.DoWithSelected(PridatPolStejnokrojeOOPP);
  finally
    RefreshQuery(qrPolozkyStejNab);
    RefreshQuery(qrPolozkyStejVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.grPolozkyStejNabDblClick(
  Sender: TObject);
begin
  btPolozkyStejAdd.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btPolozkyStejRemClick(
  Sender: TObject);
begin
  if HasData(qrPolozkyStejVyb) then
  try
    grPolozkyStejVyb.DoWithSelected(OdebratPolStejnokrojeOOPP);
  finally
    RefreshQuery(qrPolozkyStejNab);
    RefreshQuery(qrPolozkyStejVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.btPolozkyStejRemAllClick(
  Sender: TObject);
begin
  if HasData(qrPolozkyStejVyb) then
  try
    grPolozkyStejVyb.SelectAll(True);
    grPolozkyStejVyb.DoWithSelected(OdebratPolStejnokrojeOOPP);
  finally
    RefreshQuery(qrPolozkyStejNab);
    RefreshQuery(qrPolozkyStejVyb);
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.grPolozkyStejVybDblClick(
  Sender: TObject);
begin
  btPolozkyStejRem.Click;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgSubjektyObjednavkaOOPPParams(Params) do
  begin
    if (fpFlags and DSUBJEKTY_OBJEDNAVKA_OOPP_PFO_OD) <> 0 then fpOd := edDatumOd.Date;
    if (fpFlags and DSUBJEKTY_OBJEDNAVKA_OOPP_PFO_DO) <> 0 then fpDo := edDatumDo.Date;
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.EnableOK;
begin
  btOK.Enabled:=(edDatumOd.Text<>'  .  .    ') and (edDatumDo.Text<>'  .  .    ');
end;

// ***************************************************************************
procedure TdlgSubjektyObjednavkaOOPP.edDatumOdChange(Sender: TObject);
begin
  EnableOK;
end;

end.
