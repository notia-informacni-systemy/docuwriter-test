unit DSEC_BezpProgram;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialog, NotiaMagic, Vcl.ExtCtrls,
  UCLTypes, Vcl.StdCtrls, Data.DB, MemDS, DBAccess, Ora, Vcl.Mask, rxToolEdit,
  Vcl.DBCtrls, NotiaImageButton, Vcl.NGrids, Vcl.NDBGrids, MSGrid;

// TdlgSEC_BezpProgramParams
{ ------------------------------------------------------------------------- }
type
  TdlgSEC_BezpProgramParams = class(TMultiselectFuncParams)
  public
    fpID:Integer;
    fpSEC:Integer;
    fpSubjekt:Integer;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSEC_BezpProgram
{ ------------------------------------------------------------------------- }
type
  TdlgSEC_BezpProgram = class(TacDialog)
    qrSubjekt: TOraQuery;
    qrSubjektID: TIntegerField;
    qrSubjektNAZEV: TWideStringField;
    qrBezpProgram: TOraQuery;
    Panel1: TPanel;
    Label12: TLabel;
    edSubjekt: TEdit;
    pnBottom: TPanel;
    btOK: TButton;
    btCancel: TButton;
    Panel2: TPanel;
    lbID: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbSchvaleno: TLabel;
    edID: TEdit;
    edZaslano: TDateEdit;
    mePoznamka: TMemo;
    edSchvaleno: TDateEdit;
    qrTexty: TOraQuery;
    qrTextyID: TIntegerField;
    qrTextySEC_ID: TIntegerField;
    qrTextyDRUH: TWideStringField;
    qrTextyTYP: TWideStringField;
    qrTextyDATUM: TDateTimeField;
    qrTextyEVID_CISLO: TWideStringField;
    qrTextyPLATNOST_DO: TDateTimeField;
    qrTextyPOZNAMKA: TWideStringField;
    qrTextyZAPSAL: TWideStringField;
    qrTextyZAPSANO: TDateTimeField;
    qrTextyZMENIL: TWideStringField;
    qrTextyZMENENO: TDateTimeField;
    qrTextyPOZNAMKA250: TWideStringField;
    dsTexty: TOraDataSource;
    Panel3: TPanel;
    Panel25: TPanel;
    tbZmenyAdd: TNotiaImageButton;
    tbZmenyDel: TNotiaImageButton;
    DBNavigator2: TDBNavigator;
    Panel26: TPanel;
    Label13: TLabel;
    grZmeny: TMSDBGrid;
    qrBezpProgramID: TIntegerField;
    qrBezpProgramSEC_ID: TIntegerField;
    qrBezpProgramZASLANO: TDateTimeField;
    qrBezpProgramSCHVALENO: TDateTimeField;
    qrBezpProgramSPLNENO: TDateTimeField;
    qrBezpProgramPOZNAMKA: TWideStringField;
    qrBezpProgramZAPSAL: TWideStringField;
    qrBezpProgramZAPSANO: TDateTimeField;
    qrBezpProgramZMENIL: TWideStringField;
    qrBezpProgramZMENENO: TDateTimeField;
    Label1: TLabel;
    edSplneno: TDateEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qrSubjektAfterOpen(DataSet: TDataSet);
    procedure qrBezpProgramAfterOpen(DataSet: TDataSet);
    procedure qrBezpProgramBeforeOpen(DataSet: TDataSet);
    procedure qrSubjektBeforeOpen(DataSet: TDataSet);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure qrTextyAfterOpen(DataSet: TDataSet);
    procedure qrTextyBeforeOpen(DataSet: TDataSet);
    procedure qrTextyCalcFields(DataSet: TDataSet);
    procedure grZmenyDblClick(Sender: TObject);
    procedure tbZmenyAddClick(Sender: TObject);
    procedure tbZmenyDelClick(Sender: TObject);
  private
    function UlozData:Boolean;
    procedure ClearForNew;
  protected
    Procedure WMSysCommand(var msg: TMessage); Override;
  public
    fSEC:Integer;
    fSubjekt:Integer;
    fID:Integer;
    procedure Text(_Insert:boolean; Druh:string);
    procedure BezpProgramInit;
  end;

