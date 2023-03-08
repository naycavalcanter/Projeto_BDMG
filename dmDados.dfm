object dtmDados: TdtmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 186
  Width = 371
  object Conexao: TFDConnection
    Params.Strings = (
      'Database=TESTE'
      'User_Name=sa'
      'Password=1008'
      'Server=localhost'
      'DriverID=MSSQL')
    FetchOptions.AssignedValues = [evMode, evAutoClose]
    FetchOptions.Mode = fmAll
    FormatOptions.AssignedValues = [fvMapRules, fvFmtDisplayDate, fvFmtDisplayNumeric]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    ResourceOptions.AssignedValues = [rvAutoReconnect]
    ResourceOptions.AutoReconnect = True
    UpdateOptions.AssignedValues = [uvUpdateMode, uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    ConnectedStoredUsage = [auRunTime]
    LoginPrompt = False
    Transaction = Transacao
    UpdateTransaction = Transacao
    Left = 40
    Top = 24
  end
  object Transacao: TFDTransaction
    Connection = Conexao
    Left = 112
    Top = 24
  end
  object SqlServerDriver: TFDPhysMSSQLDriverLink
    Left = 208
    Top = 24
  end
  object FBDriver: TFDPhysFBDriverLink
    Left = 208
    Top = 80
  end
  object qryConsulta: TFDQuery
    Connection = Conexao
    Transaction = Transacao
    UpdateTransaction = Transacao
    Left = 116
    Top = 82
  end
end
