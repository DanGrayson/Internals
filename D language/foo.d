b := true;
i := if b then 11 else 22;
export X := {  x:int, y:int};
export Y := {+ a:int, b:int, c:bool};
export Z := {+ d:int, e:int};
export U := Y or Z;
export foo ( u:U ) : int := (
     when u
     is y:Y do y.a
     is z:Z do z.d
     );
export bar () : U := Y(111,222,true);
export car () : U := Z(333,444);
