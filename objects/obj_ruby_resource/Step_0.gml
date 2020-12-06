// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]), camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])) {
	objectOnScreen = true;
}
else {
	objectOnScreen = false;
}

// Make sure the ruby regenerates.
if currentHP > maxHP {
	currentHP = maxHP;
}
else if currentHP < maxHP {
	currentHP += min((maxHP - currentHP), regenerationPerSecond);
}
// If current HP is less than the HP a full group of miners could mine in the next frame, boost
// it so that the HP is above that number.
if instance_exists(obj_unit) {
	if variable_instance_exists(obj_unit, "objectRubyMineSpeed") {
		if currentHP <= (12 * obj_unit.objectRubyMineSpeed) {
			currentHP += (12 * obj_unit.objectRubyMineSpeed);
		}
	}
}


