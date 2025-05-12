unit DSubjektyOsobyRejstrik;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Db, Mask,
  DBCtrls, NotiaDBComboBox, Ora, udmODAC, rxToolEdit, RXDBCtrl, FileCo,
  MemDS, DBAccess, NotiaImageButton;

const
  DSUBJEKTY_OSOBY_REJSTRIK_PFI_CISLO = $0001;
  DSUBJEKTY_OSOBY_REJSTRIK_PFI_ROS = $0002;
  DSUBJEKTY_OSOBY_REJSTRIK_PFI_RTO = $0003;

type
  TdlgSubjektyOsobyRejstrikParams = class(TfuncParams)
    fpCislo: Integer;
    fpCisloPol: Integer;
    fpROS: Integer;
    fpRTO: Integer;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

type
  TdlgSubjektyOsobyRejstrik = class(TacDialogOkStorno)
    dsMain: TOraDataSource;
    nbMain: TNotebook;
    lbJmeno: TLabel;
    lbPrijmeni: TLabel;
    lbRodnePrijmeni: TLabel;
    lbStatPrislusnost: TLabel;
    edJmeno: TDBEdit;
    edPrijmeni: TDBEdit;
    edRodnePrijmeni: TDBEdit;
    edStatPrislusnost: TDBEdit;
    lbRodneCislo: TLabel;
    edRodneCislo: TDBEdit;
    gbMistoNarozeni: TGroupBox;
    cbStat: TNotiaDBComboBox;
    cbOkres: TNotiaDBComboBox;
    cbObec: TNotiaDBComboBox;
    btOkres: TButton;
    btObec: TButton;
    btStat: TButton;
    qrMain: TOraQuery;
    qrMainCISLO: TIntegerField;
    qrMainPRIJMENI: TWideStringField;
    qrMainJMENO: TWideStringField;
    qrMainTITUL: TWideStringField;
    qrMainPOHLAVI: TSmallintField;
    qrMainRODNE_PRIJM: TWideStringField;
    qrMainDAT_NAROZENI: TDateTimeField;
    qrMainMISTO_NAROZENI: TWideStringField;
    qrMainRC: TWideStringField;
    qrMainST_KOD: TWideStringField;
    qrMainSTAT_NAROZENI: TWideStringField;
    lbJmeno2: TLabel;
    lbPrijmeni2: TLabel;
    lbRodnePrijmeni2: TLabel;
    lbStatPrislusnost2: TLabel;
    edJmeno2: TDBEdit;
    edPrijmeni2: TDBEdit;
    edRodnePrijmeni2: TDBEdit;
    edStatPrislusnost2: TDBEdit;
    lbPohlavi: TLabel;
    gbMistoNarozeni2: TGroupBox;
    cbStat2: TNotiaDBComboBox;
    btStat2: TButton;
    lbDatumNarozeni: TLabel;
    edDatumNarozeni: TDBDateEdit;
    cbPohlavi: TComboBox;
    Label1: TLabel;
    qrSoapBody: TOraQuery;
    qrSoapBodySESSIONID: TFloatField;
    qrSoapBodyKOD: TWideStringField;
    qrSoapBodyI1: TFloatField;
    qrSoapBodyI2: TFloatField;
    qrSoapBodyS1: TWideStringField;
    qrSoapBodyS2: TWideStringField;
    qrSoapBodyS3: TWideStringField;
    qrSoapBodyS4: TWideStringField;
    qrSoapBodyS5: TWideStringField;
    qrSoapBodySESSIONDATE: TDateTimeField;
    btOdeslatPDF: TButton;
    qrPrilohy: TOraQuery;
    qrPrilohyID: TIntegerField;
    qrPrilohyDOC_ID: TIntegerField;
    qrPrilohyNAZEV: TWideStringField;
    qrPrilohyZAPSAL: TWideStringField;
    qrPrilohyZAPSANO: TDateTimeField;
    qrPrilohyZMENIL: TWideStringField;
    qrPrilohyZMENENO: TDateTimeField;
    qrPrilohyPRILOHA: TBlobField;
    fcPriloha: TFileContainer;
    dsPrilohy: TOraDataSource;
    cKJmPrij: TCheckBox;
    cKJmPrijCZ: TCheckBox;
    btAdmin: TButton;
    qrMainSUBJEKT: TIntegerField;
    qrMainCIZINEC_CZ: TSmallintField;
    qrSoapBodyDATA_CLOB: TMemoField;
    qrSoapBodyDATA_BLOB: TBlobField;
    Label2: TLabel;
    edObec2: TDBEdit;
    Label3: TLabel;
    edOkres2: TDBEdit;
    qrMainOKRES_NAROZENI: TWideStringField;
    qrMainOBEC_NAROZENI: TWideStringField;
    sbProblem: TNotiaImageButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qrMainSTAT_NAROZENIGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMainSTAT_NAROZENISetText(Sender: TField;
      const Text: String);
    procedure qrMainOKRES_NAROZENIGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMainOKRES_NAROZENISetText(Sender: TField;
      const Text: String);
    procedure qrMainOBEC_NAROZENIGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMainOBEC_NAROZENISetText(Sender: TField;
      const Text: String);
    procedure qrMainOBEC_NAROZENIChange(Sender: TField);
    procedure cbPohlaviClick(Sender: TObject);
    procedure btOkresClick(Sender: TObject);
    procedure btObecClick(Sender: TObject);
    procedure btStatClick(Sender: TObject);
    procedure btOdeslatXMLPDFClick(Sender: TObject);
    procedure btAdminClick(Sender: TObject);
    procedure cbStatChange(Sender: TObject);
    procedure qrMainAfterOpen(DataSet: TDataSet);
    procedure sbProblemClick(Sender: TObject);
  private
    FPublicKey: string;
    FPrivateKey: string;
    FSoapResponse: String;
    FROS: integer;
    FPol: integer;
    FRTO: integer;
    procedure InitOkresyCombo;
    procedure InitObceCombo;
    procedure InitStatyCombo;
    procedure SetPrivateKey(const Value: string);
    procedure SetPublicKey(const Value: string);
    procedure SetSoapResponse(const Value: String);
  protected
    procedure OdeslatXMLClick;
    property PublicKey:string read FPublicKey write SetPublicKey;
    property PrivateKey:string read FPrivateKey write SetPrivateKey;
    property SoapResponse:String read FSoapResponse write SetSoapResponse;
    procedure OnOK(var Accept: boolean); override;
    function OdeslatSOAP(_Soap:String):boolean;
  public
    protokol:String;
    procedure Init;
    function NactiData:Boolean;
  end;


