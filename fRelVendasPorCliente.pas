unit fRelVendasPorCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, RLReport;

type
  TfrmRelVendasPorCliente = class(TForm)
    RLReportVendasCli: TRLReport;
    RLBandCabecalho: TRLBand;
    RLLabel1: TRLLabel;
    RLSystemInfo1: TRLSystemInfo;
    RLBandSumario: TRLBand;
    RLSystemInfo2: TRLSystemInfo;
    qryVendas: TFDQuery;
    dsVendas: TDataSource;
    qryVendasNUMERO: TIntegerField;
    qryVendasDATA_HORA: TSQLTimeStampField;
    RLBandColunas: TRLBand;
    RLLabelNumero: TRLLabel;
    RLLabelDataHora: TRLLabel;
    qryVendasCOD_CLIENTE: TIntegerField;
    qryVendasNOME_CLIENTE: TStringField;
    RLLabel2: TRLLabel;
    qryItensVenda: TFDQuery;
    IntegerField3: TIntegerField;
    StringField2: TStringField;
    dsItensVenda: TDataSource;
    qryItensVendaNUMERO_VENDA: TIntegerField;
    RLSubDetailItens: TRLSubDetail;
    RLBandDados: TRLBand;
    RLDBTextNumero: TRLDBText;
    RLDBTextNome: TRLDBText;
    RLDBText1: TRLDBText;
    RLBandItens: TRLBand;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    procedure RLReportVendasCliBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLSubDetailItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private declarations }
    procedure ListaVendas;
    procedure ListaItensVenda(Venda: Integer);
  public
    { Public declarations }
  end;

var
  frmRelVendasPorCliente: TfrmRelVendasPorCliente;

implementation

{$R *.dfm}

{ TfrmRelVendasPorCliente }

procedure TfrmRelVendasPorCliente.ListaItensVenda(Venda: Integer);
begin
  qryItensVenda.Close;
  qryItensVenda.SQL.Text := ' SELECT I.NUMERO_VENDA, I.COD_PRODUTO, P.DESCRICAO ' +
                            ' FROM ITENS_VENDA I ' +
                            ' JOIN PRODUTOS P ON P.CODIGO = I.COD_PRODUTO ' +
                            ' WHERE I.NUMERO_VENDA = ' + IntToStr(Venda)+
                            ' ORDER BY P.DESCRICAO ';
  qryItensVenda.Open;
end;

procedure TfrmRelVendasPorCliente.ListaVendas;
begin
  qryVendas.Close;
  qryVendas.SQL.Text := ' SELECT V.NUMERO, V.COD_CLIENTE, C.NOME AS NOME_CLIENTE, V.DATA_HORA ' +
                        ' FROM VENDAS V ' +
                        ' JOIN CLIENTES C ON C.CODIGO = V.COD_CLIENTE ' +
                        ' WHERE V.STATUS = ''E'' '+
                        ' ORDER BY V.NUMERO, V.DATA_HORA ';
  qryVendas.Open;
end;

procedure TfrmRelVendasPorCliente.RLReportVendasCliBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  ListaVendas;
end;

procedure TfrmRelVendasPorCliente.RLSubDetailItensBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  ListaItensVenda(qryVendasNUMERO.AsInteger);
end;

end.
