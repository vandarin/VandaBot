include <conf/config.scad>
include <_positions.scad>
use <motor_mount.scad>
use <bits.scad>

module frame_assembly() {
	assembly("frame");
	frame_extrusions_top();
	frame_extrusions_sides();
	frame_extrusions_bottom();
	frame_corners();
	end("frame");

}


module frame_extrusions_top(showInBom=true) {
	//FRONT
	translate([0,-frame_offset.y,frame_offset.z])
		rotate([45,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - extrusion_diag - frame_corner_thickness, showInBom=showInBom);
	//LEFT
	translate([-frame_offset.x,0,frame_offset.z])
		rotate([0,45,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag, showInBom=showInBom);
	//BACK
	translate([0,frame_offset.y,frame_offset.z])
		rotate([45,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - tube_dimensions.x - frame_corner_thickness*2, showInBom=showInBom);
	//RIGHT
	translate([frame_offset.x,0,frame_offset.z])
		rotate([0,45,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag, showInBom=showInBom);

}
module frame_extrusions_bottom(showInBom=true) {
	//FRONT
	translate([0,-frame_offset.y,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - extrusion_diag - frame_corner_thickness, showInBom=showInBom);
	//LEFT
	translate([-frame_offset.x,0,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag, showInBom=showInBom);
	//BACK
	translate([0,frame_offset.y,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - tube_dimensions.x - frame_corner_thickness*2, showInBom=showInBom);
	//RIGHT
	translate([frame_offset.x,0,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag, showInBom=showInBom);

}

module frame_extrusions_sides(showInBom=true) {
	// FRONT RIGHT
	translate([frame_offset.x, -frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z,showInBom=showInBom);
	// FRONT LEFT
	translate([-frame_offset.x, -frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z,showInBom=showInBom);
	// BACK RIGHT
	translate([frame_offset.x, frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z,showInBom=showInBom);
	// BACK LEFT
	translate([-frame_offset.x, frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z,showInBom=showInBom);
}


module frame_corners() {
	difference() {
		union() {
			// FRONT TOP RIGHT
			translate([frame_offset.x,-frame_offset.y, frame_offset.z]) {
				xy_pulley_assembly();
			}
			// FRONT TOP LEFT
			translate([-frame_offset.x,-frame_offset.y, frame_offset.z]) {
				rotate([0,0,-90]) {
					xy_pulley_assembly();
				}
			}
			// BACK TOP RIGHT
			translate([frame_offset.x,frame_offset.y, frame_offset.z]) {
				rotate([0,0,90]) {
					xy_motor_assembly();
				}
			}
			// BACK TOP LEFT
			translate([-frame_offset.x,frame_offset.y, frame_offset.z]) {
				rotate([0,0,180]) {
					xy_motor_assembly();
				}
			}

			// FRONT BOTTOM RIGHT
			translate([frame_offset.x,-frame_offset.y, -frame_offset.z]) {
				rotate([0,90,0]) {
					frame_corner_bottom_stl();
					frame_corner_screws(frame_corner_bottom_holes());
				}
			}
			// FRONT BOTTOM LEFT
			translate([-frame_offset.x,-frame_offset.y, -frame_offset.z]) {
				rotate([0,90,-90]) {
					frame_corner_bottom_stl();
					frame_corner_screws(frame_corner_bottom_holes());
				}
			}
			// BACK BOTTOM RIGHT
			translate([frame_offset.x,frame_offset.y, -frame_offset.z]) {
				rotate([90,0,90]) {
					frame_corner_bottom_stl();
					frame_corner_screws(frame_corner_bottom_holes());
				}
			}
			// BACK BOTTOM LEFT
			translate([-frame_offset.x,frame_offset.y, -frame_offset.z]) {
				rotate([90,0,180]) {
					frame_corner_bottom_stl();
					frame_corner_screws(frame_corner_bottom_holes());
				}
			}

		}
	}
}


module frame_corner(angled = true) {
	//main block
	base_size = angled ? extrusion_diag + frame_corner_thickness : extrusion_size + frame_corner_thickness * 2;
	position = angled ? extrusion_diag : extrusion_size;
	difference() {
	color(plastic_part_color("Yellow"))
		union() {
			translate([-base_size/3 - position / (angled ? 2 : 1), 0, 0])
				cube(
					size=[
						base_size*1.5 + position * (angled ? 1 : 1.5),
						base_size,
						base_size
						],
					center=true
					);
			translate([0, base_size/3 + position / (angled ? 2 : 1), 0])
				cube(
					size=[
						base_size,
						base_size*1.5 + position * (angled ? 1 : 1.5),
						base_size
						],
					center=true
				);
			translate([0,0,-position])
			cube([base_size,base_size,position*(angled ? 2 : 3)], center=true);
				} // end inner union
			if (angled) {
				translate([
					position - frame_corner_thickness,
					-position + frame_corner_thickness,
					position
					])
					rotate([45,45,0])
						cube(base_size*2, center=true);
				translate([-base_size - extrusion_size/2 - frame_corner_thickness,0,-base_size-base_size/2])
					cube(size=base_size*2, center=true);
				translate([0,base_size + extrusion_size/2 + frame_corner_thickness,-base_size-base_size/2])
					cube(size=base_size*2, center=true);
				translate([-frame_offset.x,frame_offset.y,-frame_offset.z])
					frame_extrusions_top(false);
				translate([-frame_offset.x,frame_offset.y,-frame_offset.z])
					frame_extrusions_sides(false);

				for(i = frame_corner_top_holes()) {
				translate(i[0])
					rotate(i[1]) {
						screw_hole(frame_thick_screw, screw_longer_than(frame_corner_thickness + tube_dimensions.z));


					}
				}
			} else {
				translate([
				position + frame_corner_thickness,
				-position - frame_corner_thickness,
				position + frame_corner_thickness
				])
					rotate([45,45,0])
						cube(base_size*2, center=true);
				translate([-frame_offset.x,frame_offset.y,frame_offset.z])
					frame_extrusions_bottom(false);
				translate([-frame_offset.x,frame_offset.y,-frame_offset.z])
					frame_extrusions_sides(false);
				for(i = frame_corner_bottom_holes()) {
				translate(i[0])
					rotate(i[1]) {
						screw_hole(frame_thick_screw, screw_longer_than(frame_corner_thickness + tube_dimensions.z));
					}
				}
			}

	}
}

module frame_corner_bottom_stl() {
	stl("frame_corner_bottom");
	frame_corner(false);
}

module frame_corner_screws(holes) {
	for (i = holes) {
		translate(i[0])
			rotate(i[1]) {
				screw_and_washer(frame_thick_screw, screw_longer_than(frame_corner_thickness + tube_dimensions.z + washer_thickness(screw_washer(frame_thick_screw))));
			}
	}
}

module xy_pulley_assembly() {
	assembly("xy_pulley");
	xy_pulley_mount_stl();
	frame_corner_screws(frame_corner_top_holes());
	translate([-motor_offset(XY_motor), motor_offset(XY_motor), mount_thickness/2]) {
		pulley_tower();
	}
	//translate([-motor_offset(XY_motor), motor_offset(XY_motor),-nut_thickness(screw_nut(frame_thick_screw))])


	end("xy_pulley");
}
module xy_pulley_mount_stl() {
	stl("xy_pulley_mount");
	difference(){
		union() {
			frame_corner();
			translate([-motor_offset(XY_motor)/2 - extrusion_diag/2, motor_offset(XY_motor)/2 + extrusion_diag/2, 0])
				cube(size = [motor_offset(XY_motor), motor_offset(XY_motor), mount_thickness], center=true);
		}
		translate([-motor_offset(XY_motor), motor_offset(XY_motor), mount_thickness/2])
			screw_hole(frame_thick_screw,screw_longer_than(mount_thickness));
	}
}

function frame_corner_top_holes(angle = 45) = [
	// translate,rotate
	[ [-extrusion_size*1.5,extrusion_size/3+frame_corner_thickness, -extrusion_size/3 - frame_corner_thickness], [180+45,0,0] ],
	[ [-extrusion_size*1.5,-extrusion_size/3-frame_corner_thickness, -extrusion_size/3 - frame_corner_thickness], [180-45,0,0] ],

	[ [-extrusion_size/3-frame_corner_thickness, extrusion_size*1.5,-extrusion_size/3 - frame_corner_thickness], [0,180+45,0] ],
	[ [extrusion_size/3+frame_corner_thickness, extrusion_size*1.5,-extrusion_size/3 - frame_corner_thickness], [0,180-45,0] ],


	[ [0, extrusion_size/2 + frame_corner_thickness, -extrusion_size*1.5], [-90,0,0] ],
	[ [-extrusion_size/2 - frame_corner_thickness, 0, -extrusion_size*1.5], [-90,0,90] ],
	];

function frame_corner_bottom_holes() = [
	// translate,rotate
	[ [-extrusion_size*1.5, 0, -extrusion_size/2 - frame_corner_thickness], [180,0,0] ],
	[ [-extrusion_size*1.5, extrusion_size/2 + frame_corner_thickness, 0], [-90,0,0] ],
	[ [-extrusion_size/2 - frame_corner_thickness, extrusion_size*1.5,  0], [-90,0,90] ],
	[ [0, extrusion_size*1.5, -extrusion_size/2 - frame_corner_thickness], [180,0,0] ],

	[ [0, extrusion_size/2 + frame_corner_thickness, -extrusion_size*1.5], [-90,0,0] ],
	[ [-extrusion_size/2 - frame_corner_thickness, 0, -extrusion_size*1.5], [-90,0,90] ],
	];


if (false) {
	frame_corner_bottom_stl();
	frame_corner_screws(frame_corner_bottom_holes());

} else {
	xy_pulley_assembly();
	//frame_corner_screws(frame_corner_top_holes());

}
