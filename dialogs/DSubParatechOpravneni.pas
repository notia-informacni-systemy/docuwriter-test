unit DSubParatechOpravneni;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, Mask, rxToolEdit, Buttons,
  UCLTypes, Ora;

type
  TdlgSubParatechOpravneniParams = class(TfuncParams)
    fpSubID: Integer;
    fpID: Integer;
    fpTag: Integer;
  end;

type
  TdlgSubParatechOpravneni = class(TacDialogOkStorno)
    Label15: TLabel;
    Label18: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sbOprDel: TSpeedButton;
    sbExamDel: TSpeedButton;
    lbPoznamka: TLabel;
    edJmeno: TEdit;
    edPrijmeni: TEdit;
    btExam: TButton;
    edExamText: TEdit;
    btOpr: TButton;
    edOprText: TEdit;
    edOd: TDateEdit;
    edDo: TDateEdit;
    edPrezk: TDateEdit;
    mePoznamka: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btOprClick(Sender: TObject);
    procedure btExamClick(Sender: TObject);
    procedure sbOprDelClick(Sender: TObject);
    procedure sbExamDelClick(Sender: TObject);
    procedure edPrezkChange(Sender: TObject);
  private
    FID: integer;
    FTag: integer;
    FSubID: integer;
    FExamID: integer;
    FOprID: integer;

    procedure OnOK(var Accept: boolean); override;
  public
    { Public declarations }
  end;

var
  dlgSubParatechOpravneni: TdlgSubParatechOpravneni;

function dlgSubParatechOpravneniExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses Tools, Utils, FSubjektyParaganiExamTyp, FSubjektyParatechSpecOpravneni, FSubjektyParatechDruhyPK;

function dlgSubParatechOpravneniExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubParatechOpravneni, dlgSubParatechOpravneni, true);
  with dlgSubParatechOpravneni do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ************************************************************************************
procedure TdlgSubParatechOpravneni.FormCreate(Sender: TObject);
begin
  inherited;
  borderstyle:=bsDialog;
  FID:=0;
  FTag:=0;
  FSubID:=0;
  FExamID:=0;
  FOprID:=0;
end;

// ************************************************************************************
procedure TdlgSubParatechOpravneni.FormShow(Sender: TObject);
var qrTemp: TOraQuery;
begin
  qrTemp:=nil;
  inherited;

  edJmeno.Text:='';
  edPrijmeni.Text:='';
  edExamText.Text:='';
  edOprText.Text:='';
  edOd.Text:='';
  edDo.Text:='';
  edPrezk.Text:='';

  if Assigned(Params) then
  begin
    with TdlgSubParatechOpravneniParams(Params) do
    begin
      FID:=fpID;
      FTag:=fpTag;
      FSubID:=fpSubID;
    end;
    Case FTag of
      0:begin
          Caption:='Subjekty - Technici PARA - Oprávnìni';
          lbPoznamka.Caption:='Poznámka';
          qrTemp:=CreateQueryOpen('SELECT S.PRIJMENI, S.JMENO, P.* '+
                                  ' FROM SUBJEKTY S, (SELECT * FROM SUBJEKTY_PARATECH_SPEC_OPR WHERE ID='+IntToStr(FID)+') P'+
                                  ' WHERE S.ID=P.SUB_ID(+) AND S.ID='+IntToStr(FSubID));
        end;
      1:begin
          Caption:='Subjekty - Technici PARA - Padákový komplet';
          lbPoznamka.Caption:='Typy a znaèky PK';
          qrTemp:=CreateQueryOpen('SELECT S.PRIJMENI, S.JMENO, P.* '+
                                  ' FROM SUBJEKTY S, (SELECT * FROM SUBJEKTY_PARATECH_OSOBNI_PK WHERE ID='+IntToStr(FID)+') P'+
                                  ' WHERE S.ID=P.SUB_ID(+) AND S.ID='+IntToStr(FSubID));
        end;
    end;
  end;
  try
    if HasData(qrTemp) then
    begin
      edJmeno.Text:=qrTemp.FieldByName('JMENO').AsString;
      edPrijmeni.Text:=qrTemp.FieldByName('PRIJMENI').AsString;
      edOd.Date:=qrTemp.FieldByName('DATUM_OD').AsDateTime;
      edPrezk.Date:=qrTemp.FieldByName('PREZKOUSENI').AsDateTime;
      edDo.Date:=qrTemp.FieldByName('DATUM_DO').AsDateTime;
      mePoznamka.Text:=qrTemp.FieldByName('POZNAMKA').AsString;
      Case FTag of
        0:begin
            FOprID:=qrTemp.FieldByName('ID_SPEC_OPR').AsInteger;
            edOprText.Text:=SelectStr('SELECT NAZEV FROM PARATECH_SPEC_OPR WHERE ID='+IntToStr(FOprID));
          end;
        1:begin
            FOprID:=qrTemp.FieldByName('ID_OSOBNI_PK').AsInteger;
            edOprText.Text:=SelectStr('SELECT NAZEV FROM PARATECH_OSOBNI_PK WHERE ID='+IntToStr(FOprID));
          end;
      end;

      FExamID:=qrTemp.FieldByName('ID_EXAM').AsInteger;
      edExamText.Text:=SelectStr('SELECT NAZEV FROM PARA_EXAM_TYP WHERE ID='+IntToStr(FExamID));
    end;
  finally
    qrTemp.Close;
    qrTemp.Free;
  end;
end;

