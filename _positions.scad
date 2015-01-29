include <_conf/_config.scad>
frame_offset = [
	dimensions.x / 2,
	dimensions.y / 2,
	dimensions.z / 2
	];
tube_dimensions = [
	extrusion_size,
	extrusion_size,
	extrusion_size
	];
extrusion_diag = sqrt(
		pow(extrusion_size, 2)
		+ pow(extrusion_size, 2)
	);

