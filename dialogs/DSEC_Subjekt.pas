unit DSEC_Subjekt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialog, NotiaMagic, Vcl.ExtCtrls,
  UCLTypes, Data.DB, MemDS, DBAccess, Ora, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons;

// TdlgSEC_SubjektParams
{ ------------------------------------------------------------------------- }
type
  TdlgSEC_SubjektParams = class(TMultiselectFuncParams)
  public
    fpNewSEC: integer;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSEC_Subjekt
type
  TdlgSEC_Subjekt = class(TacDialog)
    pnBottom: TPanel;
    btOK: TButton;
    btCancel: TButton;
    Button1: TButton;
    Label1: TLabel;
    edICO: TEdit;
    GroupBox1: TGroupBox;
    dsSubSidlo: TOraDataSource;
    qrSubSidlo: TOraQuery;
    qrSubSidloULICE: TWideStringField;
    qrSubSidloMESTO: TWideStringField;
    qrSubSidloPSC: TWideStringField;
    qrSubSidloSTAT: TWideStringField;
    qrSubjekt: TOraQuery;
    qrSubjektID: TIntegerField;
    qrSubjektNAZEV: TWideStringField;
    dsSubjekt: TOraDataSource;
    qrSubjektICO: TWideStringField;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edMesto: TDBEdit;
    edUlice: TDBEdit;
    edPSC: TDBEdit;
    edStat: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edSubNazev: TDBEdit;
    edSubICO: TDBEdit;
    edSubDatSchr: TDBEdit;
    edSubID: TDBEdit;
    edSubCRZmena: TDBEdit;
    qrSubjektCR_MODIFY: TDateTimeField;
    qrSubjektDATOVA_SCHRANKA: TWideStringField;
    sbAktualizovat: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure qrSubjektBeforeOpen(DataSet: TDataSet);
    procedure edSubIDDblClick(Sender: TObject);
    procedure edSubIDMouseEnter(Sender: TObject);
    procedure edSubIDMouseLeave(Sender: TObject);
    procedure sbAktualizovatClick(Sender: TObject);
  private
    function UlozData:Boolean;
  protected
    Procedure WMSysCommand(var msg: TMessage); Override;
    procedure ClearForNew;
  public
    FNewSEC:integer;
    FSubjekt:integer;
  end;

var
  dlgSEC_Subjekt: TdlgSEC_Subjekt;

function dlgSEC_SubjektExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}
uses Tools, Utils, FSubjekty, uUCLConsts, Caches, uStoredProcs, NConsts, NParam,
     uObjUtils, FSEC;

function dlgSEC_SubjektExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSEC_Subjekt, dlgSEC_Subjekt, true);
  try
    with dlgSEC_Subjekt do
    begin
      borderStyle:=bsSizeable;
      Params := _Params;
      if WindowState = wsMinimized then
        WindowState := wsNormal;
      Result := (ShowModal = mrOK);
      Params := nil;
      if result and assigned(_Params) then
      begin
        TdlgSEC_SubjektParams(_Params).fpNewSEC:=FNewSEC;
      end;
    end;
  finally
    dlgSEC_Subjekt.free;
    dlgSEC_Subjekt:=nil;
  end;
end;


{ TdlgSEC_SubjektParams }
// ..........................................................................
constructor TdlgSEC_SubjektParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpNewSEC:=-1;
end;

{ TdlgSEC_Subjekt }
// ..........................................................................
procedure TdlgSEC_Subjekt.FormCreate(Sender: TObject);
begin
  inherited;
  FNewSEC:=-1;
  FSubjekt:=-1;
  ClearForNew;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.WMSysCommand(var msg: TMessage);
begin
  inherited;
  case Msg.wParam of
    SC_Close:if pnBottom.Visible then btCancel.Click;
  end;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.ClearForNew;
var
  i : integer;
begin
  FSubjekt:=-1;
  qrSubSidlo.Close;
  qrSubjekt.Close;
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TMemo then TMemo(Components[i]).text:='';
    if Components[i] is TEdit then TEdit(Components[i]).text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.edSubIDDblClick(Sender: TObject);