var
  dlgSubjektyOsobyRejstrik: TdlgSubjektyOsobyRejstrik;
  WSDL:Integer=0;

function dlgSubjektyOsobyRejstrikExec(_Params: TFuncParams;_Show:Boolean =True): boolean;

implementation

{$R *.DFM}

uses Tools, Utils, Caches, Queries, FOkresy, FObce, FStaty,uStoredProcs,
//     FAdmin,
     USimpleSOAP,Cestina, FileIo, ShellAPi, NConsts, uDBUtils, uUCLConsts,
     FSeznamPriloh, DRosPol, FRos, FSubjekty, FRejstrikTrestuOsoby, DlgMess;

{ TET }
{ ------------------------------------------------------------------------- }
type
  TET = class(TThread)
    private
      EC: DWORD;
      SI: TStartupInfo;
      PI: TProcessInformation;
      procedure ThreadEnd(Sender: TObject);
    protected
      procedure Execute; override;
    public
      StdEnd:TNotifyEvent;
      StdEndProc:TProcedure;
      constructor Create(const _App: String; _Vis: Word);
    end;


{ ......................................................................... }
constructor TET.Create(const _App: String; _Vis: Word);
begin
  StdEnd:=nil;
  EC := MAXDWORD;
  ZeroMemory(@SI, Sizeof(SI));
  ZeroMemory(@PI, Sizeof(PI));
  SI.cb := Sizeof(SI);
  SI.dwFlags := STARTF_USESHOWWINDOW;
  SI.wShowWindow := _Vis;
  FreeOnTerminate:=True;
  inherited Create(True); //true=jeste nespustit process
  Priority := tpNormal;
  OnTerminate:=ThreadEnd;
  if not CreateProcess(nil, PChar(_App),
                       nil, nil, False, NORMAL_PRIORITY_CLASS,
                       nil, nil, SI, PI) then
    begin
      Beep;
      EXIT;
    end;

end;
{ ......................................................................... }
procedure TET.Execute;
begin
  WaitForSingleObject(PI.hProcess, INFINITE); //infinite=neomezene dlouho
end;

{ ......................................................................... }
procedure TET.ThreadEnd(Sender: TObject);
begin
  if Assigned(StdEnd) then StdEnd(Sender);
  if Assigned(StdEndProc) then StdEndProc;
end;
// --------------------------------------------------------------------------




