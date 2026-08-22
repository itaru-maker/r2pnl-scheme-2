(define-library (mylang values)
  (export
   nil-value? the-nil ;にlは一つでいいので
;   make-label-value label-value? label-value-token
   make-symbol-value symbol-value? symbol-value-token
   make-lazy-value lazy-value? lazy-value-token
   make-block-value block-value? block-value-items block-value-items-set!
   block-value-append!
   make-lambda-value lambda-value? lambda-value-params lambda-value-body lambda-value-env lambda-value-line call-lambda!
   value->write-string)
  (import (scheme base)
	  (scheme write)
	  (mylang tokens))
  (include "values.scm"))
   
