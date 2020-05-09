b := true;
export c := 345;
(x:int) + (y:int) ::= Ccode(int,"(",x," + ",y,")");
d := 2 + 2;
i := if b then 11 else 22;
X := {  x:int, y:int};
Y := {+ a:int, b:int, c:bool};
Z := {+ d:int, e:int};
U := Y or Z;
foo ( u:U ) : int := (
     when u
     is y:Y do y.a
     is z:Z do z.d
     );
bar () : U := Y(111,222,true);
car () : U := Z(333,444);
u1 := bar();
u2 := car();