{ TdlgSubjektyOsobyRejstrikParams }
// --------------------------------------------------------------------------
constructor TdlgSubjektyOsobyRejstrikParams.Create(
  const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpCislo:=0;
  fpCisloPol:=0;
  fpROS:=0;
  fpRTO:=0;
  inherited Create(_IOFlags,_ActionFlags, _OnDataChanged,_BeforeOKEvent);
end;
// --------------------------------------------------------------------------



var
  XSLTResult:boolean;

procedure SendXML2Signed;
begin
  XSLTResult:=True;
end;


// --------------------------------------------------------------------------
function dlgSubjektyOsobyRejstrikExec(_Params: TFuncParams;_Show:Boolean =True): boolean;
begin
  PrepareForm(TdlgSubjektyOsobyRejstrik, dlgSubjektyOsobyRejstrik, true);

  with dlgSubjektyOsobyRejstrik do
  begin
    Params := _Params;
    if _Show then
      Result := (ShowModal = mrOK)
    else
      result:=dlgSubjektyOsobyRejstrik.NactiData;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsobyRejstrik.Init;
begin
  FROS:=0;
  FRTO:=0;
  FPol:=0;
  if (PublicKey='') or (PrivateKey='') then
    begin
      nbMain.ActivePage:='ErrorKey';
      btOdeslatPDF.enabled:=False;
    end
  else
    if Assigned(Params) then
    with TdlgSubjektyOsobyRejstrikParams(Params) do
    begin
      if FlagIsSet(DSUBJEKTY_OSOBY_REJSTRIK_PFI_ROS) then
        FROS:=fpROS;
      if FlagIsSet(DSUBJEKTY_OSOBY_REJSTRIK_PFI_RTO) then
        FRTO:=fpRTO;
      FPol:=fpCisloPol;


      if FROS=1 then
        qrMain.SQL.Text:='SELECT ID as SUBJEKT, ID as CISLO, PRIJMENI, JMENO, TITUL, POHLAVI, RODNE_PRIJM, DAT_NAROZENI, MISTO_NAROZENI, RC, ST_KOD,'+
                         'STAT_NAROZENI, OKRES_NAROZENI, OBEC_NAROZENI, CIZINEC_CZ FROM ROS WHERE ID=:ID'
      else
        if FRTO=1 then
          qrMain.SQL.Text:='SELECT ID as SUBJEKT, ID as CISLO, PRIJMENI, JMENO, TITUL, POHLAVI, RODNE_PRIJM, DAT_NAROZENI, MISTO_NAROZENI, RC, ST_KOD,'+
                           'STAT_NAROZENI, OKRES_NAROZENI, OBEC_NAROZENI, CIZINEC_CZ FROM RT_OSOBY WHERE ID=:ID'
        else
          qrMain.SQL.Text:='SELECT SUBJEKT, CISLO, PRIJMENI, JMENO, TITUL, POHLAVI, RODNE_PRIJM, DAT_NAROZENI, MISTO_NAROZENI, RC, ST_KOD,'+
                           'STAT_NAROZENI, OKRES_NAROZENI, OBEC_NAROZENI, CIZINEC_CZ FROM SUBJEKTY_OSOBY WHERE CISLO=:ID';

      if FlagIsSet(DSUBJEKTY_OSOBY_REJSTRIK_PFI_CISLO) then
        qrMain.ParamByName('ID').AsInteger := fpCislo;

      qrMain.Open;
      qrMain.Edit;
      if (qrMainST_KOD.AsString='CZ') or (qrMainCIZINEC_CZ.AsInteger=1) then
        nbMain.ActivePage:='CZ'
      else
      begin
        nbMain.ActivePage:='Ostatni';
        cbPohlavi.ItemIndex:=qrMainPOHLAVI.AsInteger;
      end;

    end;
end;

// ..........................................................................
procedure TdlgSubjektyOsobyRejstrik.FormShow(Sender: TObject);
begin
  inherited;
  btAdmin.enabled:=GetPermission(perm_isucl_administrator) or
                   GetPermission(perm_isucl_vse);
  btOdeslatPDF.enabled:=True;
  init;
end;

// ..........................................................................
function TdlgSubjektyOsobyRejstrik.NactiData: Boolean;
begin
  result:=false;
  btOdeslatPDF.enabled:=True;
  protokol:='';
  init;
  if btOdeslatPDF.enabled then
  begin
    OdeslatXMLClick;
    result:=true;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyOsobyRejstrik.InitObceCombo;
begin
  InitComboSql(cbObec, QS_Obce_Nazev_Combo);
  cbObec.Items.Insert(0,'');
end;

// ..........................................................................
procedure TdlgSubjektyOsobyRejstrik.InitOkresyCombo;
begin
  InitComboSql(cbOkres, QS_Okresy_Nazev_Combo);
  cbOkres.Items.Insert(0,'');
end;

// ..........................................................................
procedure TdlgSubjektyOsobyRejstrik.InitStatyCombo;
begin
  InitComboSql(cbStat, QS_Staty_Kod_Combo);
  cbStat.Items.Insert(0,'');
  cbStat2.Items.Assign(cbStat.Items);
end;

// ..........................................................................
procedure TdlgSubjektyOsobyRejstrik.FormCreate(Sender: TObject);
var
  qrTemp:TOraQuery;
begin
  inherited;
  InitStatyCombo;
  InitOkresyCombo;
  InitObceCombo;
  PublicKey:='';
  PrivateKey:='';
  qrTemp:=CreateQueryOpen('SELECT * FROM RSA_KEYS WHERE UZIVATEL=''_IS_UCL_'' AND KOD=''SOAP_RT'' ');
  try
    if hasdata(qrTemp) then
    begin;
//      PublicKey:=qrTemp.FieldByName('PUBLIC_KEY_MOD').asString;
//      if PublicKey='' then
        PublicKey:=qrTemp.FieldByName('PUBLIC_KEY_CERT').asString;
//      PrivateKey:=qrTemp.FieldByName('PRIVATE_KEY_MOD').asString;
//      if PrivateKey='' then
        PrivateKey:=qrTemp.FieldByName('PRIVATE_KEY_CERT').asString;
//      PrivateKey:=StringReplace(PrivateKey,Chr(13)+Chr(10),Chr(10),[rfReplaceAll]);
    end;
  finally
    qrTemp.Free;
  end;
(*
  qrTemp:=CreateQueryOpen('SELECT * FROM CR_KEYS WHERE KOD=''SOAP_RT'' ');
  try
    if hasdata(qrTemp) then
    begin;
      PublicKey:=qrTemp.FieldByName('PUBLIC_KEY').asString;
      PrivateKey:=qrTemp.FieldByName('PRIVATE_KEY').asString;
    end;
  finally
    qrTemp.Free;
  end;
*)

end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.qrMainSTAT_NAROZENIGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then Text := '' else Text := CachedSTATY(Sender.AsString);
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.qrMainSTAT_NAROZENISetText(
  Sender: TField; const Text: String);
begin
  Sender.AsString := CachedOBCEnum(Text);
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.qrMainOKRES_NAROZENIGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then Text := '' else Text := CachedOKRESY(Sender.AsString);
  if Text='' then Text:=Sender.AsString;
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.qrMainOKRES_NAROZENISetText(
  Sender: TField; const Text: String);
var
  t:String;
begin
  t := CachedOKRESYnum(Text);
  if t='' then Sender.AsString:=Text
          else Sender.AsString := t;
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.qrMainOBEC_NAROZENIGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then Text := '' else Text := CachedOBCE(Sender.AsString);
  if Text='' then Text:=Sender.AsString;
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.qrMainOBEC_NAROZENISetText(
  Sender: TField; const Text: String);
var
  t:String;
begin
  t := CachedOBCEnum(Text);
  if t='' then Sender.AsString:=Text
          else Sender.AsString := t;
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.qrMainOBEC_NAROZENIChange(
  Sender: TField);
begin
  if qrMainOKRES_NAROZENI.IsNull then
    qrMainOKRES_NAROZENI.AsString:=SelectStr('SELECT OKRES FROM OBCE WHERE KOD='+Q(qrMainOBEC_NAROZENI.AsString));
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.OnOK(var Accept: boolean);
begin
  inherited;
  if nbMain.ActivePage='CZ' then

  begin
    if qrMainRC.IsNull then
    begin
      ErrorMsg('Rodné èíslo musí být vyplnìno!');
      edRodneCislo.SetFocus;
      Accept := false;
      exit;
    end;
    if qrMainSTAT_NAROZENI.IsNull then
    begin
      ErrorMsg('Stát narození musí být vyplnìn!');
      cbStat.SetFocus;
      Accept := false;
      exit;
    end;
    if qrMainSTAT_NAROZENI.asString='CZ' then
    begin
      if qrMainOBEC_NAROZENI.IsNull then
      begin
        ErrorMsg('Obec narození musí být vyplnìna!');
        cbObec.SetFocus;
        Accept := false;
        exit;
      end;
      if qrMainOKRES_NAROZENI.IsNull then
      begin
        ErrorMsg('Okres narození musí být vyplnìn!');
        cbOkres.SetFocus;
        Accept := false;
        exit;
      end;
    end;
  end

  else

  begin
    if qrMainPOHLAVI.AsInteger<1 then
    begin
      ErrorMsg('Pohlaví musí být vyplnìno!');
      cbPohlavi.SetFocus;
      Accept := false;
      exit;
    end;
    if qrMainDAT_NAROZENI.IsNull then
    begin
      ErrorMsg('Datum narození musí být vyplnìno!');
      edDatumNarozeni.SetFocus;
      Accept := false;
      exit;
    end;
    if qrMainSTAT_NAROZENI.IsNull then
    begin
      ErrorMsg('Stát narození musí být vyplnìn!');
      cbStat2.SetFocus;
      Accept := false;
      exit;
    end;
  end;
  if qrMain.State=dsEdit then
    qrMain.Post;
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.cbPohlaviClick(Sender: TObject);
begin
  qrMainPOHLAVI.AsInteger:=cbPohlavi.ItemIndex;
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.btOkresClick(Sender: TObject);
var
  FormIOParams: TfrmOkresyParams;
begin
  FormIOParams := TfrmOkresyParams.Create(FOKRESY_PFO_KOD, [], InitOkresyCombo );
  try

    FormIOParams.fpSearch :=  cbOkres.Text <> '' ;
    FormIOParams.fpSearchFor :=  qrMainOKRES_NAROZENI.AsString;

    if frmOkresyExec(FormIOParams, true) then
    begin
      preparedata(qrMain);
      qrMainOKRES_NAROZENI.AsString := FormIOParams.fpKOD;
    end;  
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.btObecClick(Sender: TObject);
var
  FormIOParams: TfrmObceParams;
begin
  FormIOParams := TfrmObceParams.Create(FOBCE_PFO_KOD, [], InitObceCombo );
  try
    FormIOParams.fpSearch :=  cbObec.Text <> '' ;
    FormIOParams.fpSearchFor :=  qrMainOBEC_NAROZENI.AsString;

    if frmObceExec(FormIOParams, true) then
    begin
      preparedata(qrMain);
      qrMainOBEC_NAROZENI.AsString := FormIOParams.fpKOD;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgSubjektyOsobyRejstrik.btStatClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], InitStatyCombo );
  try
    FormIOParams.fpSearch :=  cbStat.Text <> '' ;
    FormIOParams.fpSearchFor :=  qrMainSTAT_NAROZENI.AsString;

    if frmStatyExec(FormIOParams, true) then
    begin
      preparedata(qrMain);
      qrMainSTAT_NAROZENI.AsString := FormIOParams.fpKOD;
    end;
  finally
    FormIOParams.Free;
  end;
