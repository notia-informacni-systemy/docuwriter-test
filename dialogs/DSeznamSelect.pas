unit DSeznamSelect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  NotiaMagic, ExtCtrls, ToolWin, ComCtrls, DBCtrls, Db,  Ora, udmODAC, NGrids,
  NDBGrids, MSGrid, StdCtrls, Registry, NConsts, ADialog, Buttons, DBAccess,
  MemDS, NotiaImageButton, uDMUcl;

type
  TdlgCRMSeznamSelect = class(TacDialog)
    qrMaster: TOraQuery;
    dsMaster: TOraDataSource;
    Panel1: TPanel;
    nvMaster: TDBNavigator;
    ToolBar2: TToolBar;
    grMaster: TMSDBGrid;
    tbMinus: TNotiaImageButton;
    pnBottom: TPanel;
    btOK: TButton;
    btCancel: TButton;
    procedure grMasterDblClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure qrMasterAfterOpen(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbMinusClick(Sender: TObject);
  private
    FReference: pointer;
    FMultiSelectList: TStringList;
    FMultiSelectFieldName: string;
    procedure SetKeyFieldName(const Value: string);
    function AddToMultiSelectList(D: TDataSet): boolean;
  protected
    fpTemporaryQuery:String;
    fpLookFor:String;
    fpID:String;
    FKeyFieldName: string;
    FMinustable: TStringList;
    function  OdeberPolozku(D:TDataset):boolean;
    procedure VybranePolozkyDoParametru;
    Procedure WMSysCommand(var msg: TMessage); Override;
    procedure LoadData(_Reg: TRegistry);
    procedure SaveData(_Reg: TRegistry);
    function  CopyToTargetList(D: TDataSet): boolean; virtual;
  public
    FPuvCapt:String;
    FSelectedItems:TStringList;
    property KeyFieldName: string read FKeyFieldName write SetKeyFieldName;
    property MultiSelectList: TStringlist read FMultiSelectList write FMultiSelectList;
    procedure FillMultiSelectList(_Grid: TMSDBGrid; _FieldName: string);
    procedure SetCaption(_Capt:String);
    procedure LoadPreferences;
    procedure SavePreferences;
  end;

var
  dlgCRMSeznamSelect: TdlgCRMSeznamSelect;

function dlgSeznamSelectExecute(_TempQuery: string; _ID: string='';
                                _S:TStringList=nil; _KeyFieldName:String='';
                                _Minustable:TStringList=nil;
                                _ShowStorno:boolean=true;
                                _Caption:String=''): string;

implementation

{$R *.DFM}
uses
  Tools, Utils, NParam;

function dlgSeznamSelectExecute(_TempQuery: string; _ID: string='';
                                _S:TStringList=nil; _KeyFieldName:String='';
                                _Minustable:TStringList=nil;
                                _ShowStorno:boolean=true;
                                _Caption:String=''): string;
begin
  try
    Screen.Cursor := crHourGlass;
    PrepareModal(TdlgCRMSeznamSelect, dlgCRMSeznamSelect);
    dlgCRMSeznamSelect.fpTemporaryQuery:='SELECT * FROM ('+_TempQuery+')';
    if _ID<>'0' then
      dlgCRMSeznamSelect.fpLookFor:=_ID;
    dlgCRMSeznamSelect.fpID:=_ID;
    if _ID='' then
      dlgCRMSeznamSelect.caption:='Pøehled'
    else
      dlgCRMSeznamSelect.caption:='Výbìr';
    if _Caption<>'' then
      dlgCRMSeznamSelect.caption:=_Caption;
    dlgCRMSeznamSelect.tbMinus.visible:=assigned(_Minustable) and (_Minustable.count>0) and (_KeyFieldName<>'');
    if dlgCRMSeznamSelect.tbMinus.visible then
      dlgCRMSeznamSelect.FMinustable.assign(_Minustable);
    if _KeyFieldName<>'' then
      dlgCRMSeznamSelect.KeyFieldName:=_KeyFieldName;

    if not _ShowStorno then
      dlgCRMSeznamSelect.btOK.left:=dlgCRMSeznamSelect.btCancel.left;
    dlgCRMSeznamSelect.btCancel.visible:=_ShowStorno;

    dlgCRMSeznamSelect.ShowModal;
  finally
    if dlgCRMSeznamSelect.modalresult=mrOk then
    begin
      If assigned(_S) then
      begin
        _S.Assign(dlgCRMSeznamSelect.FSelectedItems);
        if dlgCRMSeznamSelect.FSelectedItems.Count > 0 then
          Result := dlgCRMSeznamSelect.FSelectedItems[0]
      end
      else
          Result := dlgCRMSeznamSelect.qrMaster.fieldByName(_KeyFieldName).asString;
    end;
    dlgCRMSeznamSelect.Free;
    Screen.Cursor := crDefault;
  end;
end;

// ..........................................................................
function RegKeyName(const _SubKey: string = ''): string;
begin
  Result := SystemIIKey + Uzivatel + '\' + _SubKey;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.grMasterDblClick(Sender: TObject);
begin
  inherited;
  if btOK.Enabled then
    btOK.Click
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.btOKClick(Sender: TObject);
begin
  inherited;
  if fpID<>'' then
    VybranePolozkyDoParametru;
  ModalResult := mrOK;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.WMSysCommand(var msg: TMessage);
begin
  inherited;
  case Msg.wParam of
    SC_Close:btCancel.Click;
  end;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.VybranePolozkyDoParametru;
begin
  grMaster.DoWithSelected(CopyToTargetList);
end;

// ..........................................................................
function TdlgCRMSeznamSelect.CopyToTargetList(D: TDataSet): boolean;
begin
  Result := true;
  FSelectedItems.Append(D.FieldByName(FKeyFieldName).AsString);
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.LoadData(_Reg: TRegistry);
var
  i: integer;

  function RI(const _Name: string; const _Default: integer): integer;
  begin
    if _Reg.ValueExists(_Name) then
      Result := _Reg.ReadInteger(_Name)
    else
      Result := _Default;
  end;

begin
(*
  LoadFormPosition(_Reg, Self);
*)
  i := RI('WindowState', 0);
  if i = integer(wsMaximized) then
    WindowState := wsMaximized;
(*
  LoadComponentPreferences(_Reg, Self);
*)
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.SaveData(_Reg: TRegistry);
begin
(*
  SaveFormPosition(_Reg, Self);
*)
  _Reg.WriteInteger('WindowState', integer(WindowState));
(*
  SaveComponentPreferences(_Reg, Self);
*)
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.LoadPreferences;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    if Reg.OpenKey(RegKeyName(Name), false) then
    begin
      LoadData(Reg);
    end;
  finally
    Reg.Free;
  end;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.SavePreferences;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    if Reg.OpenKey(RegKeyName(Name), true) then
    begin
      SaveData(Reg);
    end;
  finally
    Reg.Free;
  end;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.SetCaption(_Capt: String);
begin
  Caption := _Capt;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.SetKeyFieldName(const Value: string);
begin
  FKeyFieldName := Value;
end;


// ..........................................................................
procedure TdlgCRMSeznamSelect.qrMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  if (fpLookFor <> '') then
    begin
      qrMaster.Locate(FKeyFieldName,fpLookFor,[]);
      fpLookFor:='';
    end;
  btOK.enabled:=hasData(qrMaster);
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.FormCreate(Sender: TObject);
begin
  inherited;
  qrMaster.close;
  qrMaster.sql.text:='';
  FPuvCapt:=Caption;
  LoadPreferences;
  FMinustable:=TStringList.Create;
  FKeyFieldName := 'ID';
  FSelectedItems := TStringList.Create;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FMultiSelectList := nil; //  kvuli MemoryManageru
  Action := caFree;
  SavePreferences;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.FormDestroy(Sender: TObject);
begin
  FMinustable.Free;
  FSelectedItems.Free;
  inherited;
  if Assigned(FReference) then // tohle nastavi promennou, ktera ukazuje na tohle okno, na NIL
    pointer(FReference^) := nil;
end;

// ..........................................................................
function TdlgCRMSeznamSelect.AddToMultiSelectList(D: TDataSet): boolean;
begin
  FMultiSelectList.Add(D.FieldByName(FMultiSelectFieldName).AsString);
  Result := true;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.FillMultiSelectList(_Grid: TMSDBGrid;
  _FieldName: string);
begin
  if Assigned(FMultiSelectList) then
  begin
    FMultiSelectFieldName := _FieldName;
    _Grid.DoWithSelected(AddToMultiSelectList);
  end;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.FormShow(Sender: TObject);
begin
  if ((fpLookFor <> '') or (fpTemporaryQuery <> '')) then
  begin
    if fpTemporaryQuery <> '' then
      begin
        qrMaster.close;
        qrMaster.sql.text:=fpTemporaryQuery
      end;
  end;
  if qrMaster.sql.text<>'' then
    qrMaster.open;
end;

// ..........................................................................
procedure TdlgCRMSeznamSelect.tbMinusClick(Sender: TObject);
begin
  if Confirm('Opravdu chcete odebrat vybrané položky?') then
    try
      qrMaster.DisableControls;
      grMaster.DoWithSelected(OdeberPolozku);
    finally
      qrMaster.EnableControls;
      RefreshQuery(qrMaster);
    end;
end;

// ..........................................................................
function TdlgCRMSeznamSelect.OdeberPolozku(D: TDataset): boolean;
var
  i:Integer;
begin
  result:=True;
  for i:=0 to FMinustable.count-1 do
  begin
    if FMinustable[i]<>'PRILOHY_NOVE' then
      ExecQuery('DELETE FROM '+FMinustable[i]+
                ' WHERE '+FKeyFieldName+'='+Q(D.FieldByName(FKeyFieldName).AsString))
    else
    try
      ExecQuery('DELETE FROM  '+FMinustable[i]+
                ' WHERE PK='+Q(D.FieldByName('REF_ID').AsString)+
                '   AND PRILOHA_ID='+Q(D.FieldByName(FKeyFieldName).AsString));
    except
    end;
  end;
end;

end.
