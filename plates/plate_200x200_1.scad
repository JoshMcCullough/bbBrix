include <../bb-brix.scad>;
include <../vars.scad>;

_padding = 3;
_paddedSize = _size + _padding;

// 1x1 
for (i = [0 : 5]) {
    translate([i * _paddedSize, 0, 0]) {
        Brick(1, 1);
    };
}

translate([0, (5 * _paddedSize) - (2 * _padding), 0]) {
    for (i = [0 : 5]) {
        translate([i * _paddedSize, 0, 0]) {
            Brick(1, 1);
        };
    }
};

// 1x2
translate([0, _paddedSize, 0]) {
    for (i = [0 : 1]) {
        translate([i * _paddedSize, 0, 0]) {
            Brick(1, 2);
        };
        
        translate([i * _paddedSize, (2 * _paddedSize) - _padding, 0]) {
            Brick(1, 2);
        };
        
        translate([(((i * 2) + 2) * _paddedSize) - (i * _padding), (4 * _paddedSize) - (3 * _padding), 0]) {
            rotate([0, 0, -90]) {
                Brick(1, 2);
            };
        };
    }
};

// 1x3
translate([2 * _paddedSize, _paddedSize, 0]) {
    for (i = [0 : 3]) {
        translate([i * _paddedSize, 0, 0]) {
            Brick(1, 3);
        };
    }
};
