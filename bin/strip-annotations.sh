pdftk original.pdf output uncompressed.pdf uncompress
LANG=C sed -n '/^\/Annots/!p' uncompressed.pdf > stripped.pdf
pdftk stripped.pdf output final.pdf compress
