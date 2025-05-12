unit DSubjektyZkouskyInit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, SIIEditEx, ComCtrls, UCLTypes,
  Mask, rxToolEdit;

const
  DSUBJEKTY_ZKOUSKY_INIT_PFO_ID = $00000001;
  DSUBJEKTY_ZKOUSKY_INIT_CHANGE = $00010000;

type
  TdlgSubjektyZkouskyInitParams = class(TFuncParams)
    fpTOD_ID: string;
    fpODBORNOST_ID: string;
    fpSUB_ID: string;
    fpPREDMET_ZK: string;
    fpTOD_NAME: string;
    fpSUB_NAME: string;
    fpPREDMET_NAME: string;
    fpPokus: Integer;
    fpDatum: TDate;
    fpUsp: Double;
    fpOK: Integer;
  public
    procedure CreateInitChild;override;
  end;

  TdlgSubjektyZkouskyInit = class(TacDialogOkStorno)
    Panel1: TPanel;
    lbSubjekt: TLabel;
    lbOdbornost: TLabel;
    lbPredmet: TLabel;
    pnData: TPanel;
    Label1: TLabel;
    edPokus: TSIIEditEx;
    ckUspech: TCheckBox;
    Label2: TLabel;
    edUsp: TSIIEditEx;
    Label3: TLabel;
    edDatum: TDateEdit;
    meText: TMemo;
    lbDuvod: TLabel;
    procedure btOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTOD_ID: string;
    FODBORNOST_ID: string;
    FSUB_ID: string;
    FPREDMET_ZK: string;
    FTOD_NAME: string;
    FSUB_NAME: string;
    FPREDMET_NAME: string;
    FPOKUS: Integer;
    FDATUM: TDate;
    FUSP: Double;
    FOK:Integer;
  public
    { Public declarations }
  end;

var
  dlgSubjektyZkouskyInit: TdlgSubjektyZkouskyInit;

function dlgSubjektyZkouskyInitExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}
uses
  uUCLConsts, Tools, Caches, Utils, SysParam, uStoredProcs, uObjUtils;


function dlgSubjektyZkouskyInitExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektyZkouskyInit, dlgSubjektyZkouskyInit, true);
  try
    with dlgSubjektyZkouskyInit do
    begin
      lbDuvod.Visible:=False;
      meText.Visible:=False;
      Height:=pnData.Top+pnData.Height+80;
      Params := _Params;
      if Assigned(Params) then
        begin
          if Params is TdlgSubjektyZkouskyInitParams then
            With TdlgSubjektyZkouskyInitParams(Params) do
            begin
              FTOD_ID:=fpTOD_ID;
              FODBORNOST_ID:=fpODBORNOST_ID;
              FSUB_ID:=fpSUB_ID;
              FPREDMET_ZK:=fpPREDMET_ZK;
              FTOD_NAME:=fpTOD_NAME;
              FSUB_NAME:=fpSUB_NAME;
              FPREDMET_NAME:=fpPREDMET_NAME;
              FPOKUS:=fpPokus;
              FDATUM:=fpDatum;
              FUSP:=fpUsp;
              FOK:=fpOK;

    if FlagIsSet(DSUBJEKTY_ZKOUSKY_INIT_CHANGE) then
      begin
        lbDuvod.Visible:=True;
        meText.Visible:=True;
        Height:=meText.Top+meText.Height+80;
      end;

    SetControlsReadOnly([edDatum, edPokus], lbDuvod.Visible);



            end;
        end;

      Result := (ShowModal = mrOK);
    end;
  finally
    dlgSubjektyZkouskyInit.Free;
    dlgSubjektyZkouskyInit:=nil;
  end;
end;

{ TdlgSubjektyZkouskyInitParams }
// ***************************************************************************
procedure TdlgSubjektyZkouskyInitParams.CreateInitChild;
begin
  inherited;
  fpTOD_ID:='';
  fpODBORNOST_ID:='';
  fpSUB_ID:='';
  fpPREDMET_ZK:='';
  fpTOD_NAME:='';
  fpSUB_NAME:='';
  fpPREDMET_NAME:='';
  fpPokus:=1;
  fpDatum:=now;
  fpUsp:=0;
  fpOK:=0;
end;

{ TdlgSubjektyZkouskyInit }
// ***************************************************************************
procedure TdlgSubjektyZkouskyInit.FormCreate(Sender: TObject);
begin
  inherited;
  FTOD_ID:='';
  FODBORNOST_ID:='';
  FSUB_ID:='';
  FPREDMET_ZK:='';
  FTOD_NAME:='';
  FSUB_NAME:='';
  FPREDMET_NAME:='';
  FPOKUS:=1;
  FDATUM:=now;
  FUSP:=0;
  lbDuvod.Visible:=False;
  meText.Text:='';
  meText.Visible:=False;
  Height:=pnData.Top+pnData.Height+80;
end;

// ***************************************************************************
procedure TdlgSubjektyZkouskyInit.FormShow(Sender: TObject);
var
 i:Integer;
begin
  inherited;
  btOK.Enabled:=(FTOD_ID<>'') and (FSUB_ID<>'') and (FPREDMET_ZK<>'');
  lbSubjekt.caption:='Subjekt:       '+FSUB_NAME;
  lbOdbornost.caption:='Odbornost:   '+FTOD_NAME;
  lbPredmet.caption:='Pøedmìt:      '+FPREDMET_NAME;

(*
              FTOD_ID:=fpTOD_ID;
              FODBORNOST_ID:=fpODBORNOST_ID;
              FSUB_ID:=fpSUB_ID;
              FPREDMET_ZK:=fpPREDMET_ZK;
*)
  if FPREDMET_ZK<>'' then
    i:=SelectInt('SELECT NVL(SUBSTR(EP.KOD,LENGTH(ET.KOD)+2,3),0)*10 '+
                 '  FROM EXAM_PREDMET EP, EXAM_TYPY_PREDMETU ET '+
                 ' WHERE EP.SUBJECT_SECTION=ET.SUBJECT_SECTION '+
                 '   AND ODBORNOST_ID='+FODBORNOST_ID +
                 '   AND EP.KOD='+Q(FPREDMET_ZK));
  edPokus.asInteger:=i+FPOKUS;
  edDatum.date:=FDATUM;

  ckUspech.Checked:=FOK>0;
  edUsp.asFloat:=FUSP;

end;

// ***************************************************************************
procedure TdlgSubjektyZkouskyInit.btOKClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrNone;
  if ckUspech.checked and (edUsp.asFloat<0) then
    begin
      ErrorMsg('Chyba: Úspìšnost u úspìšné zkoušky nemùže být záporná.');
      abort;
    end;
  if not meText.Visible then
    begin
      if Predmet_Exam_Init(StrToInt(FSUB_ID),StrToInt(FODBORNOST_ID),
                           FTOD_ID, FPREDMET_ZK,
                           byte(ckUspech.checked and (edUsp.asFloat>0)),FPokus,
                           edDatum.Date, edUsp.asFloat) then
        ModalResult := mrOk;
    end
  else
    begin
      if length(trim(meText.text))<3 then
      begin
        ErrorMsg('Dùvod musí mít min. 3 znaky.');
        abort;
      end;
      if Zmenit_Exam_Zkousku(StrToInt(FSUB_ID),StrToInt(FODBORNOST_ID),
                             FTOD_ID, FPREDMET_ZK,
                             byte(ckUspech.checked and (edUsp.asFloat>0)),FPokus,
                             edDatum.Date, edUsp.asFloat,
                             meText.text) then
        ModalResult := mrOk;
    end
end;


end.