end;

procedure TdlgSubjektyOsobyRejstrik.SetPrivateKey(const Value: string);
begin
  FPrivateKey := Value;
end;

procedure TdlgSubjektyOsobyRejstrik.SetPublicKey(const Value: string);
begin
  FPublicKey := Value;
end;

procedure TdlgSubjektyOsobyRejstrik.SetSoapResponse(const Value: String);
begin
  FSoapResponse := Value;
end;

procedure TdlgSubjektyOsobyRejstrik.btOdeslatXMLPDFClick(Sender: TObject);
begin
  try
    MessageExec('ROS', 'Probíhá ovìøování dat - R.T. ...');
    OdeslatXMLClick;
  finally
    MessageHide;
  end;
end;

procedure TdlgSubjektyOsobyRejstrik.OdeslatXMLClick;
var
  qrTemp:TOraQuery;
  onOkAccept:Boolean;
  SoapBody:String;
  SoapReq:String;
  SoapSignedHash:String;
  S,S2:TStringList;
  bSessionid:String;
  PKFile:string;
  InFile:string;
  OutFile:string;
  execbat:string;
  execbatPDF:string;
  GetKod:String;
  i:Integer;
  j:Integer;
  ErrorSoap:Boolean;
  JmPrij:Boolean;
  SoapOK:Boolean;
  FR:TFrameSeznamPriloh;
  t,tt:String;
  OnLine: boolean;
  PodDenikOUT:Integer;
  PodDenikIN:Integer;
  PrilohaID:Integer;
begin
  inherited;

//  bSessionid:=SelectStr('SELECT USERENV(''SESSIONID'') FROM DUAL');
  GetKod:='PDF';
  PodDenikOUT:=0;
  PodDenikIN:=0;

  if FROS=1 then
    begin
      PodDenikOUT:=Podaci_denik_novy('ROS',qrMainCISLO.asString,'','RT_OUT'); // odeslani
      SoapOK:=SOAP_RT_OSOBA(qrMainCISLO.asInteger,GetKod,Byte(jmPrij),1,1) // z ROSu
    end
  else
    if FRTO=1 then
      SoapOK:=SOAP_RT_OSOBA(qrMainCISLO.asInteger,GetKod,Byte(jmPrij),2,1) // z RTO
    else
       SoapOK:=SOAP_RT_OSOBA(qrMainCISLO.asInteger,GetKod,Byte(jmPrij),0,1); // ze subjektu

  t:='Prijmeni: '+edPrijmeni.text+EOL+
     'Jmeno:    '+edJmeno.text+EOL+
     'Rod.cislo:'+edRodneCislo.text+EOL;

  if (FROS=1) and assigned(dlgRosPol) then
    OperationLog(dlgRosPol,'VYPIS_RT',t)
  else
    if (FRTO=1) and assigned(frmRejstrikTrestuOsoby) then
      OperationLog(frmRejstrikTrestuOsoby,'VYPIS_RT',t)
    else
      if assigned(frmSubjekty) then
        OperationLog(frmSubjekty,'VYPIS_RT',t);

  if PodDenikOUT>0 then // uprava zaznamu
  begin
     PodDenikIN:=Podaci_denik_novy('ROS',qrMainCISLO.asString,'','RT_IN'); // prijem
     if PodDenikIN>0 then // uprava zaznamu
     begin
        ExecQuery('UPDATE PODACI_DENIK SET '+
                  ' MATKA='+IntToStr(PodDenikOUT)+
                  ' WHERE ID='+IntToStr(PodDenikIN));
     end;
  end;

  try
    FR:=TframeSeznamPriloh.Create(application);
    qrTemp:=CreateQueryOpen('SELECT I1, S1, DATA_CLOB,DATA_BLOB FROM SESSIONID_TEMP WHERE KOD=''RT_DATA'' AND SESSIONID=USERENV(''SESSIONID'') ');
    if Hasdata(qrTemp) then // mam nejaka data
    begin
      case qrTemp.fieldByName('I1').asInteger of
        0:begin // je PDF
            if FROS=1 then
              begin
               if FPol>0 then
                  FR.SetPK('ROS', qrMainSUBJEKT.asString+'_'+IntToStr(FPol))
                else
                  FR.SetPK('ROS', qrMainSUBJEKT.asString+'_');
              end
            else
              if FRTO=1 then
                FR.SetPK('RT_OSOBY', qrMainSUBJEKT.asString)
              else
                FR.SetPK('SUBJEKTY', qrMainSUBJEKT.asString);

            Application.Processmessages;
            PrilohaID:=FR.VlozitNovouPrilohuZDB('Vypis_z_RT.pdf', GetSessionid,'RT_DATA', false, False,-1,0,'Vypis_z_RT.pdf');
            Application.Processmessages;
            if PrilohaID>0 then
            begin
              execSqlText('UPDATE PRILOHY_DATA SET'+
                          '   CHARAKTERISTIKA='+Q(qrMainSUBJEKT.asString)+', '+
                          '   SOUBOR=''Vypis_z_RT.pdf'', '+
                          '   POPIS=''PDF_RT''||'' ('+trim(qrMainJMENO.asString+' '+qrMainPRIJMENI.asString)+')'' '+
                          ' WHERE ID='+IntToStr(PrilohaID));
              if PodDenikIN>0 then
                ExecQuery('INSERT INTO PRILOHY_NOVE (TABULKA, PK, PRILOHA_ID) '+
                          ' VALUES (''PODACI_DENIK'','+Q(IntToStr(PodDenikIN))+','+IntToStr(PrilohaID)+')');
              t:='Dotazovaná osoba nemá záznam v rejstøíku trestù'+EOL;
              if  (FPol>0) then
              begin // zpracovani PDF
                ExecSqlText('begin PDF_TO_TXT(null,null,'+IntToStr(PrilohaID)+'); end;');
                ExecSqlText('begin RT_INFO_FROM_PDF('+qrMainSUBJEKT.asString+','+IntToStr(FPol)+'); end;');
                if SelectInt('SELECT count(*) from ROS_POL where ID_ROS='+qrMainCISLO.asString+' AND CISLO='+IntToStr(FPol)+' and RT_INFO is null')=0 then
                   t:='Dotazovaná osoba MÁ záznam v rejstøíku trestù'+EOL;
              end;

              if isShowing then
              begin
               if Msg(t+'Zobrazit detail?' , 'Protokol z R.T.', MB_YESNO+MB_ICONINFORMATION)= ID_YES then
                  FR.OtevritPrilohu(PrilohaID, false)
               else
                 protokol:=protokol+t+EOL+EOL;
              end
            end;
          end; // 0
       else
         begin
           ErrorMsg(qrTemp.fieldByName('S1').asString);
         end;
      end; // case
    end;  // hasdata
    qrTemp.Close;
    FR.Close;
  finally
    FR.Free;
    qrTemp.free;
    FR:=nil;
    qrTemp:=nil;
  end;

