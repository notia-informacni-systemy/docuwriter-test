
unit DSubjektyESSLSpisCJ;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, UCLTypes, Data.DB, MemDS, DBAccess, Ora, Vcl.Mask,
  rxToolEdit, Vcl.Buttons;

const
  DSUB_ESSL_SPIS_CJ_ID = $10000;

// TdlgSubjektyESSLSpisCJParams
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektyESSLSpisCJParams = class(TFuncParams)
  public
    fpID: integer;
    fpSPIS_ID: integer;
    fpSUB_ID: integer;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgSubjektyESSLSpisCJ
{ ------------------------------------------------------------------------- }
type
  TdlgSubjektyESSLSpisCJ = class(TacDialogOkStorno)
    qrData: TOraQuery;
    qrDataID: TIntegerField;
    qrDataSPIS_ID: TIntegerField;
    qrDataSPIS_DATUM: TDateTimeField;
    qrDataCISLO: TIntegerField;
    qrDataCJ: TWideStringField;
    qrDataNAZEV: TWideStringField;
    qrDataTYP: TIntegerField;
    qrDataPOZNAMKA: TWideStringField;
    qrDataZAPSAL: TWideStringField;
    qrDataZAPSANO: TDateTimeField;
    qrDataZMENIL: TWideStringField;
    qrDataZMENENO: TDateTimeField;
    pnSubjekt: TPanel;
    lbJmeno: TLabel;
    edCislo: TEdit;
    edID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edNazev: TEdit;
    pnSpis: TPanel;
    edCJ: TEdit;
    Label3: TLabel;
    lbDatumNarozeni: TLabel;
    edDatVlozeni: TDateEdit;
    Label11: TLabel;
    mePoznamka: TMemo;
    Label4: TLabel;
    cbTyp: TComboBox;
    sbAttAdd: TSpeedButton;
    qrDataATT: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure sbAttAddClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure OnOK(var Accept: boolean); override;
  public
    FID: integer;
    FSpisID: integer;
    FSubID: integer;
    AttName: String;
    Function ulozdata:Boolean;
    Function NactiDataZEssl(aCJ:string):Boolean;
  end;

var
  dlgSubjektyESSLSpisCJ: TdlgSubjektyESSLSpisCJ;

function dlgSubjektyESSLSpisCJExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}

uses
  Tools, Caches,  NParam, uStoredProcs, Utils, uUCLConsts, uObjUtils,
  uDBUtils, NConsts, FSubjekty, DSubjektyESSLSpis, FSeznamPriloh;

function dlgSubjektyESSLSpisCJExec(_Params: TFuncParams): boolean;
begin
  result:=false;
  try
    Screen.Cursor := crHourGlass;
    if assigned(dlgSubjektyESSLSpisCJ) then
    begin
      dlgSubjektyESSLSpisCJ.free;
      dlgSubjektyESSLSpisCJ:=nil;
    end;
    PrepareForm(TdlgSubjektyESSLSpisCJ, dlgSubjektyESSLSpisCJ, true);
    with dlgSubjektyESSLSpisCJ do
    begin
      borderStyle:=bsSizeable;
      Params := _Params;
      if Assigned(Params) then
      begin
        FID:=TdlgSubjektyESSLSpisCJParams(Params).fpID;
        FSpisID:=TdlgSubjektyESSLSpisCJParams(Params).fpSpis_ID;
        FSubID:=TdlgSubjektyESSLSpisCJParams(Params).fpSub_ID;
      end;
      Screen.Cursor := crDefault;
      Result := (ShowModal = mrOK);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;


{ TdlgSubjektyESSLSpisCJParams }
{ ========================================================================= }
constructor TdlgSubjektyESSLSpisCJParams.Create(
  const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent; _BeforeOKEvent: TBeforeOKEvent);
begin
  fpID:=-1;
  fpSPIS_ID:=-1;
  fpSUB_ID:=-1;
end;

{ TdlgSubjektyESSLSpisCJ }
{ ========================================================================= }
procedure TdlgSubjektyESSLSpisCJ.FormCreate(Sender: TObject);
begin
  inherited;
  FID:=-1;
  FSpisID:=-1;
  FSubID:=-1;
end;

// ..........................................................................
procedure TdlgSubjektyESSLSpisCJ.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgSubjektyESSLSpisCJ.FormShow(Sender: TObject);
begin
  inherited;
  edID.Text:='';
  edCislo.Text:=selectStr('SELECT NVL(max(CISLO),0)+1 FROM SUBJEKTY_ESSL_SPIS_CJ WHERE SPIS_ID='+Q(IntToStr(FSpisID)));
  edCJ.Text:='';
  edNazev.Text:='';
  mePoznamka.Text:='';
  cbTyp.itemIndex:=0;
  AttName:='';
  sbAttAdd.tag:=0;
  sbAttAdd.hint:='Vložit pøílohu';
  sbAttAdd.font.color:=clWindowText;
  sbAttAdd.font.style:=[];
  edDatVlozeni.clear;
  if FID>0 then
  begin
    qrData.close;
    qrData.paramByName('ID').asInteger:=FID;
    qrData.Open;
    edID.Text:=qrDataID.asString;
    edCislo.Text:=qrDataCISLO.asString;
    edCJ.Text:=qrDataCJ.asString;
    edNazev.Text:=qrDataNAZEV.asString;
    edDatVlozeni.date:=qrDataSPIS_DATUM.asDateTime;
    mePoznamka.Text:=qrDataPOZNAMKA.asString;
    cbTyp.itemIndex:=qrDataTYP.asInteger;
    sbAttAdd.tag:=qrDataATT.asInteger;
    if qrDataATT.asInteger>0 then
    begin
      sbAttAdd.hint:='Zobrazit pøílohu';
      sbAttAdd.font.color:=clRed;
      sbAttAdd.font.style:=[fsbold];
    end;
    SetControlsReadOnly([edCislo,edCJ,edDatVlozeni], true);
  end;

  if FSubID>0 then
    pnSubjekt.caption:=SelectStr('SELECT NAZEV_K_ZOBRAZENI FROM SUBJEKTY WHERE ID='+IntToStr(FSubID));
  if FSpisID>0 then
    pnSpis.caption:='Spis: '+SelectStr('SELECT NVL(NAZEV,SPIS) FROM SUBJEKTY_ESSL_SPIS WHERE ID='+IntToStr(FSpisID));
