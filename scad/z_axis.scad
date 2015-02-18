include <conf/config.scad>
include <_positions.scad>
use <bed.scad>
use <carriage.scad>

module z_assembly() {
	assembly("Z Axis");
	for (i = [1, -1]) {
		translate([
			i * (envelope_dimensions.x/2 -carriage_width - thick_wall/2),
			dimensions.y/2 - extrusion_diag,
			0
		]) {
			rotate([0,0,(i>0 ? 0 : 180)])
				z_rail_assembly();
			translate([0, extrusion_diag/2 - frame_corner_thickness/2, dimensions.z/2]) {
				render() z_rail_top_stl();
				z_rail_top_vitamins();
			}
			translate([0, extrusion_size/2 + frame_corner_thickness/2, -dimensions.z/2]) {
				render() z_rail_bottom_stl();
				z_rail_bottom_vitamins();
			}
		}
	}

	translate([0,0,-envelope_dimensions.z/2 - pillar_height(bed_pillars)])
		bed_assembly();

	end("Z Axis");
}

module z_rail_assembly() {
	assembly("Z Rail");

	rotate([0,0,-45]) {
		square_tube(tube_dimensions, dimensions.z + extrusion_size/2 + extrusion_diag/2);
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

module z_rail_bottom_stl() {
	stl("z_rail_bottom");
	difference() {
		union() {
			cube([
				extrusion_diag + frame_corner_thickness*2,
				extrusion_diag + extrusion_size + frame_corner_thickness*3,
				extrusion_size + frame_corner_thickness*2
				], center=true);
		}
		translate([0, -extrusion_size/2 - frame_corner_thickness/2,0])
			rotate([0,0,45])
				cube(size=[extrusion_size,extrusion_size, extrusion_size*4], center=true);
		translate([0,extrusion_diag/2 + frame_corner_thickness/2,0])
			cube(size=[extrusion_size*4,extrusion_size, extrusion_size], center=true);
		z_rail_bottom_layout()
			screw_hole(frame_thick_screw, extrusion_size);
	}
}
module z_rail_bottom_vitamins() {
	z_rail_bottom_layout()
		screw_and_washer(frame_thick_screw, screw_longer_than(frame_corner_thickness*2 + tube_dimensions.z));
}

module z_rail_bottom_layout() {
	for(i=[1, -1]) {
		translate([0, -extrusion_size/2 - frame_corner_thickness/2, 0])
		rotate([0,90,i*45 - 90])
		translate([0, 0, (extrusion_size/2 + frame_corner_thickness*2)])
			children();
		translate([0, extrusion_diag/2 + frame_corner_thickness/2, 0])
		rotate([(i > 0 ? -90 : 0),0,0])
		translate([0, 0, extrusion_size/2 + frame_corner_thickness + eta])
			children();
	}
}



module z_rail_top_stl() {
	stl("z_rail_top");
	difference() {
		union() {
			translate([0,frame_corner_thickness/3*2,0])
			cube([
				extrusion_diag + frame_corner_thickness*2,
				extrusion_diag + extrusion_diag + frame_corner_thickness*2,
				extrusion_diag + frame_corner_thickness*2
				], center=true);
		}
		translate([0, -extrusion_size/2 - frame_corner_thickness/2,0])
			rotate([0,0,45])
				cube(size=[extrusion_size,extrusion_size, extrusion_size*4], center=true);
		translate([0,extrusion_diag/2 + frame_corner_thickness/2,0])
			rotate([45,0,0])
				cube(size=[extrusion_size*4,extrusion_size, extrusion_size], center=true);
		z_rail_top_layout()
			screw_hole(frame_thick_screw, extrusion_size);
	}
}
module z_rail_top_vitamins() {
	z_rail_top_layout()
		screw_and_washer(frame_thick_screw, screw_longer_than(frame_corner_thickness*2 + tube_dimensions.z));
}

module z_rail_top_layout() {
	for(i=[1, -1]) {
		translate([0, -extrusion_size/2 - frame_corner_thickness/2, 0])
		rotate([0,90,i*45 - 90])
		translate([0, 0, (extrusion_size/2 + frame_corner_thickness*2)])
			children();
		translate([0, extrusion_diag/2 + frame_corner_thickness/2, 0])
		rotate([-90 - i*45,0,0])
		translate([0, 0, extrusion_size/2 + frame_corner_thickness*2])
			children();
	}
}




z_assembly();
//z_rail_assembly();

//z_rail_bottom_stl();
//z_rail_bottom_vitamins();

//z_rail_top_stl();
//z_rail_top_vitamins();
