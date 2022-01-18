unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, ComCtrls, types, Math, LCLIntf,
  colorlists, ExtDlgs, Menus,simulationClass, r0r1AbsSimClass, r0v0AbsSimClass;


type

  { TADTF }

  TADTF = class(TForm)
    Label11: TLabel;
    ExitMenu: TMenuItem;
    HelpMenu: TMenuItem;
    ManualLink: TMenuItem;
    AboutMenu: TMenuItem;
    screen: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    p1MinEdit: TEdit;
    Label3: TLabel;
    p1MaxEdit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    p2MinEdit: TEdit;
    Label6: TLabel;
    p2MaxEdit: TEdit;
    Label7: TLabel;
    IterationSpin: TSpinEdit;
    GroupBox2: TGroupBox;
    RunSim: TButton;
    Label8: TLabel;
    AlphaEdit: TEdit;
    ProgressBar: TProgressBar;
    Label9: TLabel;
    dTEdit: TEdit;
    DrawFlipBtn: TButton;
    ColorScale: TImage;
    CScaleMax: TLabel;
    CScaleMin: TLabel;
    DrawError: TButton;
    DrawMaxValueBtn: TButton;
    DrawMaskedEndValBtn: TButton;
    Label10: TLabel;
    LabelTime: TLabel;
    DrawTguess: TButton;
    DrawFitT: TButton;
    FitTCheckBox: TCheckBox;
    Menu: TMainMenu;
    File1: TMenuItem;
    SaveImage1: TMenuItem;
    SavePicture: TSavePictureDialog;
    DomeFunctionChoice: TComboBox;
    procedure AboutMenuClick(Sender: TObject);
    procedure ExitMenuClick(Sender: TObject);
    procedure ManualLinkClick(Sender: TObject);
    procedure RunSimClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrawFlipBtnClick(Sender: TObject);
    procedure DrawErrorClick(Sender: TObject);
    procedure DrawMaxValueBtnClick(Sender: TObject);
    procedure DrawMaskedEndValBtnClick(Sender: TObject);
    procedure DrawTguessClick(Sender: TObject);
    procedure SaveImage1Click(Sender: TObject);
    procedure FitTCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
    Tstart: TDateTime;
    Tstop: TDateTime;
    TotalTime: TDateTime;
    Sim: TSimulationClass;
    procedure startTimer();
    procedure stopTimer();
    procedure initializeSimulation();
  public
    { Public declarations }
    LastImageButton:string;
    procedure SetColorScaleI(Sender: TObject; min, max: integer);
    procedure SetColorScaleD(Sender: TObject; min, max: double);
    procedure DrawTsomething(Sender: TObject; MAT: TDataD);
    procedure FlipButtonStatus(status:boolean);
  end;

{Global constants}
const
maxx = 500;
maxy = 500;
maxxm = 499;
maxym = 499;

var
  ADTF: TADTF;
  colors: TColorList;
  colortype: integer;

implementation
//since the Project>Options>linker leads to problems, overwritting the memory
//we can manually change the stacksize in the *.dof file.
// MinStackSize=16777216      16Mb
// MaxStackSize=1073741824    1Gb
{$M+ 22000000,1000000000}  //a space after the comma invalidates the command
{$R *.dfm}

{
Some general intialization of GUI features
}
procedure TADTF.FormCreate(Sender: TObject);
begin
screen.Width:=maxx;
screen.Height:=maxy;
TotalTime:=0;
LastImageButton:=' --- NO BUTTON CLICKED --- ';
DomeFunctionChoice.ItemIndex:=0;
self.sim:=TSimulationClass.create();//A class needs to be created to allow for the FitTCheckBoxClick call
self.FitTCheckBoxClick(Sender);
end;
{
Flip the enabled status of the buttons at start and end of the simulation run
}
procedure TADTF.FlipButtonStatus(status:boolean);
begin
DrawTguess.Enabled:=status;
DrawFitT.Enabled:=status;
DrawMaskedEndValBtn.Enabled:=status;
DrawMaxValueBtn.Enabled:=status;
RunSim.Enabled:=status;
DrawFlipBtn.Enabled:=status;
DrawError.Enabled:=status;
end;

{
Starts the timer with second accuracy.
}
procedure TADTF.startTimer();
begin
LabelTime.Visible:=false;
Tstart:=Now;
end;

{
Stops the timer with second accuracy & updates the form caption.
}
procedure TADTF.stopTimer();
var
   diffT: TDateTime;
