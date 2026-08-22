(entry-builtin-names! (list "display")
  (lambda (interp)
    (display
     (value->write-string
      (stack-pop! interp)))))
		     
		    
