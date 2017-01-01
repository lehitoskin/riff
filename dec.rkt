#lang racket/base
; dec.rkt
(require ffi/unsafe
         ffi/unsafe/define
         "flif.rkt")
(provide (except-out (all-defined-out) define/dec))

(define-ffi-definer define/dec (ffi-lib "libflif_dec"))

; The _string type supports conversion between Racket strings
; and char* strings using a parameter-determined conversion.
; instead of using _bytes, which is unnatural, use _string
; of specified type _string*/utf-8.
(default-_string-type _string*/utf-8)

(define _FLIF-DECODER (_cpointer 'FLIF-DECODER))
(define _FLIF-INFO (_cpointer/null 'FLIF-INFO))

; initialize a flif decoder
(define/dec flif-create-decoder
  (_fun -> _FLIF-DECODER)
  #:c-id flif_create_decoder)

; decode a given flif file
(define/dec flif-decoder-decode-file!
  (_fun [decoder : _FLIF-DECODER]
        [filename : _string]
        -> _bool) ; _int32
  #:c-id flif_decoder_decode_file)

(define/dec flif-decoder-decode-memory!
  (_fun [decoder : _FLIF-DECODER]
        [buffer : _bytes]
        [size : _size = (bytes-length buffer)]
        -> _bool) ; _int32
  #:c-id flif_decoder_decode_memory)

; returns the number of frames
(define/dec flif-decoder-num-images
  (_fun [decoder : _FLIF-DECODER] -> _size)
  #:c-id flif_decoder_num_images)

; only relevant for animations: returns the loop count (0 = loop forever)
(define/dec flif-decoder-num-loops
  (_fun [decoder : _FLIF-DECODER] -> _int32)
  #:c-id flif_decoder_num_loops)

; returns a pointer to a given frame, counting from 0
(define/dec flif-decoder-get-image
  (_fun [decoder : _FLIF-DECODER]
        [index : _size]
        -> _FLIF-IMAGE) ; _FLIF-IMAGE
  #:c-id flif_decoder_get_image)

; release a decoder (has to be run to avoid memory leaks)
(define/dec flif-destroy-decoder!
  (_fun [decoder : _FLIF-DECODER] -> _void)
  #:c-id flif_destroy_decoder)

; abort a decoder (may be used before decoding is completed)
(define/dec flif-abort-decoder!
  (_fun [decoder : _FLIF-DECODER] -> _int32)
  #:c-id flif_abort_decoder)

; decode options, all optional,
; can be set after decoder initialization and before actual decoding

; default check?: #f
(define/dec flif-decoder-set-crc-check!
  (_fun [decoder : _FLIF-DECODER]
        [check? : _bool]
        -> _void)
  #:c-id flif_decoder_set_crc_check)

; valid quality: 0 - 100
(define/dec flif-decoder-set-quality!
  (_fun [decoder : _FLIF-DECODER]
        [quality : _int32]
        -> _void)
  #:c-id flif_decoder_set_quality)

; valid scales (powers of 2): 1,2,4,8,16,...
(define/dec flif-decoder-set-scale!
  (_fun [decoder : _FLIF-DECODER]
        [scale : _uint32]
        -> _void)
  #:c-id flif_decoder_set_scale)

(define/dec flif-decoder-set-resize!
  (_fun [decoder : _FLIF-DECODER]
        [width : _uint32]
        [height : _uint32]
        -> _void)
  #:c-id flif_decoder_set_resize)

(define/dec flif-decoder-set-fit!
  (_fun [decoder : _FLIF-DECODER]
        [width : _uint32]
        [height : _uint32]
        -> _void)
  #:c-id flif_decoder_set_fit)

#|
Progressive decoding: set a callback function. The callback will be called
after a certain quality is reached, and it should return the desired next
quality that should be reached before it will be called again. The qualities
are expressed on a scale from 0 to 10000 (not 0 to 100!) for fine-grained
control.
|#

; valid quality: 0 - 10000
(define/dec flif-decoder-set-callback!
  (_fun [decoder : _FLIF-DECODER]
        [callback : (_fun [quality : _int32]
                          [bytes-read : _int64]
                          -> _uint32)]
        -> _void)
  #:c-id flif_decoder_set_callback)

; valid quality: 0 - 10000
(define/dec flif-decoder-set-first-callback-quality!
  (_fun [decoder : _FLIF-DECODER]
        [quality : _int32]
        -> _void)
  #:c-id flif_decoder_set_first_callback_quality)

; Reads the header of a FLIF file and packages it as a FLIF_INFO struct.
; May return a null pointer if the file is not in the right format.
; The caller takes ownership of the return value and must call flif_destroy_info().
(define/dec flif-read-info-from-memory
  (_fun [buffer : _bytes]
        [buffer-len : _size = (bytes-length buffer)]
        -> _FLIF-INFO)
  #:c-id flif_read_info_from_memory)

; deallocator function for FLIF_INFO
(define/dec flif-destroy-info!
  (_fun [info : _FLIF-INFO] -> _void)
  #:c-id flif_destroy_info)

; get the image width
(define/dec flif-info-get-width
  (_fun [info : _FLIF-INFO] -> _uint8)
  #:c-id flif_info_get_width)

; get the image height
(define/dec flif-info-get-height
  (_fun [info : _FLIF-INFO] -> _uint8)
  #:c-id flif_info_get_height)

; get the number of color channels
(define/dec flif-info-get-nb-channels
  (_fun [info : _FLIF-INFO] -> _uint8)
  #:c-id flif_info_get_nb_channels)

; get the number of bits per channel
(define/dec flif-info-get-depth
  (_fun [info : _FLIF-INFO] -> _uint8)
  #:c-id flif_info_get_depth)

; get the number of animation frames
(define/dec flif-info-num-images
  (_fun [info : _FLIF-INFO] -> _size)
  #:c-id flif_info_num_images)
