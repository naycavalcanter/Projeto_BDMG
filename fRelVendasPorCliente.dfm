object frmRelVendasPorCliente: TfrmRelVendasPorCliente
  Left = 0
  Top = 0
  Caption = 'Listagem de Vendas por Cliente'
  ClientHeight = 728
  ClientWidth = 1023
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RLReportVendasCli: TRLReport
    Left = 8
    Top = -8
    Width = 794
    Height = 1123
    DataSource = dsVendas
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    BeforePrint = RLReportVendasCliBeforePrint
    object RLBandCabecalho: TRLBand
      Left = 38
      Top = 38
      Width = 718
      Height = 59
      BandType = btTitle
      Borders.Sides = sdCustom
      Borders.DrawLeft = True
      Borders.DrawTop = True
      Borders.DrawRight = True
      Borders.DrawBottom = True
      Borders.FixedLeft = True
      Borders.FixedTop = True
      Borders.FixedRight = True
      Borders.FixedBottom = True
      object RLLabel1: TRLLabel
        Left = 229
        Top = 21
        Width = 247
        Height = 19
        Caption = 'Listagem de Vendas Por Cliente'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLSystemInfo1: TRLSystemInfo
        Left = 656
        Top = 42
        Width = 59
        Height = 15
        Alignment = taRightJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Info = itFullDate
        ParentFont = False
        Text = ''
      end
    end
    object RLBandSumario: TRLBand
      Left = 38
      Top = 172
      Width = 718
      Height = 31
      BandType = btFooter
      object RLSystemInfo2: TRLSystemInfo
        Left = 628
        Top = 12
        Width = 87
        Height = 16
        Alignment = taRightJustify
        Info = itPageNumber
        Text = ''
      end
    end
    object RLBandColunas: TRLBand
      Left = 38
      Top = 97
      Width = 718
      Height = 22
      BandType = btColumnHeader
      Borders.Sides = sdCustom
      Borders.DrawLeft = False
      Borders.DrawTop = False
      Borders.DrawRight = False
      Borders.DrawBottom = True
      Borders.FixedBottom = True
      object RLLabelNumero: TRLLabel
        Left = 16
        Top = 3
        Width = 65
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'N'#250'mero'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabelDataHora: TRLLabel
        Left = 531
        Top = 2
        Width = 105
        Height = 16
        AutoSize = False
        Caption = 'Data/Hora'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabel2: TRLLabel
        Left = 97
        Top = 3
        Width = 105
        Height = 16
        AutoSize = False
        Caption = 'Cliente'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object RLSubDetailItens: TRLSubDetail
      Left = 38
      Top = 144
      Width = 718
      Height = 28
      DataSource = dsItensVenda
      BeforePrint = RLSubDetailItensBeforePrint
      object RLBandItens: TRLBand
        Left = 0
        Top = 0
        Width = 718
        Height = 26
        object RLDBText2: TRLDBText
          Left = 40
          Top = 6
          Width = 65
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          DataField = 'COD_PRODUTO'
          DataSource = dsItensVenda
          Text = ''
        end
        object RLDBText3: TRLDBText
          Left = 121
          Top = 6
          Width = 418
          Height = 16
          AutoSize = False
          DataField = 'DESCRICAO'
          DataSource = dsItensVenda
          Text = ''
        end
      end
    end
    object RLBandDados: TRLBand
      Left = 38
      Top = 119
      Width = 718
      Height = 25
      object RLDBTextNumero: TRLDBText
        Left = 16
        Top = 6
        Width = 65
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        DataField = 'NUMERO'
        DataSource = dsVendas
        Text = ''
      end
      object RLDBTextNome: TRLDBText
        Left = 531
        Top = 6
        Width = 105
        Height = 16
        AutoSize = False
        DataField = 'DATA_HORA'
        DataSource = dsVendas
        Text = ''
      end
      object RLDBText1: TRLDBText
        Left = 97
        Top = 6
        Width = 418
        Height = 16
        AutoSize = False
        DataField = 'NOME_CLIENTE'
        DataSource = dsVendas
        Text = ''
      end
    end
  end
  object qryVendas: TFDQuery
    Connection = dtmDados.Conexao
    Left = 360
    Top = 408
    object qryVendasNUMERO: TIntegerField
      FieldName = 'NUMERO'
    end
    object qryVendasCOD_CLIENTE: TIntegerField
      FieldName = 'COD_CLIENTE'
    end
    object qryVendasNOME_CLIENTE: TStringField
      FieldName = 'NOME_CLIENTE'
      Size = 100
    end
    object qryVendasDATA_HORA: TSQLTimeStampField
      FieldName = 'DATA_HORA'
    end
  end
  object dsVendas: TDataSource
    DataSet = qryVendas
    Left = 432
    Top = 408
  end
  object qryItensVenda: TFDQuery
    Connection = dtmDados.Conexao
    Left = 360
    Top = 472
    object qryItensVendaNUMERO_VENDA: TIntegerField
      FieldName = 'NUMERO_VENDA'
    end
    object IntegerField3: TIntegerField
      FieldName = 'COD_PRODUTO'
    end
    object StringField2: TStringField
      FieldName = 'DESCRICAO'
      Size = 120
    end
  end
  object dsItensVenda: TDataSource
    DataSet = qryItensVenda
    Left = 456
    Top = 472
  end
end
