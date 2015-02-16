include <conf/config.scad>
include <_positions.scad>
use <bed.scad>
use <carriage.scad>

module z_assembly() {
	assembly("Z Axis");
	for (i = [1, -1]) {
		translate([
			i * (envelope_dimensions.x/2 -carriage_width - thick_wall/2),
			dimensions.z/2 - extrusion_diag*2,
			0
		])
		rotate([0,0,(i>0 ? 0 : 180)])
		z_rail_assembly();
	}

	translate([0,0,-envelope_dimensions.z/2 - pillar_height(bed_pillars)])
		bed_assembly();

	end("Z Axis");
}

module z_rail_assembly() {
	assembly("Z Rail");

	rotate([0,0,-45]) {

		square_tube(tube_dimensions, dimensions.z);
		translate([0, 0, -dimensions.z/2 + carriage_height]) {
			render() z_carriage_stl();
			carriage_slide_vitamins(false);
		}
	}
	translate([
		carriage_width/2 + extrusion_size/2 + thick_wall*2,
		0,
		-envelope_dimensions.z/2 - pillar_height(bed_pillars) - extrusion_size/2
		]) {
		for(i=[1,-1]) {
			translate([0, i * (carriage_width/2 - thick_wall*1.25), 0])
			rotate([0, 90, 0]) {
				translate([0,0,-screw_longer_than(extrusion_size+thick_wall+nut_thickness(screw_nut(frame_thick_screw)))])
					nut(screw_nut(frame_thick_screw));
					screw_and_washer(frame_thick_screw, screw_longer_than(extrusion_size+thick_wall+nut_thickness(screw_nut(frame_thick_screw))));
			}
		}
	}
	end("Z Rail");
}

module z_carriage_stl() {
	stl("z_carriage");
	carriage_slide(false);
}

z_assembly();
//z_rail_assembly();
