all :
	autoheader
	autoconf
	ls -l configure.ac configure
	./configure
	cat foo.in
	cat foo 
clean : ; rm -rf autom4te.cache config.log config.status configure foo config.h config.h.in *~
