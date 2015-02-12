include <conf/config.scad>
include <_positions.scad>
use <MCAD/shapes.scad>
use <bits.scad>

//carriage_bearing = BB624;

bb_mount_size = max(extrusion_size,ball_bearing_diameter(carriage_bearing)+carriage_clearance);
carriage_height = bb_mount_size*3;
carriage_width = max(bb_mount_size,ball_bearing_diameter(carriage_bearing)*2)+extrusion_size+carriage_clearance;
//function grip_offset(extrusion_size = extrusion_size) = extrusion_size + ball_bear;
module xy_carriage_assembly() {
	assembly("xy_carriage");
	translate([-frame_offset.x, 0, 0])
	rotate([90,0,0]) {
		y_carriage_slide_assembly();
		y_carriage_end_stl();
		y_carriage_end_vitamins();
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
			y_carriage_end_stl();
			y_carriage_end_vitamins();
		}
	}
	rotate([0,90,0])
	rotate([0,0,45])
	square_tube(tube_dimensions, dimensions.x - carriage_width*2);
	end("xy_carriage");
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

					translate([0, 0, extrusion_diag/2])
					cube(size=[extrusion_size*1.5 + thick_wall, extrusion_diag*3, mount_thickness], center=true);
					}
				}
			}
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
			translate([-carriage_width - extrusion_size, 0,0]) {
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
			carriage_tab();
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
	translate([carriage_width-thick_wall + pulley_od(pulley_type),thick_wall/2 + extrusion_diag/2, -extrusion_diag])
		rotate([-90,0,0])
		children();
	translate([carriage_width-thick_wall,thick_wall/2 + extrusion_diag/2, extrusion_diag])
		rotate([-90,0,0])
		children();
}

module y_carriage_slide_stl() {
	stl("y_carriage_slide");
	rotate([0,0,-45])
	carriage_slide();
	translate([carriage_width/2-thick_wall/2,-thick_wall*1.5,0])
		rotate([90,0,0])
		carriage_tab();
	translate([carriage_width/2-thick_wall/2,thick_wall*1.5,0])
		rotate([90,0,0])
		carriage_tab();
}
module carriage_slide_vitamins() {
	%cube([extrusion_size,extrusion_size,carriage_height*2], center=true);

	translate([0,0,carriage_height/3])
		carriage_layout() {
			ball_bearing(carriage_bearing);
			translate([0,0,ball_bearing_width(carriage_bearing)/2])
				screw(
				bearing_screw(carriage_bearing), screw_longer_than(ball_bearing_width(carriage_bearing) + carriage_clearance*2)
				);
			translate([0,0,-screw_longer_than(ball_bearing_width(carriage_bearing))-thick_wall/2])
			nut(screw_nut(bearing_screw(carriage_bearing)));
		}
	translate([0,0,-carriage_height/3])
	carriage_layout() {
		ball_bearing(carriage_bearing);
		translate([0,0,ball_bearing_width(carriage_bearing)/2])
			screw(
			bearing_screw(carriage_bearing), screw_longer_than(ball_bearing_width(carriage_bearing) + carriage_clearance*2)
			);
		translate([0,0,-screw_longer_than(ball_bearing_width(carriage_bearing))-thick_wall/2])
			nut(screw_nut(bearing_screw(carriage_bearing)));
	}
	translate([carriage_width/2 - spring_length(hob_spring)/2, -carriage_width/2 + spring_length(hob_spring)/2, 0])
	rotate([90,0,45])
	comp_spring(hob_spring);
}

module carriage_slide() {
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
			rotate([0,0,45])
			living_hinge(carriage_width, carriage_height);
			rotate([0,0,45])
			translate([0,-l_hinge_width,0])
			difference() {
				// outer shell
				roundedBox(carriage_width-thick_wall,carriage_width+thick_wall+l_hinge_width*2,carriage_height,carriage_clearance/4*3);
				difference() {
					// inner shell
					roundedBox(carriage_width-thick_wall*2,carriage_width+l_hinge_width*2,carriage_height+10,carriage_clearance/2);
				}
			}
		}
		// bearing holes top
		translate([0,0,carriage_height/3])
		carriage_layout() {
			translate([0,0,-bb_mount_size+nut_thickness(screw_nut(bearing_screw(carriage_bearing)))*2])
			nut_trap(screw_radius(bearing_screw(carriage_bearing)), nut_radius(screw_nut(bearing_screw(carriage_bearing))), nut_thickness(screw_nut(bearing_screw(carriage_bearing))));
		}

		// bearing holes bottom
		translate([0,0,-carriage_height/3])
		carriage_layout() {
			translate([0,0,-bb_mount_size+nut_thickness(screw_nut(bearing_screw(carriage_bearing)))*2])
				nut_trap(screw_radius(bearing_screw(carriage_bearing)), nut_radius(screw_nut(bearing_screw(carriage_bearing))), nut_thickness(screw_nut(bearing_screw(carriage_bearing))));
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

xy_carriage_assembly();
//y_carriage_slide_assembly();


//y_carriage_end_stl();
//y_carriage_end_vitamins();
