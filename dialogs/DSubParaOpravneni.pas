unit DSubParaOpravneni;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Mask, DBCtrls,
  Ora, udmODAC, rxToolEdit, Buttons;

type
  TdlgSubParaOpravneniParams = class(TfuncParams)
    fpSubID: Integer;
    fpID: Integer;
    fpTag: Integer;
  end;

type
  TdlgSubParaOpravneni = class(TacDialogOkStorno)
    Label15: TLabel;
    Label18: TLabel;
    edJmeno: TEdit;
    edPrijmeni: TEdit;
    btExam: TButton;
    edExamText: TEdit;
    btOpr: TButton;
    edOprText: TEdit;
    edOd: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    edDo: TDateEdit;
    Label3: TLabel;
    edPrezk: TDateEdit;
    sbOprDel: TSpeedButton;
    sbExamDel: TSpeedButton;
    Label5: TLabel;
    mePoznamka: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btExamClick(Sender: TObject);
    procedure btOprClick(Sender: TObject);
    procedure sbExamDelClick(Sender: TObject);
    procedure sbOprDelClick(Sender: TObject);
    procedure edPrezkChange(Sender: TObject);
  private
    procedure OnOK(var Accept: boolean); override;
  public
    FID: integer;
    FTag: integer;
    FSubID: integer;
    FExamID: integer;
    FOprID: integer;
    procedure DataClear;
  end;

var
  dlgSubParaOpravneni: TdlgSubParaOpravneni;

function dlgSubParaOpravneniExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses Tools, Utils,
   FSubjektyParaganiExamTyp,FSubjektyParaganiProvozOprTyp,FSubjektyParaganiSportOprTyp,
   FSubjektyParaganiTechnikOprTyp;

function dlgSubParaOpravneniExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubParaOpravneni, dlgSubParaOpravneni, true);
  with dlgSubParaOpravneni do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

// ..........................................................................
procedure TdlgSubParaOpravneni.FormCreate(Sender: TObject);
begin
  inherited;
  borderstyle:=bsDialog;
  FID:=0;
  FTag:=0;
  FSubID:=0;
  FExamID:=0;
  FOprID:=0;
end;

// ..........................................................................
procedure TdlgSubParaOpravneni.FormShow(Sender: TObject);
var
  qrTemp:TOraQuery;
