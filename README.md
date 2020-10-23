kjv-mode
======================================================================

An Emacs minor mode to insert passages from the King James Bible in
plain text, Markdown, LaTeX, or HTML.

Commentary
----------------------------------------------------------------------

To use this minor mode, you must have the the
[`kjv`](https://github.com/JasonFruit/kjv) command-line utility
installed and on your PATH.

To install kjv.el, save it somewhere in your Emacs load path and put
the following in your .emacs:

  (require 'kjv)

To toggle kjv-mode, which is initially off, do:

  M-x kjv-mode

Once kjv-mode is active, the following default keybindings will be
created:

  C-c C-i: insert a passage
  C-c C-o: choose a different format (plain text, Markdown, LaTeX,
           or HTML)
  C-c C-p: search for a phrase
  C-c C-m: search for multiple words
  
To automatically set the format based on the extension of the current
buffer, call `kjv-auto-set-format`.
