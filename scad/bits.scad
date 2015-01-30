include <conf/config.scad>
include <_positions.scad>

module printed_axle(id,od,l) {

	difference(){
		cylinder(h=l, d=od, center=true, $fn=20);
		poly_cylinder(id/2,l+eta, center=true);
	}
}


printed_axle(3,8,20);
