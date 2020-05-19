dnl This creates the initial part of the "configure" script:

AC_INIT(Macaulay2,[m4_esyscmd_s([cat VERSION])],Macaulay2@math.uiuc.edu, Macaulay2, http://macaulay2.com/)

dnl This tells what files need to be configured:
AC_CONFIG_FILES(foo)

dnl these are shell commands:
: This is text to be passed through.
: [Matching brackets are removed.]
# [Except in shell comments.]
ISSUE=foobar
echo ++ hi there

dnl The system is based on "m4"
define(bar,echo == this is an m4 macro $1 $2 $3)
bar(a,b,c)

dnl You can define your own macros
AC_DEFUN(foo,echo == $1 -- $2)
foo(hello,there)
foo(goodbye,now)
dnl macros swallow two levels of brackets
foo(  [hello,goodbye]  ,now)
foo( [[hello,goodbye]] ,now)
foo([[[hello,goodbye]]],now)

AC_SUBST(ISSUE) dnl this declares a substitution variable
AC_MSG_NOTICE([with ISSUE = $ISSUE])

AC_CONFIG_HEADERS(config.h)
AC_DEFINE(FOOBAR,,[hi there])
AC_DEFINE(FOOBAR,1,[hi there 1])
AC_DEFINE(FOOBAR,2,[hi there 2])
FOOBAR=3

dnl This creates the final part of the "configure" script:
AC_OUTPUT()

dnl Local Variables:
dnl mode: autoconf
dnl End:
