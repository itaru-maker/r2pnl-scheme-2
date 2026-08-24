;;(set! %load-extensions (cons ".sld" %load-extensions));guileの人は書く
#|===実行方法===
gauche
gosh -r7 -I. main.scm
chibi
chibi-scheme main.scm
kawa
kawa -Dkawa.import.path="./*.sld" --r7rs main.scm
|#

(import (scheme base)
	(scheme write)
	(mylang values)
	(mylang tokens)
	(mylang env)
	(mylang lexar)
	(mylang parser)
	(mylang error)
	(mylang builtin database)
	(mylang interpreter)
	(mylang builtin math-func)
	(mylang builtin io-func)
	(mylang builtin var-func))

(define mylang (make-interp));インスタンス化




(interp-run mylang "
. write \"ミクーッ！！ミクーッ！！ヒャー！！おわっほあああああああああああああああああああああああああああああああああ！！\"  ;
. write write ;
. write \" ;

")