(*
  WSDL:=GetIntParam('SOAP_RT_WSDL');
  qrTemp:=nil;
  S:=nil;
  FR:=nil;
//  if TComponent(Sender).Tag=1 then
    GetKod:='PDF';
//  else
//    GetKod:='XML';
  onOkAccept:=True;
  onOk(onOkAccept);
  if not onOkAccept then
    EXIT;

--  OnLine:=(nbMain.ActivePage='CZ') and (edRodneCislo.text<>'');
--  if not OnLine then
--    Inform('Zpracování bez rodného èísla. Odpovìï pøíjde emailem.');

  OnLine:=true;
  if not ((nbMain.ActivePage='CZ') and (edRodneCislo.text<>'')) then
    if isShowing then
      Inform('Zpracování bez rodného èísla.'+EOL+'Pokud nedojde k online odpovìdi, pøíjde výpis emailem.')
    else
      protokol:=protokol+'Zpracování bez rodného èísla.'+EOL+'Pokud nedojde k online odpovìdi, pøíjde výpis emailem.'+EOL;


  bSessionid:=SelectStr('SELECT USERENV(''SESSIONID'') FROM DUAL');
  PKFile:=AddBackSlash(GetEnvironmentVariable('TEMP'))+bSessionid+'.pem';
  InFile:=AddBackSlash(GetEnvironmentVariable('TEMP'))+bSessionid+'.in';
  OutFile:=AddBackSlash(GetEnvironmentVariable('TEMP'))+bSessionid+'.out';
  Deletefile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOkPDF.bin');
  DeleteFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapErr.xml');
  DeleteFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.xml');
  DeleteFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf');
  DeleteFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapResponse.xml');
  Deletefile(PKFile);
  Deletefile(InFile);
  Deletefile(OutFile);
  if WSDL>0 then
    execbat:=UpperCase(GetStringParam('XML_SSL_RT_WSDL'))
  else
    execbat:=UpperCase(GetStringParam('XML_SSL'));

  execbatPDF:=UpperCase(GetStringParam('XML_SSL_PDF'));
  if (qrMainST_KOD.AsString='CZ') or (qrMainCIZINEC_CZ.AsInteger=1) then
    jmPrij:=cKJmPrijCZ.Checked
  else
    jmPrij:=cKJmPrij.Checked;

  SoapOK:=false;
  if FROS=1 then
    SoapOK:=SOAP_RT_OSOBA(qrMainCISLO.asInteger,GetKod,Byte(jmPrij),1) // z ROSu
  else
    if FRTO=1 then
      SoapOK:=SOAP_RT_OSOBA(qrMainCISLO.asInteger,GetKod,Byte(jmPrij),2) // z RTO
    else
       SoapOK:=SOAP_RT_OSOBA(qrMainCISLO.asInteger,GetKod,Byte(jmPrij),0); // ze subjektu


  if SoapOK then
    try
      S:=TStringList.Create;
      S.Text:=PrivateKey;
      S.Text:=StringReplace(S.Text,Chr(13)+Chr(10),Chr(10),[rfReplaceAll]);
      S.SaveToFile(PKFile);  // ulozeni private klice

      try
        qrTemp:=CreateQueryOpen('SELECT DATA_CLOB,DATA_BLOB FROM SESSIONID_TEMP WHERE KOD=''SOAP:Body'' AND SESSIONID=USERENV(''SESSIONID'') ');
        if Hasdata(qrTemp) then // mam body
        begin
//        SoapBody:=qrTemp.FieldByName('DATA_CLOB').asString;
          SoapBody:=TBlobField(qrTemp.FieldByName('DATA_BLOB')).asString;
        end;
        qrTemp.close;
      finally
        qrTemp.free;
        qrTemp:=nil;
      end;
{
      if Length(SoapBody)>0 then  // jinak to nema smysl
      begin
//        SoapBody:=Win2Utf(SoapBody);
        ExecSQLText('DELETE SESSIONID_TEMP '
                   +' WHERE SESSIONID=USERENV(''SESSIONID'') AND KOD=''SOAP:Body'' ');
        qrSoapBody.Open;
        try
          qrSoapBody.Session.StartTransaction;
          qrSoapBody.Insert;
          qrSoapBody.FieldByName('KOD').asString:='SOAP:Body';
          qrSoapBody.FieldByName('DATA_CLOB').asString:=SoapBody;
//        ExecSQLText('Insert into SESSIONID_TEMP(KOD,DATA_CLOB) '
//                    +' VALUES(''SOAP:Body'','''+SoapBody+''')');
          qrSoapBody.Post;
          qrSoapBody.Session.Commit;
        except
          qrSoapBody.Session.Rollback;
        end;
        qrSoapBody.Close;
}
        if SOAP_RT_DATA(0) then // jinak to nema smysl
        begin
          try
            qrTemp:=CreateQueryOpen('SELECT DATA_CLOB, DATA_BLOB FROM SESSIONID_TEMP WHERE KOD=''SOAP:Complet'' AND SESSIONID=USERENV(''SESSIONID'') ');
            if Hasdata(qrTemp) then // mam celek
            begin
//              SoapReq:=qrTemp.FieldByName('DATA_CLOB').asString;
              SoapReq:=TBlobField(qrTemp.FieldByName('DATA_BLOB')).asString;
              TBlobField(qrTemp.FieldByName('DATA_BLOB')).saveTofile(InFile);
            end;
            qrTemp.Close;
          finally
            qrTemp.free;
            qrTemp:=nil;
          end;

          if Length(SoapReq)>0 then  // jinak to nema smysl
          begin

            S.Text:=SoapReq;
//          inform('STOP');
//            S.SaveToFile(InFile);  // ulozeni zdrojoveho dokumentu

            Chdir(ExtractFilePath(execbat));
            execbat:='"'+execbat+'" "'+PKFile+'" "'+InFile+'" "'+OutFile+'"';
            With TET.Create(execbat,SW_SHOWNormal) do
            begin
              XSLTResult:=False;
              StdEndProc:=SendXML2Signed;
              Resume; //spustí proces
            end;
            While not XSLTResult do Application.ProcessMessages; // <MK> fuj to je humus ale nechce se mi to delat slozitejsi
            chdir(ExtractFilePath(paramstr(0)));


//          inform('STOP1');
            S.LoadFromFile(OutFile);

            ExecSQLText('DELETE SESSIONID_TEMP '
                       +' WHERE SESSIONID=USERENV(''SESSIONID'') AND KOD=''SOAP:Request'' ');

            qrSoapBody.close;


            qrSoapBody.Open;
            try
              qrSoapBody.Session.StartTransaction;
              qrSoapBody.KeyFields:='SESSIONID;KOD';
              qrSoapBody.Insert;
              qrSoapBody.FieldByName('SESSIONID').asString:=bSessionid;
              qrSoapBody.FieldByName('KOD').asString:='SOAP:Request';
              qrSoapBody.FieldByName('DATA_CLOB').asString:=S.Text;
              TBlobField(qrSoapBody.FieldByName('DATA_BLOB')).LoadFromfile(OutFile);
              qrSoapBody.Post;
              qrSoapBody.Session.Commit;
            except
              qrSoapBody.Session.Rollback;
            end;
            qrSoapBody.Close;


//          inform('STOP');
//          Abort;
*)

