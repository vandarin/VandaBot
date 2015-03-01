// bom = 2;

extrusion_size =  19.2; //0.75 * 25.4; // 3/4 inch tube
frame_corner_thickness = 3;
mount_thickness = 5;
carriage_clearance = 6;
l_hinge_thickness = 0.6;
l_hinge_width = 5;
printed_plastic_color = "yellow";


echo("VandaBot:");
echo(str("Outside dimensions: ", dimensions.x, "mm x ", dimensions.y, "mm x ", dimensions.z, "mm"));
echo(str("Build envelope: ", envelope_dimensions.x, "mm x ", envelope_dimensions.y, "mm x ", envelope_dimensions.z, "mm"));
echo(str("Carriage dimensions: ", carriage_width, "mm x ", carriage_height, "mm"));
echo(str("Extrusion size: ", tube_dimensions.x, "mm x ", tube_dimensions.y, "mm x ", tube_dimensions.z, "mm"));
//hot_end = E3Dv6;
hotend_radius = 15;
hotend_offset = 9.4; // from extruder STL
hotend_height = 62; // from E3Dv6 documentation


bed_depth = 214;
bed_width = 314;
bed_pillars = M3x20_pillar;
bed_glass = glass2;
bed_thickness = pcb_thickness + sheet_thickness(bed_glass);    // PCB heater plus glass sheet
bed_holes = [bed_width - 2 * 2.54, bed_depth - 2 * 2.54];

base = DiBond;                  // Sheet material used for the base. Needs to be thick enough to screw into.
base_corners = 25;
base_nuts = true;

frame = DiBond;
frame_corners = 25;
frame_nuts = true;
// Printing envelope
envelope_dimensions = [
	bed_width + 70,
	bed_depth + 70,
	350
	];
X_travel = envelope_dimensions.x;
Y_travel = envelope_dimensions.y;
Z_travel = envelope_dimensions.z;

case_fan = fan80x38;
part_fan = fan40x11;

psu = External;
controller = Melzi;

spool = spool_200x55;
bottom_limit_switch = false;
top_limit_switch = true;
include_fan = true;

clip_handles = false;
single_piece_frame = true;
stays_from_window = false;
cnc_sheets = true;                 // If sheets are cut by CNC we can use slots, etc instead of just round holes

pulley_type = GT2x20_metal_pulley;

XY_belt = GT2;
XY_motor = NEMA17;
motor_clearance = 5;
XY_bearing = BBF624;
carriage_bearing = BB623;

Z_belt = GT2;
Z_motor = NEMA17;
Z_bearing = BB608;

E_motor = NEMA17;
E_motor_clearance = 4;


printed_washer_type = [Z_bearing, M3_cap_screw];
//
// Default screw use where size doesn't matter
//
cap_screw = M3_cap_screw;
hex_screw = M3_hex_screw;
//
// Screw for the frame and base
//
frame_soft_screw = No4_screw;               // Used when sheet material is soft, e.g. wood
frame_thin_screw = M3_cap_screw;            // Used with nuts when sheets are thin
frame_thick_screw = M4_cap_screw;
//
// Feature sizes
//
default_wall = 3;
thick_wall = 6;
