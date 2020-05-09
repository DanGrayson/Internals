# get a copy of the program scc1 by building Macaulay2 -- it is in Macaulay2/c inside your build directory --
# and put it on the PATH for use here.

all : foo
foo : foo.d
	scc1 -noline foo.d
	scc1 -typecodes
clean : ; rm -f *.tmp *-tmp.c typecode.db
