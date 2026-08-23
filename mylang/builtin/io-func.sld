(define-library (mylang builtin io-func)
  (export)
  (import (scheme base)
	  (scheme write)
	  (mylang values)
	  (mylang interpreter)
	  (mylang builtin database))
  (begin
    (entry-builtin-names! (list "write")
      (lambda (interp)
	(display
	 (value->write-string
	  (stack-pop! interp)))))))
