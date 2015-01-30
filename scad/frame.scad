
include <conf/config.scad>

include <_positions.scad>
use <motor_mount.scad>

module frame_assembly() {
	assembly("frame");
	frame_extrusions_top();
	frame_extrusions_sides();
	frame_extrusions_bottom();
	frame_corners();
	end("frame");

}


module frame_extrusions_top(bom=true) {
	//FRONT
	translate([0,-frame_offset.y,frame_offset.z])
		rotate([45,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - extrusion_diag - frame_corner_thickness, bom=bom);
	//LEFT
	translate([-frame_offset.x,0,frame_offset.z])
		rotate([0,45,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag);
	//BACK
	translate([0,frame_offset.y,frame_offset.z])
		rotate([45,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - tube_dimensions.x - frame_corner_thickness*2, bom=bom);
	//RIGHT
	translate([frame_offset.x,0,frame_offset.z])
		rotate([0,45,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag, bom=bom);

}
module frame_extrusions_bottom(bom=true) {
	//FRONT
	translate([0,-frame_offset.y,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - extrusion_diag - frame_corner_thickness, bom=bom);
	//LEFT
	translate([-frame_offset.x,0,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag, bom=bom);
	//BACK
	translate([0,frame_offset.y,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - tube_dimensions.x - frame_corner_thickness*2, bom=bom);
	//RIGHT
	translate([frame_offset.x,0,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag, bom=bom);

}

module frame_extrusions_sides(bom=true) {
	// FRONT RIGHT
	translate([frame_offset.x, -frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z,bom=bom);
	// FRONT LEFT
	translate([-frame_offset.x, -frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z,bom=bom);
	// BACK RIGHT
	translate([frame_offset.x, frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z,bom=bom);
	// BACK LEFT
	translate([-frame_offset.x, frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z,bom=bom);
}


module frame_corners() {
	difference() {
		union() {
			// FRONT TOP RIGHT
			translate([frame_offset.x,-frame_offset.y, frame_offset.z]) {
				frame_corner_top_stl();
				frame_corner_screws(frame_corner_top_holes());
			}
			// FRONT TOP LEFT
			translate([-frame_offset.x,-frame_offset.y, frame_offset.z]) {
				rotate([0,0,-90]) {
					frame_corner_top_stl();
					frame_corner_screws(frame_corner_top_holes());
				}
			}
			// BACK TOP RIGHT
			translate([frame_offset.x,frame_offset.y, frame_offset.z]) {
				rotate([0,0,90]) {
					translate([-extrusion_diag*1.5, extrusion_diag*1.5, extrusion_diag/2 -1 + eta])
						motor_mount_assembly();
					frame_corner_top_motor_stl();
					frame_corner_screws(frame_corner_top_holes());
				}
			}
			// BACK TOP LEFT
			translate([-frame_offset.x,frame_offset.y, frame_offset.z]) {
				rotate([0,0,180]) {
					frame_corner_top_motor_stl();
					frame_corner_screws(frame_corner_top_holes());
				translate([-extrusion_diag*1.5, extrusion_diag*1.5, extrusion_diag/2 -1 + eta])
					motor_mount_assembly();
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
			translate([-position / (angled ? 2 : 1), 0, 0])
				cube(
					size=[
						base_size + position * (angled ? 1 : 1.5),
						base_size,
						base_size
						],
					center=true
					);
			translate([0, position / (angled ? 2 : 1), 0])
				cube(
					size=[
						base_size,
						base_size + position * (angled ? 1 : 1.5),
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
				translate([-frame_offset.x,frame_offset.y,-frame_offset.z])
					frame_extrusions_top(false);
				translate([-frame_offset.x,frame_offset.y,-frame_offset.z])
					frame_extrusions_sides(false);

				for(i = frame_corner_top_holes()) {
				translate(i[0])
					rotate(i[1]) {
						poly_cylinder(r=screw_radius(frame_thick_screw),h=extrusion_size);
						translate([0,0,-(frame_corner_thickness* (angled ? 3 : 2))/2])
						cylinder(
							h=screw_head_height(frame_thick_screw) + washer_thickness(screw_washer(frame_thick_screw)),
							d=screw_boss_diameter(frame_thick_screw),
							center=true,
							$fn=20
							);

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
						#poly_cylinder(r=screw_radius(frame_thick_screw),h=extrusion_size);
						cylinder(
							h=frame_corner_thickness* 3,
							d=screw_boss_diameter(frame_thick_screw),
							center=true,
							$fn=20
							);

					}
				}
			}

	}
}

module frame_corner_top_stl() {
	stl("frame_corner_top");
	frame_corner();
}

module frame_corner_top_motor_stl() {
	stl("frame_corner_top_motor");
	frame_corner();
	translate([-extrusion_diag*1.5, extrusion_diag*1.5, extrusion_diag/2 -1 + eta])
		rotate([0, 0, -180])
		motor_mount();
}

module frame_corner_bottom_stl() {
	stl("frame_corner_bottom");
	frame_corner(false);
}
module frame_corner_screws(holes) {
	#for (i = holes) {
		translate(i[0])
			rotate(i[1]) {
				rotate([0,180,0])
				screw_and_washer(frame_thick_screw, screw_longer_than(frame_corner_thickness + tube_dimensions.z + washer_thickness(screw_washer(frame_thick_screw))));
			}
	}
}

function frame_corner_top_holes(angle = 45) = [
	// translate,rotate
	[ [-extrusion_diag,extrusion_diag/2 - frame_corner_thickness,-extrusion_diag/2 + frame_corner_thickness], [angle,0,0] ],
	[ [-extrusion_diag,-extrusion_diag/2 + frame_corner_thickness,-extrusion_diag/2 + frame_corner_thickness ], [-angle,0,0] ],

	[ [-extrusion_diag/2 + frame_corner_thickness,extrusion_diag,-extrusion_diag/2 + frame_corner_thickness ], [0,angle,0] ],
	[ [extrusion_diag/2 - frame_corner_thickness,extrusion_diag,-extrusion_diag/2 + frame_corner_thickness ], [0,-angle,0] ],

	[ [0, extrusion_diag/2 + washer_thickness(screw_washer(frame_thick_screw)) ,-extrusion_diag ], [90,0,0] ],
	[ [-extrusion_diag/2 - washer_thickness(screw_washer(frame_thick_screw)), 0,-extrusion_diag ], [0,90,0] ]
];

function frame_corner_bottom_holes(angle = 90) = [
	// translate,rotate
	[ [-extrusion_size*1.5,extrusion_size - frame_corner_thickness,0], [angle,0,0] ],
	[ [-extrusion_size*1.5,0,-extrusion_size/2 - frame_corner_thickness*2], [0,0,0] ],

	[ [-extrusion_size +frame_corner_thickness,extrusion_size*1.5,0 ], [0,angle,0] ],
	[ [0, extrusion_size*1.5, -extrusion_size/2 - frame_corner_thickness * 2 ], [0,0,0] ],

	[ [0, extrusion_size - frame_corner_thickness,-extrusion_size*1.5 ], [90,0,0] ],
	[ [-extrusion_size + frame_corner_thickness, 0,-extrusion_size*1.5 ], [0,90,0] ]
];

frame_corner_bottom_stl();
frame_corner_screws();
