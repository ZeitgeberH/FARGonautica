object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Framework'
  ClientHeight = 571
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 774
    Height = 571
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      'NUMBO')
    TabIndex = 0
    object Button1: TButton
      Left = 600
      Top = 32
      Width = 161
      Height = 25
      Caption = 'Load bricks and target'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Memo1: TMemo
      Left = 4
      Top = 24
      Width = 581
      Height = 543
      Align = alLeft
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object Button3: TButton
      Left = 600
      Top = 56
      Width = 161
      Height = 25
      Caption = 'Run bottom-up and top-down'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 600
      Top = 80
      Width = 161
      Height = 25
      Caption = 'Slipnet Design'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button2: TButton
      Left = 600
      Top = 104
      Width = 161
      Height = 25
      Caption = 'NUMBO (Slipnet nodes only)'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button5: TButton
      Left = 600
      Top = 128
      Width = 161
      Height = 25
      Caption = '2-level depth first'
      TabOrder = 5
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 600
      Top = 152
      Width = 161
      Height = 25
      Caption = 'Parallel terraced scan'
      TabOrder = 6
      OnClick = Button6Click
    end
  end
end