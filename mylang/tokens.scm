(define-record-type <period>
  (make-period)
  period?)

(define the-period (make-period))

(define-record-type <semicolon>
  (make-semicolon)
  semicolon?)

(define the-semicolon (make-semicolon))

(define-record-type <r-paren>
  (make-r-paren)
  r-paren?)

(define the-r-paren (make-r-paren))

(define-record-type <l-paren>
  (make-l-paren)
  l-paren?)

(define the-l-paren (make-l-paren))