begin
  qrTemp:=nil;
  inherited;
  DataClear;
  if Assigned(Params) then
  begin
    with TdlgSubParaOpravneniParams(Params) do
    begin
      FID:=fpID;
      FTag:=fpTag;
      FSubID:=fpSubID;
    end;
    Case FTag of
      0:qrTemp:=CreateQueryOpen('SELECT S.PRIJMENI, S.JMENO, P.* '+
                                ' FROM SUBJEKTY S, (SELECT * FROM SUBJEKTY_PARAGANI_PROVOZ WHERE ID='+IntToStr(FID)+') P'+
                                ' WHERE S.ID=P.SUB_ID(+) AND S.ID='+IntToStr(FSubID));
      1:qrTemp:=CreateQueryOpen('SELECT S.PRIJMENI, S.JMENO, P.* '+
                                ' FROM SUBJEKTY S, (SELECT * FROM SUBJEKTY_PARAGANI_SPORT WHERE ID='+IntToStr(FID)+') P'+
                                ' WHERE S.ID=P.SUB_ID(+) AND S.ID='+IntToStr(FSubID));
      2:qrTemp:=CreateQueryOpen('SELECT S.PRIJMENI, S.JMENO, P.* '+
                                ' FROM SUBJEKTY S, (SELECT * FROM SUBJEKTY_PARAGANI_TECHNIK WHERE ID='+IntToStr(FID)+') P'+
                                ' WHERE S.ID=P.SUB_ID(+) AND S.ID='+IntToStr(FSubID));
    end;
  end;
  try
    if HasData(qrTemp) then
    begin
      edJmeno.Text:=qrTemp.FieldByName('JMENO').asString;
      edPrijmeni.Text:=qrTemp.FieldByName('PRIJMENI').asString;
      edOd.date:=qrTemp.FieldByName('DATUM_OD').asDatetime;
      edPrezk.date:=qrTemp.FieldByName('PREZKOUSENI').asDatetime;
      edDo.date:=qrTemp.FieldByName('DATUM_DO').asDatetime;
      mePoznamka.text:=qrTemp.FieldByName('POZNAMKA').asString;
      Case FTag of
        0:begin
            FOprID:=qrTemp.FieldByName('ID_OPR_PROVOZ').asInteger;
            edOprText.text:=SelectStr('SELECT NAZEV FROM PARA_PROVOZ_TYP WHERE ID='+IntToStr(FOprID));
          end;
        1:begin
            FOprID:=qrTemp.FieldByName('ID_OPR_SPORT').asInteger;
            edOprText.text:=SelectStr('SELECT NAZEV FROM PARA_SPORT_TYP WHERE ID='+IntToStr(FOprID));
          end;
        2:begin
            FOprID:=qrTemp.FieldByName('ID_OPR_TECHNIK').asInteger;
            edOprText.text:=SelectStr('SELECT NAZEV FROM PARA_TECHNIK_TYP WHERE ID='+IntToStr(FOprID));
          end;
      end;

      FExamID:=qrTemp.FieldByName('ID_EXAM').asInteger;
      edExamText.Text:=SelectStr('SELECT NAZEV FROM PARA_EXAM_TYP WHERE ID='+IntToStr(FExamID));
    end;
  finally
    qrTemp.Close;
    qrTemp.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubParaOpravneni.DataClear;
begin
  edJmeno.Text:='';
  edPrijmeni.Text:='';
  edExamText.Text:='';
  edOprText.Text:='';
  edOd.Text:='';
  edDo.Text:='';
  edPrezk.Text:='';
end;

// ..........................................................................
procedure TdlgSubParaOpravneni.btExamClick(Sender: TObject);
var
  FormIOParams: TfrmSubjektyParaganiExamTypParams;
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

// ..........................................................................
procedure TdlgSubParaOpravneni.btOprClick(Sender: TObject);
var
  FormIOParams: TFuncParams;
begin
  try
    case FTag of
      0:FormIOParams := TfrmSubjektyParaganiProvozOprTypParams.Create(0);
      1:FormIOParams := TfrmSubjektyParaganiSportOprTypParams.Create(0);
      2:FormIOParams := TfrmSubjektyParaganiTechnikOprTypParams.Create(0);
    end;
    if FOprID>0 then
    begin
      TfrmSubjektyParaganiProvozOprTypParams(FormIOParams).fpID:=FOprID; // vsechny 3 maji fpID
      FormIOParams.fpSearchFor:=FOprID;
      FormIOParams.fpSearch:=True;
    end;
    case FTag of
      0:if frmSubjektyParaganiProvozOprTypExec(FormIOParams, true) then
        begin
          FOprID := TfrmSubjektyParaganiProvozOprTypParams(FormIOParams).fpID;
          edOprText.text:=SelectStr('SELECT NAZEV FROM PARA_PROVOZ_TYP WHERE ID='+IntToStr(FOprID));
        end;
      1:if frmSubjektyParaganiSportOprTypExec(FormIOParams, true) then
        begin
          FOprID := TfrmSubjektyParaganiSportOprTypParams(FormIOParams).fpID;
          edOprText.text:=SelectStr('SELECT NAZEV FROM PARA_SPORT_TYP WHERE ID='+IntToStr(FOprID));
        end;
      2:if frmSubjektyParaganiTechnikOprTypExec(FormIOParams, true) then
        begin
          FOprID := TfrmSubjektyParaganiTechnikOprTypParams(FormIOParams).fpID;
          edOprText.text:=SelectStr('SELECT NAZEV FROM PARA_TECHNIK_TYP WHERE ID='+IntToStr(FOprID));
        end;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ..........................................................................
