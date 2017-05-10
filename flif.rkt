#lang racket/base
; flif.rkt
; common definitions for the FLIF wrapper
(require ffi/unsafe ffi/unsafe/define)
(provide (except-out (all-defined-out) define/flif))

(define-ffi-definer define/flif (ffi-lib "libflif"))

; The _string type supports conversion between Racket strings
; and char* strings using a parameter-determined conversion.
; instead of using _bytes, which is unnatural, use _string
; of specified type _string*/utf-8.
(default-_string-type _string*/utf-8)

(define _FLIF-IMAGE (_cpointer/null 'FLIF-IMAGE _gcpointer))

(define (flif? img)
  (define in
    (cond [(bytes? img) (open-input-bytes img)]
          [(path-string? img) (open-input-file img)]
          [else (open-input-bytes #"")]))
  (define header (peek-bytes 4 0 in))
  (close-input-port in)
  (and (not (eof-object? header)) (bytes=? header #"FLIF")))

; in RGBA
(define/flif flif-create-image
  (_fun [width : _uint32]
        [height : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_create_image)

(define/flif flif-create-image-rgb
  (_fun [width : _uint32]
        [height : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_create_image_RGB)

(define/flif flif-create-image-gray
  (_fun [width : _uint32]
        [height : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_create_image_GRAY)

(define/flif flif-create-image-gray16
  (_fun [width : _uint32]
        [height : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_create_image_GRAY16)

(define/flif flif-create-image-palette
  (_fun [width : _uint32]
        [height : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_create_image_PALETTE)

(define/flif flif-create-image-hdr
  (_fun [width : _uint32]
        [height : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_create_image_HDR)

(define/flif flif-import-image-rgba!
  (_fun [width : _uint32]
        [height : _uint32]
        [rgba : _bytes]
        [stride : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_import_image_RGBA)

(define/flif flif-import-image-rgb!image-fr
  (_fun [width : _uint32]
        [height : _uint32]
        [rgb : _bytes]
        [stride : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_import_image_RGB)

(define/flif flif-import-image-gray!
  (_fun [width : _uint32]
        [height : _uint32]
        [gray : _bytes]
        [stride : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_import_image_GRAY)

(define/flif flif-import-image-gray16!
  (_fun [width : _uint32]
        [height : _uint32]
        [gray : _bytes]
        [stride : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_import_image_GRAY)

(define/flif flif-import-image-palette!
  (_fun [width : _uint32]
        [height : _uint32]
        [gray : _bytes]
        [stride : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_import_image_PALETTE)

(define/flif flif-destroy-image!
  (_fun [image : _FLIF-IMAGE] -> _void)
  #:c-id flif_destroy_image)

(define/flif flif-image-get-width
  (_fun [image : _FLIF-IMAGE] -> _uint32)
  #:c-id flif_image_get_width)

(define/flif flif-image-get-height
  (_fun [image : _FLIF-IMAGE] -> _uint32)
  #:c-id flif_image_get_height)

(define/flif flif-image-get-nb-channels
  (_fun [image : _FLIF-IMAGE] -> _uint8)
  #:c-id flif_image_get_nb_channels)

; 0 = no palette
; 1 - 256 = nb of colors in palette
(define/flif flif-image-get-palette-size
  (_fun [image : _FLIF-IMAGE] -> _uint32)
  #:c-id flif_image_get_palette_size)

; returns the RGBA colors in a new buffer
(define/flif flif-image-get-palette
  (_fun [image : _FLIF-IMAGE]
        [buffer : (_bytes o (* 4 (flif-image-get-palette-size image)))]
        -> _void
        -> buffer)
  #:c-id flif_image_get_palette)

; puts RGBA colors in buffer (4*palette_size bytes)
(define/flif flif-image-set-palette!
  (_fun [image : _FLIF-IMAGE]
        [buffer : _bytes]
        [size : _uint32 = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_set_palette)

(define/flif flif-image-get-depth
  (_fun [image : _FLIF-IMAGE] -> _uint8)
  #:c-id flif_image_get_depth)

(define/flif flif-image-get-frame-delay
  (_fun [image : _FLIF-IMAGE] -> _uint32)
  #:c-id flif_image_get_frame_delay)

(define/flif flif-image-set-frame-delay!
  (_fun [image : _FLIF-IMAGE]
        [frame-delay : _uint32]
        -> _void)
  #:c-id flif_image_set_frame_delay)

(define/flif flif-image-set-metadata!
  (_fun [image : _FLIF-IMAGE]
        [chunkname : _string]
        [data : _bytes]
        [len : _size = (bytes-length data)]
        -> _void)
  #:c-id flif_image_set_metadata)

; chunkname: "eXif", "eXmp"
(define/flif flif-image-get-metadata
  (_fun (image chunkname) ::
        [image : _FLIF-IMAGE]
        [chunkname : _string]
        [data : (_ptr o _bytes)]
        [len : (_box _size) = (box 0)]
        -> (success : _bool)
        -> (cond [success
                  (define metadata (make-sized-byte-string data (unbox len)))
                  (flif-image-free-metadata! image data)
                  metadata]
                 [else #""]))
  #:c-id flif_image_get_metadata)

(define/flif flif-image-free-metadata!
  (_fun [image : _FLIF-IMAGE]
        [data : _gcpointer]
        -> _void)
  #:c-id flif_image_free_metadata)

(define/flif flif-image-write-row-palette8!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_write_row_PALETTE8)

(define/flif flif-image-read-row-palette8!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _pointer]
        [len : _size]
        -> _void)
  #:c-id flif_image_read_row_PALETTE8)

(define (flif-image-read-palette8 image width height)
  (define len (* width height 4))
  (define pixels-ptr (malloc len _byte))
  (for ([y (in-range height)])
    (define offset-ptr (ptr-add pixels-ptr (* y width 4)))
    (flif-image-read-row-palette8! image y offset-ptr len))
  (make-sized-byte-string pixels-ptr len))

(define/flif flif-image-write-row-gray8!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_write_row_GRAY8)

(define/flif flif-image-read-row-gray8!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _pointer]
        [len : _size]
        -> _void)
  #:c-id flif_image_read_row_GRAY8)

(define (flif-image-read-gray8 image width height)
  (define len (* width height 4))
  (define pixels-ptr (malloc len _byte))
  (for ([y (in-range height)])
    (define offset-ptr (ptr-add pixels-ptr (* y width 4)))
    (flif-image-read-row-gray8! image y offset-ptr len))
  (make-sized-byte-string pixels-ptr len))

(define/flif flif-image-write-row-gray16!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_write_row_GRAY16)

(define/flif flif-image-read-row-gray16!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _pointer]
        [len : _size]
        -> _void)
  #:c-id flif_image_read_row_GRAY16)

(define (flif-image-read-gray16 image width height)
  (define len (* width height 4))
  (define pixels-ptr (malloc len _byte))
  (for ([y (in-range height)])
    (define offset-ptr (ptr-add pixels-ptr (* y width 4)))
    (flif-image-read-row-gray16! image y offset-ptr len))
  (make-sized-byte-string pixels-ptr len))

(define/flif flif-image-write-row-rgba8!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_write_row_RGBA8)

; see flif-image-get-metadata
(define/flif flif-image-read-row-rgba8!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _pointer]
        [len : _size]
        -> _void)
  #:c-id flif_image_read_row_RGBA8)

(define (flif-image-read-rgba8 image width height)
  (define len (* width height 4))
  (define pixels-ptr (malloc len _byte))
  (for ([y (in-range height)])
    (define offset-ptr (ptr-add pixels-ptr (* y width 4)))
    (flif-image-read-row-rgba8! image y offset-ptr len))
  (make-sized-byte-string pixels-ptr len))

(define/flif flif-image-write-row-rgba16!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_write_row_RGBA16)

; see flif-image-get-metadata
(define/flif flif-image-read-row-rgba16!
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _pointer]
        [len : _size]
        -> _void)
  #:c-id flif_image_read_row_RGBA16)

(define (flif-image-read-rgba16 image width height)
  (define len (* width height 4))
  (define pixels-ptr (malloc len _byte))
  (for ([y (in-range height)])
    (define offset-ptr (ptr-add pixels-ptr (* y width 4)))
    (flif-image-read-row-rgba16! image y offset-ptr len))
  (make-sized-byte-string pixels-ptr len))

; buffer is originally void*, so this might not be needed when
; programming in racket?
(define/flif flif-free-memory!
  (_fun [buffer : _gcpointer] -> _void)
  #:c-id flif_free_memory)
