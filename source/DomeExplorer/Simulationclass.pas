unit Simulationclass;
{
Parent class providing all required functions for the child class
simulation types.
}
interface
uses
  ComCtrls, math, fitting;

{ Arrays where data is stored before being transformed into a 500x500 bitmap graphic. }
type TDataD = array [1..500,1..500] of double;
type TDataI = array [1..500,1..500] of integer;
type TDataB = array [1..500,1..500] of boolean;

type
  TSimulationClass = class(TObject)
      private
        p1min: double; //edge-points defining the rectangle of the graphics frame, in terms of model space
        p1max: double;
        p2min: double;
        p2max: double;
        nx   : integer; //width of arrays in x and y directions, starting at 1
        ny   : integer;
      protected
        alpha: double;             //the power of the dome/mound
        dt   : double;             //the timestep
        maxiter: integer;          //maximum number of iterations
        doTfitting : boolean;      //Is a T-fit requested?
        snlist:array of double;  //list in which the array of sn-values is storred during the run
        timelist:array of double;//list in which the time is storred for the iterations

      public
        DomeEndPos:TDataD; // final values after as many iterations as the scheme survived
        Flips:TDataI;      // number of sign-flips during the iterations
        ErrorCodes:TDataI; // listing or error-codes on which each pixel may have failed.
        DomeGuessT:TDataD; // T from a very simple guess procedure looking only at the last value of the iteration
        DomeFitT:TDataD;   // Fitted T value from levenberg-fit, starting from an initial guess for T
        DomeFitErrorT:TDataD; // Error of the fitted T according to LM-fit

        constructor create();
        procedure setP1range(vmin,vmax:double);
        procedure setP2range(vmin,vmax:double);
        procedure setTimestep(deltaT:double);
        procedure setAlpha(alp:double);
        procedure setTfitting(dofit:boolean);
        function getTfitting():boolean;
        procedure setMaximumIterations(imax:integer);
        procedure updateTimelist();
        procedure setArrayDim(width,height:integer);
        procedure clearArrays();
        procedure RunSimulation(Progress:TProgressbar); // this one will need updating for derived classes
        //abstract functions that need to be written for new equation sets
        procedure setGlobalPrefactors();virtual; abstract;//set fitting and other constant factors once and for all of the simulation
        procedure DomeFunction(s0,s1:double; nrx,nry:integer);virtual;abstract;  // s0,s1 setup for the generalized dome    
        function  GuessTFunction(var error: integer ):double;virtual;abstract;  // should have the format defined in TGuessTFunction
        procedure FitDeriveFunction(xx:double; a:glmma; var yfit:double; var dyda:glmma; mma:integer);virtual;abstract;
//that evaluates the fitting function yfit and its derivatives dyda
//with respect to the parameters a at point xx.

      end;

//function  GuessTSimple(var error: integer ):double;   // should have the format defined in TGuessTFunction

implementation


{
create an empty simulation class object
}
constructor TSimulationClass.create();
begin
    p1min:=0.0;
    p1max:=0.0;
    p2min:=0.0;
    p2max:=0.0;
    nx:=0;
    ny:=0;
    dt:=0.0;
    alpha:=0.0;
    maxiter:=-1;
    doTfitting:=false;
    setlength(snlist,0);
    setlength(timelist,0);
end;


{
Set the value-range for the first parameter
}
procedure TSimulationClass.setP1range(vmin,vmax:double);
begin
  p1min:=vmin;
  p1max:=vmax;
end;
{
Set the value-range for the first parameter
}
procedure TSimulationClass.setP2range(vmin,vmax:double);
begin
  p2min:=vmin;
  p2max:=vmax;
end;
{
Set the timestep
}
procedure TSimulationClass.setTimestep(deltaT:double);
begin
  dT:=deltaT;
  updateTimelist();
end;
{
Set the alpha
}
procedure TSimulationClass.setalpha(alp:double);
begin
  alpha:=alp;
end;
{
switch the T fitting
}
procedure TSimulationClass.setTfitting(dofit:boolean);
begin
  self.doTfitting:=dofit;
end;
{
was fitting switched on?
}
function TSimulationClass.getTfitting():boolean;
begin
  getTfitting:=self.doTfitting;
end;
{
Set the maximum number of iterations
}
procedure TSimulationClass.setMaximumIterations(imax:integer);
begin
  maxiter:=imax;
  setlength(snlist,maxiter+1);  //+1 since we start at 0
  setlength(timelist,maxiter+1);
  updateTimelist();
end;
{
update the list of times used during the iterations.
}
procedure TSimulationClass.updateTimelist();
var
nr:integer;
begin
for nr:=low(timelist) to high(timelist) do timelist[nr]:=nr*dT;
end;
{
Set the alpha
}
procedure TSimulationClass.setArrayDim(width,height:integer);
begin
  nx:=width;
  ny:=height;
end;
{
Initialize the arrays on zero
}
procedure TSimulationClass.clearArrays();
var
  nrx,nry:integer;
begin
  for nrx:=1 to nx do
    begin
    for nry:=1 to ny do
      begin
        self.DomeEndPos[nrx,nry]:=0.0;
        self.DomeGuessT[nrx,nry]:=0.0;
        self.DomeFitT[nrx,nry]:=0.0;
        self.DomeFitErrorT[nrx,nry]:=0.0;
        self.Flips[nrx,nry]:=0;
        self.ErrorCodes[nrx,nry]:=0;
      end;
    end;

end;

{
Run the simulation and update the progress-bar.
}
procedure TSimulationClass.RunSimulation(Progress:TProgressbar);
var
 nrx, nry:integer;
 facx,facy: double;
 s0,s1: double;
begin
progress.Position:=0;
setGlobalPrefactors();

facx:=(p1max-p1min)/(nx-1);
facy:=(p2max-p2min)/(ny-1);
for nrx:=1 to nx do
  begin
  s0:=P1min+facx*(nrx-1);
  for nry:=1 to ny do
    begin
    s1:=P2min+facy*(nry-1);
    //Run the Dome-Function
    DomeFunction(s0,s1,nrx,nry);
    end;
  progress.StepIt;
  progress.Refresh;
  end;

end;

end.
