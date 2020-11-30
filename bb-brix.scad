include <vars.scad>;

use <roundcubes.scad>;

assert(_size >= 10);
assert(_height >= 10);
assert(_wall >= 1);
assert(_wall * 5 < _size);
assert(_gap > 0);
assert(_nubHeight < _height + _wall);
assert(_nubGap > 0);

module Brick(nubCountX, nubCountY, height = _height) {
    assert(nubCountX > 0);
    assert(nubCountY > 0);
    
    xSize = (nubCountX * _size) + ((nubCountX - 1) * _gap);
    ySize = (nubCountY * _size) + ((nubCountY - 1) * _gap);
        
    difference() {
        Outer(nubCountX, nubCountY, height);
        Inner(nubCountX, nubCountY, height);
        Logo(height);
    };
}

module BrickL(nubCountX, nubCountY, invert = false) {
    assert(nubCountX > 1);
    assert(nubCountY > 1);
    
    BrickT(nubCountX, nubCountY, nubCountX, invert);
}

module BrickT(nubCountX, nubCountY, offset, invert = false) {
    assert(nubCountX > 1);
    assert(nubCountY > 1);
    assert(offset > 0 && offset <= nubCountX);
    
    rotationZ = invert ? 180 : 0;
    legStartX = (offset - (invert ? 0 : 1)) * _size * (invert ? -1 : 1);
    legStartY = invert ? -_size : 0;
    
    Brick(nubCountX, 1);
    
    rotate([0, 0, rotationZ]) {
        translate([legStartX, legStartY, 0]) {
            Brick(1, nubCountY);
        };
    };
}

module BrickSquare(nubCountX, nubCountY) {
    assert(nubCountX > 2);
    assert(nubCountY > 2);
    
    BrickL(nubCountX, nubCountY);
    
    translate([nubCountX * _size, nubCountY * _size, 0]) {
        rotate([0, 0, 180]) {
            BrickL(nubCountX, nubCountY);
        };
    };
}

module Baseplate(nubCountX, nubCountY) {
    assert(nubCountX > 2);
    assert(nubCountY > 2);
    
    Brick(nubCountX, nubCountY, _baseHeight);
}

module Outer(nubCountX, nubCountY, height = _height) {
    assert(nubCountX > 0);
    assert(nubCountY > 0);
    
    xSize= nubCountX * _size;
    ySize = nubCountY * _size;
    
    rcube(size = [xSize, ySize, height]);

    for (nubX = [0 : nubCountX - 1]) {
        for (nubY = [0 : nubCountY - 1]) {
            translate([(nubX * _size) + (nubX * _gap), (nubY * _size) + (nubY * _gap), height]) {
                NubOuter();
            };
        }
    }
}

module Inner(nubCountX, nubCountY, height = _height) {
    assert(nubCountX > 0);
    assert(nubCountY > 0);

    for (nubX = [0 : nubCountX - 1]) {
        for (nubY = [0 : nubCountY - 1]) {
            translate([(nubX * _size) + (nubX * _gap), (nubY * _size) + (nubY * _gap), 0]) {
                if (height > _nubHeight + _nubGap + _wall) {
                    translate([_wall, _wall, 0]) {
                        BrickInnerPoly(height);
                    };
                }
                
                translate([0, 0, height]) {
                    NubInner();
                };
            };
        }
    }
}

module BrickInnerPoly(height = _height) {
    xCutoutSize = _size - _wall_x2;
    yCutoutSize = _size - _wall_x2;
    cutoutLowerY = _nubHeight + _nubGap;
    cutoutUpperOffset = _nubOffset + _wall;
    
    polyhedron(
        points = [
            [0, 0, 0],
            [xCutoutSize, 0, 0],
            [xCutoutSize, yCutoutSize, 0],
            [0, yCutoutSize, 0],
    
            [0, 0, cutoutLowerY],
            [xCutoutSize, 0, cutoutLowerY],
            [xCutoutSize, yCutoutSize, cutoutLowerY],
            [0, yCutoutSize, cutoutLowerY],
    
            [cutoutUpperOffset, cutoutUpperOffset, height - _wall],
            [xCutoutSize - cutoutUpperOffset, cutoutUpperOffset, height - _wall],
            [xCutoutSize - cutoutUpperOffset, yCutoutSize - cutoutUpperOffset, height - _wall],
            [cutoutUpperOffset, yCutoutSize - cutoutUpperOffset, height - _wall]
        ],
        faces = [
            [0, 1, 2], [2, 3, 0],       // bottom
            
            [4, 1, 0], [1, 4, 5],       // side A
            [5, 2, 1], [2, 5, 6],       // side B
            [6, 3, 2], [3, 6, 7],       // side C
            [7, 0, 3], [0, 7, 4],       // side D
            
            [8, 5, 4], [5,   8,  9],    // slope A
            [9, 6, 5], [6,   9, 10],    // slope B
            [10, 7, 6], [7,  10, 11],   // slope C
            [11, 4, 7], [4,  11,  8],   // slope D
            
            [10, 9, 8], [8, 11, 10]     // top
        ]
    );
}

module Nub() {
    difference() {
        rcube([_nubSize, _nubSize, _nubHeight], center = true);
        NubChamfer();
    };
}

module NubOuter() {
    translate([_size / 2, _size / 2, _nubHeight / 2]) {
        Nub();
    };
}

module NubInner() {
    size = _nubSize - _wall_x2;
    
    translate([_size / 2, _size / 2, _nubHeight / -3]) {
        resize([size, size, _nubHeight * 3]) {
            Nub();
        };
    };
}

module NubChamfer() {
    chamferDiameter = _size + _wall_x2;
    chamferOffset = _size / 2;
    innerChamferDiameter = _size - _wall;
    
    difference() {
        cylinder(h = _nubHeight, d = chamferDiameter, center = true);
        cylinder(h = _nubHeight, d = innerChamferDiameter, center = true);
    };
}

module Logo(height = _height) {
    font = "Liberation Mono";
    
    translate([1, .5, 1.5]) {
        rotate([90, 0, 0]) {
            linear_extrude(height = 2) {
                text("bbBrix", size = 5, font = font);
                
                translate([24, 0, 10]) {
                    text("TM", size = 2, font = font);
                };
            };
        };
    };
}
/* 
    Command-line Support
    -------------------------

    Options:
        action  "brick" to generate a standard brick -- requires: x, y
                "brick-l" to generate an "L" brick -- requires: x, y
                "brick-t" to generate a "T" brick -- requires: x, y, offset
        x       nub-count in X direction
        y       nub-count in Y direction
        offset  for "T" bricks, where to render the stem of the "T"
*/

action = undef;

if (action != undef) {
    // all require x & y
    assert(x != undef);
    assert(y != undef);

    if (action == "brick") {
        Brick(x, y);
    }
    else if (action == "brick-l") {
        BrickL(x, y);
    }
    else if (action == "brick-t") {
        assert(offset != undef);

        BrickT(x, y, offset);
    }
    else {
        echo("Unsupported action: ", action);
    }
}
