;(set! %load-extensions (cons ".sld" %load-extensions));guileの人は書く

(import (scheme base)
	(scheme write)
	(mylang values)
	(mylang tokens)
	(mylang env)
	(mylang lexar)
	(mylang parser)
	(mylang builtin database)
	(mylang interpreter)
	(mylang builtin math-func)
	(mylang builtin io-func)
	(mylang builtin var-func))

(define mylang (make-interp));インスタンス化



(interp-run mylang "
. write \"ミクーッ！！ミクーッ！！ヒャー！！おわっほあああああああああああああああああああああああああああああああああ！！\"  ;
. write write ;

")


