include <_conf/_config.scad>
include <_conf/colors.scad>
include <_positions.scad>
include <_conf/colors.scad>
include <utils/bom.scad>
include <vitamins/washers.scad>
include <vitamins/screws.scad>
include <vitamins/stepper-motors.scad>

module motor_mount(type = NEMA17) {
	//translate([-extrusion_diag/2, -NEMA_width(type) + mount_thickness, extrusion_diag / 2 - mount_thickness /4 ]) {
	difference() {
		union() {
			translate([-extrusion_diag/2 + mount_thickness,extrusion_diag/2 - mount_thickness,0])
			color(plastic_part_color("Yellow")) {
			cube(
				[
				NEMA_width(type) + extrusion_diag - mount_thickness,
				NEMA_width(type) + extrusion_diag - mount_thickness,
				mount_thickness
				],
				center=true
				);
			}

		}
		translate([-extrusion_diag * 2 , -extrusion_diag + mount_thickness, 0])
			cylinder(h=mount_thickness + eta, r=extrusion_diag, center=true);
		translate([extrusion_diag, extrusion_diag * 2 - frame_corner_thickness, 0])
			cylinder(h=mount_thickness + eta, r=extrusion_diag, center=true);
		cylinder(h=mount_thickness*2, r=NEMA_big_hole(type), center=true);
		for(x = NEMA_holes(type))
	        for(y = NEMA_holes(type))
	            translate([x, y, 0])
	                cylinder(r = 3/2, h = mount_thickness*2, center = true);
	}
	%translate([0,0,-mount_thickness/2])
	NEMA(type);
	translate([0, 0, mount_thickness]/2)
	NEMA_screws(type, screw_length = 8 + mount_thickness, screw_type = M3_cap_screw);
	//}
}

motor_mount();
