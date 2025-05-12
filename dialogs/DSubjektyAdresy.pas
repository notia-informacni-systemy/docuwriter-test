unit DSubjektyAdresy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB, Ora, udmODAC,uMultilanguage, AForm, NotiaMagic,
  Mask, NDBCtrls, EditEx, ComCtrls, ToolWin, DBCtrls, MemDS, DBAccess;

type
  TdlgSubjektyAdresy = class(TacForm)
    Panel2: TPanel;
    Panel3: TPanel;
    btCancel: TButton;
    btOK: TButton;
    qrStat: TOraQuery;
    qrStatNAZEV: TWideStringField;
    qrAdresy: TOraQuery;
    qrAdresyCISLO: TIntegerField;
    qrAdresyNAZEV_ADRESY: TWideStringField;
    qrAdresyULICE: TWideStringField;
    qrAdresyMESTO: TWideStringField;
    qrAdresyPSC: TWideStringField;
    qrAdresySTAT: TWideStringField;
    qrAdresySIDLO: TSmallintField;
    qrAdresyPOBOCKA: TSmallintField;
    qrAdresyDOPRAVA: TSmallintField;
    qrAdresyFAKTURACE: TSmallintField;
    qrAdresyVYCHOZI: TSmallintField;
    qrAdresyNAZEV_ADRESY_2: TWideStringField;
    qrAdresyPOTVRZENI_OBJP: TSmallintField;
    qrAdresyTISK_NAZEV2: TSmallintField;
    qrAdresyPOPIS: TWideStringField;
    pnAdresa: TPanel;
    Label1: TLabel;
    edNazev: TEdit;
    Label5: TLabel;
    edNazev2: TEdit;
    Label2: TLabel;
    edUlice: TEdit;
    Label3: TLabel;
    edMesto: TEdit;
    Label4: TLabel;
    edPSC: TEdit;
    btStat: TButton;
    cbStat: TComboBox;
    edPartner: TEdit;
    cbVychozi: TCheckBox;
    mePopis: TMemo;
    lbPopis: TLabel;
    cbPobocka: TCheckBox;
    cbSidlo: TCheckBox;
    lbCislo: TLabel;
    qrAdresyEAN: TWideStringField;
    qrAdresyOBJEKT: TWideStringField;
    Label7: TLabel;
    edObjekt: TEdit;
    qrAdresyPRODEJCE: TWideStringField;
    qrAdresySUBJEKT: TIntegerField;
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btStatClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qrAdresyBeforeOpen(DataSet: TDataSet);
    procedure edMestoExit(Sender: TObject);
  private
    Procedure InitComboStaty;
    Procedure EdPartnerLoad;
    Function UlozitAdresu:Boolean;
    procedure ClearForNew;
    Function STAT_Nazev(_KOD:String):String;
    Function STAT_Kod(_Nazev:String):String;
  public
    FSubjekt:Integer;
    FLocateID:Integer;
    NextAdresa : Boolean;
  end;

var
  dlgSubjektyAdresy: TdlgSubjektyAdresy;

function dlgSubjektyAdresyExecute(_Subjekt:Integer; _ID:Integer=0):Boolean;

implementation

{$R *.DFM}

uses
  Tools, Utils, Caches,NConsts, uDButils, uDMUCL, uStoredProcs, FStaty;

// ..........................................................................

function dlgSubjektyAdresyExecute(_Subjekt:Integer; _ID:Integer=0):Boolean;
begin
 result:=False;
 try
    Screen.Cursor := crHourGlass;
    PrepareModal(TdlgSubjektyAdresy, dlgSubjektyAdresy);
    With dlgSubjektyAdresy do
    begin
      FLocateID:=_ID;
      FSubjekt:=_Subjekt;
      result:=Showmodal=mrOk;
    end;
  finally
    Screen.Cursor := crDefault
  end;
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.FormCreate(Sender: TObject);
begin
  inherited;
  FSubjekt:=0;
  FLocateID:=0;
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.ClearForNew;
var
  i : integer;
