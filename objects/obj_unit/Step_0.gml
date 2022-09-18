if !initialized {
	initialized = true;
	initialize_object_data();
}
// Depth setting
depth = -y//(y / 1000);

// Stop certain conditions from being met if the unit isn't a Worker currently working on returning
// gathered materials to a dropoff point or making its way back from the dropoff point.
if returnToResourceID != noone {
	if (objectType == "Worker") && (instance_exists(objectTarget)) {
		// If the target exists, but it's not a resource or a dropoff point
		if (objectTarget.objectClassification != "Resource") && ((objectTarget.objectClassification == "Building") && ((objectTarget.objectType != "Farm") && (objectTarget.objectType != "Thicket") && (objectTarget.objectType != "Mine") && (objectTarget.objectType != "City Hall") && (objectTarget.objectType != "Storehouse"))) {
			set_return_resource_variables_noone();
		}
		// If the Worker's current command is not to collect a material
		if (objectCurrentCommand != "Farm") && (objectCurrentCommand != "Chop") && (objectCurrentCommand != "Mine") && (objectCurrentCommand != "Ruby Mine") {
			set_return_resource_variables_noone();
		}
		// If the Worker's current state is not Idle, Move, or collecting a material
		if (currentAction != unitAction.idle) && (currentAction != unitAction.move) && (currentAction != unitAction.farm) && (currentAction != unitAction.chop) && (currentAction != unitAction.mine) {
			set_return_resource_variables_noone();
		}
	}
}

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
	///		 Set sprite index and sprite frame
	// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
	// What will need to be adjusted is actually the actions - if any actions are added besides idle, move, chop, farm, mine, and attack,
	// that will need to be added to this.
	currentImageIndex += currentImageIndexSpeed;
	if (currentAction != unitAction.idle) && (currentAction != unitAction.move) {
		var i, j, break_;
		var current_action_ = -1;
		var current_direction_facing_ = -1;
		break_ = false;
		// currentAction counting
		for (i = 0; i < unitAction.length; i++) {
			// If the current action and direction facing for the currently shown sprite is found, stop searching.
			if ((current_action_ != -1) && (current_direction_facing_ != -1)) || break_ {
				break;
			}
			else {
				// currentDirection counting
				for (j = 0; j < unitDirection.length; j++) {
					if break_ {
						break;
					}
					// If the correct action and direction are found, either for normal units, or
					// for Abomination units just using the head sprite as verification, record that
					// action and direction.
					if ((objectType != "Abomination") && (currentSprite == unitSprite[i][j])) || ((objectType == "Abomination") && (currentHeadSprite == unitSprite[headBodyPart][i][j])) {
						current_action_ = i;
						current_direction_facing_ = j;
						break_ = true;
					}
				}
			}
		}
		if (current_action_ != -1) && (current_direction_facing_ != -1) {
			if current_direction_facing_ != currentDirection {
				if objectType != "Abomination" {
					currentSprite = unitSprite[current_action_][currentDirection];
				}
				else {
					currentHeadSprite = unitSprite[headBodyPart][current_action_][currentDirection];
					currentChestSprite = unitSprite[chestBodyPart][current_action_][currentDirection];
					currentLegsSprite = unitSprite[legsBodyPart][current_action_][currentDirection];
				}
			}
		}
	}

	///		Set sprite index and sprite frame. All this code is here to allow for wait periods between animations to match up with their
	///		action speeds.
	// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
	// What will need to be adjusted is actually the actions - if any actions are added besides idle, move, chop, farm, mine, and attack,
	// that will need to be added to this.
	if currentImageIndex > (sprite_get_number(sprite_index) - 1) {
		currentImageIndex = 0;
		/// Apply a wait time to different animations, so that the animation lines up with the action taken on the other object.
		// If the object's current action is simply to idle or move, just set the sprite normally.
		if (currentAction == unitAction.idle) || (currentAction == unitAction.move) {
			if objectType != "Abomination" {
				currentSprite = unitSprite[currentAction][currentDirection];
			}
			else {
				currentHeadSprite = unitSprite[headBodyPart][currentAction][currentDirection];
				currentChestSprite = unitSprite[chestBodyPart][currentAction][currentDirection];
				currentLegsSprite = unitSprite[legsBodyPart][currentAction][currentDirection];
			}
		}
		// However, if the object's current action is to mine, chop, farm, or attack, check to see if its currently idling.
		// Just to reiterate, I check for either regular sprites, or the head sprite of Abominations
		else if ((currentSprite == unitSprite[unitAction.idle][currentDirection]) || (currentSprite == unitSprite[unitAction.move][currentDirection])) || ((objectType == "Abomination") && ((currentHeadSprite == unitSprite[headBodyPart][unitAction.idle][currentDirection]) || (currentHeadSprite == unitSprite[headBodyPart][unitAction.move][currentDirection]))) {
			if (currentAction == unitAction.mine) || (currentAction == unitAction.chop) || (currentAction == unitAction.farm) || (currentAction == unitAction.attack) {
				// If the object is still commanded to mine, chop, farm, or attack, and the idle time is over, start the action animation.
				if spriteWaitTimer <= 0 {
					if objectType != "Abomination" {
						currentSprite = unitSprite[currentAction][currentDirection];
					}
					else {
						currentHeadSprite = unitSprite[headBodyPart][currentAction][currentDirection];
						currentBodySprite = unitSprite[bodyBodyPart][currentAction][currentDirection];
						currentLegsSprite = unitSprite[legsBodyPart][currentAction][currentDirection];
					}
				}
			}
			// Redundant to prevent errors.
			else {
				if objectType != "Abomination" {
					currentSprite = unitSprite[currentAction][currentDirection];
				}
				else {
					currentHeadSprite = unitSprite[headBodyPart][currentAction][currentDirection];
					currentBodySprite = unitSprite[bodyBodyPart][currentAction][currentDirection];
					currentLegsSprite = unitSprite[legsBodyPart][currentAction][currentDirection];
				}
			}
		}
		// Else if the object's action is to mine, chop, farm, or attack, and it is not currently idling, and obviously the animation
		// for the action has ended because of the very first check at the beginning of this whole section, then set the SPRITE (not
		// action, just sprite) to idling and wait until its time to act again - that's set to 3 frames before the action is set to
		// activate, because I want the animation to happen slightly before the action itself occurs, to more accurately line up the
		// middle of the animation with the action itself.
		// Don't have to worry about checking if the unit is an Abomination here or not because
		// only Workers can chop/farm/mine.
		else if currentSprite == unitSprite[currentAction][currentDirection] {
			if (currentAction != unitAction.idle) && (currentAction != unitAction.move) {
				switch currentAction {
					case unitAction.mine:
						if instance_exists(objectTarget) {
							if objectTarget.objectType == "Ruby" {
								spriteWaitTimer = objectRubyMineSpeedTimer - (3 * (1 / currentImageIndexSpeed));
							}
							else if (objectTarget.objectType == "Gold") || (objectTarget.objectType == "Mine") {
								spriteWaitTimer = objectGoldMineSpeedTimer - (3 * (1 / currentImageIndexSpeed));
							}
						}
						break;
					case unitAction.chop:
						spriteWaitTimer = objectWoodChopSpeedTimer - (3 * (1 / currentImageIndexSpeed));
						break;
					case unitAction.farm:
						spriteWaitTimer = objectFoodGatherSpeedTimer - (3 * (1 / currentImageIndexSpeed));
						break;
					case unitAction.attack:
						spriteWaitTimer = objectAttackSpeedTimer - (3 * (1 / currentImageIndexSpeed));
						break;
				}
			}
			// Don't have to worry about checking if the unit is an Abomination here or not because
			// only Workers can chop/farm/mine.
			currentSprite = unitSprite[unitAction.idle][currentDirection]
		}
	}
	if objectType != "Abomination" {	
		sprite_index = currentSprite;
	}
	else {
		sprite_index = currentHeadSprite;
	}
	image_index = currentImageIndex;


	// Check for if the object was very recently in combat, and if so, detect for other potential combat targets.
	// If any exist, set those as the target.
	if objectCurrentCommand == "Attack" {
		if (!ds_exists(objectTargetList, ds_type_list)) && (!instance_exists(objectTarget)) {
			forceAttack = false;
			check_for_new_target(x, y);
		}
	}
	
	
	var target_list_ = noone;
	// If the mouse is on the map and not on the toolbar, then allow clicks. Or if the unit is being autonomously commanded to move, move it.
	if (mouse_check_button_pressed(mb_right) && (objectSelected) && ((device_mouse_y_to_gui(0) <= obj_gui.toolbarTopY) || ((device_mouse_x_to_gui(0) <= obj_gui.toolbarLeftX) || (device_mouse_x_to_gui(0) >= obj_gui.toolbarRightX)))) || objectNeedsToMove {
		// Firstly, if the object was automatically instructed to move, check for what object is at its target location and if the
		// found object is not an object its commanded to attack or mine, change the object it should be attacking or mining
		// to something valid.
		if (keyboard_check(vk_control)) && (objectSelected) {
			forceAttack = true;
		}
		if objectNeedsToMove {
			// Get the ID of every single object currently at the click location, and depending on what the object
			// was commanded to do previously, determine which object currently at the click location should be the
			// target of the click.
			var object_at_location_, list_of_objects_, number_of_objects_, target_found_;
			target_found_ = false;
			list_of_objects_ = ds_list_create();
			number_of_objects_ = instance_place_list((targetToMoveToX / 16) * 16, floor(targetToMoveToY / 16) * 16, all, list_of_objects_, true);
			if number_of_objects_ > 1 {
				var n;
				for (n = 0; n < ds_list_size(list_of_objects_); n++) {
					var temp_instance_to_reference_ = ds_list_find_value(list_of_objects_, n);
					if objectCurrentCommand == "Attack" {
						if (temp_instance_to_reference_.objectClassification == "Unit") || (temp_instance_to_reference_.objectClassification == "Building") {
							object_at_location_ = temp_instance_to_reference_;
							target_found_ = true;
						}
					}
					else if (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Chop") || (objectCurrentCommand == "Ruby Mine") || (objectCurrentCommand == "Farm") {
						// Allow Workers to move if their target location is either a resource,
						// Storehouse, or City Hall
						if (temp_instance_to_reference_.objectClassification == "Resource") || (temp_instance_to_reference_.objectType == "Storehouse") || (temp_instance_to_reference_.objectType == "City Hall") {
							object_at_location_ = temp_instance_to_reference_;
							target_found_ = true;
						}
					}
					else if (objectCurrentCommand == "Idle") || (objectCurrentCommand == "Move") {
						object_at_location_ = temp_instance_to_reference_;
						target_found_ = true;
					}
					// If the whole list of objects at the target location have been evaluated and none match the given commands,
					// just set the object_at_location_ to noone. I have code in place later to handle that event correctly, no need
					// to write it twice.
					if n == (ds_list_size(list_of_objects_) - 1) {
						object_at_location_ = noone;
						target_found_ = true;
					}
					if target_found_ {
						break;
					}
				}
			}
			else {
				if number_of_objects_ == 1 {
					object_at_location_ = ds_list_find_value(list_of_objects_, 0);
				}
				else {
					object_at_location_ = noone;
				}
			}
			// Clean up that ds_list to prevent memory leaks
			if ds_exists(list_of_objects_, ds_type_list) {
				ds_list_destroy(list_of_objects_);
				list_of_objects_ = noone;
			}
			list_of_objects_ = noone;
			// Check for what is at the current location and if the current object doesn't match the type its looking for,
			// look for the correct type. This won't really activate if a manual click happens, so there's no risk of a
			// user input being overridden.
			var temp_object_at_location_ = noone;
			if instance_exists(object_at_location_) {
				// If the object_at_location_ is not a resource to mine, and not a building that 
				// can be mined like a Farm, Thicket, or Mine
				if ((objectCurrentCommand == "Chop") || (objectCurrentCommand == "Farm") || (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Ruby Mine")) && ((object_at_location_.objectClassification != "Resource") && ((object_at_location_.objectClassification == "Building") && (object_at_location_.objectType != "Storehouse") && (object_at_location_.objectType != "City Hall") && (object_at_location_.objectType != "Farm") && (object_at_location_.objectType != "Thicket") && (object_at_location_.objectType != "Mine"))) {
					if objectCurrentCommand == "Chop" {
						if !instance_exists(object_at_location_) || ((object_at_location_.object_index != obj_tree_resource) && (object_at_location_.objectType != "Thicket")) {
							temp_object_at_location_ = instance_nearest(targetToMoveToX, targetToMoveToY, obj_tree_resource);
							if instance_exists(temp_object_at_location_) {
								if point_distance(x, y, temp_object_at_location_.x, temp_object_at_location_.y) <= (10 * 16) {
									object_at_location_ = temp_object_at_location_;
								}
								else {
									object_at_location_ = noone;
								}
							}
						}
					}
					else if objectCurrentCommand == "Farm" {
						if !instance_exists(object_at_location_) || ((object_at_location_.object_index != obj_food_resource) && (object_at_location_.objectType != "Farm")) {
							temp_object_at_location_ = instance_nearest(targetToMoveToX, targetToMoveToY, obj_food_resource);
							if instance_exists(temp_object_at_location_) {
								if point_distance(x, y, temp_object_at_location_.x, temp_object_at_location_.y) <= (10 * 16) {
									object_at_location_ = temp_object_at_location_;
								}
								else {
									object_at_location_ = noone;
								}
							}
						}
					}
					else if objectCurrentCommand == "Mine" {
						if !instance_exists(object_at_location_) || ((object_at_location_.object_index != obj_gold_resource) && (object_at_location_.objectType != "Mine")) {
							temp_object_at_location_ = instance_nearest(targetToMoveToX, targetToMoveToY, obj_gold_resource);
							if instance_exists(temp_object_at_location_) {
								if point_distance(x, y, temp_object_at_location_.x, temp_object_at_location_.y) <= (10 * 16) {
									object_at_location_ = temp_object_at_location_;
								}
								else {
									object_at_location_ = noone;
								}
							}
						}
					}
					else if objectCurrentCommand == "Ruby Mine" {
						if !instance_exists(object_at_location_) || object_at_location_.object_index != obj_ruby_resource {
							temp_object_at_location_ = instance_nearest(targetToMoveToX, targetToMoveToY, obj_ruby_resource);
							if instance_exists(temp_object_at_location_) {
								if point_distance(x, y, temp_object_at_location_.x, temp_object_at_location_.y) <= (10 * 16) {
									object_at_location_ = temp_object_at_location_;
								}
								else {
									object_at_location_ = noone;
								}
							}
						}
					}
					// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
					// In this instance, I'll need to add same paragraphs as above, except specific to units and/or buildings
				
				}
			}
		}
		// If the object wasn't automatically instructed to move, that means the right mouse button was clicked, and if
		// the object selected is part of the player team, it can move.
		else if objectRealTeam == player[1].team {
			var object_at_location_ = instance_place(floor(mouse_x / 16) * 16, floor(mouse_y / 16) * 16, all);
		}
		// Else if the object wasn't automatically instructed to move, it shouldn't move even if the right mouse button
		// was clicked.
		else {
			var object_at_location_ = noone;
		}
		// If objects selected are commanded onto a space occupied by a different object, get that
		// object's type, create a ds_list including that and all other objects of the same type for
		// use later, and send to movement script.
		if object_at_location_ != noone {
			if objectRealTeam == player[1].team {
				// Set the selected group's direction to search for in the targeting script
				if ds_exists(objectsSelectedList, ds_type_list) {
					var i, number_of_selected_targeting_right_, number_of_selected_targeting_up_, number_of_selected_targeting_left_, number_of_selected_targeting_down_;
					number_of_selected_targeting_right_ = 0;
					number_of_selected_targeting_up_ = 0;
					number_of_selected_targeting_left_ = 0;
					number_of_selected_targeting_down_ = 0;
					for (i = 0; i < ds_list_size(objectsSelectedList); i++) {
						with ds_list_find_value(objectsSelectedList, i) {
							if objectRealTeam == player[1].team {
								// Create a list of all instances of the same type and team of the original
								// object that was clicked on. I COULD do this outside of the for i loop, which
								// would run this instead only once for all selected targets and really speed
								// things up, but it would mean the direction of the search is static and objects
								// would often take long routes to out-of-the-way objects just to attack or mine.
								// Placing this inside the for i loop, while slowing things down nominally, will
								// lead to more fluid combat and movement.
								var j, k, instance_to_reference_, target_list_, x_start_, y_start_, x_sign_, y_sign_, adjusted_click_direction_, click_direction_;
								target_list_ = noone;
								// Set click_direction_ to equal a number 0-3 inclusive based on the point direction 
								// from the original object location to the click location, and then set x_sign_ and
								// y_sign_, which determine the direction of the search, depending on that direction.
								adjusted_click_direction_ = point_direction(x, y, obj_inputs.mouseClampedX, obj_inputs.mouseClampedY) + 45;
								if adjusted_click_direction_ >= 360 {
									adjusted_click_direction_ -= 360;
								}
								click_direction_ = floor(adjusted_click_direction_ / 90);
								switch click_direction_ {
									case 0:
										x_sign_ = 1;
										y_sign_ = -1;
										number_of_selected_targeting_right_++;
										break;
									case 1:
										x_sign_ = -1;
										y_sign_ = -1;
										number_of_selected_targeting_up_++;
										break;
									case 2:
										x_sign_ = -1;
										y_sign_ = 1;
										number_of_selected_targeting_left_++;
										break;
									case 3:
										x_sign_ = 1;
										y_sign_ = 1;
										number_of_selected_targeting_down_++;
										break;
								}
							}
						}
					}
					// After going through each selected object, set the group's targeting direction
					// based on the group's largest existing direction facing.
					var max_ = max(number_of_selected_targeting_right_, number_of_selected_targeting_up_, number_of_selected_targeting_left_, number_of_selected_targeting_down_);
					if number_of_selected_targeting_right_ == max_ {
						selectedUnitsDefaultDirectionToFace = 0;
					}
					else if number_of_selected_targeting_up_ == max_ {
						selectedUnitsDefaultDirectionToFace = 1;
					}
					else if number_of_selected_targeting_left_ == max_ {
						selectedUnitsDefaultDirectionToFace = 2;
					}
					else if number_of_selected_targeting_down_ == max_ {
						selectedUnitsDefaultDirectionToFace = 3;
					}
					var i;
					for (i = 0; i < ds_list_size(objectsSelectedList); i++) {
						with ds_list_find_value(objectsSelectedList, i) {
							groupDirectionToMoveIn = selectedUnitsDefaultDirectionToFace;
							groupDirectionToMoveInAdjusted = 0;
						}
					}
				}
				else {
					groupDirectionToMoveIn = floor(point_direction(x, y, targetToMoveToX, targetToMoveToY) / 90);
				}
			}
			if ((ds_exists(objectsSelectedList, ds_type_list)) && (ds_list_find_index(objectsSelectedList, id) != -1)) || objectNeedsToMove {
				// If the object is not selected, but still needs to move, set the variables needed later
				// based solely on its target position.
				if (!ds_exists(objectsSelectedList, ds_type_list)) && objectNeedsToMove {
					var i, number_of_selected_targeting_right_, number_of_selected_targeting_up_, number_of_selected_targeting_left_, number_of_selected_targeting_down_;
					number_of_selected_targeting_right_ = 0;
					number_of_selected_targeting_up_ = 0;
					number_of_selected_targeting_left_ = 0;
					number_of_selected_targeting_down_ = 0;
					// Create a list of all instances of the same type and team of the original
					// object that was clicked on. I COULD do this outside of the for i loop, which
					// would run this instead only once for all selected targets and really speed
					// things up, but it would mean the direction of the search is static and objects
					// would often take long routes to out-of-the-way objects just to attack or mine.
					// Placing this inside the for i loop, while slowing things down nominally, will
					// lead to more fluid combat and movement.
					var j, k, instance_to_reference_, target_list_, x_start_, y_start_, x_sign_, y_sign_, adjusted_click_direction_, click_direction_;
					// I know this is redundant. Code acts all weird if I remove it. Whatever, I'll clean it up if it becomes a problem.
					target_list_ = noone;
					// Set click_direction_ to equal a number 0-3 inclusive based on the point direction 
					// from the original object location to the click location, and then set x_sign_ and
					// y_sign_, which determine the direction of the search, depending on that direction.
					adjusted_click_direction_ = point_direction(x, y, targetToMoveToX, targetToMoveToY) + 45;
					if adjusted_click_direction_ >= 360 {
						adjusted_click_direction_ -= 360;
					}
					click_direction_ = floor(adjusted_click_direction_ / 90);
					switch click_direction_ {
						case 0:
							x_sign_ = 1;
							y_sign_ = -1;
							number_of_selected_targeting_right_++;
							break;
						case 1:
							x_sign_ = -1;
							y_sign_ = -1;
							number_of_selected_targeting_up_++;
							break;
						case 2:
							x_sign_ = -1;
							y_sign_ = 1;
							number_of_selected_targeting_left_++;
							break;
						case 3:
							x_sign_ = 1;
							y_sign_ = 1;
							number_of_selected_targeting_down_++;
							break;
					}
				}
				// Reset objectTarget so that it can be properly set in the movement script.
				if !forceAttack {
					objectTarget = noone;
					objectTargetType = noone;
					objectTargetTeam = noone;
					forceAttack = false;
				}
			
				// Find all other valid targets within range, and add them to the objectTargetList.
				var square_iteration_, square_iteration_random_start_number_, square_true_iteration_, square_size_increase_count_, square_size_increase_count_max_, base_square_edge_size_, search_increment_size_, temp_check_x_, temp_check_y_, target_x_, target_y_;
				square_size_increase_count_ = 0;
				square_iteration_random_start_number_ = 0;
				square_iteration_ = 0;
				square_true_iteration_ = 0;
				search_increment_size_ = 16;
				if (!objectNeedsToMove) && ((ds_exists(objectsSelectedList, ds_type_list)) && (ds_list_find_index(objectsSelectedList, id) != -1)) {
					target_x_ = floor(obj_inputs.mouseClampedX / 16) * 16;
					target_y_ = floor(obj_inputs.mouseClampedY / 16) * 16;
				}
				else if objectNeedsToMove {
					target_x_ = targetToMoveToX;
					target_y_ = targetToMoveToY;
				}
			
				// Set the size of the square that the AI will search for targets inside.
				if objectType == "Worker" {
					square_size_increase_count_max_ = 10;
				}
				else if objectClassification == "Building" {
					square_size_increase_count_max_ = 15;
				}
				/*
				ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
				else if objectType == "Any other type" {
					square_size_increase_count_max_ = whatever is an adequate range to search for in a square around the unitAction
				}
				*/
		
				// The size of one side of the square to search is double what the check is below
				while square_size_increase_count_ < square_size_increase_count_max_ {
					// If, after checking for a specific location, it still wasn't valid,
					// move on and continue the search.
					base_square_edge_size_ = (square_size_increase_count_ * 2) + 1;
					// If the randomized iteration start point is greater than the total segments in the perimeter,
					// but the true iteration count is still less than, and I don't yet need to move to searching 
					// in a new perimeter, then just reset iteration.
					if square_true_iteration_ < (base_square_edge_size_ * 4) {
						if square_iteration_ == (base_square_edge_size_ * 4) {
							square_iteration_ = 0;
						}
						else if square_iteration_ > (base_square_edge_size_ * 4) {
							square_iteration_ = 1;
						}
					}
					// Top edge, moving left to right
					if square_iteration_ < base_square_edge_size_ {
						// Start at the left corner and move right
						temp_check_x_ = target_x_ - (square_size_increase_count_ * search_increment_size_) + (square_iteration_ * search_increment_size_);
						// Shift the temporary check upwards to the top edge
						temp_check_y_ = target_y_ - (square_size_increase_count_ * search_increment_size_);
					}
					// Right edge, moving top to bottom
					else if square_iteration_ < base_square_edge_size_ * 2 {
						// Shift the temporary check rightwards to the right edge
						temp_check_x_ = target_x_ + (square_size_increase_count_ * search_increment_size_);
						// Start at the top right corner and move down. Subtracted the size
						// of one side from the coordinates, since I've already iterated through
						// a side.
						temp_check_y_ = target_y_ - (square_size_increase_count_ * search_increment_size_) + (square_iteration_ * search_increment_size_) - (((square_size_increase_count_ * 2) + 1) * search_increment_size_);
					}
					// Bottom edge, moving right to left
					else if square_iteration_ < base_square_edge_size_ * 3 {
						// Start at the bottom right corner, and move left. How it works:
						// Start at origin point target_x_. Shift over to the right
						// edge. Move left by subtracting square_iteration_ * search_increment_size_. Adjust for
						// the previous two sides that have already been run through by
						// adding the equivalent pixel size of two sides to the coordinates.
						temp_check_x_ = target_x_ + (square_size_increase_count_ * search_increment_size_) - (square_iteration_ * search_increment_size_) + ((((square_size_increase_count_ * 2) + 1) * search_increment_size_) * 2);
						// Shift the temporary check downwards to the bottom edge
						temp_check_y_ = target_y_ + (square_size_increase_count_ * search_increment_size_);
					}
					// Left edge, moving bottom to top
					else if square_iteration_ < base_square_edge_size_ * 4 {
						// Shift the temporary check leftwards to the left edge
						temp_check_x_ = target_x_ - (square_size_increase_count_ * search_increment_size_);
						// Start at the bottom left corner and move up. Works in the same
						// way the check in the else if statement above works with the x axis.
						temp_check_y_ = target_y_ + (square_size_increase_count_ * search_increment_size_) - (square_iteration_ * search_increment_size_) + ((((square_size_increase_count_ * 2) + 1) * search_increment_size_) * 3);
					}
		
					// Iterate the count that moves along the edges up by one
					square_iteration_++;
					square_true_iteration_++;
					// If the iteration count reaches the max amount of squares on the perimeter
					// of the search square, reset the iteration count, increment the size increase
					// count by one, and set base_square_edge_size_ to equal the correct values based off
					// of the new square_size_increase_count_ value.
					if square_true_iteration_ >= (((square_size_increase_count_ * 2) + 1) * 4) {
						square_size_increase_count_++;
						base_square_edge_size_ = (square_size_increase_count_ * 2) + 1;
						square_iteration_random_start_number_ = irandom_range(0, (base_square_edge_size_ * 4));
						square_iteration_ = square_iteration_random_start_number_;
						square_true_iteration_ = 0;
					}
					// If the iteration is divisible by the size of an edge, meaning its at a corner,
					// skip the corner. The previous frame will have already searched that corner -
					// this skips redundant checks.
					if square_iteration_ mod ((square_size_increase_count_ * 2) + 1) == 0 {
						square_iteration_++;
						square_true_iteration_++;
					}
					// If the iteration count reaches the max amount of squares on the perimeter
					// of the search square, reset the iteration count, increment the size increase
					// count by one, and set base_square_edge_size_ to equal the correct values based off
					// of the new square_size_increase_count_ value.
					if square_true_iteration_ == (((square_size_increase_count_ * 2) + 1) * 4) {
						square_size_increase_count_++;
						base_square_edge_size_ = (square_size_increase_count_ * 2) + 1;
						square_iteration_random_start_number_ = irandom_range(0, (base_square_edge_size_ * 4));
						square_iteration_ = square_iteration_random_start_number_;
						square_true_iteration_ = 0;
					}
		
					var instance_to_reference_ = instance_place(temp_check_x_, temp_check_y_, all);
					if (instance_to_reference_ != noone) && (instance_to_reference_ != object_at_location_) && (instance_to_reference_ != id) {
						// If any other objects look like the same team as the original click target are within range,
						// and aren't actually spies part of the original object's team, then set them as valid targets.
						// This also prevents auto targeting multiple spies looking like the same team from the same enemy
						// team that are in the vicinity.
						if (instance_to_reference_.objectVisibleTeam == object_at_location_.objectVisibleTeam) && (instance_to_reference_.objectRealTeam == object_at_location_.objectRealTeam)  {
							if (instance_to_reference_.objectType == object_at_location_.objectType) || ((instance_to_reference_.objectClassification  == "Unit") && (object_at_location_.objectClassification == "Building")) || ((instance_to_reference_.objectClassification == "Building") && (object_at_location_.objectClassification == "Unit")) {
								if ds_exists(target_list_, ds_type_list) {
									if ds_list_find_index(target_list_, instance_to_reference_) == -1 {
										ds_list_add(target_list_, instance_to_reference_);
									}
								}
								else {
									target_list_ = ds_list_create();
									ds_list_add(target_list_, instance_to_reference_);
								}
							}
						}
					}
				}
				ds_list_sort_distance(x, y, target_list_);
				// If the object at target location is a valid target, then mine/attack it if the
				// object selected is an object that can mine it. An object's actual "team" 
				// (objectRealTeam) will only be set to "Neutral" if it is a resource.
				if (object_at_location_.objectRealTeam == player[0].team) && (!forceAttack) {
					// Out of all selected objects, if the currently referenced object in the selected
					// object list belongs to the player, is a unitAction, and is a worker, then set the
					// object that was clicked on as the target.
					if objectClassification == "Unit" {
						if objectType == "Worker" {
							if object_at_location_.object_index == obj_tree_resource {
								objectCurrentCommand = "Chop";
							}
							else if object_at_location_.object_index == obj_food_resource {
								objectCurrentCommand = "Farm";
							}
							else if object_at_location_.object_index == obj_gold_resource {
								objectCurrentCommand = "Mine";
							}
							else if object_at_location_.object_index == obj_ruby_resource {
								objectCurrentCommand = "Ruby Mine";
							}
							else if object_at_location_.object_index == obj_unit {
								objectCurrentCommand = "Attack";
							}
							else if object_at_location_.object_index == obj_building {
								objectCurrentCommand = "Attack";
							}
							/*
							ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
							else if object_at_location_.object_index == building/unitAction/whatever that can be attacked {
								objectCurrentCommand = "Attack";
							}
							*/
							if ds_exists(objectTargetList, ds_type_list) {
								ds_list_destroy(objectTargetList);
								objectTargetList = noone;
							}
							objectTargetList = ds_list_create();
							if ds_exists(target_list_, ds_type_list) {
								ds_list_copy(objectTargetList, target_list_);
								ds_list_insert(objectTargetList, 0, object_at_location_);
							}
							else {
								ds_list_add(objectTargetList, object_at_location_);
							}
							if !mouse_check_button_pressed(mb_right) || (mouse_check_button_pressed(mb_right) && !objectSelected) {
								if returnToResourceID == noone {
									ds_list_sort_distance(x, y, objectTargetList);
								}
								else {
									ds_list_sort_distance(returnToResourceX, returnToResourceY, objectTargetList);
								}
							}
						}
						else if (object_at_location_.object_index == obj_unit) || (object_at_location_.object_index == obj_building) {
							objectCurrentCommand = "Attack";
							/*
							ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
							else if object_at_location_.object_index == building/unitAction/whatever that can be attacked {
								objectCurrentCommand = "Attack";
							}
							*/
							if ds_exists(objectTargetList, ds_type_list) {
								ds_list_destroy(objectTargetList);
								objectTargetList = noone;
							}
							objectTargetList = ds_list_create();
							if ds_exists(target_list_, ds_type_list) {
								ds_list_copy(objectTargetList, target_list_);
								ds_list_insert(objectTargetList, 0, object_at_location_);
							}
							else {
								ds_list_add(objectTargetList, object_at_location_);
							}
							if !mouse_check_button_pressed(mb_right) || (mouse_check_button_pressed(mb_right) && !objectSelected) {
								ds_list_sort_distance(x, y, objectTargetList);
							}
						}
						else {
							objectCurrentCommand = "Move";
							objectTargetList = noone;
						}
					}
				}
				// Else if the object at target location is an enemy, or forceAttack is active, attack it 
				// if the object selected is an object that can attack it.
				else if (object_at_location_.objectRealTeam != objectRealTeam) || (forceAttack) {
					if (objectClassification == "Unit") || ((objectClassification == "Building") && (canAttack)) {
						objectCurrentCommand = "Attack";
						if ds_exists(objectTargetList, ds_type_list) {
							ds_list_destroy(objectTargetList);
							objectTargetList = noone;
						}
						objectTargetList = ds_list_create();
						if ds_exists(target_list_, ds_type_list) {
							ds_list_copy(objectTargetList, target_list_);
							ds_list_insert(objectTargetList, 0, object_at_location_);
						}
						else {
							ds_list_add(objectTargetList, object_at_location_);
						}
						if !mouse_check_button_pressed(mb_right) || (mouse_check_button_pressed(mb_right) && !objectSelected) {
							ds_list_sort_distance(x, y, objectTargetList);
						}
					}
				}
				// Else if the object at target location is a friendly unitAction, nothing should be done and
				// just reset object_at_location_ so that the object can move normally.
				else if object_at_location_.objectRealTeam == objectRealTeam {
					// Sometimes, during movement of targets, a friendly target will pass over an enemy target
					// at the exact location of object_at_location_. When this happens, if the object running
					// this code is currently in combat, I don't want to remove it from combat due to this error,
					// so I skip over running the below code if its currently in combat. The cool thing with this
					// is that this won't be skipped over no matter what if the player is manually commanding
					// the object, so it'll never cause issues.
					if ((objectCurrentCommand != "Attack") && (objectCurrentCommand != "Mine") && (objectCurrentCommand != "Ruby Mine") && (objectCurrentCommand != "Chop") && (objectCurrentCommand != "Gather") && (!ds_exists(objectTargetList, ds_type_list))) || (mouse_check_button_pressed(mb_right)) {
						objectCurrentCommand = "Move";
						if ds_exists(objectTargetList, ds_type_list) {
							ds_list_destroy(objectTargetList);
						}
						objectTargetList = noone;
						objectTarget = noone;
						objectTargetType = noone;
						objectTargetTeam = noone;
						forceAttack = false;
					}
				}
			
				// Get rid of the temporary ds_list
				if ds_exists(target_list_, ds_type_list) {
					ds_list_destroy(target_list_);
					target_list_ = noone;
				}
		
		
		
				// Do a final ds_list cleanse, since sometimes this step event will run over multiple frames
				// and enemies can die between then.
				if ds_exists(objectTargetList, ds_type_list) {
					var m;
					for (m = 0; m < ds_list_size(objectTargetList); m++) {
						var temp_instance_ = ds_list_find_value(objectTargetList, m);
						if !instance_exists(temp_instance_) {
							if ds_list_size(objectTargetList) > 1 {
								ds_list_delete(objectTargetList, m);
							}
							else {
								ds_list_destroy(objectTargetList);
								objectTargetList = noone;
								if !instance_exists(objectTarget) {
									objectTarget = noone;
									forceAttack = false;
								}
							}
						}
					}
				}
			
				// After cleansing the list, go back and look for any new targets, one last time.
				if objectCurrentCommand == "Attack" {
					if (!ds_exists(objectTargetList, ds_type_list)) && (!instance_exists(objectTarget)) {
						check_for_new_target(x, y);
						forceAttack = false;
					}
				}
				// Finally, after setting each object's ds_lists (if necessary), reset all
				// movement variables for each selected object.
				if !justSpawned {
					if returnToResourceID == noone {
						if !ds_exists(objectTargetList, ds_type_list) {
							targetToMoveToX = floor(obj_inputs.mouseClampedX / 16) * 16;
							targetToMoveToY = floor(obj_inputs.mouseClampedY / 16) * 16;
						}
						else {
							if ds_exists(objectTargetList, ds_type_list) {
								var target_ = ds_list_find_value(objectTargetList, 0);
								targetToMoveToX = floor(target_.x / 16) * 16;
								targetToMoveToY = floor(target_.y / 16) * 16;
							}
							else {
								var target_ = noone;
								targetToMoveToX = x;
								targetToMoveToY = y;
							}
						}
					}
					else {
						var target_ = object_at_location_;
						targetToMoveToX = floor(target_.x / 16) * 16;
						targetToMoveToY = floor(target_.y / 16) * 16;
					}
				}
				if targetToMoveToX < 0 {
					targetToMoveToX = 0;
				}
				if targetToMoveToX > (room_width - 16) {
					targetToMoveToX = room_width - 16;
				}
				if targetToMoveToY < 0 {
					targetToMoveToY = 0;
				}
				if targetToMoveToY > (room_height - 16) {
					targetToMoveToY = room_height - 16;
				}
				originalTargetToMoveToX = targetToMoveToX;
				originalTargetToMoveToY = targetToMoveToY;
				// Variables specifically used by object to move
				changeVariablesWhenCloseToTarget = true;
				notAtTargetLocation = true;
				validLocationFound = false;
				validPathFound = false;
				needToStartGridSearch = true;
				x_n_ = 0;
				y_n_ = 0;
				right_n_ = 0;
				top_n_ = 0;
				left_n_ = 0;
				bottom_n_ = 0;
				rightWallFound = false;
				topWallFound = false;
				leftWallFound = false;
				bottomWallFound = false;
				rightForbidden = false;
				topForbidden = false;
				leftForbidden = false;
				bottomForbidden = false;
				specificLocationNeedsToBeChecked = false;
				specificLocationToBeCheckedX = -1;
				specificLocationToBeCheckedY = -1;
				baseSquareEdgeSize = 0;
				squareSizeIncreaseCount = 0;
				squareIteration = 0;
				squareTrueIteration = 0;
				tempCheckX = targetToMoveToX;
				tempCheckY = targetToMoveToY;
				searchHasJustBegun = true;
				totalTimesSearched = 0;
				closestPointsToObjectsHaveBeenSet = false;
				if path_exists(myPath) {
					path_delete(myPath);
					myPath = -1;
				}
			
				// Set action to take and sprite direction (different from group direction)
				currentAction = unitAction.move;
				currentDirection = point_direction(x, y, targetToMoveToX, targetToMoveToY) div 90;
			}
		}
		// Else if the area that was clicked on is empty, just move normally.
		else {
			if objectRealTeam == player[1].team {
				// Set the selected group's direction to face while pathfinding
				if ds_exists(objectsSelectedList, ds_type_list) {
					var i, number_of_selected_targeting_right_, number_of_selected_targeting_up_, number_of_selected_targeting_left_, number_of_selected_targeting_down_;
					number_of_selected_targeting_right_ = 0;
					number_of_selected_targeting_up_ = 0;
					number_of_selected_targeting_left_ = 0;
					number_of_selected_targeting_down_ = 0;
					for (i = 0; i < ds_list_size(objectsSelectedList); i++) {
						with ds_list_find_value(objectsSelectedList, i) {
							if objectRealTeam == player[1].team {
								// Create a list of all instances of the same type and team of the original
								// object that was clicked on. I COULD do this outside of the for i loop, which
								// would run this instead only once for all selected targets and really speed
								// things up, but it would mean the direction of the search is static and objects
								// would often take long routes to out-of-the-way objects just to attack or mine.
								// Placing this inside the for i loop, while slowing things down nominally, will
								// lead to more fluid combat and movement.
								var j, k, instance_to_reference_, target_list_, x_start_, y_start_, x_sign_, y_sign_, adjusted_click_direction_, click_direction_;
								target_list_ = noone;
								// Set click_direction_ to equal a number 0-3 inclusive based on the point direction 
								// from the original object location to the click location, and then set x_sign_ and
								// y_sign_, which determine the direction of the search, depending on that direction.
								adjusted_click_direction_ = point_direction(x, y, obj_inputs.mouseClampedX, obj_inputs.mouseClampedY) + 45;
								if adjusted_click_direction_ >= 360 {
									adjusted_click_direction_ -= 360;
								}
								click_direction_ = adjusted_click_direction_ div 90;
								switch click_direction_ {
									case 0:
										x_sign_ = 1;
										y_sign_ = -1;
										number_of_selected_targeting_right_++;
										break;
									case 1:
										x_sign_ = -1;
										y_sign_ = -1;
										number_of_selected_targeting_up_++;
										break;
									case 2:
										x_sign_ = -1;
										y_sign_ = 1;
										number_of_selected_targeting_left_++;
										break;
									case 3:
										x_sign_ = 1;
										y_sign_ = 1;
										number_of_selected_targeting_down_++;
										break;
								}
							}
						}
					}
					// After going through each selected object, set the group's targeting direction
					// based on the group's largest existing direction facing.
					var max_ = max(number_of_selected_targeting_right_, number_of_selected_targeting_up_, number_of_selected_targeting_left_, number_of_selected_targeting_down_);
					if number_of_selected_targeting_right_ == max_ {
						selectedUnitsDefaultDirectionToFace = 0;
					}
					else if number_of_selected_targeting_up_ == max_ {
						selectedUnitsDefaultDirectionToFace = 1;
					}
					else if number_of_selected_targeting_left_ == max_ {
						selectedUnitsDefaultDirectionToFace = 2;
					}
					else if number_of_selected_targeting_down_ == max_ {
						selectedUnitsDefaultDirectionToFace = 3;
					}
					var i;
					for (i = 0; i < ds_list_size(objectsSelectedList); i++) {
						with ds_list_find_value(objectsSelectedList, i) {
							obj_inputs.groupDirectionToMoveIn = selectedUnitsDefaultDirectionToFace;
							obj_inputs.groupDirectionToMoveInAdjusted = 0;
						}
					}
				}
				else {
					groupDirectionToMoveIn = point_direction(x, y, targetToMoveToX, targetToMoveToY) div 90;
				}
			}
			else {
				groupDirectionToMoveIn = point_direction(x, y, targetToMoveToX, targetToMoveToY) div 90;
			}
			// If the object is selected and player controlled, or if the object has been automatically instructed to move,
			// do so.
			if ((((ds_exists(objectsSelectedList, ds_type_list)) && (ds_list_find_index(objectsSelectedList, id) != -1)) || objectSelected == true) && (objectRealTeam == player[1].team)) || objectNeedsToMove {
				// Set regular variables
				if !justSpawned {
					if objectNeedsToMove {
						targetToMoveToX = floor(targetToMoveToX / 16) * 16;
						targetToMoveToY = floor(targetToMoveToY / 16) * 16;
					}
					else {
						targetToMoveToX = floor(obj_inputs.mouseClampedX / 16) * 16;
						targetToMoveToY = floor(obj_inputs.mouseClampedY / 16) * 16;
					}
				}
				if targetToMoveToX < 0 {
					targetToMoveToX = 0;
				}
				if targetToMoveToX > (room_width - 16) {
					targetToMoveToX = room_width - 16;
				}
				if targetToMoveToY < 0 {
					targetToMoveToY = 0;
				}
				if targetToMoveToY > (room_height - 16) {
					targetToMoveToY = room_height - 16;
				}
				originalTargetToMoveToX = targetToMoveToX;
				originalTargetToMoveToY = targetToMoveToY;
				// Variables specifically used by object to move
				changeVariablesWhenCloseToTarget = true;
				notAtTargetLocation = true;
				validLocationFound = false;
				validPathFound = false;
				needToStartGridSearch = true;
				x_n_ = 0;
				y_n_ = 0;
				right_n_ = 0;
				top_n_ = 0;
				left_n_ = 0;
				bottom_n_ = 0;
				rightWallFound = false;
				topWallFound = false;
				leftWallFound = false;
				bottomWallFound = false;
				rightForbidden = false;
				topForbidden = false;
				leftForbidden = false;
				bottomForbidden = false;
				specificLocationNeedsToBeChecked = false;
				specificLocationToBeCheckedX = -1;
				specificLocationToBeCheckedY = -1;
				baseSquareEdgeSize = 0;
				squareSizeIncreaseCount = 0;
				squareIteration = 0;
				squareTrueIteration = 0;
				tempCheckX = targetToMoveToX;
				tempCheckY = targetToMoveToY;
				groupRowWidth = 0;
				searchHasJustBegun = true;
				totalTimesSearched = 0;
				closestPointsToObjectsHaveBeenSet = false;
				if !objectNeedsToMove {
					objectCurrentCommand = "Move";
					objectTarget = noone;
					objectTargetType = noone;
					objectTargetTeam = noone;
					forceAttack = false;
					if ds_exists(objectTargetList, ds_type_list) {
						ds_list_destroy(objectTargetList);
						objectTargetList = noone;
					}
					if path_exists(myPath) {
						path_delete(myPath);
						myPath = -1;
					}
				}
				if mp_grid_get_cell(movementGrid, floor(x / 16), floor(y / 16)) == -1 {
					var x_adjustment_, y_adjustment_;
					x_adjustment_ = 0;
					y_adjustment_ = 0;
					if mp_grid_get_cell(movementGrid, floor((x + currentMovementSpeed + 1) / 16), floor(y / 16)) != -1 {
						x_adjustment_ += (currentMovementSpeed + 1);
					}
					else if mp_grid_get_cell(movementGrid, floor(x / 16), floor((y - currentMovementSpeed - 1) / 16)) != -1 {
						y_adjustment_ -= (currentMovementSpeed + 1);
					}
					else if mp_grid_get_cell(movementGrid, floor((x - currentMovementSpeed - 1) / 16), floor(y / 16)) != -1 {
						x_adjustment_ -= (currentMovementSpeed + 1);
					}
					else if mp_grid_get_cell(movementGrid, floor(x / 16), floor((y + currentMovementSpeed + 1) / 16)) != -1 {
						y_adjustment_ += (currentMovementSpeed + 1);
					}
					x += x_adjustment_;
					y += y_adjustment_;
				}
				// Set action to take and sprite direction (different from group direction)
				currentAction = unitAction.move;
				currentDirection = point_direction(x, y, targetToMoveToX, targetToMoveToY) div 90;
			}
		}
		objectNeedsToMove = false;
	}



	// Manage targets
	if ds_exists(objectTargetList, ds_type_list) {
		if instance_exists(ds_list_find_value(objectTargetList, 0)) {
			objectTarget = ds_list_find_value(objectTargetList, 0);
			objectTargetType = objectTarget.objectClassification;
			objectTargetTeam = objectTarget.objectRealTeam;
		}
		else if ds_list_size(objectTargetList) > 1 {
			while (ds_list_size(objectTargetList) > 1) && (!instance_exists(ds_list_find_value(objectTargetList, 0))) {
				ds_list_delete(objectTargetList, 0);
				forceAttack = false;
			}
			if instance_exists(ds_list_find_value(objectTargetList, 0)) {
				objectTarget = ds_list_find_value(objectTargetList, 0);
				objectTargetType = objectTarget.objectClassification;
				objectTargetTeam = objectTarget.objectRealTeam;
			}
			else if ds_list_size(objectTargetList) <= 1 {
				ds_list_destroy(objectTargetList);
				objectTargetList = noone;
				objectTarget = noone;
				objectTargetType = noone;
				objectTargetTeam = noone;
				forceAttack = false;
			}
		}
		if ds_exists(objectTargetList, ds_type_list) {
			if (ds_list_size(objectTargetList) <= 1) && (!instance_exists(ds_list_find_value(objectTargetList, 0))) {
				ds_list_destroy(objectTargetList);
				objectTargetList = noone;
				objectTarget = noone;
				objectTargetType = noone;
				objectTargetTeam = noone;
				forceAttack = false;
			}
		}
	}

	// Detect nearest valid targets and attack, if necessary. If in combat, detect all nearby enemies each frame.
	if objectDetectTarget <= 0 {
		objectDetectTarget = room_speed;
		if objectCurrentCommand != "Move" {
			// If the object doesn't have a target yet, or if its just collecting resources either from
			// a natural resource or from a structure that provides resources (a Farm, Thicket, or
			// Mine), continue searching for nearby enemies.
			if (!instance_exists(objectTarget)) || (objectTarget.objectClassification == "Resource") || ((objectTarget.objectClassification == "Building") && ((objectType == "Farm") || (objectType == "Thicket") || (objectType == "Mine"))) {
				detect_nearby_enemy_objects(x, y);
				if ds_exists(objectDetectedList, ds_type_list) {
					var i;
					for (i = 0; i < ds_list_size(objectDetectedList); i++) {
						// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
						// In this case specifically, worker units will not aggro to nearby enemy units unless they're in active
						// combat. With more militiant type units, this will change to aggro'ing to any enemy target within range.
						var instance_nearby_ = ds_list_find_value(objectDetectedList, i);
						if line_of_sight_exists_to_target(x + 7, y + 7, instance_nearby_.x, instance_nearby_.y) {
							if objectType == "Worker" {
								var target_of_instance_nearby_ = instance_nearby_.objectTarget;
								if instance_exists(target_of_instance_nearby_) {
									// If the target of any enemy object within range is a team member of this unitAction, attack that enemy object.
									if (target_of_instance_nearby_.objectRealTeam == objectRealTeam) {
										if objectCurrentCommand != "Attack" {
											objectCurrentCommand = "Attack";
											objectTarget = instance_nearby_;
											objectNeedsToMove = true;
											targetToMoveToX = instance_nearby_.x;
											targetToMoveToY = instance_nearby_.y;
											currentAction = unitAction.attack;
											currentDirection = point_direction(x, y, targetToMoveToX, targetToMoveToY) div 90;
											ds_list_destroy(objectDetectedList);
											objectDetectedList = noone;
											break;
										}
									}
								}
							}
							else {
								if objectCurrentCommand != "Attack" {
									objectCurrentCommand = "Attack";
									objectTarget = instance_nearby_;
									objectNeedsToMove = true;
									targetToMoveToX = instance_nearby_.x;
									targetToMoveToY = instance_nearby_.y;
									currentAction = unitAction.attack;
									currentDirection = point_direction(x, y, targetToMoveToX, targetToMoveToY) div 90;
									ds_list_destroy(objectDetectedList);
									objectDetectedList = noone;
									break;
								}
							}
						}
					}
				}
			}
		}
	}
	if ds_exists(objectDetectedList, ds_type_list) {
		ds_list_destroy(objectDetectedList);
		objectDetectedList = noone;
	}
	objectDetectedList = noone;

	// Count down various timers
	count_down_timers();

	// Switch the state machine's active state
	switch currentAction {
		case unitAction.idle:
			
			break;
		case unitAction.move:
			unit_move();
			break;
		case unitAction.mine:
			unit_mine();
			break;
		case unitAction.chop:
			unit_mine();
			break;
		case unitAction.farm:
			unit_mine();
			break;
		case unitAction.attack:
			unit_attack();
			break;
	}

	// Destroy self and remove self from all necessary ds_lists if HP goes to 0
	if currentHP <= 0 {
		kill_self();
	}
}


