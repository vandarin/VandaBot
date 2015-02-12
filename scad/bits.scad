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
