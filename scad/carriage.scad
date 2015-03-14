include <conf/config.scad>
include <_positions.scad>
use <MCAD/shapes.scad>
use <bits.scad>
use <extruder.scad>
use <frame.scad>

//carriage_bearing = BB624;


//function grip_offset(extrusion_size = extrusion_size) = extrusion_size + ball_bear;
module xy_carriage_assembly() {
	assembly("xy_carriage");
	translate([-frame_offset.x, 0, 0]) {
		translate([carriage_width/2 + screw_boss_diameter(frame_thick_screw)/2,0,0]) {
			translate([0,0,thick_wall*1.5])
			screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall*4));
			translate([0,0,-thick_wall*2])
				nut(screw_nut(frame_thick_screw));
		}
		rotate([90,0,0]) {
			y_carriage_slide_assembly();
		}
			translate([motor_offset(XY_motor), 0, 0]) {
				render() y_carriage_end_stl();
				y_carriage_end_vitamins();
			}
	}
	translate([frame_offset.x, 0, 0]) {
		translate([-carriage_width/2 - screw_boss_diameter(frame_thick_screw)/2,0,0]) {
			translate([0,0,thick_wall*1.5])
			screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall*4));
			translate([0,0,-thick_wall*2])
				nut(screw_nut(frame_thick_screw));
		}
		rotate([-90,180,0])
			y_carriage_slide_assembly();
		rotate([0,0,180]) {
			translate([motor_offset(XY_motor), 0, 0]) {
				render() y_carriage_end_stl();
				y_carriage_end_vitamins();
			}
		}
	}
	//translate([0,0,extrusion_diag/2])
	rotate([0,90,0])
	rotate([0,0,45])
	square_tube(tube_dimensions, dimensions.x - motor_offset(XY_motor)*2);
	x_carriage_assembly();
	end("xy_carriage");
}

module x_carriage_assembly() {
	assembly("x_carriage");
	render() x_carriage_stl();
	rotate([45,0,0]) rotate([0,90,0])
	{
		carriage_slide_vitamins(false);
	}
	translate([0,0,carriage_width/2 + thick_wall/2 + NEMA_width(E_motor)/2 + E_motor_clearance])
		extruder_assembly();
	end("x_carriage");
}

module x_carriage_stl() {
	stl("x_carriage");
	difference(){
		union() {
			rotate([45,0,0]) rotate([0,90,0])
				render() carriage_slide(false);
			translate([
				0,
				-carriage_width/2,
				carriage_width/2 + thick_wall/2 + NEMA_width(E_motor)/2 + E_motor_clearance
				]) {// vertical mount
				translate([0, mount_thickness/2 - hotend_offset, - thick_wall/4])
					cube(size=[carriage_height, mount_thickness, NEMA_width(E_motor) + thick_wall/2], center=true);
				// connector
				translate([0, - hotend_offset + mount_thickness*1.5, -NEMA_width(E_motor)/2 - E_motor_clearance])
					cube(size=[carriage_height, mount_thickness*3, thick_wall], center=true);

				translate([0,0,-NEMA_width(E_motor)/2 - E_motor_clearance - mount_thickness/2])
					rotate([-90,0,0]) rotate([0, 90, 0])
					fillet(mount_thickness, carriage_height);
			}
			// belt clips
			for(i=[-1,1]) for(j=[-1,1])
				translate([
					j * (carriage_height/2 - belt_thickness(XY_belt)*3),
					i * (extrusion_diag/2 + thick_wall - ball_bearing_diameter(XY_bearing)/2),
					carriage_width/2 + thick_wall/2
					])
					cylinder(h=belt_width(XY_belt) * 4, r=belt_thickness(XY_belt)*3, center=true);
		} // end union
			translate([
				0,
				-carriage_width/2,
				carriage_width/2 + thick_wall/2 + NEMA_width(E_motor)/2 + E_motor_clearance
				]) {
				translate([0,-hotend_offset+mount_thickness/2, 0])
					rotate([90,0,0])
					NEMA_all_holes(E_motor);
				translate([0,-hotend_offset,-NEMA_width(E_motor)/2 - E_motor_clearance - mount_thickness/3*2])
					rotate([0, -90, 0])
					fillet(mount_thickness, carriage_height+5);
				for(i=[-1,1])
				translate([i * (NEMA_width(E_motor)/2 + thick_wall/2), -mount_thickness, NEMA_width(E_motor)/2])
					rotate([0,i * 45,0])
					cube(size=[mount_thickness*6, mount_thickness*2, mount_thickness*2], center=true);
			}
		// belt clips
		for(i=[-1,1]) for(j=[-1,1])
				translate([
					j * (carriage_height/2 - belt_thickness(XY_belt)*3),
					i * (extrusion_diag/2 + thick_wall - ball_bearing_diameter(XY_bearing)/2),
					carriage_width/2 + thick_wall/2
					]) {
					cylinder(h=belt_width(XY_belt) * 4, r=belt_thickness(XY_belt)*1.5, center=true);
					translate([j * belt_thickness(XY_belt) * 2, 0, 0])
					cube(size=[belt_thickness(XY_belt)*3, belt_thickness(XY_belt)*1.5, belt_width(XY_belt) * 4], center=true);
					translate([j * -belt_thickness(XY_belt)*3.5, 0, belt_width(XY_belt)*1.5])
						cube(size=[4,belt_thickness(XY_belt)*6,belt_width(XY_belt)*2], center=true);
				}
	}
}

