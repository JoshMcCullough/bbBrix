# bbBrix: A DIY Duplo Knock-off

Baby/toddler-friendly building bricks, for fun!

## Overview

Bricks are generated via OpenSCAD. The primary file, `bb-brix.scad` can generate bricks of any size including "L" and "T" shapes, baseplates, and "squares". Command-line variables are supported. See `make-stls.sh` and the end of `bb-brix.scad` for more information. Or you can simply download the pre-generated STLs under `/out/stl`.

## Standard Bricks

Standard bricks in common sizes/shapes are available under `/out/stl` -- simply download the STLs you'd like to create, slice them, and print them. File an issue if you feel other "common" sizes/shapes should be included.

### Plates

There are SCAD files to generate "plates" (e.g. a bunch of pieces at once) under `/plates`, and related exported STLs under `/out/stl`. Use these to get a good set of common sized/shaped blocks, but note that they will take a while to print.

## Customization

Default values are contained in `vars.scad` and result in a "friendly" sized brick that is a bit smaller than a Duplo. You can adjust these values to customize the size of your bricks.

## Printing Settings

Do as you wish, but these settings produce good quality, sturdy bricks:

- **resolution / layer height** -- .2mm
- **wall thickness** -- 1.2mm (3 walls/shells for .4mm nozzle)
- **top/bottom thickness** -- 1mm (5 layers)
- **infill density** -- 0%
- **speed** -- as fast as possible since the shapes are very simple and non-intricate.
- **support** -- off.
