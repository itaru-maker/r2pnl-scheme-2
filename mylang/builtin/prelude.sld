(define-library (mylang builtin prelude)
  (export all-builtins)
  (import (scheme base)
	  (scheme write)
	  (mylang builtin math-func)
	  (mylang builtin io-func)
	  (mylang builtin var-func)
	  (mylang builtin stack-func)
	  (mylang builtin control-func)
          (mylang builtin lambda-func)
          (mylang builtin comp-func))

  (begin
    (define all-builtins
      (append
       math-func-dict
       io-func-dict
       var-func-dict
       stack-func-dict
       control-func-dict
       lambda-func-dict
       comp-func-dict))))
