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

// Destroy self if current HP drops below 0.
if currentHP <= 0 {
	mp_grid_clear_cell(movementGrid, floor(x / 16), floor(y / 16));
	instance_destroy(id);
}


