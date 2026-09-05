(define-library (mylang builtin control-func)
  (export control-func-dict)
  (import (scheme base)
          (mylang values)
          (mylang tokens)
          (mylang interpreter)
          (mylang parser))

  (begin
    (define (exec-func interp)
      ;;一つのブロックを実行する
      (let ((block (stack-pop! interp)))
        (if (not (block-value? block))
            (interp-error! interp
                           "TypeError"
                           (string-append
                            "the exec func is expects block args but"
                            (value->write-string block)))

            (exec-block block interp))))

    (define (if-func interp)
      (let*
          ((condition (stack-pop! interp))
           (true-then (stack-pop! interp))
           (false-then (stack-pop! interp)))
      (if (or
           (eq? #f condition)
           (nil-value? condition))
          (stack-push! interp false-then)
          (stack-push! interp true-then))))

    (define (if-exec-func interp)
      (let*
          ((condition (stack-pop! interp))
           (true-then (stack-pop! interp))
           (false-then (stack-pop! interp)))
        (if (not (and (block-value? true-then) (block-value? false-then)))
            (interp-error! interp "TypeError" "if-exec func expects one any value and two block args."))
        (if (or
             (eq? #f condition)
             (nil-value? condition))
            (exec-block false-then interp)
            (exec-block true-then interp))))

    

    (define (while-func interp)
      (let*
          ((cond-block (stack-pop! interp))
           (body (stack-pop! interp)))
        (if (or (not (block-value? cond-block)) (not (block-value? body)))
            (interp-error! interp "TypeError" "the while func expects two block args")
            (let loop ()                ;このループを回す
              (exec-block cond-block interp)
              (let ((now-cond (stack-pop! interp)))
                (if (or (eq? the-nil now-cond) (eq? #f now-cond))
                    '()                 ;終わり。何もしない
                    (begin
                      (exec-block body interp)
                      (loop))))))))

    (define (repeat-func interp)
      (let*
          ((repeat-count (stack-pop! interp))
           (repeat-body (stack-pop! interp)))
        (if (not (and
                  (number? repeat-count)
                  (< 0 repeat-count)
                  (block-value? repeat-body)))
            (interp-error! interp "TypeError" "the repeat func expects a positive number and a block value")
            (let loop ((current-num 0) (limit (truncate repeat-count)))
              (if (< limit current-num)
                  '()
                  (begin
                   (exec-block repeat-body interp)
                   (loop (+ current-num 1) limit)))))))


    (define control-func-dict
      `(("exec" . ,exec-func)
        ("if" . ,if-func)
        ("if-exec" . ,if-exec-func)
        ("while" . ,while-func)
        ("repeat" . ,repeat-func))
      )))