begin
Tstop:=Now;
diffT:=Tstop-Tstart;
TotalTime:=TotalTime+diffT;
Caption:='Norton Dome Explorer.           Total Used WallTime:'+TimeToStr(TotalTime);
LabelTime.Caption:=TimeToStr(diffT);
LabelTime.Visible:=true;
end;

{
Initialize all parameters for the simulation & create a model of the selected simulation class.
}
procedure TADTF.initializeSimulation();
var
 v1, v2: double;
 err: integer;
begin
//sim:=TSimulationClass.create();
case (self.DomeFunctionChoice.ItemIndex) of
   0: sim:=TR0R1AbsSimClass.create();
   1: sim:=TR0V0AbsSimClass.create();
else
  begin
   MessageDlg('This type of function is not available. Switching to default r0,r1.',
               mtInformation, [mbOk], 0);
   sim:=TR0R1AbsSimClass.create();
  end;
end;//case

val(p1MinEdit.Text,v1,err);
val(p1MaxEdit.Text,v2,err);
sim.setP1range(v1,v2);
val(p2MinEdit.Text,v1,err);
val(p2MaxEdit.Text,v2,err);
sim.setP2range(v1,v2);
sim.setMaximumIterations(IterationSpin.Value);
val(AlphaEdit.Text,v1,err);
val(dTEdit.Text,v2,err);
sim.setAlpha(v1);
sim.setTfitting(FitTCheckbox.checked);
sim.setTimestep(v2);
sim.setArrayDim(maxx,maxy);
sim.clearArrays();
end;

{
Run Simulation button was pressed --> Run the simulation
}
procedure TADTF.RunSimClick(Sender: TObject);
var
rect:TRect;
begin
LastImageButton:='Run Simulation.';
StartTimer();
FlipButtonStatus(false);
//initializations
progressbar.Visible:=true;
colortype:=2;
getColorList(colortype,colors);
rect.Left:=0; rect.Right:=maxx;
rect.Top:=maxy; rect.Bottom:=0;
screen.Canvas.Brush.Color:=clgray;
screen.Canvas.Pen.Color:=clgreen;
screen.Canvas.FillRect(rect);
//first read our variables
self.initializeSimulation();
Sim.RunSimulation(progressbar);
progressbar.Visible:=false;
FlipButtonStatus(true);
StopTimer();
end;//RunFunction
{
Exit the program.
}
procedure TADTF.ExitMenuClick(Sender: TObject);
begin
  application.Terminate;
end;

procedure TADTF.AboutMenuClick(Sender: TObject);
begin
  OpenURL('https://github.com/DannyVanpoucke/NortonDomeExplorer/');
end;

{
Open the Github-page with the "user manual/help".
}
procedure TADTF.ManualLinkClick(Sender: TObject);
begin
  OpenURL('https://github.com/DannyVanpoucke/NortonDomeExplorer/blob/master/docs/2_Manual.md');
end;

{
Draw the number of flips, before the end of the iteration, or fatal error.
}
procedure TADTF.DrawFlipBtnClick(Sender: TObject);
var
 nrx,nry, nr:integer;
 l,h: integer;
 ds: real;
 flipc: byte;
 ll, hl: array[1..maxx] of  integer;
begin
LastImageButton:='Draw #flips';

for nr:=1 to maxx do
  begin
  ll[nr]:=minintvalue(sim.Flips[nr]);
  hl[nr]:=maxintvalue(sim.Flips[nr]);
  end;
l:=minintvalue(ll);
h:=maxintvalue(hl);
ds:=max((h-l)/255.0,1.0/255.0);//protect against zero-div
SetColorScaleI(sender,l,h);

for nrx:=1 to maxx do
  begin
  for nry:=1 to maxy do
    begin
    flipc:=trunc(sim.flips[nrx,nry]/ds);
    screen.Canvas.Pixels[nrx,screen.Height-nry]:=colors[flipc];
    end;
  end;
screen.Canvas.Refresh;
screen.Repaint;
end;

{
Setup the colorscale...for integers.
}
procedure TADTF.SetColorScaleI(Sender: TObject; min, max: integer);
var
nr: integer;
s:string;
begin

str(min,s);
CScaleMin.Caption:= Trim(s);
str(max,s);
CScaleMax.Caption:= Trim(s);
self.CScaleMax.Left:=self.ColorScale.Left+trunc((self.ColorScale.Width-self.CScaleMax.Width)*0.5);
self.CScaleMin.Left:=self.ColorScale.Left+trunc((self.ColorScale.Width-self.CScaleMin.Width)*0.5);

