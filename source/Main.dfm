object ADTF: TADTF
  Left = 853
  Top = 194
  Width = 820
  Height = 582
  Caption = 'Norton Dome Explorer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = Menu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object screen: TImage
    Left = 8
    Top = 16
    Width = 500
    Height = 500
  end
  object ColorScale: TImage
    Left = 512
    Top = 16
    Width = 15
    Height = 256
  end
  object CScaleMax: TLabel
    Left = 512
    Top = 0
    Width = 6
    Height = 13
    Alignment = taCenter
    Caption = '5'
    Transparent = True
    Visible = False
  end
  object CScaleMin: TLabel
    Left = 514
    Top = 272
    Width = 6
    Height = 13
    Alignment = taCenter
    Caption = '0'
    Transparent = True
    Visible = False
  end
  object Label10: TLabel
    Left = 536
    Top = 248
    Width = 52
    Height = 13
    Caption = 'Time used:'
  end
  object LabelTime: TLabel
    Left = 592
    Top = 248
    Width = 47
    Height = 13
    Caption = 'some time'
    Visible = False
  end
  object ProgressBar: TProgressBar
    Left = 536
    Top = 248
    Width = 257
    Height = 17
    Max = 500
    ParentShowHint = False
    Smooth = True
    Step = 1
    ShowHint = False
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 536
    Top = 16
    Width = 257
    Height = 169
    Caption = 'Screen'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 36
      Height = 13
      Caption = 'Point 1:'
    end
    object Label2: TLabel
      Left = 8
      Top = 32
      Width = 19
      Height = 13
      Caption = 'min:'
    end
    object Label3: TLabel
      Left = 136
      Top = 32
      Width = 22
      Height = 13
      Caption = 'max:'
    end
    object Label4: TLabel
      Left = 8
      Top = 48
      Width = 36
      Height = 13
      Caption = 'Point 2:'
    end
    object Label5: TLabel
      Left = 8
      Top = 64
      Width = 19
      Height = 13
      Caption = 'min:'
    end
    object Label6: TLabel
      Left = 136
      Top = 64
      Width = 22
      Height = 13
      Caption = 'max:'
    end
    object Label7: TLabel
      Left = 8
      Top = 88
      Width = 142
      Height = 13
      Caption = 'Maximum number of iterations:'
    end
    object Label8: TLabel
      Left = 8
      Top = 114
      Width = 30
      Height = 13
      Caption = 'Alpha:'
    end
    object Label9: TLabel
      Left = 128
      Top = 114
      Width = 35
      Height = 13
      Caption = 'DeltaT:'
    end
    object p1MinEdit: TEdit
      Left = 40
      Top = 32
      Width = 73
      Height = 21
      TabOrder = 0
      Text = '0.00000001'
    end
    object p1MaxEdit: TEdit
      Left = 168
      Top = 32
      Width = 73
      Height = 21
      TabOrder = 1
      Text = '1.0'
    end
    object p2MinEdit: TEdit
      Left = 40
      Top = 64
      Width = 73
      Height = 21
      TabOrder = 2
      Text = '0.00000001'
    end
    object p2MaxEdit: TEdit
      Left = 168
      Top = 64
      Width = 73
      Height = 21
      TabOrder = 3
      Text = '1.0'
    end
    object IterationSpin: TSpinEdit
      Left = 160
      Top = 88
      Width = 81
      Height = 22
      MaxValue = 1000000
      MinValue = 100
      TabOrder = 4
      Value = 250
    end
    object AlphaEdit: TEdit
      Left = 40
      Top = 112
      Width = 73
      Height = 21
      TabOrder = 5
      Text = '0.50'
    end
    object dTEdit: TEdit
      Left = 168
      Top = 112
      Width = 73
      Height = 21
      TabOrder = 6
      Text = '0.01'
    end
    object FitTCheckBox: TCheckBox
      Left = 8
      Top = 136
      Width = 81
      Height = 17
      Caption = 'Fit T ?'
      Enabled = False
      TabOrder = 7
      Visible = False
      OnClick = FitTCheckBoxClick
    end
    object DomeFunctionChoice: TComboBox
      Left = 64
      Top = 140
      Width = 145
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 8
      Text = 'Initial values: R0, R1'
      Items.Strings = (
        'Initial values: R0, R1'
        'Initial values: R0, V0')
    end
  end
  object GroupBox2: TGroupBox
    Left = 536
    Top = 288
    Width = 257
    Height = 177
    Caption = 'Run Options'
    TabOrder = 1
    object RunSim: TButton
      Left = 8
      Top = 16
      Width = 137
      Height = 70
      Caption = '1. Run Simulation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMoneyGreen
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      TabOrder = 0
      OnClick = RunSimClick
    end
    object DrawFlipBtn: TButton
      Left = 152
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Draw Flips'
      Enabled = False
      TabOrder = 1
      OnClick = DrawFlipBtnClick
    end
    object DrawError: TButton
      Left = 152
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Draw Error Code'
      Enabled = False
      TabOrder = 2
      OnClick = DrawErrorClick
    end
    object DrawMaxValueBtn: TButton
      Left = 152
      Top = 112
      Width = 97
      Height = 25
      Caption = 'Draw log(EndVal)'
      Enabled = False
      TabOrder = 3
      OnClick = DrawMaxValueBtnClick
    end
    object DrawMaskedEndValBtn: TButton
      Left = 152
      Top = 80
      Width = 97
      Height = 25
      Caption = 'Draw Endval'
      Enabled = False
      TabOrder = 4
      OnClick = DrawMaskedEndValBtnClick
    end
    object DrawTguess: TButton
      Left = 8
      Top = 96
      Width = 137
      Height = 70
      Caption = '2. Draw T'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      TabOrder = 5
      OnClick = DrawTguessClick
    end
    object DrawFitT: TButton
      Left = 152
      Top = 144
      Width = 97
      Height = 25
      Caption = 'Draw T fit'
      Enabled = False
      TabOrder = 6
      Visible = False
      OnClick = DrawTguessClick
    end
  end
  object Menu: TMainMenu
    object File1: TMenuItem
      Caption = 'File'
      object SaveImage1: TMenuItem
        Caption = 'Save Image'
        OnClick = SaveImage1Click
      end
    end
  end
  object SavePicture: TSavePictureDialog
    DefaultExt = '.bmp'
    FileName = 'DomePic.bmp'
    Title = 'Save Picture As:'
    Left = 32
  end
end
