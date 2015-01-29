eta = 0.01;                     // small fudge factor to stop CSG barfing on coincident faces.

//
// Hole sizes
//
No2_pilot_radius = 1.7 / 2;       // self tapper into ABS
No4_pilot_radius = 2.0 / 2;       // wood screw into soft wood
No6_pilot_radius = 2.0 / 2;       // wood screw into soft wood

No2_clearance_radius = 2.5 / 2;
No4_clearance_radius = 3.5 / 2;
No6_clearance_radius = 4.0 / 2;

M2_tap_radius = 1.6 / 2;
M2_clearance_radius = 2.4 / 2;
M2_nut_trap_depth = 2.5;

M2p5_tap_radius = 2.05 / 2;
M2p5_clearance_radius= 2.8 / 2;   // M2.5
M2p5_nut_trap_depth = 2.5;

M3_tap_radius = 2.5 / 2;
M3_clearance_radius = 3.3 / 2;
M3_nut_radius = 6.5 / 2;
M3_nut_trap_depth = 3;

M4_tap_radius = 3.3 / 2;
M4_clearance_radius = 2.2;
M4_nut_radius = 8.2 / 2;
M4_nut_trap_depth = 4;

M5_tap_radius = 4.2 / 2;
M5_clearance_radius = 5.3 / 2;
M5_nut_radius = 9.2 / 2;
M5_nut_depth = 4;

M6_tap_radius = 5 / 2;
M6_clearance_radius = 6.4 / 2;
M6_nut_radius = 11.6 / 2;
M6_nut_depth = 5;

M8_tap_radius = 6.75 / 2;
M8_clearance_radius = 8.4 / 2;
M8_nut_radius = 15.4 / 2;
M8_nut_depth = 6.5;


include <utils.scad>
include <../vitamins/ball-bearings.scad>
include <../vitamins/belts.scad>
//include <../vitamins/fans.scad>
include <../vitamins/microswitch.scad>
include <../vitamins/washers.scad>
include <../vitamins/nuts.scad>
include <../vitamins/screws.scad>
include <../vitamins/pullies.scad>
include <../vitamins/stepper-motors.scad>

bom = 0;
use_realistic_colors = false;
include <colors.scad>
exploded = false;

// OUTSIDE DIMENSIONS
dimensions = [300,350,300];
extrusion_size = 0.75 * 25.4; // 3/4 inch tube
frame_corner_thickness = 3;
mount_thickness = 5;

printed_plastic_color = "yellow";



//
// Mendel90
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// Configuration file
//

AXIS_MOTOR = NEMA17;

