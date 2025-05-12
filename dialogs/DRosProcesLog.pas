unit DRosProcesLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, UCLTypes;

type
  TdlgRosProcesLog = class(TacDialogOkStorno)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgRosProcesLog: TdlgRosProcesLog;

implementation

{$R *.dfm}
uses
  Tools, Utils, NParam;

end.
