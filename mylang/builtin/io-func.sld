(define-library (mylang builtin io-func)
  (export io-func-dict)
  (import (scheme base)
	  (scheme write)
	  (mylang values)
	  (mylang interpreter))
  (begin
      (define  (write-func interp)
	(display
	 (value->write-string
	  (stack-pop! interp))))

      (define io-func-dict
	`(("write" . ,write-func)))))
