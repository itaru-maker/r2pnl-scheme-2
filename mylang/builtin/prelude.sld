(define-library (mylang builtin prelude)
  (export all-builtins)
  (import (scheme base)
	  (scheme write)
	  (mylang builtin math-func)
	  (mylang builtin io-func)
	  (mylang builtin var-func))

  (begin
    (define all-builtins
      (append
       math-func-dict
       io-func-dict
       var-func-dict))))
