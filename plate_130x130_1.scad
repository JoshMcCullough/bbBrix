include <vars.scad>;

use <bb-brix.scad>;

_padding = 3;
_paddedSize = _size + _padding;

// 1x1 
for (i = [0 : 3]) {
    translate([i * _paddedSize, 0, 0]) {
        Brick(1, 1);
    };
}

// 1x2
translate([0, _paddedSize, 0]) {
    for (i = [0 : 1]) {
        translate([i * _paddedSize, 0, 0]) {
            Brick(1, 2);
        };
    }
        
    translate([0, (3 * _paddedSize) - (2 * _padding), 0]) {
        rotate([0, 0, -90]) {
            Brick(1, 2);
        };
    };
};

// 1x3
translate([2 * _paddedSize, _paddedSize, 0]) {
    for (i = [0 : 1]) {
        translate([i * _paddedSize, 0, 0]) {
            Brick(1, 3);
        };
    }
};
