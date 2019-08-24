unit Colorlists;
{Build a specific 255 item color list.}

interface
  uses
  Windows,//for rgb
  Graphics; // for TColor


type TColorList = array[0..255] of TColor;

procedure GetColorList(ctype:integer; var list:TColorList);


implementation

procedure GetColorList(ctype:integer; var list:TColorList);
var
nr, nr1 : integer;
sublist: array[0..255] of TColor;
begin
case ctype of
  0:  begin
      for nr:=0 to 255 do
        begin
        list[nr]:=rgb(nr,nr,nr);
        end;
      end;//case 0
  1:  begin
      for nr:=0 to 255 do
        begin
        list[nr]:=rgb(nr,0,0);
        end;
      end;//case 0
  2:  begin
      for nr:=0 to 255 do
        begin
        list[nr]:=rgb(0,nr,0);
        end;
      end;//case 0
  3:  begin
      for nr:=0 to 255 do
        begin
        list[nr]:=rgb(0,0,nr);
        end;
      end;//case 0
  108: begin
        sublist[0]:=rgb(0,0,0);
        sublist[1]:=rgb(255,0,0);
        sublist[2]:=rgb(0,255,0);
        sublist[3]:=rgb(255,255,0);
        sublist[4]:=rgb(0,0,255);
        sublist[5]:=rgb(255,0,255);
        sublist[6]:=rgb(0,255,255);
        sublist[7]:=rgb(255,255,255);

      for nr1:=0 to 7 do  begin
      for nr:=0 to 31 do
        begin
        list[nr1*32 + nr]:=sublist[nr1];
        end;end;
      end;//case 0
  200:begin
      for nr:=0 to 127 do
        begin
        list[nr]:=rgb(0,0,(127-nr)*2);
        list[nr+128]:=rgb(nr*2,0,0);
        end;
      end;//case 0
end; //case

end;

end.
