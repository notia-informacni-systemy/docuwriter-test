unit DSubjektyVyhledat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  NotiaMagic, ADialog, UCLTypes, Data.DB, MemDS, DBAccess, Ora;

// TdlgSubjektyVyhledatParams
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektyVyhledatParams = class(TMultiselectFuncParams)
  public
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSubjektyVyhledat
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektyVyhledat = class(TacDialog)
    pnBottom: TPanel;
    btOK: TButton;
    btCancel: TButton;
    Label15: TLabel;
    edICO: TEdit;
    Label1: TLabel;
    edDIC: TEdit;
    Label2: TLabel;
    edIdent: TEdit;
    Label3: TLabel;
    edEvidCis: TEdit;
    Label4: TLabel;
    edDatSchr: TEdit;
    edRejCis: TEdit;
    Label5: TLabel;
    edMobil: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edJmeno: TEdit;
    Label8: TLabel;
    edPrijmeni: TEdit;
    btClear: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure edICOChange(Sender: TObject);
    procedure btClearClick(Sender: TObject);
  private
    function UlozData:Boolean;
    procedure ClearForNew;
    procedure LoadLastData;
  protected
    Procedure WMSysCommand(var msg: TMessage); Override;
  public
  end;

var
  dlgSubjektyVyhledat: TdlgSubjektyVyhledat;

function dlgSubjektyVyhledatExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}

uses Tools, Utils, Caches, uUCLConsts, uStoredProcs, NConsts, NParam,uObjUtils,
     FSubjekty;

function dlgSubjektyVyhledatExec(_Params: TFuncParams): boolean;
begin
  result:=false;
//  ErrorMsg('Pøipravuje se');
//  Exit;

  PrepareForm(TdlgSubjektyVyhledat, dlgSubjektyVyhledat, true);
  try
    with dlgSubjektyVyhledat do
    begin
//      borderStyle:=bsSizeable;
      Params := _Params;
      if WindowState = wsMinimized then
        WindowState := wsNormal;

      ClearForNew;
      if assigned(Params) then
      begin
      end;

      Result := (ShowModal = mrOK);
      Params := nil;
    end;
  finally
    dlgSubjektyVyhledat.free;
    dlgSubjektyVyhledat:=nil;
  end;
end;


{ TdlgSubjektyVyhledatParams }
// ..........................................................................
constructor TdlgSubjektyVyhledatParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
//
end;


{ TdlgSubjektyVyhledat }
// ..........................................................................
procedure TdlgSubjektyVyhledat.FormCreate(Sender: TObject);
begin
  inherited;
  ClearForNew;
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.FormShow(Sender: TObject);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.btOKClick(Sender: TObject);
begin
  if not UlozData then
    exit;

  inherited;
  ModalResult := mrOK;
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.ClearForNew;
var
  i : integer;
begin
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TMemo then TMemo(Components[i]).text:='';
    if Components[i] is TEdit then TEdit(Components[i]).text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
  LoadLastData;
  edICOChange(nil);
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.btClearClick(Sender: TObject);
begin
  ExecSqlText('DELETE FROM SESSIONID_TEMP WHERE KOD like ''FIND_SUBJEKT%'' AND SESSIONID=USERENV(''SESSIONID'')');
  ClearForNew;
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.WMSysCommand(var msg: TMessage);
begin
  inherited;
  case Msg.wParam of
    SC_Close:if pnBottom.Visible then btCancel.Click;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.LoadLastData;
var qrTemp:TOraQuery;
begin
  try
    qrTemp:=CreateQueryOpen('SELECT S1, S2, S3, S4, S5 FROM SESSIONID_TEMP WHERE KOD=''FIND_SUBJEKT1'' AND SESSIONID=USERENV(''SESSIONID'')  ');
    if hasdata(qrTemp) then
    begin
      edIdent.text:=qrTemp.FieldByName('S1').asString;
      edICO.text:=qrTemp.FieldByName('S2').asString;
      edDIC.text:=qrTemp.FieldByName('S3').asString;
      edEvidCis.text:=qrTemp.FieldByName('S4').asString;
      edRejCis.text:=qrTemp.FieldByName('S5').asString;
    end;
    qrTemp.close;
    qrTemp.SQL.Text:='SELECT S1, S2, S3, S4, S5 FROM SESSIONID_TEMP WHERE KOD=''FIND_SUBJEKT2'' AND SESSIONID=USERENV(''SESSIONID'')  ';
    qrTemp.open;
    if hasdata(qrTemp) then
    begin
      edPrijmeni.text:=qrTemp.FieldByName('S1').asString;
      edJmeno.text:=qrTemp.FieldByName('S2').asString;
      edDatSchr.text:=qrTemp.FieldByName('S3').asString;
      edMobil.text:=qrTemp.FieldByName('S4').asString;
    end;
    qrTemp.close;
  finally
    qrTemp.free;
  end;
end;

// ..........................................................................
function TdlgSubjektyVyhledat.UlozData: Boolean;
var qrTemp:TOraQuery;
begin
  result:=false;
  ExecSqlText('DELETE FROM SESSIONID_TEMP WHERE KOD like ''FIND_SUBJEKT%'' AND SESSIONID=USERENV(''SESSIONID'')');
  try
    qrTemp:=CreateQueryWithText('SELECT * FROM SESSIONID_TEMP',true);
    qrTemp.Open;
    qrTemp.insert;
    qrTemp.FieldByName('KOD').asString:='FIND_SUBJEKT1';
    qrTemp.FieldByName('SESSIONID').asString:=GetSessionid;
    qrTemp.FieldByName('S1').asString:=edIdent.text;
    qrTemp.FieldByName('S2').asString:=edICO.text;
    qrTemp.FieldByName('S3').asString:=edDIC.text;
    qrTemp.FieldByName('S4').asString:=edEvidCis.text;
    qrTemp.FieldByName('S5').asString:=edRejCis.text;
    qrTemp.Post;
    qrTemp.insert;
    qrTemp.FieldByName('KOD').asString:='FIND_SUBJEKT2';
    qrTemp.FieldByName('SESSIONID').asString:=GetSessionid;
    qrTemp.FieldByName('S1').asString:=edPrijmeni.text;
    qrTemp.FieldByName('S2').asString:=edJmeno.text;
    qrTemp.FieldByName('S3').asString:=edDatSchr.text;
    qrTemp.FieldByName('S4').asString:=edMobil.text;
    qrTemp.Post;
    qrTemp.Close;
    result:=true;
  finally
    qrTemp.free;
  end
end;

// ..........................................................................
procedure TdlgSubjektyVyhledat.edICOChange(Sender: TObject);
begin
  inherited;
  btOK.enabled:=trim(edICO.text+edDIC.text+edIdent.text+
                     edEvidCis.text+edDatSchr.text+edRejCis.text+
                     edMobil.text+edJmeno.text+edPrijmeni.text)<>'';
end;

end.
