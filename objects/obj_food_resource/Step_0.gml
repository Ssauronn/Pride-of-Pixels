// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, view_get_xport(view_camera[0]), view_get_yport(view_camera[0]), view_get_xport(view_camera[0]) + view_get_wport(view_camera[0]), view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) {
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


