;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt --string-lowering  -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $array16 (array (mut i16)))
  (type $array16 (array (mut i16)))

  ;; CHECK:      (type $1 (func (param externref externref) (result i32)))

  ;; CHECK:      (rec
  ;; CHECK-NEXT:  (type $2 (func (param externref i32 externref)))

  ;; CHECK:       (type $3 (func (result externref)))

  ;; CHECK:       (type $4 (func (param externref) (result externref)))

  ;; CHECK:       (type $5 (func (param externref) (result i32)))

  ;; CHECK:       (type $6 (func (param externref externref) (result i32)))

  ;; CHECK:       (type $7 (func (param externref (ref $array16)) (result i32)))

  ;; CHECK:       (type $8 (func (param (ref $array16))))

  ;; CHECK:       (type $9 (func (param externref externref externref externref)))

  ;; CHECK:      (type $10 (func))

  ;; CHECK:      (type $11 (func (param (ref null $array16) i32 i32) (result (ref extern))))

  ;; CHECK:      (type $12 (func (param i32) (result (ref extern))))

  ;; CHECK:      (type $13 (func (param externref (ref null $array16) i32) (result i32)))

  ;; CHECK:      (type $14 (func (param externref) (result i32)))

  ;; CHECK:      (type $15 (func (param externref i32) (result i32)))

  ;; CHECK:      (type $16 (func (param externref i32 i32) (result (ref extern))))

  ;; CHECK:      (import "string.const" "0" (global $string.const_exported (ref extern)))

  ;; CHECK:      (import "colliding" "name" (func $fromCodePoint (type $10)))
  (import "colliding" "name" (func $fromCodePoint))

  ;; CHECK:      (import "wasm:js-string" "fromCharCodeArray" (func $fromCharCodeArray (type $11) (param (ref null $array16) i32 i32) (result (ref extern))))

  ;; CHECK:      (import "wasm:js-string" "fromCodePoint" (func $fromCodePoint_13 (type $12) (param i32) (result (ref extern))))

  ;; CHECK:      (import "wasm:js-string" "intoCharCodeArray" (func $intoCharCodeArray (type $13) (param externref (ref null $array16) i32) (result i32)))

  ;; CHECK:      (import "wasm:js-string" "equals" (func $equals (type $1) (param externref externref) (result i32)))

  ;; CHECK:      (import "wasm:js-string" "compare" (func $compare (type $1) (param externref externref) (result i32)))

  ;; CHECK:      (import "wasm:js-string" "length" (func $length (type $14) (param externref) (result i32)))

  ;; CHECK:      (import "wasm:js-string" "codePointAt" (func $codePointAt (type $15) (param externref i32) (result i32)))

  ;; CHECK:      (import "wasm:js-string" "substring" (func $substring (type $16) (param externref i32 i32) (result (ref extern))))

  ;; CHECK:      (export "export.1" (func $exported-string-returner))

  ;; CHECK:      (export "export.2" (func $exported-string-receiver))

  ;; CHECK:      (func $string.as (type $9) (param $a externref) (param $b externref) (param $c externref) (param $d externref)
  ;; CHECK-NEXT:  (local.set $b
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $c
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $d
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.as
    (param $a stringref)
    (param $b stringview_wtf8)
    (param $c stringview_wtf16)
    (param $d stringview_iter)
    ;; These operations all vanish in the lowering, as they all become extref
    ;; (JS strings).
    (local.set $b
      (string.as_wtf8
        (local.get $a)
      )
    )
    (local.set $c
      (string.as_wtf16
        (local.get $a)
      )
    )
    (local.set $d
      (string.as_iter
        (local.get $a)
      )
    )
  )

  ;; CHECK:      (func $string.new.gc (type $8) (param $array16 (ref $array16))
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $fromCharCodeArray
  ;; CHECK-NEXT:    (local.get $array16)
  ;; CHECK-NEXT:    (i32.const 7)
  ;; CHECK-NEXT:    (i32.const 8)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.new.gc (param $array16 (ref $array16))
    (drop
      (string.new_wtf16_array
        (local.get $array16)
        (i32.const 7)
        (i32.const 8)
      )
    )
  )

  ;; CHECK:      (func $string.from_code_point (type $3) (result externref)
  ;; CHECK-NEXT:  (call $fromCodePoint_13
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.from_code_point (result stringref)
    (string.from_code_point
      (i32.const 1)
    )
  )

  ;; CHECK:      (func $string.encode (type $7) (param $ref externref) (param $array16 (ref $array16)) (result i32)
  ;; CHECK-NEXT:  (call $intoCharCodeArray
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (local.get $array16)
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.encode (param $ref stringref) (param $array16 (ref $array16)) (result i32)
    (string.encode_wtf16_array
      (local.get $ref)
      (local.get $array16)
      (i32.const 10)
    )
  )

  ;; CHECK:      (func $string.eq (type $6) (param $a externref) (param $b externref) (result i32)
  ;; CHECK-NEXT:  (call $equals
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:   (local.get $b)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.eq (param $a stringref) (param $b stringref) (result i32)
    (string.eq
      (local.get $a)
      (local.get $b)
    )
  )

  ;; CHECK:      (func $string.compare (type $6) (param $a externref) (param $b externref) (result i32)
  ;; CHECK-NEXT:  (call $compare
  ;; CHECK-NEXT:   (local.get $a)
  ;; CHECK-NEXT:   (local.get $b)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.compare (param $a stringref) (param $b stringref) (result i32)
    (string.compare
      (local.get $a)
      (local.get $b)
    )
  )

  ;; CHECK:      (func $string.length (type $5) (param $ref externref) (result i32)
  ;; CHECK-NEXT:  (call $length
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.length (param $ref stringview_wtf16) (result i32)
    (stringview_wtf16.length
      (local.get $ref)
    )
  )

  ;; CHECK:      (func $string.get_codeunit (type $5) (param $ref externref) (result i32)
  ;; CHECK-NEXT:  (call $codePointAt
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.get_codeunit (param $ref stringview_wtf16) (result i32)
    (stringview_wtf16.get_codeunit
      (local.get $ref)
      (i32.const 2)
    )
  )

  ;; CHECK:      (func $string.slice (type $4) (param $ref externref) (result externref)
  ;; CHECK-NEXT:  (call $substring
  ;; CHECK-NEXT:   (local.get $ref)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:   (i32.const 3)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $string.slice (param $ref stringview_wtf16) (result stringref)
    (stringview_wtf16.slice
      (local.get $ref)
      (i32.const 2)
      (i32.const 3)
    )
  )

  ;; CHECK:      (func $exported-string-returner (type $3) (result externref)
  ;; CHECK-NEXT:  (global.get $string.const_exported)
  ;; CHECK-NEXT: )
  (func $exported-string-returner (export "export.1") (result stringref)
    ;; We should update the signature of this function even though it is public
    ;; (exported).
    (string.const "exported")
  )

  ;; CHECK:      (func $exported-string-receiver (type $2) (param $x externref) (param $y i32) (param $z externref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $y)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $z)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $exported-string-receiver (export "export.2") (param $x stringref) (param $y i32) (param $z stringref)
    ;; We should update the signature of this function even though it is public
    ;; (exported).
    (drop
      (local.get $x)
    )
    (drop
      (local.get $y)
    )
    (drop
      (local.get $z)
    )
  )
)
