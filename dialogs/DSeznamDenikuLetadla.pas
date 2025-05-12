unit DSeznamDenikuLetadla;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes, Grids,
  NDBGrids, MSGrid, Db, Ora, udmODAC, DBAccess, MemDS, NGrids;

const
  DSEZNAM_DENIKU_LETADLA_PFO_ID     = $0001;

type
  TdlgSeznamDenikuLetadlaParams = class(TfuncParams)
    fpID: integer;
  end;

type
  TdlgSeznamDenikuLetadla = class(TacDialogOkStorno)
    grMaster: TMSDBGrid;
    qrMaster: TOraQuery;
    dsMaster: TOraDataSource;
    qrMasterPOZN_ZNACKA: TIntegerField;
    qrMasterTYP_LETADLA: TIntegerField;
    qrMasterPAX: TSmallintField;
    qrMasterVOLACI_ZNACKA: TWideStringField;
    qrMasterDATUM: TDateTimeField;
    qrMasterPIC: TIntegerField;
    qrMasterF_O: TIntegerField;
    qrMasterINSPEKTOR_1: TIntegerField;
    qrMasterINSPEKTOR_2: TIntegerField;
    qrMasterINSPEKTOR_3: TIntegerField;
    qrMasterTUL_1: TIntegerField;
    qrMasterTUL_2: TIntegerField;
    qrMasterID_LETU: TIntegerField;
    qrMasterID_LET_UCL: TIntegerField;
    qrMasterZARIZENI: TWideStringField;
    qrMasterCISLO_STRANKY: TFloatField;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure qrMasterTYP_LETADLAGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure grMasterDblClick(Sender: TObject);
    procedure qrMasterPICGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrMasterID_LET_UCLGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    { Private declarations }
  protected
    procedure FillParams; override;
  public
    { Public declarations }
  end;

var
  dlgSeznamDenikuLetadla: TdlgSeznamDenikuLetadla;

function dlgSeznamDenikuLetadlaExec(_Params: TFuncParams): boolean;
  
implementation

{$R *.DFM}

uses Tools, uObjUtils, Caches;

function dlgSeznamDenikuLetadlaExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgSeznamDenikuLetadla, dlgSeznamDenikuLetadla, true); {1}

  with dlgSeznamDenikuLetadla do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

// ..........................................................................
procedure TdlgSeznamDenikuLetadla.FormShow(Sender: TObject);
begin
  inherited;
  qrMaster.Open;
end;

// ..........................................................................
procedure TdlgSeznamDenikuLetadla.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  qrMaster.Close;
end;

// ..........................................................................
procedure TdlgSeznamDenikuLetadla.FillParams;
begin
  inherited;
  if Assigned(Params) then
  with TdlgSeznamDenikuLetadlaParams(Params) do
  begin
    if FlagIsSet(DSEZNAM_DENIKU_LETADLA_PFO_ID) then
      fpID := qrMasterID_LETU.AsInteger;
  end;
end;

// ..........................................................................
procedure TdlgSeznamDenikuLetadla.qrMasterTYP_LETADLAGetText(
  Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
      Text := CachedTYPY_LETADELKratkyNazev( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgSeznamDenikuLetadla.grMasterDblClick(Sender: TObject);
begin
  inherited;
  btOK.Click;
end;

// ..........................................................................
procedure TdlgSeznamDenikuLetadla.qrMasterPICGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedKODY_JMEN( Sender.AsInteger );
end;

// ..........................................................................
procedure TdlgSeznamDenikuLetadla.qrMasterID_LET_UCLGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := CachedLETADLA(CachedLETALA_UCL_POZN_ZNACKA( Sender.AsInteger ));
end;

end.
