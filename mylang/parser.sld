(define-library (mylang parser)
  (export parse-one-token
	  sorting-types
	  parse-paren
	  tokens->sentences)
  (import (scheme base)
	  (scheme write)
	  (mylang values)
	  (mylang tokens))
  (begin
    ;;一つのtokenを受け取って、変換して返す
    (define (parse-one-token item)
      (let ((token-len (string-length item)))
	(cond
	 ;;数値
	 ((string->number item)
	  (string->number item))
	 ;;文字列
	 ((and (< 1 token-len)
	       (char=? (string-ref item 0) #\")
	       (char=? (string-ref item (- token-len 1)) #\"))
	  (substring item 1 (- token-len 1)))
	 
	 ((string=? item "#true") #t) ;true
	 ((string=? item "#false") #f) ;false
	 ((string=? item "#nil") the-nil) ;nil
     
	 ;;lazy
	 ((char=? (string-ref item 0) #\')
	  (make-lazy-value (substring item 1 token-len)))
	 ;;label(廃止予定）
	 ;;((char=? (string-ref item 0) #\:)
	 ;; (make-lazy-value (substring item 1 token-len)))

	 ((string=? item ".") the-period)
	 ((string=? item ";") the-semicolon)
	 ((string=? item "(") the-l-paren)
	 ((string=? item ")") the-r-paren)

	 (else (make-symbol-value item)))))


    (define (sorting-types str-tokens)
      (map (lambda (pair)
	     (cons (parse-one-token (car pair))
		   (cdr pair)))
	   str-tokens))


    (define (parse-paren types)
      (let loop ((rest types)
		 (stack (list (make-block-value '())))) ;外側の受け皿 (逆向きにくっつけて行きます)(append!が使いまわせるので、block-valueを流用する)
	(cond
	 ((null? rest)
	  (if (null? (cdr stack));スタックに2以上あるなら、とじかっこが少ない（解決していない）
	      (reverse (block-value-items (car stack)))
	      (error "unclosed paren")))
     
	 ((l-paren? (car (car rest)));ペアの中の値をみる
	  (loop (cdr rest)
		(cons (make-block-value '()) stack)))
	 
	 ((r-paren? (car (car rest)))
	  (if (null? (cdr stack)) ;すでにblockが解決している場合
	      (error "Extra closing paren!")
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
	  (reverse stack)) ;スタックを返す。セミコロンで終わってない判定をしてないので注意！
	 
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

