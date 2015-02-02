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
