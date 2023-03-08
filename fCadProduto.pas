unit fCadProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, RxToolEdit, RxDBCtrl, Vcl.Mask, dmDados, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Buttons;

type
  TfrmCadProduto = class(TForm)
    pgCadastro: TPageControl;
    tsConsulta: TTabSheet;
    tsDetalhe: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edFiltroDescricao: TEdit;
    btPesquisar: TButton;
    DBGrid1: TDBGrid;
    pnlNavegacao: TPanel;
    pnlDados: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    dbPRECO_UNITARIO: TDBEdit;
    qryProdutos: TFDQuery;
    dsProdutos: TDataSource;
    qryProdutosDESCRICAO: TStringField;
    qryProdutosATIVO: TStringField;
    Label5: TLabel;
    cbAtivo: TComboBox;
    qryProdutosCODIGO: TIntegerField;
    btFirst: TBitBtn;
    btPrior: TBitBtn;
    btNew: TBitBtn;
    btEdit: TBitBtn;
    btSave: TBitBtn;
    btCancel: TBitBtn;
    btDelete: TBitBtn;
    btNext: TBitBtn;
    btLast: TBitBtn;
    dbDESCRICAO: TDBEdit;
    qryProdutosCOD_FORNECEDOR: TIntegerField;
    qryProdutosRAZAO_SOCIAL: TStringField;
    dbCOD_FORNECEDOR: TDBLookupComboBox;
    Label4: TLabel;
    qryFornecedores: TFDQuery;
    dsFornecedores: TDataSource;
    qryFornecedoresCODIGO: TIntegerField;
    qryFornecedoresRAZAO_SOCIAL: TStringField;
    qryProdutosPRECO_UNITARIO: TBCDField;
    procedure qryProdutosATIVOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure btPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryProdutosNewRecord(DataSet: TDataSet);
    procedure dbPRECO_UNITARIOKeyPress(Sender: TObject; var Key: Char);
    procedure btFirstClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btLastClick(Sender: TObject);
    procedure qryProdutosBeforePost(DataSet: TDataSet);
    procedure edFiltroCNPJKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure InicializaConsulta;
    procedure SetaSituacao;
    function  Valida: Boolean;
    function  ProximoCodigo: integer;
    procedure StatusTela;
  public
    { Public declarations }
  end;

var
  frmCadProduto: TfrmCadProduto;

implementation

{$R *.dfm}

procedure TfrmCadProduto.btCancelClick(Sender: TObject);
begin
  qryProdutos.Cancel;
  StatusTela;
end;

procedure TfrmCadProduto.btDeleteClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja excluir o produto?', 'Cadastro de Produtos', MB_YESNO + MB_ICONQUESTION) = IDYES) then
  begin
    qryProdutos.Delete;
    StatusTela;
    SetaSituacao;
  end;
end;

procedure TfrmCadProduto.btEditClick(Sender: TObject);
begin
  qryProdutos.Edit;
  StatusTela;
  if (dbDESCRICAO.CanFocus) then
    dbDESCRICAO.SetFocus;
end;

procedure TfrmCadProduto.btFirstClick(Sender: TObject);
begin
  qryProdutos.First;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadProduto.btLastClick(Sender: TObject);
begin
  qryProdutos.Last;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadProduto.btNewClick(Sender: TObject);
begin
  qryProdutos.Append;
  StatusTela;
  if (dbDESCRICAO.CanFocus) then
    dbDESCRICAO.SetFocus;
end;

procedure TfrmCadProduto.btNextClick(Sender: TObject);
begin
  qryProdutos.Next;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadProduto.btPesquisarClick(Sender: TObject);
begin
  InicializaConsulta;
end;

procedure TfrmCadProduto.btPriorClick(Sender: TObject);
begin
  qryProdutos.Prior;
  StatusTela;
  SetaSituacao;
end;

procedure TfrmCadProduto.btSaveClick(Sender: TObject);
begin
  if not Valida then
    Exit;

  qryProdutos.Post;
  StatusTela;
end;

