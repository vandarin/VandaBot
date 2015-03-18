include <conf/config.scad>
include <_positions.scad>


module ps_cover_stl() {
	stl("ps_cover");
	translate([0, ps_dim.y/2, 0]) %cube(size=ps_dim, center=true);
	color("purple")
	difference() {
		union () {
			shelled_box(ps_cover_dim , default_wall, true);

			translate([ps_cover_dim.x/2 - ps_switch_dim.x/2 - default_wall, -ps_cover_dim.y/2, ps_cover_dim.z/2 - ps_switch_dim.z/2 - ps_switch_holes/3]) {
					for(i=[1,-1])
						rotate([90,0,0]) {
							translate([0, i * ps_switch_holes,-default_wall - 3])
							cylinder(h=7, r=3, center=true);
						}
				}
		}
		translate([ps_cover_dim.x/2 - ps_switch_dim.x/2 - default_wall, -ps_cover_dim.y/2, ps_cover_dim.z/2 - ps_switch_dim.z/2 - ps_switch_holes/3]) {
			cube(ps_switch_dim, center=true);
			for(i=[1,-1])
				rotate([90,0,0]) {
					translate([0, i * ps_switch_holes,default_wall])
					screw_hole(M3_cap_screw, screw_longer_than(default_wall*5));
				}
		}
		translate([-ps_cover_dim.x/3,-ps_cover_dim.y/2,0])
			rotate([90,0,0])
			cylinder(h=default_wall*4, d=20, center=true);
		translate([0,0,-ps_cover_dim.z/2-5])
			rotate([0,180,180])
			engrave("VANDABOT");
	}


}


module shelled_box(size, thickness=default_wall, center=true) {

	difference() {
		cube(size + [thickness*2,0,thickness*2], center=center);

		translate([0,thickness, 0])
			cube(size, center=center);
	}
}

//shelled_box([ps_dim.x, ps_switch_dim.y, ps_dim.z] , 3, true);

ps_cover_stl();
