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
        (stack-push! interp
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
           ;;わざわざtoken取らなくてもいいのかな

           ((and (lazy-value? a) (lazy-value? b))
            (equal? (lazy-value-token a ) (lazy-value-token b)))

           ((and (block-value? a) (block-value? b))
            (equal? (block-value-items a) (block-value-items b)));これでいいの？<=よくないです。作られた行が違うと偽になる。のちに改善
           
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

           (else #f)))))
    (define (lt-func interp)
      (let* ((num-1 (stack-pop! interp))
             (num-2 (stack-pop! interp)))
        (if (not (and (number? num-1) (number? num-2)))
            (interp-error! interp "TypeError" "< func expects two number args")
            (stack-push! interp (< num-1 num-2)))))

    (define (gt-func interp)
      (let* ((num-1 (stack-pop! interp))
             (num-2 (stack-pop! interp)))
        (if (not (and (number? num-1) (number? num-2)))
            (interp-error! interp "TypeError" "> func expects two number args")
            (stack-push! interp (> num-1 num-2)))))

    (define (le-func interp)
      (let* ((num-1 (stack-pop! interp))
             (num-2 (stack-pop! interp)))
        (if (not (and (number? num-1) (number? num-2)))
            (interp-error! interp "TypeError" "<= func expects two number args")
            (stack-push! interp (<= num-1 num-2)))))

    (define (ge-func interp)
      (let* ((num-1 (stack-pop! interp))
             (num-2 (stack-pop! interp)))
        (if (not (and (number? num-1) (number? num-2)))
            (interp-error! interp "TypeError" ">= func expects two number args")
            (stack-push! interp (>= num-1 num-2)))))

    
    (define comp-func-dict
      `(("is?" . ,is-func)
        ("=" . ,eq-func)
        ("<" . ,lt-func)
        (">" . ,gt-func)
        ("<=" . ,le-func)
        (">=" . ,ge-func)
        ("lt" . ,lt-func)
        ("gt" . ,gt-func)
        ("le" . ,le-func)
        ("ge" . ,ge-func)))))
