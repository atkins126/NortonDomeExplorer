unit fitting;
{This module provides the required function for our fitting.
The (non-linear least-squares) fitting is performed using the
Levelberg-Marquardt method. For the latter the implementation of
numerical recipes is used.}

interface
 uses
    Math;

 TYPE
{* Listing of the types of all input arrays used in this module:

   glndata = ARRAY [1..ndata] OF real;
   glmma = ARRAY [1..mma] OF real;
   gllista = ARRAY [1..mma] OF integer;   //B
   glncabynca = ARRAY [1..nca,1..nca] OF real;    //A
   glnalbynal = ARRAY [1..nalp,1..nalp] OF real;  //=A
   glnpbynp = ARRAY [1..np,1..np] OF real; //=A
   glnpbymp = ARRAY [1..np,1..mp] OF real; //~A
   glnp = ARRAY [1..np] OF integer;   //=B
   glcovar = ARRAY [1..ncvm,1..ncvm] OF real; //=A
   gllista = ARRAY [1..mfit] OF integer;  //=B
   glnalbynal = ARRAY OF ARRAY OF real;
   *}

   glndata = ARRAY OF double;
   glmma = ARRAY OF double;
   gllista = ARRAY OF integer;
   glncabynca = ARRAY OF ARRAY OF double;

{Some magic stuff with functions:}
TGuessTFunction = function (var error: integer ):double of object;  //the 'of object' allows us to use methods from an object.
TDerivFunction = procedure (xx:double; a:glmma; var yfit:double; var dyda:glmma; mma:integer) of object;


  procedure FitData(xval,yval:array of double; ny:integer; alp:double; dofit:boolean;
                    var Tguess, Tfit, Terror: double; var error:integer; thress: double;
                    maxit:integer;
                    fguessT:TGuessTFunction;
                    funcs  :TDerivFunction);
//procedure funcs(xx:double; a:glmma; var yfit:double; var dyda:glmma; mma:integer);
//that evaluates the fitting function yfit and its derivatives dyda
//with respect to the parameters a at point xx.


  {NR functions
  }
  PROCEDURE mrqmin(x,y,sig: glndata; ndata: integer;
       VAR a: glmma; mma: integer; lista: gllista;
       mfit: integer; VAR covar,alpha: glncabynca;
       nca: integer; VAR chisq,alamda: double;
       funcs:TDerivFunction);

  PROCEDURE mrqcof(x,y,sig: glndata; ndata: integer;
       VAR a: glmma; mma: integer; lista: gllista;
       mfit: integer; VAR alpha: glncabynca;
       VAR beta: glmma; nalp: integer; VAR chisq: double;
       funcs:TDerivFunction);

  PROCEDURE gaussj(VAR a: glncabynca; n,np: integer;
       VAR b: glncabynca; m,mp: integer);

  PROCEDURE covsrt(VAR covar: glncabynca; ncvm: integer; ma: integer;
       lista: gllista; mfit: integer);
(* Programs using routine COVSRT must define the types
TYPE
   glcovar = ARRAY [1..ncvm,1..ncvm] OF real;
   gllista = ARRAY [1..mfit] OF integer;
in the calling program. *)



implementation

VAR
   glochisq: double;
   glbeta: glmma;

//some own global varaible for indicating the dimensions of the arrays
    mgl_ndata : integer;  // for ndata--> # of datapoints   (x,y,sig): glndata
    mgl_mma   : integer;  // for fitparam--> # of fitparam  (a,lista,covar,alpha): glmma, glncabynca


{*
Error-codes:
 1 : Guess for big T is bigger than the largest t-5 value in the xval list. The returned fitted T is the guess value
 2 : Did not converge within maxit steps. The Fitted T are the best guess values.
*}

procedure FitData(xval,yval:array of double; ny:integer; alp:double; dofit:boolean;
                  var Tguess, Tfit, Terror: double; var error:integer; thress: double;
                  maxit:integer;
                  fguessT:TGuessTFunction;
                  funcs  :TDerivFunction);
var
x,y,sig:glndata;
nr,Tgindex:integer;
a: glmma;
lista: gllista;
covar,alpha: glncabynca;
chiq, chiold, reldchi, lambda: double;
done:boolean;
begin
error:=0;
Terror:=0.0;
Tfit:=0.0;

Tguess:=fguessT(error);
if (error>0) then
  begin
  Tfit := 0.0;
  exit;
  end;

if (dofit) then
  begin
