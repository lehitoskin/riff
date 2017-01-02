#lang scribble/manual
@; png-image.scrbl
@(require (for-label (rename-in ffi/unsafe [-> -->])
                     racket/base
                     racket/contract
                     "../main.rkt"))

@title{@bold{riff}: A wrapper to the FLIF library.}
@author{Lehi Toskin}

@defmodule[riff]{
  @racketmodname[riff] is a simple wrapper to the FLIF library, providing a
  mostly C-like interface.
}

@deftogether[(@defthing[_FLIF-IMAGE ctype?]
              @defthing[_FLIF-INFO ctype?]
              @defthing[_FLIF-ENCODER ctype?]
              @defthing[_FLIF-DECODER ctype?])]{
  These are the C pointers that are used in almost every function in this
  wrapper. Use them with care.
}

@defproc[(flif? [img any/c]) boolean?]{
  Determines if the given file has a FLIF header.
}

@deftogether[(@defproc[(flif-create-image [width integer?] [height integer?]) _FLIF-IMAGE]
              @defproc[(flif-create-image-hdr [width integer?] [height integer?]) _FLIF-IMAGE])]{
  Creates a pointer to a @racket[_FLIF-IMAGE] struct.
}
