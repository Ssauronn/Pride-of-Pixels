if --spawnUnit <= 0 {
	spawnUnit = room_speed * 4;
	//building_spawn_unit("Worker", player[1].team);
}

if !initialized {
	initialized = true;
	initialize_object_data();
	add_self_to_storehouse_city_hall_list();
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

if !obj_gui.startMenu.active {
	// Move the building animation forward
	currentImageIndex += currentImageIndexSpeed;
	if currentImageIndex > (sprite_get_number(sprite_index) - 1) {
		currentImageIndex = 0;
	}
	sprite_index = currentSprite;
	image_index = currentImageIndex;
	
	// If the mouse is on the map and not on the toolbar, then allow clicks
	if ((device_mouse_y_to_gui(0) <= obj_gui.toolbarTopY) || ((device_mouse_x_to_gui(0) <= obj_gui.toolbarLeftX) || (device_mouse_x_to_gui(0) >= obj_gui.toolbarRightX))) {
		if mouse_check_button_pressed(mb_right) && (objectSelected) {
			if keyboard_check(vk_control) {
				forceAttack = true;
			}
			var object_at_location_ = instance_place((floor(mouse_x / 16) * 16), (floor(mouse_y / 16) * 16), all);
			if instance_exists(object_at_location_) {
				var object_mid_x_ = (floor(object_at_location_.x / 16) * 16) + 8;
				var object_mid_y_ = (floor(object_at_location_.y / 16) * 16) + 8;
				// If the object clicked on is a resource, just set that resource as a rally point.
				if object_at_location_.objectClassification == "Resource" {
					// Set rally point.
					set_rally(object_mid_x_, object_mid_y_);
				}
				// If the object clicked on is not a resource, is not on the building's team, and the object
				// is a building, attack. In addition, if the Force Attack button is being held, attack the
				// object regardless of team. Otherwise, just set it as a rally point.
				else if (object_at_location_.objectVisibleTeam != objectRealTeam) || (forceAttack) {
					if (canAttack) && (distance_to_object(object_at_location_) <= objectAttackRange) {
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
				set_rally((floor(mouse_x / 16) * 16) + 8, (floor(mouse_y / 16) * 16) + 8);
			}
		}
	}

	// Detect nearest valid targets and attack, if necessary
	if objectDetectTarget <= 0 {
		objectDetectTarget = room_speed;
		if !instance_exists(objectTarget) {
			forceAttack = false;
			detect_nearby_enemy_objects(x, y);
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
				forceAttack = false;
			}
		}
		else {
			objectTarget = noone;
			forceAttack = false;
		}
	}

	// Destroy self and remove self from all necessary ds_lists if HP goes to 0
	if currentHP <= 0 {
		kill_self();
	}
}

