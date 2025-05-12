unit DRosPolZam;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADialogOkStorno, NotiaMagic,
  Vcl.StdCtrls, Vcl.ExtCtrls, UCLTypes, Vcl.Mask, rxToolEdit;

// TdlgRosPolZamParams
{ ------------------------------------------------------------------------- }
type
  TdlgRosPolZamParams = class(TMultiselectFuncParams)
  public
    fpID: Integer;
    fpTyp: string;
    fpZam: string;
    fpOd: TDate;
    fpDo: TDate;
    fpFunkce: string;
    fpReadOnly: boolean;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _BeforeOKEvent: TBeforeOKEvent = nil);
  end;

// TdlgRosPolZam
type
  TdlgRosPolZam = class(TacDialogOkStorno)
    pnTyp: TPanel;
    rbZam: TRadioButton;
    rbStudium: TRadioButton;
    rbOstatni: TRadioButton;
    edZam: TEdit;
    edFunkce: TEdit;
    lbZam: TLabel;
    lbFunkce: TLabel;
    edDatumOd: TDateEdit;
    edDatumDo: TDateEdit;
    Label4: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
    procedure rbZamClick(Sender: TObject);
  private
    procedure FillParams; override;
  public
    procedure clearForm;
  end;

var
  dlgRosPolZam: TdlgRosPolZam;

function dlgRosPolZamExec(_Params: TFuncParams): boolean;

implementation

{$R *.dfm}
uses
  Tools, Utils, NParam;

function dlgRosPolZamExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgRosPolZam, dlgRosPolZam, true);
  with dlgRosPolZam do
  begin
    borderStyle:=bsSizeable;
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;

{ TdlgRosPolZamParams }
// ..........................................................................
constructor TdlgRosPolZamParams.Create(const _IOFlags: TFormParamsFlags;
  const _ActionFlags: TOnFormOpenActionFlags;
  _OnDataChanged: TFuncParamsDataChangedEvent;
  _BeforeOKEvent: TBeforeOKEvent);
begin
  fpReadOnly:=False;
  inherited Create(_IOFlags,_ActionFlags, _OnDataChanged,_BeforeOKEvent);
end;

{ TdlgRosPolZam }
// ..........................................................................
procedure TdlgRosPolZam.FormCreate(Sender: TObject);
begin
  inherited;
//
end;

// ..........................................................................
procedure TdlgRosPolZam.FormShow(Sender: TObject);
begin
  inherited;
  clearForm;
  if Assigned(Params) then
    with TdlgRosPolZamParams(Params) do
    begin
      pnTyp.enabled:=fpID=0;
      rbStudium.Checked:=fpTyp=rbStudium.caption;
      rbOstatni.Checked:=fpTyp=rbStudium.caption;
      edZam.text:=fpZam;
      eddatumOd.date:=fpOd;
      eddatumDo.date:=fpDo;
      edFunkce.text:=fpFunkce;
    end;
  if not pnTyp.enabled then
    pnTyp.color:=clBtnShadow;
end;

// ..........................................................................
procedure TdlgRosPolZam.FillParams;
begin
  inherited;
  if Assigned(Params) then
    with TdlgRosPolZamParams(Params) do
    begin
      if rbStudium.Checked then
        fpTyp:=rbStudium.caption
      else if rbOstatni.Checked then
        fpTyp:=rbOstatni.caption
      else
        fpTyp:=rbZam.caption;
      fpZam:=StringReplace(edZam.text,'''','"',[rfReplaceAll, rfIgnoreCase]);
      fpOd:= eddatumOd.date;
      fpDo:= eddatumDo.date;
      fpFunkce:=StringReplace(edFunkce.text,'''','"',[rfReplaceAll, rfIgnoreCase]);
    end;
end;

// ..........................................................................
procedure TdlgRosPolZam.btCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ..........................................................................
procedure TdlgRosPolZam.btOKClick(Sender: TObject);
begin
  inherited;
  modalresult:=mrNone;
  FillParams;
  modalresult:=mrOk;
end;

// ..........................................................................
procedure TdlgRosPolZam.clearForm;
begin
  pnTyp.enabled:=true;
  pnTyp.color:=clBtnFace;
  rbZam.checked:=true;
  edZam.text:='';
  eddatumOd.date:=date;
  eddatumDo.date:=date;
  edFunkce.text:='';
end;

// ..........................................................................
procedure TdlgRosPolZam.rbZamClick(Sender: TObject);
begin
  if rbStudium.checked then
  begin
    lbZam.caption:='Instituce:';
  end
  else if rbOstatni.checked then
  begin
    lbZam.caption:='Èinnost:';
  end
  else
  begin
    lbZam.caption:='Zamìstnavatel:';
  end;
end;

end.
