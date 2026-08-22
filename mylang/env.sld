(define-library (mylang env)
  (export
   make-env
   env?
   in-env?
   env-define
   env-set!
   env-get)
  (import (scheme base)
	  (scheme write))
  (include "env.scm"))
