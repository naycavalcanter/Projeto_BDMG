unit fVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, RxToolEdit, RxDBCtrl, Vcl.Mask, dmDados, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Buttons;

type
  TfrmVendas = class(TForm)
    pgCadastro: TPageControl;
    tsConsulta: TTabSheet;
    tsDetalhe: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edFiltroCliente: TEdit;
    btPesquisar: TButton;
    DBGrid1: TDBGrid;
    pnlNavegacao: TPanel;
    pnlDados: TPanel;
    qryVendas: TFDQuery;
    dsVendas: TDataSource;
    btFirst: TBitBtn;
    btPrior: TBitBtn;
    btNew: TBitBtn;
    btEdit: TBitBtn;
    btSave: TBitBtn;
    btCancel: TBitBtn;
    btDelete: TBitBtn;
    btNext: TBitBtn;
    btLast: TBitBtn;
    qryVendasNUMERO: TIntegerField;
    qryVendasCOD_CLIENTE: TIntegerField;
    qryVendasNOME: TStringField;
    qryVendasSTATUS: TStringField;
    qryClientes: TFDQuery;
    qryClientesCODIGO: TIntegerField;
    qryClientesNOME: TStringField;
    dsClientes: TDataSource;
    pnlMaster: TPanel;
    Label6: TLabel;
    dbCOD_CLIENTE: TDBLookupComboBox;
    pnlDetail: TPanel;
    gbItens: TGroupBox;
    pnlNavItens: TPanel;
    pnlDetailInfo: TPanel;
    Label2: TLabel;
    dbProdutos: TDBLookupComboBox;
    Label3: TLabel;
    Label4: TLabel;
    dbQUANTIDADE: TDBEdit;
    dbVALOR_TOTAL: TDBEdit;
    Label5: TLabel;
    btNewItem: TSpeedButton;
    btEditItem: TSpeedButton;
    btSaveItem: TSpeedButton;
    btCancelItem: TSpeedButton;
    btDeleteItem: TSpeedButton;
    DBGrid2: TDBGrid;
    qryItensVenda: TFDQuery;
    dsItensVenda: TDataSource;
    qryItensVendaNUMERO_VENDA: TIntegerField;
    qryItensVendaNUMERO_ITEM: TIntegerField;
    qryItensVendaCOD_PRODUTO: TIntegerField;
    qryItensVendaQUANTIDADE: TIntegerField;
    qryProdutos: TFDQuery;
    dsProdutos: TDataSource;
    qryProdutosCODIGO: TIntegerField;
    qryProdutosDESCRICAO: TStringField;
    qryVendasDATA_HORA: TSQLTimeStampField;
    qryItensVendaDESCRICAO: TStringField;
    btEfetivar: TButton;
    lbEfetivada: TLabel;
    qryVendasVALOR_TOTAL: TBCDField;
    qryProdutosPRECO_UNITARIO: TBCDField;
    qryItensVendaVALOR_TOTAL: TBCDField;
    qryItensVendaPRECO_UNITARIO: TBCDField;
    dbPRECO_UNITARIO: TEdit;
    procedure btPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryVendasNewRecord(DataSet: TDataSet);
    procedure btFirstClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btLastClick(Sender: TObject);
    procedure qryVendasSTATUSGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure qryItensVendaNewRecord(DataSet: TDataSet);
    procedure qryVendasBeforePost(DataSet: TDataSet);
    procedure dbPRECO_UNITARIOChange(Sender: TObject);
    procedure dbQUANTIDADEChange(Sender: TObject);
    procedure dbProdutosExit(Sender: TObject);
    procedure btNewItemClick(Sender: TObject);
    procedure btEditItemClick(Sender: TObject);
    procedure btSaveItemClick(Sender: TObject);
    procedure btCancelItemClick(Sender: TObject);
    procedure btDeleteItemClick(Sender: TObject);
    procedure qryVendasAfterOpen(DataSet: TDataSet);
    procedure qryVendasAfterScroll(DataSet: TDataSet);
    procedure btEfetivarClick(Sender: TObject);
    procedure dsItensVendaDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    function  Valida: Boolean;
    function  ValidaItem: Boolean;
    function  ValidaEfetivar: Boolean;
    function  ValidaMesmoProduto: Boolean;
    function  ProximoCodigo: integer;
    function  ProximoCodigoItem: integer;
    function  CalculaTotalVenda: Double;
    procedure InicializaConsulta;
    procedure InicializaConsultaItem;
    procedure StatusTela;
    procedure StatusTelaItem;
    procedure EfetivarVenda;
  public
    { Public declarations }
  end;

