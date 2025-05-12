unit DRosProcesInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, UCLTypes, Vcl.NGrids, Vcl.NDBGrids, MSGrid,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.DBCtrls, Data.DB, DBAccess, Ora, MemDS;

// TdlgRosProcesInfoParams
{ ------------------------------------------------------------------------- }
type
  TdlgRosProcesInfoParams = class(TMultiselectFuncParams)
  public
    fpNIA: integer;
    fpID: integer;
    fpCISLO: integer;
    fpReadOnly: boolean;
    fpDuplikat: integer;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgRosProcesInfo
{ ------------------------------------------------------------------------- }
type
  TdlgRosProcesInfo = class(TacDialogOkStorno)
    qrMaster: TOraQuery;
    dsMaster: TOraDataSource;
    qrMasterREF_DATE: TDateTimeField;
    qrMasterESSL_CJ: TWideStringField;
    qrMasterESSL_DATE: TDateTimeField;
    qrMasterWEB_JMENO: TWideStringField;
    qrMasterWEB_PRIJMENI: TWideStringField;
    qrMasterWEB_DAT_NAR: TDateTimeField;
    qrMasterWEB_STAT_NAROZENI: TWideStringField;
    qrMasterWEB_TRV_ULICE: TWideStringField;
    qrMasterWEB_TRV_MESTO: TWideStringField;
    qrMasterWEB_TRV_PSC: TWideStringField;
    qrMasterWEB_OBEC_NAROZENI: TWideStringField;
    qrMasterWEB_OKRES_NAROZENI: TWideStringField;
    qrMasterWEB_TRV_STAT: TWideStringField;
    qrMasterPOPIS: TWideStringField;
    pnData: TPanel;
    Panel1: TPanel;
    nvMaster: TDBNavigator;
    ToolBar2: TToolBar;
    grMaster: TMSDBGrid;
    qrMasterID_ROS: TIntegerField;
    qrMasterCISLO: TIntegerField;
    qrMasterNIA: TFloatField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure grMasterDblClick(Sender: TObject);
    procedure qrMasterAfterOpen(DataSet: TDataSet);
    procedure grMasterGetRowColor(var Color, FontColor: Integer);
  private
    procedure FillParams; override;
  public
    { Public declarations }
  end;

function dlgRosProcesInfoExec(_Params: TFuncParams): boolean;

var
  dlgRosProcesInfo: TdlgRosProcesInfo;

implementation

{$R *.dfm}
uses
  Tools, Utils, NParam, DSeznamSelect;

function dlgRosProcesInfoExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgRosProcesInfo, dlgRosProcesInfo, true);
  with dlgRosProcesInfo do
  begin
    borderStyle:=bsSizeable;
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

{ TdlgRosProcesInfoParams }
// ..........................................................................
constructor TdlgRosProcesInfoParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent;
  _BeforeOKEvent: TBeforeOKEvent);
begin
  fpNIA:=0;
  fpID:=0;
  fpReadOnly:=False;
  inherited Create(_IOFlags,_ActionFlags, _OnDataChanged,_BeforeOKEvent);
end;

{ TdlgRosProcesInfo }
// ..........................................................................
procedure TdlgRosProcesInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qrMaster.close;
  inherited;
end;

// ..........................................................................
procedure TdlgRosProcesInfo.FormCreate(Sender: TObject);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgRosProcesInfo.FormShow(Sender: TObject);
begin
  inherited;
  qrMaster.close;
  if Assigned(Params) then
    with TdlgRosProcesInfoParams(Params) do
    begin
      if fpNIA=1 then
        qrMaster.SQL.Text:='select * from ROS_POL_PROCES_INFO_NIA'
      else
        qrMaster.SQL.Text:='select * from ROS_POL_PROCES_INFO';
    end;
  qrMaster.open;
end;

// ..........................................................................
procedure TdlgRosProcesInfo.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgRosProcesInfo.FillParams;
begin
  inherited;
  if Assigned(Params) then
    with TdlgRosProcesInfoParams(Params) do
    begin
      fpID:=qrMasterID_ROS.asInteger;
      fpCISLO:=qrMasterCISLO.asInteger;
    end;
end;

// ..........................................................................
procedure TdlgRosProcesInfo.btOKClick(Sender: TObject);
begin
  modalresult:=mrNone;
  FillParams;
  modalresult:=mrOk;
end;

// ..........................................................................
procedure TdlgRosProcesInfo.grMasterDblClick(Sender: TObject);
begin
  if btOK.Enabled then
    btOK.Click
end;

// ..........................................................................
procedure TdlgRosProcesInfo.grMasterGetRowColor(var Color, FontColor: Integer);
begin
  inherited;
  if qrMasterNIA.asInteger=1 then
    FontColor:=clRed;
end;

// ..........................................................................
procedure TdlgRosProcesInfo.qrMasterAfterOpen(DataSet: TDataSet);
begin
  inherited;
  btOk.enabled:=hasData(qrMaster);
end;

end.
