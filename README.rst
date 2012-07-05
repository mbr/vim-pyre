====================================================
Perl-style regular expressions in VIM through Python
====================================================

A small vim plugin that adds a new command: ``:S``. It works somewhat similiar
to the regular ``:s``, but all regular expressions are split using a python
script and evaluated with Python's ``re``-module.

Examples::

  :%S/foo/bar/g                " replaces 'foo' with 'bar' in the whole document
  :S/hello, (\w+)/goodbye \1   " replace strings like "hello bob" with
                               " "goodbye bob" on the current line
  :'<,'>S#[cK]orn#candy#       " replaces all instances of "corn" and "Korn"
                               " with "candy"

Installation
------------

To install, simply copy ``pyre.vim`` into your ``.vim/plugin`` folder. Or use
`VAM <https://github.com/MarcWeber/vim-addon-manager>`_
