unit dDocPrukazCreate;
{
	projekt: 	ISUCL.dpr
	unit:		dDocPrukazCreate.pas
	autor:		Jan Tomsa
	úèel:           Tento unit obsahuje form dlgDocPrukazCreateParams
                        dlgDocPrukazCreateParams slouží k naètení dat pro volání
                        stored procedury doc_prukaz_create.
	DB tabulky:     TYPY_ODBORNOSTI
	DB funkce:      (žádné)
	proc&func:      dlgDocPrukazCreateExec( _Params )
        historie zmìn:  Tomy (HT) 11.9.2001 - vytvoøeno
                        24.10.2001 <PCH> - nove volani
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADialogOkStorno, StdCtrls, Mask, rxToolEdit, NotiaMagic, ExtCtrls, UCLTypes,
  EditEx;

type
  TdlgDocPrukazCreateParams = class( TFuncParams )
  public
    fpPlatnostOd: TDateTime;
    fpPlatnostDo: TDateTime;
    fpPoznamka: String;
// TG    fpTypOdbornosti: Integer;
    fpTypOdbornosti: String;
    fpCisloPrukazu: String;
    fpPoplatekID: Integer;
  end;

  TdlgDocPrukazCreate = class(TacDialogOkStorno)
    lbPlatnostOd: TLabel;
    lbPlatnostDo: TLabel;
    edPlatnostOd: TDateEdit;
    edPlatnostDo: TDateEdit;
    lbPoznamka: TLabel;
    edPoznamka: TEdit;
    btTypOdbornosti: TButton;
    cbTypOdbornosti: TComboBox;
    lbCisloPrukazu: TLabel;
    edCisloPrukazu: TEdit;
    btPoplatek: TButton;
    edPoplatek: TEditEx;
    procedure edJCChange(Sender: TObject);
    procedure cbTypOdbornostiChange(Sender: TObject);
    procedure edCisloPrukazuChange(Sender: TObject);
    procedure edPlatnostOdExit(Sender: TObject);
    procedure edPlatnostDoExit(Sender: TObject);
    procedure btTypOdbornostiClick(Sender: TObject);
    procedure btPoplatekClick(Sender: TObject);
    procedure FormShow(Sender: TObject); // + <PCH> 24.10.2001
  private
    function CheckOK: Boolean;
    procedure InitTypOdbornostiCombo;
  protected
    procedure FillParams; override; // + <PCH> 24.10.2001
  public
//    function ExecModal( _Params: TdlgDocPrukazCreateParams ): Boolean; // - <PCH> 24.10.2001
  end;

var
  dlgDocPrukazCreate: TdlgDocPrukazCreate;

//function dlgDocPrukazCreateExecModal( _Params: TdlgDocPrukazCreateParams ): Boolean; // - <PCH> 24.10.2001
function dlgDocPrukazCreateExec(_Params: TFuncParams): boolean; // + <PCH> 24.10.2001

implementation

{$R *.DFM}

uses
  Tools, Caches, Queries, Utils, fTypyOdbornosti;

(*
function dlgDocPrukazCreateExecModal( _Params: TdlgDocPrukazCreateParams ): Boolean;
begin
  Result := False;
  PrepareForm( TdlgDocPrukazCreate, dlgDocPrukazCreate );
  Result := dlgDocPrukazCreate.ExecModal( _Params );
end;
*)

{ Exec }

function dlgDocPrukazCreateExec(_Params: TFuncParams): boolean; // + <PCH> 24.10.2001
begin
  PrepareForm(TdlgDocPrukazCreate, dlgDocPrukazCreate, true); {1}

  with dlgDocPrukazCreate do {2}
  begin
    Params := _Params;
    Result := (ShowModal = mrOK);
  end; {with}
end;

{ TdlgDocPrukazCreate }

function TdlgDocPrukazCreate.CheckOK: Boolean;
begin
  Result := (cbTypOdbornosti.ItemIndex <> -1) and
            (edCisloPrukazu.Text <> '') and
            (edPlatnostOd.Text <> '  .  .    ') and
            (edPlatnostDo.Text <> '  .  .    ');
end;
(*
function TdlgDocPrukazCreate.ExecModal(
  _Params: TdlgDocPrukazCreateParams): Boolean;
begin
  Result := False;
  Params := _Params;
  // inicializace okna
  InitTypOdbornostiCombo;
  cbTypOdbornosti.ItemIndex :=
    cbTypOdbornosti.Items.IndexOf( CachedTYPY_ODBORNOSTI(TdlgDocPrukazCreateParams(Params).fpTypOdbornosti) );
  edCisloPrukazu.Text := '';
  edPlatnostOd.Date := TdlgDocPrukazCreateParams(Params).fpPlatnostOd;
  edPlatnostDo.Date := TdlgDocPrukazCreateParams(Params).fpPlatnostDo;
  edPoznamka.Text := '';
//  edPoplatek.asInteger := Params.fpPoplatekID; // - Tomy (HT) 11.9.2001 - obnovit až se zavedou flagy
  btOK.Enabled := CheckOK;
  // zobrazení
  Result := (ShowModal = mrOK);
  // naplnìní výstupních parametrù
  TdlgDocPrukazCreateParams(Params).fpPlatnostOd := edPlatnostOd.Date;
  TdlgDocPrukazCreateParams(Params).fpPlatnostDo := edPlatnostDo.Date;
  TdlgDocPrukazCreateParams(Params).fpPoznamka  := edPoznamka.Text;
  TdlgDocPrukazCreateParams(Params).fpTypOdbornosti := CachedTYPY_ODBORNOSTInum( cbTypOdbornosti.Text );
  TdlgDocPrukazCreateParams(Params).fpCisloPrukazu := edCisloPrukazu.Text;
//  Params.fpPoplatekID := edPoplatek.asInteger; // - Tomy (HT) 12.9.2001 - obnovit až se zavedou flagy
end;
*) // - <PCH> 24.10.2001
procedure TdlgDocPrukazCreate.edJCChange(Sender: TObject);
begin
  btOK.Enabled := CheckOK;
end;

procedure TdlgDocPrukazCreate.cbTypOdbornostiChange(Sender: TObject);
//var pomID: Integer;
var pomID: String;
begin
  pomID:=CachedTYPY_ODBORNOSTInum(cbTypOdbornosti.Text);
  edCisloPrukazu.Text:= SelectStr('SELECT PRUKAZ_KOD FROM TYPY_ODBORNOSTI WHERE ID ='+
                                   Q(pomID) );
  btOK.Enabled := CheckOK;
end;

procedure TdlgDocPrukazCreate.edCisloPrukazuChange(Sender: TObject);
begin
  btOK.Enabled := CheckOK;
end;

procedure TdlgDocPrukazCreate.edPlatnostOdExit(Sender: TObject);
begin
  btOK.Enabled := CheckOK;
end;

procedure TdlgDocPrukazCreate.edPlatnostDoExit(Sender: TObject);
begin
  btOK.Enabled := CheckOK;
end;

procedure TdlgDocPrukazCreate.btTypOdbornostiClick(Sender: TObject);
var
  FormIOParams: TfrmTypyOdbornostiParams;
begin
  FormIOParams := TfrmTypyOdbornostiParams.Create(FTYPYODBORNOSTI_PFO_ID or FTYPYODBORNOSTI_PFO_PRUKAZ_KOD, [], InitTypOdbornostiCombo);
  try
    FormIOParams.fpSearch :=  cbTypOdbornosti.Text <> '' ;
    FormIOParams.fpSearchFor := CachedTYPY_ODBORNOSTInum(cbTypOdbornosti.Text);

    if frmTypyOdbornostiExec(FormIOParams, true) then
    begin
      cbTypOdbornosti.ItemIndex :=
        cbTypOdbornosti.Items.IndexOf( CachedTYPY_ODBORNOSTI(FormIOParams.fpID));
      edCisloPrukazu.Text:= FormIOParams.fpPRUKAZ_KOD;
    end;
  finally
    FormIOParams.Free;
  end;
end;

procedure TdlgDocPrukazCreate.btPoplatekClick(Sender: TObject);
begin
  // + Tomy (HT) 11.9.2001 - 17:41
end;

procedure TdlgDocPrukazCreate.InitTypOdbornostiCombo;
begin
  InitComboSQL( cbTypOdbornosti, QS_TypyOdbornosti_Nazev );
end;

procedure TdlgDocPrukazCreate.FormShow(Sender: TObject);
begin
  InitTypOdbornostiCombo;
  cbTypOdbornosti.ItemIndex :=
    cbTypOdbornosti.Items.IndexOf( CachedTYPY_ODBORNOSTI(TdlgDocPrukazCreateParams(Params).fpTypOdbornosti) );
  edCisloPrukazu.Text := '';
  edPlatnostOd.Date := TdlgDocPrukazCreateParams(Params).fpPlatnostOd;
  edPlatnostDo.Date := TdlgDocPrukazCreateParams(Params).fpPlatnostDo;
  edPoznamka.Text := '';
//  edPoplatek.asInteger := Params.fpPoplatekID; // - Tomy (HT) 11.9.2001 - obnovit až se zavedou flagy
  btOK.Enabled := CheckOK;

  inherited;
end;

procedure TdlgDocPrukazCreate.FillParams;
begin
  inherited;
  with TdlgDocPrukazCreateParams(Params) do
  begin
    fpPlatnostOd := edPlatnostOd.Date;
    fpPlatnostDo := edPlatnostDo.Date;
    fpPoznamka  := edPoznamka.Text;
    fpTypOdbornosti := CachedTYPY_ODBORNOSTInum( cbTypOdbornosti.Text );
    fpCisloPrukazu := edCisloPrukazu.Text;
  end;
end;

end.
