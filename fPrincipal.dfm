object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Sistema de Vendas - BDMG'
  ClientHeight = 385
  ClientWidth = 755
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mnPrincipal
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object mnPrincipal: TMainMenu
    Left = 40
    Top = 104
    object Cadastros1: TMenuItem
      Caption = 'Cadastros'
      object Clientes1: TMenuItem
        Action = acCadClientes
      end
      object Fornecedores1: TMenuItem
        Action = acCadFornecedores
      end
      object Produtos1: TMenuItem
        Action = acCadProdutos
      end
    end
    object Movimentaes1: TMenuItem
      Caption = 'Movimenta'#231#245'es'
      object Vendas1: TMenuItem
        Action = acVendas
      end
    end
    object Relatrios1: TMenuItem
      Caption = 'Relat'#243'rios'
      object ListagemdeClientes1: TMenuItem
        Action = acRelClientes
      end
      object ListagemdeVendasporCliente1: TMenuItem
        Action = acRelVendasCliente
      end
    end
  end
  object acPrincipal: TActionList
    Left = 120
    Top = 104
    object acCadClientes: TAction
      Category = 'Cadastros'
      Caption = 'Clientes'
      OnExecute = acCadClientesExecute
    end
    object acCadFornecedores: TAction
      Category = 'Cadastros'
      Caption = 'Fornecedores'
      OnExecute = acCadFornecedoresExecute
    end
    object acCadProdutos: TAction
      Category = 'Cadastros'
      Caption = 'Produtos'
      OnExecute = acCadProdutosExecute
    end
    object acVendas: TAction
      Category = 'Movimentacoes'
      Caption = 'Vendas'
      OnExecute = acVendasExecute
    end
    object acRelClientes: TAction
      Category = 'Relatorios'
      Caption = 'Listagem de Clientes'
      OnExecute = acRelClientesExecute
    end
    object acRelVendasCliente: TAction
      Category = 'Relatorios'
      Caption = 'Listagem de Vendas por Cliente'
      OnExecute = acRelVendasClienteExecute
    end
  end
end
