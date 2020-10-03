// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, view_get_xport(view_camera[0]), view_get_yport(view_camera[0]), view_get_xport(view_camera[0]) + view_get_wport(view_camera[0]), view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) {
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
if instance_exists(obj_worker) {
	if currentHP <= (12 * obj_worker.objectRubyMineSpeed) {
		currentHP += (12 * obj_worker.objectRubyMineSpeed);
	}
}


