(entry-builtin-names! (list "add" "+")
  (lambda (interp)
    (let* ((a (stack-pop! interp))
	   (b (stack-pop! interp)))
      (if (and (number? a) (number? b))
	  (stack-push! interp (+ a b))
	  (interp-error! interp "TypeError" "func \"add\" expects two numbers args")))))
		      
(entry-builtin-names! (list "sub" "-")
  (lambda (interp)
    (let* ((a (stack-pop! interp))
	   (b (stack-pop! interp)))
      (if (and (number? a) (number? b))
	  (stack-push! interp (- a b))
	  (interp-error! interp "TypeError" "func \"sub\" expects two numbers args")))))		      
(entry-builtin-names! (list "mul" "*")
  (lambda (interp)
    (let* ((a (stack-pop! interp))
	   (b (stack-pop! interp)))
      (if (and (number? a) (number? b))
	  (stack-push! interp (* a b))
	  (interp-error! interp "TypeError" "func \"mul\" expects two numbers args")))))

(entry-builtin-names! (list "div" "/")
  (lambda (interp)
    (let* ((a (stack-pop! interp))
	   (b (stack-pop! interp)))
      (if (and (number? a) (number? b))
	  (stack-push! interp (/ a b))
	  (interp-error! interp "TypeError" "func \"div\" expects two numbers args")))))		      


			
			


		      
		      

		      


			  
			      