procedure TdlgSubParaOpravneni.sbExamDelClick(Sender: TObject);
begin
  FExamID := 0;
  edExamText.Text:='';
end;

// ..........................................................................
procedure TdlgSubParaOpravneni.sbOprDelClick(Sender: TObject);
begin
  FOprID := 0;
  edOprText.Text:='';
end;

// ..........................................................................
procedure TdlgSubParaOpravneni.edPrezkChange(Sender: TObject);
var Year, Month, Day: Word;
begin
  inherited;
  decodedate(edPrezk.date,Year, Month, Day);
  edDo.Date:=SelectDat('SELECT (TO_DATE(''01.''||TO_CHAR(add_Months(TO_DATE('''+IntToStr(Day)+'.'+IntToStr(Month)+'.'+IntToStr(Year)+''',''DD.MM.YYYY''),13),''MM.YYYY''),''DD.MM.YYYY'')-1) FROM DUAL')
(*
  Year:=Year+1;
  if (Month=2) and (Day=29) then // korekce prestupneho roku
    Day:=28;
  edDo.Date:=encodedate(Year, Month, Day);
*)
end;

// ..........................................................................
procedure TdlgSubParaOpravneni.OnOK(var Accept: boolean);
var
  qrTemp:TOraQuery;
begin
  inherited;
  qrTemp:=nil;
  Accept:=false;
  if FOprID=0 then
  begin
    ErrorMsg('Není vybráno oprávnìní');
    EXIT;
  end;
  if edOd.date<(now-25000) then
  begin
    ErrorMsg('Chybné datum získání');
    EXIT;
  end;
  try
    Case FTag of
      0:qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_PARAGANI_PROVOZ WHERE ID='+IntToStr(FID), true);
      1:qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_PARAGANI_SPORT WHERE ID='+IntToStr(FID), true);
      2:qrTemp:=CreateQueryWithText('SELECT * FROM SUBJEKTY_PARAGANI_TECHNIK WHERE ID='+IntToStr(FID), true);
    end;
    qrTemp.open;
    preparedata(qrTemp);
    if qrTemp.FieldByName('ID').asInteger=0 then
    begin
      qrTemp.FieldByName('ID').asInteger:=SelectInt('SELECT Get_Next_Ciselnik_ID FROM DUAL');
      qrTemp.FieldByName('SUB_ID').asInteger:=FSubID;
    end;
    qrTemp.FieldByName('DATUM_OD').clear;
    if edOd.date>(now-25000) then
      qrTemp.FieldByName('DATUM_OD').asDatetime:=edOd.date;
    qrTemp.FieldByName('DATUM_DO').clear;
    if edDo.date>(now-25000) then
      qrTemp.FieldByName('DATUM_DO').asDatetime:=edDo.date;

    qrTemp.FieldByName('PREZKOUSENI').clear;
    if edPrezk.date>(now-25000) then
      qrTemp.FieldByName('PREZKOUSENI').asDatetime:=edPrezk.date;
    if FExamID>0 then
      qrTemp.FieldByName('ID_EXAM').asInteger:=FExamID
    else
      qrTemp.FieldByName('ID_EXAM').clear;
    Case FTag of
      0:qrTemp.FieldByName('ID_OPR_PROVOZ').asInteger:=FOprID;
      1:qrTemp.FieldByName('ID_OPR_SPORT').asInteger:=FOprID;
      2:qrTemp.FieldByName('ID_OPR_TECHNIK').asInteger:=FOprID;
    end;
    qrTemp.FieldByName('POZNAMKA').asString:=mePoznamka.text;
    qrTemp.post;
    qrTemp.close;
    Accept:=true;
  finally
    qrTemp.free;
  end;  
end;

end.
