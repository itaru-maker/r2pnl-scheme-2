(define-library (mylang parser)
  (export parse-one-token
	  sorting-types
	  parse-paren
	  tokens->sentences)
  (import (scheme base)
	  (scheme write)
	  (mylang values)
	  (mylang tokens)
	  (mylang error))
  (begin
    ;;一つのtokenを受け取って、変換して返す
    (define (parse-one-token item line)
      (let ((token-len (string-length item))
	    (item-line line));parse-error用
	(cond
	 ;;数値
	 ((string->number item)
	  (string->number item))
	 
	 ;;文字列
	 ((and (< 1 token-len)
	       (char=? (string-ref item 0) #\")
	       (char=? (string-ref item (- token-len 1)) #\"))
	  (substring item 1 (- token-len 1)))

	 ;;真偽地&nil
	 ((string=? item "#true") #t) ;true
	 ((string=? item "#false") #f) ;false
	 ((string=? item "#nil") the-nil) ;nil

	 ((string=? item "'" )
	  (raise-mylang-error! "parse-error" "Value missing after single quote." item-line))
	 ;;lazy
	 ((char=? (string-ref item 0) #\')
	  (make-lazy-value (substring item 1 token-len)))

	 ;;tokenなど
	 ((string=? item ".") the-period)
	 ((string=? item ";") the-semicolon)
	 ((string=? item "(") the-l-paren)
	 ((string=? item ")") the-r-paren)

	 ;;symbol
	 (else (make-symbol-value item)))))


    (define (sorting-types str-tokens)
      (map (lambda (pair)
	     (cons (parse-one-token (car pair) (cdr pair));もうちょっと簡潔にかける気が
		   (cdr pair)))
	   str-tokens))


    (define (parse-paren types)
      (let loop ((rest types)
		 (stack (list (make-block-value '())))) ;外側の受け皿 (逆向き)appendを使い回すため
	(cond
	 ((null? rest)
	  (if (null? (cdr stack));スタックに2以上あるなら、とじかっこが少ない（解決していない）
	      (reverse (block-value-items (car stack)))
	      (error "unclosed paren(自作言語側だよ)")))
     
	 ((l-paren? (car (car rest)));ペアの中の値をみる
	  (loop (cdr rest)
		(cons (make-block-value '()) stack)))
	 
	 ((r-paren? (car (car rest)))
	  (if (null? (cdr stack)) ;すでにblockが解決している場合
	      (raise-mylang-error! "parse-error" "extra closing paren"(cdr (car rest)))
	      (let ((new-block (car stack))
		    (rest-stack (cdr stack))
		    (line (cdr (car rest)))) ;自身((car (car rest))) が持ってるline
		(block-value-items-set! new-block (reverse (block-value-items new-block))) ; ここでも裏返す
		(block-value-append! (car rest-stack) (cons new-block line))
		(loop (cdr rest) rest-stack))))
	 (else
	  (block-value-append! (car stack) (car rest))
	  (loop (cdr rest) stack)))))


    (define (tokens->sentences types)
      (let loop ((rest types)
		 (current '());現在の処理している文（逆側に積む）
		 (stack '()));最終的に返す文たち(逆側に積む）
	(cond
	 ((null? rest);全部集計が終わった
	  (if (null? current);スタックを返す。
	      (reverse stack)
	      (raise-mylang-error! "semicolon-error" "semicolon is missing!" (cdr (car current))))) 
	 
	 ((semicolon? (car (car rest)))
	  (loop
	   (cdr rest)
	   '()
	   (cons (reverse (cons (car (car rest)) current)) stack))) ;セミコロンもしっかり入れる
	 
	 (else
	  (loop
	   (cdr rest)
	   (cons (car rest) current)
	   stack)))))))

