object ADTF: TADTF
  Left = 541
  Height = 604
  Top = 193
  Width = 894
  Caption = 'Norton Dome Explorer'
  ClientHeight = 579
  ClientWidth = 894
  Color = clBtnFace
  DesignTimePPI = 120
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Menu = Menu
  OnCreate = FormCreate
  LCLVersion = '2.0.10.0'
  object screen: TImage
    Left = 10
    Height = 500
    Top = 20
    Width = 500
  end
  object ColorScale: TImage
    Left = 528
    Height = 255
    Top = 32
    Width = 15
  end
  object CScaleMax: TLabel
    Left = 520
    Height = 16
    Top = 8
    Width = 7
    Alignment = taCenter
    Caption = '5'
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object CScaleMin: TLabel
    Left = 519
    Height = 16
    Top = 296
    Width = 7
    Alignment = taCenter
    Caption = '0'
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object Label10: TLabel
    Left = 16
    Height = 19
    Top = 552
    Width = 79
    Caption = 'Time used:'
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    ParentColor = False
    ParentFont = False
  end
  object LabelTime: TLabel
    Left = 104
    Height = 19
    Top = 552
    Width = 74
    Caption = 'some time'
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object ProgressBar: TProgressBar
    Left = 128
    Height = 19
    Top = 528
    Width = 382
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Max = 500
    ParentFont = False
    ParentShowHint = False
    Smooth = True
    Step = 1
    TabOrder = 2
    Visible = False
  end
  object GroupBox1: TGroupBox
    Left = 552
    Height = 255
    Top = 32
    Width = 338
    Caption = 'Screen'
    ClientHeight = 226
    ClientWidth = 334
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Height = 19
      Top = 10
      Width = 56
      Caption = 'Point 1:'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object Label2: TLabel
      Left = 10
      Height = 19
      Top = 30
      Width = 31
      Caption = 'min:'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object Label3: TLabel
      Left = 170
      Height = 19
      Top = 30
      Width = 34
      Caption = 'max:'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object Label4: TLabel
      Left = 10
      Height = 19
      Top = 60
      Width = 56
      Caption = 'Point 2:'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object Label5: TLabel
      Left = 10
      Height = 19
      Top = 80
      Width = 31
      Caption = 'min:'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object Label6: TLabel
      Left = 170
      Height = 19
      Top = 80
      Width = 34
      Caption = 'max:'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object Label7: TLabel
      Left = 10
      Height = 19
      Top = 110
      Width = 158
      Caption = 'Maximum # iterations:'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object Label8: TLabel
      Left = 10
      Height = 23
      Top = 137
      Width = 17
      Caption = 'a:'
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object Label9: TLabel
      Left = 160
      Height = 19
      Top = 142
      Width = 49
      Caption = 'DeltaT:'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object p1MinEdit: TEdit
      Left = 50
      Height = 24
      Top = 30
      Width = 91
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      TabOrder = 0
      Text = '0.00000001'
    end
    object p1MaxEdit: TEdit
      Left = 215
      Height = 24
      Top = 30
      Width = 110
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      TabOrder = 1
      Text = '1.0'
    end
    object p2MinEdit: TEdit
      Left = 50
      Height = 24
      Top = 80
      Width = 91
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      TabOrder = 2
      Text = '0.00000001'
    end
    object p2MaxEdit: TEdit
      Left = 215
      Height = 24
      Top = 80
      Width = 110
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      TabOrder = 3
      Text = '1.0'
    end
    object IterationSpin: TSpinEdit
      Left = 215
      Height = 24
      Top = 110
      Width = 110
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      MaxValue = 1000000
      MinValue = 100
      ParentFont = False
      TabOrder = 4
      Value = 250
    end
    object AlphaEdit: TEdit
      Left = 50
      Height = 24
      Top = 140
      Width = 91
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      TabOrder = 5
      Text = '0.50'
    end
    object dTEdit: TEdit
      Left = 215
      Height = 24
      Top = 140
      Width = 110
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ParentFont = False
      TabOrder = 6
      Text = '0.01'
    end
    object FitTCheckBox: TCheckBox
      Left = 8
      Height = 23
      Top = 208
      Width = 70
      Caption = 'Fit T ?'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      OnClick = FitTCheckBoxClick
      ParentFont = False
      TabOrder = 7
      Visible = False
    end
    object DomeFunctionChoice: TComboBox
      Left = 8
      Height = 24
      Top = 176
      Width = 320
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      ItemHeight = 16
      ItemIndex = 0
      Items.Strings = (
        'Initial values: R0, R1'
        'Initial values: R0, V0'
      )
      ParentFont = False
      TabOrder = 8
      Text = 'Initial values: R0, R1'
    end
  end
  object GroupBox2: TGroupBox
    Left = 552
    Height = 248
    Top = 323
    Width = 338
    Caption = 'Run Options'
    ClientHeight = 219
    ClientWidth = 334
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object RunSim: TButton
      Left = 10
      Height = 88
      Top = 20
      Width = 171
      Caption = '1. Run Simulation'
      Font.Color = clMoneyGreen
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsUnderline]
      OnClick = RunSimClick
      ParentFont = False
      TabOrder = 0
    end
    object DrawFlipBtn: TButton
      Left = 190
      Height = 31
      Top = 20
      Width = 138
      Caption = 'Draw Flips'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      OnClick = DrawFlipBtnClick
      ParentFont = False
      TabOrder = 1
    end
    object DrawError: TButton
      Left = 190
      Height = 31
      Top = 60
      Width = 138
      Caption = 'Draw Error Code'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      OnClick = DrawErrorClick
      ParentFont = False
      TabOrder = 2
    end
    object DrawMaxValueBtn: TButton
      Left = 190
      Height = 31
      Top = 140
      Width = 138
      Caption = 'Draw log(EndVal)'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      OnClick = DrawMaxValueBtnClick
      ParentFont = False
      TabOrder = 3
    end
    object DrawMaskedEndValBtn: TButton
      Left = 190
      Height = 31
      Top = 100
      Width = 138
      Caption = 'Draw Endval'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      OnClick = DrawMaskedEndValBtnClick
      ParentFont = False
      TabOrder = 4
    end
    object DrawTguess: TButton
      Left = 10
      Height = 88
      Top = 123
      Width = 171
      Caption = '2. Draw T'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsUnderline]
      OnClick = DrawTguessClick
      ParentFont = False
      TabOrder = 5
    end
    object DrawFitT: TButton
      Left = 190
      Height = 31
      Top = 180
      Width = 138
      Caption = 'Draw T fit'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      OnClick = DrawTguessClick
      ParentFont = False
      TabOrder = 6
      Visible = False
    end
  end
  object Label11: TLabel
    Left = 16
    Height = 19
    Top = 528
    Width = 110
    Caption = 'Progress Run: '
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    ParentColor = False
    ParentFont = False
  end
  object Menu: TMainMenu
    object File1: TMenuItem
      Caption = 'File'
      object SaveImage1: TMenuItem
        Caption = 'Save Image'
        OnClick = SaveImage1Click
      end
      object ExitMenu: TMenuItem
        Caption = 'Exit Program'
        OnClick = ExitMenuClick
      end
    end
    object HelpMenu: TMenuItem
      Caption = 'Help'
      object ManualLink: TMenuItem
        Caption = 'Online Manual'
        OnClick = ManualLinkClick
      end
      object AboutMenu: TMenuItem
        Caption = 'About'
        OnClick = AboutMenuClick
      end
    end
  end
  object SavePicture: TSavePictureDialog
    Title = 'Save Picture As:'
    DefaultExt = '.bmp'
    FileName = 'DomePic.bmp'
    Left = 40
  end
end
