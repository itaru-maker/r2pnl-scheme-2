(define-library (mylang builtin block-func)
  (export
   block-func-dict)
  (import (scheme base)
          (scheme write)
          (mylang values)
          (mylang interpreter))
  (begin
    (define (head-func interp)
      (let* ((a (stack-pop! interp)))
        (cond
         ((not (block-value? a))
          (interp-error! interp "TypeError"  "the \"head\" func expects 1 block value."))

         ((null? (block-value-items a))
          (interp-error! interp "ValueError" "the \"head\" func expects a not null block"))

         (else
          (stack-push! interp (car (car (block-value-items a))))))))
    
    (define (tail-func interp)
      (let* ((a (stack-pop! interp)))
        (cond
         ((not (block-value? a))
          (interp-error! interp "TypeError"  "the \"head\" func expects 1 block value."))

         ((null? (block-value-items a))
          (interp-error! interp "ValueError" "the \"tail\" func expects a not null block"))

         (else
          (stack-push! interp (make-block-value(cdr (block-value-items a))))))))



    (define block-func-dict
      `(("head" . ,head-func)
        ("tail" . ,tail-func)))
    )

  )
