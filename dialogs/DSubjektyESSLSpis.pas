unit DSubjektyESSLSpis;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, UCLTypes, Data.DB, MemDS, DBAccess, Ora;

const
  DSUB_ESSL_SPIS_ID = $10000;

// TdlgSubjektyESSLSpisParams
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektyESSLSpisParams = class(TFuncParams)
  public
    fpID: integer;
    fpSUB_ID: integer;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSubjektyESSLSpis
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektyESSLSpis = class(TacDialogOkStorno)
    lbPrijmeni: TLabel;
    lbJmeno: TLabel;
    edSpis: TEdit;
    edCislo: TEdit;
    pnSubjekt: TPanel;
    edID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edNazev: TEdit;
    qrData: TOraQuery;
    qrDataID: TIntegerField;
    qrDataSUB_ID: TIntegerField;
    qrDataCISLO: TIntegerField;
    qrDataSPIS: TWideStringField;
    qrDataNAZEV: TWideStringField;
    qrDataZAPSAL: TWideStringField;
    qrDataZAPSANO: TDateTimeField;
    qrDataZMENIL: TWideStringField;
    qrDataZMENENO: TDateTimeField;
    qrMaster: TOraQuery;
    qrMasterID: TIntegerField;
    qrMasterSUB_ID: TIntegerField;
    qrMasterCISLO: TIntegerField;
    qrMasterSPIS: TWideStringField;
    qrMasterNAZEV: TWideStringField;
    qrMasterZAPSAL: TWideStringField;
    qrMasterZAPSANO: TDateTimeField;
    qrMasterZMENIL: TWideStringField;
    qrMasterZMENENO: TDateTimeField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure OnOK(var Accept: boolean); override;
  public
    FID: integer;
    FSubID: integer;
    Function ulozdata:Boolean;
  end;

var
  dlgSubjektyESSLSpis: TdlgSubjektyESSLSpis;

function dlgSubjektyESSLSpisExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}

uses
  Tools, Caches,  NParam, uStoredProcs, Utils, uUCLConsts, uObjUtils,
  uDBUtils, NConsts, FSubjekty;

function dlgSubjektyESSLSpisExec(_Params: TFuncParams): boolean;
begin
  result:=false;
  try
    Screen.Cursor := crHourGlass;
    if assigned(dlgSubjektyESSLSpis) then
    begin
      dlgSubjektyESSLSpis.free;
      dlgSubjektyESSLSpis:=nil;
    end;
    PrepareForm(TdlgSubjektyESSLSpis, dlgSubjektyESSLSpis, true);
    with dlgSubjektyESSLSpis do
    begin
      borderStyle:=bsSizeable;
      Params := _Params;
      if Assigned(Params) then
      begin
        FID:=TdlgSubjektyESSLSpisParams(Params).fpID;
        FSubID:=TdlgSubjektyESSLSpisParams(Params).fpSub_ID;
      end;
      Result := (ShowModal = mrOK);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;



{ TdlgSubjektyESSLSpisParams }
{ ========================================================================= }
constructor TdlgSubjektyESSLSpisParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpID:=-1;
  fpSUB_ID:=-1;
end;


{ TdlgSubjektyESSLSpis }
{ ========================================================================= }
procedure TdlgSubjektyESSLSpis.FormCreate(Sender: TObject);
begin
  inherited;
  FID:=-1;
  FSubID:=-1;
end;

// ..........................................................................
procedure TdlgSubjektyESSLSpis.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgSubjektyESSLSpis.FormShow(Sender: TObject);
begin
  inherited;
  edID.Text:='';
  edCislo.Text:='';
  edSpis.Text:='';
  edNazev.Text:='';
  if FID>0 then
  begin
    qrData.close;
    qrData.paramByName('ID').asInteger:=FID;
    qrData.Open;
    edID.Text:=qrDataID.asString;
    edCislo.Text:=qrDataCISLO.asString;
    edSpis.Text:=qrDataSPIS.asString;
    edNazev.Text:=qrDataNAZEV.asString;
    SetControlsReadOnly([edCislo,edSpis], true);
  end;
  if FSubID>0 then
    pnSubjekt.caption:=SelectStr('SELECT NAZEV_K_ZOBRAZENI FROM SUBJEKTY WHERE ID='+IntToStr(FSubID));

end;

// ..........................................................................
procedure TdlgSubjektyESSLSpis.OnOK(var Accept: boolean);
begin
  Accept:= ulozdata;
  inherited;
end;

// ..........................................................................
function TdlgSubjektyESSLSpis.ulozdata: Boolean;
begin
  result:=False;
  if (trim(edCislo.text)='') or (trim(edSpis.text)='') then
  begin
    ErrorMsg('Vyplòte èíslo/poøadí spisu a spis');
    Exit;
  end;

  qrData.close;
  qrData.paramByName('ID').asInteger:=FID;
  qrData.Open;
  if qrDataID.asInteger>0 then
  begin
    qrData.edit;
    qrDataNAZEV.asString:=edNazev.Text;
    qrData.post;
  end
  else
  begin
    If SelectInt('select Count(*) from SUBJEKTY_ESSL_SPIS WHERE SUB_ID='+IntToStr(FSubID)+' and CISLO='+edCislo.Text)>0 then
    begin
       Errormsg('Zadané èíslo/poøadí spisu již existuje');
       Exit;
    end;

    qrData.insert;
    qrDataSUB_ID.asInteger:=FSubID;
    qrDataCISLO.asString:=edCislo.Text;
    qrDataSPIS.asString:=edSpis.Text;
    qrDataNAZEV.asString:=edNazev.Text;
    qrData.post;
  end;
  result:=true;
end;

end.
