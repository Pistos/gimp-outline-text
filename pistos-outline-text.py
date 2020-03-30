#!/usr/bin/env python

from gimpfu import *

def outline_text(image, layer, outline_size, layer_opacity) :
    gimp.progress_init("Outlining text on layer '" + layer.name + "'...")

    pdb.gimp_undo_push_group_start(image)

    drawable = pdb.gimp_image_get_active_drawable(image)
    colour = pdb.gimp_text_layer_get_color(layer)
    pdb.gimp_image_select_color(image, 0, drawable, colour)

    pdb.gimp_selection_grow(image, outline_size)

    new_layer = pdb.gimp_layer_new(
        image,
        pdb.gimp_image_width(image),
        pdb.gimp_image_height(image),
        RGBA_IMAGE,
        'Outline of '+layer.name,
        layer_opacity,
        0
    )
    pdb.gimp_image_insert_layer(image, new_layer, None, 1)

    pdb.gimp_selection_feather(image, outline_size)

    pdb.gimp_edit_fill(new_layer, BACKGROUND_FILL)

    pdb.gimp_selection_none(image)

    pdb.gimp_undo_push_group_end(image)

register(
    "python_fu_outline_text",
    "Outline text with background colour",
    "Outlines text with a feathered outline using the current background colour.  Version 1.1.0",
    "Pistos",
    "Pistos",
    "2016-2020",
    "Outline Text...",
    "*",
    [
        (PF_IMAGE, "image", "Input image", None),
        (PF_DRAWABLE, "drawable", "Input layer", None),
        (PF_INT, "outline_size", "Size of outline (in pixels):", 10),
        (PF_INT, "layer_opacity", "Opacity of new layer (in percent):", 70)
    ],
    [],
    outline_text,
    menu="<Image>/Filters/Light and Shadow"
)

main()
