(entry-builtin-names! (list "let")
  (lambda (interp)
    (let* ((name (stack-pop! interp))
	   (value (stack-pop! interp)))
      (if (symbol-value? interp)
	  (if (in-env (interp-env interp) name)
	      (interp-error! interp "TypeError" "symbol is already defined! please use func \"set\"")
	      (begin
		(env-define (interp-env interp) name value)
		(write "定義されました（デバッグ）")))
	  (interp-error! interp "TypeError" (string-append "func \"let\" expect symbol-value and any-value, but value " (value->write-string name) " is passed as symbol"))))))

