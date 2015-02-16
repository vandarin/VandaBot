include <conf/config.scad>
include <_positions.scad>
use <bed.scad>

module z_assembly() {
	assembly("Z Axis");
	translate([0, dimensions.z/2 - extrusion_diag*2,0])
		z_rail_assembly();

	translate([0,0,-envelope_dimensions.z/2 - 20])
		bed_assembly();

	end("Z Axis");
}

module z_rail_assembly() {
	assembly("Z Rail");

    square_tube(tube_dimensions, dimensions.z);
	end("Z Rail");
}
