if --spawnUnit <= 0 {
	spawnUnit = room_speed * 4;
	spawn_unit("Worker", player[1].team);
}

if !initialized {
	initialized = true;
	initialize_object_data();
}
// Depth setting
depth = y;

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

// If the mouse is on the map and not on the toolbar, then allow clicks
if ((device_mouse_y_to_gui(0) <= obj_gui.toolbarTopY) || ((device_mouse_x_to_gui(0) <= obj_gui.toolbarLeftX) || (device_mouse_x_to_gui(0) >= obj_gui.toolbarRightX))) {
	if mouse_check_button_pressed(mb_right) && (objectSelected) {
		var object_at_location_ = instance_place((floor(mouse_x / 16) * 16), (floor(mouse_y / 16) * 16), all);
		if instance_exists(object_at_location_) {
			var object_mid_x_ = (floor(object_at_location_.x / 16) * 16) + 8;
			var object_mid_y_ = (floor(object_at_location_.y / 16) * 16) + 8;
			// If the object clicked on is a resource, just set that resource as a rally point.
			if object_at_location_.objectClassification == "Resource" {
				// Set rally point.
				set_rally(object_mid_x_, object_mid_y_);
			}
			// If the object clicked on is not a resource, is not on the building's team, and the building
			// is a type of building that can attack, attack the object. Otherwise, again, just set the
			// rally point as normal.
			else if object_at_location_.objectVisibleTeam != objectRealTeam {
				// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
				if (objectType == "City Hall") || (objectType == "Tower") || (objectType == "Outpost") {
					if distance_to_object(object_at_location_) <= objectCombatAggroRange {
						objectTarget = object_at_location_.id;
					}
					else {
						// Set rally point.
						set_rally(object_mid_x_, object_mid_y_);
					}
				}
				else {
					// Set rally point.
					set_rally(object_mid_x_, object_mid_y_);
				}
			}
			else {
				// Set rally point.
				set_rally(object_mid_x_, object_mid_y_);
			}
		}
		else {
			// Set rally point.
			set_rally((floor(mouse_x / 16) * 16) + 8, (floor(mouse_y / 16) * 16) + 8);
		}
	}
}

// Detect nearest valid targets and attack, if necessary
if objectDetectTarget <= 0 {
	objectDetectTarget = room_speed;
	if !instance_exists(objectTarget) {
		detect_nearby_enemy_objects();
		if ds_exists(objectDetectedList, ds_type_list) {
			var instance_nearby_ = ds_list_find_value(objectDetectedList, 0);
			objectTarget = instance_nearby_.id;
			ds_list_destroy(objectDetectedList);
			objectDetectedList = noone;
		}
	}
}

// Count down various timers
count_down_timers();

// Attack nearby target, if possible
if canAttack {
	if instance_exists(objectTarget) {
		if distance_to_object(objectTarget) <= objectCombatAggroRange * 16 {
			if objectAttackSpeedTimer <= 0 {
				objectAttackSpeedTimer = objectAttackSpeed;
				deal_damage(objectAttackDamage, objectAttackDamageType, objectTarget);
			}
		}
		else {
			objectTarget = noone;
		}
	}
	else {
		objectTarget = noone;
	}
}

// Destroy self and remove self from all necessary ds_lists if HP goes to 0
if currentHP <= 0 {
	kill_self();
}