var
  frmVendas: TfrmVendas;

implementation

{$R *.dfm}

procedure TfrmVendas.btCancelClick(Sender: TObject);
begin
  if (qryItensVenda.State in [dsInsert, dsEdit]) then
    qryItensVenda.Cancel;

  qryVendas.Cancel;
  StatusTela;
  StatusTelaItem;
end;

procedure TfrmVendas.btCancelItemClick(Sender: TObject);
begin
  qryItensVenda.Cancel;
  StatusTelaItem;
end;

procedure TfrmVendas.btDeleteClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja excluir a venda e os itens da venda?', 'Vendas de Produtos', MB_YESNO + MB_ICONQUESTION) = IDYES) then
  begin
    // Exclui os itens da venda
    qryItensVenda.First;
    while not qryItensVenda.Eof do
    begin
      qryItensVenda.Delete;
    end;

    qryVendas.Delete;
    StatusTela;
    StatusTelaItem;
  end;
end;

procedure TfrmVendas.btDeleteItemClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja excluir o item da venda?', 'Vendas de Produtos', MB_YESNO + MB_ICONQUESTION) = IDYES) then
  begin
    qryItensVenda.Delete;
    StatusTelaItem;
  end;
end;

procedure TfrmVendas.btEditClick(Sender: TObject);
begin
  if (qryItensVenda.State in [dsInsert, dsEdit]) then
    raise Exception.Create('Favor salvar ou cancelar os itens da venda.');

  qryVendas.Edit;
  StatusTela;
  StatusTelaItem;
  if (dbCOD_CLIENTE.CanFocus) then
    dbCOD_CLIENTE.SetFocus;
end;

procedure TfrmVendas.btEditItemClick(Sender: TObject);
begin
  if (VarToStrDef(dbCOD_CLIENTE.KeyValue, '') = '') then
    raise Exception.Create('Favor informar o cliente da venda antes de alterar um item.');

  qryItensVenda.Edit;
  StatusTelaItem;
  if (dbProdutos.CanFocus) then
    dbProdutos.SetFocus;
end;

procedure TfrmVendas.btEfetivarClick(Sender: TObject);
begin
  EfetivarVenda;
end;

procedure TfrmVendas.btFirstClick(Sender: TObject);
begin
  qryVendas.First;
  StatusTela;
  StatusTelaItem;
end;

procedure TfrmVendas.btLastClick(Sender: TObject);
begin
  qryVendas.Last;
  StatusTela;
  StatusTelaItem;
end;

procedure TfrmVendas.btNewClick(Sender: TObject);
begin
  if (qryItensVenda.State in [dsInsert, dsEdit]) then
    raise Exception.Create('Favor salvar ou cancelar os itens da venda.');

  qryVendas.Append;
  StatusTela;
  StatusTelaItem;
  if (dbCOD_CLIENTE.CanFocus) then
    dbCOD_CLIENTE.SetFocus;
end;

procedure TfrmVendas.btNewItemClick(Sender: TObject);
begin
  if (VarToStrDef(dbCOD_CLIENTE.KeyValue, '') = '') then
    raise Exception.Create('Favor informar o cliente da venda antes de incluir um item.');

  if (qryVendas.State in [dsInsert, dsEdit]) then
  begin
    qryVendas.Post;
    qryVendas.Edit;
  end;

  qryItensVenda.Append;
  StatusTelaItem;
  if (dbProdutos.CanFocus) then
    dbProdutos.SetFocus;
end;

procedure TfrmVendas.btNextClick(Sender: TObject);
begin
  qryVendas.Next;
  StatusTela;
  StatusTelaItem;
end;

procedure TfrmVendas.btPesquisarClick(Sender: TObject);
begin
  InicializaConsulta;
end;

procedure TfrmVendas.btPriorClick(Sender: TObject);
begin
  qryVendas.Prior;
  StatusTela;
  StatusTelaItem;
end;

