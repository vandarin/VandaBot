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
}

machine_assembly();