CScaleMin.Visible:=true;
CScaleMax.Visible:=true;

for nr:=0 to 255 do
      begin
      colorscale.Canvas.Pen.Color:=colors[nr];
      colorscale.Canvas.MoveTo(0,colorscale.Height-nr);
      colorscale.Canvas.LineTo(colorscale.Width,colorscale.Height-nr);
      end;
end;

{
 Setup the colorscale...for real numbers.
}
procedure TADTF.SetColorScaleD(Sender: TObject; min, max: double);
var
nr: integer;
s:string;
begin

str(min:12:4,s);
CScaleMin.Caption:= Trim(s);
str(max:12:4,s);
CScaleMax.Caption:= Trim(s);
CScaleMin.Visible:=true;
CScaleMax.Visible:=true;

for nr:=0 to 255 do
      begin
      colorscale.Canvas.Pen.Color:=colors[nr];
      colorscale.Canvas.MoveTo(0,colorscale.Height-nr);
      colorscale.Canvas.LineTo(15,colorscale.Height-nr);
      end;
end;

{
Show which pixel had which error-code
}
procedure TADTF.DrawErrorClick(Sender: TObject);
var
 nrx,nry :integer;
begin
LastImageButton:='Draw errorcode';

GetColorList(108,colors);
SetColorScaleI(sender,0,7);

for nrx:=1 to maxx do
  begin
  for nry:=1 to maxy do
    begin
    screen.Canvas.Pixels[nrx,screen.Height-nry]:=colors[sim.errorcodes[nrx,nry]*32];//we have 8 colors
    end;
  end;
screen.Canvas.Refresh;
screen.Repaint;

GetColorList(colortype,colors);
end;//draw error

{
Show the maximum value (i.e., the last value in the iteration, or before fail)
}
procedure TADTF.DrawMaxValueBtnClick(Sender: TObject);
var
 nrx,nry, nr:integer;
 l,h: double;
 ds, tmp: double;
 flipc: smallint;
 ll, hl: array[1..maxx] of  double;
begin
LastImageButton:='Draw log maxval';

for nr:=1 to maxx do
  begin
  ll[nr]:=minvalue(sim.DomeEndPos[nr]);
  hl[nr]:=maxvalue(sim.DomeEndPos[nr]);
  end;
l:=minvalue(ll);
h:=log10(maxvalue(hl));
if (l<0) then
begin
  l:=-log10(abs(l));
  ds:=(max(l/128.0,h/128.0));
end
else
begin
  l:=0;
  ds:=(h/128.0);
end;
GetColorList(200,colors);
SetColorScaleD(sender,l,h);

for nrx:=1 to maxx do
  begin
  for nry:=1 to maxy do
    begin
    tmp:=sim.DomeEndPos[nrx,nry];
    //since this is intended to show the location of big numbers > +- x 10^100, stuff near zero is set to 0
    if (abs(tmp)>=1.0) then flipc:=trunc(log10(abs(tmp))/ds)
    else flipc:=0;

    if  (tmp<0) then flipc:=-flipc;
    screen.Canvas.Pixels[nrx,screen.Height-nry]:=colors[128+flipc];
    end;
  end;
screen.Canvas.Refresh;
screen.Repaint;
GetColorList(colortype,colors);
end;

{
Show the maximum value at the end of the iteration, when no error was encountered.
}
procedure TADTF.DrawMaskedEndValBtnClick(Sender: TObject);
var
 nrx,nry:integer;
 l,h: double;
 ds: double;
 flipc: byte;
 Masked: TDataD;
 Mask:TDataB;
begin
LastImageButton:='Draw masked endvalue';

l:=1.0E100;
h:=-1.0E100;

for nrx:=1 to maxx do
  begin
  for nry:=1 to maxy do
    begin
      if (sim.Errorcodes[nrx,nry]=0) then
        begin
        Mask[nrx,nry]:=true;
        Masked[nrx,nry]:=sim.DomeEndPos[nrx,nry];
        if (Masked[nrx,nry]<l) then l:=Masked[nrx,nry];
        if (Masked[nrx,nry]>h) then h:=Masked[nrx,nry];
        end
      else
        begin
        Mask[nrx,nry]:=false;
        Masked[nrx,nry]:=0.0;
        end;
    end;
  end;

ds:=(h-l)/255.0;
GetColorList(200,colors);
SetColorScaleD(sender,l,h);