end;

// ..........................................................................
procedure TdlgSubjektyESSLSpisCJ.OnOK(var Accept: boolean);
begin
  Accept:= ulozdata;
  inherited;
end;

// ..........................................................................
function TdlgSubjektyESSLSpisCJ.NactiDataZEssl(aCJ: string): Boolean;
begin

  result:=False;

end;

// ..........................................................................
function TdlgSubjektyESSLSpisCJ.ulozdata: Boolean;
var
  FR:TframeSeznamPriloh;
  r,i:Integer;
  EsslOK:Boolean;
begin
  result:=False;
  EsslOK:=False;
  FR:=nil;
  if (edDatVlozeni.date<(date-5000)) or (trim(edCislo.text)='') or (trim(edCJ.text)='') then
  begin
    ErrorMsg('Vyplòte èíslo/poøadí dokumentu ve spisu a datum vložení do spisu a jednací èíslo');
    Exit;
  end;

  qrData.close;
  qrData.paramByName('ID').asInteger:=FID;
  qrData.Open;
  if qrDataID.asInteger>0 then
  begin
    qrData.edit;
    qrDataNAZEV.asString:=edNazev.Text;
    qrDataPOZNAMKA.asString:=mePoznamka.Text;
    qrDataTYP.asInteger:=cbTyp.itemIndex;
    qrData.post;
  end
  else
  begin
    If SelectInt('select Count(*) from SUBJEKTY_ESSL_SPIS_CJ WHERE SPIS_ID='+IntToStr(FSpisID)+' and CISLO='+edCislo.Text)>0 then
    begin
       Errormsg('Zadané èíslo/poøadí spisu již existuje');
       Exit;
    end;
// nejdrive kontrola proti ESSL
//    EsslOK:=NactiDataZEssl(edCJ.Text);
// a pak pokud neni tak insert
//    if not EsslOK and Confirm('Data v ESSL pro "'+edCJ.Text+'" nenalezena. '+EOL+'Uložit jen zapsaná data?') then
    begin
      qrData.insert;
      qrDataID.asInteger:=Get_Next_Ciselnik_ID;
      qrDataSPIS_ID.asInteger:=FSpisID;
      qrDataCISLO.asString:=edCislo.Text;
      qrDataCJ.asString:=edCJ.Text;
      qrDataNAZEV.asString:=edNazev.Text;
      qrDataPOZNAMKA.asString:=mePoznamka.Text;
      qrDataSPIS_DATUM.asDateTime:=edDatVlozeni.date;
      qrDataTYP.asInteger:=cbTyp.itemIndex;
      qrData.post;
      if attName<>'' then
      try
        FR:=TframeSeznamPriloh.Create(application);
        FR.SetPK('SUBJEKTY_ESSL_SPIS_CJ', qrDataID.asString);
        r:=FR.VlozitNovouPrilohu(attName,false, false, false,-1,false);
        if r>0 then
        begin
          if FSubID>0 then
            ExecSqlText('INSERT INTO PRILOHY_NOVE (TABULKA, PK, PRILOHA_ID) '+
                        ' VALUES (''SUBJEKTY'','+IntToStr(FSubID)+','+IntToStr(r)+')');
          ExecSqlText('UPDATE SUBJEKTY_ESSL_SPIS_CJ SET '+
                      '  ATT='+IntToStr(r)+
                      ' WHERE ID='+qrDataID.asString);
        end;
      finally
        FR.close;
        FR.free;
      end
    end;
  end;
  result:=true;
end;

// ..........................................................................
procedure TdlgSubjektyESSLSpisCJ.sbAttAddClick(Sender: TObject);
var
  FR:TframeSeznamPriloh;
  OD:TOpenDialog;
begin
  FR:=nil;
  OD:=nil;
  if sbAttAdd.tag=0 then // vyhledat soubor
    try
      OD:=TOpenDialog.Create(self);
      if OD.Execute then
      begin
        AttName:=OD.FileName;
        sbAttAdd.font.color:=clRed;
        sbAttAdd.font.style:=[fsbold];
      end;
    finally
      OD.free;
    end
  else // zobrazit prilohu
    try
      FR:=TframeSeznamPriloh.Create(application);
      FR.SetPK('SUBJEKTY_ESSL_SPIS_CJ', IntToStr(FSpisID));
      FR.OtevritPrilohu(sbAttAdd.tag, not (FR.readonly or FR.openreadonly))
    finally
      FR.close;
      FR.free;
    end;
end;

end.
