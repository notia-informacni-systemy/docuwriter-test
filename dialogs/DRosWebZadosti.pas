unit DRosWebZadosti;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Data.DB, DBAccess, Ora,
  MemDS, Vcl.NGrids, Vcl.NDBGrids, MSGrid, Vcl.DBCtrls, UCLTypes;

// TdlgRosWebZadostiParams
{ ------------------------------------------------------------------------- }
type
  TdlgRosWebZadostiParams = class(TMultiselectFuncParams)
  public
    fpID: integer;
    fpROS: integer;
    fpReadOnly: boolean;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgRosWebZadosti
type
  TdlgRosWebZadosti = class(TacDialogOkStorno)
    pnData: TPanel;
    qrMaster: TOraQuery;
    dsMaster: TOraDataSource;
    Panel1: TPanel;
    nvMaster: TDBNavigator;
    ToolBar2: TToolBar;
    grMaster: TMSDBGrid;
    qrMasterID: TIntegerField;
    qrMasterJMENO: TWideStringField;
    qrMasterPRIJMENI: TWideStringField;
    qrMasterDAT_NAR: TDateTimeField;
    qrMasterSTAT_NAROZENI: TWideStringField;
    qrMasterTRV_ULICE: TWideStringField;
    qrMasterTRV_MESTO: TWideStringField;
    Panel2: TPanel;
    ToolButton1: TToolButton;
    edCK: TEdit;
    qrMasterOBEC_NAROZENI: TWideStringField;
    qrMasterOKRES_NAROZENI: TWideStringField;
    qrMasterTRV_STAT: TWideStringField;
    qrMasterJAZYK: TWideStringField;
    qrMasterZAMESTNAVATEL: TWideStringField;
    qrMasterZAPSANO: TDateTimeField;
    qrMasterDUPLIKAT: TIntegerField;
    qrMasterDUPLIKAT_DUVOD: TWideStringField;
    btPropojit: TButton;
    qrMasterNIA: TFloatField;
    qrMasterAIFO_INFO: TWideStringField;
    qrMasterNIA_INFO: TWideStringField;
    btNový: TButton;
    qrMasterPLATNY: TIntegerField;
    qrMasterPRIJMENI_UPPER: TWideStringField;
    qrMasterJMENO_UPPER: TWideStringField;
    tbZnepatnit: TToolButton;
    ToolButton2: TToolButton;
    procedure edCKKeyPress(Sender: TObject; var Key: Char);
    procedure edCKKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grMasterDblClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure edCKExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grMasterGetRowColor(var Color, FontColor: Integer);
    procedure qrMasterDUPLIKATGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qrMasterDUPLIKATSetText(Sender: TField; const Text: string);
    procedure btPropojitClick(Sender: TObject);
    procedure qrMasterAfterOpen(DataSet: TDataSet);
    procedure qrMasterAfterScroll(DataSet: TDataSet);
    procedure btNovýClick(Sender: TObject);
    procedure tbZnepatnitClick(Sender: TObject);
  private
    FKodKey:Word;
    procedure FillParams; override;
    function Propojit:Boolean;
  public
    procedure ClearForm;
  end;

var
  dlgRosWebZadosti: TdlgRosWebZadosti;

function dlgRosWebZadostiExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}
uses
  Tools, Utils, NParam, NConsts, DSeznamSelect, uStoredProcs;


function dlgRosWebZadostiExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgRosWebZadosti, dlgRosWebZadosti, true);
  with dlgRosWebZadosti do
  begin
    borderStyle:=bsSizeable;
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

{ TdlgRosWebZadostiParams }
// ..........................................................................
constructor TdlgRosWebZadostiParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent;
  _BeforeOKEvent: TBeforeOKEvent);
begin
  fpID:=0;
  fpROS:=0;
  fpReadOnly:=False;
  inherited Create(_IOFlags,_ActionFlags, _OnDataChanged,_BeforeOKEvent);
end;

{ TdlgRosWebZadosti }
// ..........................................................................
procedure TdlgRosWebZadosti.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qrMaster.close;
  inherited;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.FormCreate(Sender: TObject);
begin
  inherited;
  ClearForm;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.FormShow(Sender: TObject);
