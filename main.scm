;;(set! %load-extensions (cons ".sld" %load-extensions));guileの人は書く
#|実行方法：お使いの処理系に応じて使い分けてください！
gauche
gosh -r7 -I. main.scm
chibi
chibi-scheme main.scm
kawa
kawa -Dkawa.import.path="./*.sld" --r7rs main.scm
sash
sash -r7 -L . main.scm
guile
guile --r7rs -L . main.scm
chicken
 むりだった！(r7rs-eggがsldファイルに非対応のため)
cyclone
 むりだった！(apple silicon macとの相性が悪かった)
==================
|#

(import (scheme base)
        (scheme write)
        (scheme file)
        (mylang values)
        (mylang tokens)
        (mylang env)
        (mylang lexar)
        (mylang parser)
        (mylang error)
        (mylang interpreter)
        (mylang builtin prelude))

(define mylang (make-interp all-builtins));インスタンス化





(import (scheme base)
        (scheme file))

(define r2pnl-code
  (call-with-input-file "test.r2pnl"
    (lambda (port)
      (string-copy (read-string 10000 port)))));よくわからないけどguileの内部構造的にコピーを作らないといけないらしい（他の処理系では動く）



(interp-run mylang r2pnl-code);実行する

(newline)



