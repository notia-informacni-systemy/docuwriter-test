unit DSubjektySelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, UCLTypes, uDMUCL, NotiaImageButton, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.DBCtrls, Data.DB, DBAccess, Ora, MemDS, Vcl.NGrids,
  Vcl.NDBGrids, MSGrid;

// TdlgSubjektySelectParams
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektySelectParams = class(TMultiselectFuncParams)
  public
    fpID: integer;
    fpJMENO: string;
    fpPRIJMENI: string;
    fpSQL: string;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSubjektySelect
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektySelect = class(TacDialogOkStorno)
    dsMaster: TOraDataSource;
    Panel1: TPanel;
    nvMaster: TDBNavigator;
    ToolBar2: TToolBar;
    tbPlus: TNotiaImageButton;
    grMaster: TMSDBGrid;
    qrMaster: TOraQuery;
    qrMasterMISTO_NAROZENI: TWideStringField;
    qrMasterID: TIntegerField;
    qrMasterDAT_NAROZENI: TDateTimeField;
    qrMasterDIC: TWideStringField;
    qrMasterPLATNY: TSmallintField;
    qrMasterICO: TWideStringField;
    qrMasterTITUL_PRED: TWideStringField;
    qrMasterTITUL_ZA: TWideStringField;
    qrMasterNAZEV_K_ZOBRAZENI: TWideStringField;
    qrMasterRODNE_PRIJM: TWideStringField;
    qrMasterADRESA_ULICE: TWideStringField;
    qrMasterADRESA_MESTO: TWideStringField;
    qrMasterADRESA_STAT: TWideStringField;
    qrMasterPRAVNICKA: TIntegerField;
    qrMasterPRAVNICKA_INFO: TWideStringField;
    qrMasterADRESA_MESTO_CAST: TWideStringField;
    qrMasterJMENO: TWideStringField;
    qrMasterPRIJMENI: TWideStringField;
    qrMasterNAZEV: TWideStringField;
    qrMasterPRAVNI_FORMA: TWideStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbPlusClick(Sender: TObject);
    procedure grMasterDblClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure OnOK(var Accept: boolean); override;
  public
    { Public declarations }
  end;

var
  dlgSubjektySelect: TdlgSubjektySelect;

function dlgSubjektySelectExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}

uses Tools, Utils, uStoredProcs, NConsts, uDBUtils, uUCLConsts,
  FSubjekty;


function dlgSubjektySelectExec(_Params: TFuncParams): boolean;
var
  lSQL : String;
begin
  PrepareForm(TdlgSubjektySelect, dlgSubjektySelect, true);
  with dlgSubjektySelect do
  begin
    borderStyle:=bsSizeable;
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;


{ TdlgSubjektySelectParams }
// ..........................................................................
constructor TdlgSubjektySelectParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpID:=0;
  fpJMENO:='';
  fpPRIJMENI:='';
  fpSQL:='';
  inherited Create(_IOFlags,_ActionFlags, _OnDataChanged,_BeforeOKEvent);
end;

{ TdlgSubjektySelect }
// ..........................................................................
procedure TdlgSubjektySelect.FormCreate(Sender: TObject);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgSubjektySelect.FormShow(Sender: TObject);
begin
  inherited;
  qrMaster.close;
  if Assigned(Params) then
    with TdlgSubjektySelectParams(Params) do
    begin
//SELECT * FROM SUBJEKTY_DATA
      if fpSQL<>'' then
        qrMaster.SQL.text:=fpSQL;
    end;
  Screen.Cursor := crHourGlass;
  try
    qrMaster.Open;
  finally
    Screen.Cursor := crDefault;
  end;
end;

// ..........................................................................
procedure TdlgSubjektySelect.btOKClick(Sender: TObject);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgSubjektySelect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qrMaster.Close;
  inherited;
end;

procedure TdlgSubjektySelect.tbPlusClick(Sender: TObject);
begin
  if  not (GetPermission(perm_subjekty_SIU) or GetPermission(perm_subjekty_ALL) or
    GetPermission(perm_isucl_vse)) then
  begin
    Errormsg('Nedostateèné oprávnìní na subjekty');
    EXIT;
  end;

  Inform('Pøipravuje se')
end;

// ..........................................................................
procedure TdlgSubjektySelect.OnOK(var Accept: boolean);
begin
  Accept := False;
  inherited;
  if Assigned(Params) then
    with TdlgSubjektySelectParams(Params) do
    begin
      fpID:=qrMasterID.asInteger;
      Accept := fpID>0;
    end;
end;

// ..........................................................................
procedure TdlgSubjektySelect.grMasterDblClick(Sender: TObject);
begin
  inherited;
  btOKClick(nil);

end;

end.
