unit DVolbaOverovanychZarizeni;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, Grids, NDBGrids, MSGrid,
  Db, Ora, udmODAC, UCLTypes, NotiaDBComboBox, Mask, rxToolEdit, RXDBCtrl,
  NDBCtrls, EditEx;

const
  FOVEROVANE_ZARIZENI_PFI_ID_LETU      = $00000001;

type
  TdlgVolbaOverovanychZarizeniParams = class(TFuncParams)
  public
    fpID_LETU: Integer;
  end;

type
  TdlgVolbaOverovanychZarizeni = class(TacDialogOkStorno)
    lbLet: TLabel;
    lbCisloLetu: TLabel;
    grPridane: TMSDBGrid;
    qrPridane: TOraQuery;
    dsPridane: TOraDataSource;
    btDruhLO: TButton;
    btLetiste: TButton;
    btIdentifikator: TButton;
    grVyber: TMSDBGrid;
    btPridat: TButton;
    btHledat: TButton;
    lbPridane: TLabel;
    lbMozne: TLabel;
    qrVyber: TOraQuery;
    dsVyber: TOraDataSource;
    qrVyberIDENTIFIKACE: TWideStringField;
    qrPridaneID_EVIDENCE_LPZ: TIntegerField;
    btVse: TButton;
    cbIdentifikator: TComboBox;
    cbDruhLPZ: TComboBox;
    cbLetiste: TComboBox;
    qrPridaneID: TIntegerField;
    qrPridaneID_PROTOKOLU: TIntegerField;
    qrPridaneCISLO_PROTOKOLU: TSmallintField;
    qrPridaneID_LETU: TIntegerField;
    qrPridanePLATNOST: TDateTimeField;
    qrPridanePOZNAMKA: TWideStringField;
    qrPridaneCENA: TWideStringField;
    qrPridaneZAPSAL: TWideStringField;
    qrPridaneZAPSANO: TDateTimeField;
    qrPridaneMERITEL: TIntegerField;
    qrPridaneLETISTE: TIntegerField;
    qrPridaneDRUH_LPZ: TIntegerField;
    qrPridaneDATUM_LETU: TDateTimeField;
    qrPridaneVYSLEDEK_MERENI_LO: TIntegerField;
    qrPridaneVYSLEDEK_MERENI_LPZ: TIntegerField;
    qrPridaneVYSLEDEK_MERENI: TWideStringField;
    btOdebrat: TButton;
    qrVyberID: TIntegerField;
    qrPridaneDRUH_MERENI: TIntegerField;
    qrPridaneKLASIFIKACE_LO: TIntegerField;
    qrPridaneKLASIFIKACE_LPZ: TIntegerField;
    procedure FormShow(Sender: TObject);
    procedure qrPridaneID_EVIDENCE_LPZGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qrPridaneID_EVIDENCE_LPZSetText(Sender: TField;
      const Text: String);
    procedure btVseClick(Sender: TObject);
    procedure btHledatClick(Sender: TObject);
    procedure btIdentifikatorClick(Sender: TObject);
    procedure btDruhLOClick(Sender: TObject);
    procedure btLetisteClick(Sender: TObject);
    procedure btPridatClick(Sender: TObject);
    procedure btOdebratClick(Sender: TObject);
    procedure grVyberDblClick(Sender: TObject);
    procedure qrPridaneVYSLEDEK_MERENI_LOGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qrPridaneVYSLEDEK_MERENI_LOSetText(Sender: TField;
      const Text: String);
    procedure qrPridaneVYSLEDEK_MERENI_LPZGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qrPridaneVYSLEDEK_MERENI_LPZSetText(Sender: TField;
      const Text: String);
    procedure qrPridaneMERITELGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrPridaneMERITELSetText(Sender: TField; const Text: String);
    procedure qrPridaneKLASIFIKACE_LPZGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure qrPridaneKLASIFIKACE_LPZSetText(Sender: TField;
      const Text: String);
    procedure qrPridaneAfterPost(DataSet: TDataSet);
    procedure qrPridaneAfterEdit(DataSet: TDataSet);
    procedure grPridaneDblClick(Sender: TObject);
    procedure qrPridaneAfterOpen(DataSet: TDataSet);
    procedure qrVyberAfterOpen(DataSet: TDataSet);
    procedure grPridaneGetRowColor(var Color, FontColor: Integer);
    procedure qrPridaneID_LETUSetText(Sender: TField; const Text: String);
  private
    FIDLetu: Integer;

    procedure InitIdentifikatorCombo;
    procedure InitDruhLPZCombo;
    procedure InitLetisteCombo;
    procedure InitSelectors;
  public
    { Public declarations }
  end;

var
  dlgVolbaOverovanychZarizeni: TdlgVolbaOverovanychZarizeni;

