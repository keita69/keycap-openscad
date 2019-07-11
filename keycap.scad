$fs = 0.1;
$fa = 0.25;
stem_outer_size = 5.5;
stem_cross_length = 4.0;
stem_cross_h      = 1.25;
stem_cross_v      = 1.10;

module stem () {
    difference () {
      cylinder(d = stem_outer_size, h = 15);
      // 十字部分
      translate([- stem_cross_h / 2, - stem_cross_length / 2, 0])
        cube([stem_cross_h, stem_cross_length, 15]);
      translate([- stem_cross_length / 2, - stem_cross_v / 2, 0])
        cube([stem_cross_length, stem_cross_v, 15]);
    }
}

module rounded_cube (size, r) {
  h = 0.0001; // cylinder の高さ (適当な値)
  minkowski () {
    cube([size[0] - r*2, size[1] - r*2, size[2] - h], center = true);
    cylinder(r = r, h = h);
  }
}

// w * 1.2 ≒ √2 （対角線の長さ）
function dish_r(w, d) = (w * 1.2 * w * 1.2 + 4 * d * d) / (8 * d);

module keycap_outer_shape (key_bottom_size, key_top_size, key_top_height, angle, dish_depth) {
  difference () {
    hull () {
      translate([0, 0, key_top_height])
        rotate([- angle, 0, 0])
          rounded_cube([key_top_size, key_top_size, 0.01], 3);
      rounded_cube([key_bottom_size, key_bottom_size, 0.01], 0.5);
    }
    translate([0, 0, key_top_height])
      rotate([- angle, 0, 0])
        translate([0, 0, dish_r(key_top_size, dish_depth) - dish_depth])
          rotate([90, 0, 30])
            cylinder(r = dish_r(key_top_size, dish_depth), h = 60, /* 適当に十分な長さ */ center = true);
  }
}

module keycap_shape () {
  difference () {
    keycap_outer_shape(18, 14, 8, 10, 1);
    keycap_outer_shape(15, 11, 6.5, 10, 1);
  }
}

intersection () {
  stem();
  keycap_outer_shape(18, 14, 8, 10, 2);
}

keycap_shape();
