unit DWebRosZadosti;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin, Data.DB, DBAccess, Ora,
  MemDS;

type
  TdlgWebRosZadosti = class(TacDialogOkStorno)
    pnData: TPanel;
    pnTBLeftPart: TPanel;
    ToolBar1: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    Panel2: TPanel;
    qrMaster: TOraQuery;
    dsMaster: TOraDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgWebRosZadosti: TdlgWebRosZadosti;

implementation

{$R *.dfm}

end.
