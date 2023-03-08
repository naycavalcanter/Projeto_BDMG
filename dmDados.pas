unit dmDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  Data.DB, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.Phys.IBBase, FireDAC.Phys.ODBCBase,
  Vcl.Forms, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  System.IniFiles;

type
  TdtmDados = class(TDataModule)
    Conexao: TFDConnection;
    Transacao: TFDTransaction;
    SqlServerDriver: TFDPhysMSSQLDriverLink;
    FBDriver: TFDPhysFBDriverLink;
    qryConsulta: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure SetaConexao;
  public
    { Public declarations }
  end;

var
  dtmDados: TdtmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdtmDados }

procedure TdtmDados.DataModuleCreate(Sender: TObject);
begin
  SetaConexao;
end;

procedure TdtmDados.SetaConexao;
var
  ArqCfg: TIniFile;
begin
  ArqCfg := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Vendas_BDMG.ini');
  try
    Conexao.LoginPrompt       := False;
    Conexao.Transaction       := Transacao;
    Conexao.UpdateTransaction := Transacao;
    Conexao.UpdateOptions.AutoCommitUpdates := True;
    Conexao.TxOptions.AutoCommit := True;

    Conexao.Params.Values['DriverID'] := 'MSSQL';
    Conexao.Params.Values['Server']   := ArqCfg.ReadString('BANCO', 'SERVER', '');;
    Conexao.Params.Values['Database'] := ArqCfg.ReadString('BANCO', 'DATABASE', '');;
    Conexao.Params.Values['User_name']:= ArqCfg.ReadString('BANCO', 'USER', '');;
    Conexao.Params.Values['Password'] := ArqCfg.ReadString('BANCO', 'PASSWORD', '');;

    try
      Conexao.Connected := True;
    except
      on E: exception do
      raise Exception.Create('Não foi possível conectar a base de dados: '+#13+ e.Message);
    end;
  finally
    ArqCfg.Free
  end;
end;

end.
