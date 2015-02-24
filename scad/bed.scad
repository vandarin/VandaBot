//
// Mendel90
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// Bed with glass and support pillars
//

include <conf/config.scad>
include <_positions.scad>
use <bits.scad>

module bed_assembly(y = 0) {
    assembly("Bed");
    //
    // Screws pillars and washers
    //
    for(x = [-bed_holes[0] / 2, bed_holes[0] / 2]) {
        translate([x, bed_holes[1] / 2, 0])
            washer(M3_washer);

        translate([x, -bed_holes[1] / 2, 0])
            washer(M3_washer);

        for(y = [-bed_holes[1] / 2, bed_holes[1] /2])
            translate([x, y, washer_thickness(M3_washer)]) {
                hex_pillar(bed_pillars);

                translate([0,0, pillar_height(bed_pillars) + pcb_thickness])
                    screw(M3_cap_screw, 10);
            }
    }

    //
    // Mark the origin
    //
    *translate([0, 0, pillar_height(bed_pillars) + pcb_thickness + sheet_thickness(bed_glass)])
        color("green")
            render()
                sphere();

    // Substrate
    assembly("Bed Frame");
    translate([0,0, -extrusion_size/2 - washer_thickness(M3_washer)*2]) {
        for (i = [-1,1]) {
            translate([i*(bed_width/2 + extrusion_size), (dimensions.y/2 - bed_depth/2)/2 - extrusion_size/4 + thick_wall/2, 0])
            rotate([90, 0, 0])
            square_tube(tube_dimensions, bed_depth/2 + dimensions.y/2 + extrusion_size/2 + thick_wall);
            vitamin("CB40: Corner Brace");
            for(j = [-1 : 2]) {
                translate([j*screw_boss_diameter(frame_thick_screw), i*screw_boss_diameter(frame_thick_screw), 0])
                screw_and_washer(frame_thick_screw, 10);
            }
        }
        for (i = [-1,1]) {
            translate([0,i*(bed_depth/2), 0])
            rotate([0, 90, 0])
            square_tube(tube_dimensions, bed_width + extrusion_size);
            vitamin("CB40: Corner Brace");
            for(j = [-1 : 2]) {
                translate([j*screw_boss_diameter(frame_thick_screw), i*screw_boss_diameter(frame_thick_screw)*2, 0])
                screw_and_washer(frame_thick_screw, 10);
            }
        }
    }
    end("Bed Frame");

    //
    // PCB, glass and clips
    //
    translate([0, 0, washer_thickness(M3_washer)]) {
        vitamin(str("BED", bed_width, bed_depth,": PCB bed ", bed_width, "mm x ", bed_depth, "mm"));
        vitamin(str("CRK", bed_width, bed_depth, ": PCB Insulator ", bed_width, "mm x ", bed_depth, "mm"));
        translate([0,0, pillar_height(bed_pillars) + pcb_thickness / 2])
            color(bed_color) cube([bed_width, bed_depth, pcb_thickness], center = true);

        translate([0,0, pillar_height(bed_pillars) + pcb_thickness + sheet_thickness(bed_glass) / 2 + eta * 3])
            sheet(bed_glass, bed_width, bed_depth - 12);

        for(x = [-1, 1])
            for(y = [-1,1])
                translate([bed_width / 2 * x,
                           ((bed_depth - bulldog_length(small_bulldog)) / 2 - washer_diameter(M3_washer)) * y,
                           pillar_height(bed_pillars) + (pcb_thickness + sheet_thickness(bed_glass))/ 2])
                    rotate([0, 0, 90 + x * 90])
                        bulldog(small_bulldog, pcb_thickness + sheet_thickness(bed_glass));
    }

    translate([-1 * (bed_width/2 + extrusion_size*1.5 + thick_wall/2), dimensions.y/2 - extrusion_diag, -extrusion_size/2])
        rotate([90,0,90])
        #z_long_belt_clip_stl();
    translate([bed_width/2 - carriage_width + thick_wall, dimensions.y/2 - extrusion_diag, -extrusion_size/2])
        rotate([90,0,90])
        #z_long_belt_clip_stl();

    translate([0, 40, pillar_height(bed_pillars) - 1])
        rotate([-90, 0, 0])
            sleeved_resistor(EpcosBlue, PTFE07, heatshrink = HSHRNK16);

    for(i = [-1, 1]) {
        translate([i * 10, bed_depth / 2 - y + 17.5, -(extrusion_size / 2) + 3.4])
            rotate([90, 0, 0])
                tubing(HSHRNK64, 30);

        translate([i * 3, bed_depth / 2 - y + 10, -(extrusion_size / 2) + 1.4])
            rotate([90, 0, 0])
                tubing(HSHRNK24);
    }
    wire("Red", 32, 600 + 20);
    wire("Black", 32, 615 + 20);
    ribbon_cable(bed_ways,
        10 +            // strip
        70 +            // loop under bed
        5  +            // loop to other side of carriage
        cable_strip_length(10, envelope_dimensions.z)
        + 25            // tail for connection to wire
    );
    end("Bed");
}

bed_assembly();