var
  FormIOParams: TfrmSubjektyParams;
begin
  if not (qrSubjekt.active and hasdata(qrSubjekt)) then
    Exit;

  FormIOParams := TfrmSubjektyParams.Create(FSUBJEKTY_PFO_ID, []);
  try
    FormIOParams.fpSearch:=qrSubjektID.AsInteger>0;
    FormIOParams.fpSearchFor :=qrSubjektID.AsString;
    frmSubjektyExec(FormIOParams, false);
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.edSubIDMouseEnter(Sender: TObject);
begin
  screen.cursor:=crHandPoint;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.edSubIDMouseLeave(Sender: TObject);
begin
  screen.cursor:=crDefault;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.btOKClick(Sender: TObject);
begin
  if not UlozData then
    exit;

  inherited;
  ModalResult := mrOK;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.qrSubjektBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  qrSubjekt.ParamByName('SUBJEKT').asInteger:=FSubjekt;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.sbAktualizovatClick(Sender: TObject);
begin
  qrSubSidlo.Close;
  qrSubjekt.Close;
  qrSubjekt.Open;
  qrSubSidlo.Open;
end;

// ..........................................................................
procedure TdlgSEC_Subjekt.Button1Click(Sender: TObject);
var
  FormIOParams: TfrmSubjektyParams;
  i:Integer;
begin
  FormIOParams :=nil;
  if trim(edICO.text)<>'' then
  begin
    i:=SelectInt('SELECT COUNT(*) FROM SUBJEKTY WHERE ICO='+Q(edICO.text));
    if i=0 then
    begin
      WarnInfo('Subjekt s IÈO="'+edICO.text+'" v agendì "Subjekty" nelalezen.'+EOL+
               'Dohledejte ho pøímo dle názvu a pøípadnì založte nový.');
      edICO.text:='';
    end;
    if i=1 then
    begin
      FSubjekt:=SelectInt('SELECT ID FROM SUBJEKTY WHERE ICO='+Q(edICO.text));
      sbAktualizovatclick(nil);
      exit;
    end;
  end;

  FormIOParams := TfrmSubjektyParams.Create(FSUBJEKTY_PFO_ID, []);
  try
    if trim(edICO.text)<>'' then
    begin
      FormIOParams.fpUseFilter:=true;
      FormIOParams.fpFilterCondition:=' ICO='+Q(edICO.text);
    end;
    if frmSubjektyExec(FormIOParams, true) then
    begin
      FSubjekt := FormIOParams.fpID;
      sbAktualizovatclick(nil);
    end;
  finally
    FormIOParams.Free;
    FormIOParams:=nil;
  end;
end;

// ..........................................................................
function TdlgSEC_Subjekt.UlozData: Boolean;
begin
  result:=false;
  if FSubjekt<0 then
  begin
    ErrorMsg('"Subjekt" musí být vybrán.');
    Exit;
  end;
  if (SelectInt('SELECT COUNT(*) FROM SEC '+
                ' WHERE SUBJEKT_TYP is null and SUBJEKT_PODTYP is null and  EDB_IDENT is null '+
                '   AND SUB_ID='+IntToStr(FSubjekt))>0) then
  begin
    ErrorMsg('Subjekt "'+qrSubjektNAZEV.asString+'" s ID='+IntToStr(FSubjekt)+
             ' a nevyplnìným Typem, Podtypem a identifikací EDB již v SEC existuje.');
    Exit;
  end;


  if FNewSec<0 then
    FNewSec:=selectInt('SELECT SEQ_SEC_ID.NEXTVAL FROM dual');
  ExecSqlText('INSERT INTO SEC (ID, SUB_ID) VALUES ('+IntToStr(FNewSec)+','+IntToStr(FSubjekt)+')');
  result:=true;
  qrSubSidlo.Close;
  qrSubjekt.Close;
end;

end.
