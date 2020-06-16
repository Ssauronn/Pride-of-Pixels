// Self evident
//window_set_fullscreen(true);


depth = -y;


// Escaping the Game
if keyboard_check(vk_escape) {
	game_end();
}

// Camera Movement Controlling
if keyboard_check(ord("A")) {
	x -= cameraMovementSpeed;
}
if keyboard_check(ord("D")) {
	x += cameraMovementSpeed;
}
if keyboard_check(ord("W")) {
	y -= cameraMovementSpeed;
}
if keyboard_check(ord("S")) {
	y += cameraMovementSpeed;
}
x = clamp(x, 0 + (view_get_wport(view_camera[0]) / 2), room_width - (view_get_wport(view_camera[0]) / 2));
y = clamp(y, 0 + (view_get_hport(view_camera[0]) / 2), room_height - (view_get_hport(view_camera[0]) / 2));

// Moving Camera with Mouse
mouseClampedX = clamp(mouse_x, camera_get_view_x(view_camera[0]), camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]));
mouseClampedY = clamp(mouse_y, camera_get_view_y(view_camera[0]), camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]));
if (mouseClampedX - camera_get_view_x(view_camera[0])) <= mouseBufferDistanceToEdgeOfScreen {
	if !keyboard_check(ord("A")) {
		x -= cameraMovementSpeed;
	}
}
else if (camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) - mouseClampedX) <= mouseBufferDistanceToEdgeOfScreen {
	if !keyboard_check(ord("D")) {
		x += cameraMovementSpeed;
	}
}
if (mouseClampedY - camera_get_view_y(view_camera[0])) <= mouseBufferDistanceToEdgeOfScreen {
	if !keyboard_check(ord("W")) {
		y -= cameraMovementSpeed;
	}
}
else if (camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) - mouseClampedY) <= mouseBufferDistanceToEdgeOfScreen {
	if !keyboard_check(ord("S")) {
		y += cameraMovementSpeed;
	}
}


// Setting the coordinates used to draw a selection box if the player holds the mouse button down.
if mouse_check_button_pressed(mb_left) {
	mbLeftPressedXCoordinate = floor(mouse_x / 16) * 16;
	mbLeftPressedYCoordinate = floor(mouse_y / 16) * 16;
	
}
// If the button is continuously held down in the original spot it was pressed,
// don't play the hover icon animation. However, if the mouse moves from the original spot
// it was pressed, then don't run this code and the animation can begin agian.
if mouse_check_button(mb_left) && ((floor(mouse_x / 16) * 16) == mbLeftPressedXCoordinate) && ((floor(mouse_y / 16) * 16) == mbLeftPressedYCoordinate) {
	mouseHoverIconFrame = 0;
	mouseHoverIconFrameCountdown = mouseHoverIconFrameCountdownStart;
}

if mouseHoverIconFrameCountdown >= 0 {
	mouseHoverIconFrameCountdown--;
}
else {
	mouseHoverIconFrameCountdown = mouseHoverIconFrameCountdownStart;
	mouseHoverIconFrame = !mouseHoverIconFrame;
}

// Selecting units
// Reset the currently selected objects
if mouse_check_button_pressed(mb_left) {
	clear_selections(obj_tree_resource, obj_food_resource, obj_gold_resource, obj_ruby_resource, obj_worker);
	obj_camera_and_gui.numberOfObjectsSelected = 0;
	selectedUnitsDefaultDirectionToFace = -1;
}

