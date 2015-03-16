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
}

machine_assembly();

