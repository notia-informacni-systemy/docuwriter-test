unit DSubjektySpojeni;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Db, Ora, udmODAC, DBCtrls, Mask,
  AForm, NotiaMagic, uMultilanguage, NDBCtrls, EditEx, Buttons,
  ToolWin, ComCtrls, MemDS, DBAccess;

type
  TdlgSubjektySpojeni = class(TacForm)
    Panel2: TPanel;
    pnBottom: TPanel;
    Panel4: TPanel;
    btStorno: TButton;
    btOK: TButton;
    cbKodSpojeni: TComboBox;
    qrSpojeni: TOraQuery;
    qrSpojeniCISLO: TIntegerField;
    qrSpojeniKOD: TWideStringField;
    qrSpojeniCISLO_ADRESY: TIntegerField;
    qrSpojeniCISLO_OSOBY: TIntegerField;
    qrSpojeniHODNOTA: TWideStringField;
    qrSpojeniSORT: TSmallintField;
    qrSpojeniPROVAZAT_S_ADRESOU: TSmallintField;
    edPartner: TEdit;
    edAdresa: TEdit;
    edHodnota: TEdit;
    lbCislo: TLabel;
    ToolBar3: TToolBar;
    tbAdresaAdd: TToolButton;
    tbAdresaDel: TToolButton;
    qrSpojeniSUBJEKT: TIntegerField;
    ToolBar1: TToolBar;
    tbOsobaAdd: TToolButton;
    tbOsobaDel: TToolButton;
    edOsoba: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btDalsiClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure qrSpojeniBeforeOpen(DataSet: TDataSet);
    procedure btAdresaClick(Sender: TObject);
    procedure cbKodSpojeniExit(Sender: TObject);
    procedure tbAdresaDelClick(Sender: TObject);
    procedure tbOsobaAddClick(Sender: TObject);
    procedure tbOsobaDelClick(Sender: TObject);
  private
    Function UlozitSpojeni:Boolean;
    Procedure EdPartnerLoad;
    Procedure EdAdresaLoad;
    Procedure EdOsobaLoad;
    procedure InitComboKodySpojeni;
    procedure ClearForNew;
  public
    FSubjekt:Integer;
    FOsoba:Integer;
    FAdresa:Integer;
    FLocateID:Integer;
    NextSpojeni : Boolean;
  end;

var
  dlgSubjektySpojeni: TdlgSubjektySpojeni;

function dlgSubjektySpojeniExecute(_Subjekt:Integer; _ID:Integer=0):Boolean;

implementation

{$R *.DFM}

uses
  Utils, Tools, Manager, uDbUtils, uDMUCL, uStoredProcs, FAdresy, FOsoby;


function dlgSubjektySpojeniExecute(_Subjekt:Integer; _ID:Integer=0):Boolean;
begin
 result:=False;
 try
    Screen.Cursor := crHourGlass;
    PrepareModal(TdlgSubjektySpojeni, dlgSubjektySpojeni);
    With dlgSubjektySpojeni do
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
procedure TdlgSubjektySpojeni.FormCreate(Sender: TObject);
begin
  inherited;
  FSubjekt:=0;
  fAdresa:=0;
  FOsoba:=0;
  fLocateID:=0;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.ClearForNew;
var
  i:Integer;
begin
  lbCislo.Caption:=' ';
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TEdit then TEdit(Components[i]).Text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.FormShow(Sender: TObject);
begin
  InitComboKodySpojeni;
  NextSpojeni:=False;
  qrSpojeni.Close;
  qrSpojeni.Open;

  if not HasData(qrSpojeni) then  //Insert
    begin
      Caption:=SetCaption('Nové spojení');
      if cbKodSpojeni.Items.count>0 then
        cbKodSpojeni.ItemIndex:=0;
      ClearForNew;
    end
  else     //update
    begin
      Caption:=SetCaption('Upravit spojení');
      FSubjekt:=qrSpojeniSUBJEKT.AsInteger;
      FAdresa:=qrSpojeniCISLO_ADRESY.AsInteger;
      FOsoba:=qrSpojeniCISLO_OSOBY.AsInteger;
      lbCislo.Caption:='# '+qrSpojeniCISLO.AsString;
      cbKodSpojeni.ItemIndex:=cbKodSpojeni.Items.IndexOf(qrSpojeniKOD.AsString);
      edHodnota.text:=qrSpojeniHODNOTA.AsString;
    end;

  cbKodSpojeniExit(nil);

  EdOsobaLoad;
  EdAdresaLoad;
  EdPartnerLoad;


  if (MultiLanguage<>nil) then //Multilanguage
    begin
      MultiLanguage.ActivateLanguage(MultiLanguage.LanguageIndex,Self.Name,False);
      MultiLanguage.TranslateComponent(self,self);
    end;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.InitComboKodySpojeni;
