if !initialized {
	initialized = true;
	initialize_object_data();
}
// Depth setting
depth = y;

// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, view_get_xport(view_camera[0]), view_get_yport(view_camera[0]), view_get_xport(view_camera[0]) + view_get_wport(view_camera[0]), view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) {
	objectOnScreen = true;
}
else {
	objectOnScreen = false;
}

// If the mouse is on the map and not on the toolbar, then allow clicks
if device_mouse_y_to_gui(0) <= (view_get_hport(view_camera[0]) - obj_camera_inputs_and_gui.toolbarHeight) {
	if mouse_check_button_pressed(mb_right) && (objectSelected) {
		// Set rally point.
		rallyPointX = (floor(mouse_x / 16) * 16) + 8;
		rallyPointY = (floor(mouse_y / 16) * 16) + 8;
	}
}

// Detect nearest valid targets and attack, if necessary
if objectDetectTarget <= 0 {
	objectDetectTarget = room_speed;
	if !instance_exists(objectTarget) {
		detect_nearby_enemy_objects();
		if ds_exists(objectDetectedList, ds_type_list) {
			var i, iteration_;
			iteration_ = irandom_range(0, ds_list_size(objectDetectedList) - 1);
			for (i = 0; i < ds_list_size(objectDetectedList); i++) {
				// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
				// In this case specifically, worker units will not aggro to nearby enemy units unless they're in active
				// combat. With more militiant type units, this will change.
				var instance_nearby_ = ds_list_find_value(objectDetectedList, iteration_);
				if objectCurrentCommand != "Attack" {
					objectTarget = instance_nearby_.id;
					ds_list_destroy(objectDetectedList);
					objectDetectedList = noone;
					break;
				}
				iteration_++;
				if iteration_ >= ds_list_size(objectDetectedList) - 1 {
					iteration_ = 0;
				}
			}
		}
	}
}

// Count down various timers
count_down_timers();

// Destroy self and remove self from all necessary ds_lists if HP goes to 0
if currentHP <= 0 {
	kill_self();
}