var
  dlgSEC_BezpProgram: TdlgSEC_BezpProgram;

function dlgSEC_BezpProgramExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}
uses Tools, Utils, Caches, uUCLConsts, uStoredProcs, NConsts, NParam,uObjUtils,
     FSEC, DSEC_Text;

function dlgSEC_BezpProgramExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSEC_BezpProgram, dlgSEC_BezpProgram, true);
  try
    with dlgSEC_BezpProgram do
    begin
      borderStyle:=bsSizeable;
      Params := _Params;
      if WindowState = wsMinimized then
        WindowState := wsNormal;
      if assigned(Params) then
      begin
        fSEC:=TdlgSEC_BezpProgramParams(Params).fpSEC;
        fSubjekt:=TdlgSEC_BezpProgramParams(Params).fpSubjekt;
        fID:=TdlgSEC_BezpProgramParams(Params).fpID;
      end;
      Result := (ShowModal = mrOK);
      Params := nil;
    end;
  finally
    dlgSEC_BezpProgram.free;
    dlgSEC_BezpProgram:=nil;
  end;
end;

{ TdlgSEC_BezpProgramParams }
// ..........................................................................
constructor TdlgSEC_BezpProgramParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpSEC:=-1;
  fpSubjekt:=-1;
  fpID:=-1;
end;

{ TdlgSEC_BezpProgram }
// ..........................................................................
procedure TdlgSEC_BezpProgram.FormCreate(Sender: TObject);
begin
  inherited;
  fSEC:=-1;
  fSubjekt:=-1;
  fID:=-1;
  ClearForNew;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.FormShow(Sender: TObject);
begin
  inherited;
  BezpProgramInit;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qrTexty.close;
  qrBezpProgram.close;
  qrSubjekt.close;
  inherited;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.WMSysCommand(var msg: TMessage);
begin
  inherited;
  case Msg.wParam of
    SC_Close:if pnBottom.Visible then btCancel.Click;
  end;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.ClearForNew;
var
  i : integer;
begin
  fID:=-1;
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TMemo then TMemo(Components[i]).text:='';
    if Components[i] is TEdit then TEdit(Components[i]).text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
  BezpProgramInit;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.qrSubjektAfterOpen(DataSet: TDataSet);
begin
  edSubjekt.text:=qrSubjektNAZEV.AsString+'('+qrSubjektID.AsString+')';
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.qrSubjektBeforeOpen(DataSet: TDataSet);
begin
  qrSubjekt.ParamByName('SUBJEKT').asInteger:=FSubjekt;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.qrBezpProgramAfterOpen(DataSet: TDataSet);
begin
  if not hasdata(qrBezpProgram) then EXIT;
  if not qrBezpProgramZASLANO.isnull then
    edZaslano.date:=qrBezpProgramZASLANO.asDateTime
  else
    edZaslano.clear;
  if not qrBezpProgramSCHVALENO.isnull then
    edSchvaleno.date:=qrBezpProgramSCHVALENO.asDateTime
  else
    edSchvaleno.clear;
  if not qrBezpProgramSPLNENO.isnull then
    edSplneno.date:=qrBezpProgramSPLNENO.asDateTime
  else
    edSplneno.clear;

  mePoznamka.text:=qrBezpProgramPOZNAMKA.asString;
  edID.text:=qrBezpProgramID.asString;
end;


