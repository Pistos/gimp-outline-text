(script-fu-register
  "script-fu-outline-text"
  "Outline Text"                                  ;menu label
  "Outlines text with a feathered outline using the current background colour.  Version 1.2.0"  ;description
  "Pistos"                             ;author
  "Copyright 2016-2020, Pistos"        ;copyright notice
  "2016-05-31"                          ;date created
  ""                     ;image type that the script works on
  SF-IMAGE "image" -1 ; "Input image"
  SF-DRAWABLE "layer" -1 ; "Input layer"
  SF-VALUE "outlineSize" "10" ; "Size of outline (in pixels):"
  SF-VALUE "layerOpacity" "70" ; "Opacity of new layer (in percent):"
)

(script-fu-menu-register "script-fu-outline-text" "<Image>/Filters/Light and Shadow")

(define (script-fu-outline-text image layer outlineSize layerOpacity)
  (gimp-progress-init
    (string-append
      "Outlining text on layer '"
      (car (gimp-item-get-name layer))
      "'..."
    )
    -1  ; separate window
  )

  (let*
    (
      (colour -1)
      (activeLayer -1)
      (newLayer -1)
    )

    (gimp-undo-push-group-start image)

    (set! activeLayer
      (car (gimp-image-get-active-layer image))
    )
    (set! colour
      (car (gimp-text-layer-get-color layer))
    )

    (gimp-image-select-color image CHANNEL-OP-ADD activeLayer colour)

    (gimp-selection-grow image outlineSize)

    (set! newLayer
      (car (gimp-layer-new
        image
        (car (gimp-image-width image))
        (car (gimp-image-height image))
        RGBA-IMAGE
        (string-append
          "Outline of "
          (car (gimp-item-get-name layer))
        )
        layerOpacity
        0
      ))
    )

    (gimp-image-insert-layer image newLayer -1 1)
    (gimp-selection-feather image outlineSize)
    (gimp-edit-fill newLayer BACKGROUND-FILL)
    (gimp-selection-none image)

    (gimp-undo-push-group-end image)

    (gimp-displays-flush)
  )
)
