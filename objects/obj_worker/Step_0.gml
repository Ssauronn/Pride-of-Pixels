// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, view_get_xport(view_camera[0]), view_get_yport(view_camera[0]), view_get_xport(view_camera[0]) + view_get_wport(view_camera[0]), view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) {
	objectOnScreen = true;
}
else {
	objectOnScreen = false;
}

// Set sprite index and sprite frame
sprite_index = currentSprite;
currentImageIndex += currentImageIndexSpeed;
if currentImageIndex > (sprite_get_number(sprite_index) - 1) {
	currentImageIndex = 0;
}
image_index = currentImageIndex;

// If the mouse is on the map and not on the toolbar, then allow clicks
if device_mouse_y_to_gui(0) <= (view_get_hport(view_camera[0]) - obj_camera_inputs_and_gui.toolbarHeight) {
	if (mouse_check_button_pressed(mb_right) && (objectSelected)) || objectNeedsToMove {
		if objectTeam == playerTeam {
			if objectNeedsToMove {
				var object_at_location_ = instance_place(floor(targetToMoveToX / 16) * 16, floor(targetToMoveToY / 16) * 16, all);
				var temp_object_at_location_ = noone;
				if instance_exists(object_at_location_) {
					if (object_at_location_.objectClassification != "Resource") && ((objectCurrentCommand == "Chop") || (objectCurrentCommand == "Farm") || (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Ruby Mine")) {
						if objectCurrentCommand == "Chop" {
							if !instance_exists(object_at_location_) || object_at_location_.object_index != obj_tree_resource {
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
							if !instance_exists(object_at_location_) || object_at_location_.object_index != obj_food_resource {
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
							if !instance_exists(object_at_location_) || object_at_location_.object_index != obj_gold_resource {
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
					}
				}
			}
			else {
				var object_at_location_ = instance_place(floor(mouse_x / 16) * 16, floor(mouse_y / 16) * 16, all);
			}
		}
		else {
			var object_at_location_ = noone;
		}
		// If objects selected are commanded onto a space occupied by a different object, get that
		// object's type, create a ds_list including that and all other objects of the same type for
		// use later, and send to movement script.
		if object_at_location_ != noone {
			if objectTeam == playerTeam {
				// Set the selected group's direction to search for in the targeting script
				if ds_exists(objectsSelectedList, ds_type_list) {
					var i, number_of_selected_targeting_right_, number_of_selected_targeting_up_, number_of_selected_targeting_left_, number_of_selected_targeting_down_;
					number_of_selected_targeting_right_ = 0;
					number_of_selected_targeting_up_ = 0;
					number_of_selected_targeting_left_ = 0;
					number_of_selected_targeting_down_ = 0;
					for (i = 0; i <= ds_list_size(objectsSelectedList) - 1; i++) {
						with ds_list_find_value(objectsSelectedList, i) {
							if objectTeam == playerTeam {
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
								adjusted_click_direction_ = point_direction(x, y, obj_camera_inputs_and_gui.mouseClampedX, obj_camera_inputs_and_gui.mouseClampedY) + 45;
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
					for (i = 0; i <= ds_list_size(objectsSelectedList) - 1; i++) {
						with ds_list_find_value(objectsSelectedList, i) {
							groupDirectionToMoveIn = selectedUnitsDefaultDirectionToFace;
							groupDirectionToMoveInAdjusted = 0;
						}
					}
				}
				else {
					groupDirectionToMoveIn = floor(point_direction(x, y, targetToMoveToX, targetToMoveToY) / 90);
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
					objectTarget = noone;
					objectTargetType = noone;
					objectTargetTeam = noone;
				
					// Find all other valid targets within range, and add them to the objectTargetList.
					var square_iteration_, square_iteration_random_start_number_, square_true_iteration_, square_size_increase_count_, square_size_increase_count_max_, base_square_edge_size_, search_increment_size_, temp_check_x_, temp_check_y_, target_x_, target_y_;
					square_size_increase_count_ = 0;
					square_iteration_random_start_number_ = 0;
					square_iteration_ = 0;
					square_true_iteration_ = 0;
					search_increment_size_ = 16;
					if (!objectNeedsToMove) && ((ds_exists(objectsSelectedList, ds_type_list)) && (ds_list_find_index(objectsSelectedList, id) != -1)) {
						target_x_ = floor(obj_camera_inputs_and_gui.mouseClampedX / 16) * 16;
						target_y_ = floor(obj_camera_inputs_and_gui.mouseClampedY / 16) * 16;
					}
					else if objectNeedsToMove {
						target_x_ = targetToMoveToX;
						target_y_ = targetToMoveToY;
					}
					if objectType == "Worker" {
						square_size_increase_count_max_ = 10;
					}
					/*
					else if objecType == "Any other type" {
						square_size_increase_count_max_ = whatever is an adequate range to search for in a square around the unit
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
							if instance_to_reference_.objectTeam == object_at_location_.objectTeam {
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
					// If the object at target location is a resource, then mine it if the object selected
					// is an object that can mine it. An object's "team" (objectTeam) will only be set to
					// "Neutral" if it is a resource.
					if object_at_location_.objectTeam == "Neutral" {
						// Out of all selected objects, if the currently referenced object in the selected
						// object list belongs to the player, is a unit, and is a worker, then set the
						// resource object that was clicked on as the target.
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
							}
							else {
								objectCurrentCommand = "Move";
								objectTargetList = noone;
							}
						}
					}
					// Else if the object at target location is an enemy, attack it if the object selected
					// is an object that can attack it.
					else if object_at_location_.objectTeam != playerTeam {
						if objectClassification == "Unit" {
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
						}
					}
					// Else if the object at target location is a friendly unit, nothing should be done and
					// just reset object_at_location_ so that the object can move normally.
					else if object_at_location_.objectTeam == playerTeam {
						objectCurrentCommand = "Move";
						if ds_exists(objectTargetList, ds_type_list) {
							ds_list_destroy(objectTargetList);
						}
						objectTargetList = noone;
						objectTarget = noone;
						objectTargetType = noone;
						objectTargetTeam = noone;
					}
					
					// Get rid of the temporary ds_list
					if ds_exists(target_list_, ds_type_list) {
						ds_list_destroy(target_list_);
						target_list_ = noone;
					}
			
			
			
					// Finally, after setting each object's ds_lists (if necessary), reset all
					// movement variables for each selected object.
					if !ds_exists(objectTargetList, ds_type_list) {
						targetToMoveToX = floor(obj_camera_inputs_and_gui.mouseClampedX / 16) * 16;
						targetToMoveToY = floor(obj_camera_inputs_and_gui.mouseClampedY / 16) * 16;
					}
					else {
						var target_ = ds_list_find_value(objectTargetList, 0);
						targetToMoveToX = floor(target_.x / 16) * 16;
						targetToMoveToY = floor(target_.y / 16) * 16;
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
					if mp_grid_get_cell(movementGrid, floor(x / 16), floor(y / 16)) == -1 {
						var x_adjustment_, y_adjustment_;
						x_adjustment_ = 0;
						y_adjustment_ = 0;
						if mp_grid_get_cell(movementGrid, floor((x + movementSpeed + 1) / 16), floor(y / 16)) != -1 {
							x_adjustment_ += (movementSpeed + 1);
						}
						else if mp_grid_get_cell(movementGrid, floor(x / 16), floor((y - movementSpeed - 1) / 16)) != -1 {
							y_adjustment_ -= (movementSpeed + 1);
						}
						else if mp_grid_get_cell(movementGrid, floor((x - movementSpeed - 1) / 16), floor(y / 16)) != -1 {
							x_adjustment_ -= (movementSpeed + 1);
						}
						else if mp_grid_get_cell(movementGrid, floor(x / 16), floor((y + movementSpeed + 1) / 16)) != -1 {
							y_adjustment_ += (movementSpeed + 1);
						}
						x += x_adjustment_;
						y += y_adjustment_;
					}
					// Set action to take and sprite direction (different from group direction)
					currentAction = worker.move;
					currentDirection = floor(point_direction(x, y, targetToMoveToX, targetToMoveToY) / 90);
				}
			}
		}
		// Else if the area that was clicked on is empty, just move normally.
		else {
			if objectTeam == playerTeam {
				// Set the selected group's direction to face while pathfinding
				if ds_exists(objectsSelectedList, ds_type_list) {
					var i, number_of_selected_targeting_right_, number_of_selected_targeting_up_, number_of_selected_targeting_left_, number_of_selected_targeting_down_;
					number_of_selected_targeting_right_ = 0;
					number_of_selected_targeting_up_ = 0;
					number_of_selected_targeting_left_ = 0;
					number_of_selected_targeting_down_ = 0;
					for (i = 0; i <= ds_list_size(objectsSelectedList) - 1; i++) {
						with ds_list_find_value(objectsSelectedList, i) {
							if objectTeam == playerTeam {
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
								adjusted_click_direction_ = point_direction(x, y, obj_camera_inputs_and_gui.mouseClampedX, obj_camera_inputs_and_gui.mouseClampedY) + 45;
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
					for (i = 0; i <= ds_list_size(objectsSelectedList) - 1; i++) {
						with ds_list_find_value(objectsSelectedList, i) {
							obj_camera_inputs_and_gui.groupDirectionToMoveIn = selectedUnitsDefaultDirectionToFace;
							obj_camera_inputs_and_gui.groupDirectionToMoveInAdjusted = 0;
						}
					}
				}
				else {
					groupDirectionToMoveIn = floor(point_direction(x, y, targetToMoveToX, targetToMoveToY) / 90);
				}
				if ((ds_exists(objectsSelectedList, ds_type_list)) && (ds_list_find_index(objectsSelectedList, id) != -1)) || objectNeedsToMove {
					// Set regular variables
					objectCurrentCommand = "Move";
					if objectNeedsToMove {
						targetToMoveToX = floor(targetToMoveToX / 16) * 16;
						targetToMoveToY = floor(targetToMoveToY / 16) * 16;
					}
					else {
						targetToMoveToX = floor(obj_camera_inputs_and_gui.mouseClampedX / 16) * 16;
						targetToMoveToY = floor(obj_camera_inputs_and_gui.mouseClampedY / 16) * 16;
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
					objectTarget = noone;
					objectTargetType = noone;
					objectTargetTeam = noone;
					if path_exists(myPath) {
						path_delete(myPath);
						myPath = -1;
					}
					if mp_grid_get_cell(movementGrid, floor(x / 16), floor(y / 16)) == -1 {
						var x_adjustment_, y_adjustment_;
						x_adjustment_ = 0;
						y_adjustment_ = 0;
						if mp_grid_get_cell(movementGrid, floor((x + movementSpeed + 1) / 16), floor(y / 16)) != -1 {
							x_adjustment_ += (movementSpeed + 1);
						}
						else if mp_grid_get_cell(movementGrid, floor(x / 16), floor((y - movementSpeed - 1) / 16)) != -1 {
							y_adjustment_ -= (movementSpeed + 1);
						}
						else if mp_grid_get_cell(movementGrid, floor((x - movementSpeed - 1) / 16), floor(y / 16)) != -1 {
							x_adjustment_ -= (movementSpeed + 1);
						}
						else if mp_grid_get_cell(movementGrid, floor(x / 16), floor((y + movementSpeed + 1) / 16)) != -1 {
							y_adjustment_ += (movementSpeed + 1);
						}
						x += x_adjustment_;
						y += y_adjustment_;
					}
					if ds_exists(objectTargetList, ds_type_list) {
						ds_list_destroy(objectTargetList);
						objectTargetList = noone;
					}
					// Set action to take and sprite direction (different from group direction)
					currentAction = worker.move;
					currentDirection = floor(point_direction(x, y, targetToMoveToX, targetToMoveToY) / 90);
				}
			}
		}
		objectNeedsToMove = false;
	}
}

// Manage targets
if ds_exists(objectTargetList, ds_type_list) {
	if instance_exists(ds_list_find_value(objectTargetList, 0)) {
		objectTarget = ds_list_find_value(objectTargetList, 0);
		objectTargetType = objectTarget.objectClassification;
		objectTargetTeam = objectTarget.objectTeam;
	}
	else if ds_list_size(objectTargetList) > 1 {
		while (ds_list_size(objectTargetList) > 1) && (!instance_exists(ds_list_find_value(objectTargetList, 0))) {
			ds_list_delete(objectTargetList, 0);
		}
		if instance_exists(ds_list_find_value(objectTargetList, 0)) {
			objectTarget = ds_list_find_value(objectTargetList, 0);
			objectTargetType = objectTarget.objectClassification;
			objectTargetTeam = objectTarget.objectTeam;
		}
		else if ds_list_size(objectTargetList) <= 1 {
			ds_list_destroy(objectTargetList);
			objectTargetList = noone;
			objectTarget = noone;
			objectTargetType = noone;
			objectTargetTeam = noone;
		}
	}
	if ds_exists(objectTargetList, ds_type_list) {
		if (ds_list_size(objectTargetList) <= 1) && (!instance_exists(ds_list_find_value(objectTargetList, 0))) {
			ds_list_destroy(objectTargetList);
			objectTargetList = noone;
			objectTarget = noone;
			objectTargetType = noone;
			objectTargetTeam = noone;
		}
	}
}

// Count down various timers
count_down_timers();

// Switch the state machine's active state
switch currentAction {
	case worker.idle:
		
		break;
	case worker.move:
		unit_move();
		break;
	case worker.mine:
		unit_mine();
		break;
	case worker.attack:
		unit_attack();
		break;
}

// Destroy self and remove self from all necessary ds_lists if HP goes to 0
if currentHP <= 0 {
	kill_self();
}


