unit DZkouskaPlan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, DBCtrls, Db,
  Ora, udmODAC, Buttons, NotiaSpeedButton, Mask, rxToolEdit, Grids, NGrids, Contnrs,
  NDBGrids, MSGrid, NotiaComboBox, DataComboBox, EditEx, DBAccess, MemDS;

const
  DZKOUSKA_PLAN_PFO_ID = $0001;

Const
  CasovyPlanCelMin:integer=60; // pocet minut na jedno pole

type
  TdlgZkouskaPlanParams = class(TFuncParams)
    fpTechnicka: Boolean;
    fpSubjekt: integer;
    fpTOD_ID: string;
    fpPREDMET_ZK: string;
    fpMistnost: integer;
    fpDenList:boolean;
    fpTyp:Integer;
    fpSelSubjekt:Boolean;
    fpIDAkce:Integer;
    fpIDPozadavku:Integer;
    fpCas:Integer; // v minutach
    fpPracovnidobaStart:Boolean;
  public
    procedure CreateInitChild;override;
  end;

  TUdalObjects=class(TObject)
  public
    xPos, xSum, x1,x2:Integer; //pouziti pri vykresloveni v dennim gridu v kalendari
    UID:Integer;  // ID Udalosti
    UTechnicka:Integer;
    UOd:TDateTime;
    UDo:TDateTime;
    UDox:TDateTime;
    UTyp:String;
    UPozn:String;
    UPredm:String;
    UColor:Integer;
  end;

  TCelObjects=class(TObject)
  public
    datum:TDateTime;   // datum pole od v nasobcich CelMin
    Udal:TObjectList;
    function CreateUdalObjects(_UID,_UTechnicka: Integer; _UOd, _UDo, _UDox: TDateTime;
                               _UTyp, _UPozn, _UPredm: String
                               ): Integer;
    Constructor Create; Virtual;
    Destructor Destroy; override;
  end;

  TdlgZkouskaPlan = class(TacDialogOkStorno)
    pnForm: TPanel;
    qrCasovaData: TOraQuery;
    pnTop: TPanel;
    btMistnost: TButton;
    eddatum: TDateEdit;
    Label1: TLabel;
    ckWorkTime: TCheckBox;
    sbAktualizovat: TNotiaSpeedButton;
    pnLeft: TPanel;
    pnGrid: TPanel;
    grData: TStringGrid;
    pnLeftTop: TPanel;
    grObjekty: TMSDBGrid;
    qrObjekty: TOraQuery;
    dsObjekty: TOraDataSource;
    qrObjektyNAZEV: TWideStringField;
    qrObjektyID: TFloatField;
    qrObjektyDRUH: TFloatField;
    cbMistnost: TDataComboBox;
    cbDen: TDataComboBox;
    lbLupa: TLabel;
    cbLupa: TComboBox;
    btAddAkce: TButton;
    btAddPozadavek: TButton;
    rbAkce: TRadioButton;
    rbPozadavky: TRadioButton;
    qrAkce: TOraQuery;
    qrPozadavky: TOraQuery;
    qrCasovaDataPAR_OD: TDateTimeField;
    qrCasovaDataPAR_DO: TDateTimeField;
    qrCasovaDataNAZEV: TWideStringField;
    qrCasovaDataPOPIS: TWideStringField;
    qrCasovaDataUDALOST_OD: TDateTimeField;
    qrCasovaDataUDALOST_DO: TDateTimeField;
    qrCasovaDataMIS_ID: TIntegerField;
    qrCasovaDataID: TIntegerField;
    qrCasovaDataXID: TIntegerField;
    qrCasovaDataZDROJ_ID: TIntegerField;
    qrCasovaDataKOD_ZDROJE: TWideStringField;
    qrCasovaDataNAZEV_ZDROJE: TWideStringField;
    qrCasovaDataSTAV_ZDROJE: TSmallintField;
    qrCasovaDataMISTNOST_ID: TIntegerField;
    qrCasovaDataPREDMET: TWideStringField;
    pnCas: TPanel;
    qrObjektyLINE: TFloatField;
    qrCasovaDataTECHNICKA: TSmallintField;
    edMin: TEditEx;
    procedure btMistnostClick(Sender: TObject);
    procedure sbAktualizovatClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qrObjektyBeforeOpen(DataSet: TDataSet);
    procedure cbMistnostChange(Sender: TObject);
    procedure grDataDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grObjektyGetRowColor(var Color, FontColor: Integer);
    procedure eddatumChange(Sender: TObject);
    procedure cbDenChange(Sender: TObject);
    procedure cbLupaChange(Sender: TObject);
    procedure eddatumAcceptDate(Sender: TObject; var ADate: TDateTime;
      var Action: Boolean);
    procedure qrObjektyAfterOpen(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btAddAkceClick(Sender: TObject);
    procedure grDataClick(Sender: TObject);
    procedure grDataMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grDataMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grDataSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure grDataDblClick(Sender: TObject);
    procedure rbPozadavkyClick(Sender: TObject);
    procedure rbAkceClick(Sender: TObject);
    procedure btAddPozadavekClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure qrObjektyAfterScroll(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure grDataEnter(Sender: TObject);
    procedure qrCasovaDataBeforeOpen(DataSet: TDataSet);
  private
    FTechnicka:Boolean;
    FTyp: integer;
    FSubjekt: integer;
    FTOD_ID: string;
    FPredmet_ZK: string;
    FDenList:boolean;
    FMistnost: Integer;
    FMinDayHour:Word;
    FMaxDayHour:Word;
    FLastMouseRow: Integer;
    FMasterCount: Integer;
    FLastMouseCol: Integer;
    FSelectedCels:TRect;
    FSelectedDatum:TDateTime;
    FCas:integer; // v minutach
    IsShowing:Boolean;
    FPracovnidobaStart:Boolean;
    procedure DataClear;
    procedure OnOK(var Accept: boolean); override;
    procedure InitComboMistnosti;
    procedure InitComboDny;
    procedure MasterRefresh;
    function ColByDate(const d:TDateTime):Integer;
    procedure NaplCasovaData;
    procedure SetMasterCount(const Value: Integer);
    procedure SetLastMouseCol(const Value: Integer);
    procedure SetLastMouseRow(const Value: Integer);
    procedure UpdateControlStates;
  public
    FSelSubjekt:boolean;
    property LastMouseCol:Integer read FLastMouseCol write SetLastMouseCol;
    property LastMouseRow:Integer read FLastMouseRow write SetLastMouseRow;
    property MasterCount:Integer read FMasterCount write SetMasterCount;
  end;

var
  dlgZkouskaPlan: TdlgZkouskaPlan;

function dlgZkouskaPlanExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}
uses
  uUCLConsts, Tools, Caches, Utils, SysParam,uStoredProcs, uDBUtils, NConsts,
    FMistnosti, DCasovyPlanInfo, FAkce, FPozadavky, uObjUtils;

var
  FDataSelSubjekt:Boolean;
function dlgZkouskaPlanExec(_Params: TFuncParams): boolean;
begin
//  dlgCasovyPlanInfo:=nil;
  PrepareForm(TdlgCasovyPlanInfo, dlgCasovyPlanInfo, false); {1}
  PrepareForm(TdlgZkouskaPlan, dlgZkouskaPlan, true); {1}
  try
    with dlgZkouskaPlan do {2}
    begin
      Params := _Params;
      if Assigned(Params) then
        begin
          if Params is TdlgZkouskaPlanParams then
            With TdlgZkouskaPlanParams(Params) do
            begin
              FTechnicka:=fpTechnicka;
              FTyp:=fpTyp;
              FMistnost:=fpMistnost;
              FCas:=fpCas;
              FPracovnidobaStart:=fpPracovnidobaStart;
              if FTyp=1 then
                begin
                  FSubjekt:=fpSubjekt;
                  FTOD_ID:=fpTOD_ID;
                  FPredmet_ZK:=fpPredmet_ZK;
                  FDenList:=fpDenList;
                end;
            end;
        end;
      cbDen.Visible:=FDenList;
      eddatum.Visible:=not cbDen.Visible;
      eddatum.enabled:=eddatum.visible;
      cbDen.enabled:=cbDen.visible;

      if FDenList and (SelectInt('SELECT COUNT(*) FROM EXAM_DNY')=0) then
        begin
          ErrorMsg('Není definován "povolený" seznam dnù');
          Abort;
        end;

      Result := (ShowModal = mrOK) or FDataSelSubjekt;
      if Assigned(Params) then
        if Params is TdlgZkouskaPlanParams then
          With TdlgZkouskaPlanParams(Params) do
            fpSelSubjekt:=FDataSelSubjekt;
    end; {with}
  finally
    dlgCasovyPlanInfo.Free;
    dlgZkouskaPlan.Free;
    dlgCasovyPlanInfo:=nil;
    dlgZkouskaPlan:=nil;
  end;
end;

{ TCelObjects }
// ***************************************************************************
constructor TCelObjects.Create;
begin
  Udal:=TObjectList.Create;
end;

// ***************************************************************************
function TCelObjects.CreateUdalObjects(_UID,_UTechnicka: Integer; _UOd, _UDo, _UDox: TDateTime;
 _UTyp, _UPozn, _UPredm: String): Integer;
var
  u:TUdalObjects;
begin
  result:=-1;
  u:=TUdalObjects.Create;
  With u do
  begin
   xPos:=0;
   xSum:=0;
   x1:=0;
   x2:=0;
   UID:=_UID;
   UOd:=_UOd;
   UDo:=_UDo;
   UDox:=_UDox;
   UTyp:=_UTyp;
   UPozn:=_UPozn;
   UPredm:=_UPredm;
   UTechnicka:=_UTechnicka;
(* AA
   if perm_udal_s and not USoukr then
     UPozn:=_UPozn;
   UColor:=SelectInt('SELECT COLOR FROM CRM_UDALOSTI_TYPY WHERE KOD='+Q(_UTyp));
*)
   if UTechnicka=1 then
     UColor:=clBtnShadow
   else
    Case StrToInt(UTyp) of
      1:UColor:=$00B5D5AA;
      2:UColor:=$00BBBBFF;
      3:UColor:=$00BFFFFF;
    end;
  end;
  result:=Udal.add(u);
end;

// ***************************************************************************
destructor TCelObjects.Destroy;
begin
  Udal.Free;
  inherited;
end;



{ TdlgZkouskaPlanParams }
// ***************************************************************************
procedure TdlgZkouskaPlanParams.CreateInitChild;
begin
  inherited;
  fpTechnicka:=False;
  fpSelSubjekt:=False;
  fpDenList:=false;
  fpMistnost:=-1;
  fpSubjekt:=-1;
  fpTOD_ID:='';
  fpPredmet_ZK:='';
  fpTyp:=0;
  fpIDAkce:=-1;
  fpIDPozadavku:=-1;
  fpCas:=1;
  fpPracovnidobaStart:=False;
end;

{ TdlgZkouskaPlan }
// ***************************************************************************
procedure TdlgZkouskaPlan.FormCreate(Sender: TObject);
begin
  inherited;
  FDataSelSubjekt:=False;
  FTechnicka:=False;
  FTyp:=0;
  FSelSubjekt:=False;
  FMasterCount:=0;
  FLastMouseCol:=-1;
  FLastMouseRow:=-1;
  FSubjekt:=-1;
  FTOD_ID:='';
  FPredmet_ZK:='';
  FDenList:=false;
  FSelectedDatum:=Round(now*24)/24;
  FSelectedCels:=grData.CellRect(0,0);
  FCas:=0;
  FPracovnidobaStart:=False;

  eddatum.Top:=cbDen.Top;

  rbAkce.Checked:=True;
  qrCasovaData.Close;
  qrCasovaData.SQL.TEXT:=qrAkce.SQL.TEXT;
  IsShowing:=False;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.FormShow(Sender: TObject);
begin
  inherited;
  cbLupa.ItemIndex:=cbLupa.Items.IndexOf('100% (zobrazení dne)');
  InitComboMistnosti;
  InitComboDny;
  MasterRefresh;

  UpdateControlStates;

  if cbDen.enabled then
    cbDenChange(nil)
  else
    eddatum.Date:=now;

  btOk.enabled:=False;
  if FTyp=1 then
    begin
      btCancel.enabled:=True;
      btAddAkce.enabled:=True;
//      btAddPozadavek.enabled:=False;
    end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.OnOK(var Accept: boolean);
begin
  inherited;
//
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.btMistnostClick(Sender: TObject);
var
  FormIOParams: TfrmMistnostiParams;
begin
  FormIOParams := TfrmMistnostiParams.Create(FMISTNOSTI_PFO_ID);
  try
    if frmMistnostiExec(FormIOParams, true) then
    begin
      FMistnost:=FormIOParams.fpID;
      MasterRefresh;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.qrObjektyAfterOpen(DataSet: TDataSet);
begin
  try
    qrObjekty.DisableControls;
    qrObjekty.Last;
    MasterCount:=qrObjekty.recordcount;
    qrObjekty.First;
 finally
    qrObjekty.EnableControls;
 end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FDataSelSubjekt:=FSelSubjekt;
  IsShowing:=False;
  qrObjekty.Close;
  inherited;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.FormDestroy(Sender: TObject);
var
  i,j:Integer;
begin
  if Assigned(dlgCasovyPlanInfo) then
    begin
      dlgCasovyPlanInfo.Hide;
      dlgCasovyPlanInfo.Free;
    end;
  dlgCasovyPlanInfo:=nil;
  DataClear;
(*
  if FMasterCount>0 then
    For i:=0 to grData.ColCount-1 do
      For j:=0 to FMasterCount+2 do  // celkem + 3
        if assigned(grData.Objects[i,j]) then
          begin
            TCelObjects(grData.Objects[i,j]).Free;
            grData.Objects[i,j]:=nil;
          end;
*)          
  inherited;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.sbAktualizovatClick(Sender: TObject);
begin
  inherited;
  InitComboMistnosti;
  InitComboDny;
  MasterRefresh;
  NaplCasovaData;
  grData.Repaint;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.InitComboMistnosti;
var
  t:String;
  i:Integer;
begin
  if FMistnost>0 then
    t:=SelectStr('SELECT NAZEV FROM MISTNOSTI WHERE ID='+IntToStr(FMistnost))
  else
    t:=cbMistnost.text;
  cbMistnost.Clear;
  cbMistnost.AddQueryItems('SELECT NAZEV, ID FROM MISTNOSTI WHERE STAV=0 ORDER BY NAZEV',database);
  cbMistnost.InsertItemValue(0, '', '0');
  if t<>'' then
    begin
      cbMistnost.ItemIndex:=cbMistnost.IndexOfItems(t);
    end
  else
    begin
      cbMistnost.ItemIndex := 0;
    end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.InitComboDny;
var
  t:String;
begin
  t:=cbDen.text;
  cbDen.Clear;
  cbDen.AddQueryItems('SELECT TO_CHAR(DATUM,''DD.MM.YYYY'') as DAT, ID FROM EXAM_DNY ORDER BY DATUM',database);
  if t='' then
    t:=SelectStr('SELECT TO_CHAR(MIN(DATUM),''DD.MM.YYYY'') as DAT FROM EXAM_DNY WHERE DATUM>SYSDATE');
  if (cbDen.Items.Count>0) and (t<>'') then
    begin
      cbDen.ItemIndex:=cbDen.IndexOfItems(t);
    end
  else
    begin
      cbDen.InsertItemValue(0, '', '0');
      cbDen.ItemIndex := 0;
    end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.cbDenChange(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  i:=StrToInt(cbDen.GetDataValue(cbDen.ItemIndex));
  if (i=0) and (cbDen.items.Count>0) then
    begin
      i:=StrToInt(cbDen.GetDataValue(cbDen.items.Count-1));
      cbDen.ItemIndex:=cbDen.items.Count-1;
    end;

  if i=0 then
    begin
      eddatum.clear;
      ErrorMsg('Nelze plánovat ani zobrazit');
      Close;
    end;

  eddatum.date:=SelectDat('SELECT DATUM FROM EXAM_DNY WHERE ID='+IntToStr(i));
  eddatumChange(nil);
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.MasterRefresh;
begin
  qrObjekty.Close;
  qrObjekty.Open;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.qrObjektyBeforeOpen(DataSet: TDataSet);
begin
  inherited;
//  if FMistnost=0 then
//    Abort;
  qrObjekty.ParamByName('MISTNOST').asInteger:=FMistnost;
end;


// ***************************************************************************
procedure TdlgZkouskaPlan.cbMistnostChange(Sender: TObject);
begin
  FMistnost:=StrToInt(cbMistnost.GetDataValue(cbMistnost.ItemIndex));
  MasterRefresh;
  NaplCasovaData;
  grData.Repaint;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.grObjektyGetRowColor(var Color,
  FontColor: Integer);
begin
  inherited;
  Case qrObjektyDRUH.asInteger of
    1:Color:=$00B5D5AA;
    2:Color:=$00BBBBFF;
    3:Color:=$00BFFFFF;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.eddatumChange(Sender: TObject);
begin
  cbLupaChange(nil);
  grData.Repaint;

  cbDen.Color:=clWindow;
  edDatum.Color:=clWindow;
  if Trunc(eddatum.date)<Trunc(now) then
    begin
      cbDen.Color:=$006666DD;
      edDatum.Color:=$006666DD;
    end;

  FSelectedDatum:=edDatum.Date+FMinDayHour/24;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.cbLupaChange(Sender: TObject);
begin
  inherited;
  SetMasterCount(MasterCount);
  NaplCasovaData;

// aby doslo ke spravnemu posunu cca na stred
  if FPracovnidobaStart then
    grData.Col:=ColByDate(eddatum.Date+FMinDayHour/24)+7
  else
    grData.Col:=ColByDate(eddatum.Date+Frac(now))+4;
  grData.Col:=grData.Col-4;
  grData.Col:=grData.Col+2;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.eddatumAcceptDate(Sender: TObject;
  var ADate: TDateTime; var Action: Boolean);
begin
  inherited;
  eddatumChange(nil)
end;


// ***************************************************************************
procedure TdlgZkouskaPlan.SetLastMouseCol(const Value: Integer);
begin
  FLastMouseCol := Value;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.SetLastMouseRow(const Value: Integer);
begin
  FLastMouseRow := Value;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.SetMasterCount(const Value: Integer);
begin
  FMasterCount := Value;
  grData.RowCount:=FMasterCount+3;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.DataClear;
var
  i,j:Integer;
begin
  if FMasterCount>0 then
    For i:=0 to grData.ColCount-1 do
      For j:=0 to FMasterCount+2 do  // celkem + 3
        if assigned(grData.Objects[i,j]) then
          begin
            TCelObjects(grData.Objects[i,j]).Free;
            grData.Objects[i,j]:=nil;
          end;
end;


// ***************************************************************************
function TdlgZkouskaPlan.ColByDate(const d: TDateTime): Integer;
var
  i:Integer;
begin
  result:=-1;
  For i:=0 to grData.ColCount-1 do
   if d<TCelObjects(grData.Objects[i,2]).Datum then
     begin
       result:=i-1;
       if (result>=0) then
         if TCelObjects(grData.Objects[i,2]).Datum>0 Then;
       Break;
     end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.grDataDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i, x,xx:Integer;
  Hour, Min, Sec, MSec: Word;
  URect:TRect;
  flags:Word;
  t:String;
  u:TUdalObjects;
  c:TCelObjects;
begin
  inherited;
  if (grData.LeftCol+grData.VisibleColCount)=ACol Then
    grData.Cells[ACol-1, ARow]:='';

//  if grData.LeftCol=ACol Then
//    grData.Cells[ACol+1, ARow]:='';


  URect:=grData.CellRect(ACol,ARow);
  if URect.Top=URect.Bottom then
    EXIT;

  c:=TCelObjects(grData.Objects[ACol,ARow]);

  if not assigned(c) then
    exit;

  grData.Canvas.Font.size:=grData.Font.size-2;
  DecodeTime(c.datum, Hour, Min, Sec, MSec);

  if ARow=0 then  // dny
    begin
      if Hour=FMinDayHour then
        begin
          grData.Canvas.Font.style:=grData.Canvas.Font.style+[fsBold];
          t:=FormatDateTime('dd.mmmm yyyy',c.datum); // dny
          grData.Canvas.TextOut(URect.Left,URect.Top, t);
        end;
      if Hour=FMinDayHour+1 then  // ta devka z canvasu to orezava :-((
        begin
          grData.Canvas.Font.style:=grData.Canvas.Font.style+[fsBold];
          t:=FormatDateTime('dd.mmmm yyyy',c.datum); // dny
          With grData do
            Canvas.TextOut(URect.Left-DefaultColWidth-GridLineWidth,URect.Top, t);
        end;
    end;

  grData.Canvas.Font.style:=grData.Canvas.Font.style-[fsBold];
  if ARow=1 then  // hodiny
    begin
      t:=FormatDateTime('hh:nn',c.datum); // Hodiny
      grData.Canvas.TextOut(URect.Left,URect.Top, t);
    end;

  if ARow=2 then
    begin
      grData.Canvas.Brush.Color:=grObjekty.FixedColor;
      grData.Canvas.FillRect(URect);
    end;

  if ARow>=grData.FixedCols then
  begin
    URect:=grData.CellRect(ACol,ARow);
    grData.Canvas.Brush.Color:=clWindow;
    URect.Bottom:=URect.Bottom+1;
    if Hour=FMaxDayHour then
      begin
        URect.Left:=URect.Right{-1};
        URect.Right:=URect.Right+1;
        grData.Canvas.FillRect(URect);
      end;
    if Hour=FMinDayHour then
      begin
        URect.Right:=URect.Left+1;
        URect.Left:=URect.Left-1;
        grData.Canvas.FillRect(URect);
      end;
    grData.Canvas.Brush.Color:=grData.Color;
  end;

  if c.Udal.Count=0 then EXIT;

  flags:=0;
  if c.Udal.Count>1 then flags:=11;

// Bila barva
  For i:=0 to c.Udal.Count-1 do
  Begin
    URect:=grData.CellRect(ACol,ARow);
    u:=TUdalObjects(c.Udal[i]);

    if Trunc(u.UOD*60*24)<Trunc(c.datum*60*24) then
      x:=URect.Left-1
    else
      begin
        DecodeTime(u.UOD, Hour, Min, Sec, MSec);
        x:=URect.Left+Round((URect.Right-URect.Left)*Min/CasovyPlanCelMin);
      end;
    if Trunc(u.UDo*60*24)>Trunc((c.datum+1/24)*60*24) then
      xx:=URect.Right+1
    else
      begin
        DecodeTime(u.UDo, Hour, Min, Sec, MSec);
//        xx:=URect.Left+Round((URect.Right-URect.Left)*Min/CasovyPlanCelMin);
        xx:=URect.Left+Round((grData.DefaultColWidth)*Min/CasovyPlanCelMin);
        if xx=URect.Left then xx:=URect.Right;
      end;

    if x=xx then xx:=xx+1;
    URect.left:=x;
    if URect.left<0 then URect.left:=0;
    URect.Right:=xx;
    URect.top:=URect.top+2;
    URect.bottom:=URect.bottom-2;
    grData.Canvas.Brush.Color:=clWhite;
    grData.Canvas.FillRect(URect);
  end;
// Oramovani
  For i:=0 to c.Udal.Count-1 do
  Begin
    URect:=grData.CellRect(ACol,ARow);
    u:=TUdalObjects(c.Udal[i]);
//    n:=u.UDo-u.UOd;
    if Trunc(u.UOD*60*24)<Trunc(c.datum*60*24) then // Nastaveni priznaku stylu a mista odkum kam vykreslovat
      begin
        flags:=flags or 10;
        x:=URect.Left-1;
      end
    else
      begin
        DecodeTime(u.UOD, Hour, Min, Sec, MSec);
        x:=URect.Left+Round((URect.Right-URect.Left)*Min/CasovyPlanCelMin);
      end;
    if Trunc(u.UDo*60*24)>Trunc((c.datum+1/24)*60*24) then
      begin
        flags:=flags or 01;
        xx:=URect.Right+1;
      end
    else
      begin
        DecodeTime(u.UDo, Hour, Min, Sec, MSec);
//        xx:=URect.Left+Round((URect.Right-URect.Left)*Min/CasovyPlanCelMin);
        xx:=URect.Left+Round((grData.DefaultColWidth)*Min/CasovyPlanCelMin);
        if xx=URect.Left then xx:=URect.Right;
      end;
    if x=xx then xx:=xx+1;
    URect.left:=x;
    if URect.left<0 then URect.left:=0;
    URect.Right:=xx;
    URect.top:=URect.top+2;
    URect.bottom:=URect.bottom-2;
    if flags>0 then
      begin
        grData.Canvas.Pen.Color:=u.UColor;
        grData.Canvas.Rectangle(URect.left, URect.Top, URect.Right, URect.Top+1);
        grData.Canvas.Rectangle(URect.left, URect.bottom-1, URect.Right, URect.bottom);
        grData.Canvas.Brush.Color:=u.UColor;
        if Trunc(u.UOD*60*24)>=Trunc(c.datum*60*24) then  // zesileni pocatecni casti
          begin
            uRect.Right:=URect.Left+4;
            grData.Canvas.FillRect(URect);
            uRect.Right:=xx;
          end;
        if Trunc(u.UDo*60*24)<=Trunc((c.datum+1/24)*60*24) then // zesileni koncove casti
          begin
            uRect.left:=URect.right-1;
            grData.Canvas.FillRect(URect);
          end;
      end
    else
      begin
        grData.Canvas.Brush.Color:=u.UColor;
        grData.Canvas.FillRect(URect);
      end;
    grData.Canvas.Pen.Color:=grData.Font.Color;
    grData.Canvas.Brush.Color:=grData.Color;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.NaplCasovaData;
var
  URect:TRect;
  i,j:Integer;
  d:TDatetime;
  dOd, dDo, dDox:TDatetime;
  Hour, Min, Sec, MSec: Word;
begin
  if not qrObjekty.Active then
    EXIT;

  FMinDayHour:=0; // vse
  FMaxDayHour:=23;
  CasovyPlanCelMin:=60;
  DataClear;
  if ckWorkTime.Checked then
    begin
      FMinDayHour:=7;
      FMaxDayHour:=17;
(* AA
      FMinDayHour:=parPracDobaOd; // pracovni
      FMaxDayHour:=parPracDobaDo;
*)
    end;
  d:=eddatum.Date-((grData.ColCount div 2)/(FMaxDayHour-FMinDayHour+1))+1;
  d:=Trunc(d)+EncodeTime(FMinDayHour,0,0,0) ;// zarovnani na hodiny
  For i:=0 to grData.ColCount-1 do // datumy do objektu
  begin
    DecodeTime(d+(i/24), Hour, Min, Sec, MSec);
    for j:=0 to MasterCount+2 do
    begin
      if not assigned(grData.Objects[i,j]) then
        grData.Objects[i,j]:=TCelObjects.Create;
      TCelObjects(grData.Objects[i,j]).Datum:=d+i/24;
    end;
    if Hour=FMaxDayHour then
      d:=d+(24-FMaxDayHour+FMinDayHour-1)/24;
  end;

  qrCasovaData.Close;

  qrObjekty.DisableControls;
  qrObjekty.First;
  j:=3;
  try
    While not qrObjekty.eof do
    begin
(* AA
      perm_udal_spriv:=GetCrmUserOsobaPermission(perm_crm_udal_s, qrMasterOSOBA.asInteger ,Uzivatel);
      perm_udal_s:=GetCrmUserOsobaPermission(perm_crm_udal_s_priv, qrMasterOSOBA.asInteger ,Uzivatel);
*)
      qrCasovaData.ParamByName('DatumOd').asDateTime:=TCelObjects(grData.Objects[0,3]).Datum;
      qrCasovaData.ParamByName('DatumDo').asDateTime:=TCelObjects(grData.Objects[grData.ColCount-1,3]).Datum+1/24;
      if qrObjektyDRUH.asInteger<=0 then
        begin
          qrCasovaData.ParamByName('MISTNOST').asInteger:=-1;
          qrCasovaData.ParamByName('ZDROJ').asInteger:=-1;
        end
      else
       if qrObjektyDRUH.asInteger=1 then
         begin
           qrCasovaData.ParamByName('MISTNOST').asInteger:=FMistnost;
           qrCasovaData.ParamByName('ZDROJ').Clear;
         end
       else
         begin
           qrCasovaData.ParamByName('MISTNOST').Clear;
           qrCasovaData.ParamByName('ZDROJ').asInteger:=qrObjektyID.asInteger
         end;
      qrCasovaData.Open;
      if Hasdata(qrCasovaData) then
        for i:=0 to grData.ColCount-1 do
        begin
          qrCasovaData.First;
          d:=TCelObjects(grData.Objects[i,2]).Datum;
          While not qrCasovaData.eof do
          begin
              dOd:=Trunc(qrCasovaDataUDALOST_OD.asDateTime*24*60)/24/60;
              dDo:=Round((qrCasovaDataUDALOST_DO.asDateTime*24*60)-1)/24/60;
              dDox:=Round(qrCasovaDataUDALOST_DO.asDateTime*24*60)/24/60;
              if (((dOd>=d) and (dOd<(d+1/24))) OR
                  ((dDo>d)  and (dDo<(d+1/24))) OR
                  ((dOd<d)  and (dDo>(d+1/24)))) then
                With TCelObjects(grData.Objects[i,j]) do
// AA                if perm_udal_spriv  then
                  begin
                    CreateUdalObjects(qrCasovaDataID.asInteger,qrCasovaDataTECHNICKA.asInteger,
                                      dOd, dDo, dDox,
                                      qrObjektyDRUH.asString,
                                      qrCasovaDataPOPIS.asString,
                                      qrCasovaDataPREDMET.asString);
                  end;
            qrCasovaData.Next;
          end;
        end;
      qrCasovaData.Close;
      qrObjekty.Next;
      j:=j+1;
    end
  finally
    qrObjekty.First;
    qrCasovaData.Close;
    qrObjekty.EnableControls;
    self.Repaint;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.qrObjektyAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if IsShowing and not (activeControl=grData) then
  begin
    if (qrObjektyLINE.asInteger<(grData.Row-2)) and (grData.Row>2) then
//      While qrObjektyLINE.asInteger<>(grData.Row-2) do
        grData.Row:=qrObjektyLINE.asInteger+2;
    if (qrObjektyLINE.asInteger>(grData.Row-2)) and (grData.Row>2) then
//      While qrObjektyLINE.asInteger<>(grData.Row-2) do
        grData.Row:=qrObjektyLINE.asInteger+2;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.grDataClick(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  FSelectedCels:=grData.CellRect(0,0);
  if assigned(TCelObjects(grData.Objects[grData.Col,2])) then
    FSelectedDatum:=TCelObjects(grData.Objects[grData.Col,2]).Datum;
  if grData.Selection.Top>2 then
    FSelectedCels:=grData.CellRect(grData.Selection.Left,grData.Selection.Top);

  qrObjekty.DisableControls;
  try
//    qrObjekty.First;
//    For i:=3 to (grData.Row+grData.TopRow-1) do
//      qrObjekty.Next;
    if activeControl=grData then
    begin
      if (qrObjektyLINE.asInteger<(grData.Row-2)) and (grData.Row>2) then
        While qrObjektyLINE.asInteger<>(grData.Row-2) do
          qrObjekty.Next;

      if (qrObjektyLINE.asInteger>(grData.Row-2)) and (grData.Row>2) then
        While qrObjektyLINE.asInteger<>(grData.Row-2) do
          qrObjekty.Prior;
    end;
  finally
    qrObjekty.EnableControls;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.rbPozadavkyClick(Sender: TObject);
begin
  qrCasovaData.Close;
  qrCasovaData.SQL.TEXT:=qrPozadavky.SQL.TEXT;
//  MasterRefresh;
  NaplCasovaData;
  self.Repaint;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.rbAkceClick(Sender: TObject);
begin
  qrCasovaData.Close;
  qrCasovaData.SQL.TEXT:=qrAkce.SQL.TEXT;
//  MasterRefresh;
  NaplCasovaData;
  self.Repaint;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.grDataSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
//  beep;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.grDataMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FSelectedCels:=grData.CellRect(0,0);
  if assigned(grData.Objects[grData.Col,2]) then
    FSelectedDatum:=TCelObjects(grData.Objects[grData.Col,2]).Datum;
  if grData.Selection.Top>2 then
    FSelectedCels:=grData.CellRect(grData.Selection.Left,grData.Selection.Top);
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.grDataDblClick(Sender: TObject);
var
  d:TDateTime;
  AkceExists:Boolean;
  addAkce:boolean;
begin
  inherited;
  FSelectedCels:=grData.CellRect(0,0);
  FSelectedDatum:=TCelObjects(grData.Objects[grData.Col,2]).Datum;
  if grData.Selection.Top>2 then
    FSelectedCels:=grData.CellRect(grData.Selection.Left,grData.Selection.Top);

  d:=FSelectedDatum;
  qrCasovaData.Close;
  if rbAkce.Checked then
    qrCasovaData.SQL.TEXT:=qrAkce.SQL.TEXT
  else
    qrCasovaData.SQL.TEXT:=qrPozadavky.SQL.TEXT;
  qrCasovaData.ParamByName('DatumOd').asDateTime:=d+(0.5/(24*60));
  qrCasovaData.ParamByName('DatumDo').asDateTime:=d+(1/24)-(0.5/(24*60));


  if qrObjektyDRUH.asInteger<=0 then
    begin
      qrCasovaData.ParamByName('MISTNOST').asInteger:=-1;
      qrCasovaData.ParamByName('ZDROJ').asInteger:=-1;
    end
  else
    if qrObjektyDRUH.asInteger=1 then
      begin
        qrCasovaData.ParamByName('MISTNOST').asInteger:=FMistnost;
        qrCasovaData.ParamByName('ZDROJ').Clear;
      end
    else
      begin
        qrCasovaData.ParamByName('MISTNOST').Clear;
        qrCasovaData.ParamByName('ZDROJ').asInteger:=qrObjektyID.asInteger
      end;
  qrCasovaData.Open;
  AkceExists:=Hasdata(qrCasovaData);
  if AkceExists then
    While not qrCasovaData.eof do
    begin
      if qrCasovaDataUDALOST_DO.asDateTime>FSelectedDatum then
        FSelectedDatum:=qrCasovaDataUDALOST_DO.asDateTime;
      qrCasovaData.Next;
    end;
  qrCasovaData.Close;
  if FSelectedDatum>(d+(1/24)-(0.5/(24*60))) then
    Beep
  else
    begin
      addAkce:=rbAkce.checked;
      addAkce:=addAkce or (FTyp=1);

      if AddAkce then
        begin
          if (btAddAkce.Visible) and (btAddAkce.enabled) then
            btAddAkceClick(nil)
        end
      else
        begin
          if (btAddPozadavek.Visible) and (btAddPozadavek.enabled) then
            btAddPozadavekClick(nil)
        end;
    end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.grDataMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
 aCol, aRow:Integer;
 c:TCelObjects;
 u:TUdalObjects;
 i:Integer;
 t:string;
 p:TPoint;
begin
  inherited;
  GetCursorPos(p);
  grData.MouseToCell(X, Y, aCol, aRow);
  if (aCol<0) or (aRow<0) then
    begin
      LastMouseCol:=-1;
      LastMouseRow:=-1;
      if Assigned(dlgCasovyPlanInfo) then
        begin
          dlgCasovyPlanInfo.Hide;
          dlgCasovyPlanInfo.lbInfo.Clear;
        end;
      EXIT;
    end;

  if (aCol=LastMouseCol) and (aRow=LastMouseRow) then
    begin
      if Assigned(dlgCasovyPlanInfo) then
        begin
          dlgCasovyPlanInfo.Left:=p.X+1;
          dlgCasovyPlanInfo.Top:=p.Y+1;
//          if not dlgCasovyPlanInfo.Visible then
//            dlgCasovyPlanInfo.Show;
        end;
      EXIT;
    end;

  LastMouseCol:=aCol;
  LastMouseRow:=aRow;

  if Assigned(dlgCasovyPlanInfo) then
    begin
      dlgCasovyPlanInfo.Hide;
      dlgCasovyPlanInfo.lbInfo.Clear;
      dlgCasovyPlanInfo.UdalList.Clear;
    end;


  c:=TCelObjects(grData.Objects[ACol,ARow]);
  if not assigned(c) or (c.Udal.Count=0) then EXIT;
  For i:=0 to c.Udal.Count-1 do
  begin
    u:=TUdalObjects(c.Udal[i]);
    t:=FormatdateTime('hh:nn',u.UOd)+' - '+
       FormatdateTime('hh:nn',u.UDox);
    t:=t+' : '+u.UPredm;
    if Assigned(dlgCasovyPlanInfo) then
      begin
        dlgCasovyPlanInfo.lbInfo.Items.add(t);
        dlgCasovyPlanInfo.UdalList.add(IntToStr(u.UID));
//        if not dlgCasovyPlanInfo.Visible then
//          dlgCasovyPlanInfo.Show;
//        bringWindowToTop(dlgCasovyPlanInfo.handle);
      end;
  end;
  if Assigned(dlgCasovyPlanInfo) and (dlgCasovyPlanInfo.lbInfo.Items.Count>0) then
    begin
      dlgCasovyPlanInfo.Left:=p.X+1;
      dlgCasovyPlanInfo.Top:=p.Y+1;
      if not dlgCasovyPlanInfo.Visible then
        dlgCasovyPlanInfo.Show;
      bringWindowToTop(dlgCasovyPlanInfo.handle);
    end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.btAddAkceClick(Sender: TObject);
var
  FormIOParams: TfrmAkceParams;
  aID,i:Integer;
  t:String;
begin
  if (FTyp=1) and (FSubjekt<0) then
  begin
    If Warn('Nemáte vybraný subjekt.'+EOL+'Pøejete si pokraèovat výbìrem subjektu?') then
      begin
        FSelSubjekt:=True;
        Close;
      end;
    Exit;
  end;

//  ErrorMsg('Pøipravuje se');
//  Abort;

  FormIOParams := TfrmAkceParams.Create(PF_NOTHING, [ofoaInsert]);
  try
    i:=0;
    aID:=0;
    if qrObjektyDRUH.asInteger>1 then
      i:=qrObjektyID.asInteger;

    if (FTyp=1) and ((i<=0) or ((i>0) and (qrObjektyDRUH.asInteger<>2))) then
      begin
        ErrorMsg('Není vybrán "vázaný" zdroj.');
        EXIT;
      end;


    aID:=NovaAkce(FMistnost, FSubjekt, FTOD_ID, FPredmet_ZK,
                  FSelectedDatum, FSelectedDatum+(edMin.asInteger/(24*60)),
                  i);
    if aID=0 then
      begin
        ErrorMsg('Nepodaøilo se založit novou akci.');
        EXIT;
      end;
    if FTechnicka Then
    begin
      ExecSQLText('UPDATE AKCE SET TECHNICKA=1 WHERE ID='+IntToStr(aID));
      if qrObjektyDRUH.asInteger=1 then
      begin
        ExecSQLText('INSERT INTO AKCE_ZDROJE (AK_ID,ZDROJ_ID) '+
                    '(SELECT '+IntToStr(aID)+', ID FROM ZDROJE WHERE MISTNOST_ID='+IntToStr(FMistnost)+')');
      end;
    end;
    FormIOParams.fpSearchFor := aID;
    FormIOParams.fpTyp := FTyp;
    FormIOParams.fpSearch:=True;
    if frmAkceExec(FormIOParams, True) then
      begin
        if not FTechnicka Then
          btAddAkce.enabled:=false;
        if assigned(Params) then
          begin
            aID:=SelectInt('SELECT ID FROM AKCE WHERE STAV=1 and ID='+IntToStr(aID));
            if aID>0 then
             TdlgZkouskaPlanParams(Params).fpIDAkce:=aID;
          end;
//        MasterRefresh;
        NaplCasovaData;
        grData.Repaint;
        btOk.enabled:=True;
        btCancel.enabled:=False;
        if FTyp=1 then
        begin
          btAddAkce.enabled:=False;
          btAddPozadavek.enabled:=False;
        end;
      end;
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.btAddPozadavekClick(Sender: TObject);
var
  FormIOParams: TfrmPozadavkyParams;
  aID,i:Integer;
begin
  if cbDen.Visible then
  begin
    Inform('STOP');
    EXIT;
  end;

  FormIOParams := TfrmPozadavkyParams.Create(PF_NOTHING, [ofoaInsert]);
  try
    if qrObjektyDRUH.asInteger>1 then
      i:=qrObjektyID.asInteger;
    aID:=NovyPozadavek(FMistnost, FSubjekt, FTOD_ID, FPredmet_ZK,
                       FSelectedDatum, FSelectedDatum+1/24/60,
                       i);
    if aID=0 then
      begin
         EXIT;
      end;
    FormIOParams.fpSearchFor := aID;
    FormIOParams.fpSearch:=True;
(*
    FormIOParams.fpInsert:=True;
    FormIOParams.fpMistnost:=FMistnost;
    FormIOParams.fpSubjekt:=FSubjekt;
    FormIOParams.fpTOD_ID:=FTOD_ID;
    FormIOParams.fpPredmet_ZK:=FPredmet_ZK;
    FormIOParams.fpOD:=FSelectedDatum;
    FormIOParams.fpDO:=FSelectedDatum+1/24/60;
    if qrObjektyDRUH.asInteger>1 then
      FormIOParams.fpZdroj:=qrObjektyID.asInteger;
*)
    if frmPozadavkyExec(FormIOParams, True) then
    begin
        btOk.enabled:=True;
        btCancel.enabled:=False;
    end;
  finally
    FormIOParams.Free;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.UpdateControlStates;
var
 Par:TdlgZkouskaPlanParams;
begin
  btAddAkce.Visible:=False;
  btAddPozadavek.Visible:=False;
  pnCas.Visible:=False;
  edMin.asInteger:=0;
  SetControlsReadOnly([btMistnost, cbMistnost, rbPozadavky],false);
  Case FTyp of
    1:Begin
        Self.caption:='Plánování zkoušky';
        SetControlsReadOnly([btMistnost, cbMistnost],FMistnost>0);
        SetControlsReadOnly([rbPozadavky],true);
        btAddAkce.caption:='Naplán.zkoušku';
        btAddAkce.Visible:=True;
        if FCas>1 then
          begin
            edMin.asInteger:=FCas;
            edMin.MaxValue:=FCas;
            pnCas.Visible:=True;
          end;
      end;
   else
      begin
        if Ftechnicka then
          Self.caption:='Plánování technické akce'
        else
          Self.caption:='Pøehled obsazenosti';

        btAddAkce.caption:='Pøidat akci';
        btAddPozadavek.caption:='Pøidat požadavek';
        btAddAkce.Visible:=True;
        btAddPozadavek.Visible:=True;
        SetControlsReadOnly([rbPozadavky,btAddPozadavek],FTechnicka);
      end;
  end;
end;

// ***************************************************************************
procedure TdlgZkouskaPlan.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if assigned(Params) and (TdlgZkouskaPlanParams(Params).fpIDAkce>0) then
    modalresult:=mrOk;
  inherited;
end;


procedure TdlgZkouskaPlan.FormActivate(Sender: TObject);
begin
  inherited;
  IsShowing:=True;
  if not assigned (dlgCasovyPlanInfo) then
    PrepareForm(TdlgCasovyPlanInfo, dlgCasovyPlanInfo, false); {1}
end;

procedure TdlgZkouskaPlan.FormHide(Sender: TObject);
begin
  inherited;
  IsShowing:=False;
end;

procedure TdlgZkouskaPlan.grDataEnter(Sender: TObject);
begin
  inherited;
  grObjekty.SelectedRows.Clear;
end;

procedure TdlgZkouskaPlan.qrCasovaDataBeforeOpen(DataSet: TDataSet);
begin
  inherited;
//  beep;
end;

end.
