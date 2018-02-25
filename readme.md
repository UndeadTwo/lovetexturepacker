Written for Love, https://love2d.org/
Uses moses, https://github.com/Yonaba/Moses

To use:

Assuming this is cloned to the default folder, place the file you want to generate a sheet from, with background alpha set to 0 and
run love lovetexturepacker imagehere width

to generate an image of given width from the sprites contained in the image.

Performance will likely be slow with large images, and the exported sheets are not efficiently packed.

The result is exported to these directories:

Windows XP 	C:\Documents and Settings\user\Application Data\LOVE\ 	%appdata%\LOVE\
Windows Vista, 7, 8 and 10 	C:\Users\user\AppData\Roaming\LOVE 	%appdata%\LOVE\
Mac 	/Users/user/Library/Application Support/LOVE/
Linux 	$XDG_DATA_HOME/love/ 	~/.local/share/love/