procedure TfrmVendas.btSaveClick(Sender: TObject);
begin
  if not Valida then
    Exit;

  if (qryItensVenda.State in [dsInsert, dsEdit]) then
    qryItensVenda.Post;

  qryVendas.Post;
  StatusTela;
  StatusTelaItem;
end;

procedure TfrmVendas.btSaveItemClick(Sender: TObject);
begin
  if (VarToStrDef(dbCOD_CLIENTE.KeyValue, '') = '') then
    raise Exception.Create('Favor informar o cliente da venda antes de salvar os itens.');

  if not ValidaItem then
    Exit;

  qryItensVenda.Post;
  StatusTelaItem;
end;

function TfrmVendas.CalculaTotalVenda: Double;
var
  Total: Double;
begin
  Total := 0;

  qryItensVenda.DisableControls;
  try
    qryItensVenda.First;
    while not qryItensVenda.Eof do
    begin
      Total := Total + qryItensVendaVALOR_TOTAL.AsFloat;
      qryItensVenda.Next;
    end;

    Result := Total;
  finally
    qryItensVenda.EnableControls;
  end;
end;

procedure TfrmVendas.dbPRECO_UNITARIOChange(Sender: TObject);
begin
  if (qryItensVenda.State in [dsInsert, dsEdit]) then
    qryItensVendaVALOR_TOTAL.AsFloat := StrToFloatDef(dbPRECO_UNITARIO.Text, 0) * qryItensVendaQUANTIDADE.AsFloat;
end;

procedure TfrmVendas.dbProdutosExit(Sender: TObject);
begin
  if (qryItensVenda.State in [dsInsert, dsEdit]) then
    dbPRECO_UNITARIO.Text := FormatFloat(',0.00', qryProdutosPRECO_UNITARIO.AsFloat);
end;

procedure TfrmVendas.dbQUANTIDADEChange(Sender: TObject);
begin
    if (qryItensVenda.State in [dsInsert, dsEdit]) then
      qryItensVendaVALOR_TOTAL.AsFloat := StrToFloatDef(dbPRECO_UNITARIO.Text, 0) * StrToFloatDef(dbQUANTIDADE.Text, 0);
end;

procedure TfrmVendas.dsItensVendaDataChange(Sender: TObject; Field: TField);
begin
  dbPRECO_UNITARIO.Text := FormatFloat(',0.00', qryProdutosPRECO_UNITARIO.AsFloat);
end;

procedure TfrmVendas.EfetivarVenda;
begin
  if not ValidaEfetivar then
    Exit;

  if (Application.MessageBox('Deseja realmente efetivar a venda?', 'Vendas de Produtos', MB_YESNO + MB_ICONQUESTION) = IDYES) then
  begin
    qryVendas.Edit;
    qryVendasSTATUS.AsString := 'E';
    qryVendas.Post;
  end;

  StatusTela;
  StatusTelaItem;
end;

procedure TfrmVendas.FormShow(Sender: TObject);
begin
  InicializaConsulta;
  pgCadastro.ActivePage := tsDetalhe;
  StatusTela;
  StatusTelaItem;
end;

procedure TfrmVendas.InicializaConsulta;
var
  Sql,
  ParamCliente: string;
begin
  Sql          := '';
  ParamCliente := '';

  // Define o parametro referente ao cliente
  if (Trim(edFiltroCliente.Text) <> '') then
  begin
    ParamCliente :=' WHERE (C.NOME LIKE ''%'+edFiltroCliente.Text+'%'') ';
  end;

  Sql := ' SELECT V.NUMERO, V.COD_CLIENTE, C.NOME, V.DATA_HORA, V.VALOR_TOTAL, ' +
         '        V.STATUS ' +
         ' FROM VENDAS V ' +
         ' INNER JOIN CLIENTES C ON C.CODIGO = V.COD_CLIENTE ';

  qryVendas.Close;
  qryVendas.Sql.Clear;
  qryVendas.Sql.Text := Sql;
  qryVendas.Open;

  qryClientes.Close;
  qryClientes.Open;
end;

procedure TfrmVendas.InicializaConsultaItem;
var
  Sql: string;
