tube_dimensions = [
	extrusion_size,
	extrusion_size,
	25.4/16
	];
extrusion_diag = sqrt(
		pow(extrusion_size, 2)
		+ pow(extrusion_size, 2)
	);

bb_mount_size = max(extrusion_size,ball_bearing_diameter(carriage_bearing)+carriage_clearance);
carriage_height = bb_mount_size*3;
carriage_width = max(bb_mount_size,ball_bearing_diameter(carriage_bearing)*2)+extrusion_size+carriage_clearance;

// OUTSIDE DIMENSIONS
dimensions = [
	// 										y_end
	round(envelope_dimensions.x + carriage_width*3 + (extrusion_size*1.5 + thick_wall + screw_boss_diameter(frame_thick_screw)*2)),
	//										corner mounts
	round(envelope_dimensions.y + carriage_height*2 + extrusion_diag * 3 + thick_wall*2),
		// base					  top frame 		 bottom frame
	round(envelope_dimensions.z + extrusion_diag/2 + extrusion_size/2 + carriage_width + carriage_height)
	];

frame_offset = [
	dimensions.x / 2,
	dimensions.y / 2,
	dimensions.z / 2
	];

XY_pulley_bearing_offset = abs(pulley_od(pulley_type) - ball_bearing_diameter(XY_bearing))/2;

ps_cover_dim = [ps_dim.x, ps_switch_dim.y + ps_extra_space, ps_dim.z];

function motor_offset(type) = NEMA_width(type)/2 + motor_clearance + extrusion_diag/2;
