unit fRelClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, dmDados, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmRelClientes = class(TForm)
    RLReportClientes: TRLReport;
    RLBandCabecalho: TRLBand;
    RLLabel1: TRLLabel;
    RLSystemInfo1: TRLSystemInfo;
    RLBandSumario: TRLBand;
    RLSystemInfo2: TRLSystemInfo;
    RLBandColunas: TRLBand;
    RLLabelCodigo: TRLLabel;
    RLLabelNome: TRLLabel;
    RLLabelStatus: TRLLabel;
    RLBandDados: TRLBand;
    RLDBTextCodigo: TRLDBText;
    dsClientes: TDataSource;
    qryClientes: TFDQuery;
    qryClientesCODIGO: TIntegerField;
    qryClientesNOME: TStringField;
    qryClientesATIVO: TStringField;
    RLDBTextNome: TRLDBText;
    RLDBTextStatus: TRLDBText;
    procedure qryClientesATIVOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure RLReportClientesBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private declarations }
    procedure ListaClientes;
  public
    { Public declarations }
  end;

var
  frmRelClientes: TfrmRelClientes;

implementation

{$R *.dfm}

procedure TfrmRelClientes.ListaClientes;
begin
  qryClientes.Close;
  qryClientes.SQL.Text := ' SELECT CODIGO, NOME, ATIVO ' +
                          ' FROM CLIENTES ' +
                          ' WHERE ATIVO = ''S'' '+
                          ' ORDER BY CODIGO ';
  qryClientes.Open;
end;

procedure TfrmRelClientes.qryClientesATIVOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if Sender.AsString = 'N' then
    Text := 'Inativo'
  else
    Text := 'Ativo';
end;

procedure TfrmRelClientes.RLReportClientesBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  ListaClientes;
end;

end.
