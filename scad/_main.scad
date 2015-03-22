include <conf/config.scad>
include <_positions.scad>

use <frame.scad>
use <xy_motor_mount.scad>
use <bits.scad>
use <carriage.scad>
use <z_axis.scad>
use <ps_cover.scad>

module machine_assembly() {
	frame_assembly();
	translate([0,0,frame_offset.z])
		xy_carriage_assembly();
	vitamin(str("BT", belt_pitch(XY_belt) * 10,belt_width(XY_belt), round(dimensions.x + dimensions.y)*2, ": Belt T", belt_pitch(XY_belt)," x ", belt_width(XY_belt), "mm x ", round(dimensions.x + dimensions.y)*2, "mm"));
	vitamin(str("BT", belt_pitch(XY_belt) * 10,belt_width(XY_belt), round(dimensions.x + dimensions.y)*2, ": Belt T", belt_pitch(XY_belt)," x ", belt_width(XY_belt), "mm x ", round(dimensions.x + dimensions.y)*2, "mm"));
	translate([0,-carriage_height/2,carriage_width/2])
		color("DarkGreen", 0.2) %cube(size=envelope_dimensions, center=true);

	z_assembly();

	vitamin(str("PSU12: Power Supply 12V 30A"));
	translate([dimensions.x/2 - ps_cover_dim.y,dimensions.y/2 - ps_cover_dim.z,-dimensions.z/2 + ps_cover_dim.x/2])
		rotate([0,90,180])
			ps_cover_stl();
	translate([dimensions.x/2 - extrusion_diag, 0, 0])
		render() y_endstop_flag_stl();
	translate([-dimensions.x/2 + extrusion_diag, dimensions.y/2 - extrusion_diag, 0])
		render() y_endstop_flag_stl();


	translate([dimensions.x/2,dimensions.y/2,envelope_dimensions.z/2])
		rotate([0,0,180])
		render() frame_clip_stl();
	translate([dimensions.x/2,dimensions.y/2,envelope_dimensions.z/2 - 99])
		rotate([0,0,180])
		render() frame_clip_stl();
	color("purple")
		translate([dimensions.x/2 - extrusion_diag/2, dimensions.y/2 - 150, 30])
		rotate([90,-90,-90]) {
			render() smoothie_box_stl();
			translate([170,0,50])
				rotate([0,180,0])
				render() smoothie_box_lid_stl();
	}
}

module smoothie_box_stl() {
	stl("smoothie_box");
	import("../imported_stls/Smoothie_Box_-_bottom_-_rev2_-_with_brim.stl");
}
module smoothie_box_lid_stl() {
	stl("smoothie_box_lid");
	import("../imported_stls/Lid_-_rev1_-_with_brim.stl");
}

module frame_clip_stl() {
	stl("frame_clip");
	difference() {
		union() {
			cube(size=[extrusion_size + default_wall*2, extrusion_size+default_wall, extrusion_size], center=true);
			translate([-extrusion_size/2 - default_wall/2, extrusion_size*3/2+1.5, 0])
			cube(size=[default_wall, extrusion_size*3+3, extrusion_size], center=true);
		}
		translate([0, -default_wall/2, 0])
		cube(size=[extrusion_size, extrusion_size, extrusion_size*2], center=true);
		for(i=[extrusion_size/3*2, extrusion_size/3*4, extrusion_size/3*6, extrusion_size/3*8])
			translate([-extrusion_size/2 - default_wall/2, i, 0])
			rotate([90,0,90])
			slot(screw_radius(frame_thick_screw)*2, 2, extrusion_size/3, center = true);
		rotate([0,90,0])
			nut_trap(screw_radius(frame_thick_screw));
	}
}

//frame_clip_stl();
machine_assembly();