begin
  Sql := ' SELECT I.NUMERO_VENDA, I.NUMERO_ITEM, I.COD_PRODUTO, I.QUANTIDADE, I.VALOR_TOTAL '+
         ' FROM ITENS_VENDA I ' +
         ' JOIN PRODUTOS P ON P.CODIGO = I.COD_PRODUTO ' +
         ' WHERE P.ATIVO = ''S'' ' +
         '   AND I.NUMERO_VENDA = ' + IntToStr(qryVendasNUMERO.AsInteger);

  qryItensVenda.Close;
  qryItensVenda.Sql.Clear;
  qryItensVenda.Sql.Text := Sql;
  qryItensVenda.Open;

  qryProdutos.Close;
  qryProdutos.Open;
end;

function TfrmVendas.ProximoCodigo: integer;
begin
  dtmDados.qryConsulta.Close;
  dtmDados.qryConsulta.SQL.Clear;
  dtmDados.qryConsulta.SQL.Text := 'SELECT MAX(NUMERO) AS CODIGO FROM VENDAS';
  dtmDados.qryConsulta.Open;

  Result := dtmDados.qryConsulta.FieldByName('CODIGO').AsInteger + 1;
end;

function TfrmVendas.ProximoCodigoItem: integer;
begin
  dtmDados.qryConsulta.Close;
  dtmDados.qryConsulta.SQL.Clear;
  dtmDados.qryConsulta.SQL.Text := ' SELECT MAX(NUMERO_ITEM) AS CODIGO ' +
                                   ' FROM ITENS_VENDA ' +
                                   ' WHERE NUMERO_VENDA = '+IntToStr(qryVendasNUMERO.AsInteger);
  dtmDados.qryConsulta.Open;

  Result := dtmDados.qryConsulta.FieldByName('CODIGO').AsInteger + 1;
end;

procedure TfrmVendas.qryItensVendaNewRecord(DataSet: TDataSet);
begin
  qryItensVenda.FieldByName('NUMERO_VENDA').AsInteger:= qryVendasNUMERO.AsInteger;
  qryItensVenda.FieldByName('NUMERO_ITEM').AsInteger := ProximoCodigoItem;
end;

procedure TfrmVendas.qryVendasAfterOpen(DataSet: TDataSet);
begin
  InicializaConsultaItem;
end;

procedure TfrmVendas.qryVendasAfterScroll(DataSet: TDataSet);
begin
  InicializaConsultaItem;
  StatusTela;
end;

procedure TfrmVendas.qryVendasBeforePost(DataSet: TDataSet);
begin
  qryVendas.FieldByName('VALOR_TOTAL').AsFloat := CalculaTotalVenda;
end;

procedure TfrmVendas.qryVendasNewRecord(DataSet: TDataSet);
begin
  qryVendas.FieldByName('NUMERO').AsInteger     := ProximoCodigo;
  qryVendas.FieldByName('DATA_HORA').AsDateTime := Now;
  qryVendas.FieldByName('STATUS').AsString      := 'P';
end;

procedure TfrmVendas.qryVendasSTATUSGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if Sender.AsString = 'E' then
    Text := 'Efetivada'
  else
    Text := 'Pendente';
end;

procedure TfrmVendas.StatusTela;
begin
  btFirst.Enabled   := (not (qryVendas.State in [dsInsert, dsEdit])) and (not qryVendas.IsEmpty);
  btPrior.Enabled   := (not (qryVendas.State in [dsInsert, dsEdit])) and (not qryVendas.IsEmpty);
  btNext.Enabled    := (not (qryVendas.State in [dsInsert, dsEdit])) and (not qryVendas.IsEmpty);
  btLast.Enabled    := (not (qryVendas.State in [dsInsert, dsEdit])) and (not qryVendas.IsEmpty);
  btNew.Enabled     := (not (qryVendas.State in [dsInsert, dsEdit]));
  btEdit.Enabled    := (not (qryVendas.State in [dsInsert, dsEdit])) and (not qryVendas.IsEmpty) and (qryVendasSTATUS.AsString <> 'E');
  btDelete.Enabled  := (not (qryVendas.State in [dsInsert, dsEdit])) and (not qryVendas.IsEmpty) and (qryVendasSTATUS.AsString <> 'E');
  btSave.Enabled    := (qryVendas.State in [dsInsert, dsEdit]) and (qryVendasSTATUS.AsString <> 'E');
  btCancel.Enabled  := (qryVendas.State in [dsInsert, dsEdit]) and (qryVendasSTATUS.AsString <> 'E');

  btEfetivar.Enabled:= (not (qryVendas.State in [dsInsert, dsEdit])) and (not qryVendas.IsEmpty) and (qryVendasSTATUS.AsString <> 'E');
  lbEfetivada.Visible:= (qryVendasSTATUS.AsString = 'E');

  pnlMaster.Enabled := (qryVendas.State in [dsInsert, dsEdit]);

  tsConsulta.TabVisible := not (qryVendas.State in [dsInsert, dsEdit]);
