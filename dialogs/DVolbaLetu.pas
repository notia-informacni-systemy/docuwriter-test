unit DVolbaLetu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, NotiaDBComboBox, Grids,
  NDBGrids, MSGrid, Db, Ora, udmODAC, Mask, rxToolEdit, UCLTypes, DataComboBox,
  DBCtrls, DBAccess, MemDS, NGrids;

type
  TdlgVolbaLetu = class(TacDialogOkStorno)
    lbDatum: TLabel;
    lbZnackaOK: TLabel;
    btLetadlo: TButton;
    btNajdi: TButton;
    grMain: TMSDBGrid;
    qrMaster: TOraQuery;
    dsMaster: TOraDataSource;
    edDatum: TDateEdit;
    cbLetadlo: TComboBox;
    btMereni: TButton;
    qrMasterID_LETU: TIntegerField;
    qrMasterPOZN_ZNACKA: TIntegerField;
    qrMasterTYP_LETADLA: TIntegerField;
    qrMasterPIC: TIntegerField;
    qrMasterF_O: TIntegerField;
    qrMasterINSPEKTOR_1: TIntegerField;
    qrMasterINSPEKTOR_2: TIntegerField;
    qrMasterINSPEKTOR_3: TIntegerField;
    qrMasterTUL_1: TIntegerField;
    qrMasterTUL_2: TIntegerField;
    qrMasterPAX: TSmallintField;
    qrMasterVOLACI_ZNACKA: TWideStringField;
    qrMasterDATUM: TDateTimeField;
    qrMasterZARIZENI: TWideStringField;
    qrMereni: TOraQuery;
    qrMereniID: TIntegerField;
    qrMereniID_PROTOKOLU: TIntegerField;
    qrMereniCISLO_PROTOKOLU: TSmallintField;
    qrMereniID_LETU: TIntegerField;
    qrMereniID_EVIDENCE_LPZ: TIntegerField;
    qrMereniDRUH_MERENI: TIntegerField;
    qrMereniPLATNOST: TDateTimeField;
    qrMereniPOZNAMKA: TWideStringField;
    qrMereniCENA: TWideStringField;
    qrMereniZAPSAL: TWideStringField;
    qrMereniZAPSANO: TDateTimeField;
    qrMereniMERITEL: TIntegerField;
    qrMereniLETISTE: TIntegerField;
    qrMereniDRUH_LPZ: TIntegerField;
    qrMereniDATUM_LETU: TDateTimeField;
    qrMereniVYSLEDEK_MERENI_LO: TIntegerField;
    qrMereniVYSLEDEK_MERENI_LPZ: TIntegerField;
    qrMereniVYSLEDEK_MERENI: TWideStringField;
    qrMereniKLASIFIKACE_LO: TIntegerField;
    qrMereniKLASIFIKACE_LPZ: TIntegerField;
    qrMasterID_LET_UCL: TIntegerField;
    Navigator: TDBNavigator;
    qrMasterCISLO_STRANKY: TFloatField;
    procedure FormShow(Sender: TObject);
    procedure btNajdiClick(Sender: TObject);
    procedure btLetadloClick(Sender: TObject);
    procedure btMereniClick(Sender: TObject);
    procedure qrMasterPICGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMasterPICSetText(Sender: TField; const Text: String);
    procedure qrMasterAfterOpen(DataSet: TDataSet);
    procedure qrMasterPOZN_ZNACKAGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMasterPOZN_ZNACKASetText(Sender: TField;
      const Text: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrMasterAfterClose(DataSet: TDataSet);
    procedure qrMereniAfterInsert(DataSet: TDataSet);
    procedure qrMereniAfterPost(DataSet: TDataSet);
    procedure qrMereniNewRecord(DataSet: TDataSet);
    procedure qrMereniID_EVIDENCE_LPZSetText(Sender: TField;
      const Text: String);
    procedure qrMereniDRUH_MERENISetText(Sender: TField;
      const Text: String);
    procedure qrMereniKLASIFIKACE_LPZSetText(Sender: TField;
      const Text: String);
    procedure qrMereniID_EVIDENCE_LPZGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qrMereniDRUH_MERENIGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMereniKLASIFIKACE_LPZGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qrMasterBeforePost(DataSet: TDataSet);
    procedure qrMasterID_LET_UCLGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMasterID_LET_UCLSetText(Sender: TField;
      const Text: String);
    procedure qrMereniID_LETUSetText(Sender: TField; const Text: String);
  private
    FNovaPolozkaMereni: Boolean;

    procedure InitLetadloCombo;
    procedure Enabluj;
    Procedure NaplnSlouceGridu;
  public
    { Public declarations }
  end;

var
  dlgVolbaLetu: TdlgVolbaLetu;

function dlgVolbaLetuExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

Uses Tools, Queries, Utils, Caches, uStoredProcs, FLetadlaUCL,
     DVolbaOverovanychZarizeni, uObjUtils, DProtokolyMereni, GridUtl;

const Primary_SQL = 'SELECT * FROM DENIK_LETADLA_LETADLA_UCL';

function dlgVolbaLetuExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgVolbaLetu, dlgVolbaLetu, true); {1}

  with dlgVolbaLetu do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

