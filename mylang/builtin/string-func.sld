(define-library (mylang builtin string-func)
  (export string-func-dict)
  (import (scheme base)
          (mylang values)
          (mylang interpreter))

  (begin
    (define (concat-func interp)
      (let* ((a (stack-pop! interp)) (b (stack-pop! interp)))
        (if (not (and (string? a) (string? b)))
            (interp-error! interp "TypeError" "The \"concat\" func expects two string")
            (stack-push! interp (string-append a b)))))

    (define (string-len-func interp)
      (let* ((a (stack-pop! interp)))
        (if (string? a)
            (stack-push! interp (string-length a))
            (interp-error! intero "TypeError" "The \"string-len func\" expects one string"))))

    (define string-func-dict
      `(("concat" . ,concat-func)
        ("string-len" . ,string-len-func)))))
