
include <_config.scad>
module square_tube(w = extrusion_size, h = extrusion_size, l) {
	cube([w,h,l]);
}

square_tube(l=200);