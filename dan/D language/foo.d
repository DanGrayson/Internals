b := true;
export c := 345;
(x:int) + (y:int) ::= Ccode(int,"(",x," + ",y,")");
d := 2 + 2;
i := if b then 11 else 22;
X := {  x:int, y:int};
Y := {+ a:int, b:int, c:bool};
Z := {+ d:int, e:int};
z := Z(3,4);
W := tarray(Z);
WW := tarray(Z);
WWW := tarray(Z);
WWWW := tarray(Z);
U := Y or Z or tarray(Z);
foo ( u:U ) : int := (
     when u
     is y:Y do y.a
     is z:Z do z.d
     is w:WWW do 44
     );
w := new WWW len 2 do provide z;
u := U(w);
bar () : U := Y(111,222,true);
car () : U := Z(333,444);
u1 := bar();
u2 := car();
foo(x:int,y:int):int := 2;
export foo():int := 1;
export foo(x:int):int := 1;