(*  Zurnal
            if FROS=1 then
            begin
              if FPol>0 then
              begin
                t:=SelectStr('SELECT CISJED FROM ROS_DATA_POL WHERE ID_ROS='+qrMainCISLO.asString+' AND CISLO='+IntToStr(FPol));
                New_zurnal(t,'Osvìdèení',
                           'ROS',qrMainCISLO.asString+'_'+IntToStr(FPol),'Odeslání do R.T.','RT')
              end
              else
              begin
                t:=SelectStr('SELECT CISJED FROM ROS_DATA WHERE ID='+qrMainCISLO.asString);
                New_zurnal(t,'',
                           'ROS',qrMainCISLO.asString+'_','Odeslání do R.T.','RT');
              end;
//              execSqlText('INSERT INTO TCPIP_SEND_LOG(UZIVATEL, KOD, OBJEKT, PK_OBJEKT, DATUM)' // log
//                         +'VALUES(USER, ''SOAP_RT'', ''ROS'', '+qrMainCISLO.asString+', SYSDATE)');

              PodDenikOUT:=Podaci_denik_novy('ROS',qrMainCISLO.asString,'','RT_OUT'); // odeslani
              if PodDenikOUT>0 then // uprava zaznamu
              begin
              end;
            end
            else
              if FRTO=1 then
                execSqlText('INSERT INTO TCPIP_SEND_LOG(UZIVATEL, KOD, OBJEKT, PK_OBJEKT, DATUM)' // log
                           +'VALUES(USER, ''SOAP_RT'', ''RT_OSOBY'', '+qrMainCISLO.asString+', SYSDATE)')
              else
                execSqlText('INSERT INTO TCPIP_SEND_LOG(UZIVATEL, KOD, OBJEKT, PK_OBJEKT, DATUM)' // log
                         +'VALUES(USER, ''SOAP_RT'', ''SUBJEKTY_OSOBY'', '+qrMainCISLO.asString+', SYSDATE)');
*)

(*

//      odeslat
            case WSDL of
              2:try // wsdl pres ORACLE
                  SoapResponse:='';
                  ErrorSoap:=true;
                  execSqlText('INSERT INTO SESSIONID_TEMP(KOD, DATA_CLOB)'
                              +'VALUES(''SOAP_RT'', ''SUBJEKTY_OSOBY'', '+Q(S.Text)+')');
                  execSqlText('Begin soap_rt_odeslat; end;');
                  ErrorSoap:=false;
                  try
                    qrTemp:=CreateQueryOpen('SELECT DATA_CLOB,DATA_BLOB FROM SESSIONID_TEMP WHERE KOD=''SOAPRESPONSE'' AND SESSIONID=USERENV(''SESSIONID'') ');
                    if Hasdata(qrTemp) then // mam body
                    begin
//                      SoapBody:=qrTemp.FieldByName('DATA_CLOB').asString;
                      SoapResponse:=TBlobField(qrTemp.FieldByName('DATA_BLOB')).asString;
                    end;
                    qrTemp.close;
                  finally
                    qrTemp.free;
                    qrTemp:=nil;
                  end;
                finally
                  ErrorSoap:=SoapResponse<>'';
                end;
              1:begin // wsdl jak dtd
                  ErrorSoap:=not OdeslatSoap(S.Text);
                end;
            else // DTD
              begin
                ErrorSoap:=not OdeslatSoap(S.Text);
              end;
            end; // case

// zpracovani odpovedi
          if not ErrorSoap then  // dilci kontroly
          begin
*)

(* podaci denil

            PodDenikIN:=Podaci_denik_novy('ROS',qrMainCISLO.asString,'','RT_IN'); // prijem
            if PodDenikIN>0 then // uprava zaznamu
            begin
               ExecQuery('UPDATE PODACI_DENIK SET '+
                         ' MATKA='+IntToStr(PodDenikOUT)+
                         ' WHERE ID='+IntToStr(PodDenikIN));
            end;
*)

