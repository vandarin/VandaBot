

include <_conf/_config.scad>
include <utils/bom.scad>
include <vitamins/bars.scad>
include <vitamins/washers.scad>
include <vitamins/screws.scad>
include <_positions.scad>
use <motor_mount.scad>

module frame() {
//TOP
	frame_corners();

}


module frame_extrusions_top() {
	//FRONT
	translate([0,-frame_offset.y,frame_offset.z])
		rotate([45,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - extrusion_diag - frame_corner_thickness);
	//LEFT
	translate([-frame_offset.x,0,frame_offset.z])
		rotate([0,45,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag);
	//BACK
	translate([0,frame_offset.y,frame_offset.z])
		rotate([45,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - tube_dimensions.x - frame_corner_thickness*2);
	//RIGHT
	translate([frame_offset.x,0,frame_offset.z])
		rotate([0,45,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag);

}
module frame_extrusions_bottom() {
	//FRONT
	translate([0,-frame_offset.y,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - extrusion_diag - frame_corner_thickness);
	//LEFT
	translate([-frame_offset.x,0,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag);
	//BACK
	translate([0,frame_offset.y,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,0])
				square_tube(tube_dimensions, dimensions.x - tube_dimensions.x - frame_corner_thickness*2);
	//RIGHT
	translate([frame_offset.x,0,-frame_offset.z])
		rotate([0,0,0])
			rotate([0,90,90])
				square_tube(tube_dimensions, dimensions.y - extrusion_diag);

}

module frame_extrusions_sides() {
	// FRONT RIGHT
	translate([frame_offset.x, -frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z);
	// FRONT LEFT
	translate([-frame_offset.x, -frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z);
	// BACK RIGHT
	translate([frame_offset.x, frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z);
	// BACK LEFT
	translate([-frame_offset.x, frame_offset.y, 0])
		rotate([0,0,0])
			rotate([0,0,90])
				square_tube(tube_dimensions, dimensions.z);
}

module frame_corners() {
	difference() {
		union() {
			// FRONT TOP RIGHT
			translate([frame_offset.x,-frame_offset.y, frame_offset.z]) {
				frame_corner();
			}
			// FRONT TOP LEFT
			translate([-frame_offset.x,-frame_offset.y, frame_offset.z]) {
				rotate([0,0,-90])
				frame_corner();
			}
			// BACK TOP RIGHT
			translate([frame_offset.x,frame_offset.y, frame_offset.z]) {
				rotate([0,0,90])
				frame_corner();
				translate([-extrusion_diag*1.5, -extrusion_diag*1.5, extrusion_diag/2 -1 + eta])
					rotate([0, 0, -90])
					motor_mount();
			}
			// BACK TOP LEFT
			translate([-frame_offset.x,frame_offset.y, frame_offset.z]) {
				rotate([0,0,180])
				frame_corner();
				translate([extrusion_diag*1.5, -extrusion_diag*1.5, extrusion_diag/2 -1])
					motor_mount();
			}

			// FRONT BOTTOM RIGHT
			translate([frame_offset.x,-frame_offset.y, -frame_offset.z]) {
				rotate([0,90,0])
				frame_corner(false);
			}
			// FRONT BOTTOM LEFT
			translate([-frame_offset.x,-frame_offset.y, -frame_offset.z]) {
				rotate([0,90,-90])
				frame_corner(false);
			}
			// BACK BOTTOM RIGHT
			translate([frame_offset.x,frame_offset.y, -frame_offset.z]) {
				rotate([90,0,90])
				frame_corner(false);
			}
			// BACK BOTTOM LEFT
			translate([-frame_offset.x,frame_offset.y, -frame_offset.z]) {
				rotate([90,0,180])
				frame_corner(false);
			}

		}
			#frame_extrusions_top();
			#frame_extrusions_sides();
			#frame_extrusions_bottom();
	}
}

module frame_corner(angle_screws = true) {
	//main block
	base_size = angle_screws ? extrusion_diag + frame_corner_thickness : extrusion_size + frame_corner_thickness * 2;
	position = angle_screws ? extrusion_diag : extrusion_size;
	color(plastic_part_color("Yellow"))
	difference() {
		union() {
			translate([-position / 2, 0, 0])
				cube(
					size=[base_size +position,base_size,base_size],
					center=true
					);
			translate([0, position / 2, 0])
				cube(
					size=[
						base_size,
						base_size +position,
						base_size
						],
					center=true
				);
	// Z support
			translate([0,0,-position])
			cube(base_size, center=true);
				} // end inner union
			if (angle_screws) {
			translate([
				position - frame_corner_thickness,
				-position + frame_corner_thickness,
				position
				])
				rotate([45,45,0])
					cube(base_size*2, center=true);

			} else {
				translate([
				position + frame_corner_thickness,
				-position - frame_corner_thickness,
				position + frame_corner_thickness
				])
				rotate([45,45,0])
					cube(base_size*2, center=true);
			}
	}
}

frame();
