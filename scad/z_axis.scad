include <conf/config.scad>
include <_positions.scad>
use <bed.scad>
use <carriage.scad>
use <bits.scad>

module z_assembly() {
	assembly("Z Axis");
	translate([
			-dimensions.x/2 + extrusion_size + NEMA_width(Z_motor)/2,
			dimensions.y/2 - extrusion_diag*2 - pulley_width(GT2x20_twin_metal_pulley) + 4,
			-dimensions.z/2 + NEMA_width(XY_motor)/2 - extrusion_size/2 + frame_corner_thickness
		]) {
		rotate([-90,0,0]) {
			metal_pulley(GT2x20_twin_metal_pulley);
			NEMA(XY_motor);
			translate([0,0,mount_thickness/2])
			NEMA_screws(Z_motor, screw_length = 8 + mount_thickness, screw_type = M3_cap_screw);
		}
		render() z_motor_mount_stl();
	}
	for (i = [1, -1]) {
		translate([
			i * (envelope_dimensions.x/2 -carriage_width - thick_wall/2),
			dimensions.y/2 - extrusion_diag,
			0
		]) {
			rotate([0,0,(i>0 ? 0 : 180)])
				z_rail_assembly();
			translate([0, extrusion_diag/2 - frame_corner_thickness/2, dimensions.z/2]) {
				render() z_rail_top_stl();
				z_rail_top_vitamins();
			}
			translate([0, extrusion_size/2 + frame_corner_thickness/2, -dimensions.z/2]) {
				render() z_rail_bottom_stl();
				z_rail_bottom_vitamins();
			}

		}
	}
	// left belts
	translate([
		-1 *(envelope_dimensions.x/2 -carriage_width - thick_wall/2) - (ball_bearing_diameter(Z_bearing)*2 + extrusion_size/2),
		dimensions.y/2 - extrusion_diag -extrusion_diag + 4,
		-dimensions.z/2
		]) {
			z_belt_lower_assembly();
			translate([0,0,dimensions.z])
				z_belt_upper_assembly();
	}
	// right belts
	translate([
		(envelope_dimensions.x/2 -carriage_width - thick_wall/2) - (ball_bearing_diameter(Z_bearing) + extrusion_size/2),
		dimensions.y/2 - extrusion_diag -extrusion_diag + 4,
		-dimensions.z/2
		]) {
			z_belt_lower_assembly(true);
			translate([0,0,dimensions.z])
				z_belt_upper_assembly(true);
	}

	translate([0,0,-dimensions.z/2 + carriage_height + extrusion_size/2])
		bed_assembly();

	end("Z Axis");
}

module z_motor_mount_stl() {
	stl("z_motor_mount");
	//face
	difference() {
		translate([0,0,-frame_corner_thickness/2])
		cube(size=[NEMA_width(Z_motor) + frame_corner_thickness*2, frame_corner_thickness, NEMA_width(Z_motor) + frame_corner_thickness*2], center=true);
		rotate([90,0,0])
		NEMA_all_holes(Z_motor);
	}
	//bottom
	translate([0,-NEMA_length(Z_motor)/2 - frame_corner_thickness/2, -NEMA_width(Z_motor)/2 - frame_corner_thickness*1.5])
		cube(size=[NEMA_width(Z_motor) + frame_corner_thickness*2, NEMA_length(Z_motor) + frame_corner_thickness*2, frame_corner_thickness], center=true);
	//left
	translate([-NEMA_width(Z_motor)/2 - frame_corner_thickness, -NEMA_length(Z_motor)/2 - frame_corner_thickness/2, - frame_corner_thickness/2])
		cube(size=[frame_corner_thickness, NEMA_length(Z_motor) + frame_corner_thickness*2, NEMA_width(Z_motor) + frame_corner_thickness*2], center=true);
	//connector
	difference() {
		translate([-extrusion_size - NEMA_width(Z_motor)/2, -NEMA_length(Z_motor)/2 - frame_corner_thickness/2, -NEMA_width(XY_motor)/2 + extrusion_size/2 - frame_corner_thickness]) {

			cube(size=[extrusion_size + frame_corner_thickness*2, NEMA_length(Z_motor)+frame_corner_thickness*2, extrusion_size+ frame_corner_thickness*2], center=true);
			translate([frame_corner_thickness*1.5,0,0])
				cube(size=[extrusion_size + frame_corner_thickness*2, NEMA_length(Z_motor)+frame_corner_thickness*2, extrusion_size+ frame_corner_thickness*2], center=true);
		}
		translate([-extrusion_size - NEMA_width(Z_motor)/2, -NEMA_length(Z_motor)/2 - frame_corner_thickness/2, -NEMA_width(XY_motor)/2 + extrusion_size/2 - frame_corner_thickness])
			cube(size=[extrusion_size, extrusion_size*4, extrusion_size], center=true);
	}
}

