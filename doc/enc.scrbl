#lang scribble/manual
@; enc.rkt
@(require (for-label (rename-in ffi/unsafe [-> -->])
                     racket/base
                     racket/contract
                     "../enc.rkt"
                     "../flif.rkt"))

@title[#:tag "enc"]{Encoder FLIF Functions}

@defmodule[riff/enc]{
  @racketmodname[riff/enc] contains definitions for encoding FLIF data.
}

@defthing[_FLIF-ENCODER ctype?]{
  This ctype is the basis for the functions in this section. It is associated
  with an image itself - either from file or its bytes.
}

@defproc[(flif-create-encoder) _FLIF-ENCODER]{
  Create a pointer to an encoder struct.
}

@defproc[(flif-encoder-add-image! [encoder _FLIF-ENCODER] [image _FLIF-IMAGE]) void?]{
  Add the image onto the encoder --- add more than one image to create
  an animation.
}

@defproc[(flif-encoder-encode-file! [encoder _FLIF-ENCODER] [filename string?]) void?]{
  Encode to the supplied filename.
}

@defproc[(flif-encoder-encode-memory! [encoder _FLIF-ENCODER]) bytes?]{
  Encode to a newly-generated byte string. If the encoding fails, it will
  @racket[raise-result-error].
}

@defproc[(flif-destroy-encoder! [encoder _FLIF-ENCODER]) void?]{
  Destroy the encoder pointer.
}

@defproc[(flif-encoder-set-interlaced! [encoder _FLIF-ENCODER]
                                      [interlaced? boolean?]) void?]{
  Set whether the image is interlaced or non-interlaced (default is @racket[#t]).
}

@defproc[(flif-encoder-set-learn-repeat! [encoder _FLIF-ENCODER] [learn integer?]) void?]{
  Set how many times FLIF should learn the MANIAC tree (default is @racket[2]).
}

@defproc[(flif-encoder-set-auto-color-buckets! [encoder _FLIF-ENCODER]
                                               [acb? boolean?]) void?]{
  Default is @racket[#t].
}

@defproc[(flif-encoder-set-palette-size! [encoder _FLIF-ENCODER]
                                         [size integer?]) void?]{
  Default is @racket[512], the max.
}

@defproc[(flif-encoder-set-lookback! [encoder _FLIF-ENCODER]
                                     [looback? boolean?]) void?]{
  Default is @racket[#t].
}

@defproc[(flif-encoder-set-divisor! [encoder _FLIF-ENCODER] [divisor integer?]) void?]{
  Default is @racket[30].
}

@defproc[(flif-encoder-set-min-size! [encoder _FLIF-ENCODER] [size integer?]) void?]{
  Default is @racket[50].
}

@defproc[(flif-encoder-set-split-threshold! [encoder _FLIF-ENCODER] [split integer?]) void?]{
  Default is @racket[64].
}

@defproc[(flif-encoder-set-alpha-zero-lossless! [encoder _FLIF-ENCODER] [azl boolean?]) void?]{
  Default is @racket[#f].
}

@defproc[(flif-encoder-set-chance-cutoff! [encoder _FLIF-ENCODER] [cutoff integer?]) void?]{
  Default is @racket[2].
}

@defproc[(flif-encoder-set-chance-alpha! [encoder _FLIF-ENCODER] [alpha integer?]) void?]{
  Default is @racket[19].
}

@defproc[(flif-encoder-set-crc-check! [encoder _FLIF-ENCODER] [check? boolean?]) void?]{
  Set whether or not a CRC check should be added.
}

@defproc[(flif-encoder-set-channel-compact! [encoder _FLIF-ENCODER] [plc? boolean?]) void?]{
  Default is @racket[#t].
}

@defproc[(flif-encoder-set-ycocg! [encoder _FLIF-ENCODER] [ycocg? boolean?]) void?]{
  Default is @racket[#t].
}

@defproc[(flif-encoder-set-frame-shape! [encoder _FLIF-ENCODER] [shape? boolean?]) void?]{
  Default is @racket[#t].
}

@defproc[(flif-encoder-set-lossy! [encoder _FLIF-ENCODER] [loss integer?]) void?]{
  Set the amount of quality loss: @racket[0] means no loss and @racket[100] means
  maximum loss. Negative values indicate adaptive lossy (second image should be
  the saliency map). Default is @racket[0].
}