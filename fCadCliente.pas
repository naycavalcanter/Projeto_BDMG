unit fCadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, RxToolEdit, RxDBCtrl, Vcl.Mask, dmDados, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Buttons;

type
  TfrmCadCliente = class(TForm)
    pgCadastro: TPageControl;
    tsConsulta: TTabSheet;
    tsDetalhe: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edFiltroNome: TEdit;
    btPesquisar: TButton;
    DBGrid1: TDBGrid;
    pnlNavegacao: TPanel;
    pnlDados: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dbNOME: TDBEdit;
    dbCPF: TDBEdit;
    dbDATA_NASCIMENTO: TDBDateEdit;
    qryClientes: TFDQuery;
    dsClientes: TDataSource;
    qryClientesNOME: TStringField;
    qryClientesCPF: TStringField;
    qryClientesDATA_NASCIMENTO: TDateField;
    qryClientesATIVO: TStringField;
    Label5: TLabel;
    cbAtivo: TComboBox;
    qryClientesCODIGO: TIntegerField;
    btFirst: TBitBtn;
    btPrior: TBitBtn;
    btNew: TBitBtn;
    btEdit: TBitBtn;
    btSave: TBitBtn;
    btCancel: TBitBtn;
    btDelete: TBitBtn;
    btNext: TBitBtn;
    btLast: TBitBtn;
    edFiltroCPF: TEdit;
    Label6: TLabel;
    procedure qryClientesATIVOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure btPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryClientesNewRecord(DataSet: TDataSet);
    procedure dbCPFKeyPress(Sender: TObject; var Key: Char);
    procedure btFirstClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btLastClick(Sender: TObject);
    procedure qryClientesBeforePost(DataSet: TDataSet);
    procedure edFiltroCPFKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure InicializaConsulta;
    procedure SetaSituacao;
    function  Valida: Boolean;
    function  ValidaMesmoCPF: Boolean;
    function  ProximoCodigo: integer;
    procedure StatusTela;
  public
    { Public declarations }
  end;

var
  frmCadCliente: TfrmCadCliente;

implementation

{$R *.dfm}

procedure TfrmCadCliente.btCancelClick(Sender: TObject);
begin
  qryClientes.Cancel;
  StatusTela;
end;

procedure TfrmCadCliente.btDeleteClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja excluir o cliente?', 'Cadastro de Clientes', MB_YESNO + MB_ICONQUESTION) = IDYES) then
  begin
    qryClientes.Delete;
    StatusTela;
    SetaSituacao;
  end;
end;

procedure TfrmCadCliente.btEditClick(Sender: TObject);
begin
  qryClientes.Edit;
  StatusTela;
  if (dbNOME.CanFocus) then
    dbNOME.SetFocus;
end;

procedure TfrmCadCliente.btFirstClick(Sender: TObject);
begin
  qryClientes.First;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadCliente.btLastClick(Sender: TObject);
begin
  qryClientes.Last;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadCliente.btNewClick(Sender: TObject);
begin
  qryClientes.Append;
  StatusTela;
  if (dbNOME.CanFocus) then
    dbNOME.SetFocus;
end;

procedure TfrmCadCliente.btNextClick(Sender: TObject);
begin
  qryClientes.Next;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadCliente.btPesquisarClick(Sender: TObject);
begin
  InicializaConsulta;
end;

procedure TfrmCadCliente.btPriorClick(Sender: TObject);
begin
  qryClientes.Prior;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadCliente.btSaveClick(Sender: TObject);
begin
  if not Valida then
    Exit;

  qryClientes.Post;
  StatusTela;
end;