// ************************************************************************************
procedure TdlgSubParatechOpravneni.btOprClick(Sender: TObject);
var FormIOParams: TFuncParams;
begin
  try
    case FTag of
      0:FormIOParams := TfrmSubjektyParatechSpecOpravneniParams.Create(0);
      1:FormIOParams := TfrmSubjektyParatechDruhyPKParams.Create(0);
    end;
    if FOprID>0 then
    begin
      case FTag of
        0: TfrmSubjektyParatechSpecOpravneniParams(FormIOParams).fpID:=FOprID;
        1: TfrmSubjektyParatechDruhyPKParams(FormIOParams).fpID:=FOprID;
      end;
      FormIOParams.fpSearchFor:=FOprID;
      FormIOParams.fpSearch:=True;
    end;
    case FTag of
      0:if frmSubjektyParatechSpecOpravneniExec(FormIOParams, true) then
        begin
          FOprID := TfrmSubjektyParatechSpecOpravneniParams(FormIOParams).fpID;
          edOprText.Text:=SelectStr('SELECT NAZEV FROM PARATECH_SPEC_OPR WHERE ID='+IntToStr(FOprID));
        end;
      1:if frmSubjektyParatechDruhyPKExec(FormIOParams, true) then
        begin
          FOprID := TfrmSubjektyParatechDruhyPKParams(FormIOParams).fpID;
          edOprText.Text:=SelectStr('SELECT NAZEV FROM PARATECH_OSOBNI_PK WHERE ID='+IntToStr(FOprID));
        end;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ************************************************************************************
procedure TdlgSubParatechOpravneni.btExamClick(Sender: TObject);
var FormIOParams: TfrmSubjektyParaganiExamTypParams;
begin
  try
    FormIOParams := TfrmSubjektyParaganiExamTypParams.Create(0);
    if FExamID>0 then
    begin
      FormIOParams.fpID:=FExamID;
      FormIOParams.fpSearchFor:=FExamID;
      FormIOParams.fpSearch:=True;
    end;
    if frmSubjektyParaganiExamTypExec(FormIOParams, true) then
    begin
      FExamID := FormIOParams.fpID;
      edExamText.Text:=SelectStr('SELECT NAZEV FROM PARA_EXAM_TYP WHERE ID='+IntToStr(FExamID));
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ************************************************************************************
procedure TdlgSubParatechOpravneni.sbOprDelClick(Sender: TObject);
begin
  FOprID := 0;
  edOprText.Text:='';
end;

// ************************************************************************************
procedure TdlgSubParatechOpravneni.sbExamDelClick(Sender: TObject);
begin
  FExamID := 0;
  edExamText.Text:='';
end;

// ************************************************************************************
procedure TdlgSubParatechOpravneni.edPrezkChange(Sender: TObject);
var Year, Month, Day: Word;
begin
  DecodeDate(edPrezk.Date, Year, Month, Day);
  edDo.Date:=SelectDat('SELECT (TO_DATE(''01.''||TO_CHAR(ADD_MONTHS(TO_DATE('''+IntToStr(Day)+'.'+IntToStr(Month)+'.'+IntToStr(Year)+''',''DD.MM.YYYY''),25),''MM.YYYY''),''DD.MM.YYYY'')-1) FROM DUAL')
end;

// ************************************************************************************
procedure TdlgSubParatechOpravneni.OnOK(var Accept: boolean);
var qrTemp:TOraQuery;
begin
  inherited;
  qrTemp:=nil;
  Accept:=False;
  if FOprID=0 then
  begin
    ErrorMsg('Není vybráno oprávnìní');
    EXIT;
  end;
  if edOd.Date<(now-10000) then
  begin
    ErrorMsg('Chybné datum získání');
    EXIT;
  end;
  try
    Case FTag of
      0:qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_PARATECH_SPEC_OPR WHERE ID='+IntToStr(FID), True);
      1:qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_PARATECH_OSOBNI_PK WHERE ID='+IntToStr(FID), True);
    end;
    qrTemp.Open;
    preparedata(qrTemp);
    if qrTemp.FieldByName('ID').AsInteger=0 then
    begin
      qrTemp.FieldByName('ID').AsInteger:=SelectInt('SELECT Get_Next_Ciselnik_ID FROM DUAL');
      qrTemp.FieldByName('SUB_ID').AsInteger:=FSubID;
    end;
    qrTemp.FieldByName('DATUM_OD').clear;
    if edOd.Date>(now-10000) then
      qrTemp.FieldByName('DATUM_OD').AsDateTime:=edOd.Date;
    qrTemp.FieldByName('DATUM_DO').clear;
    if edDo.Date>(now-10000) then
      qrTemp.FieldByName('DATUM_DO').AsDateTime:=edDo.Date;

    qrTemp.FieldByName('PREZKOUSENI').clear;
    if edPrezk.Date>(now-10000) then
      qrTemp.FieldByName('PREZKOUSENI').AsDateTime:=edPrezk.Date;
    if FExamID>0 then
      qrTemp.FieldByName('ID_EXAM').AsInteger:=FExamID
    else
      qrTemp.FieldByName('ID_EXAM').clear;
    Case FTag of
      0:qrTemp.FieldByName('ID_SPEC_OPR').AsInteger:=FOprID;
      1:qrTemp.FieldByName('ID_OSOBNI_PK').AsInteger:=FOprID;
    end;
    qrTemp.FieldByName('POZNAMKA').AsString:=mePoznamka.Text;
    qrTemp.Post;
    qrTemp.Close;
    Accept:=True;
  finally
    qrTemp.free;
  end;  
end;

end.