module z_belt_upper_assembly(right=false) {
	assembly(str("Z Belt Upper ", (right ? "Right" : "Left")));
	translate([0,(right ? -8 : 0), 0])
		rotate([90,0,0]) {
			ball_bearing(Z_bearing);
			translate([0,0,ball_bearing_width(Z_bearing)/2]) {
				screw(M3_cap_screw, screw_longer_than(ball_bearing_width(Z_bearing) + frame_corner_thickness));
				rotate([0,180,0])printed_washer_stl();
			}
		}
	if (right) {
		render() z_belt_upper_right_stl();
	} else {
		render() z_belt_upper_left_stl();
	}
	end(str("Z Belt Upper ", (right ? "Right" : "Left")));
}

module z_belt_upper_mount(right=false) {
	difference() {
		union(){
			translate([0,ball_bearing_width(Z_bearing)/2 + (right ? -7 : 1),0]) {
				rotate([90,0,0]) {
					cylinder(h=2, r=Z_bearing[0]/2+1 , center=true);
					translate([0, 0, ball_bearing_width(Z_bearing)/2])
						cylinder(h=ball_bearing_width(Z_bearing), r=Z_bearing[0]/2 - 0.125, center=true, $fn=20);
				}
				translate([0,(extrusion_diag*2 + frame_corner_thickness*3)/2 + (right ? 3 : -1), 0])
				cube(size=[ ball_bearing_diameter(Z_bearing) + 2, extrusion_diag*2 + frame_corner_thickness*2 + (right ? 10 : 2), extrusion_diag + frame_corner_thickness*2], center=true);

			}
		} // end union
		translate([
		0,
		extrusion_diag + extrusion_size + frame_corner_thickness+1,
		0
		])
			rotate([-45,0,0]) {
				cube(size=[extrusion_size*4, extrusion_size, extrusion_size], center=true);
				translate([0,0,extrusion_diag/2])
				for(i=[1, -1]) {
					rotate([-45,0,0])
				translate([0, frame_corner_thickness/2, 0])
				rotate([45 * i,0,0])
				translate([0, 0, frame_corner_thickness*2])
					screw_hole(frame_thick_screw, screw_longer_than(frame_corner_thickness + tube_dimensions.z));
				}
			}
	}
}

module z_belt_upper_right_stl() {
	stl("z_belt_upper_right");
	z_belt_upper_mount(true);
}

module z_belt_upper_left_stl() {
	stl("z_belt_upper_left");
	z_belt_upper_mount();
}

module z_belt_lower_assembly(right=false) {
	assembly(str("Z Belt Lower ", (right ? "Right" : "Left")));
	translate([0,(right ? -8 : 0), 0])
	z_belt_lower_bearing_layout() {
		ball_bearing(Z_bearing);
		translate([0,0,ball_bearing_width(Z_bearing)/2]) {
			screw(M3_cap_screw, screw_longer_than(ball_bearing_width(Z_bearing) + frame_corner_thickness));
			rotate([0,180,0])
			printed_washer_stl();
		}
		translate([ball_bearing_diameter(Z_bearing)/2, carriage_height/2, 0])
			color(belt_color) cube(size=[belt_thickness(GT2), carriage_height, belt_width(GT2)], center=true);
	}
	if(right) {
		render() z_belt_lower_right_stl();
	} else {
		render() z_belt_lower_left_stl();
	}
	translate([
		-extrusion_diag/2 + frame_corner_thickness,
		(extrusion_diag + extrusion_size + frame_corner_thickness),
		extrusion_size/2 + frame_corner_thickness
		])
		screw_and_washer(frame_thick_screw, screw_longer_than(frame_corner_thickness*2 + tube_dimensions.z));
	translate([
		-extrusion_diag/2 + frame_corner_thickness,
		(extrusion_diag + extrusion_size + frame_corner_thickness) + extrusion_size/2 + frame_corner_thickness+1,
		0
		])
		rotate([-90,0,0])
		screw_and_washer(frame_thick_screw, screw_longer_than(frame_corner_thickness*2 + tube_dimensions.z));
	end(str("Z Belt Lower ", (right ? "Right" : "Left")));
}

