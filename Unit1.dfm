object Form1: TForm1
  Left = 341
  Height = 118
  Top = 107
  Width = 516
  Caption = 'Form1'
  ClientHeight = 118
  ClientWidth = 516
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  OnCreate = FormCreate
  LCLVersion = '1.2.6.0'
  object Button1: TButton
    Left = 415
    Height = 25
    Top = 4
    Width = 97
    Caption = 'SEND'
    Enabled = False
    OnClick = Button1Click
    TabOrder = 0
  end
  object ProgressBar1: TProgressBar
    Left = 40
    Height = 17
    Top = 40
    Width = 234
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 280
    Height = 81
    Top = 32
    Width = 232
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object StringGrid1: TStringGrid
    Left = 8
    Height = 145
    Top = 120
    Width = 504
    Color = clCream
    ColCount = 2
    DefaultColWidth = 240
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs]
    RowCount = 10
    ScrollBars = ssVertical
    TabOrder = 3
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    OnKeyDown = StringGrid1KeyDown
  end
  object Button2: TButton
    Left = 88
    Height = 25
    Top = 271
    Width = 75
    Caption = 'SAVE'
    OnClick = Button2Click
    TabOrder = 4
  end
  object Button3: TButton
    Left = 8
    Height = 25
    Top = 271
    Width = 75
    Caption = 'LOAD'
    OnClick = Button3Click
    TabOrder = 5
  end
  object Button4: TButton
    Left = 185
    Height = 25
    Top = 88
    Width = 89
    Caption = 'Edit client''s DB'
    OnClick = Button4Click
    TabOrder = 6
  end
  object ProgressBar2: TProgressBar
    Left = 56
    Height = 17
    Top = 64
    Width = 218
    TabOrder = 7
  end
  object Edit1: TEdit
    Left = 8
    Height = 21
    Top = 8
    Width = 218
    TabOrder = 8
    Text = '\'
  end
  object Button5: TButton
    Left = 280
    Height = 25
    Top = 4
    Width = 72
    Caption = 'Обзор'
    OnClick = Button5Click
    TabOrder = 9
  end
  object Edit2: TEdit
    Left = 232
    Height = 21
    Top = 8
    Width = 42
    TabOrder = 10
    Text = 'wsv'
  end
  object Label1: TLabel
    Left = 8
    Height = 13
    Top = 44
    Width = 28
    Caption = 'Total:'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 8
    Height = 13
    Top = 68
    Width = 41
    Caption = 'Current:'
    ParentColor = False
  end
  object Label3: TLabel
    Left = 8
    Height = 13
    Top = 88
    Width = 44
    Caption = 'Process: '
    ParentColor = False
  end
  object IdFTP1: TIdFTP
    OnWork = IdFTP1Work
    OnWorkBegin = IdFTP1WorkBegin
    OnWorkEnd = IdFTP1WorkEnd
    IPVersion = Id_IPv4
    AutoLogin = True
    Passive = True
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    left = 487
    top = 73
  end
  object IdAntiFreeze1: TIdAntiFreeze
    left = 487
    top = 17
  end
end
