(define-library (mylang builtin math-func)
  (export);ない袖は触れぬ
  (import (scheme base)
	  (mylang interpreter)
	  (mylang builtin database))
  (include "math-func.scm"))
