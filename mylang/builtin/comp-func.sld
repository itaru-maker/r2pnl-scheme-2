(define-library (mylang builtin comp-func)
  (export comp-func-dict)
  (import (scheme base)
          (mylang values)
          (mylang tokens)
          (mylang interpreter))
  (begin
    (define (is-func interp)
      (let*
          ((a (stack-pop! interp))
           (b (stack-pop! interp)))
        (stack-push! interp (eq? a b))))

    (define (eq-func interp)
      (let*
          ((a (stack-pop! interp))
           (b (stack-pop! interp)))

        (cond
         ((and (number? a) (number? b))
          (equal? a b))
         
         ((and (string? a) (string? b))
          (equal? a b))

         ((and (eq? a #t) (eq? a #t))
          #t)

         ((and (not a) (not b))
          #t)

         ((and (nil-value? a) (nil-value? b))
          #t)

         ((and (symbol-value? a) (symbol-value? b))
          (equal? (symbol-value-token a) (symbol-value-token b)))
         ;わざわざtoken取らなくてもいいのかな

         ((and (lazy-value? a) (lazy-value? b))
          (equal? (lazy-value-token a ) (lazy-value-token b)))

         ((and (block-value? a) (block-value? b))
          (equal? a b));これでいいの？

         ((and (builtin-func? a) (builtin-func? b))
          (equal? a b))

         ((and (lambda-value? a) (lambda-value? b))
          (equal? a b))

         ((and (trigger? a) (trigger? b))
          #t)

         ((and (semicolon? a) (semicolon? b))
          #t)

         ((and (r-paren? a) (l-paren? b))
          #t)

         ((and (l-paren? a) (l-paren? b))
          #t)

         (else (interp-error! interp "InterpreterError!" "unknown word!!")))))
    (define comp-func-dict
      `(("is?" . ,is-func)
        ("=" . ,eq-func)))))