begin
  lbCislo.Caption:=' ';
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TEdit then TEdit(Components[i]).text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.FormShow(Sender: TObject);
begin
  InitComboStaty;
  NextAdresa:=False;

  qrAdresy.Close;
  qrAdresy.Open;

  if not HasData(qrAdresy) then  //Insert
    begin
      Caption:=SetCaption('Nová adresa');
      cbStat.ItemIndex:=cbStat.items.IndexOf('Èeská republika');
      ClearForNew;
    end
  else     //update
    begin
      Caption:=SetCaption('Upravit adresu');
      FSubjekt:=qrAdresySubjekt.AsInteger;
      lbCislo.Caption:='# '+qrAdresyCISLO.AsString;
      edNazev.text:=qrAdresyNAZEV_ADRESY.AsString;
      edNazev2.text:=qrAdresyNAZEV_ADRESY_2.AsString;
      edUlice.text:=qrAdresyULICE.AsString;
      edMesto.text:=qrAdresyMESTO.AsString;
      edPSC.text:=qrAdresyPSC.AsString;
      edObjekt.text:=qrAdresyOBJEKT.AsString;
      cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev(qrAdresySTAT.AsString));
      mePopis.Text:=qrAdresyPOPIS.AsString;
      cbSidlo.Checked:=(qrAdresySIDLO.AsInteger = 1);
      cbPobocka.Checked:=(qrAdresyPOBOCKA.AsInteger = 1);
      cbVychozi.Checked:=(qrAdresyVYCHOZI.AsInteger = 1);
    end;

  edMestoExit(nil);
  EdPartnerLoad;

  if (MultiLanguage<>nil) then //Multilanguage
    begin
      MultiLanguage.ActivateLanguage(MultiLanguage.LanguageIndex,Self.Name,False);
      MultiLanguage.TranslateComponent(self,self);
    end;
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.edMestoExit(Sender: TObject);
begin
  inherited;
  btOk.Enabled:=(Trim(edMesto.text)<>'') and (Trim(cbStat.text)<>'');
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.qrAdresyBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  if FLocateID>0 then
    qrAdresy.ParamByName('CISLO').asInteger:=FLocateID
  else
    qrAdresy.ParamByName('CISLO').Clear;

end;

// ..........................................................................
procedure TdlgSubjektyAdresy.EdPartnerLoad;
begin
  edPartner.Text:='';
  if FSubjekt>0 then
    edPartner.Text:=Subjekty_Nazev(FSubjekt)
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.InitComboStaty;
begin
 InitCombo(cbStat,qrStat);
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.btStatClick(Sender: TObject);
var
  FormIOParams: TfrmStatyParams;
begin
  FormIOParams := TfrmStatyParams.Create(FSTATY_PFO_KOD, [], InitComboStaty);
  try
    FormIOParams.fpSearch := cbStat.TEXT<>'';
    FormIOParams.fpSearchFor := Stat_kod(cbStat.TEXT);
    if frmStatyExec(FormIOParams, true) then
    begin
      cbStat.ItemIndex:=cbStat.Items.IndexOf(Stat_Nazev(FormIOParams.fpKOD));
      edMestoExit(nil);
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.btNextClick(Sender: TObject);
begin
  NextAdresa:=True;
  if Not UlozitAdresu then
    EXIT;
  ClearForNew;
  EdPartnerLoad;
end;

// ..........................................................................
function TdlgSubjektyAdresy.UlozitAdresu: Boolean;
var
  cis:Integer;
begin
  result:=False;