Tgindex:=0;
if (Tguess>0)and(Tguess<xval[ny]) then
  begin
  Tgindex:=trunc(Tguess/((xval[ny]-xval[1])/(ny-1)));
  end
else
  begin
  if (Tguess<=0 ) then tgindex:=0;
  if (tguess>=xval[ny]) then tgindex:=ny;
  end;

if (Tgindex<1) then Tgindex:=1;
if ((Tgindex+5)>=ny) then //make sure we have at least 4 points for fitting
    begin
        error := 1;
        Tfit := Tguess;
        exit;
    end;
mgl_mma:=1; //we only have one parameter: T
setlength(a, mgl_mma+1);//+1 because we start at 0...and the functions start from 1
setlength(lista,mgl_mma+1);
setlength(glbeta,mgl_mma+1);
// If we arrive at this point, it is possible to fit
// setup our arrays:
mgl_ndata:=ny-Tgindex;
setlength(x,mgl_ndata+1);
setlength(y,mgl_ndata+1);
setlength(sig,mgl_ndata+1);
for nr:=Tgindex to ny do
  begin
  x[nr-Tgindex]:=xval[nr];
  y[nr-Tgindex]:=yval[nr];
  sig[nr-Tgindex]:=1.0; //standard deviation set to 1.0. SInce it is unknown and chisqr is inversely related to sigma.
  end;

//a also provides a starting guess:
a[1]:=Tguess;
lista[1]:=1;
setlength(covar,mgl_mma+1,mgl_mma+1);
setlength(alpha,mgl_mma+1,mgl_mma+1);

//initialisation call, with negative alambda value
lambda:=-1.0;
mrqmin(x,y,sig,mgl_ndata, //x-y data & standard deviation
        a, mgl_mma,         //parameter list of the function
        lista, mgl_mma,
        covar,alpha, //work arrays
        mgl_mma, chiq, lambda,funcs);
//converge or minimize Chi^2
done:=false;
nr:=0;
while ((abs(chiq)>thress)and(not(done))) do
  begin
  inc(nr);
  chiold:=chiq;
  mrqmin(x,y,sig,mgl_ndata, a, mgl_mma, lista, mgl_mma, covar,alpha, mgl_mma, chiq, lambda,funcs);
  if (nr>=maxit) then
    begin
    error:=2;
    TFit:=a[1]; //best guess
    exit;
    end;
    reldchi:=abs((chiold-chiq)/chiq);
    if (reldchi<thress) then  done:=true;
  end;
//finalization call with alambda=0, to get covariance matrix covar and curvature matrix alpha
lambda:=0.0;
mrqmin(x,y,sig,mgl_ndata, a, mgl_mma, lista, mgl_mma, covar,alpha, mgl_mma, chiq, lambda,funcs);
TError:=sqrt(covar[1,1]);//gives the uncertainty on T from the fit
TFit:=a[1];
end
else  //if no fit is done
begin
Tfit:=0.0;
end;
end;//end of fitting procedure

////////////////// ALL FUNCTIONS BELOW ARE NR-FUNCTIONS FOR FITTING /////////////

PROCEDURE mrqmin(x,y,sig: glndata; ndata: integer;
       VAR a: glmma; mma: integer; lista: gllista;
       mfit: integer; VAR covar,alpha: glncabynca;
       nca: integer; VAR chisq,alamda: double;
       funcs:TDerivFunction);
(* Programs using routine MRQMIN must define the types
TYPE
   glndata = ARRAY [1..ndata] OF real;
   glmma = ARRAY [1..mma] OF real;
   gllista = ARRAY [1..mma] OF integer;
   glncabynca = ARRAY [1..nca,1..nca] OF real;
and the variables
VAR
   glochisq: real;
   glbeta: glmma;
in the main routine. Also note that this routine calls MRQCOF, which
requires a user-defined procedure FUNCS, described in that routine.   *)
VAR
   k,kk,j,ihit: integer;
   atry,da: glmma;
   oneda: glncabynca;
