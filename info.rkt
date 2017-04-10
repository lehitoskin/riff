#lang setup/infotab

(define name "riff")
(define scribblings '(("doc/manual.scrbl" ())))

(define blurb '("Riff is a wrapper for the FLIF library."))
(define primary-file "main.rkt")
(define homepage "https://github.com/lehitoskin/riff/")

(define version "0.2")
(define release-notes '("New progressive callback API"))

(define required-core-version "6.1")

(define deps '("base" "scribble-lib"))
(define build-deps '("racket-doc"))