begin
  InitComboSQL(cbKodSpojeni,'SELECT KOD FROM SUBJEKTY_SPOJENI_DRUHY ORDER BY PRIORITA');
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.cbKodSpojeniExit(Sender: TObject);
begin
  inherited;
  btOk.Enabled:=(Trim(cbKodSpojeni.text)<>'') and (Trim(edHodnota.text)<>'');
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.qrSpojeniBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  qrSpojeni.ParamByName('CISLO').asInteger:=FLocateID;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.tbOsobaAddClick(Sender: TObject);
begin
  if frmOsobyExecute(FOsoba, FSubjekt) then
   begin
     EdOsobaLoad;
   end;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.EdOsobaLoad;
begin
  edOsoba.text :='';
  if FOsoba>0 then
    edOsoba.text := SelectStr('SELECT CISLO||''=''||OSOBA_JMENO(Prijmeni,Jmeno,Titul,Titul2) '+
                              ' FROM SUBJEKTY_OSOBY '+
                              ' WHERE CISLO='+IntToStr(FOsoba));
  tbOsobaDel.Enabled:=FOsoba>0;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.EdAdresaLoad;
begin
  edAdresa.text :='';
  if FAdresa>0 then
    edAdresa.text := SelectStr('SELECT CISLO||''=''||NAZEV_ADRESY||'':''||TRIM(MESTO||'', ''||ULICE) '+
                              '  FROM SUBJEKTY_ADRESY '+
                              ' WHERE CISLO='+IntToStr(FAdresa));
  tbAdresaDel.Enabled:=FAdresa>0;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.EdPartnerLoad;
begin
  edPartner.Text:='';
  if FSubjekt>0 then
    edPartner.Text:=Subjekty_Nazev(FSubjekt)
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.btAdresaClick(Sender: TObject);
begin
 if frmAdresyExecute(FAdresa, FSubjekt) then
  begin
    EdAdresaLoad;
  end;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.btDalsiClick(Sender: TObject);
begin
  inherited;
  NextSpojeni:=True;
  if Not UlozitSpojeni then
    EXIT;
  ClearForNew;
  EdAdresaLoad;
  EdPartnerLoad;
end;

// ..........................................................................
function TdlgSubjektySpojeni.UlozitSpojeni: Boolean;
begin
  result:=False;
  try
    qrSpojeni.Session.StartTransaction;
    if FLocateID=0 then
      Begin
        qrSpojeni.Insert;
        qrSpojeniCISLO.AsInteger:=SelectInt('SELECT SEQ_SUBJEKTY_SPOJENI_CISLO.NEXTVAL FROM dual');
      end
    else
      begin
        refreshQuery(qrSpojeni);
        qrSpojeni.Edit;
      end;
    qrSpojeniSUBJEKT.AsInteger:=FSubjekt;
    if FAdresa>0 then qrSpojeniCISLO_ADRESY.AsInteger:=FAdresa
                 else qrSpojeniCISLO_ADRESY.Clear;
    if FOsoba>0 then qrSpojeniCISLO_OSOBY.AsInteger:=FOsoba
                 else qrSpojeniCISLO_OSOBY.Clear;
    qrSpojeniKOD.AsString:=cbKodSpojeni.Text;
    qrSpojeniHODNOTA.AsString:=edHodnota.text;
    qrSpojeni.post;
    qrSpojeni.Session.Commit;
    result:=True;
    Aktualizuj_Subjekty_Spojeni(FSubjekt);
  except
    qrSpojeni.Session.Rollback;
    raise;
  end;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.btOKClick(Sender: TObject);
begin
  ModalResult:=mrNone;
  if Not UlozitSpojeni then
    EXIT;
  ModalResult:=mrOk;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.tbAdresaDelClick(Sender: TObject);
begin
  inherited;
  FAdresa:=0;
  EdAdresaLoad;
end;

// ..........................................................................
procedure TdlgSubjektySpojeni.tbOsobaDelClick(Sender: TObject);
begin
  FOsoba:=0;
  EdOsobaLoad;
end;

end.
