(define-library (mylang builtin database)
  (export
   *builtin*
   entry-builtin!
   entry-builtin-names!)
  (import (scheme base))
  (include "database.scm"))
