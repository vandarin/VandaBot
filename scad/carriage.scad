include <conf/config.scad>
include <_positions.scad>
use <MCAD/shapes.scad>
use <bits.scad>
use <extruder.scad>

//carriage_bearing = BB624;


//function grip_offset(extrusion_size = extrusion_size) = extrusion_size + ball_bear;
module xy_carriage_assembly() {
	assembly("xy_carriage");
	translate([-frame_offset.x, 0, 0]) {
		translate([carriage_width/2 + screw_boss_diameter(frame_thick_screw)/2,0,0]) {
			translate([0,0,thick_wall*2])
			screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall*5));
			translate([0,0,-thick_wall*2.5])
				nut(screw_nut(frame_thick_screw));
		}
		rotate([90,0,0]) {
			y_carriage_slide_assembly();
			render() y_carriage_end_stl();
			y_carriage_end_vitamins();
		}
	}
	translate([frame_offset.x, 0, 0]) {
		translate([-carriage_width/2 - screw_boss_diameter(frame_thick_screw)/2,0,0]) {
			translate([0,0,thick_wall*2])
			screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall*5));
			translate([0,0,-thick_wall*2.5])
				nut(screw_nut(frame_thick_screw));
		}

		rotate([-90,180,0]) {
			y_carriage_slide_assembly();
			render() y_carriage_end_stl();
			y_carriage_end_vitamins();
		}
	}
	rotate([0,90,0])
	rotate([0,0,45])
	square_tube(tube_dimensions, dimensions.x - carriage_width*2);
	x_carriage_assembly();
	end("xy_carriage");
}

module x_carriage_assembly() {
	assembly("x_carriage");
	render() x_carriage_stl();
	rotate([45,0,0]) rotate([0,90,0])
	{
		carriage_slide_vitamins();
	}
	translate([
		carriage_width/2 + thick_wall/3 ,
		carriage_width/3 - thick_wall/2,
		0
		]) {
		belt_tie();
	}
	translate([
		-carriage_width/2 - thick_wall/3 ,
		carriage_width/3 - thick_wall/2,
		0
		]) {
		belt_tie();
	}
	translate([
		carriage_width/2 + thick_wall/3 ,
		-carriage_width/3 + thick_wall/2,
		0
		]) {
		belt_tie();
	}
	translate([
		-carriage_width/2 - thick_wall/3 ,
		-carriage_width/3 + thick_wall/2,
		0
		]) {
		belt_tie();
	}
	extruder_assembly();
	end("x_carriage");
}
module belt_tie() {
	translate([0,0,carriage_width/2+ thick_wall + ball_bearing_width(XY_bearing)*4])
		screw_and_washer(bearing_screw(XY_bearing), screw_longer_than(
				ball_bearing_width(XY_bearing) * 4
				+ washer_thickness(screw_washer(bearing_screw(XY_bearing)))*5
				+ mount_thickness
				+ nut_thickness(screw_nut(bearing_screw(XY_bearing)))
				));
	translate([0,0,carriage_width/2 - thick_wall/2])
		nut(screw_nut(bearing_screw(XY_bearing)));
	translate([0,0,carriage_width/2 + thick_wall/2])
		nut(screw_nut(bearing_screw(XY_bearing)));
}

