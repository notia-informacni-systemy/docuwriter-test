unit DSestavy_korekce;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialog, NotiaMagic, ExtCtrls, StdCtrls, EditEx;

type
  TdlgSestavy_korekce = class(TacDialog)
    edPocet: TEditEx;
    lbPocet: TLabel;
    btOK: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSestavy_korekce: TdlgSestavy_korekce;

implementation

{$R *.DFM}

end.