module z_belt_lower_left_stl() {
	stl("z_belt_lower_left");
	z_belt_lower_mount();
}

module z_belt_lower_right_stl() {
	stl("z_belt_lower_right");
	z_belt_lower_mount(true);
}

module z_belt_lower_mount(right = false) {
	difference() {
		union() {
		translate([0,ball_bearing_width(Z_bearing)/2 + (right ? -7 : 1), 0]) {
		// bearing axles
		z_belt_lower_bearing_layout() {
			//spacer
			cylinder(h=2, r=Z_bearing[0]/2+1 , center=true);
			//axle
			translate([0, 0, ball_bearing_width(Z_bearing)/2])
				cylinder(h=ball_bearing_width(Z_bearing), r=Z_bearing[0]/2 - 0.125, center=true, $fn=20);
		}
		// extra surround for the lower screw hole.
		translate([0,ball_bearing_width(Z_bearing),ball_bearing_diameter(Z_bearing)/2])
			rotate([90,0,0])
				cylinder(h=ball_bearing_width(Z_bearing), r=Z_bearing[0]/2 - 0.125, center=true, $fn=20);
		// connector
		hull() {
			translate([-ball_bearing_diameter(Z_bearing) - frame_corner_thickness*2 + 1, frame_corner_thickness/2, extrusion_size/2 + Z_bearing[0]])
				cube(size=[1, frame_corner_thickness, ball_bearing_diameter(Z_bearing)], center=true);
			translate([0,frame_corner_thickness/2,ball_bearing_diameter(Z_bearing)/2]) {
					rotate([90,0,0])
					cylinder(h=frame_corner_thickness, d=ball_bearing_diameter(Z_bearing) + 4, center=true);
				}
		}
		translate([-ball_bearing_diameter(Z_bearing)/2, frame_corner_thickness, extrusion_size/2 + frame_corner_thickness])
			rotate([0, -90, 0])
			fillet(frame_corner_thickness, extrusion_diag + frame_corner_thickness*2);
	}
	translate([
		-ball_bearing_diameter(Z_bearing)/2,
		(extrusion_diag + extrusion_size + frame_corner_thickness*4)/2 + ball_bearing_width(Z_bearing)/2 + (right ? -3 : 1),
		0
		])
		difference() {
			cube([
				extrusion_diag + frame_corner_thickness*2,
				extrusion_diag + extrusion_size + frame_corner_thickness*4 + (right ? 8 : 0),
				extrusion_size + frame_corner_thickness*2
				], center=true);
			translate([0, -frame_corner_thickness + extrusion_size + (right ? 4 : 0), 0])
				cube(size=[extrusion_size*4, extrusion_size, extrusion_size], center = true);
			translate([-extrusion_size/2 - frame_corner_thickness, -extrusion_size*1.5, -extrusion_size - frame_corner_thickness*3])
				rotate([0,90,0])
				sphere(r=extrusion_diag+frame_corner_thickness, $fn=48);
				//cylinder(h=extrusion_diag + frame_corner_thickness, r=extrusion_size, center=true);
		}
	} // end union
	z_belt_lower_bearing_layout()
	translate([0,0,ball_bearing_width(Z_bearing)/2])
		screw_hole(M3_cap_screw, screw_longer_than(ball_bearing_width(Z_bearing) + frame_corner_thickness*2));
	}

}

module z_belt_lower_bearing_layout() {
	translate([0,0,ball_bearing_diameter(Z_bearing)/2]) {
		// lower
		rotate([90,0,0])
			children();
		// upper
		translate([-ball_bearing_diameter(Z_bearing), 0, ball_bearing_diameter(Z_bearing)/2]) {
			rotate([90,0,0])
				children();
		}
	}
}

module z_rail_assembly() {
	assembly("Z Rail");

