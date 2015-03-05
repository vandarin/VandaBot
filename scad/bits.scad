include <conf/config.scad>
include <_positions.scad>


function bearing_screw(ball_bearing) =
					ball_bearing[0] == 3 ? M3_cap_screw :
					ball_bearing[0] == 4 ? M4_cap_screw :
					ball_bearing[0] == 8 ? M8_hex_screw :
					No6_screw
			;

module printed_axle(id,od,l) {
	difference(){
		cylinder(h=l, d=od, center=true, $fn=20);
		poly_cylinder(id/2,l+eta, center=true);
	}
}
module printed_washer_stl() {
	stl("printed_washer");
	difference() {
		union() {
			translate([0,0,1])
			cylinder(h=1, d1=printed_washer_type[0][1] - 2, d2=printed_washer_type[0][0] + 2, center=true);
			cylinder(h=1, d=printed_washer_type[0][1] + 4, center=true);
		}
		translate([0,0,2])
			screw_hole(printed_washer_type[1], screw_longer_than(3));
	}
}

module living_hinge(length,height) {
	for(x = [-length/2+l_hinge_thickness*10 : l_hinge_thickness *10 : length/2-l_hinge_thickness*10]) {
		translate([x,0,0])
			rotate([0,0,45])
			cube(size=[l_hinge_thickness, l_hinge_thickness*8, height], center=true);
		translate([x+l_hinge_thickness*5,0,0])
			rotate([0,0,-45])
			cube(size=[l_hinge_thickness, l_hinge_thickness*8, height], center=true);

	}
}

module pulley_tower(double = true) {
	washer(screw_washer(bearing_screw(XY_bearing)));
	translate([0, 0, washer_thickness(screw_washer(bearing_screw(XY_bearing))) + ball_bearing_width(XY_bearing)/2]) {

		ball_bearing(XY_bearing);
		translate([0,0, ball_bearing_width(XY_bearing)+0.125]) {
			rotate([180,0,0])
			ball_bearing(XY_bearing);
			if (double) {
				washer(screw_washer(bearing_screw(XY_bearing)));
				translate([0,0, washer_thickness(screw_washer(bearing_screw(XY_bearing)))+ ball_bearing_width(XY_bearing)+0.125]) {
					ball_bearing(XY_bearing);
					translate([0,0, ball_bearing_width(XY_bearing)+0.125]) {
						rotate([180,0,0])
						ball_bearing(XY_bearing);
					}
				}
			}
			translate([0,0, ball_bearing_width(XY_bearing)*(double ? 2.5 : 0.5)])
				screw_and_washer(bearing_screw(XY_bearing), screw_longer_than(
					ball_bearing_width(XY_bearing) * (double ? 4 : 2)
					+ washer_thickness(screw_washer(bearing_screw(XY_bearing)))*(double ? 5 : 3)
					+ mount_thickness
					+ nut_thickness(screw_nut(bearing_screw(XY_bearing)))
					));
		}

	}

	translate([0,0,-washer_thickness(screw_washer(bearing_screw(XY_bearing)))/2 - mount_thickness])
	rotate([180,0,0])
		nut_and_washer(screw_nut(bearing_screw(XY_bearing)),true);
}

module z_belt_clip_stl() {
	stl("z_belt_clip");
	difference() {
		hull() {
			for(i=[-1, 1]) {
				translate([i * (belt_width(Z_belt) + default_wall), 0, 0])
				cylinder(h=thick_wall, d = belt_width(Z_belt) + default_wall, center=true);
			}
		}
		for(i=[-1,1]) {
			translate([i * (belt_width(Z_belt) + default_wall), 0, thick_wall])
			screw_hole(frame_thick_screw, thick_wall*2);
		}
		translate([0,0,belt_thickness(Z_belt)/2])
		cube(size=[belt_width(Z_belt)+1, 50, belt_thickness(Z_belt)+1], center=true);
		cube(size=[belt_width(Z_belt)+1, belt_thickness(Z_belt)*2 + 1, thick_wall*2], center=true);
	}
}

module z_long_belt_clip_stl() {
	stl("z_long_belt_clip");
	difference() {
		hull() {
			translate([ (carriage_width/2 - thick_wall*1.25), 0, 0])
				cylinder(h=thick_wall, d = belt_width(Z_belt) + default_wall, center=true);

			translate([ -1 * (carriage_width/2 - thick_wall*1.25 + belt_width(Z_belt)*6), 0, 0])
				cylinder(h=thick_wall, d = belt_width(Z_belt) + default_wall, center=true);
		}
		for(i=[-1,1]) {
			translate([i * (carriage_width/2 - thick_wall*1.25), 0, thick_wall])
			screw_hole(frame_thick_screw, thick_wall*2);
		}
		translate([-1 * (carriage_width/2 + thick_wall*1.2 + belt_width(Z_belt)*2), 0, 0]) {
			translate([0,0,thick_wall/2 - belt_thickness(Z_belt)/2])
				cube(size=[belt_width(Z_belt)+2, 50, belt_thickness(Z_belt)+1], center=true);
			cube(size=[belt_width(Z_belt)+2, belt_thickness(Z_belt)*2 + 1, thick_wall*2], center=true);
		}
		translate([-1 * (carriage_width/2 + thick_wall*1.2 + belt_width(Z_belt)*2 - Z_belt_right_offset), 0, 0]) {
			translate([0,0,thick_wall/2 - belt_thickness(Z_belt)/2])
				cube(size=[belt_width(Z_belt)+2, 50, belt_thickness(Z_belt)+1], center=true);
			cube(size=[belt_width(Z_belt)+2, belt_thickness(Z_belt)*2 + 1, thick_wall*2], center=true);
		}
	}
}
//belt_mount(GT2);
//printed_washer_stl(BB608,M3_cap_screw);

z_long_belt_clip_stl();
