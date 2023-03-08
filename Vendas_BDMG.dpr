program Vendas_BDMG;

uses
  Vcl.Forms,
  fPrincipal in 'fPrincipal.pas' {frmPrincipal},
  fCadCliente in 'fCadCliente.pas' {frmCadCliente},
  dmDados in 'dmDados.pas' {dtmDados: TDataModule},
  fCadFornecedor in 'fCadFornecedor.pas' {frmCadFornecedor},
  fCadProduto in 'fCadProduto.pas' {frmCadProduto},
  fVendas in 'fVendas.pas' {frmVendas},
  fRelClientes in 'fRelClientes.pas' {frmRelClientes},
  fRelVendasPorCliente in 'fRelVendasPorCliente.pas' {frmRelVendasPorCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdtmDados, dtmDados);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCadFornecedor, frmCadFornecedor);
  Application.CreateForm(TfrmCadProduto, frmCadProduto);
  Application.CreateForm(TfrmVendas, frmVendas);
  Application.CreateForm(TfrmRelClientes, frmRelClientes);
  Application.CreateForm(TfrmRelVendasPorCliente, frmRelVendasPorCliente);
  Application.Run;
end.
