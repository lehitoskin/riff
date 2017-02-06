#lang scribble/manual
@; flif.scrbl
@(require (for-label (rename-in ffi/unsafe [-> -->])
                     racket/base
                     racket/contract
                     "../flif.rkt"))

@title[#:tag "flif"]{Common FLIF Functions}

@defthing[_FLIF-IMAGE ctype?]{
  This ctype is the basis for the functions in this section. It is associated
  with an image itself - either from file or its bytes.
}

@defproc[(flif? [img any/c]) boolean?]{
  Determines if the given file has a FLIF header.
}

@deftogether[(@defproc[(flif-create-image [width integer?] [height integer?]) _FLIF-IMAGE]
              @defproc[(flif-create-image-rgb [width integer?] [height integer?]) _FLIF-IMAGE]
              @defproc[(flif-create-image-gray [width integer?] [height integer?]) _FLIF-IMAGE]
              @defproc[(flif-create-image-palette [width integer?] [height integer?]) _FLIF-IMAGE]
              @defproc[(flif-create-image-hdr [width integer?] [height integer?]) _FLIF-IMAGE])]{
  Creates a pointer to a @racket[_FLIF-IMAGE] struct. Note:
  @racket[flif-create-image] is RGBA.
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

@defproc[(flif-image-set-metadata! [image _FLIF-IMAGE] [chunkname string?] [data bytes?]) void?]{
  Sets the metadata for the image.
}

@defproc[(flif-image-free-metadata! [image _FLIF-IMAGE] [data cpointer?]) void?]{
  Free the data pointer returned by @racket[flif-image-get-metadata] --
  this function is largely worthless because there is no pointer to free and it
  is visible to the garbage collector anyway. However, just for gits and
  shiggles, I added this function to the end of @racket[flif-image-get-metadata]
  to free the generated data pointer.
}

@deftogether[(@defproc[(flif-image-write-row-palette8! [image _FLIF-IMAGE]
                                                       [row integer?]
                                                       [buffer bytes?]) void?]
              @defproc[(flif-image-read-row-palette8 [image _FLIF-IMAGE]
                                                     [row integer?]
                                                     [len integer?]) bytes?]
              @defproc[(flif-image-write-row-gray8! [image _FLIF-IMAGE]
                                                    [row integer?]
                                                    [buffer bytes?]) void?]
              @defproc[(flif-image-read-row-gray8 [image _FLIF-IMAGE]
                                                  [row integer?]
                                                  [len integer?]) bytes?]
              @defproc[(flif-image-write-row-rgba8! [image _FLIF-IMAGE]
                                                    [row integer?]
                                                    [buffer bytes?]) void?]
              @defproc[(flif-image-read-row-rgba8 [image _FLIF-IMAGE]
                                                  [row integer?]
                                                  [len integer?]) bytes?])]{
  Read or write 8-bit depth image data. Read functions will return a byte
  string of length @racket[len] with the row pixels inside.
}

@deftogether[(@defproc[(flif-image-write-row-rgba16! [image _FLIF-IMAGE]
                                                     [row integer?]
                                                     [buffer bytes?]) void?]
              @defproc[(flif-image-read-row-rgba16 [image _FLIF-IMAGE]
                                                   [row integer?]
                                                   [len integer?]) bytes?])]{
  Read or write 16-bit depth image data. Read functions will return a byte
  string of length @racket[len] with the row pixels inside.
}

@defproc[(flif-free-memory! [buffer cpointer?]) void?]{
  Free the memory located inside the buffer gcpointer. Again, this is kind of
  a useless function.
}

