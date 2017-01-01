#lang racket/base
; flif.rkt
; common definitions for the FLIF wrapper
(require ffi/unsafe ffi/unsafe/define)
(provide (except-out (all-defined-out) define/flif))

(define-ffi-definer define/flif (ffi-lib "libflif"))

(define _FLIF-IMAGE (_cpointer 'FLIF-IMAGE))

(define/flif flif-create-image
  (_fun [width : _uint32]
        [height : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_create_image)

(define/flif flif-create-image-hdr
  (_fun [width : _uint32]
        [height : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_create_image_HDR)

(define/flif flif-import-image-rgba
  (_fun [width : _uint32]
        [height : _uint32]
        [rgba : _bytes]
        [stride : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_import_image_RGBA)

(define/flif flif-import-image-rgb
  (_fun [width : _uint32]
        [height : _uint32]
        [rgb : _bytes]
        [stride : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_import_image_RGB)

(define/flif flif-import-image-gray
  (_fun [width : _uint32]
        [height : _uint32]
        [gray : _bytes]
        [stride : _uint32]
        -> _FLIF-IMAGE)
  #:c-id flif_import_image_GRAY)

(define/flif flif-destroy-image (_fun [image : _FLIF-IMAGE] -> _void)
  #:c-id flif_destroy_image)

(define/flif flif-image-get-width (_fun [image : _FLIF-IMAGE] -> _uint32)
  #:c-id flif_image_get_width)

(define/flif flif-image-get-height (_fun [image : _FLIF-IMAGE] -> _uint32)
  #:c-id flif_image_get_height)

(define/flif flif-image-get-nb-channels (_fun [image : _FLIF-IMAGE] -> _uint8)
  #:c-id flif_image_get_nb_channels)

(define/flif flif-image-get-depth (_fun [image : _FLIF-IMAGE] -> _uint8)
  #:c-id flif_image_get_depth)

(define/flif flif-image-get-frame-delay (_fun [image : _FLIF-IMAGE] -> _uint32)
  #:c-id flif_image_get_frame_delay)

(define/flif flif-image-set-frame-delay
  (_fun [image : _FLIF-IMAGE]
        [frame-delay : _uint32]
        -> _void)
  #:c-id flif_image_set_frame_delay)

(define/flif flif-image-set-metadata
  (_fun [image : _FLIF-IMAGE]
        [chunkname : _string]
        [data : _bytes]
        [len : _size = (bytes-length data)]
        -> _void)
  #:c-id flif_image_set_metadata)

; perhaps data is a byte buffer and len is how much we should read?
; should ask the devs how this is supposed to work...
(define/flif flif-image-get-metadata
  (_fun [image : _FLIF-IMAGE]
        [chunkname : _string]
        [data : _bytes]
        [len : _size]; = (bytes-length data)] ;???
        -> _void)
  #:c-id flif_image_get_metadata)

(define/flif flif-image-free-metadata
  (_fun [image : _FLIF-IMAGE]
        [data : _bytes]
        -> _void)
  #:c-id flif_image_free_metadata)

(define/flif flif-image-write-row-rgba8
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_write_row_RGBA8)

; see flif-image-get-metadata
(define/flif flif-image-read-row-rgba8
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size]; = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_read_row_RGBA8)

(define/flif flif-image-write-row-rgba16
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_write_row_RGBA16)

; see flif-image-get-metadata
(define/flif flif-image-read-row-rgba16
  (_fun [image : _FLIF-IMAGE]
        [row : _uint32]
        [buffer : _bytes]
        [len : _size]; = (bytes-length buffer)]
        -> _void)
  #:c-id flif_image_read_row_RGBA16)

; buffer is originally void*, so this might not be needed when
; programming in racket?
(define/flif flif-free-memory (_fun [buffer : _bytes] -> _void)
  #:c-id flif_free_memory)