{ TdlgVolbaLetu }

// ..........................................................................
procedure TdlgVolbaLetu.InitLetadloCombo;
begin
  InitComboSQL(cbLetadlo, QS_LetadlaUCL_Znacka_Combo);
end;

// ..........................................................................
procedure TdlgVolbaLetu.FormShow(Sender: TObject);
begin
  inherited;
  InitLetadloCombo;
  cbLetadlo.ItemIndex:=-1;
  edDatum.Date:=Date;
  NaplnSlouceGridu;
  qrMaster.Close;
  qrMaster.SQL.Text:=Primary_SQL;
  qrMaster.Open;
end;

// ..........................................................................
procedure TdlgVolbaLetu.btNajdiClick(Sender: TObject);
var SQL: String;
begin
  if cbLetadlo.Text='' then
  begin
    ErrorMsg('Vyplòte poznávací znaèku letadla!');
    cbLetadlo.SetFocus;
    Abort;
  end;

  if edDatum.Text='  .  .    ' then
  begin
    ErrorMsg('Vyplòte datum!');
    edDatum.SetFocus;
    Abort;
  end;

  SQL:=Primary_SQL+Format(' WHERE POZN_ZNACKA=%d AND DATUM=%s',
                  [CachedLETADLAnum(cbLetadlo.Text),Q(edDatum.Text)]);
  qrMaster.Close;
  qrMaster.SQL.Text:=SQL;
  qrMaster.Open;
end;

