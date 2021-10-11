object GameTypeForm: TGameTypeForm
  Left = 198
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 313
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object GrpBox: TGroupBox
    Left = 8
    Top = 8
    Width = 298
    Height = 265
    Caption = ' Options '
    TabOrder = 0
    object PredefLabel: TLabel
      Left = 10
      Top = 30
      Width = 125
      Height = 16
      Caption = 'Une taille predefinie: '
    end
    object PersoXLabel: TLabel
      Left = 30
      Top = 98
      Width = 49
      Height = 16
      Caption = 'Largeur:'
    end
    object PersoYLabel: TLabel
      Left = 30
      Top = 128
      Width = 50
      Height = 16
      Caption = 'Hauteur:'
    end
    object PersoXLabel2: TLabel
      Left = 163
      Top = 98
      Width = 40
      Height = 16
      Caption = 'cases.'
    end
    object PersoYLabel2: TLabel
      Left = 166
      Top = 128
      Width = 40
      Height = 16
      Caption = 'cases.'
    end
    object SepBevel1: TBevel
      Left = 10
      Top = 158
      Width = 277
      Height = 2
    end
    object BckImgLabel: TLabel
      Left = 10
      Top = 167
      Width = 92
      Height = 16
      Caption = 'Image de fond :'
    end
    object SepBevel2: TBevel
      Left = 10
      Top = 226
      Width = 277
      Height = 3
    end
    object PredefCombo: TComboBox
      Left = 138
      Top = 26
      Width = 149
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      ItemIndex = 2
      TabOrder = 0
      Text = 'Normal (6 * 8)'
      Items.Strings = (
        'Petit (3 x 3)'
        'Moyen (5 x 5)'
        'Normal (6 * 8)'
        'Grand (8 x 8)'
        'Tres grand (10 x 10)')
    end
    object PersoCheckBox: TCheckBox
      Left = 10
      Top = 69
      Width = 184
      Height = 21
      Caption = 'Ou une taille personnalisee :'
      TabOrder = 1
    end
    object PersoX: TSpinEdit
      Left = 88
      Top = 95
      Width = 65
      Height = 26
      MaxValue = 10
      MinValue = 3
      TabOrder = 2
      Value = 5
    end
    object PersoY: TSpinEdit
      Left = 88
      Top = 124
      Width = 65
      Height = 26
      MaxValue = 10
      MinValue = 3
      TabOrder = 3
      Value = 5
    end
    object PathNameEdit: TEdit
      Left = 10
      Top = 190
      Width = 173
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = '[Aucune image]'
    end
    object FindBtn: TButton
      Left = 192
      Top = 187
      Width = 92
      Height = 31
      Caption = 'Parcourir ...'
      TabOrder = 5
      OnClick = FindBtnClick
    end
    object MusicCheckBox: TCheckBox
      Left = 10
      Top = 236
      Width = 159
      Height = 21
      Caption = 'Jouer les effets sonores'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
  end
  object PlayBtn: TButton
    Left = 8
    Top = 280
    Width = 169
    Height = 25
    Caption = 'Game!'
    TabOrder = 1
    OnClick = PlayBtnClick
  end
  object CancelBtn: TButton
    Left = 184
    Top = 280
    Width = 121
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object FindDlg: TOpenPictureDialog
    Filter = 
      'Tous|*.bmp*;*.jpg*;*.jpeg*|Bitmaps (.bmp)|*.bmp*|Jpeg (.jpg, .jp' +
      'eg)|*.jpg*;*.jpeg*'
    Title = 'Trouver une image de fond'
    Left = 184
    Top = 120
  end
end
