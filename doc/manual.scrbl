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
              @defproc[(flif-create-image-rgb [width integer?] [height integer?]) _FLIF-IMAGE]
              @defproc[(flif-create-image-gray [width integer?] [height integer?]) _FLIF-IMAGE]
              @defproc[(flif-create-image-palette [width integer?] [height integer?]) _FLIF-IMAGE]
              @defproc[(flif-create-image-hdr [width integer?] [height integer?]) _FLIF-IMAGE])]{
  Creates a pointer to a @racket[_FLIF-IMAGE] struct.
}

@deftogether[(@defproc[(flif-import-image-rgba! [width integer?]
                                                [height integer?]
                                                [rgba bytes?]
                                                [stride integer?]) _FLIF-IMAGE]
              @defproc[(flif-import-image-rgb! [width integer?]
                                               [height integer?]
                                               [rgb bytes?]
                                               [stride integer?]) _FLIF-IMAGE]
              @defproc[(flif-import-image-gray! [width integer?]
                                                [height integer?]
                                                [gray bytes?]
                                                [stride integer?]) _FLIF-IMAGE]
              @defproc[(flif-import-image-palette! [width integer?]
                                                   [height integer?]
                                                   [palette bytes?]
                                                   [stride integer?]) _FLIF-IMAGE])]{
  Creates a pointer to a @racket[_FLIF-IMAGE] struct by importing the associated bytes.
}

@defproc[(flif-destroy-image! [image _FLIF-IMAGE]) void?]{
  Destroy the image pointer.
}

@deftogether[(@defproc[(flif-image-get-width [image _FLIF-IMAGE]) integer?]
              @defproc[(flif-image-get-height [image _FLIF-IMAGE]) integer?]
              @defproc[(flif-image-get-nb-channels [image _FLIF-IMAGE]) integer?])]{
  Gets the associated information from the image pointer.
}


@defproc[(flif-image-get-palette-size [image _FLIF-IMAGE]) integer?]{
  Gets the size of the palette from the image pointer, where @racket[0]
  means no palette and @racket[1] - @racket[256] means nb of colors in
  the palette.
}

@defproc[(flif-image-get-palette [image _FLIF-IMAGE]) bytes?]{
  Gets the bytes of the image palette from a newly-created byte buffer,
  allocated with @racket[flif-image-get-palette-size].
}

@defproc[(flif-image-set-palette! [image _FLIF-IMAGE] [buffer bytes?]) void?]{
  Puts the RGBA bytes into the image pointer (must be
  @racket[(* 4 palette-size)] in size).
}

@defproc[(flif-image-get-depth [image _FLIF-IMAGE]) integer?]{
  Gets the bit-depth of the image (e.g. @racket[8]).
}

@deftogether[(@defproc[(flif-image-get-frame-delay [image _FLIF-IMAGE]) integer?]
              @defproc[(flif-image-set-frame-delay! [image _FLIF-IMAGE]
                                                    [frame-delay integer?]) void?])]{
  Gets or sets the frame delay for an image. Only applicable for FLIF images with animation.
}

@defproc[(flif-image-get-metadata [image _FLIF-IMAGE] [chunkname string?]) bytes?]{
  Gets the metadata from the image from a newly-created pointer that is passed
  to the FFI.
}

@defproc[(flif-set-metadata! [image _FLIF-IMAGE] [chunkname string?] [data bytes?]) void?]{
  Sets the metadata for the image.
}