BEGIN
setlength(atry,mgl_mma+1);//+1 since dynamic arrays start at 0
setlength(da,mgl_mma+1);
setlength(oneda,mgl_mma+1,mgl_mma+1);

   IF (alamda < 0.0) THEN BEGIN
      kk := mfit+1;
      FOR j := 1 TO mma DO BEGIN
         ihit := 0;
         FOR k := 1 TO mfit DO BEGIN
            IF (lista[k] = j) THEN ihit := ihit+1
         END;
         IF (ihit = 0) THEN BEGIN
            lista[kk] := j;
            kk := kk+1
         END ELSE IF (ihit > 1) THEN BEGIN
            writeln('pause 1 in routine MRQMIN');
            writeln('Improper permutation in LISTA'); readln
         END
      END;
      IF (kk <> (mma+1)) THEN BEGIN
         writeln('pause 2 in routine MRQMIN');
         writeln('Improper permutation in LISTA'); readln
      END;
      alamda := 0.001;
      mrqcof(x,y,sig, ndata, a, mma, lista, mfit, alpha, glbeta, nca, chisq,funcs);
      glochisq := chisq;
      FOR j := 1 TO mma DO BEGIN
         atry[j] := a[j]
      END
   END;
   FOR j := 1 TO mfit DO BEGIN
      FOR k := 1 TO mfit DO BEGIN
         covar[j,k] := alpha[j,k]
      END;
      covar[j,j] := alpha[j,j]*(1.0+alamda);
      oneda[j,1] := glbeta[j]
   END;
   gaussj(covar,mfit,nca,oneda,1,1);
   FOR j := 1 TO mfit DO da[j] := oneda[j,1];
   IF (alamda = 0.0) THEN BEGIN
      covsrt(covar,nca,mma,lista,mfit);
      exit;
   END;
   FOR j := 1 TO mfit DO BEGIN
      atry[lista[j]] := a[lista[j]]+da[j]
   END;
   mrqcof(x,y,sig,ndata,atry,mma,lista,mfit,covar,da,nca,chisq,funcs);
   IF (chisq < glochisq) THEN BEGIN
      alamda := 0.1*alamda;
      glochisq := chisq;
      FOR j := 1 TO mfit DO BEGIN
         FOR k := 1 TO mfit DO BEGIN
            alpha[j,k] := covar[j,k]
         END;
         glbeta[j] := da[j];
         a[lista[j]] := atry[lista[j]]
      END
   END ELSE BEGIN
      alamda := 10.0*alamda;
      chisq := glochisq
   END;

END;

PROCEDURE mrqcof(x,y,sig: glndata; ndata: integer;
       VAR a: glmma; mma: integer; lista: gllista;
       mfit: integer; VAR alpha: glncabynca;
       VAR beta: glmma; nalp: integer; VAR chisq: double; funcs:TDerivFunction);
(* Programs using routine MRQMIN must provide a
PROCEDURE funcs(xx:real; a:glmma; yfit:real; dyda:glmma; mma:integer);
that evaluates the fitting function yfit and its derivatives dyda
with respect to the parameters a at point xx.  Also they
must define the types
TYPE
   glndata = ARRAY [1..ndata] OF real;
   glmma = ARRAY [1..mma] OF real;
   gllista = ARRAY [1..mma] OF integer;
   glnalbynal = ARRAY [1..nalp,1..nalp] OF real;
in the main routine *)
VAR
   k,j,i: integer;
   ymod,wt,sig2i,dy: double;
   dyda: glmma;
BEGIN
setlength(dyda,mgl_mma+1);// +1 since dynamical arrays are zerobased

   FOR j := 1 TO mfit DO BEGIN
      FOR k := 1 TO j DO BEGIN
         alpha[j,k] := 0.0
      END;
      beta[j] := 0.0
   END;
   chisq := 0.0;
   FOR i := 1 TO ndata DO BEGIN
      funcs(x[i],a,ymod,dyda,mma);
      sig2i := 1.0/(sig[i]*sig[i]);
      dy := y[i]-ymod;
      FOR j := 1 TO mfit DO BEGIN
         wt := dyda[lista[j]]*sig2i;
         FOR k := 1 TO j DO BEGIN
            alpha[j,k] := alpha[j,k]+wt*dyda[lista[k]]
         END;
         beta[j] := beta[j]+dy*wt
      END;
      chisq := chisq+dy*dy*sig2i
   END;
   FOR j := 2 TO mfit DO BEGIN
      FOR k := 1 TO j-1 DO BEGIN
         alpha[k,j] := alpha[j,k]
      END
   END
END;

PROCEDURE covsrt(VAR covar: glncabynca; ncvm: integer; ma: integer;
       lista: gllista; mfit: integer);
(* Programs using routine COVSRT must define the types
TYPE
   glcovar = ARRAY [1..ncvm,1..ncvm] OF real;
   gllista = ARRAY [1..mfit] OF integer;
in the calling program. *)
VAR
   j,i: integer;
   swap: double;
