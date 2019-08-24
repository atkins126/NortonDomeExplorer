unit r0r1AbsSimClass;
{Child class running the simulation model based on 2 initial start positions along
a 1D radial dome.}

interface
uses
  sysutils, math, SimulationClass, fitting;

type
  TR0R1AbsSimClass = class(TSimulationClass)
      private
        // some prefactors
        f1, p1 : double;
        //some factors for fitting:
        fitf1, fitf2, fitf3: double; // the factors needed for the function and derivative evaluation.
      public
        constructor create();
        procedure setGlobalPrefactors();override;
        procedure DomeFunction(r0,r1:double; nrx,nry:integer);override;  // s0,s1 setup for the generalized dome  var endvalue, fitT,errorT, guessT: double; var flips, error:integer)
        function  GuessTFunction(var error: integer ):double;override;  // should have the format defined in TGuessTFunction
        procedure FitDeriveFunction(xx:double; a:glmma; var yfit:double; var dyda:glmma; mma:integer);override;
                //that evaluates the fitting function yfit and its derivatives dyda
                //with respect to the parameters a at point xx.
  end;


implementation

constructor TR0R1AbsSimClass.create();
begin
  inherited create(); //the inherited part of the create function from the TSimulationClass
  f1 := 0.0;    // these parameters will be set correctly once setGlobalPrefactors is run.
  p1 := 0.0;
  fitf1 := 0.0;
  fitf2 := 0.0;
  fitf3 := 0.0;
end;

{
calculate constant prefactors once for the entire simulation.
}
procedure  TR0R1AbsSimClass.setGlobalPrefactors();
begin
// set some constant parameters for the function evaluation
p1:=alpha;
f1:=dt*dt;

// set the global factore required for evaluation of function and derivative:
fitf2:=(2.0)/(1.0-alpha);
fitf3:=(1.0+alpha)/(1.0-alpha);
fitf1:=power((1.0-alpha)/(sqrt(2*(1.0+alpha))),fitf2);
end;

{
 The actual dome-function as function of r (r=arclength)
}
{*
General shape:
R(n)=-R(n-2) + 2 R(n-1) + dT**2 ABS[R(n-1)]**(a)

Error-codes:
  0 : all is well
  1 : division by zero
  2 : EOverFlow
  3 : EInvalidOp
*}
procedure TR0R1AbsSimClass.DomeFunction(r0,r1:double; nrx,nry:integer);// var endvalue, fitT, errorT, guessT: double; var flips, error:integer);
const
 thress : double = 1.0E-5;
 maxitfit : integer = 1000 ;
var
nr, error2:integer;
sgn:TValueSign;
begin
flips[nrx,nry]:=0;
errorcodes[nrx,nry]:=0;
DomeFitT[nrx,nry]:=0;
DomeGuessT[nrx,nry]:=0.0;
snlist[0]:=r0;
snlist[1]:=r1;
DomeEndPOS[nrx,nry]:=r1;
//initialisation
for nr:=2 to maxiter do
  begin
  snlist[nr]:=0.0
  end;

//the real deal ...
sgn:=sign(snlist[1]);
for nr:=2 to maxiter do
  begin
  try
    snlist[nr]:=-snlist[nr-2] + 2*snlist[nr-1] + sign(snlist[nr-1])*f1*power(Abs(snlist[nr-1]),p1);
  except
    on EZeroDivide do
      begin
      errorcodes[nrx,nry]:=1;
      DomeEndPOS[nrx,nry]:=snlist[nr-1];
      exit;
      end;
    on EOverFlow do
      begin
      errorcodes[nrx,nry]:=2;
      if (abs(snlist[nr-2])<1.0E-10) then errorcodes[nrx,nry]:=1;
      DomeEndPOS[nrx,nry]:=snlist[nr-1];
      exit;
      end;
    on EInvalidOp do
      begin
      errorcodes[nrx,nry]:=3;
      DomeEndPOS[nrx,nry]:=snlist[nr-1];
      exit;
      end;
   end;//try-except
   if (sign(snlist[nr])<>sgn) then
    begin
        inc(flips[nrx,nry]);
        sgn:=sign(snlist[nr])
    end;
  end; //for

DomeEndPOS[nrx,nry]:=snlist[maxiter];

if (abs(DomeEndPOS[nrx,nry])>1.0E60) then //this generally means we are at a problematic point
  begin
  writeln('r0=',r0,' r1=',r1);
  writeln(' list:',snlist[5],snlist[10],snlist[20],snlist[50],snlist[100], snlist[150],snlist[200],snlist[210],snlist[220],snlist[230],snlist[240],snlist[248],snlist[249],snlist[250] );
  errorcodes[nrx,nry]:=4;
  exit;
  end;

if (errorcodes[nrx,nry]=0) then
  begin
  FitData(timelist,snlist,maxiter,alpha,self.doTfitting,DomeGuessT[nrx,nry],DomeFitT[nrx,nry],DomeFitErrorT[nrx,nry],error2,thress,maxitfit,GuessTFunction,FitDeriveFunction);
  end;
end;

{
Guess the T value in a simple way.
}
function TR0R1AbsSimClass.GuessTFunction(var error: integer ):double;
begin
error:=0;
//make a first estimate guess for T
GuessTFunction:= timelist[maxiter]-(sqrt(2.0*(1.0+alpha))/(1.0-alpha))* power(Abs(snlist[maxiter]),(1.0-alpha)*0.5);
end;
{
returns the function evaluation and derivatives
}
procedure TR0R1AbsSimClass.FitDeriveFunction(xx:double; a:glmma; var yfit:double; var dyda:glmma; mma:integer);
begin
yfit:=fitf1*power(xx-a[1],fitf2);
dyda[1]:=-fitf1*fitf2*power(xx-a[1],fitf3);
end;

end.
