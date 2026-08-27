(define-library (mylang builtin lambda-func)
  (export lambda-func-dict)
  (import (scheme base)
          (scheme write)
          (mylang values)
          (mylang tokens)
          (mylang interpreter))
  (begin
    (define (func-func interp);わかりにくい名前だな
      ;;lispのlambdaみたいなやつ
      (let*
          ((params (stack-pop! interp))
           (body (stack-pop! interp)))

      (if (not (and (block-value? params) (block-value? body)))
          (interp-error! interp "TypeError" "the \"func\" func expects two block-value args"))

      ;;ここでparamsが全てsymbol-valueか調べる処理が必要です

      (stack-push! interp
        (make-lambda-value
         params
         body
         (interp-env interp);現在のenv
         (interp-token-line interp)))));現在のline
    
    (define lambda-func-dict ;これを変えす
      `(("func" . ,func-func)))))
