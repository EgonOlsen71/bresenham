# bresenham
A line drawing, point plotting and flood filling routine for the C64's hires graphics mode written in 6502-assembly language. The goal of this small project isn't to provide the fastest line drawing routine possible but to create something reasonable fast that can be used from within BASIC without relying on an extension or some interpreter hacks like SYS X,Y,Z.

The main reason for this is to keep it "compiler friendly", because while some compilers, like MOSpeed, can compile variants of the SYS X,Y,Z hack, the results usually aren't as fast as they could be. So this routine relies on the required values simply being poked into memory at 780-782 before calling the actual function via SYS.

By default, the routines assume the graphics memory to be located at $2000 and the screen memory at $0400. If something else is desired, one has to modify the assembly code slightly by adjusting two constants at the start (and modify the hires enable and disable routines).

These calls are supported:

**Enable hires mode**

This call is simple: SYS 49152 switched hires graphics on.

**Disable hires mode**

Just call SYS 49155 to disable hires graphics.

**Clear screen and set color**

This call combines clearing the screen with setting the color. Poke the color (foreground * 16 + background) into 780 and call SYS 49158.

**Plot a point**

Plots a point in the foreground color. Poke the coordinates into 780/781 (x-low and x-high) and 782 (y). Then call SYS 49161.

**Clear a point**

The  setup is the same as plotting a point, but call SYS 49173 instead.

**Draw a line**

Line drawing is split into two calls. The first one sets the start of the line, the seconds one the end point. Both points have to be, just like when plotting a single point, poked into 780/781 for x-low and x-high and 782 for y. So...

* setup the coordinates of the start point, then call SYS 49164 to set it.
* setup the coordinates of the end point, then call SYS 49167 to draw the line from start to end.

**Clear a line**

The setup is the same as when drawing a line and so is the call to set the first point: SYS 49164. Then setup the second point and call SYS 49170 to clear the line.

**Flood fill**

Poke the seed coordinates into 780/781 (x-low and x-high) and 782 (y), then call SYS 49176 to fill starting from that point. The algorithm uses a stack that extends after the actual machine language code and up to $D000, if required.


**Sources and building the project**

The project can build with MOSpeed:  https://github.com/EgonOlsen71/basicv2
MOSpeed is required to assemble the assembly language parts (albeit some other assembler might work as well with minor modifications) and to compile the BASIC parts. If you don't want to build the project your own, you can just use the pre-built prg-files in the build-directory (see description below).

In the src-directory, you'll find the assembly language sources in *asm* and two BASIC basic example in *basic*. In *build*, you'll find several files:

* c1541.exe - a helpful utility from the VICE project to create a D64 image. The license for VICE applies to this file.
* build.cmd - a build script for Windows to assemble and compile the source files and create a D64 image from them
* graphics_AD.d64 - the D64 image containing the routines and the examples
* graphics.prg - the graphics rountines
* ++example.prg - a compiled version of the first example (some funny lines)
* ++example2.prg - a compiled version of the second example (a 3d view of a function)
* ++example3.prg - a compiled version of the third example (a flood fill example)

