include <conf/config.scad>
include <_positions.scad>

x_filament = 4.4;
z_filament = 9.5;
base_thickness = 2;
total_thickness = 9;

x_idler = 22/2+x_filament;
y_idler = 0;
module mk8() {
	vitamin("MK8 extruder drive gear");
	translate([0,0,z_filament])
	rotate_extrude(convexity = 10, $fn = 100)
	import (file = "extruder/MyExtruder_v1.2.dxf", layer = "mk8");
}

module base() {

difference() {

	union() {

		// Import the 2D design
		linear_extrude(height = 3, center = false, convexity = 10)
  			import (file = "extruder/MyExtruder_v1.2.dxf", layer = "base", $fn=64);
		linear_extrude(height = 14, center = false, convexity = 10)
   			import (file = "extruder/MyExtruder_v1.2.dxf", layer = "base_top", $fn=64);

		// Support for the idler hinge
		translate([15.5,-15.5,0]) {
			cylinder(r=5, h=4, $fn=64);
		}
	}

	union() {

		// Import the 2D design
		translate([0,0,-1]) linear_extrude(height = 16, center = false, convexity = 10)
  			import (file = "extruder/MyExtruder_v1.2.dxf", layer = "base_hole", $fn=64);
  		// bigger bearing cutout
		translate([x_idler,y_idler,3]) cylinder(d=22+2, h=12, $fn=64);

		translate([0,0,z_filament])
		rotate_extrude(convexity = 10, $fn = 100)
		import (file = "extruder/MyExtruder_v1.2.dxf", layer = "mk8ext");

		translate([])
		// Hole for the motor screws
		translate([15.5,-15.5,-1]) cylinder(r=1.5, h=16, $fn=64);
		translate([-15.5,-15.5,-1]) cylinder(r=1.5, h=16, $fn=64);
		translate([15.5,15.5,-1]) cylinder(r=1.5, h=16, $fn=64);
		translate([-15.5,15.5,-1]) cylinder(r=1.5, h=16, $fn=64);

		// motor hole
		// not needed for vandabot
		*translate([0,0,-1]) cylinder(r=11.1, h=3, $fn=64);

		// Hole for the filament
		translate([x_filament,35,z_filament]) rotate([90,0,0]) cylinder(d=4.02, h=70, $fn=64);

		// Hole for the spring nut
		translate([6,21,9.5]) rotate([0,90,0]) cylinder(r=2, h=12, $fn=64);
		translate([7.8,17.4,15.5]) rotate([0,90,0]) cube([10,7.2,3.2]);

		// Hole for the hot-end
		translate([x_filament,-21,z_filament]) rotate([90,0,0]) cylinder(r=8.05, h=4.1, $fn=64);
		translate([x_filament,-25,z_filament]) rotate([90,0,0]) cylinder(r=6.05, h=6, $fn=64);
		translate([x_filament-8.05,-21,z_filament]) rotate([90,0,0]) cube([16.1, 10, 4.1]);
		translate([x_filament-6.05,-25,z_filament]) rotate([90,0,0]) cube([12.1, 10, 6]);

		// Добавлено для 6-й версии Е3Д
		translate([x_filament,-19,z_filament]) rotate([90,0,0]) cylinder(r=3.55, h=2, $fn=64);
		translate([x_filament-3.55,-19,z_filament]) rotate([90,0,0]) cube([7.1, 10, 2]);
		// end Добавлено

		// Holes for the hod-end mount screws
		translate([15.5,-26,-1]) {
				cylinder(r=1.5, h=16, $fn=64);
				cylinder(r=3.5, h=6, $fn=6); // поменял 3.3 на 3.5
		}
		translate([-15.5+8,-26,-1]) {
			cylinder(r=1.5, h=16, $fn=64);
			cylinder(r=3.5, h=6, $fn=6);      // поменял 3.3 на 3.5
		}

		// Hole for the fan mount
		translate([-17.5,-28+3.6,10]) rotate([0,90,0]) cylinder(r=2, h=8, $fn=64);
		translate([-13.5,-28,16]) rotate([0,90,0]) cube([10,7.2,3.2]);

	}

}
	// Import the 2D design, Add some support
		// not needed for vandabot
		*translate([0,0,0]) linear_extrude(height = base_thickness, center = false, convexity = 10)
  			import (file = "extruder/MyExtruder_v1.2.dxf", layer = "support", $fn=64);

}
module extruder_base_stl() {
	stl("extruder_base");
	base();
}

module hot_end_mount() {
difference() {

	union() {
		// Import the 2D design
		translate([0,0,14]) linear_extrude(height = 5, center = false, convexity = 10)
  			import (file = "extruder/MyExtruder_v1.2.dxf", layer = "hot_mount", $fn=64);

	}

	union() {

		// Hole for the hot-end
		translate([4,-20.9,z_filament-0.1]) rotate([90,0,0]) cylinder(r=8.05, h=4.2, $fn=64);
		translate([4,-25,z_filament-0.1]) rotate([90,0,0]) cylinder(r=6.05, h=6.1, $fn=64);

		translate([-25,-50, 0]) cube([50,50,12]);

		// Holes for the hod-end mount screws
		translate([15.5,-26,10]) {
				cylinder(r=1.5, h=16, $fn=64);
				//cylinder(r=3.3, h=4, $fn=6);
		}
		translate([-15.5+8,-26,10]) {
			cylinder(r=1.5, h=16, $fn=64);
			//cylinder(r=3.3, h=4, $fn=6);
		}

	}

}

}
module extruder_hotend_clamp_stl() {
	stl("extruder_hotend_clamp");
	hot_end_mount();
}

