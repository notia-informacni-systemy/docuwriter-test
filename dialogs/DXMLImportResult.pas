unit DXMLImportResult;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UCLTypes, ADialogOk, NotiaMagic, StdCtrls, ExtCtrls;

const
  DXML_IMPORT_RESULT_INTEGRITADB    = $00000001; // 0000,0000,0000,0000,0000,0000,0000,0001

// TdlgXMLImportResultParams
{ ------------------------------------------------------------------------- }
type
  TdlgXMLImportResultParams = class(TFuncParams)
  public
    fpCapt:string;
    fpItems:TStringList;
    constructor Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _OnBeforeOKEvent: TBeforeOKEvent = nil);
    destructor destroy; override;
  end;

// TdlgXMLImportResult
{ ------------------------------------------------------------------------- }
type
  TdlgXMLImportResult = class(TacDialogOk)
    meResult: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgXMLImportResult: TdlgXMLImportResult;

function dlgXMLImportResultExec(_Params: TFuncParams): boolean;

implementation

{$R *.DFM}

uses
  Tools, Utils;

function dlgXMLImportResultExec(_Params: TFuncParams): boolean;
begin
  PrepareForm(TdlgXMLImportResult, dlgXMLImportResult, true);
  with dlgXMLImportResult do
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end;
end;


// TdlgXMLImportResultParams
{ ------------------------------------------------------------------------- }
constructor TdlgXMLImportResultParams.Create(const _IOFlags: TFormParamsFlags; const _ActionFlags: TOnFormOpenActionFlags = []; _OnDataChanged: TFuncParamsDataChangedEvent = nil; _OnBeforeOKEvent: TBeforeOKEvent = nil);
begin
  inherited;
  fpItems:=TStringList.Create;
end;

destructor TdlgXMLImportResultParams.destroy;
begin
  fpItems.Free;
  inherited;
end;


// TdlgXMLImportResult
{ ------------------------------------------------------------------------- }
procedure TdlgXMLImportResult.FormShow(Sender: TObject);
begin
  inherited;
  if Assigned(Params) then
    with TdlgXMLImportResultParams(Params) do
    begin
      if FlagIsSet(DXML_IMPORT_RESULT_INTEGRITADB) then
        begin
          caption:=fpCapt;
          meResult.Lines.assign(fpItems);
        end;
    end;
end;

end.
