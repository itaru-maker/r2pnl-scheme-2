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
	(mylang values)
	(mylang tokens)
	(mylang env)
	(mylang lexar)
	(mylang parser)
	(mylang error)
	(mylang interpreter)
	(mylang builtin prelude))

(define mylang (make-interp all-builtins));インスタンス化


(interp-run mylang "
. write . add . dup 3 ;
. write . sub . swap 5 10 ;
. write . drop \"ゴミデータ\" \"ゴミじゃないデータ\" ;
. write \"parfect!\" ;
. exec ( . write \"hello\" ; ) ;

. let 'hello (
  . let 'この変数名は使わないで ;
  . write \"hello, \" ;
  . write この変数名は使わないで ;
  . write \"!\" ;
) ;

. exec hello \"world\" ;
")

(newline)


