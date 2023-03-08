unit fCadFornecedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, RxToolEdit, RxDBCtrl, Vcl.Mask, dmDados, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Buttons;

type
  TfrmCadFornecedor = class(TForm)
    pgCadastro: TPageControl;
    tsConsulta: TTabSheet;
    tsDetalhe: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edFiltroRazaoSocial: TEdit;
    btPesquisar: TButton;
    DBGrid1: TDBGrid;
    pnlNavegacao: TPanel;
    pnlDados: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    dbNOME_FANTASIA: TDBEdit;
    dbCNPJ: TDBEdit;
    qryFornecedores: TFDQuery;
    dsFornecedores: TDataSource;
    qryFornecedoresNOME_FANTASIA: TStringField;
    qryFornecedoresCNPJ: TStringField;
    qryFornecedoresATIVO: TStringField;
    Label5: TLabel;
    cbAtivo: TComboBox;
    qryFornecedoresCODIGO: TIntegerField;
    btFirst: TBitBtn;
    btPrior: TBitBtn;
    btNew: TBitBtn;
    btEdit: TBitBtn;
    btSave: TBitBtn;
    btCancel: TBitBtn;
    btDelete: TBitBtn;
    btNext: TBitBtn;
    btLast: TBitBtn;
    edFiltroCNPJ: TEdit;
    Label6: TLabel;
    Label4: TLabel;
    dbRAZAO_SOCIAL: TDBEdit;
    qryFornecedoresRAZAO_SOCIAL: TStringField;
    edFiltroNomeFantasia: TEdit;
    Label7: TLabel;
    procedure qryFornecedoresATIVOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure btPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryFornecedoresNewRecord(DataSet: TDataSet);
    procedure dbCNPJKeyPress(Sender: TObject; var Key: Char);
    procedure btFirstClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btLastClick(Sender: TObject);
    procedure qryFornecedoresBeforePost(DataSet: TDataSet);
    procedure edFiltroCNPJKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure InicializaConsulta;
    procedure SetaSituacao;
    function  Valida: Boolean;
    function  ValidaMesmoCNPJ: Boolean;
    function  ProximoCodigo: integer;
    procedure StatusTela;
  public
    { Public declarations }
  end;

var
  frmCadFornecedor: TfrmCadFornecedor;

implementation

{$R *.dfm}

procedure TfrmCadFornecedor.btCancelClick(Sender: TObject);
begin
  qryFornecedores.Cancel;
  StatusTela;
end;

procedure TfrmCadFornecedor.btDeleteClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja excluir o cliente?', 'Cadastro de Clientes', MB_YESNO + MB_ICONQUESTION) = IDYES) then
  begin
    qryFornecedores.Delete;
    StatusTela;
    SetaSituacao;
  end;
end;

procedure TfrmCadFornecedor.btEditClick(Sender: TObject);
begin
  qryFornecedores.Edit;
  StatusTela;
  if (dbRAZAO_SOCIAL.CanFocus) then
    dbRAZAO_SOCIAL.SetFocus;
end;

procedure TfrmCadFornecedor.btFirstClick(Sender: TObject);
begin
  qryFornecedores.First;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadFornecedor.btLastClick(Sender: TObject);
begin
  qryFornecedores.Last;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadFornecedor.btNewClick(Sender: TObject);
begin
  qryFornecedores.Append;
  StatusTela;
  if (dbRAZAO_SOCIAL.CanFocus) then
    dbRAZAO_SOCIAL.SetFocus;
end;

procedure TfrmCadFornecedor.btNextClick(Sender: TObject);
begin
  qryFornecedores.Next;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadFornecedor.btPesquisarClick(Sender: TObject);
begin
  InicializaConsulta;
end;

procedure TfrmCadFornecedor.btPriorClick(Sender: TObject);
begin
  qryFornecedores.Prior;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadFornecedor.btSaveClick(Sender: TObject);
begin
  if not Valida then
    Exit;

  qryFornecedores.Post;
  StatusTela;
