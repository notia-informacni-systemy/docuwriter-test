unit dRejcis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, Db, Ora, udmODAC, NotiaMagic, StdCtrls, ExtCtrls, UCLTypes,
  Mask, DBCtrls, DBAccess, MemDS;

const
  DREJCIS_PFI_ID = $0001;

type
  TdlgRejcisParams = class(TFuncParams)
  public
    fpID: integer;
  end;

  TdlgRejcis = class(TacDialogOkStorno)
    qrMaster: TOraQuery;
    qrMasterPROPUSTENI: TDateTimeField;
    qrMasterID: TIntegerField;
    qrMasterPRIJMENI: TWideStringField;
    qrMasterNAZEV: TWideStringField;
    qrMasterJMENO: TWideStringField;
    qrMasterREJCIS_P: TSmallintField;
    qrMasterREJCIS_T: TSmallintField;
    qrMasterREJCIS: TIntegerField;
    dsMaster: TOraDataSource;
    lbJmeno: TLabel;
    lbPrijmeni: TLabel;
    edPrijmeni: TDBEdit;
    edJmeno: TDBEdit;
    lbRejstrikoveCislo: TLabel;
    edRejstrikoveCislo: TDBEdit;
    Label1: TLabel;
    edRejstrikoveCisloPilota: TDBEdit;
    edRejstrikoveCisloTechnika: TDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    edNazev: TDBEdit;
    Image1: TImage;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    edID: TDBEdit;
    procedure btOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgRejcis: TdlgRejcis;

function dlgRejcisExec(_Params: TFuncParams): boolean;

implementation

uses Tools;

{$R *.DFM}

{ Exec }

function dlgRejcisExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgRejcis, dlgRejcis, true); {1}

  with dlgRejcis do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

procedure TdlgRejcis.btOKClick(Sender: TObject);
begin
  qrMaster.Post;

  inherited;
end;

procedure TdlgRejcis.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  qrMaster.Close;
end;

procedure TdlgRejcis.FormShow(Sender: TObject);
begin
  inherited;

  if Assigned(Params) then
    with TdlgRejcisParams(Params) do
    begin
      qrMaster.ParamByName('ID').AsInteger := fpID;
    end;

  qrMaster.Open;
  qrMaster.Edit;
end;

procedure TdlgRejcis.FormCreate(Sender: TObject);
begin
  inherited;
  Image1.Picture.Icon.Handle := LoadIcon(0, IDI_WARNING);
end;

end.
