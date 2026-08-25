;;(set! %load-extensions (cons ".sld" %load-extensions));guileの人は書く
#|===実行方法===
gauche
gosh -r7 -I. main.scm
chibi
chibi-scheme main.scm
kawa
kawa -Dkawa.import.path="./*.sld" --r7rs main.scm
sash
sash -r7 -L . main.scm
guile
guile --r7rs -L . main.scm
==================
|#

(import (scheme base)
	(scheme write)
	(mylang values)
	(mylang tokens)
	(mylang env)
	(mylang lexar)
	(mylang parser)
	(mylang error)
	(mylang interpreter)
	(mylang builtin prelude))

(define mylang (make-interp all-builtins));インスタンス化


(interp-run mylang "
. add 3 4 ;
. write \"ミクーッ！！ミクーッ！！ヒャー！！おわっほあああああああああああああああああああああああああああああああああ！！\"  ;
. write ;
. write write ;


")

(newline)


