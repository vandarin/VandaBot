include <conf/config.scad>


use <frame.scad>
use <motor_mount.scad>
use <bits.scad>

module machine_assembly() {
	frame_assembly();
}

machine_assembly();
