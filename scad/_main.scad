include <conf/config.scad>
include <_positions.scad>

use <frame.scad>
use <motor_mount.scad>
use <bits.scad>
use <carriage.scad>

module machine_assembly() {
	frame_assembly();
	translate([0,0,frame_offset.z])
		xy_carriage_assembly();
	vitamin(str("BT", belt_pitch(XY_belt) * 10,belt_width(XY_belt), round(dimensions.x + dimensions.y)*2, ": Belt T", belt_pitch(XY_belt)," x ", belt_width(XY_belt), "mm x ", round(dimensions.x + dimensions.y)*2, "mm"));
	vitamin(str("BT", belt_pitch(XY_belt) * 10,belt_width(XY_belt), round(dimensions.x + dimensions.y)*2, ": Belt T", belt_pitch(XY_belt)," x ", belt_width(XY_belt), "mm x ", round(dimensions.x + dimensions.y)*2, "mm"));
}

machine_assembly();