module y_carriage_slide_assembly() {
	assembly("y_carriage_slide");
	rotate([0,0,-45])
		carriage_slide_vitamins();
	render() y_carriage_slide_stl();
	end("y_carriage_slide");
}


module y_carriage_end_stl() {
	stl("y_carriage_end");
	*group(){
		translate([dimensions.x/2 - motor_offset(XY_motor),0, -dimensions.z/2])
			%frame_extrusions_top(false);
		%translate([-motor_offset(XY_motor), 0,0])
			rotate([90,0,0]) render() y_carriage_slide_stl();
		}
	difference() {
		union() {
			// pulley_tower mount
			translate([motor_offset(XY_motor)/2 - frame_corner_thickness,0, extrusion_diag/2 + frame_corner_thickness/2 - mount_thickness/2])
				cube(size=[motor_offset(XY_motor), carriage_width + frame_corner_thickness, mount_thickness], center=true);
			// carriage_tab
			rotate([0,0,180])
				carriage_tab();

			// extrusion grip
			translate([motor_offset(XY_motor)/2 - frame_corner_thickness, 0, 0])
				rotate([45,0,0])
					cube(size=[motor_offset(XY_motor), extrusion_size+frame_corner_thickness*2, extrusion_size+frame_corner_thickness*2], center=true);
			// extra wall for pulley_tower holes
			for (i=[-1,1]) {
			for (j=[0,1])
			translate([
				j * (pulley_od(pulley_type)) + XY_pulley_bearing_offset,
				i * (extrusion_diag/2 + thick_wall),
				extrusion_diag/2 + frame_corner_thickness/2 - mount_thickness/2
				])
				cylinder(h=mount_thickness, r=thick_wall, center=true);
			}
		} // end union
		// carriage tab hole
		translate([-motor_offset(XY_motor) + extrusion_diag + thick_wall/3,0,0])
			cylinder(h=thick_wall*8, r=screw_pilot_hole(frame_thick_screw), center=true);
		// pulley_tower holes
		for (i=[-1,1]) {
			for (j=[0,1])
			translate([
				j * (pulley_od(pulley_type)) + XY_pulley_bearing_offset,
				i * (extrusion_diag/2 + thick_wall),
				extrusion_diag/2 + mount_thickness/2
				])
				screw_hole(frame_thick_screw, screw_longer_than(20));
		}
		// extrusion
		translate([motor_offset(XY_motor)/2, 0, 0])
			rotate([45,0,0])
			cube(size=[motor_offset(XY_motor), extrusion_size, extrusion_size], center=true);
		// keep the top flat
		translate([motor_offset(XY_motor)/2 - frame_corner_thickness, 0, extrusion_diag/2 + frame_corner_thickness/2 + mount_thickness/2])
			cube(size=[motor_offset(XY_motor) + frame_corner_thickness, extrusion_diag, mount_thickness], center=true);
		// extrusion screws
		y_carriage_end_ext_layout() {
			screw_hole(frame_thick_screw, screw_longer_than(thick_wall+tube_dimensions.z));
			translate([0,0,6])
				screw_hole(frame_thick_screw, screw_longer_than(thick_wall+tube_dimensions.z));
		}
	}
}

