#lang scribble/manual
@; dec.scrbl
@(require (for-label (rename-in ffi/unsafe [-> -->])
                     racket/base
                     racket/contract
                     "../dec.rkt"))

@title[#:tag "dec"]{Decoder FLIF Functions}

@defmodule[riff/dec]{
  @racketmodname[riff/dec] contains definitions for decoding FLIF data.
}

@deftogether[(@defthing[_FLIF-DECODER ctype?]
              @defthing[_FLIF-INFO ctype?])]{
  These ctypes are the basis for the functions in this section. They keep track
  of the image you are working on.
}

@defproc[(flif-create-decoder) _FLIF-DECODER]{
  Create a new pointer to a @racket[_FLIF-DECODER] struct.
}
