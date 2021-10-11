unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, StdCtrls, Jpeg, MMSystem;

type
  TRGBArray = ARRAY[0..10000] of TRGBTriple;
  pTRGBArray = ^TRGBArray; // Pour les scanline

  TCell=record
  Color: Byte;
  X, Y: Byte;
  end;

  TMainForm = class(TForm)
    ImgList: TImageList;
    BtnPanel: TPanel;
    GamePanel: TPanel;
    Img: TImage;
    BackImg: TImage;
    ProgName: TLabel;
    SepShape1: TShape;
    SepShape2: TShape;
    SepShape4: TShape;
    NewGameBtn: TLabel;
    QuitBtn: TLabel;
    SepShape3: TShape;
    RulesBtn: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NewGameBtnMouseEnter(Sender: TObject);
    procedure NewGameBtnMouseLeave(Sender: TObject);
    procedure QuitBtnClick(Sender: TObject);
    procedure NewGameBtnClick(Sender: TObject);
    procedure RulesBtnClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure DrawCell(X, Y: Byte); // On dessine juste une case
    procedure DrawAll; // On dessine tout
    procedure CenterImg; // On centre l'image selon les dimensions
    procedure InitGame(NbX, NbY: Byte); // On initialise un nouveau jeu
    procedure DrawBackImg(AFileName: String);
    function CheckWin: Boolean; // Vérifie si on a gagné
    procedure PlayGameSound(ID: String);
  end;

var
  MainForm: TMainForm;
  Game: array [1..10, 1..10] of TCell; // Maximum taille : 10 x 10
  GameX, GameY: Byte; // les dimensions du jeu en cours
  IsGameRunning: Boolean=False; // Si un jeu est en cours
  WorkingOnAnim: Boolean=False; // Si le CPU bosse sur les animations
  PlayMusic: Boolean; // si on joue de la musique

implementation

uses GameType;

{$R *.dfm}

function RepertoireWindows:string;
var Buffer : array[0..255] of char;
    BufferSize : DWORD;
begin
  BufferSize := sizeOf(Buffer);
  GetWindowsDirectory(@buffer, BufferSize);
  Result:=Buffer;
end;

procedure TMainForm.DrawCell(X, Y: Byte);
Var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  case Game[X, Y].Color of
  0: ImgList.GetBitmap(0, Bmp); // On récupère le bon bitmap
  1: ImgList.GetBitmap(5, Bmp); // On récupère le bon bitmap
  end;

  // On dessine et on libère
  Img.Canvas.Draw((X - 1) * 60, (Y - 1) * 60, Bmp);
  Bmp.Free;
end;

procedure TMainForm.DrawAll;
Var
  A, B: Byte;
begin
  for A := 1 to GameX do     // On dessine le tout
    for B := 1 to GameY do
      DrawCell(A, B);
end;

procedure TMainForm.CenterImg;
begin
  Img.Width := GameX * 60;
  Img.Height := GameY * 60;   // On centre l'image
  Img.Update;
  Img.Left := (BackImg.Width div 2) - (Img.Width div 2);
  Img.Top := (BackImg.Height div 2) - (Img.Height div 2);
  Img.Enabled := True; // On active l'image
  IsGameRunning := True; // Le jeu tourne à partir de maintenant
end;

procedure TMainForm.InitGame(NbX, NbY: Byte);
Var
  A, B: Byte;
  C: Byte;
  WC, BC, Max: Byte;
begin
  GameX := NbX;  // Il faut répartir équitablement noir et blanc ...
  GameY := NbY;
  WC := 0;
  BC := 0;

  Max := (NbX * NbY) div 2; // Le maximum de cases de chaque couleur possible

  for A := 1 to NbX do
    for B := 1 to NbY do
      begin
        Game[A, B].X := A;  // On affecte les X et les Y de chaque cellule
        Game[A, B].Y := B;

        if WC = Max then
         begin
          Game[A, B].Color := 1;
          Continue;
         end;

        if BC = Max then
         begin
          Game[A, B].Color := 0;
          Continue;
         end;

        C := random(2);
        case C of
        0: Inc(WC);
        1: Inc(BC);
        end;

        Game[A, B].Color := C;
      end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  BtnPanel.DoubleBuffered := True; // On doublebuffer
  GamePanel.DoubleBuffered := True;
  randomize;     // Initialisation du moteur de nombres aléatoires
end;

procedure TMainForm.ImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  A, B: Byte;
  I: Integer;
  WBmp, BBmp: TBitmap;