// Select new objects
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
		//draw_sprite_ext(spr_mouse_drag_horizontal_line, 0, mbLeftPressedXCoordinate + displacement_for_negative_values_in_drawing_x_, top_line_location_ - 3, amount_of_boxes_displaced_on_x_axis_, 1, 0, c_white, 0.5);
		//draw_sprite_ext(spr_mouse_drag_horizontal_line, 0, mbLeftPressedXCoordinate + displacement_for_negative_values_in_drawing_x_, bottom_line_location_ + 3, amount_of_boxes_displaced_on_x_axis_, 1, 0, c_white, 0.5);
		//draw_sprite_ext(spr_mouse_drag_vertical_line, 0, left_line_location_ - 3, mbLeftPressedYCoordinate + displacement_for_negative_values_in_drawing_y_, 1, amount_of_boxes_displaced_on_y_axis_, 0, c_white, 0.5);
		//draw_sprite_ext(spr_mouse_drag_vertical_line, 0, right_line_location_ + 3, mbLeftPressedYCoordinate + displacement_for_negative_values_in_drawing_y_, 1, amount_of_boxes_displaced_on_y_axis_, 0, c_white, 0.5);
		var unit_selected_, resource_selected_,
		unit_selected_ = false;
		resource_selected_ = false;
		with obj_worker {
			if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
				unit_selected_ = true;
				if !objectSelected {
					objectSelected = true;
					obj_camera_and_gui.numberOfObjectsSelected++;
				}
			}
			else {
				if objectSelected {
					objectSelected = false;
					obj_camera_and_gui.numberOfObjectsSelected--;
				}
			}
		}
		if !unit_selected_ {
			with obj_tree_resource {
				if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
					if !objectSelected {
						resource_selected_ = true;
						objectSelected = true;
						obj_camera_and_gui.numberOfObjectsSelected++;
					}
				}
			}
			with obj_food_resource {
				if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
					if !objectSelected {
						resource_selected_ = true;
						objectSelected = true;
						obj_camera_and_gui.numberOfObjectsSelected++;
					}
				}
			}
			with obj_gold_resource {
				if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
					if !objectSelected {
						resource_selected_ = true;
						objectSelected = true;
						obj_camera_and_gui.numberOfObjectsSelected++;
					}
				}
			}
			with obj_ruby_resource {
				if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
					if !objectSelected {
						resource_selected_ = true;
						objectSelected = true;
						obj_camera_and_gui.numberOfObjectsSelected++;
					}
				}
			}
		}
		else {
			clear_selections(obj_tree_resource, obj_food_resource, obj_gold_resource, obj_ruby_resource);
		}
	}
	// If the player is currently only clicking on one single object to select it
	else {
		var unit_selected_, resource_selected_, left_line_location_, top_line_location_, right_line_location_, bottom_line_location_,
		unit_selected_ = false;
		resource_selected_ = false;
		left_line_location_ = floor(mouse_x / 16) * 16;
		top_line_location_ = floor(mouse_y / 16) * 16;
		right_line_location_ = (floor(mouse_x / 16) * 16) + 15;
		bottom_line_location_ = (floor(mouse_y / 16) * 16) + 15;
		with obj_worker {
			if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
				if !objectSelected {
					unit_selected_ = true;
					objectSelected = true;
					obj_camera_and_gui.numberOfObjectsSelected++;
				}
			}
			else {
				if objectSelected {
					objectSelected = false;
					obj_camera_and_gui.numberOfObjectsSelected--;
				}
			}
		}
		if !unit_selected_ {
			with obj_tree_resource {
				if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
					if !objectSelected {
						resource_selected_ = true;
						objectSelected = true;
						obj_camera_and_gui.numberOfObjectsSelected++;
					}
				}
			}
			with obj_food_resource {
				if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
					if !objectSelected {
						resource_selected_ = true;
						objectSelected = true;
						obj_camera_and_gui.numberOfObjectsSelected++;
					}
				}
			}
			with obj_gold_resource {
				if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
					if !objectSelected {
						resource_selected_ = true;
						objectSelected = true;
						obj_camera_and_gui.numberOfObjectsSelected++;
					}
				}
			}
			with obj_ruby_resource {
				if point_in_rectangle(x, y, left_line_location_ - 2, top_line_location_ - 2, right_line_location_, bottom_line_location_) {
					if !objectSelected {
						resource_selected_ = true;
						objectSelected = true;
						obj_camera_and_gui.numberOfObjectsSelected++;
					}
				}
			}
		}
	}
}

// Reset original mouse clicked coordinates if the mouse isn't held down
if !mouse_check_button(mb_left) {
	mbLeftPressedXCoordinate = -1;
	mbLeftPressedYCoordinate = -1;
}


