(define-library (mylang builtin control-func)
  (export control-func-dict)
  (import (scheme base)
          (mylang values)
          (mylang tokens)
          (mylang interpreter)
          (mylang parser))

  (begin
    (define (exec-block block interp)
      ;;blockを実行（外には渡さない）
      (let*
          ((sentences (tokens->sentences (block-value-items block))))
        (for-each (lambda (one-sentence) (execute-sentence interp one-sentence)) sentences)))
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

    (define control-func-dict
      `(("exec" . ,exec-func)
        ("if" . ,if-func))
      )))