procedure TfrmCadProduto.dbPRECO_UNITARIOKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '.', ',': if (Length(TDBEdit(Sender).Text) > 0) and (Pos(',', TDBEdit(Sender).Text) = 0) then
                 Key :=','
              else
                 Key :=#0;
  else
     if (not CharInSet(Key, ['0'..'9'])) and (Key <> #8)  and (Key <> #3) and (Key <> #22) then
        Key :=#0;
  end;
end;

procedure TfrmCadProduto.edFiltroCNPJKeyPress(Sender: TObject; var Key: Char);
begin
  if (not CharInSet(Key, ['0'..'9'])) and (Key <> #8) and (Key <> #3) and (Key <> #22) then
    Key :=#0;
end;

procedure TfrmCadProduto.FormShow(Sender: TObject);
begin
  InicializaConsulta;
  SetaSituacao;
  pgCadastro.ActivePage := tsDetalhe;
  StatusTela;
end;

procedure TfrmCadProduto.InicializaConsulta;
var
  Sql,
  ParamDescricao: string;
begin
  Sql            := '';
  ParamDescricao := '';

  // Define o parametro referente a Descricao
  if (Trim(edFiltroDescricao.Text) <> '') then
    ParamDescricao :=' WHERE (DESCRICAO LIKE ''%'+edFiltroDescricao.Text+'%'') ';

  Sql := ' SELECT P.CODIGO, P.DESCRICAO, P.PRECO_UNITARIO, P.ATIVO, ' +
         '        P.COD_FORNECEDOR, F.RAZAO_SOCIAL ' +
         ' FROM PRODUTOS P ' +
         'INNER JOIN FORNECEDORES F ON F.CODIGO = P.COD_FORNECEDOR '+
           ParamDescricao+
         ' ORDER BY P.DESCRICAO ';

  qryProdutos.Close;
  qryProdutos.Sql.Clear;
  qryProdutos.Sql.Text := Sql;
  qryProdutos.Open;

  qryFornecedores.Close;
  qryFornecedores.Open;
end;

function TfrmCadProduto.ProximoCodigo: integer;
begin
  dtmDados.qryConsulta.Close;
  dtmDados.qryConsulta.SQL.Clear;
  dtmDados.qryConsulta.SQL.Text := 'SELECT MAX(CODIGO) AS CODIGO FROM PRODUTOS';
  dtmDados.qryConsulta.Open;

  Result := dtmDados.qryConsulta.FieldByName('CODIGO').AsInteger + 1;
end;

procedure TfrmCadProduto.qryProdutosATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsString = 'S' then
    Text := 'Sim'
  else if Sender.AsString = 'N' then
    Text := 'Não'
  else
    Text := '';
end;

procedure TfrmCadProduto.qryProdutosBeforePost(DataSet: TDataSet);
begin
  case cbAtivo.ItemIndex of
    0: qryProdutos.FieldByName('ATIVO').AsString  := 'S';
    1: qryProdutos.FieldByName('ATIVO').AsString  := 'N';
  end;
end;

procedure TfrmCadProduto.qryProdutosNewRecord(DataSet: TDataSet);
begin
  qryProdutos.FieldByName('CODIGO').AsInteger:= ProximoCodigo;
  qryProdutos.FieldByName('ATIVO').AsString  := 'S';
  SetaSituacao;
end;

procedure TfrmCadProduto.SetaSituacao;
begin
  if qryProdutosATIVO.AsString = 'S' then
    cbAtivo.ItemIndex := 0
  else
    cbAtivo.ItemIndex := 1;
end;

procedure TfrmCadProduto.StatusTela;
begin
  btFirst.Enabled := (not (qryProdutos.State in [dsInsert, dsEdit])) and (not qryProdutos.IsEmpty);
  btPrior.Enabled := (not (qryProdutos.State in [dsInsert, dsEdit])) and (not qryProdutos.IsEmpty);
  btNext.Enabled  := (not (qryProdutos.State in [dsInsert, dsEdit])) and (not qryProdutos.IsEmpty);
  btLast.Enabled  := (not (qryProdutos.State in [dsInsert, dsEdit])) and (not qryProdutos.IsEmpty);
  btNew.Enabled   := not (qryProdutos.State in [dsInsert, dsEdit]);
  btEdit.Enabled  := (not (qryProdutos.State in [dsInsert, dsEdit])) and (not qryProdutos.IsEmpty);
  btDelete.Enabled:= (not (qryProdutos.State in [dsInsert, dsEdit])) and (not qryProdutos.IsEmpty);
  btSave.Enabled  := (qryProdutos.State in [dsInsert, dsEdit]);
  btCancel.Enabled:= (qryProdutos.State in [dsInsert, dsEdit]);

  pnlDados.Enabled:= (qryProdutos.State in [dsInsert, dsEdit]);

  tsConsulta.TabVisible := not (qryProdutos.State in [dsInsert, dsEdit]);

  cbAtivo.Enabled := (qryProdutos.State in [dsInsert, dsEdit]);
end;

function TfrmCadProduto.Valida: Boolean;
begin
  Result := False;

  if (Trim(dbDESCRICAO.Text) = '') then
  begin
    if dbDESCRICAO.CanFocus then
      dbDESCRICAO.SetFocus;
    raise Exception.Create('Descrição do produto inválida.');
  end;

  if (StrToFloatDef(dbPRECO_UNITARIO.Text, 0) = 0) then
  begin
    if dbPRECO_UNITARIO.CanFocus then
      dbPRECO_UNITARIO.SetFocus;
    raise Exception.Create('Preço do produto inválido.');
  end;

  if (Trim(dbCOD_FORNECEDOR.Text) = '') then
  begin
    if dbCOD_FORNECEDOR.CanFocus then
      dbCOD_FORNECEDOR.SetFocus;
    raise Exception.Create('Fornecedor inválido.');
  end;

  Result := True;
end;

end.