// ..........................................................................
procedure TdlgSEC_BezpProgram.qrTextyAfterOpen(DataSet: TDataSet);
begin
  tbZmenyDel.enabled:=tbZmenyAdd.enabled and hasData(qrTexty);
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.qrTextyBeforeOpen(DataSet: TDataSet);
begin
  tbZmenyAdd.enabled:=lbID.visible;

  qrTexty.ParamByName('ID').asInteger:=FSEC;
  qrTexty.ParamByName('DRUH').asString:='ZMENY'+IntToStr(FID);
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.qrTextyCalcFields(DataSet: TDataSet);
begin
  qrTextyPOZNAMKA250.asString:=Copy(qrTextyPOZNAMKA.asString,1,250);
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.tbZmenyAddClick(Sender: TObject);
begin
  Text(true,'ZMENY'+IntToStr(FID));
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.tbZmenyDelClick(Sender: TObject);
begin
  if confirm('Opravdu odebrat záznam o zmìnì ID="'+qrTextyID.asString+'"?') then
  begin
    ExecSqlText('DELETE FROM SEC_TEXTY '+
                ' WHERE ID='+qrTextyID.asString);
    RefreshQuery(qrTexty);
  end;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.Text(_Insert: boolean; Druh: string);
var
  Params:TdlgSEC_TextParams;
begin
  Params:=nil;
  Params := TdlgSEC_TextParams.Create(0, []);
  try
    Params.fpInsert:=_Insert;
    Params.fpSEC:=FSEC;
    Params.fpSubjekt:=FSubjekt;
    Params.fpDruh:=Druh;
    if not _insert then
      Params.fpID:=qrTextyID.asInteger;
    if dlgSEC_TextExec(Params) then
    begin
      RefreshQuery(qrTexty);
    end;
  finally
    Params.Free;
  end;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.grZmenyDblClick(Sender: TObject);
begin
  if lbID.visible then
    Text(qrTextyID.asInteger=0,'ZMENY'+IntToStr(FID));
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.qrBezpProgramBeforeOpen(DataSet: TDataSet);
begin
  qrBezpProgram.ParamByName('ID').asInteger:=FID;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.BezpProgramInit;
begin
  lbID.visible:=FID>0;
  edID.visible:=lbID.visible;

  qrTexty.close;
  qrBezpProgram.close;
  qrSubjekt.close;
  qrSubjekt.open;
  qrBezpProgram.open;
  qrTexty.open;

end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgSEC_BezpProgram.btOKClick(Sender: TObject);
begin
  if not UlozData then
    exit;

  inherited;
  ModalResult := mrOK;
end;

// ..........................................................................
function TdlgSEC_BezpProgram.UlozData: Boolean;
var
  qrTemp:TOraQuery;
begin
  qrTemp:=nil;
  result:=false;

  try
    qrTemp:=CreateQueryWithText('SELECT * FROM SEC_BEZP_OPATR '+
                                ' WHERE ID='+IntToStr(fID),true);
    qrTemp.open;
    if FID>0 then
      qrTemp.edit
    else
    begin
      qrTemp.insert;
      FID:=SelectInt('SELECT SEQ_SEC_BEZP_OPATR_ID.NEXTVAL FROM DUAL');
      qrTemp.FieldByName('SEC_ID').asInteger:=fSec;
      qrTemp.FieldByName('ID').asInteger:=FID;
    end;
    if edZaslano.date>0 then
      qrTemp.FieldByName('ZASLANO').asDateTime:=edZaslano.date
    else
      qrTemp.FieldByName('ZASLANO').clear;

    if edSchvaleno.Date>0 then
      qrTemp.FieldByName('SCHVALENO').asDateTime:=edSchvaleno.date
    else
      qrTemp.FieldByName('SCHVALENO').clear;

    if edSplneno.Date>0 then
      qrTemp.FieldByName('SPLNENO').asDateTime:=edSplneno.date
    else
      qrTemp.FieldByName('SPLNENO').clear;

    qrTemp.FieldByName('POZNAMKA').asString:=mePoznamka.text;

    qrTemp.post;
    qrTemp.close;
  finally
     qrTemp.free;
     qrTemp:=nil;
  end;

  result:=true;
end;


end.
