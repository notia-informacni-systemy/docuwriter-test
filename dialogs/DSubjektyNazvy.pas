unit DSubjektyNazvy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB, Ora, udmODAC, EditEx, AForm, NotiaMagic,UCLTypes,
  Mask, rxToolEdit, MemDS, DBAccess;

type
  TdlgSubjektyNazvy = class(TacForm)
    Panel2: TPanel;
    Panel3: TPanel;
    btCancel: TButton;
    btOK: TButton;
    Panel1: TPanel;
    lbCislo: TLabel;
    Label7: TLabel;
    edRef: TEdit;
    qrRefSubjekt: TOraQuery;
    qrRefSubjektID: TIntegerField;
    qrRefSubjektPLATNY: TSmallintField;
    qrRefSubjektTZO_ID: TIntegerField;
    qrRefSubjektZAMESTNANEC: TSmallintField;
    qrRefSubjektTITUL_PRED: TWideStringField;
    qrRefSubjektJMENO: TWideStringField;
    qrRefSubjektPRIJMENI: TWideStringField;
    qrRefSubjektTITUL_ZA: TWideStringField;
    qrRefSubjektRC: TWideStringField;
    qrRefSubjektDAT_NAROZENI: TDateTimeField;
    qrRefSubjektMISTO_NAROZENI: TWideStringField;
    qrRefSubjektST_KOD: TWideStringField;
    qrRefSubjektPOHLAVI: TSmallintField;
    qrRefSubjektNAZEV: TWideStringField;
    qrRefSubjektREJCIS: TIntegerField;
    qrRefSubjektULICE: TWideStringField;
    qrRefSubjektMESTO: TWideStringField;
    qrRefSubjektPSC: TWideStringField;
    qrRefSubjektEMAIL: TWideStringField;
    qrRefSubjektTEL: TWideStringField;
    qrRefSubjektMOBIL: TWideStringField;
    qrRefSubjektFAX: TWideStringField;
    qrRefSubjektDIC: TWideStringField;
    qrRefSubjektBANKA: TWideStringField;
    qrRefSubjektBUCET: TWideStringField;
    qrRefSubjektNASTUP: TDateTimeField;
    qrRefSubjektPROPUSTENI: TDateTimeField;
    qrRefSubjektPROP_DUVOD: TWideStringField;
    qrRefSubjektPOZNAMKA: TWideStringField;
    qrRefSubjektPILOT: TSmallintField;
    qrRefSubjektTECHNIK: TSmallintField;
    qrRefSubjektSTEVARD: TSmallintField;
    qrRefSubjektZAK: TSmallintField;
    qrRefSubjektARCHIVOVAL: TWideStringField;
    qrRefSubjektARCHIVOVAN: TDateTimeField;
    qrRefSubjektZAPSAL: TWideStringField;
    qrRefSubjektZAPSANO: TDateTimeField;
    qrRefSubjektODD_ID: TIntegerField;
    qrRefSubjektDOC_ID: TIntegerField;
    qrRefSubjektAUTOGEN: TSmallintField;
    qrRefSubjektUDALOST: TWideStringField;
    qrRefSubjektUSER_ID: TIntegerField;
    qrRefSubjektUSERNAME: TWideStringField;
    qrRefSubjektSUB_ID_BOSS: TIntegerField;
    qrRefSubjektSKUPINA: TSmallintField;
    qrRefSubjektDATUM_ZAPISU_LR: TDateTimeField;
    qrRefSubjektICO: TWideStringField;
    qrRefSubjektREJCIS_P: TSmallintField;
    qrRefSubjektREJCIS_T: TSmallintField;
    qrRefSubjektPROVOZOVATEL: TSmallintField;
    qrRefSubjektVYROBCE: TSmallintField;
    qrRefSubjektVLASTNIK: TSmallintField;
    qrRefSubjektCISLO_PRUKAZU: TWideStringField;
    qrRefSubjektUZNANY: TSmallintField;
    qrRefSubjektSUB_ID_PREDCHUDCE: TIntegerField;
    qrRefSubjektNABIZET_PRO_PPP: TSmallintField;
    qrRefSubjektUA_STAV: TSmallintField;
    qrRefSubjektLETECKA_SKOLA: TSmallintField;
    qrRefSubjektUDRZBA_JAR: TSmallintField;
    qrRefSubjektUDRZBA_NARODNI: TSmallintField;
    qrRefSubjektNAZEV_K_ZOBRAZENI: TWideStringField;
    qrRefSubjektZASTAVNI_VERITEL: TSmallintField;
    qrRefSubjektULICE_POD: TWideStringField;
    qrRefSubjektMESTO_POD: TWideStringField;
    qrRefSubjektPSC_POD: TWideStringField;
    qrRefSubjektSTAT_POD: TWideStringField;
    qrRefSubjektZKRATKA: TWideStringField;
    qrRefSubjektICO_OR: TWideStringField;
    qrRefSubjektSIDLO_OR: TWideStringField;
    qrRefSubjektRODNE_PRIJM: TWideStringField;
    qrNazvy: TOraQuery;
    qrNazvySUBJEKT: TIntegerField;
    qrNazvyCISLO: TIntegerField;
    qrNazvyNAZEV: TWideStringField;
    qrNazvyPLATNOST_OD: TDateTimeField;
    qrNazvyPLATNOST_DO: TDateTimeField;
    qrNazvyPOZNAMKA: TWideStringField;
    qrNazvyREF_ID: TIntegerField;
    Label4: TLabel;
    edNazev: TEdit;
    Label11: TLabel;
    mePoznamka: TMemo;
    lbDatum: TLabel;
    edDatumOd: TDateEdit;
    Label1: TLabel;
    edDatumDo: TDateEdit;
    procedure FormShow(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edRefExit(Sender: TObject);
    procedure edRefDblClick(Sender: TObject);
    procedure qrRefSubjektBeforeOpen(DataSet: TDataSet);
    procedure qrNazvyBeforeOpen(DataSet: TDataSet);
    procedure edNazevExit(Sender: TObject);
  private
    Function UlozitNAzev:Boolean;
    procedure ClearForNew;
  public
    OldRefID:Integer;
    fSubjekt:Integer;
    FLocateID:Integer;
  end;

var
  dlgSubjektyNazvy: TdlgSubjektyNazvy;

function dlgSubjektyNazvyExecute(_Subjekt:Integer; _ID:Integer=0):Boolean;


implementation

{$R *.DFM}
uses
  Tools, Utils, NConsts,uDMUCL, uStoredProcs, DSubjekty;

function dlgSubjektyNazvyExecute(_Subjekt:Integer; _ID:Integer=0):Boolean;
begin
 result:=False;
 try
    Screen.Cursor := crHourGlass;
    PrepareModal(TdlgSubjektyNazvy, dlgSubjektyNazvy);
    With dlgSubjektyNazvy do
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
procedure TdlgSubjektyNazvy.btOKClick(Sender: TObject);
begin
 ModalResult:=mrNone;
 if Not UlozitNazev then
   EXIT;
 ModalResult:=mrOk;
end;

// ..........................................................................
procedure TdlgSubjektyNazvy.FormCreate(Sender: TObject);
begin
  OldRefID:=0;
  fSubjekt:=0;
  FLocateID:=0;
end;

// ..........................................................................
procedure TdlgSubjektyNazvy.FormShow(Sender: TObject);
begin
  qrNazvy.Close;
  qrNazvy.Open;
  if not HasData(qrNazvy) then  //Insert
    begin
      Caption:=SetCaption('Nový název');
      ClearForNew;
    end
  else     //update
    begin
      Caption:=SetCaption('Upravit název');
      FSubjekt:=qrNazvySUBJEKT.AsInteger;
      lbCislo.Caption:='# '+qrNazvyCISLO.AsString;

      edNazev.text:=qrNazvyNAZEV.AsString;
      edDatumOd.Date:=qrNazvyPLATNOST_OD.AsDateTime;
      edDatumDo.Date:=qrNazvyPLATNOST_DO.AsDateTime;
      mePoznamka.text:=qrNazvyPOZNAMKA.AsString;
      edRef.Text:=qrNazvyREF_ID.AsString;
      OldRefID:=qrNazvyREF_ID.AsInteger;
    end;
  edNazevExit(nil);
end;

// ..........................................................................
procedure TdlgSubjektyNazvy.edRefExit(Sender: TObject);
var
 NewRefID:Integer;
begin
  try
    NewRefID:=StrToInt(edRef.text);
  except
    NewRefID:=0;
  end;
  if (OldRefID<>NewRefID) and (NewRefID>0) and
     Confirm('Dotáhnout údaje od zadaného subjektu?') then
  try
    qrRefSubjekt.Open;
    if Hasdata(qrRefSubjekt) then
      begin
        edNazev.text:=qrRefSubjektNAZEV.AsString;
        edDatumOD.Date:=qrRefSubjektDATUM_ZAPISU_LR.AsDateTime;
        edDatumDO.Date:=qrRefSubjektARCHIVOVAN.AsDateTime;
        edNazevExit(nil);
      end
    else
      ErrorMsg('Data nenalezena');
  finally
    qrRefSubjekt.Close;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyNazvy.edRefDblClick(Sender: TObject);
var
  FormIOParams: TdlgSubjektyParams;
begin
  FormIOParams := TdlgSubjektyParams.Create(DSUBJEKTY_PFO_ID, [ofoaFilter]);
  try
     FormIOParams.fpFilterCondition := 'PRIJMENI IS NOT NULL';
     if dlgSubjektyExec(FormIOParams) then
       begin
         edRef.text:='';
         if FormIOParams.fpID>0 then
           edRef.text:=IntToStr(FormIOParams.fpID);
       end;
  finally
    FormIOParams.Free;
    edRefExit(nil);
  end;
end;

// ..........................................................................
procedure TdlgSubjektyNazvy.qrRefSubjektBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  qrRefSubjekt.ParamByName('ID').asString:=edRef.text;
end;

// ..........................................................................
procedure TdlgSubjektyNazvy.qrNazvyBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  qrNazvy.ParamByName('CISLO').asInteger:=FLocateID;
end;

// ..........................................................................
procedure TdlgSubjektyNazvy.ClearForNew;
var
  i : integer;
begin
  lbCislo.Caption:=' ';
  for i:=0 to Componentcount-1 do
  begin
    if Components[i] is TEdit then TEdit(Components[i]).Text:='';
    if Components[i] is TCheckBox then TCheckBox(Components[i]).Checked:=False;
  end;
end;

// ..........................................................................
procedure TdlgSubjektyNazvy.edNazevExit(Sender: TObject);
begin
  inherited;
  btOk.Enabled:=(Trim(edNazev.text)<>'');
end;

// ..........................................................................
function TdlgSubjektyNazvy.UlozitNAzev: Boolean;
var
  cis:Integer;
begin
  result:=False;
  try
    qrNazvy.Session.StartTransaction;
    if FLocateID=0 then
      Begin
        qrNazvy.Insert;
        qrNazvyCISLO.AsInteger:=SelectInt('SELECT SEQ_SUBJEKTY_NAZVY_CISLO.NEXTVAL FROM dual');
      end
    else
      begin
        refreshQuery(qrNazvy);
        qrNazvy.Edit;
      end;
    cis:=qrNazvyCISLO.AsInteger;
    qrNazvySubjekt.AsInteger:=FSubjekt;

    FSubjekt:=qrNazvySUBJEKT.AsInteger;
    lbCislo.Caption:='# '+qrNazvyCISLO.AsString;

    qrNazvyNAZEV.AsString:=edNazev.text;
    qrNazvyPLATNOST_OD.AsDateTime:=edDatumOd.Date;
    qrNazvyPLATNOST_DO.AsDateTime:=edDatumDo.Date;
    qrNazvyPOZNAMKA.AsString:=mePoznamka.text;
    qrNazvyREF_ID.AsString:=edRef.Text;
    qrNazvy.post;
    ExecSqlText('UPDATE SUBJEKTY_NAZVY SET '+  // zjebana zmrdka v oracle meni #13#10 na #10#10
                '  POZNAMKA=Replace(POZNAMKA,CHR(10)||CHR(10),CHR(13)||CHR(10)) '+
                ' WHERE CISLO='+IntToStr(cis));
    qrNazvy.Session.Commit;
    result:=True;
    Aktualizuj_Subjekty_Nazvy(FSubjekt);
  except
    qrNazvy.Session.Rollback;
    raise;
  end;
end;

end.