end;

procedure TfrmCadFornecedor.dbCNPJKeyPress(Sender: TObject; var Key: Char);
begin
  if (not CharInSet(Key, ['0'..'9'])) and (Key <> #8) and (Key <> #3) and (Key <> #22) then
    Key :=#0;
end;

procedure TfrmCadFornecedor.edFiltroCNPJKeyPress(Sender: TObject; var Key: Char);
begin
  if (not CharInSet(Key, ['0'..'9'])) and (Key <> #8) and (Key <> #3) and (Key <> #22) then
    Key :=#0;
end;

procedure TfrmCadFornecedor.FormShow(Sender: TObject);
begin
  InicializaConsulta;
  SetaSituacao;
  pgCadastro.ActivePage := tsDetalhe;
  StatusTela;
end;

procedure TfrmCadFornecedor.InicializaConsulta;
var
  Sql,
  ParamRazaoSocial,
  ParamNomeFantasia,
  ParamCnpj: string;
begin
  Sql               := '';
  ParamRazaoSocial  := '';
  ParamNomeFantasia := '';
  ParamCnpj         := '';

  // Define o parametro referente ao CPF
  if edFiltroCNPJ.Text <> '' then
    ParamCnpj :=' WHERE CNPJ = '+QuotedStr(edFiltroCNPJ.Text)+' ';

  // Define o parametro referente ao Nome Fantasia
  if (Trim(edFiltroNomeFantasia.Text) <> '') then
  begin
    if (ParamCnpj = '') then
      ParamNomeFantasia :=' WHERE (NOME_FANTASIA LIKE ''%'+edFiltroNomeFantasia.Text+'%'') '
    else
      ParamNomeFantasia :=' AND (NOME_FANTASIA LIKE ''%'+edFiltroNomeFantasia.Text+'%'') ';
  end;

  // Define o parametro referente a Razão Sccial
  if (Trim(edFiltroRazaoSocial.Text) <> '') then
  begin
    if (ParamCnpj = '') then
      ParamRazaoSocial :=' WHERE (RAZAO_SOCIAL LIKE ''%'+edFiltroRazaoSocial.Text+'%'') '
    else
      ParamRazaoSocial :=' AND (RAZAO_SOCIAL LIKE ''%'+edFiltroRazaoSocial.Text+'%'') ';
  end;

  Sql := ' SELECT CODIGO, NOME_FANTASIA, RAZAO_SOCIAL, CNPJ, ATIVO ' +
         ' FROM FORNECEDORES '+
           ParamNomeFantasia+
           ParamRazaoSocial+
           ParamCnpj+
         ' ORDER BY NOME_FANTASIA ';

  qryFornecedores.Close;
  qryFornecedores.Sql.Clear;
  qryFornecedores.Sql.Text := Sql;
  qryFornecedores.Open;
end;

function TfrmCadFornecedor.ProximoCodigo: integer;
begin
  dtmDados.qryConsulta.Close;
  dtmDados.qryConsulta.SQL.Clear;
  dtmDados.qryConsulta.SQL.Text := 'SELECT MAX(CODIGO) AS CODIGO FROM FORNECEDORES';
  dtmDados.qryConsulta.Open;

  Result := dtmDados.qryConsulta.FieldByName('CODIGO').AsInteger + 1;
end;

procedure TfrmCadFornecedor.qryFornecedoresATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsString = 'S' then
    Text := 'Sim'
  else if Sender.AsString = 'N' then
    Text := 'Não'
  else
    Text := '';
end;

procedure TfrmCadFornecedor.qryFornecedoresBeforePost(DataSet: TDataSet);
begin
  case cbAtivo.ItemIndex of
    0: qryFornecedores.FieldByName('ATIVO').AsString  := 'S';
    1: qryFornecedores.FieldByName('ATIVO').AsString  := 'N';
  end;
end;

procedure TfrmCadFornecedor.qryFornecedoresNewRecord(DataSet: TDataSet);
begin
  qryFornecedores.FieldByName('CODIGO').AsInteger:= ProximoCodigo;
  qryFornecedores.FieldByName('ATIVO').AsString  := 'S';
  SetaSituacao;
end;

procedure TfrmCadFornecedor.SetaSituacao;
begin
  if qryFornecedoresATIVO.AsString = 'S' then
    cbAtivo.ItemIndex := 0
  else
    cbAtivo.ItemIndex := 1;
end;

procedure TfrmCadFornecedor.StatusTela;
begin
  btFirst.Enabled := (not (qryFornecedores.State in [dsInsert, dsEdit])) and (not qryFornecedores.IsEmpty);
  btPrior.Enabled := (not (qryFornecedores.State in [dsInsert, dsEdit])) and (not qryFornecedores.IsEmpty);
  btNext.Enabled  := (not (qryFornecedores.State in [dsInsert, dsEdit])) and (not qryFornecedores.IsEmpty);
  btLast.Enabled  := (not (qryFornecedores.State in [dsInsert, dsEdit])) and (not qryFornecedores.IsEmpty);
  btNew.Enabled   := not (qryFornecedores.State in [dsInsert, dsEdit]);
  btEdit.Enabled  := (not (qryFornecedores.State in [dsInsert, dsEdit])) and (not qryFornecedores.IsEmpty);
  btDelete.Enabled:= (not (qryFornecedores.State in [dsInsert, dsEdit])) and (not qryFornecedores.IsEmpty);
  btSave.Enabled  := (qryFornecedores.State in [dsInsert, dsEdit]);
  btCancel.Enabled:= (qryFornecedores.State in [dsInsert, dsEdit]);

  pnlDados.Enabled:= (qryFornecedores.State in [dsInsert, dsEdit]);

  tsConsulta.TabVisible := not (qryFornecedores.State in [dsInsert, dsEdit]);

  cbAtivo.Enabled := (qryFornecedores.State in [dsInsert, dsEdit]);
end;

function TfrmCadFornecedor.Valida: Boolean;
begin
  Result := False;

  if (Trim(dbRAZAO_SOCIAL.Text) = '') then
  begin
    if dbRAZAO_SOCIAL.CanFocus then
      dbRAZAO_SOCIAL.SetFocus;
    raise Exception.Create('Razão social do fornecedor inválido.');
  end;

  if (Trim(dbNOME_FANTASIA.Text) = '') then
  begin
    if dbNOME_FANTASIA.CanFocus then
      dbNOME_FANTASIA.SetFocus;
    raise Exception.Create('Nome fantasia do fornecedor inválido.');
  end;

  if (Trim(dbCNPJ.Text) = '') or (Length(Trim(dbCNPJ.Text)) <> 14) then
  begin
    if dbCNPJ.CanFocus then
      dbCNPJ.SetFocus;
    raise Exception.Create('CNPJ do fornecedor inválido.');
  end;

  if (not ValidaMesmoCNPJ) then
  begin
    if dbCNPJ.CanFocus then
      dbCNPJ.SetFocus;
    raise Exception.Create('CNPJ já cadastrado.');
  end;

  Result := True;
end;

function TfrmCadFornecedor.ValidaMesmoCNPJ: Boolean;
var
  Condicao: string;
begin
  Result := True;

  Condicao := '';
  if qryFornecedores.State = dsEdit then
    Condicao := ' AND CODIGO <> '+IntToStr(qryFornecedoresCODIGO.AsInteger);

  dtmDados.qryConsulta.Close;
  dtmDados.qryConsulta.SQL.Clear;
  dtmDados.qryConsulta.SQL.Text := 'SELECT CODIGO FROM FORNECEDORES WHERE CNPJ = '+QuotedStr(dbCNPJ.Text)+Condicao;
  dtmDados.qryConsulta.Open;

  if (not dtmDados.qryConsulta.IsEmpty) then
    Result := False;
end;

end.