begin
  inherited;
  if Assigned(Params) then
    with TdlgRosWebZadostiParams(Params) do
    begin
//      qrMasterID.asString:=fpID
    end;
  qrMaster.open;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.edCKExit(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  if qrMaster.active then
  begin
    try
      i:=StrToInt(StringReplace(edCK.text,' ','',[rfReplaceAll]));
    except
      i:=0;
    end;
    if i>0 then
    begin
      qrMaster.locate('ID',i,[]);
      if qrMasterID.asInteger=i then
        btOK.click;
    end;
  end;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.edCKKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FKodKey:=0;
  if Key=VK_Return then
    edCKExit(nil)
  else
    FKodKey:=GetNumKeyWord(Key);
  inherited;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.edCKKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  Key:=Chr(FKodKey)
end;

// ..........................................................................
procedure TdlgRosWebZadosti.FillParams;
begin
  inherited;
  if Assigned(Params) then
    with TdlgRosWebZadostiParams(Params) do
    begin
      fpID:=qrMasterID.asInteger;
    end;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.grMasterDblClick(Sender: TObject);
begin
  inherited;
  btOK.click;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.grMasterGetRowColor(var Color, FontColor: Integer);
begin
  inherited;
  if qrMasterNIA.asInteger=1 then
    FontColor:=clRed;

  if qrMasterDUPLIKAT.asInteger=1 then
    Color:=bgColRuzova;
  if qrMasterID.asString=edCK.text then
    Color:=bgColZluta
end;

// ..........................................................................
procedure TdlgRosWebZadosti.qrMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  btOk.enabled:=hasData(qrMaster);
  btPropojit.enabled:=hasData(qrMaster);
end;

procedure TdlgRosWebZadosti.qrMasterDUPLIKATGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := cYesNo[0]
  else
    Text := cYesNo[Sender.AsInteger];
end;

// ..........................................................................
procedure TdlgRosWebZadosti.qrMasterDUPLIKATSetText(Sender: TField;
  const Text: string);
begin
  Sender.AsInteger := integer(Text = cYesNo[1]);
end;

procedure TdlgRosWebZadosti.tbZnepatnitClick(Sender: TObject);
begin
  if not confirm('Opravdu trvale zneplatnit žádost ID="'+qrMasterID.asString+'" ?') then
    Exit;
  try
    Screen.Cursor := crHourGlass;
    ExecQuery('UPDATE ROS_WEB_ZADOSTI SET '+
              '  PLATNY=0 '+
              'WHERE ID='+qrMasterID.asString);
    qrMaster.close;
    qrMaster.open;
    New_zurnal('1','0','ROS_WEB_ZADOSTI',qrMasterID.asString,'Zneplatnìní žádosti ROS ID="'+qrMasterID.asString+'"','ROS_WEB_ZADOSTI');
    Screen.Cursor := crDefault;
    Inform('Zneplatnìno');
  finally
    Screen.Cursor := crDefault;
  end;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.btOKClick(Sender: TObject);
begin
  modalresult:=mrNone;
  if not Confirm('Zpracovat záznam ID='+qrMasterID.asString) then
    EXIT;
  FillParams;
  modalresult:=mrOk;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.qrMasterAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if Assigned(Params) then
     with TdlgRosWebZadostiParams(Params) do
        fpROS:=0;
end;

// ..........................................................................
function TdlgRosWebZadosti.Propojit: Boolean;
var
  t:String;
begin
  result:=false;
  try
    Screen.Cursor := crHourGlass;
    t:=dlgSeznamSelectExecute('SELECT * FROM ROS_MINI','0',nil, 'ID', nil, true);
    if (t<>'') and Assigned(Params) then
      with TdlgRosWebZadostiParams(Params) do
      begin
        fpROS:=StrToInt(t);
        result:=true;
      end
  finally
    Screen.Cursor := crDefault
  end;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.btPropojitClick(Sender: TObject);
begin
 if propojit then
   btOK.click;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.btNovýClick(Sender: TObject);
begin
  with TdlgRosWebZadostiParams(Params) do
    fpROS:=0;
  btOK.click;
end;

// ..........................................................................
procedure TdlgRosWebZadosti.ClearForm;
begin
  edCK.Text:='';
  ActiveControl:=edCK;
end;

end.