module y_carriage_end_vitamins() {
	y_carriage_end_ext_layout() {
		screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall+tube_dimensions.z));
	}
	for (i=[-1,1]) {
		translate([
			(i > 0 ? pulley_od(pulley_type) + XY_pulley_bearing_offset : XY_pulley_bearing_offset),
			i * (extrusion_diag/2 + thick_wall),
			extrusion_diag/2 + frame_corner_thickness/2
			])
			pulley_tower();
	}
}
module y_carriage_end_ext_layout() {
	rotate([45, 0, 0])
	translate([motor_offset(XY_motor)/2 + thick_wall, 0,0]) {
		translate([0, 0, extrusion_size/2 + frame_corner_thickness])
			rotate([0,0,0])
			children();
		translate([0, -extrusion_size/2 - frame_corner_thickness, 0])
			rotate([90,0,0])
			children();
		translate([0, 0, -extrusion_size/2 - frame_corner_thickness])
			rotate([180,0,0])
			children();
		translate([0, extrusion_size/2 + frame_corner_thickness, 0])
			rotate([270,0,0])
			children();
	}
}

module y_pulley_placement() {
	translate([
		carriage_width-thick_wall*2 + pulley_od(pulley_type),
		thick_wall/2 + extrusion_diag/2,
		-carriage_width/3 + thick_wall/2 - pulley_od(pulley_type)/2 //-extrusion_diag
		])
		rotate([-90,0,0])
		children();
	translate([
		carriage_width-thick_wall*2 +  pulley_od(pulley_type),
		thick_wall/2 + extrusion_diag/2,
		carriage_width/3 - thick_wall/2 + pulley_od(pulley_type)/2 //extrusion_diag
		])
		rotate([-90,0,0])
		children();
}

module y_carriage_slide_stl() {
	stl("y_carriage_slide");
	rotate([0,0,-45])
	render() carriage_slide(false);
	difference() {
		union() {
		translate([carriage_width/2-thick_wall/2,-thick_wall,0])
			rotate([90,0,0])
			carriage_tab();
		translate([carriage_width/2-thick_wall/2,thick_wall,0])
			rotate([90,0,0])
			carriage_tab();
			}// end union
		translate([extrusion_diag + thick_wall/3,0,0])
		rotate([90,0,0])
		cylinder(h=thick_wall*8, r=screw_pilot_hole(frame_thick_screw), center=true);
	}
}
module carriage_slide_vitamins(hinged = true) {
	%cube([extrusion_size,extrusion_size,carriage_height*2], center=true);

	// bearings, screws and nuts
	for(i=[1,-1]) {
	translate([0,0,(carriage_height/3 - thick_wall/2) * i])
		carriage_layout() {
			ball_bearing(carriage_bearing);
			translate([0,0,ball_bearing_width(carriage_bearing)/2])
				screw(
				bearing_screw(carriage_bearing), screw_longer_than(ball_bearing_width(carriage_bearing) + thick_wall/2 + bb_mount_size/2 + washer_thickness(screw_washer(bearing_screw(carriage_bearing))))
				);
			translate([0,0,-screw_longer_than(ball_bearing_width(carriage_bearing) + bb_mount_size/2)])
			nut(screw_nut(bearing_screw(carriage_bearing)));
		}
	}

	if(hinged)
	translate([carriage_width/2 - spring_length(hob_spring)/2, -carriage_width/2 + spring_length(hob_spring)/2, 0])
	rotate([90,0,45])
	comp_spring(hob_spring);
}