(*
            case WSDL of
              2:Begin // nutne dodelat
                  SoapResponse:='';

//                  if pos('<?xml version="1.0"',SoapResponse)=0 then
//                    ErrorSoap:=True;
                end;
              1:Begin
                  S.Text:=SoapResponse;
                  if pos('<ns3:chyba>',SoapResponse)>0 then // nutne overit
                    ErrorSoap:=True;
//                  if pos('<?xml version="1.0"',SoapResponse)=0 then
//                    ErrorSoap:=True;
                end;
            else
              begin
                S.Text:=SoapResponse;
                if pos('<chyba>',SoapResponse)>0 then
                  ErrorSoap:=True;
                if pos('<?xml version="1.0"',SoapResponse)=0 then
                  ErrorSoap:=True;
              end;
            end; // case
         if not ErrorSoap then
           begin
              S.Text:=SoapResponse;
              if pos('error',SoapResponse)>0 then
                ErrorSoap:=True;
              if pos('temporarily unavailable',SoapResponse)>0 then
                ErrorSoap:=True;
            end;

         if not (ErrorSoap or OnLine) then
           EXIT;

          if not ErrorSoap and (pos('manualni',SoapResponse)=0) then  //mely by byt nejaka data
            try
              FR:=TframeSeznamPriloh.Create(application);
              S.SaveToFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapResponse.xml');
              case WSDL of
                2:Begin end; // nutne dodelat
                1:Begin
                    i:=Pos('<ns2:dokumentPDF>',S.Text);
                    S.Text:=Copy(S.Text,i+Length('<ns2:dokumentPDF>'),MaxInt); // odriznuti XML casti pred
                    i:=Pos('</ns2:dokumentPDF>',S.Text);
                    S.Text:=Copy(S.Text,1,i-1); // odriznuti XML casti za
                    S.Text;t:='';
                    j:=length(S.text);
                    i:=1;
                    try
                      S2:=TStringList.create;
                      repeat
                        t:=Copy(S.Text,1+((i-1)*76),76);
                        S2.add(t);
                        inc(i);
                      until (i=100000) or (1+((i-1)*76)>j);
                      S2.SaveToFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOkPDF.bin');
                      S.text:=S2.text;
                    finally
                      S2.free;
                    end;

                    Chdir(ExtractFilePath(execbatpdf));
                    execbatpdf:='"'+execbatpdf+'" "'+AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOkPDF.bin'+'" "'+AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf"';



                  With TET.Create(execbatpdf,SW_SHOWNormal) do
                  begin
                   XSLTResult:=False;
                   StdEndProc:=SendXML2Signed;
                   Resume; //spustí proces
                  end;
                  While not XSLTResult do Application.ProcessMessages; // <MK> fuj to je humus ale nechce se mi to delat slozitejsi
                  chdir(ExtractFilePath(paramstr(0)));
                  if not fileExists(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf') then
                    ErrorSoap:=True
                  else
                    begin
*)

(* Priloha
                      if FROS=1 then
                      begin
                        if FPol>0 then
                          FR.SetPK('ROS', qrMainSUBJEKT.asString+'_'+IntToStr(FPol))
                        else
                          FR.SetPK('ROS', qrMainSUBJEKT.asString+'_');
                      end
                      else
                        if FRTO=1 then
                          FR.SetPK('RT_OSOBY', qrMainSUBJEKT.asString)
                        else
                          FR.SetPK('SUBJEKTY', qrMainSUBJEKT.asString);
                      PrilohaID:=FR.VlozitNovouPrilohu(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf',false, false, false);
                      if PrilohaID>0 then
                      begin
                        execSqlText('UPDATE PRILOHY_DATA SET'+
                                    '   CHARAKTERISTIKA='+Q(qrMainSUBJEKT.asString)+', '+
                                    '   SOUBOR=''Vypis_z_RT.pdf'', '+
                                    '   POPIS=''PDF_RT''||'' ('+trim(qrMainJMENO.asString+' '+qrMainPRIJMENI.asString)+')'' '+
                                    ' WHERE ID='+IntToStr(PrilohaID));
                        if PodDenikIN>0 then
                          ExecQuery('INSERT INTO PRILOHY_NOVE (TABULKA, PK, PRILOHA_ID) '+
                                    ' VALUES (''PODACI_DENIK'','+Q(IntToStr(PodDenikIN))+','+IntToStr(PrilohaID)+')');
                      end;
                      FR.Close;
                    end;

                  end; // nutne dodelat
              else // DTD
                begin // GetKod='pdf'
                  i:=Pos('Content-Type: application/pdf',S.Text);
                  S.Text:=Copy(S.Text,i,MaxInt); // odriznuti XML casti
                  i:=Pos('Content-Length: ',S.Text)+Length('Content-Length: ');
                  S.Text:=Copy(S.Text,i,MaxInt);
                  i:=Pos(#10,S.Text);
                  S.Text:=Copy(S.Text,i,MaxInt);
                  While (S.Text[i]=#10) or (S.Text[i]=#13) or (S.Text[i]=' ') do inc(i);
                  j:=Pos('------=_Part',S.Text);
                  S.Text:=Copy(S.Text,i-3,j-i+1);
                  S.SaveToFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOkPDF.bin');

                  Chdir(ExtractFilePath(execbatpdf));
                  execbatpdf:=execbatpdf+' '+AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOkPDF.bin'+' '+AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf';

                  With TET.Create(execbatpdf,SW_SHOWNormal) do
                  begin
                   XSLTResult:=False;
                   StdEndProc:=SendXML2Signed;
                   Resume; //spustí proces
                  end;
                  While not XSLTResult do Application.ProcessMessages; // <MK> fuj to je humus ale nechce se mi to delat slozitejsi
                  chdir(ExtractFilePath(paramstr(0)));
                  if not fileExists(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf') then
                    ErrorSoap:=True
                  else
                    begin
                      if FROS=1 then
                      begin
                        if FPol>0 then
                          FR.SetPK('ROS', qrMainSUBJEKT.asString+'_'+IntToStr(FPol))
                        else
                          FR.SetPK('ROS', qrMainSUBJEKT.asString+'_')
                      end
                      else
                        if FRTO=1 then
                          FR.SetPK('RT_OSOBY', qrMainSUBJEKT.asString)
                        else
                          FR.SetPK('SUBJEKTY', qrMainSUBJEKT.asString);
                      PrilohaID:=FR.VlozitNovouPrilohu(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf',false, false, false);
                      if PrilohaID>0 then
                      begin
                        execSqlText('UPDATE PRILOHY_DATA SET'+
                                    '   CHARAKTERISTIKA='+Q(qrMainSUBJEKT.asString)+', '+
                                    '   SOUBOR=''Vypis_z_RT.pdf'', '+
                                    '   POPIS=''PDF_RT''||'' ('+trim(qrMainJMENO.asString+' '+qrMainPRIJMENI.asString)+')'' '+
                                    ' WHERE ID='+IntToStr(PrilohaID));
                      end;
                      FR.Close;
                    end;
                end;
              end; // case
            finally
              FR.Free;
            end;

            if not ErrorSoap then  //vse je v poradku
              if pos('manualni',SoapResponse)>0 then
                begin
                  if isShowing then
                    inform('Žádost byla pøedána pro ruèní zpracování.'+EOL+
                           'Výsledek bude odeslán emailem.')
                  else
                    protokol:=protokol+'Žádost byla pøedána pro ruèní zpracování.'+EOL+
                           'Výsledek bude odeslán emailem.'+EOL;
                end
              else
                if (pos('<zaznam>',SoapResponse)>0) or (pos(':zaznam>',SoapResponse)>0) then
                  begin
                    if (PrilohaID>0) and (FPol>0) then
                    begin // zpracovani PDF
                      ExecSqlText('begin PDF_TO_TXT(null,null,'+IntToStr(PrilohaID)+'); end;');
                      ExecSqlText('begin RT_INFO_FROM_PDF('+qrMainSUBJEKT.asString+','+IntToStr(FPol)+'); end;');
                    end;
                    if isShowing then
                    begin
                      if Warn('Dotazovaná osoba má záznam v rejstøíku trestù'+EOL+
                            'Zobrazit detail?') then
                        ShellExecute(0,'open',pchar(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf'),nil,nil,sw_show)
                    end
                    else
                      protokol:=protokol+'Dotazovaná osoba má záznam v rejstøíku trestù'+EOL+EOL;
                  end
                else
                  begin
                    if isShowing then
                    begin

                      if Msg('Dotazovaná osoba nemá záznam v rejstøíku trestù'+EOL+
                             'Zobrazit detail?' , 'Chyba', MB_YESNO+MB_ICONINFORMATION)= ID_YES then
                        ShellExecute(0,'open',pchar(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf'),nil,nil,sw_show)
                    else
                      protokol:=protokol+'Dotazovaná osoba nemá záznam v rejstøíku trestù'+EOL+EOL;
                    end
                  end
            else // chyba
              begin
                S.Text:=SoapResponse;
                i:=Pos('<html',S.Text); // preskoceni doctype
                if i>20 then
                  S.Text:=Copy(S.Text,i);

                S.SaveToFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapErr.xml');
                Beep;
                if isShowing then
                begin
                  if Msg('Pøi komunikaci s rejstøíkem trestù došlo k chybì.'+EOL+
                         'Zobrazit detail?' , 'Chyba', MB_YESNO+MB_ICONHAND)= ID_YES then
                    begin
                      if GetDefaultBrowser(False)<>'' then
                        WinExec(pansichar(ansistring(GetDefaultBrowser+' '+AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapErr.xml')),SW_SHOW)
                      else
                        ShellExecute(0,'open',pchar(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapErr.xml'),nil,nil,sw_show)
                    end;
                end
                else
                  protokol:=protokol+'Pøi komunikaci s rejstøíkem trestù došlo k chybì.'+EOL+EOL;
              end
            end
          end
          else
          begin
          end;
        end
        else
        begin
        end; // SOAP_RT_DATA(0)
      end; // Length(SoapBody)>0
    finally
      chdir(ExtractFilePath(paramstr(0)));
      Deletefile(PKFile);
      Deletefile(InFile);

--      Deletefile(OutFile);
--      DeleteFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapErr.xml');
--      Deletefile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOkPDF.bin');
--      DeleteFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.xml');
--      DeleteFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapOk.pdf');
--      DeleteFile(AddBackSlash(GetEnvironmentVariable('TEMP'))+'SoapResponse.xml');

      S.Free;
      qrSoapBody.Close;
      qrPrilohy.Close;
      qrTemp.Free;
    end;
*)
end;

function TdlgSubjektyOsobyRejstrik.OdeslatSOAP(_Soap:String): boolean;
var
  vXMLData : string;
  vXML : TStringList;
  vSimpleSoap : TSimpleSOAP;
  S:TStringList;
  URL:String;
  HOST:String;
  Zadost:String;
begin
  if WSDL=0 then
  begin
    URL:=GetStringParam('SOAP_RT_URL');
    HOST:=GetStringParam('SOAP_RT_HOST');
    Zadost:=GetStringParam('SOAP_RT_AKCE');
  end
  else
  begin
    URL:=GetStringParam('SOAP_RT_URL_WSDL');
    HOST:=GetStringParam('SOAP_RT_HOST_WSDL');
    Zadost:=GetStringParam('SOAP_RT_AKCE_WSDL');
  end;
  result:=True;
  vXMLData :=_Soap;
  vXML := TStringList.Create;
  vSimpleSoap := TSimpleSOAP.Create(Application,
   URL,
   HOST,
   '',
   443);
  try
    try
      vXML.Text := vSimpleSoap.Invoke(
        '',
        Zadost,
         vXMLData);
      SoapResponse:=vXML.Text;
    except
      result:=False;
      Raise;
    end;
  finally
    vXML.Free;
    vSimpleSoap.Free;
  end;
end;


procedure TdlgSubjektyOsobyRejstrik.btAdminClick(Sender: TObject);
begin
//  FAdmin
//  UsersShow;
end;

procedure TdlgSubjektyOsobyRejstrik.qrMainAfterOpen(DataSet: TDataSet);
begin
  cbStatChange(nil);
end;

procedure TdlgSubjektyOsobyRejstrik.cbStatChange(Sender: TObject);
begin
  inherited;
  btObec.Enabled:=Pos('Èeská republika',cbStat.text)>0;
  btOkres.enabled:=btObec.Enabled;

//  cbObec.enabled:=btObec.Enabled;
//  cbOkres.enabled:=btObec.Enabled;
  if not btObec.enabled then
  begin
    cbObec.itemIndex:=0;
    cbObec.style:=csDropDown;
//    cbObec.Text:=''
  end
  else
    cbObec.style:=csDropDownList;
  if not btOkres.enabled then
  begin
    cbOkres.itemIndex:=0;
    cbOkres.style:=csDropDown;
//    cbOkres.Text:=''
  end
  else
    cbOkres.style:=csDropDownList;
end;

// ..........................................................................
procedure TdlgSubjektyOsobyRejstrik.sbProblemClick(Sender: TObject);
var
  t:String;
  nm:Integer;
begin
  if InputQuery('Popište problém','Text',t) then
  begin
    t:=t+EOL+'ROS:'+IntToStr(FRos)+EOL+'PK:'+qrMainCISLO.asString+EOL+'Pol:'+IntToStr(FPol);
    nm:=new_message( 'NT_INFO', 'EMAIL','R.T. - problem',t, 1, 0,'kralicek@notia.cz','','','');
    if nm>0 then
      inform('Odesláno');
  end;
end;

end.