(*
  if (not cbSidlo.Checked) and (not cbFakturace.Checked) and
     (not cbDoprava.Checked) and (not cbPobocka.Checked) then

  if not Confirm('Není zadáno, pro co je adresa urèena'+EOL+
                 '(sídlo, pobocka,fakurace,doprava).'+EOL+
                 'Pokraèovat?') then
   exit;
*)
  try
    qrAdresy.Session.StartTransaction;
    if FLocateID=0 then
      Begin
        qrAdresy.Insert;
        qrAdresyCISLO.AsInteger:=SelectInt('SELECT SEQ_SUBJEKTY_ADRESY_CISLO.NEXTVAL FROM dual');
      end
    else
      begin
        refreshQuery(qrAdresy);
        qrAdresy.Edit;
      end;
    cis:=qrAdresyCISLO.AsInteger;
    qrAdresySUBJEKT.AsInteger:=FSubjekt;
    qrAdresyNAZEV_ADRESY.AsString:=edNazev.text;
    qrAdresyNAZEV_ADRESY_2.AsString:=edNazev2.text;
    qrAdresyULICE.AsString:=edUlice.text;
    qrAdresyMESTO.AsString:=edMesto.text;
    qrAdresyPSC.AsString:=edPSC.text;
    qrAdresySTAT.AsString:=Stat_Kod(cbStat.Text);
    qrAdresyOBJEKT.AsString:=edOBJEKT.text;
    qrAdresyPOPIS.AsString:=StringReplace(mePopis.Text,Chr(39),'"',[rfReplaceAll]); // nelze pouzivat apostrofy v textu
    qrAdresySIDLO.AsInteger:=Byte(cbSidlo.Checked);
    qrAdresyPOBOCKA.AsInteger:=Byte(cbPobocka.Checked);
    qrAdresyVYCHOZI.AsInteger:=Byte(cbVychozi.Checked);
    qrAdresy.post;
    ExecSqlText('UPDATE SUBJEKTY_ADRESY SET '+  // zjebana zmrdka v oracle meni #13#10 na #10#10
                '  POPIS=Replace(POPIS,CHR(10)||CHR(10),CHR(13)||CHR(10)) '+
                ' WHERE CISLO='+IntToStr(cis));
    if cbVychozi.checked then
      begin
        ExecSQLText('UPDATE SUBJEKTY_ADRESY SET '+
                    ' vychozi=0 '+
                    ' WHERE SUBJEKT='+IntToStr(FSubjekt)+
                    '   AND cislo<>'+IntToStr(cis)+
                    '   AND vychozi=1');
(*
        ExecSQLText('UPDATE SUBJEKTY SET '+
                    ' Ulice='+Q(edUlice.text)+','+
                    ' Mesto='+Q(edMesto.text)+','+
                    ' Psc= '+Q(edPSC.text)+
                    ' WHERE ID='+IntToStr(FSubjekt));
        ExecSQLText('UPDATE SUBJEKTY SET '+
                    ' ST_KOD= '+Q(Stat_Kod(cbStat.Text))+
                    ' WHERE ST_KOD is NULL and ID='+IntToStr(FSubjekt));
*)                    
      end;
    if cbSidlo.checked then
      ExecSQLText('UPDATE SUBJEKTY_ADRESY SET '+
                  ' sidlo=0 '+
                  ' WHERE SUBJEKT='+IntToStr(FSubjekt)+
                  '   AND cislo<>'+IntToStr(cis)+
                  '   AND sidlo=1');
    qrAdresy.Session.Commit;
    result:=True;
    Aktualizuj_Subjekty_Adresy(FSubjekt);
  except
    qrAdresy.Session.Rollback;
    raise;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyAdresy.btOKClick(Sender: TObject);
begin
 ModalResult:=mrNone;
 if Not UlozitAdresu then
   EXIT;
 ModalResult:=mrOk;
end;

// ..........................................................................
function TdlgSubjektyAdresy.STAT_Kod(_Nazev: String): String;
begin
  result:=SelectStr('SELECT KOD FROM STATY WHERE ROWNUM<2 AND NAZEV='+Q(_Nazev));
end;

// ..........................................................................
function TdlgSubjektyAdresy.STAT_Nazev(_KOD: String): String;
begin
  result:=SelectStr('SELECT NAZEV FROM STATY WHERE ROWNUM<2 AND KOD='+Q(_KOD));
end;

end.

