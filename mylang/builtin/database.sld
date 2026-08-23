(define-library (mylang builtin database)
  (export
   *builtin*
   entry-builtin!
   entry-builtin-names!)
  (import (scheme base))
  (begin
    ;;builtin関数を貯める場所ですね

    (define *builtin* '())
    
    (define (entry-builtin! name proc)
      (set! *builtin* (cons (cons name proc) *builtin*)))

    (define (entry-builtin-names! names proc)
      (for-each
       (lambda
	   (n) (entry-builtin! n proc)) names))))
