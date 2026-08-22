;(set! %load-extensions (cons ".sld" %load-extensions));guile用に書くべきだそう（gauche派ですが、)

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
	(mylang builtin io-func))

(define mylang (make-interp));インスタンス化




(interp-run mylang ". display . add 3 \"hello\" ;")
	