// ..........................................................................
procedure TdlgVolbaLetu.btLetadloClick(Sender: TObject);
var FormIOParams: TfrmLetadlaUCLParams;
begin
  FormIOParams := TfrmLetadlaUCLParams.Create(FLETADLA_UCL_PFO_ID, [], InitLetadloCombo);
  try
    if frmLetadlaUCLExec(FormIOParams, true) then
    begin
      cbLetadlo.ItemIndex := cbLetadlo.Items.IndexOf(CachedLETADLA(CachedLETALA_UCL_POZN_ZNACKA(FormIOParams.fpID)));
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgVolbaLetu.btMereniClick(Sender: TObject);
//var
//  FormIOParams: TdlgVolbaOverovanychZarizeniParams;
begin
  qrMereni.Insert;
{
  if HasData(qrMaster) then
  begin
    FormIOParams := TdlgVolbaOverovanychZarizeniParams.Create(FOVEROVANE_ZARIZENI_PFI_ID_LETU);
    try
      FormIOParams.fpID_LETU := qrMasterID_LETU.AsInteger;
      if dlgVolbaOverovanychZarizeniExec(FormIOParams) then
        RefreshQuery(qrMaster);
    finally
      FormIOParams.Free;
    end;
  end;
}  
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterPICGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedKODY_JMEN( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterPICSetText(Sender: TField;
  const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedKODY_JMENnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaLetu.Enabluj;
begin
  SetControlsReadOnly([btMereni],not HasData(qrMaster));
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  Enabluj;
  qrMereni.Open;
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterPOZN_ZNACKAGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedLETADLA( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterPOZN_ZNACKASetText(Sender: TField;
  const Text: String);
begin
  Sender.AsInteger := CachedLETADLAnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaLetu.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  qrMaster.Close;
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterAfterClose(DataSet: TDataSet);
begin
  inherited;
  qrMereni.Close;
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniAfterInsert(DataSet: TDataSet);
var
  FormIOParams: TdlgProtokolyMereniParams;
begin
  FormIOParams := TdlgProtokolyMereniParams.Create(DPROTOKOLY_MERENI_PFI_QUERY or DPROTOKOLY_MERENI_PFO_DALSI);
  try
    FormIOParams.fpDataSet := qrMereni;
    if dlgProtokolyMereniExec(FormIOParams) then
    begin
      FNovaPolozkaMereni:= FormIOParams.fpDalsi;
      qrMereni.Post;
    end
    else
      qrMereni.Cancel
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniAfterPost(DataSet: TDataSet);
begin
  inherited;
  RefreshQuery(qrMaster,qrMasterID_LETU,qrMasterID_LET_UCL);

  if FNovaPolozkaMereni then
    qrMereni.Append;
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniNewRecord(DataSet: TDataSet);
begin
  inherited;
  qrMereniID_LETU.AsInteger:=qrMasterID_LETU.AsInteger;
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniID_EVIDENCE_LPZGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedEVIDENCE_LPZ( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniID_EVIDENCE_LPZSetText(Sender: TField;
  const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedEVIDENCE_LPZnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniDRUH_MERENIGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedDRUHY_LO( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniDRUH_MERENISetText(Sender: TField;
  const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedDRUHY_LOnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniKLASIFIKACE_LPZGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedKLASIFIKACE_LPZ( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniKLASIFIKACE_LPZSetText(Sender: TField;
  const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedKLASIFIKACE_LPZnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterBeforePost(DataSet: TDataSet);
var FLetWasInserting: Boolean;
    _PIC, _F_O, _INSPEKTOR_1, _INSPEKTOR_2, _INSPEKTOR_3: String;
    _CISLO_STRANKY, _ID_LET_UCL: String;
begin
  inherited;
  if qrMaster.State=dsInsert then
    qrMasterID_LETU.AsInteger := Get_Next_Ciselnik_ID;
  FLetWasInserting := qrMaster.State = dsInsert;

  if not qrMasterPIC.IsNull then _PIC:=qrMasterPIC.AsString else _PIC:='NULL';
  if not qrMasterF_O.IsNull then _F_O:=qrMasterF_O.AsString else _F_O:='NULL';
  if not qrMasterINSPEKTOR_1.IsNull then _INSPEKTOR_1:=qrMasterINSPEKTOR_1.AsString else _INSPEKTOR_1:='NULL';
  if not qrMasterINSPEKTOR_2.IsNull then _INSPEKTOR_2:=qrMasterINSPEKTOR_2.AsString else _INSPEKTOR_2:='NULL';
  if not qrMasterINSPEKTOR_3.IsNull then _INSPEKTOR_3:=qrMasterINSPEKTOR_3.AsString else _INSPEKTOR_3:='NULL';
  if not qrMasterCISLO_STRANKY.IsNull then _CISLO_STRANKY:=qrMasterCISLO_STRANKY.AsString else _CISLO_STRANKY:='NULL';
  if not qrMasterID_LET_UCL.IsNull then _ID_LET_UCL:=qrMasterID_LET_UCL.AsString else _ID_LET_UCL:='NULL';

  if FLetWasInserting then
    ExecQuery(Format('INSERT INTO DENIK_LETADLA (ID, PIC, F_O, INSPEKTOR_1, INSPEKTOR_2, INSPEKTOR_3,'+
                     'CISLO_STRANKY, VOLACI_ZNACKA, DATUM, ID_LET_UCL) '+
                     'VALUES (%d, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                     [qrMasterID_LETU.AsInteger, _PIC, _F_O,
                      _INSPEKTOR_1, _INSPEKTOR_2, _INSPEKTOR_3, _CISLO_STRANKY,
                      Q(qrMasterVOLACI_ZNACKA.AsString), Q(qrMasterDATUM.AsString),
                      _ID_LET_UCL]))
  else
    ExecQuery(Format('UPDATE DENIK_LETADLA SET PIC=%s, F_O=%s, INSPEKTOR_1=%s, '+
                     'INSPEKTOR_2=%s, INSPEKTOR_3=%s, '+
                     'CISLO_STRANKY=%s, VOLACI_ZNACKA=%s, DATUM=%s, ID_LET_UCL=%s WHERE ID=%d',
                     [_PIC, _F_O, _INSPEKTOR_1, _INSPEKTOR_2, _INSPEKTOR_3, _CISLO_STRANKY,
                      Q(qrMasterVOLACI_ZNACKA.AsString), Q(qrMasterDATUM.AsString),
                      _ID_LET_UCL, qrMasterID_LETU.AsInteger]));

  RefreshQuery(qrMaster,qrMasterID_LETU,qrMasterID_LET_UCL);
  Abort;
end;

// ..........................................................................
procedure TdlgVolbaLetu.NaplnSlouceGridu;
var p:TStrings;
begin
  p:=grMain.Columns[GetColumnIndex(grMain,'ID_LET_UCL')].PickList;
  p.Clear;
  InitStringListSql(p,QS_LetadlaUCL_Znacka_Combo);

  p:=grMain.Columns[GetColumnIndex(grMain,'PIC')].PickList;
  p.Clear;
  InitStringListSql(p,QS_Kody_Jmen_Combo);

  p:=grMain.Columns[GetColumnIndex(grMain,'F_O')].PickList;
  p.Clear;
  InitStringListSql(p,QS_Kody_Jmen_Combo);

  p:=grMain.Columns[GetColumnIndex(grMain,'INSPEKTOR_1')].PickList;
  p.Clear;
  InitStringListSql(p,QS_Kody_Jmen_Combo);

  p:=grMain.Columns[GetColumnIndex(grMain,'INSPEKTOR_2')].PickList;
  p.Clear;
  InitStringListSql(p,QS_Kody_Jmen_Combo);
  
  p:=grMain.Columns[GetColumnIndex(grMain,'INSPEKTOR_3')].PickList;
  p.Clear;
  InitStringListSql(p,QS_Kody_Jmen_Combo);
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterID_LET_UCLGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedLETADLA(CachedLETALA_UCL_POZN_ZNACKA( Sender.AsInteger ));
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMasterID_LET_UCLSetText(Sender: TField;
  const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedLETADLA_UCL_num( CachedLETADLAnum(Text) );
end;

// ..........................................................................
procedure TdlgVolbaLetu.qrMereniID_LETUSetText(Sender: TField;
  const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := StrToInt(GetComboText(dlgProtokolyMereni.cbIDLetu));
end;

end.
