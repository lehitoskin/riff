#lang scribble/manual
@; dec.scrbl
@(require (for-label racket/base
                     racket/contract
                     "../dec.rkt"
                     "../flif.rkt"))

@title[#:tag "dec"]{Decoder Functions}

@deftogether[(@defthing[_FLIF-DECODER ctype?]
              @defthing[_FLIF-INFO ctype?])]{
  These ctypes are the basis for the functions in this section. They keep track
  of the image you are working on.
}

@defproc[(flif-create-decoder) _FLIF-DECODER]{
  Create a new pointer to a @racket[_FLIF-DECODER] struct.
}

@deftogether[(@defproc[(flif-decoder-decode-file! [decoder _FLIF-DECODER]
                                                  [file string?]) void?]
              @defproc[(flif-decoder-decode-memory! [decoder _FLIF-DECODER]
                                                    [buffer bytes?]) void?])]{
  Decode the FLIF either from a string to the file or from its bytes.
}

@defproc[(flif-decoder-num-images [decoder _FLIF-DECODER]) integer?]{
  Obtain the number of frames in the FLIF.
}

@defproc[(flif-decoder-num-loops [decoder _FLIF-DECODER]) integer?]{
  The number of times the FLIF animation should be looped (@racket[0] indicates
  the FLIF should be looped forever).
}

@defproc[(flif-decoder-get-image [decoder _FLIF-DECODER]
                                 [index integer?]) _FLIF-IMAGE]{
  Obtain the @racket[_FLIF-IMAGE] pointer to the frame located at @racket[index].
}

@defproc[(flif-destroy-decoder! [decoder _FLIF-DECODER]) void?]{
  Free memory associated with the pointer.
}

@defproc[(flif-abort-decoder! [decoder _FLIF-DECODER]) void?]{
  Abort the decoder (may be used before decoding is complete).
}

@defproc[(flif-decoder-set-crc-check! [decoder _FLIF-DECODER]
                                      [check? boolean?]) void?]{
  Set whether the decoder should check the CRC. The default behavior is to not
  check the CRC.
}

@defproc[(flif-decoder-set-quality! [decoder _FLIF-DECODER]
                                    [quality (integer-in 0 100)]) void?]{
  Set the decoder quality.
}

@defproc[(flif-decoder-set-scale! [decoder _FLIF-DECODER]
                                  [scale integer?]) void?]{
  Set the decoder scale. @racket[scale] must be a number that is a power of 2:
  1, 2, 4, 8, 16 ...
}

@defproc[(flif-decoder-set-resize! [decoder _FLIF-DECODER] [resize integer?]) void?]{
  Set the decoder resize.
}

@defproc[(flif-decoder-set-fit! [decoder _FLIF-DECODER] [fit integer?]) void?]{
  Set the decoder fit.
}

@defproc[(flif-decoder-set-callback! [decoder _FLIF-DECODER]
                                     [callback (integer? integer? . -> . integer?)]) void?]{
  Set the decoder callback. Useful for progressive decoding where the callback
  is called at every new level of quality achieved. The callback procedure takes
  two arguments: quality and bytes-read and must return an integer that
  indicates the next quality level desired.
}

@defproc[(flif-decoder-set-first-callback-quality! [decoder _FLIF-DECODER]
                                                   [quality integer?]) void?]{
  Set the first quality level to send to the decoder callback. Note: setting
  decoder quality is different from setting the initial callback quality.
}

@defproc[(flif-read-info-from-memory [buffer bytes?]) _FLIF-INFO]{
  Generate an info pointer with information gained from @racket[buffer].
}

@defproc[(flif-destroy-info! [info _FLIF-INFO]) void?]{
  Destroy the info pointer.
}

@defproc[(flif-dimensions [img flif?]) list?]{
  Read width and height information from @racket[img]. This procedure is
  provided because the flif-info C functions can be finicky and may report
  incorrect values if the image has not yet been decoded.
}

@deftogether[(@defproc[(flif-info-get-width [info _FLIF-INFO]) integer?]
              @defproc[(flif-info-get-height [info _FLIF-INFO]) integer?]
              @defproc[(flif-info-get-nb-channels [info _FLIF-INFO]) integer?]
              @defproc[(flif-info-get-depth [info _FLIF-INFO]) integer?]
              @defproc[(flif-info-num-images [info _FLIF-INFO]) integer?])]{
  Obtain various data from the info pointer.
}