module x_carriage_stl() {
	stl("x_carriage");
	rotate([45,0,0]) rotate([0,90,0])
		render() carriage_slide();
	translate([
		0,
		-carriage_width/2,
		carriage_width
		])
	difference(){
		union() {
		// vertical mount
		translate([0, mount_thickness/2 - hotend_offset, mount_thickness])
			cube(size=[carriage_height, mount_thickness, NEMA_width(E_motor)+mount_thickness*2], center=true);
		// connector
		translate([0, -hotend_offset/2+mount_thickness/2, -carriage_width/2])
			cube(size=[carriage_height, hotend_offset + mount_thickness, thick_wall], center=true);
		translate([0,0,-NEMA_width(E_motor)/2 - mount_thickness+0.7])
			rotate([-90,0,0]) rotate([0, 90, 0])
			fillet(mount_thickness, carriage_height);
		}
		translate([0,-hotend_offset+mount_thickness/2, E_motor_clearance])
			rotate([90,0,0])
			NEMA_all_holes(E_motor);
		translate([0,-hotend_offset,-NEMA_width(E_motor)/2 - mount_thickness+0.5])
			rotate([0, -90, 0])
			fillet(mount_thickness, carriage_height+5);
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
	translate([carriage_width + extrusion_size,0,0]) {
		rotate([-45,0,0])
		difference() {
			union() {
				translate([-extrusion_size/2 - thick_wall/2,0,0]) {
					cube(
						size=[
							extrusion_size*1.5 + thick_wall,
							extrusion_size + thick_wall,
							extrusion_size + thick_wall
							],
						center=true
						);
					rotate([-45,0,0]) {
						translate([0, 0, extrusion_diag/2]) {
							cube(size=[
								extrusion_size*1.5 + thick_wall,
								extrusion_diag*2,
								mount_thickness
								], center=true);
							translate([-2 - thick_wall/2 - pulley_od(pulley_type), thick_wall + extrusion_diag/2, 0]) {
								cylinder(h=mount_thickness, d=15, center=true);
							}
							translate([-2 - thick_wall/2 - pulley_od(pulley_type), -thick_wall - extrusion_diag/2, 0]) {
								cylinder(h=mount_thickness, d=15, center=true);
							}
						}
					}
				}
			translate([-extrusion_size/2-thick_wall/2, extrusion_size/2 + thick_wall/2 , thick_wall/2])
				rotate([-20,0,0])
				rotate([0,90,0])
					fillet(mount_thickness, extrusion_size*1.5 + thick_wall);

			translate([-extrusion_size/2-thick_wall/2, thick_wall/2 , extrusion_size/2 + thick_wall/2])
				rotate([110,0,0])
				rotate([0,-90,0])
					fillet(mount_thickness, extrusion_size*1.5 + thick_wall);
			} // end union
			//cut off the triangle on top

			rotate([-45,0,0])
				translate([-extrusion_size/2 - thick_wall/2, 0, extrusion_diag/2 + mount_thickness - eta])
					cube(size=[55,55,5], center=true);
			// extrusion
			translate([thick_wall/2,0,0])
			cube([extrusion_size*2.5+thick_wall,extrusion_size,extrusion_size], center=true);
			//frame holes
			translate([-thick_wall, 0, 0])
			for( i = [0, -90] ) {
				rotate([i,0,0]) {
					poly_cylinder(r = screw_radius(frame_thick_screw), h = extrusion_size*2, center = true);
					translate([0,0,extrusion_size + thick_wall/2])
					cylinder(h=extrusion_size, d=screw_boss_diameter(frame_thick_screw), center=true);
				}
			}
			// pulley_tower holes
			translate([-carriage_width - extrusion_size - pulley_od(pulley_type), 0,0]) {
				rotate([45, 0, 0]) {

					y_pulley_placement() screw_hole(frame_thick_screw, mount_thickness*2);
					translate([(carriage_width - thick_wall)*2 + pulley_od(pulley_type), 0, 0])
					mirror([])
					y_pulley_placement() screw_hole(frame_thick_screw, mount_thickness*2);

				}
			}
		}
		translate([-carriage_width/2 - thick_wall/4*3,0,0])
			rotate([90,180,0])
			resize(newsize=[0, 0, thick_wall*2])
			render () carriage_tab();
	}
}
module y_carriage_end_vitamins() {
	translate([carriage_width + extrusion_size - thick_wall,0,0]) {
		translate([0, -extrusion_size/2, extrusion_size/2])
			rotate([45,0,0])
			screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall+tube_dimensions.z));
		translate([0, -extrusion_size/2, -extrusion_size/2])
			rotate([135,0,0])
			screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall+tube_dimensions.z));
		translate([0, extrusion_size/2, -extrusion_size/2])
			rotate([225,0,0])
			screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall+tube_dimensions.z));
		translate([0, extrusion_size/2, extrusion_size/2])
			rotate([315,0,0])
			screw_and_washer(frame_thick_screw, screw_longer_than(thick_wall+tube_dimensions.z));
	}
		y_pulley_placement()
			pulley_tower();
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
	render() carriage_slide();
	translate([carriage_width/2-thick_wall/2,-thick_wall*1.5,0])
		rotate([90,0,0])
		render() carriage_tab();
	translate([carriage_width/2-thick_wall/2,thick_wall*1.5,0])
		rotate([90,0,0])
		render() carriage_tab();
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
		// X carriage nut traps
		if(hinged) {
			translate([thick_wall/3*2, -thick_wall/3*2, 0])
			rotate([0,0,45]) {
				for(i=[1,-1]) { for(j=[1,-1]){

				translate([i*(carriage_width/3 - thick_wall/2), carriage_width/2 + thick_wall/2, j*(carriage_width/2 + thick_wall/3)])
					rotate([90,0,0])
						nut_trap(screw_radius(frame_thick_screw), nut_radius(screw_nut(frame_thick_screw)), nut_thickness(screw_nut(frame_thick_screw)));
					}}
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
	translate([-extrusion_size/2 - ball_bearing_diameter(carriage_bearing)/2,extrusion_size/2-ball_bearing_width(carriage_bearing)/2,-ball_bearing_diameter(carriage_bearing)/2])
		rotate([90,0,0]) {
			children();
		}
	// 12:00
	translate([-extrusion_size/2+ball_bearing_width(carriage_bearing)/2,extrusion_size/2 + ball_bearing_diameter(carriage_bearing)/2,ball_bearing_diameter(carriage_bearing)/2])
		rotate([90,0,90]) {
			children();
		}
}

module carriage_tab() {
	difference() {
			linear_extrude(height=thick_wall, center=true)
			hull() {
				square([1,screw_radius(frame_thick_screw)*6+thick_wall*2],center=true);
				translate([screw_boss_diameter(frame_thick_screw)/2,0,0])
				circle(r=screw_radius(frame_thick_screw)+thick_wall,center=true);
			}
			translate([screw_boss_diameter(frame_thick_screw)-thick_wall/2,0,0])
			cylinder(h=thick_wall*8, r=screw_pilot_hole(frame_thick_screw), center=true);

		}
}

//carriage_slide();
xy_carriage_assembly();
//y_carriage_slide_assembly();
//x_carriage_assembly();
//x_carriage_stl();

//y_carriage_end_stl();
//y_carriage_end_vitamins();
