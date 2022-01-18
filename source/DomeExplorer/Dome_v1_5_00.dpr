program Dome_v1_5_00;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
  windows,
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  LCLIntf, LCLType, LMessages,
  Main in 'Main.pas' {ADTF},
  Colorlists in 'Colorlists.pas',
  Simulationclass in 'Simulationclass.pas',
  r0v0AbsSimClass in 'r0v0AbsSimClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Norton Dome Explorer';
  Application.CreateForm(TADTF, ADTF);
  Application.Run;
end.
