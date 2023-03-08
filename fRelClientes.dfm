object frmRelClientes: TfrmRelClientes
  Left = 0
  Top = 0
  Caption = 'Listagem de Clientes'
  ClientHeight = 670
  ClientWidth = 905
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RLReportClientes: TRLReport
    Left = 8
    Top = 0
    Width = 794
    Height = 1123
    DataSource = dsClientes
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    BeforePrint = RLReportClientesBeforePrint
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
        Left = 285
        Top = 21
        Width = 163
        Height = 19
        Caption = 'Listagem de Clientes'
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
      Top = 145
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
      object RLLabelCodigo: TRLLabel
        Left = 16
        Top = 3
        Width = 65
        Height = 16
        AutoSize = False
        Caption = 'C'#243'digo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabelNome: TRLLabel
        Left = 96
        Top = 3
        Width = 393
        Height = 16
        AutoSize = False
        Caption = 'Nome'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabelStatus: TRLLabel
        Left = 512
        Top = 3
        Width = 105
        Height = 16
        AutoSize = False
        Caption = 'Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object RLBandDados: TRLBand
      Left = 38
      Top = 119
      Width = 718
      Height = 26
      object RLDBTextCodigo: TRLDBText
        Left = 16
        Top = 6
        Width = 65
        Height = 16
        AutoSize = False
        DataField = 'CODIGO'
        DataSource = dsClientes
        Text = ''
      end
      object RLDBTextNome: TRLDBText
        Left = 96
        Top = 6
        Width = 393
        Height = 16
        AutoSize = False
        DataField = 'NOME'
        DataSource = dsClientes
        Text = ''
      end
      object RLDBTextStatus: TRLDBText
        Left = 512
        Top = 6
        Width = 105
        Height = 16
        AutoSize = False
        DataField = 'ATIVO'
        DataSource = dsClientes
        Text = ''
      end
    end
  end
  object dsClientes: TDataSource
    DataSet = qryClientes
    Left = 576
    Top = 312
  end
  object qryClientes: TFDQuery
    Connection = dtmDados.Conexao
    Left = 512
    Top = 312
    object qryClientesCODIGO: TIntegerField
      FieldName = 'CODIGO'
    end
    object qryClientesNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object qryClientesATIVO: TStringField
      FieldName = 'ATIVO'
      OnGetText = qryClientesATIVOGetText
      Size = 1
    end
  end
end