	rotate([0,0,-45]) {
		square_tube(tube_dimensions, dimensions.z + extrusion_size/2 + extrusion_diag/2);
		translate([0, 0, -dimensions.z/2 + carriage_height]) {
			render() z_carriage_stl();
			carriage_slide_vitamins(false);
		}
	}
	translate([
		carriage_width/2 + extrusion_size/2 + thick_wall*2,
		0,
		-dimensions.z/2 + carriage_height
		]) {
		for(i=[1,-1]) {
			translate([0, i * (carriage_width/2 - thick_wall*1.25), 0])
			rotate([0, 90, 0]) {
				translate([0,0,-screw_longer_than(extrusion_size+thick_wall+nut_thickness(screw_nut(frame_thick_screw)))])
					nut(screw_nut(frame_thick_screw));
				screw_and_washer(frame_thick_screw, screw_longer_than(extrusion_size+thick_wall+nut_thickness(screw_nut(frame_thick_screw))));
			}
		}
	}
	end("Z Rail");
}

module z_carriage_stl() {
	stl("z_carriage");
	carriage_slide(false);
}

module z_rail_bottom_stl() {
	stl("z_rail_bottom");
	difference() {
		union() {
			cube([
				extrusion_diag + frame_corner_thickness*2,
				extrusion_diag + extrusion_size + frame_corner_thickness*3,
				extrusion_size + frame_corner_thickness*2
				], center=true);
		}
		translate([0, -extrusion_size/2 - frame_corner_thickness/2,0])
			rotate([0,0,45])
				cube(size=[extrusion_size,extrusion_size, extrusion_size*4], center=true);
		translate([0,extrusion_diag/2 + frame_corner_thickness/2,0])
			cube(size=[extrusion_size*4,extrusion_size, extrusion_size], center=true);
		z_rail_bottom_layout()
			screw_hole(frame_thick_screw, extrusion_size);
	}
}
module z_rail_bottom_vitamins() {
	z_rail_bottom_layout()
		screw_and_washer(frame_thick_screw, screw_longer_than(frame_corner_thickness*2 + tube_dimensions.z));
}

module z_rail_bottom_layout() {
	for(i=[1, -1]) {
		translate([0, -extrusion_size/2 - frame_corner_thickness/2, 0])
		rotate([0,90,i*45 - 90])
		translate([0, 0, (extrusion_size/2 + frame_corner_thickness*2)])
			children();
		translate([0, extrusion_diag/2 + frame_corner_thickness/2, 0])
		rotate([(i > 0 ? -90 : 0),0,0])
		translate([0, 0, extrusion_size/2 + frame_corner_thickness + eta])
			children();
	}
}



module z_rail_top_stl() {
	stl("z_rail_top");
	difference() {
		union() {
			translate([0,frame_corner_thickness/3*2,0])
			cube([
				extrusion_diag + frame_corner_thickness*2,
				extrusion_diag + extrusion_diag + frame_corner_thickness*2,
				extrusion_diag + frame_corner_thickness*2
				], center=true);
		}
		translate([0, -extrusion_size/2 - frame_corner_thickness/2,0])
			rotate([0,0,45])
				cube(size=[extrusion_size,extrusion_size, extrusion_size*4], center=true);
		translate([0,extrusion_diag/2 + frame_corner_thickness/2,0])
			rotate([45,0,0])
				cube(size=[extrusion_size*4,extrusion_size, extrusion_size], center=true);
		z_rail_top_layout()
			screw_hole(frame_thick_screw, extrusion_size);
	}
}
module z_rail_top_vitamins() {
	z_rail_top_layout()
		screw_and_washer(frame_thick_screw, screw_longer_than(frame_corner_thickness*2 + tube_dimensions.z));
}

module z_rail_top_layout() {
	for(i=[1, -1]) {
		translate([0, -extrusion_size/2 - frame_corner_thickness/2, 0])
		rotate([0,90,i*45 - 90])
		translate([0, 0, (extrusion_size/2 + frame_corner_thickness*2)])
			children();
		translate([0, extrusion_diag/2 + frame_corner_thickness/2, 0])
		rotate([-90 - i*45,0,0])
		translate([0, 0, extrusion_size/2 + frame_corner_thickness*2])
			children();
	}
}




//z_assembly();
//z_rail_assembly();

//z_rail_bottom_stl();
//z_rail_bottom_vitamins();

//z_rail_top_stl();
//z_rail_top_vitamins();

//z_belt_lower_assembly();
//z_motor_mount_stl();

z_belt_lower_assembly(true);