procedure TfrmCadCliente.dbCPFKeyPress(Sender: TObject; var Key: Char);
begin
  if (not CharInSet(Key, ['0'..'9'])) and (Key <> #8) and (Key <> #3) and (Key <> #22) then
    Key :=#0;
end;

procedure TfrmCadCliente.edFiltroCPFKeyPress(Sender: TObject; var Key: Char);
begin
  if (not CharInSet(Key, ['0'..'9'])) and (Key <> #8) and (Key <> #3) and (Key <> #22) then
    Key :=#0;
end;

procedure TfrmCadCliente.FormShow(Sender: TObject);
begin
  InicializaConsulta;
  SetaSituacao;
  pgCadastro.ActivePage := tsDetalhe;
  StatusTela;
end;

procedure TfrmCadCliente.InicializaConsulta;
var
  Sql,
  ParamNome,
  ParamCpf: string;
begin
  Sql          := '';
  ParamNome    := '';
  ParamCpf     := '';

  // Define o parametro referente ao CPF
  if edFiltroCPF.Text <> '' then
    ParamCpf :=' WHERE CPF = '+QuotedStr(edFiltroCPF.Text)+' ';

  // Define o parametro referente ao Nome
  if (Trim(edFiltroNome.Text) <> '') then
  begin
    if (ParamCpf = '') then
      ParamNome :=' WHERE (NOME LIKE ''%'+edFiltroNome.Text+'%'') '
    else
      ParamNome :=' AND (NOME LIKE ''%'+edFiltroNome.Text+'%'') ';
  end;


  Sql := ' SELECT CODIGO, NOME, CPF, DATA_NASCIMENTO, ATIVO '+
         ' FROM CLIENTES '+
           ParamNome+
           ParamCpf+
         ' ORDER BY NOME ';

  qryClientes.Close;
  qryClientes.Sql.Clear;
  qryClientes.Sql.Text := Sql;
  qryClientes.Open;
end;

function TfrmCadCliente.ProximoCodigo: integer;
begin
  dtmDados.qryConsulta.Close;
  dtmDados.qryConsulta.SQL.Clear;
  dtmDados.qryConsulta.SQL.Text := 'SELECT MAX(CODIGO) AS CODIGO FROM CLIENTES';
  dtmDados.qryConsulta.Open;

  Result := dtmDados.qryConsulta.FieldByName('CODIGO').AsInteger + 1;
end;

procedure TfrmCadCliente.qryClientesATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsString = 'S' then
    Text := 'Sim'
  else if Sender.AsString = 'N' then
    Text := 'Não'
  else
    Text := '';
end;

procedure TfrmCadCliente.qryClientesBeforePost(DataSet: TDataSet);
begin
  case cbAtivo.ItemIndex of
    0: qryClientes.FieldByName('ATIVO').AsString  := 'S';
    1: qryClientes.FieldByName('ATIVO').AsString  := 'N';
  end;
end;

procedure TfrmCadCliente.qryClientesNewRecord(DataSet: TDataSet);
begin
  qryClientes.FieldByName('CODIGO').AsInteger:= ProximoCodigo;
  qryClientes.FieldByName('ATIVO').AsString  := 'S';
  SetaSituacao;
end;

procedure TfrmCadCliente.SetaSituacao;
begin
  if qryClientesATIVO.AsString = 'S' then
    cbAtivo.ItemIndex := 0
  else
    cbAtivo.ItemIndex := 1;
end;

procedure TfrmCadCliente.StatusTela;
begin
  btFirst.Enabled := (not (qryClientes.State in [dsInsert, dsEdit])) and (not qryClientes.IsEmpty);
  btPrior.Enabled := (not (qryClientes.State in [dsInsert, dsEdit])) and (not qryClientes.IsEmpty);
  btNext.Enabled  := (not (qryClientes.State in [dsInsert, dsEdit])) and (not qryClientes.IsEmpty);
  btLast.Enabled  := (not (qryClientes.State in [dsInsert, dsEdit])) and (not qryClientes.IsEmpty);
  btNew.Enabled   := not (qryClientes.State in [dsInsert, dsEdit]);
  btEdit.Enabled  := (not (qryClientes.State in [dsInsert, dsEdit])) and (not qryClientes.IsEmpty);
  btDelete.Enabled:= (not (qryClientes.State in [dsInsert, dsEdit])) and (not qryClientes.IsEmpty);
  btSave.Enabled  := (qryClientes.State in [dsInsert, dsEdit]);
  btCancel.Enabled:= (qryClientes.State in [dsInsert, dsEdit]);

  pnlDados.Enabled:= (qryClientes.State in [dsInsert, dsEdit]);

  tsConsulta.TabVisible := not (qryClientes.State in [dsInsert, dsEdit]);

  cbAtivo.Enabled := (qryClientes.State in [dsInsert, dsEdit]);
end;

function TfrmCadCliente.Valida: Boolean;
begin
  Result := False;

  if (Trim(dbNOME.Text) = '') then
  begin
    if dbNOME.CanFocus then
      dbNOME.SetFocus;
    raise Exception.Create('Nome do cliente inválido.');
  end;

  if (Trim(dbCPF.Text) = '') or (Length(Trim(dbCPF.Text)) <> 11) then
  begin
    if dbCPF.CanFocus then
      dbCPF.SetFocus;
    raise Exception.Create('Cpf do cliente inválido.');
  end;

  if (not ValidaMesmoCPF) then
  begin
    if dbCPF.CanFocus then
      dbCPF.SetFocus;
    raise Exception.Create('Cpf já cadastrado.');
  end;

  Result := True;
end;

function TfrmCadCliente.ValidaMesmoCPF: Boolean;
var
  Condicao: string;
begin
  Result := True;

  Condicao := '';
  if qryClientes.State = dsEdit then
    Condicao := ' AND CODIGO <> '+IntToStr(qryClientesCODIGO.AsInteger);

  dtmDados.qryConsulta.Close;
  dtmDados.qryConsulta.SQL.Clear;
  dtmDados.qryConsulta.SQL.Text := 'SELECT CODIGO FROM CLIENTES WHERE CPF = '+QuotedStr(dbCPF.Text)+Condicao;
  dtmDados.qryConsulta.Open;

  if (not dtmDados.qryConsulta.IsEmpty) then
    Result := False;
end;

end.

