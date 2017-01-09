#lang setup/infotab

(define name "riff")
(define scribblings '(("doc/manual.scrbl" ())))

(define blurb '("Riff is a wrapper for the FLIF library."))
(define primary-file "main.rkt")

(define required-core-version "6.1")

(define deps '("base" "draw-lib" "scribble-lib"))
(define build-deps '("racket-doc"))
