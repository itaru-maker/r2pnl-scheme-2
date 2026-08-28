(define-library (mylang builtin var-func)
  (export var-func-dict)
  (import (scheme base)
	  (mylang values)
	  (mylang interpreter)
	  (mylang env))
  (begin
      (define  (let-func interp)
	(let* ((name (stack-pop! interp))
	       (value (stack-pop! interp)))
	  (if (symbol-value? name)
	      (if (in-env? (interp-env interp) (symbol-value-token name))
		  (interp-error! interp "VarError" "symbol is already defined! please use func \"set\"")
		  (env-define (interp-env interp) (symbol-value-token name) value))
	      (interp-error!
	       interp "TypeError" (string-append "func \"let\" expect symbol-value and any-value, but value "
						 (value->write-string name)
						 " is passed as symbol")))))
    
      (define (set-func interp)
	(let* ((name (stack-pop! interp))
	       (value (stack-pop! interp)))
	  (if (symbol-value? name)
	      (if (in-env? (interp-env interp) (symbol-value-token name))
		  (env-set! (interp-env interp) (symbol-value-token name) value)
		  (interp-error! interp "VarError" "symbol is not defined. please use func \"let\""))
	      (interp-error! interp "TypeError" (string-append "func \"set\" expect symbol-value and any-value, but value "
							       (value->write-string name)
							       " is passed as symbol")))))

      (define (def-func interp)
        (let* ((name (stack-pop! interp))
               (params (stack-pop! interp))
               (body (stack-pop! interp)))
          (if (and (symbol-value? name) (block-value? params) (block-value? body))
              (begin
                (stack-push! interp
                             (make-lambda-value
                              params
                              body
                              (interp-env interp)
                              (interp-token-line interp)))
                (stack-push! interp name)
                (let-func interp));真上で定義したletをかりる
              (interp-error! interp "TypeError" "the def func expect a symbol and two block args."))))
      (define var-func-dict
	`(("let" . ,let-func)
	  ("set" . ,set-func)
          ("def" . ,def-func)))))
