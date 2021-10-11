unit GameType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtDlgs, ExtCtrls;

type
  TGameTypeForm = class(TForm)
    GrpBox: TGroupBox;
    PredefLabel: TLabel;
    PredefCombo: TComboBox;
    PersoCheckBox: TCheckBox;
    PersoXLabel: TLabel;
    PersoYLabel: TLabel;
    PersoX: TSpinEdit;
    PersoY: TSpinEdit;
    PersoXLabel2: TLabel;
    PersoYLabel2: TLabel;
    PlayBtn: TButton;
    CancelBtn: TButton;
    SepBevel1: TBevel;
    BckImgLabel: TLabel;
    PathNameEdit: TEdit;
    FindBtn: TButton;
    FindDlg: TOpenPictureDialog;
    SepBevel2: TBevel;
    MusicCheckBox: TCheckBox;
    procedure CancelBtnClick(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  GameTypeForm: TGameTypeForm;

implementation

uses Main;

{$R *.dfm}

procedure TGameTypeForm.CancelBtnClick(Sender: TObject);
begin
  Close; // On ferme
end;

procedure TGameTypeForm.PlayBtnClick(Sender: TObject);
begin
  case PersoCheckBox.Checked of
  False:
   case PredefCombo.ItemIndex of
   0: MainForm.InitGame(3, 3);
   1: MainForm.InitGame(5, 5);
   2: MainForm.InitGame(6, 8);   // On fixe la taille
   3: MainForm.InitGame(8, 8);
   4: MainForm.InitGame(10, 10);
   end;
  True: MainForm.InitGame(PersoX.Value, PersoY.Value);
  end;

  PlayMusic := MusicCheckBox.Checked;  // On voit si il veut de la musique

  MainForm.CenterImg;      // On centre
  MainForm.DrawBackImg(PathNameEdit.Text); // On charge l'image de fond
  MainForm.DrawAll;   // On dessine le tout

  Close;     // Et on ferme la fenêtre
end;

procedure TGameTypeForm.FindBtnClick(Sender: TObject);
begin
  if FindDlg.Execute then PathNameEdit.Text := FindDlg.FileName;  // On cherche dans son système
end;    // de fichiers une image ...

procedure TGameTypeForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;      // On doublebuffer
  GrpBox.DoubleBuffered := True;
end;

procedure TGameTypeForm.FormShow(Sender: TObject);
begin
  // Quand on affiche la fiche on remet tous les paramètres à leurs valeurs par défaut ...
  PathNameEdit.Text := '[Aucune image]';
  PersoX.Value := 5;
  PersoY.Value := 5;
  PersoCheckBox.Checked := False;
  PredefCombo.ItemIndex := 2;
  MusicCheckBox.Checked := True;
end;

end.
