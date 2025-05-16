An adaptation of gilles castels inkscape figures for neovim:


https://github.com/gillescastel/inkscape-figures/tree/master

https://castel.dev/post/lecture-notes-2/

## Desired functionality (copied from Gilles Castel)
1. The script finds the 'figures' directory depending on the location of the LaTeX root file.
2. Then it checks if a figure with the same name exists. If so, the script does nothing.
3. If not, copy figure template to the figures directory.
4. The current line which contains the figure title gets replaced with the
   LaTeX code to include the figure.
5. The new figure opens in Inkscape.
6. A file watcher is set up such that whenever the figure is saved as an svg
   file by pressing Ctrl + S, it also gets saved as pdf+LaTeX. This means that
   the annoying pdf save dialog we’ve discussed before doesn’t pop up anymore.