for nrx:=1 to maxx do
  begin
  for nry:=1 to maxy do
    begin
    flipc:=trunc((masked[nrx,nry]-l)/ds);
    if  (mask[nrx,nry]) then
      begin
      screen.Canvas.Pixels[nrx,screen.Height-nry]:=colors[flipc];
      end
    else
      begin
      screen.Canvas.Pixels[nrx,screen.Height-nry]:=rgb(0,255,255);
      end;
    end;
  end;
screen.Canvas.Refresh;
screen.Repaint;
GetColorList(colortype,colors);
end;

{
wrapper for drawing the T value...in the masked area
}
procedure TADTF.DrawTguessClick(Sender: TObject);
begin
 if (sender = DrawTGuess) then
   begin
   LastImageButton:='Draw guess T';
   DrawTsomething(Sender, sim.DomeGuessT);
   end
 else if (sender = DrawFitT ) then
   begin
   if (FitTCheckBox.Checked) then
    begin
    LastImageButton:='Draw fit T';
    DrawTsomething(Sender, sim.DomeFitT);
    end
   else // there is no fitted data
    begin
    MessageDlg('No T fitting was performed. If you wish to visualize fitted'+
          'T-values, then you should check the "Fit T" checkbox and'+
          'run the simulation again.', mtInformation, [mbOk], 0);
    end;
 end
end;

{
generic draw routine for the T values.
}
procedure TADTF.DrawTsomething(Sender: TObject; MAT:TDataD);
var
 nrx,nry:integer;
 l,h: double;
 dsp,dsm: double;
 flipc: smallint;
 Masked: TDataD;
 Mask:TDataB;
begin
l:=1.0E100;
h:=-1.0E100;

for nrx:=1 to maxx do
  begin
  for nry:=1 to maxy do
    begin
      if (sim.Errorcodes[nrx,nry]=0) then
        begin
        Mask[nrx,nry]:=true;
        Masked[nrx,nry]:=MAT[nrx,nry];
        if (Masked[nrx,nry]<l) then l:=Masked[nrx,nry];
        if (Masked[nrx,nry]>h) then h:=Masked[nrx,nry];
        end
      else
        begin
        Mask[nrx,nry]:=false;
        Masked[nrx,nry]:=0.0;
        end;
    end;
  end;

if ((h>0)and(l<0)) then
  begin
  dsp:=h/128.0;
  dsm:=-l/127.0;
  GetColorList(200,colors);
  SetColorScaleD(sender,l,h);

  for nrx:=1 to maxx do
  begin
  for nry:=1 to maxy do
    begin
    if  (mask[nrx,nry]) then
      begin
      if (masked[nrx,nry]>0) then flipc:=trunc(masked[nrx,nry]/dsp)
      else                        flipc:=trunc(masked[nrx,nry]/dsm);
      screen.Canvas.Pixels[nrx,screen.Height-nry]:=colors[127+flipc];
      end
    else
      begin
      screen.Canvas.Pixels[nrx,screen.Height-nry]:=rgb(0,255,255);
      end;
    end;
  end;
  end
else
  begin
  dsp:=(h-l)/255.0;
  GetColorList(1,colors);
  SetColorScaleD(sender,l,h);

  for nrx:=1 to maxx do
  begin
  for nry:=1 to maxy do
    begin
    if  (mask[nrx,nry]) then
      begin
      flipc:=trunc((masked[nrx,nry]-l)/dsp);
      screen.Canvas.Pixels[nrx,screen.Height-nry]:=colors[flipc];
      end
    else
      begin
      screen.Canvas.Pixels[nrx,screen.Height-nry]:=rgb(0,255,255);
      end;
    end;
  end;
  end;

screen.Canvas.Refresh;
screen.Repaint;
GetColorList(colortype,colors);
end;


{
Save the onscreen image.
}
procedure TADTF.SaveImage1Click(Sender: TObject);
var
filename: string;
begin

  if (SavePicture.Execute) then
    begin
    filename:=SavePicture.FileName;
    screen.Picture.SaveToFile(filename);
    end;

end;

{
The Draw T Fit button should only be visible if the Fit T option is selected.
}
procedure TADTF.FitTCheckBoxClick(Sender: TObject);
begin
   DrawFitT.Visible := FitTCheckBox.Checked;
  try
      DrawFitT.Enabled := Sim.getTfitting();
   except
      on EAccessViolation do DrawFitT.Enabled := false;
   end;

end;

end.
