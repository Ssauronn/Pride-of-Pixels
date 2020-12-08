/*
// Draw the movement grid
var i;
for (i = 0; i <= floor(room_width / 16); i++) {
	draw_line_color(i * 16, 0, i * 16, room_height, c_red, c_red);
}
for (i = 0; i <= floor(room_height / 16); i++) {
	draw_line_color(0, i * 16, room_width, i * 16, c_red, c_red);
}*/


// Always draw the mouse sprite in the correct area
var color_ = c_yellow;
if mouse_check_button(mb_left) {
	color_ = c_white;
}
else {
	draw_sprite_ext(spr_mouse_highlight, mouseHoverIconFrame, floor(mouseClampedX / 16) * 16, floor(mouseClampedY / 16) * 16, 1, 1, 0, color_, 0.5);
}

#region Mouse UX
// Draw the selection box if the player holds the mouse down as long
// as the player isn't hovering over the toolbar at the bottom.
if device_mouse_y_to_gui(0) <= (view_get_hport(view_camera[0]) - toolbarHeight) {
	if (mbLeftPressedXCoordinate != -1) && (mbLeftPressedYCoordinate != -1) {
		var current_mouse_x_ = floor(mouse_x / 16) * 16;
		var current_mouse_y_ = floor(mouse_y / 16) * 16;
		var amount_of_boxes_displaced_on_x_axis_ = ((current_mouse_x_ - mbLeftPressedXCoordinate) / 16);
		var amount_of_boxes_displaced_on_y_axis_ = ((current_mouse_y_ - mbLeftPressedYCoordinate) / 16);
		if (amount_of_boxes_displaced_on_x_axis_ != 0) || (amount_of_boxes_displaced_on_y_axis_ != 0) {
			// Getting locations to place horizontal lines at
			var top_line_location_, bottom_line_location_;
			if mbLeftPressedYCoordinate <= current_mouse_y_ {
				top_line_location_ = mbLeftPressedYCoordinate;
				bottom_line_location_ = current_mouse_y_ + 16 - sprite_get_height(spr_mouse_drag_horizontal_line);
			}
			else {
				top_line_location_ = current_mouse_y_;
				bottom_line_location_ = mbLeftPressedYCoordinate + 16 - sprite_get_height(spr_mouse_drag_horizontal_line);
			}
			// Getting locations to place vertical lines at
			var left_line_location_, right_line_location_;
			if current_mouse_x_ <= mbLeftPressedXCoordinate {
				left_line_location_ = current_mouse_x_;
				right_line_location_ = mbLeftPressedXCoordinate + 16 - sprite_get_width(spr_mouse_drag_vertical_line);
			}
			else {
				left_line_location_ = mbLeftPressedXCoordinate;
				right_line_location_ = current_mouse_x_ + 16 - sprite_get_width(spr_mouse_drag_vertical_line);
			}
	
			// X axis
			var displacement_for_negative_values_in_drawing_x_= 0;
			var displacement_for_negative_values_in_drawing_y_ = 0;
			if sign(amount_of_boxes_displaced_on_x_axis_) != -1 {
				amount_of_boxes_displaced_on_x_axis_++;
			}
			else {
				amount_of_boxes_displaced_on_x_axis_--;
				displacement_for_negative_values_in_drawing_x_ = 16;
			}
			// Y axis
			if sign(amount_of_boxes_displaced_on_y_axis_) != -1 {
				amount_of_boxes_displaced_on_y_axis_++;
			}
			else {
				amount_of_boxes_displaced_on_y_axis_--;
				displacement_for_negative_values_in_drawing_y_ = 16;
			}
	
			draw_sprite_ext(spr_mouse_drag_horizontal_line, 0, mbLeftPressedXCoordinate + displacement_for_negative_values_in_drawing_x_, top_line_location_ - 3, amount_of_boxes_displaced_on_x_axis_, 1, 0, c_white, 0.5);
			draw_sprite_ext(spr_mouse_drag_horizontal_line, 0, mbLeftPressedXCoordinate + displacement_for_negative_values_in_drawing_x_, bottom_line_location_ + 3, amount_of_boxes_displaced_on_x_axis_, 1, 0, c_white, 0.5);
			draw_sprite_ext(spr_mouse_drag_vertical_line, 0, left_line_location_ - 3, mbLeftPressedYCoordinate + displacement_for_negative_values_in_drawing_y_, 1, amount_of_boxes_displaced_on_y_axis_, 0, c_white, 0.5);
			draw_sprite_ext(spr_mouse_drag_vertical_line, 0, right_line_location_ + 3, mbLeftPressedYCoordinate + displacement_for_negative_values_in_drawing_y_, 1, amount_of_boxes_displaced_on_y_axis_, 0, c_white, 0.5);
		}
		else {
		
		}
	}
	draw_sprite_ext(spr_mouse_highlight, mouseHoverIconFrame, floor(mouseClampedX / 16) * 16, floor(mouseClampedY / 16) * 16, 1, 1, 0, color_, 0.5);
}
#endregion

#region Menu UX

#endregion

#region Healthbars
with all {
	if variable_instance_exists(self.id, "objectClassification") {
		// Draw healthbar
		// If the object is a resource, or unitAction, or building, and is either 
		// in combat, being highlighted by the player, or selected, make the 
		// healthbar visible.
		if ((objectClassification == "Unit") && ((objectCurrentCommand == "Attack") || (collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) || ((objectClassification == "Building") && ((instance_exists(objectTarget)) || (collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) || ((objectClassification == "Resource") && ((collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) {
			// Set depth to be equal to the y value of the object. This makes it so that health bars stack
			// on top of all other objects that are there.
			depth = y;
			draw_healthbar(x, y - 5, x + 16, y - 2, (currentHP / maxHP) * 100, c_black, c_red, c_lime, 0, true, true);
			depth = -y;
		}
	}
}
#endregion



