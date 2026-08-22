(define-record-type <interp>
  (make-interp-raw stack env token-line) ;__init__みたいなの
  interp?
  (stack interp-stack interp-stack-set!)
  (env interp-env interp-env-set!)
  (token-line interp-token-line interp-token-line-set!))

(define (stack-push! interp value)
  (interp-stack-set! interp (cons value (interp-stack interp))))

(define (stack-pop! interp)
  (let ((s (interp-stack interp)))
    (if (null? s)
	(interp-error! interp "Stack underflow" "pop from empty stack")
	(begin (interp-stack-set! interp (cdr s))
	       (car s)))))

(define-record-type <builtin-func>
  (make-builtin-func name proc)
  builtin-func?
  (name builtin-func-name)
  (proc builtin-func-proc))

(define-record-type <interp-error>
  (make-interp-error error-name message line trace)
  interp-error?
  (error-name interp-error-name)
  (message interp-error-message)
  (line interp-error-line)
  (trace interp-error-trace interp-error-trace-set!))


(define (interp-error! interp error-name message . opt-line)
  (let ((error-line (if (not (null? opt-line)) (car opt-line) (interp-token-line interp))))
    (raise (make-interp-error error-name message error-line '())))) ;一番最初に起動した時だから、traceは空


(define (invoke! interp call-func)
  (cond
   ((builtin-func? call-func) ((builtin-func-proc call-func) interp))
   ((lambda-value? call-func) (call-lambda! call-func interp))
   (else (inter-error! interp "TypeError" "not callable value is passd"))))

(define (all-but-last lst);セミコロンを取り除くよう
  (if (null? lst)
      '()
      (reverse (cdr (reverse lst)))))

(define (execute-sentence interp sentence);一つだけ、文をもらう
  (let ((body (reverse (all-but-last sentence))));逆向きにする（速いから）
    (for-each
     (lambda (pair)
       (let ((item (car pair)) (item-line (cdr pair)));ここで分離
	 (interp-token-line-set! interp item-line)
	 (cond
	  ((symbol-value? item);安全確認がまだできてないので注意
	   (stack-push! interp (env-get (interp-env interp) (symbol-value-token item))))

	  ((lazy-value? item)
	   (stack-push! interp (parse-one-token (lazy-value-token item))))
	   

	  ((period? item)
	   (invoke! interp (stack-pop! interp)))

	  (else
	   (stack-push! interp item)))))
     body)))

(define (interp-run interp code)
  (guard (e
	  ((interp-error? e)
	   (for-each (lambda (x) (display x))
		     (reverse (interp-error-trace e)))
	   (display (string-append (interp-error-name e) (interp-error-message e)))))
    (let*
	((raw-tokens (lexar code))
	 (types (sorting-types raw-tokens))
	 (structure-types (parse-paren types))
	 (sentences (tokens->sentences structure-types)))
      (for-each (lambda (one-sentence) (execute-sentence interp one-sentence)) sentences))))

(define (make-interp);決まりきった引数を削り取ったやつ
  (let* ((env (make-env #f))
	 (interp (make-interp-raw '() env #f)));初期化用の、空スタック、親がいないenv(外側)、lineは#f を作る。
    (for-each
     (lambda (entry);(name . proc)のリストをもらう
       (env-define env (car entry) (make-builtin-func (car entry) (cdr entry))))
     *builtin*)
    interp));for-eachは返さないから、interpを返す。
    

  

  

	