module idler() {
//[4, 13, 5, "624"];
difference() {

	union() {

		// Import the 2D design
		linear_extrude(height = base_thickness, center = false, convexity = 10)
  			import (file = "extruder/MyExtruder_v1.2.dxf", layer = "idler_base", $fn=64);
		linear_extrude(height = total_thickness, center = false, convexity = 10)
   			import (file = "extruder/MyExtruder_v1.2.dxf", layer = "idler", $fn=64);

		// Support for the bearing
		translate([x_idler,0,0]) {
			cylinder(d=8, h=total_thickness, $fn=64);
			cylinder(d=10, h=2.4, $fn=64);
			difference() {
				cylinder(h=total_thickness, d=35, center=false);
				translate([-20,0,0])
				cube(size=[40,40,total_thickness*3], center=true);
			}
		}

		// extend the filament guide
		*translate([0,8.5,0])
		hull() {
			translate([-3, 0, 0])
				cylinder(h=total_thickness, r=1, center=false, $fn=20);
			cylinder(h=total_thickness, r=1, center=false, $fn=20);

		}
	}

	union() {

		// Hole for the bearing screw (to be taped M3)
		translate([x_idler,y_idler,total_thickness]) screw_hole(M3_cap_screw, 10);

		// bearing cutout
		difference() {
			//bearing
			translate([x_idler,y_idler,2]) cylinder(d=22+2, h=12, $fn=64);
			//axle
			translate([x_idler,y_idler,2]) cylinder(d=8, h=5, $fn=64);
			//spacer
			translate([x_idler,y_idler,0]) cylinder(d=10, h=2.4, $fn=64);
		}

		// Hole for the hinge screw
		translate([15.5,-15.5,-1]) cylinder(r=1.5, h=12, $fn=64);

		// Hole for the tightening screw
		hull() {
			translate([15,22,z_filament-4]) rotate([0,90,0]) cylinder(r=2, h=12, $fn=64);
			translate([15,20,z_filament-4]) rotate([0,90,0]) cylinder(r=2, h=12, $fn=64);
		}


		// Hole for the filament
		*hull() {
			translate([5,12,4.5]) rotate([90,0,0]) cylinder(r=1.2, h=12, $fn=64);
			translate([0,12,4.5]) rotate([90,0,0]) cylinder(r=1.2, h=12, $fn=64);
		}
		translate([x_filament/2, 6, 6.5]) cube(size=[12,10,9], center=true);
	}

}

}
module extruder_idler_stl() {
	translate([0,0,5]) stl("extruder_idler");
	idler();
}

module extruder_assembly() {
	assembly("Extruder");
	translate([0, -carriage_width/2 - hotend_offset/2, 0])
		// press bearing
		rotate([90,0,0]) {
			translate([x_idler, 0, hotend_offset + ball_bearing_width(BB624)/2 + base_thickness+1]) {
				ball_bearing(BB608);
				translate([0,0,3])
				screw_and_washer(M3_cap_screw, screw_longer_than(ball_bearing_width(BB624)));
			}
			NEMA(E_motor);

			translate([0, 0, hotend_offset/2])
			mk8();
			// short screws
			translate([0, 0, hotend_offset/2 + mount_thickness/2 + base_thickness/2])
			NEMA_screws(E_motor, n=3, screw_length = screw_longer_than(8 + mount_thickness + base_thickness), screw_type = M3_pan_screw);
			// long screw [hinge]
			translate([0, 0, hotend_offset/2 + mount_thickness + total_thickness])
			rotate([0,0,-90])
			NEMA_screws(E_motor, n=1, screw_length = screw_longer_than(8 + mount_thickness + total_thickness), screw_type = M3_pan_screw);
		}
	translate([NEMA_width(E_motor)/2+ 15+5, -carriage_width/2 - hotend_offset/2 - z_filament - mount_thickness, 0+21])
		rotate([0, 90, 0]) {
			screw_and_washer(M3_cap_screw, screw_longer_than(28+5));
			translate([0,0,-20])
			comp_spring(extruder_spring, 20);
			translate([0,0,-28-5]) {
				nut(screw_nut(M3_cap_screw));
			}
		}
	translate([0, -carriage_width/2 - hotend_offset, 0])
		rotate([90,0,0]) {
			color("LimeGreen") {
				render() extruder_base_stl();
				render() extruder_hotend_clamp_stl();
				translate([0,0,hotend_offset/2])
					render() extruder_idler_stl();
			}
			translate([15.5,-26,10 + hotend_offset])
			screw_and_washer(M3_pan_screw, screw_longer_than(total_thickness*2));
			translate([15.5,-26, hotend_offset - total_thickness])
			nut(screw_nut(M3_pan_screw));
			translate([-15.5 + 8,-26,10 + hotend_offset])
			screw_and_washer(M3_pan_screw, screw_longer_than(total_thickness*2));
			translate([-15.5 + 8,-26,hotend_offset - total_thickness])
			nut(screw_nut(M3_pan_screw));
		}
	vitamin("E3D v6 Extruder");
	color("LightBlue", 0.5)
		translate([4.5,-carriage_width/2 - hotend_radius - hotend_offset/2, -42.5])
		rotate([90,0,90])
		import("../imported_stls/E3D_v6.stl");


	end("Extruder");
}


//mk8();
//render() base();
 extruder_base_stl();
//translate([0,0,1])
//rotate([0, 180, 0]) hot_end_mount();
translate([0,0,4]) idler();
%translate([x_filament,35,z_filament]) rotate([90,0,0]) cylinder(r=1.75/2, h=70, $fn=64);

// extruder_assembly();
