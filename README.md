docx2md
=======

This is a shell script that will convert a Word-document into a markdown document with YAML Front Matter. When the document contains media, it is saved in a sub-folder with the same name as the Word-document minus the extension. 

Example: the document `my book.docx` will be converted to `my book.md` and the media are stored in `my book\`.

It uses [pandoc][] to convert the Word document to Markdown. However, the front matter export was not what I needed, so I hacked my own, and this repository is the result.


Installation
------------

* Clone or download this repository
* Make sure you have `pandoc` and `python3` installed
* Run `./docx2md.sh WORD_DOCUMENT.docx`
	-  or run `./configure.sh install`, so you can run `docx2md WORD_DOCUMENT.docx`


Todo
----

* Actually test with Jekyll
* media export is not 100%. Path is now relative to where the script is executed, not relative to document. Also, pandoc still creates a sub-folder "media".
* Use `find` in python for proper namespace support (simplify code)
* Do installion (symlink etc.)


  [pandoc]: https://pandoc.org
