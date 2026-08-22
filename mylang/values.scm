;;float str true false はschemeの機能を借りる
;;nil label symbol lazy block lambdaは自作する
(define-record-type <nil-value>
  (make-nil-value)
  nil-value?)

(define the-nil (make-nil-value)) ; nil唯一のインスタンス

;(define-record-type <label-value>;廃止するかも
; (make-label-value token)
;  label-value?
;  (token label-value-token)) ; tokenはlabel-value-tokenで取得する

(define-record-type <symbol-value>
  (make-symbol-value token)
  symbol-value?
  (token symbol-value-token))

(define-record-type <lazy-value>
  (make-lazy-value token)
  lazy-value?
  (token lazy-value-token))

(define-record-type <block-value>
  (make-block-value items)
  block-value?
  (items block-value-items block-value-items-set!))

(define (block-value-append! block item)
  (block-value-items-set! block (cons item (block-value-items block))))

(define (block-value-append! block item)
  (block-value-items-set! block
    (cons item (block-value-items block))))

(define-record-type <lambda-value>
  (make-lambda-value params body env line)
  lambda-value?
  (params lambda-value-params)
  (body lambda-value-body)
  (env lambda-value-env)
  (line lambda-value-line))

(define (call-lambda! lambda)
  (write "まだ未実装"))

(define (value->write-string value)
  (cond ((number? value) (number->string value))
	((string? value) (string-append "\"" value "\""))
	((boolean? value) (if value "#true" "#false"))
	((nil-value? value) "#nil")
	((label-value? value) (string-append ":" (label-value-token value)))
	((symbol-value? value) (symbol-value-token value))
	((lazy-value? value) (string-append "'" (lazy-value-token value)))
	((block-value? value)
	 (string-append "( "
			(apply string-append (map (lambda (pair) (string-append (value->write-string (car pair)) " ")) (block-value-items value)))
			
	      ")"))
	((lambda-value? value) (string-append "<lambda" (if (lambda-value-line value) (string-append "at" (lambda-value-line value))) ">"))
	(else (write "unknown-type") (write  value))))
