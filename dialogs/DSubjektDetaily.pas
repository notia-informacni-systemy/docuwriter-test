unit DSubjektDetaily;
{
	projekt: 	ISUCL.dpr
	autor:		Pavel Chmelaø
	úèel:           Obsahuje unit obsahující form obsahující informace
                        obsažené v subjektu.
        použití:        Napø. z okna FSubjekty pøi dvojkliku na vyplnìný sloupeèek
                        "provozovatel" v gridu "odbornosti".
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOK, NotiaMagic, ExtCtrls, ADialog, Db, Ora, udmODAC, StdCtrls, Mask,
  DBCtrls, UCLTypes;

const
  DSUBJEKTY_DETAILY_PFI_ID = $0001;

type
  TdlgSubjektDetailyParams = class(TFuncParams)
  public
    fpID: integer;
  end;

  TdlgSubjektDetaily = class(TacDialogOK)
    qrMaster: TOraQuery;
    dsMaster: TOraDataSource;
    bvlLabel: TBevel;
    qrMasterSUBJEKT_NAZEV: TWideStringField;
    lbNazev: TLabel;
    qrMasterID: TIntegerField;
    qrMasterPLATNY: TSmallintField;
    qrMasterTZO_ID: TIntegerField;
    qrMasterZAMESTNANEC: TSmallintField;
    qrMasterTITUL_PRED: TWideStringField;
    qrMasterJMENO: TWideStringField;
    qrMasterPRIJMENI: TWideStringField;
    qrMasterTITUL_ZA: TWideStringField;
    qrMasterRC: TWideStringField;
    qrMasterDAT_NAROZENI: TDateTimeField;
    qrMasterMISTO_NAROZENI: TWideStringField;
    qrMasterST_KOD: TWideStringField;
    qrMasterPOHLAVI: TSmallintField;
    qrMasterNAZEV: TWideStringField;
    qrMasterREJCIS: TSmallintField;
    qrMasterULICE: TWideStringField;
    qrMasterMESTO: TWideStringField;
    qrMasterPSC: TWideStringField;
    qrMasterEMAIL: TWideStringField;
    qrMasterTEL: TWideStringField;
    qrMasterMOBIL: TWideStringField;
    qrMasterFAX: TWideStringField;
    qrMasterDIC: TWideStringField;
    qrMasterBANKA: TWideStringField;
    qrMasterBUCET: TWideStringField;
    qrMasterNASTUP: TDateTimeField;
    qrMasterPROPUSTENI: TDateTimeField;
    qrMasterPROP_DUVOD: TWideStringField;
    qrMasterPILOT: TSmallintField;
    qrMasterTECHNIK: TSmallintField;
    qrMasterSTEVARD: TSmallintField;
    qrMasterZAK: TSmallintField;
    qrMasterARCHIVOVAL: TWideStringField;
    qrMasterARCHIVOVAN: TDateTimeField;
    qrMasterZAPSAL: TWideStringField;
    qrMasterZAPSANO: TDateTimeField;
    qrMasterODD_ID: TIntegerField;
    qrMasterDOC_ID: TIntegerField;
    qrMasterAUTOGEN: TSmallintField;
    qrMasterUSER_ID: TIntegerField;
    qrMasterUSERNAME: TWideStringField;
    qrMasterSUB_ID_BOSS: TIntegerField;
    qrMasterSKUPINA: TSmallintField;
    qrMasterDATUM_ZAPISU_LR: TDateTimeField;
    qrMasterICO: TWideStringField;
    qrMasterREJCIS_P: TSmallintField;
    qrMasterREJCIS_T: TSmallintField;
    qrMasterPROVOZOVATEL: TSmallintField;
    qrMasterVYROBCE: TSmallintField;
    qrMasterVLASTNIK: TSmallintField;
    qrMasterCISLO_PRUKAZU: TWideStringField;
    lbUlice: TLabel;
    lbMesto: TLabel;
    lbPSC: TLabel;
    lbTelefon: TLabel;
    lbFax: TLabel;
    lbMobil: TLabel;
    lbEmail: TLabel;
    edUlice: TDBEdit;
    edMesto: TDBEdit;
    edPSC: TDBEdit;
    edTel: TDBEdit;
    edFax: TDBEdit;
    edMobil: TDBEdit;
    edEmail: TDBEdit;
    qrMasterPOZNAMKA: TWideStringField;
    qrMasterUDALOST: TWideStringField;
    qrMasterUZNANY: TSmallintField;
    qrMasterSUB_ID_PREDCHUDCE: TIntegerField;
    qrMasterNABIZET_PRO_PPP: TSmallintField;
    qrMasterUA_STAV: TSmallintField;
    qrMasterLETECKA_SKOLA: TSmallintField;
    qrMasterUDRZBA_JAR: TSmallintField;
    qrMasterUDRZBA_NARODNI: TSmallintField;
    qrMasterNAZEV_K_ZOBRAZENI: TWideStringField;
    qrMasterZASTAVNI_VERITEL: TSmallintField;
    qrMasterULICE_POD: TWideStringField;
    qrMasterMESTO_POD: TWideStringField;
    qrMasterPSC_POD: TWideStringField;
    qrMasterSTAT_POD: TWideStringField;
    qrMasterZKRATKA: TWideStringField;
    qrMasterICO_OR: TWideStringField;
    qrMasterSIDLO_OR: TWideStringField;
    qrMasterRODNE_PRIJM: TWideStringField;
    qrMasterSTAT: TWideStringField;
    qrMasterLETADLOVA_ADRESA: TSmallintField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrMasterBeforeOpen(DataSet: TDataSet);
    procedure qrMasterAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSubjektDetaily: TdlgSubjektDetaily;

function dlgSubjektDetailyExec(_Params: TFuncParams): boolean;
  
implementation

{$R *.DFM}

uses Tools;

{ Exec }

function dlgSubjektDetailyExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSubjektDetaily, dlgSubjektDetaily, true); {1}

  with dlgSubjektDetaily do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

{ TdlgSubjektDetaily }

procedure TdlgSubjektDetaily.FormShow(Sender: TObject);
begin
  inherited;
  qrMaster.Open;
end;

procedure TdlgSubjektDetaily.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  qrMaster.Close;
end;

procedure TdlgSubjektDetaily.qrMasterBeforeOpen(DataSet: TDataSet);
begin
  inherited;
  if Assigned(Params) then
  with TdlgSubjektDetailyParams(Params) do
  begin
    qrMaster.ParamByName('ID').AsInteger := fpID;
  end;
end;

procedure TdlgSubjektDetaily.qrMasterAfterScroll(DataSet: TDataSet);
begin
  lbNazev.Caption := qrMasterSUBJEKT_NAZEV.AsString;
end;

end.
