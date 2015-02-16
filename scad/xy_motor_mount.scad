include <conf/config.scad>
include <_positions.scad>
use <frame.scad>

function motor_offset(type) = NEMA_width(type)/2 + XY_motor_clearance + extrusion_diag/2;

module xy_motor_assembly(type = XY_motor) {
	assembly("xy_motor");
	frame_corner_screws(frame_corner_top_holes());
	xy_motor_mount_stl(type);
	translate([-motor_offset(type),motor_offset(type),extrusion_diag/2 -mount_thickness/2]) {
		NEMA(type);
		translate([0, 0, mount_thickness]) {
			metal_pulley(pulley_type);
			NEMA_screws(type, screw_length = 8 + mount_thickness, screw_type = M3_cap_screw);
		}
	}
	end("xy_motor");
}


module xy_motor_mount_stl(type = XY_motor) {
	stl("xy_motor_mount");
	render() frame_corner();
	translate([-motor_offset(type),motor_offset(type),extrusion_diag/2])
	difference() {
		union() {
			color(plastic_part_color("Yellow")) {
			cube(
				[
				NEMA_width(type) + XY_motor_clearance*2,
				NEMA_width(type) + XY_motor_clearance*2,
				mount_thickness
				],
				center=true
				);
			}

		}
		NEMA_all_holes(type);
	}
}

xy_motor_assembly();
//xy_motor_mount_stl(NEMA17);
