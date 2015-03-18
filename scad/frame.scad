include <conf/config.scad>
include <_positions.scad>
use <xy_motor_mount.scad>
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
				square_tube(tube_dimensions, dimensions.x - extrusion_diag - frame_corner_thickness, showInBom=showInBom);
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
				square_tube(tube_dimensions, dimensions.x - extrusion_diag - frame_corner_thickness, showInBom=showInBom);
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
				translate([-extrusion_diag,extrusion_diag,-mount_thickness*1.5])
					rotate([0,0,-90])
					xy_pulley_endstop_stl();
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
				translate([extrusion_diag/2 + NEMA_width(XY_motor)/2, -extrusion_diag - NEMA_width(XY_motor), extrusion_diag/2 + mount_thickness])
				xy_motor_endstop_stl();
			}

			// FRONT BOTTOM RIGHT
			translate([frame_offset.x,-frame_offset.y, -frame_offset.z]) {
				rotate([0,0,0]) render() frame_corner_bottom_stl();
				rotate([0,90,0]) frame_corner_screws(frame_corner_bottom_holes());
			}
			// FRONT BOTTOM LEFT
			translate([-frame_offset.x,-frame_offset.y, -frame_offset.z]) {
				rotate([0,0,-90]) render() frame_corner_bottom_stl();
				rotate([0,90,-90]) frame_corner_screws(frame_corner_bottom_holes());
			}
			// BACK BOTTOM RIGHT
			translate([frame_offset.x,frame_offset.y, -frame_offset.z]) {
				rotate([0,0,90]) render() frame_corner_bottom_stl();
				rotate([90,0,90]) frame_corner_screws(frame_corner_bottom_holes());
			}
			// BACK BOTTOM LEFT
			translate([-frame_offset.x,frame_offset.y, -frame_offset.z]) {
				rotate([0,0,180]) render() frame_corner_bottom_stl();
				rotate([90,0,180]) frame_corner_screws(frame_corner_bottom_holes());
			}

		}
	}
}


module frame_corner(angled = true) {
	//main block
	base_size = angled ? extrusion_diag + frame_corner_thickness : extrusion_size + frame_corner_thickness * 2;
	position = angled ? extrusion_diag : extrusion_size;
rotate([0,(angled ? 0 : 90), 0])
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
			// cover the tiny hole between previous cubes
			cube(size=[extrusion_size+frame_corner_thickness*2,extrusion_size+frame_corner_thickness*2,extrusion_size+frame_corner_thickness*2], center=true);
			translate([0,0,-position])
			cube([base_size,base_size,position*(angled ? 2 : 3)], center=true);
				} // end inner union
			if (angled) {
				translate([
					position - frame_corner_thickness,
					-position + frame_corner_thickness,
					position
					])
					*rotate([45,45,0])
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
						*cube(base_size*2, center=true);
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
	render() xy_pulley_mount_stl();
	frame_corner_screws(frame_corner_top_holes());
	translate([-motor_offset(XY_motor) - XY_pulley_bearing_offset, motor_offset(XY_motor) + XY_pulley_bearing_offset, extrusion_diag/2 + frame_corner_thickness/2 ]) {
		pulley_tower();
	}

	end("xy_pulley");
}

module xy_motor_endstop_stl() {
	stl("xy_motor_endstop");
	difference() {
		union(){
			cube(size=[NEMA_width(XY_motor) + default_wall*2,20,default_wall], center=true);
			translate([0,-10,-(18 + default_wall*2)/2 + default_wall/2]) {
				cube(size=[NEMA_width(XY_motor) + default_wall*2, default_wall, 18 + default_wall*2], center=true);
			}
		}
		translate([0,22,0])
		NEMA_all_holes(XY_motor);
		for(j=[1,-1])
			translate([j * (19/2), -9, -18])
				rotate([-90, 0, 0])
					translate([0,0,2])
				#screw_hole(M3_cap_screw, screw_longer_than(10));
	}
}

module xy_pulley_endstop_stl() {
	stl("xy_pulley_endstop");
	difference() {
		union() {
		translate([-5,0,0])
		cube(size=[30, 19 + default_wall*2, default_wall], center=true);
		translate([-18,0,-(11 + default_wall*1.5)/2])
			cube(size=[default_wall, 19 + default_wall*2, 11 + default_wall*2], center=true);
		}
		translate([0,0,2])
		screw_hole(frame_thick_screw, screw_longer_than(10));
			for(j=[1,-1])
			translate([-18, j * (19/2), -7])
				rotate([0,  90, 0])
					translate([0,0,2])
				screw_hole(M3_cap_screw, screw_longer_than(10));

	}
}

module xy_pulley_mount_stl() {
	stl("xy_pulley_mount");
	difference(){
		union() {
			frame_corner();
			translate([-motor_offset(XY_motor)/2 - extrusion_diag/2, motor_offset(XY_motor)/2 + extrusion_diag/2, extrusion_diag/2 + frame_corner_thickness/2 - mount_thickness/2])
				cube(size = [motor_offset(XY_motor), motor_offset(XY_motor), mount_thickness], center=true);
		}
		translate([-motor_offset(XY_motor), motor_offset(XY_motor), extrusion_diag/2 + mount_thickness/2+ eta])
			screw_hole(bearing_screw(XY_bearing),screw_longer_than(mount_thickness));
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


if (true) {
	frame_assembly();
	//frame_corner_bottom_stl();
	//frame_corner_screws(frame_corner_bottom_holes());
} else {
	xy_pulley_assembly();
	//frame_corner_screws(frame_corner_top_holes());//
}
//echo("frame sides");
//frame_extrusions_sides();
//echo("frame top");
//frame_extrusions_top();
//echo("frame bottom");
//frame_extrusions_bottom();
