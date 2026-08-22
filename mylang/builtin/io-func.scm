(entry-builtin-names! (list "write")
  (lambda (interp)
    (display
     (value->write-string
      (stack-pop! interp)))))
		     
		    
