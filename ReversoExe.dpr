program ReversoExe;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  GameType in 'GameType.pas' {GameTypeForm};

{$R *.res}
{$R WindowsXP.RES}
{$R Sounds.RES}

begin
  Application.Initialize;
  Application.Title := 'Reversi';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TGameTypeForm, GameTypeForm);
  Application.Run;
end.
