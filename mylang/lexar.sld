(define-library (mylang lexar)
  (export lexar)
  (import (scheme base))
  (begin
    (define (delimiter? chr)
      (or (char=? chr #\()
          (char=? chr #\))
          (char=? chr #\;)
          (char=? chr #\:)))
    
    ;; plain-codeを受け取り、((token . line) (token . line)) の形で返す
    (define (lexar plain-code)
      (let ((code-len (string-length plain-code)))
	(let loop ((i 0) ; カウンター
		   (chars '()) ; 現在のtoken の、文字ごとのリスト (逆向き)
		   (in-str? #f)
		   (line 0) ; 現在地
		   (tokens '())); 返すやつ(逆向き)
	  
	  (define (flash-chars chars tokens line)
	    (if (null? chars)
		tokens
		(cons (cons (list->string (reverse chars)) line) tokens)))

          (define (flash-delim chr tokens line)
            (cons (cons (string chr) line) tokens))
      
	  (if (= i code-len) ;終了だったら、
	      (reverse (flash-chars chars tokens line))
	      (let ((chr (string-ref plain-code i)))
		(cond
		 ((char=? #\" chr)
		  (loop (+ i 1)
			(cons chr chars)
			(not in-str?)
			line
			tokens))

		 (in-str?
		  (loop (+ i 1)
			(cons chr chars)
			in-str?
			line
			tokens))

		 ((char=? #\newline chr)
		  (loop (+ i 1)
			'()
			in-str?
			(+ line 1)
			(flash-chars chars tokens line)))

		 ((char=? #\space chr)
		  (loop (+ i 1)
			'()
			in-str?
			line
			(flash-chars chars tokens line)))

                 ((delimiter? chr);一つで区切り文字として動くやつだったら、
                  (loop (+ i 1)
                        '()
                        in-str?
                        line
                        (flash-delim chr (flash-chars chars tokens line) line)))

		 (else
		  (loop (+ i 1)
			(cons chr chars)
			in-str?
			line
			tokens))))))))))

