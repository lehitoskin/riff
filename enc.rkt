#lang racket/base
; enc.rkt
(require ffi/unsafe
         ffi/unsafe/define
         "flif.rkt")
(provide (all-defined-out))

(define-ffi-definer define/enc (ffi-lib "libflif"))

; The _string type supports conversion between Racket strings
; and char* strings using a parameter-determined conversion.
; instead of using _bytes, which is unnatural, use _string
; of specified type _string*/utf-8.
(default-_string-type _string*/utf-8)

(define _FLIF-ENCODER (_cpointer 'FLIF-ENCODER))

; initialize a FLIF encoder
(define/enc flif-create-encoder (_fun -> _FLIF-ENCODER)
  #:c-id flif_create_encoder)

; give it an image to encode; add more than one image to encode an animation
(define/enc flif-encoder-add-image!
  (_fun [encoder : _FLIF-ENCODER]
        [image : _FLIF-IMAGE]
        -> _void)
  #:c-id flif_encoder_add_image)

; encode to a file
(define/enc flif-encoder-encode-file!
  (_fun [encoder : _FLIF-ENCODER]
        [filename : _string]
        -> _int32)
  #:c-id flif_encoder_encode_file)

; encode to memory
(define/enc flif-encoder-encode-memory!
  (_fun [encoder : _FLIF-ENCODER]
        [buffer : _bytes]
        [size : _size = (bytes-length buffer)]
        -> _int32)
  #:c-id flif_encoder_encode_memory)

; release an encoder (has to be called to prevent memory leaks)
(define/enc flif-destroy-encoder! (_fun [encoder : _FLIF-ENCODER] -> _void)
  #:c-id flif_destroy_encoder)

; encoder options
; (these are all optional, the defaults should be fine)

; 0 = -N, 1 = -I (default: -I)
(define/enc flif-encoder-set-interlaced!
  (_fun [encoder : _FLIF-ENCODER]
        [interlaced : _uint32]
        -> _void)
  #:c-id flif_encoder_set_interlaced)

; default: 2 (-R)
(define/enc flif-encoder-set-learn-repeat!
  (_fun [encoder : _FLIF-ENCODER]
        [learn : _uint32]
        -> _void)
  #:c-id flif_encoder_set_learn_repeat)

; 0 = -B, 1 = default
(define/enc flif-encoder-set-auto-color-buckets!
  (_fun [encoder : _FLIF-ENCODER]
        [acb : _uint32]
        -> _void)
  #:c-id flif_encoder_set_auto_color_buckets)

; default: 512
(define/enc flif-encoder-set-palette-size!
  (_fun [encoder : _FLIF-ENCODER]
        [size : _int32]
        -> _void)
  #:c-id flif_encoder_set_palette_size)

; default: 1 (-L)
(define/enc flif-encoder-set-lookback!
  (_fun [encoder : _FLIF-ENCODER]
        [lookback : _int32]
        -> _void)
  #:c-id flif_encoder_set_lookback)

; default: 30 (-D)
(define/enc flif-encoder-set-divisor!
  (_fun [encoder : _FLIF-ENCODER]
        [divisor : _int32]
        -> _void)
  #:c-id flif_encoder_set_divisor)

; default: 50 (-M)
(define/enc flif-encoder-set-min-size!
  (_fun [encoder : _FLIF-ENCODER]
        [min-size : _int32]
        -> _void)
  #:c-id flif_encoder_set_min_size)

; default: 64 (-T)
(define/enc flif-encoder-set-split-threshold!
  (_fun [encoder : _FLIF-ENCODER]
        [threshold : _int32]
        -> _void)
  #:c-id flif_encoder_set_split_threshold)

; 0 = default, 1 = -K
(define/enc flif-encoder-set-alpha-zero-lossless!
  (_fun [encoder : _FLIF-ENCODER] -> _void)
  #:c-id flif_encoder_set_alpha_zero_lossless)

; default: 2 (-X)
(define/enc flif-encoder-set-chance-cutoff!
  (_fun [encoder : _FLIF-ENCODER]
        [cutoff : _int32]
        -> _void)
  #:c-id flif_encoder_set_chance_cutoff)

; default: 19 (-Z)
(define/enc flif-encoder-set-chance-alpha!
  (_fun [encoder : _FLIF-ENCODER]
        [alpha : _int32]
        -> _void)
  #:c-id flif_encoder_set_chance_alpha)

; 0 = no CRC, 1 = add CRC
(define/enc flif-encoder-set-crc-check!
  (_fun [encoder : _FLIF-ENCODER]
        [check? : _bool]
        -> _void)
  #:c-id flif_encoder_set_crc_check)

; 0 = -C, 1 = default
(define/enc flif-encoder-set-channel-compact!
  (_fun [encoder : _FLIF-ENCODER]
        [plc : _uint32]
        -> _void)
  #:c-id flif_encoder_set_channel_compact)

; 0 = -Y, 1 = default
(define/enc flif-encoder-set-ycocg!
  (_fun [encoder : _FLIF-ENCODER]
        [ycocg : _uint32]
        -> _void)
  #:c-id flif_encoder_set_ycocg)

; 0 = -S, 1 = default
(define/enc flif-encoder-set-frame-shape!
  (_fun [encoder : _FLIF-ENCODER]
        [rfs : _uint32]
        -> _void)
  #:c-id flif_encoder_set_frame_shape)

; set amount of quality loss
; 0 = no loss
; 100 = maximum loss
; negative values indicate adaptive lossy (second image should be the saliency map)
; default: 0 (lossless)
(define/enc flif-encoder-set-lossy!
  (_fun [encoder : _FLIF-ENCODER]
        [loss : _int32]
        -> _void)
  #:c-id flif_encoder_set_lossy)