BEGIN
   FOR j := 1 TO ma-1 DO BEGIN
      FOR i := j+1 TO ma DO BEGIN
         covar[i,j] := 0.0
      END
   END;
   FOR i := 1 TO mfit-1 DO BEGIN
      FOR j := i+1 TO mfit DO BEGIN
         IF (lista[j] > lista[i])  THEN BEGIN
            covar[lista[j],lista[i]] := covar[i,j]
         END ELSE BEGIN
            covar[lista[i],lista[j]] := covar[i,j]
         END
      END
   END;
   swap := covar[1,1];
   FOR j := 1 TO ma DO BEGIN
      covar[1,j] := covar[j,j];
      covar[j,j] := 0.0
   END;
   covar[lista[1],lista[1]] := swap;
   FOR j := 2 TO mfit DO BEGIN
      covar[lista[j],lista[j]] := covar[1,j]
   END;
   FOR j := 2 TO ma DO BEGIN
      FOR i := 1 TO j-1 DO BEGIN
         covar[i,j] := covar[j,i]
      END
   END
END;

PROCEDURE gaussj(VAR a: glncabynca; n,np: integer;
       VAR b: glncabynca; m,mp: integer);
(* Programs using GAUSSJ must define the types
TYPE
   glnpbynp = ARRAY [1..np,1..np] OF real;
   glnpbymp = ARRAY [1..np,1..mp] OF real;
   glnp = ARRAY [1..np] OF integer;
in the main routine. *)
VAR
   big,dum,pivinv: double;
   i,icol,irow,j,k,l,ll: integer;
   indxc,indxr,ipiv: gllista;
BEGIN
setlength(indxc,mgl_mma+1);//+1 since dynamical arrays are zero-based
setlength(indxr,mgl_mma+1);
setlength(ipiv,mgl_mma+1);

   FOR j := 1 TO n DO BEGIN
      ipiv[j] := 0
   END;
   FOR i := 1 TO n DO BEGIN
      big := 0.0;
      FOR j := 1 TO n DO BEGIN
         IF (ipiv[j] <> 1) THEN BEGIN
            FOR k := 1 TO n DO BEGIN
               IF (ipiv[k] = 0) THEN BEGIN
                  IF (abs(a[j,k]) >= big) THEN BEGIN
                     big := abs(a[j,k]);
                     irow := j;
                     icol := k
                  END
               END ELSE IF (ipiv[k] > 1) THEN BEGIN
                  writeln('pause 1 in GAUSSJ - singular matrix'); readln
               END
            END
         END
      END;
      ipiv[icol] := ipiv[icol]+1;
      IF (irow <> icol) THEN BEGIN
         FOR l := 1 TO n DO BEGIN
            dum := a[irow,l];
            a[irow,l] := a[icol,l];
            a[icol,l] := dum
         END;
         FOR l := 1 TO m DO BEGIN
            dum := b[irow,l];
            b[irow,l] := b[icol,l];
            b[icol,l] := dum
         END
      END;
      indxr[i] := irow;
      indxc[i] := icol;
      IF (a[icol,icol] = 0.0) THEN BEGIN
         writeln('pause 2 in GAUSSJ - singular matrix'); readln
      END;
      pivinv := 1.0/a[icol,icol];
      a[icol,icol] := 1.0;
      FOR l := 1 TO n DO BEGIN
         a[icol,l] := a[icol,l]*pivinv
      END;
      FOR l := 1 TO m DO BEGIN
         b[icol,l] := b[icol,l]*pivinv
      END;
      FOR ll := 1 TO n DO BEGIN
         IF (ll <> icol) THEN BEGIN
            dum := a[ll,icol];
            a[ll,icol] := 0.0;
            FOR l := 1 TO n DO BEGIN
               a[ll,l] := a[ll,l]-a[icol,l]*dum
            END;
            FOR l := 1 TO m DO BEGIN
               b[ll,l] := b[ll,l]-b[icol,l]*dum
            END
         END
      END
   END;
   FOR l := n DOWNTO 1 DO BEGIN
      IF (indxr[l] <> indxc[l]) THEN BEGIN
         FOR k := 1 TO n DO BEGIN
            dum := a[k,indxr[l]];
            a[k,indxr[l]] := a[k,indxc[l]];
            a[k,indxc[l]] := dum
         END
      END
   END
END;

end.
