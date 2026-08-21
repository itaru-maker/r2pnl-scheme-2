(define-library (mylang tokens)
  (export
   period? the-period
   semicolon? the-semicolon
   r-paren? the-r-paren
   l-paren? the-l-paren)
  (import (scheme base))
  (include "tokens.scm"))
