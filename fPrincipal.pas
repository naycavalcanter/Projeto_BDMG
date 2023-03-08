unit fPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.Menus;

type
  TfrmPrincipal = class(TForm)
    mnPrincipal: TMainMenu;
    acPrincipal: TActionList;
    acCadClientes: TAction;
    acCadFornecedores: TAction;
    acCadProdutos: TAction;
    acVendas: TAction;
    Cadastros1: TMenuItem;
    Clientes1: TMenuItem;
    Fornecedores1: TMenuItem;
    Produtos1: TMenuItem;
    Movimentaes1: TMenuItem;
    Relatrios1: TMenuItem;
    Vendas1: TMenuItem;
    acRelClientes: TAction;
    ListagemdeClientes1: TMenuItem;
    acRelVendasCliente: TAction;
    ListagemdeVendasporCliente1: TMenuItem;
    procedure acCadClientesExecute(Sender: TObject);
    procedure acCadFornecedoresExecute(Sender: TObject);
    procedure acCadProdutosExecute(Sender: TObject);
    procedure acVendasExecute(Sender: TObject);
    procedure acRelClientesExecute(Sender: TObject);
    procedure acRelVendasClienteExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses fCadCliente, fCadFornecedor, fCadProduto, fVendas, fRelClientes, fRelVendasPorCliente;

procedure TfrmPrincipal.acCadClientesExecute(Sender: TObject);
begin
  frmCadCliente := TfrmCadCliente.Create(Self);
  try
    frmCadCliente.ShowModal;
  finally
    frmCadCliente.Free;
  end;
end;

procedure TfrmPrincipal.acCadFornecedoresExecute(Sender: TObject);
begin
  frmCadFornecedor := TfrmCadFornecedor.Create(Self);
  try
    frmCadFornecedor.ShowModal;
  finally
    frmCadFornecedor.Free;
  end;
end;

procedure TfrmPrincipal.acCadProdutosExecute(Sender: TObject);
begin
  frmCadProduto := TfrmCadProduto.Create(Self);
  try
    frmCadProduto.ShowModal;
  finally
    frmCadProduto.Free;
  end;
end;

procedure TfrmPrincipal.acRelClientesExecute(Sender: TObject);
begin
  frmRelClientes := TfrmRelClientes.Create(Self);
  try
    frmRelClientes.RLReportClientes.PreviewModal;
  finally
    frmRelClientes.Free;
  end;
end;

procedure TfrmPrincipal.acRelVendasClienteExecute(Sender: TObject);
begin
  frmRelVendasPorCliente := TfrmRelVendasPorCliente.Create(Self);
  try
    frmRelVendasPorCliente.RLReportVendasCli.PreviewModal;
  finally
    frmRelVendasPorCliente.Free;
  end;
end;

procedure TfrmPrincipal.acVendasExecute(Sender: TObject);
begin
  frmVendas := TfrmVendas.Create(Self);
  try
    frmVendas.ShowModal;
  finally
    frmVendas.Free;
  end;
end;

end.