begin
  if (not IsGameRunning) or (WorkingOnAnim) then Exit; // Si le jeu n'est pas en cours alors on s'arrête
  // On bloque aussi sur le processeur est en train de dessiner les animations
  // sinon on a des artéfacts vraiment moches ...


  A := (X div 60) + 1;   // On détermine quelle case a été sélectionnée
  B := (Y div 60) + 1;

  WBmp := TBitmap.Create;  // On crée les bitmaps tampon
  BBmp := TBitmap.Create;

  PlayGameSound('FLOP');

  WorkingOnAnim := True; // On commence le travail sur animations
  for I := 1 to 6 do  // Pour chaque animation
    begin
      ImgList.GetBitmap(I, WBmp);    // On récupère l'animation Blanc=>Noir
      ImgList.GetBitmap(6 - I, BBmp);  // On récupère l'animation Noir=> Blanc


      if Game[A, B].Color = 0 then Img.Canvas.Draw((A - 1) * 60, (B - 1) * 60, WBmp)
        else Img.Canvas.Draw((A - 1) * 60, (B - 1) * 60, BBmp);
                     // Case sélectionnée

      if A > 1 then
       if Game[A - 1, B].Color = 0 then Img.Canvas.Draw((A - 2) * 60, (B - 1) * 60, WBmp)
        else Img.Canvas.Draw((A - 2) * 60, (B - 1) * 60, BBmp);
                 // Case de la gauche (si elle existe)
      if A < GameX then
       if Game[A + 1, B].Color = 0 then Img.Canvas.Draw((A) * 60, (B - 1) * 60, WBmp)
        else Img.Canvas.Draw((A) * 60, (B - 1) * 60, BBmp);
                   // Case de la droite (si elle existe)
      if B > 1 then
       if Game[A, B - 1].Color = 0 then Img.Canvas.Draw((A - 1) * 60, (B - 2) * 60, WBmp)
        else Img.Canvas.Draw((A - 1) * 60, (B - 2) * 60, BBmp);  // Case du haut

      if B < GameY then
       if Game[A, B + 1].Color = 0 then Img.Canvas.Draw((A - 1) * 60, (B) * 60, WBmp)
        else Img.Canvas.Draw((A - 1) * 60, (B) * 60, BBmp); // Case du bas


       sleep(25);  // On attend pour que l'animation ne soit pas trop rapide

       Application.ProcessMessages;  // Essentiel pour voir l'animation

       Img.Invalidate; // On redessine
    end;
    WorkingOnAnim := False; // On ne travaille plus sur les animations ^^


  // Changement des couleurs

  case Game[A, B].Color of
  0: Game[A, B].Color := 1; // Case sélectionnée
  1: Game[A, B].Color := 0;
  end;

  if A > 1 then
  case Game[A - 1, B].Color of
  0: Game[A - 1, B].Color := 1;  // Case de la gauche
  1: Game[A - 1, B].Color := 0;
  end;

  if A < GameX then
  case Game[A + 1, B].Color of
  0: Game[A + 1, B].Color := 1;  // Case de la droite
  1: Game[A + 1, B].Color := 0;
  end;

  if B > 1 then
  case Game[A, B - 1].Color of
  0: Game[A, B - 1].Color := 1;  // Case du haut
  1: Game[A, B - 1].Color := 0;
  end;

  if B < GameY then
  case Game[A, B + 1].Color of
  0: Game[A, B + 1].Color := 1;  // Case du bas
  1: Game[A, B + 1].Color := 0;
  end;

  WBmp.Free; // Libération des objets
  BBmp.Free;


  DrawAll;  // On redessine le tout

  if CheckWin then
   begin             // On vérifie si on a gagné et si c'est le cas ...
    PlayGameSound('WIN'); // On joue le son et on dit que vous avez gagné
    MessageDlg('Félicitations, vous avez gagné !', mtInformation, [mbOK], 0);
    Img.Enabled := False;
    IsGameRunning := False;
   end;
end;

procedure TMainForm.DrawBackImg(AFileName: String);
begin
  if FileExists(AFileName) then BackImg.Picture.LoadFromFile(AFileName); // On ouvre une image
end;

function TMainForm.CheckWin: Boolean;
Var
  A, B: Byte;
begin
  Result := True;
  for A := 1 to GameX do
    for B := 1 to GameY do
      if Game[A, B].Color <> 0 then
       begin
        Result := False;
        Break; // Si il trouve un seul noir il s'en va avec une réponse négative !
        Exit;
       end;
end;

procedure TMainForm.PlayGameSound(ID: String);
Var
 H: HWND;
 P: Pointer;
begin
  if not PlayMusic then Exit; // Si il n'a pas voulu de musique on n'en joue pas

  H := 0;
  if ID = 'FLOP' then // On joue un son
   Try
   H := LoadResource(hInstance, FindResource(hInstance, PChar(ID), 'WAVE'));
   P := LockResource(H);
   playSound(P, 0, SND_ASYNC Or SND_MEMORY);
  Finally
   UnLockResource(H);
  End;

  if ID = 'WIN' then
   PlaySound(PChar(RepertoireWindows + '\Media\Tada.wav'), 0, SND_SYNC);
end;

procedure TMainForm.NewGameBtnMouseEnter(Sender: TObject);
begin
  if Sender is TLabel then
  TLabel(Sender).Font.Style := [fsUnderline, fsBold]; // Générique
end;

procedure TMainForm.NewGameBtnMouseLeave(Sender: TObject);
begin
  if Sender is TLabel then
  TLabel(Sender).Font.Style := [fsBold]; // Générique
end;

procedure TMainForm.QuitBtnClick(Sender: TObject);
begin
  if MessageDlg('Quitter le Reversi ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then Close;
end;                   // On quitte ou pas ?

procedure TMainForm.NewGameBtnClick(Sender: TObject);
begin
  if IsGameRunning then
   if MessageDlg('Si vous recommencez une partie, votre partie en cours sera perdue. Continuer ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  GameTypeForm.ShowModal;   // Avertissement si on recommence une partie
end;

procedure TMainForm.RulesBtnClick(Sender: TObject);
begin
  MessageDlg('Règles du jeu : ' + chr(13) + chr(13) + chr(13) + 'Le but du jeu est de rendre toutes les cases blanches.' + chr(13) + 'Pour ce faire, vous devez cliquer sur les cases de façon stratégique.' + chr(13) + 'Quand vous cliquez sur une case, ' + 'les cases adjacentes, ainsi que la case que vous avez sélectionnée,' + chr(13) +'inversent leurs couleurs, c''est à dire qu''elles passent de noir à blanc, ou de blanc à noir.', mtInformation, [mbOK], 0);
end;           // On affiche les règles du jeu

end.
