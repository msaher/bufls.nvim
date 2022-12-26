# `bufls`: Interactively list buffers.

Vim's `ls` feature displays a list of buffers. When the user wants to switch to
a buffer he or she has to take note of the buffer number, and manually switch
to it using `:b x`, or type its name using `:b <buffer name>`. This is
inconvenient, This simple plugin allows you to pick buffers interactively using
a floating window through the `require('bufls').ls()` function.

You can then navigate to your desired buffer by pressing `<CR>`. You can
additionally delete the currently hovered buffer by pressing `d`