module carriage_slide(hinged=true) {
	difference () {
		union() {
			intersection() {
				union() {
					translate([bb_mount_size/2 + extrusion_size/2,-bb_mount_size/2 - extrusion_size/2,0]) {
						roundedBox(bb_mount_size, bb_mount_size, carriage_height, carriage_clearance/4*3);
					}
					translate([-bb_mount_size/2 - extrusion_size/2,bb_mount_size/2 + extrusion_size/2,0]) {
						roundedBox(bb_mount_size, bb_mount_size, carriage_height, carriage_clearance/4*3);
					}
				}
				rotate([0,0,45])
				roundedBox(carriage_width+thick_wall,carriage_width+thick_wall,carriage_height,carriage_clearance/4*3);
			}
			translate([extrusion_diag/2 + ball_bearing_diameter(carriage_bearing)/4,-extrusion_diag/2 - ball_bearing_diameter(carriage_bearing)/3,0])
			if(hinged)
			rotate([0,0,45])
			living_hinge(carriage_width, carriage_height);
			rotate([0,0,45])
			translate([0,(hinged ? -l_hinge_width : 0),0])
			difference() {
				// outer shell
				roundedBox(
					carriage_width,
					carriage_width+thick_wall*2+(hinged ? l_hinge_width*2 : 0),
					carriage_height,carriage_clearance/4*3
					);
				// inner shell
				roundedBox(
					carriage_width-thick_wall*2,
					carriage_width + (hinged ? l_hinge_width*2 : 0),
					carriage_height+10,
					carriage_clearance/2
					);
			}
		} // end union
		// bearing holes
		for(i=[1,-1]) {
			translate([0,0,i*(carriage_height/3 - thick_wall/2)])
			carriage_layout() {
				translate([0,0,-bb_mount_size + thick_wall/2 ]) {
					// doubled so we can use shorter screws
					nut_trap(screw_radius(bearing_screw(carriage_bearing)), nut_radius(screw_nut(bearing_screw(carriage_bearing))), nut_thickness(screw_nut(bearing_screw(carriage_bearing))));
					translate([0,0,-thick_wall/2])
					nut_trap(screw_radius(bearing_screw(carriage_bearing)), nut_radius(screw_nut(bearing_screw(carriage_bearing))), nut_thickness(screw_nut(bearing_screw(carriage_bearing))));

				}
			}
		}

		// Z carriage nut traps
		if(!hinged) {
			rotate([0,0,45]) {
				difference() {
					for(i=[1,-1]) {	for(j=[1,-1]) {
					translate([j * (carriage_width/2 - thick_wall*1.25), i * (carriage_width/2 - thick_wall), 0])
					rotate([90,0,90])
					nut_trap(screw_radius(frame_thick_screw), nut_radius(screw_nut(frame_thick_screw)), nut_thickness(screw_nut(frame_thick_screw)));
					} }
					cube(size=[extrusion_size, carriage_width*2,extrusion_size], center=true);
				}
			}
		}
	}
}

module carriage_layout() {
	// comments by top view
	// 3:00
	translate([extrusion_size/2 + ball_bearing_diameter(carriage_bearing)/2,-extrusion_size/2+ball_bearing_width(carriage_bearing)/2,-ball_bearing_diameter(carriage_bearing)/2])
		rotate([-90,0,0]) {
			children();
		}
	// 6:00
	translate([extrusion_size/2-ball_bearing_width(carriage_bearing)/2,-extrusion_size/2 - ball_bearing_diameter(carriage_bearing)/2,ball_bearing_diameter(carriage_bearing)/2])
		rotate([-90,0,90]) {
			children();
		}
	// 9:00
	translate([-extrusion_size/2 - ball_bearing_diameter(carriage_bearing)/2,extrusion_size/2-ball_bearing_width(carriage_bearing)/2,-ball_bearing_diameter(carriage_bearing)/3]) // pull this one in so it doesn't interfere with the belt clip
		rotate([90,0,0]) {
			children();
		}
	// 12:00
	translate([-extrusion_size/2+ball_bearing_width(carriage_bearing)/2,extrusion_size/2 + ball_bearing_diameter(carriage_bearing)/2,ball_bearing_diameter(carriage_bearing)/3]) // pull this one in so it doesn't interfere with the belt clip
		rotate([90,0,90]) {
			children();
		}
}

module carriage_tab() {
	linear_extrude(height=thick_wall, center=true)
	hull() {
		square([1,screw_radius(frame_thick_screw)*6+thick_wall*2],center=true);
		translate([screw_boss_diameter(frame_thick_screw)/2,0,0])
		circle(r=screw_radius(frame_thick_screw)+thick_wall,center=true);
	}
}

//carriage_slide();
//xy_carriage_assembly();
//y_carriage_slide_assembly();
//x_carriage_assembly();
x_carriage_stl();

//y_carriage_end_stl();
//y_carriage_end_vitamins();