const DefaulTOraQueryNaPridani: String='SELECT IDENTIFIKACE,ID FROM EVIDENCE_LPZ WHERE ID NOT IN (SELECT ID_EVIDENCE_LPZ  FROM MERENI WHERE ID_LETU=:ID)';
const IdentifikatorQueryNaPridani: String='SELECT IDENTIFIKACE,ID FROM EVIDENCE_LPZ WHERE IDENTIFIKACE=:IDENTIFIK';
const DruhLO_LetisteQueryNaPridani: String='SELECT IDENTIFIKACE,ID FROM EVIDENCE_LPZ WHERE (DRUH_LPZ=:DRUH OR :DRUH IS NULL) AND (LETISTE=:LET OR :LET IS NULL)';

function dlgVolbaOverovanychZarizeniExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

Uses Tools, Caches, Queries, FEvidenceLPZ, FDruhyLPZ, FProvozovateleLetist, Utils,
     DProtokolyMereni, uObjUtils;

function dlgVolbaOverovanychZarizeniExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgVolbaOverovanychZarizeni, dlgVolbaOverovanychZarizeni, true); {1}

  with dlgVolbaOverovanychZarizeni do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.FormShow(Sender: TObject);
begin
  inherited;
  FIDLetu:=-1;

  if Assigned(Params) then
  with TdlgVolbaOverovanychZarizeniParams(Params) do
  begin
    if (fpFlags and FOVEROVANE_ZARIZENI_PFI_ID_LETU) <> 0 then
    begin
      FIDLetu:=fpID_LETU;

      lbCisloLetu.Caption := IntToStr(FIDLetu);
      qrPridane.Close;
      qrPridane.ParamByName('ID').AsInteger:=FIDLetu;
      qrPridane.Open;

      qrVyber.Close;
      qrVyber.ParamByName('ID').AsInteger:=FIDLetu;
      qrVyber.Open;
    end;
  end;

  InitSelectors;
  cbIdentifikator.ItemIndex:=-1;
  cbDruhLPZ.ItemIndex:=-1;
  cbLetiste.ItemIndex:=-1;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneID_EVIDENCE_LPZGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedEVIDENCE_LPZ( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneID_EVIDENCE_LPZSetText(
  Sender: TField; const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedEVIDENCE_LPZnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.btVseClick(Sender: TObject);
begin
  qrVyber.Close;
  qrVyber.SQL.Clear;
  qrVyber.SQL.Add(DefaulTOraQueryNaPridani);
  qrVyber.ParamByName('ID').AsInteger:=FIDLetu;
  qrVyber.Open;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.InitIdentifikatorCombo;
begin
  InitComboSQL(cbIdentifikator,'SELECT IDENTIFIKACE FROM EVIDENCE_LPZ WHERE ID NOT IN '+
               '(SELECT ID_EVIDENCE_LPZ FROM MERENI WHERE ID_LETU='+IntToStr(FIDLetu)+
               ') ORDER BY IDENTIFIKACE');
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.InitDruhLPZCombo;
begin
  InitComboSQL(cbDruhLPZ, QS_Druhy_LPZ_Combo);
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.InitLetisteCombo;
begin
  InitComboSQL(cbLetiste, QS_Provozovatele_Letist_Combo);
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.btHledatClick(Sender: TObject);
begin
  inherited;
  qrVyber.Close;

  if cbIdentifikator.Text<>'' then
  begin
    qrVyber.SQL.Clear;
    qrVyber.SQL.Add(IdentifikatorQueryNaPridani);

    qrVyber.ParamByName('IDENTIFIK').AsString:=cbIdentifikator.Text;
    qrVyber.Open;
  end
  else
  if (cbDruhLPZ.Text<>'') or (cbLetiste.Text<>'') then
  begin
    qrVyber.SQL.Clear;
    qrVyber.SQL.Add(DruhLO_LetisteQueryNaPridani);

    qrVyber.Params.ParamByName('DRUH').DataType:=ftInteger;
    qrVyber.Params.ParamByName('LET').DataType:=ftInteger;

    if cbDruhLPZ.ItemIndex<>-1 then
      qrVyber.ParamByName('DRUH').AsInteger:=CachedDRUHY_LPZnum(cbDruhLPZ.Text);

    if cbLetiste.ItemIndex<>-1 then
      qrVyber.ParamByName('LET').AsInteger:=CachedPROVOZOVATELE_LETISTnum(cbLetiste.Text);
    qrVyber.Open;
  end
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.btIdentifikatorClick(
  Sender: TObject);
var
  FormIOParams: TfrmEvidenceLPZParams;
begin
  FormIOParams := TfrmEvidenceLPZParams.Create( FEVIDENCE_LPZ_PFO_IDENTIFIKACE,
                                                [], InitIdentifikatorCombo );
  try
    FormIOParams.fpUseTemporaryQuery := True;
    FormIOParams.fpReadOnlyTemporaryQuery := True;
    FormIOParams.fpTemporaryQuery := 'SELECT * FROM EVIDENCE_LPZ WHERE ID NOT IN (SELECT ID_EVIDENCE_LPZ '+
                                     'FROM MERENI WHERE ID_LETU='+IntToStr(FIDLetu)+')';

    if frmEvidenceLPZExec(FormIOParams, True) then
    begin
      cbIdentifikator.ItemIndex := cbIdentifikator.Items.IndexOf(FormIOParams.fpIdentifikace);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.btDruhLOClick(Sender: TObject);
var FormIOParams: TfrmDruhyLPZParams;
begin
  FormIOParams := TfrmDruhyLPZParams.Create(FDRUHY_LPZ_PFO_ID, [], InitDruhLPZCombo);
  try
    if frmDruhyLPZExec(FormIOParams, true) then
    begin
      cbDruhLPZ.ItemIndex := cbDruhLPZ.Items.IndexOf(CachedDRUHY_LPZ(FormIOParams.fpID));
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.btLetisteClick(Sender: TObject);
var FormIOParams: TfrmProvozovateleLetistParams;
begin
  FormIOParams := TfrmProvozovateleLetistParams.Create(FPROVOZOVATELE_LETIST_PFO_ID, [], InitLetisteCombo);
  try
    if frmProvozovateleLetistExec(FormIOParams, true) then
    begin
      cbLetiste.ItemIndex := cbLetiste.Items.IndexOf(CachedPROVOZOVATELE_LETIST(FormIOParams.fpID));
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.btPridatClick(Sender: TObject);
begin
  inherited;
  if HasData(qrVyber) then
  begin
    if SelectInt(Format('SELECT COUNT(*) FROM MERENI WHERE ID_LETU=%d AND ID_EVIDENCE_LPZ=%d',
                        [FIDLetu,qrVyberID.AsInteger]))>0 then
    begin
      ErrorMsg('Toto zaøízení nelze pøidat k danému letu!');
      grVyber.SetFocus;
      Abort;
    end;

    ExecQuery(Format('INSERT INTO MERENI(ID_LETU,ID_EVIDENCE_LPZ) VALUES(%d,%d)',
                    [FIDLetu,qrVyberID.AsInteger]));

    cbIdentifikator.ItemIndex:=-1;
    InitSelectors;
    RefreshQuery(qrVyber);
    RefreshQuery(qrPridane);
  end;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.InitSelectors;
begin
  InitIdentifikatorCombo;
  InitDruhLPZCombo;
  InitLetisteCombo;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.btOdebratClick(Sender: TObject);
begin
  inherited;
  if HasData(qrPridane) then
  begin
    if Confirm('Opravdu chcete letu odebrat zaøízení " '+
                CachedEVIDENCE_LPZ(qrPridaneID_EVIDENCE_LPZ.AsInteger)+' " ?') then
    begin
      ExecQuery('DELETE MERENI WHERE ID='+qrPridaneID.AsString);
      InitSelectors;
      RefreshQuery(qrVyber);
      RefreshQuery(qrPridane);
    end;
  end;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.grVyberDblClick(Sender: TObject);
begin
  inherited;
  btPridat.Click;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneVYSLEDEK_MERENI_LOGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedDRUHY_LO( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneVYSLEDEK_MERENI_LOSetText(
  Sender: TField; const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedDRUHY_LOnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneVYSLEDEK_MERENI_LPZGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedDRUHY_LPZ( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneVYSLEDEK_MERENI_LPZSetText(
  Sender: TField; const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedDRUHY_LPZnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneMERITELGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedKODY_JMEN( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneMERITELSetText(
  Sender: TField; const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedKODY_JMENnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneKLASIFIKACE_LPZGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedKLASIFIKACE_LPZ( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneKLASIFIKACE_LPZSetText(
  Sender: TField; const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := CachedKLASIFIKACE_LPZnum( Text );
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneAfterPost(
  DataSet: TDataSet);
begin
  inherited;
  RefreshQuery(qrPridane);
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneAfterEdit(
  DataSet: TDataSet);
var
  FormIOParams: TdlgProtokolyMereniParams;
begin
  FormIOParams := TdlgProtokolyMereniParams.Create(DPROTOKOLY_MERENI_PFI_QUERY 
                                                   or DPROTOKOLY_MERENI_PFI_EVID_LPZ_READ_ONLY);
  try
    FormIOParams.fpDataSet := qrPridane;
    if dlgProtokolyMereniExec(FormIOParams) then
    begin
      qrPridane.Post;
    end
    else
      qrPridane.Cancel
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.grPridaneDblClick(Sender: TObject);
begin
  if HasData(qrPridane) then
    qrPridane.Edit;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneAfterOpen(
  DataSet: TDataSet);
begin
  inherited;
  SetControlsReadOnly([btOdebrat],not HasData(qrPridane));
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrVyberAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SetControlsReadOnly([btPridat],not HasData(qrVyber));
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.grPridaneGetRowColor(var Color,
  FontColor: Integer);
begin
  inherited;
  if not qrPridaneID_PROTOKOLU.IsNull then
    Color:=14024665
  else
    Color:=clWindow;
end;

// ..........................................................................
procedure TdlgVolbaOverovanychZarizeni.qrPridaneID_LETUSetText(
  Sender: TField; const Text: String);
begin
  if Trim(Text) = '' then
    Sender.Clear
  else
    Sender.AsInteger := StrToInt(GetComboText(dlgProtokolyMereni.cbIDLetu));
end;

end.
