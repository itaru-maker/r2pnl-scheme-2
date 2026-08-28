(define-library (mylang interpreter)
  (export
   make-interp make-interp-raw interp? interp-stack interp-stack-set! interp-env interp-env-set! interp-token-line interp-token-line-set!

   stack-push! stack-pop!
   
   interp-error!
   call-lambda!
   invoke!

   execute-sentence
   interp-run)
  (import
   (scheme base)
   (scheme write)
   (mylang values)
   (mylang tokens)
   (mylang env)
   (mylang lexar)
   (mylang parser)
   (mylang error))
  
  (begin
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
    
    (define (interp-error! interp error-name message . opt-line);基本builtinはこいつを投げる
      (let ((error-line (if (not (null? opt-line)) (car opt-line) (interp-token-line interp))))
	(raise (make-mylang-error error-name message error-line '())))) ;一番最初に起動した時だから、traceは空

    (define (call-lambda! interp lmb)
      (let*
          ((lambda-env (make-env(lambda-value-env lmb)));lambdaの中のenv
           (caller-line (interp-token-line interp))
           (caller-env (interp-env interp)));interpが元々持っていたenv
        ;;paramsを定義
        (for-each 
         (lambda (pair)
           (let ((param (car pair)))
             (if (symbol-value? param)
                 (env-define lambda-env (symbol-value-token param) (stack-pop! interp))
                 (interp-error! interp "TypeError" "'params' in 'func' must be a Block of Symbols"))))
         (block-value-items (lambda-value-params lmb)))
        (guard (e
                ((mylang-error? e)
                 (mylang-error-trace-set!
                  e
                  (cons (string-append "at line" (number->string caller-line) "\n")
                        (mylang-error-trace e)))
                 (interp-env-set! interp caller-env)
                 (interp-token-line-set! interp caller-line)
                 (raise e)));終わったら、そのまま上に流す

          ;;切り替え！
          (interp-env-set! interp lambda-env)
          (interp-token-line-set! interp (lambda-value-line lmb))

          (let ((sentences (tokens->sentences (block-value-items (lambda-value-body lmb)))))
            (for-each (lambda (one-sentence) (execute-sentence interp one-sentence))
                      sentences))

          (interp-env-set! interp caller-env);戻す
          (interp-token-line-set! interp caller-line))))


    (define (invoke! interp call-func)
      (cond
       ((builtin-func? call-func) ((builtin-func-proc call-func) interp))
       ((lambda-value? call-func) (call-lambda! interp call-func) )
       (else (interp-error! interp "TypeError" "not callable value is passd"))))

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
	      ((symbol-value? item)
	       (if (in-env? (interp-env interp) (symbol-value-token item));安全確認
		   (stack-push! interp (env-get (interp-env interp) (symbol-value-token item)))
		   (interp-error! interp "NameError" (string-append "unknown-name:" (symbol-value-token item)))))

	      ((lazy-value? item)
	       (stack-push! interp (parse-one-token (lazy-value-token item) item-line)))
	      
	      ((trigger? item)
	       (invoke! interp (stack-pop! interp)))
	      
	      (else
	       (stack-push! interp item)))))
     body)))
    
    (define (interp-run interp code)
      (guard (e;エラーをキャッチ
	      ((mylang-error? e)
               (newline)
               (display "==ERROR==")
               (newline)
	       (for-each (lambda (x) (display x))
			 (reverse (mylang-error-trace e)))
	       (display (string-append (mylang-error-name e) ":" (mylang-error-message e) " at line " (number->string (mylang-error-line e))))))
	(let*
	    ((raw-tokens (lexar code))
	     (types (sorting-types raw-tokens))
	     (structure-types (parse-paren types))
	     (sentences (tokens->sentences structure-types)))
	  (for-each (lambda (one-sentence) (execute-sentence interp one-sentence)) sentences))))

    (define (make-interp builtins);決まりきった引数を削り取ったやつ
      (let* ((env (make-env #f))
	     (interp (make-interp-raw '() env #f)));初期化用の、空スタック、親がいないenv(外側)、lineは#f を作る。
	(for-each
	 (lambda (entry);(name . proc)のリストをもらう
	   (env-define env (car entry) (make-builtin-func (car entry) (cdr entry))))
	 builtins)
	interp))));for-eachは返さないから、interpを返す。
