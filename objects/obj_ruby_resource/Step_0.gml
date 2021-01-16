// Stop certain sections of code if not on screen
var top_y_ = y - sprite_get_height(sprite_index) + 16;
var bottom_y_ = y + 16;
var left_x_ = x;
var right_x_ = x + sprite_get_width(sprite_index);
if rectangle_in_rectangle(left_x_, top_y_, right_x_, bottom_y_, viewX, viewY, viewX + viewW, viewY + viewH) > 0 {
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