end;

procedure TfrmVendas.StatusTelaItem;
begin
  btNewItem.Enabled    := (qryVendas.State in [dsInsert, dsEdit]) and (not (qryItensVenda.State in [dsInsert, dsEdit]));
  btEditItem.Enabled   := (qryVendas.State in [dsInsert, dsEdit]) and (not (qryItensVenda.State in [dsInsert, dsEdit])) and (not qryItensVenda.IsEmpty);
  btDeleteItem.Enabled := (qryVendas.State in [dsInsert, dsEdit]) and (not (qryItensVenda.State in [dsInsert, dsEdit])) and (not qryItensVenda.IsEmpty);
  btSaveItem.Enabled   := (qryVendas.State in [dsInsert, dsEdit]) and (qryItensVenda.State in [dsInsert, dsEdit]);
  btCancelItem.Enabled := (qryVendas.State in [dsInsert, dsEdit]) and (qryItensVenda.State in [dsInsert, dsEdit]);

  pnlDetail.Enabled    := (qryVendas.State in [dsInsert, dsEdit]) and (not qryVendas.IsEmpty);
  pnlDetailInfo.Enabled:= (qryItensVenda.State in [dsInsert, dsEdit]);

  tsConsulta.TabVisible:= not (qryVendas.State in [dsInsert, dsEdit]);
end;

function TfrmVendas.Valida: Boolean;
begin
  Result := False;

  if (VarToStrDef(dbCOD_CLIENTE.KeyValue, '') = '') then
  begin
    if dbCOD_CLIENTE.CanFocus then
      dbCOD_CLIENTE.SetFocus;
    raise Exception.Create('Cliente da venda inválido.');
  end;

  Result := True;
end;

function TfrmVendas.ValidaEfetivar: Boolean;
begin
  Result := False;

  if (qryItensVenda.IsEmpty) then
  begin
    raise Exception.Create('Não é possível efetivar uma venda sem itens.');
  end;

  Result := True;
end;

function TfrmVendas.ValidaItem: Boolean;
begin
  Result := False;

  if (VarToStrDef(dbProdutos.KeyValue, '') = '') then
  begin
    if dbProdutos.CanFocus then
      dbProdutos.SetFocus;
    raise Exception.Create('Produto inválido.');
  end;

  if (StrToIntDef(dbQUANTIDADE.Text,0) = 0) then
  begin
    if dbQUANTIDADE.CanFocus then
      dbQUANTIDADE.SetFocus;
    raise Exception.Create('Quantidade do produto não pode ser zero.');
  end;

  if (not ValidaMesmoProduto) then
  begin
    if dbProdutos.CanFocus then
      dbProdutos.SetFocus;
    raise Exception.Create('Produto já incluído na venda.');
  end;

  Result := True;
end;

function TfrmVendas.ValidaMesmoProduto: Boolean;
var
  CodProduto: string;
begin
  Result := True;

  if (qryItensVenda.State = dsInsert) or
     ((qryItensVenda.State = dsEdit) and (qryItensVendaCOD_PRODUTO.NewValue <> Null) and
      (qryItensVendaCOD_PRODUTO.OldValue <> qryItensVendaCOD_PRODUTO.NewValue)) then
  begin
    dtmDados.qryConsulta.Close;
    dtmDados.qryConsulta.SQL.Clear;
    dtmDados.qryConsulta.SQL.Text := ' SELECT COD_PRODUTO FROM ITENS_VENDA ' +
                                     ' WHERE NUMERO_VENDA = ' + IntToStr(qryVendasNUMERO.AsInteger) +
                                     '   AND COD_PRODUTO = ' + QuotedStr(qryItensVendaCOD_PRODUTO.AsString);
    dtmDados.qryConsulta.Open;

    if (not dtmDados.qryConsulta.IsEmpty) then
      Result := False;
  end;
end;

end.