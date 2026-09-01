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

    (define (pack-func interp)
      (let* ((args-count (stack-pop! interp)))
        (if (number? args-count)
            (let loop ((count args-count) (acc-block '()))
              (if (zero? count)
                  (stack-push! interp (make-block-value (reverse acc-block)))
                  (loop (- count 1) (cons (cons (stack-pop! interp) (interp-token-line interp)) acc-block))))
            (interp-error! interp "TypeError" "The first arg of the \"pack\" func must be a number"))))

    (define (null-block?-func interp)
      (let* ((block (stack-pop! interp)))
        (if (block-value? block)
            (stack-push! interp (null? (block-value-items block)))
            (interp-error! interp "TypeError" "the null-block? func expects 1 block-value"))))

    (define (cons-func interp)
      (let* ((value (stack-pop! interp))
             (block (stack-pop! interp)))
        (if (block-value? block)
            (stack-push! interp
                         (make-block-value
                          (cons (cons value (interp-token-line interp))
                          (block-value-items block))))
            (interp-error!
             interp
             "TypeError" "The second arg of the \"cons\" func must be a block"))))



     (define block-func-dict
      `(("head" . ,head-func)
        ("tail" . ,tail-func)
        ("pack" . ,pack-func)
        ("null-block?" . ,null-block?-func)
        ("cons" . ,cons-func)))))



