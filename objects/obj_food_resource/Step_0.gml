// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]), camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])) {
	objectOnScreen = true;
}
else {
	objectOnScreen = false;
}

// Destroy self if current HP drops below 0.
if currentHP <= 0 {
	mp_grid_clear_cell(movementGrid, floor(x / 16), floor(y / 16));
	instance_destroy(id);
}


