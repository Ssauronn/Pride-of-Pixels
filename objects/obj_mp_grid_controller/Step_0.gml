// Reset the count for the queue every frame.
unitQueueCount = 0;
// Remove all the unit id's from the front of the queue that have already
// been evaluated for this frame.
if ds_exists(unitQueueForPathfindingList, ds_type_list) {
	// If there aren't even enough units to fill the queue, just delete
	// the queue and restart in the movement object(s) next frame if necessary.
	if ds_list_size(unitQueueForPathfindingList) < unitQueueMax {
		ds_list_destroy(unitQueueForPathfindingList);
		unitQueueForPathfindingList = -1;
	}
	// Else if the queue for determining a valid path for all objects that
	// want to move this turn is too full, just remove the units that have 
	// already been evaluated this frame.
	else {
		var i;
		for (i = 0; i < unitQueueMax; i++) {
			ds_list_delete(unitQueueForPathfindingList, 0);
		}
	}
}

// If the mouse is on the map and not on the toolbar, then allow clicks
if device_mouse_y_to_gui(0) <= (view_get_hport(view_camera[0]) - obj_camera_inputs_and_gui.toolbarHeight) {
	if mouse_check_button_pressed(mb_right) {
		with obj_worker {
			var object_at_location_ = instance_place(mouse_x, mouse_y, all);
		}
		// If objects selected are commanded onto a space occupied by a different object, get that
		// object's type, create a ds_list including that and all other objects of the same type for
		// use later, and send to movement script.
		if object_at_location_ != noone {
			var i;
			for (i = 0; i <= ds_list_size(objectsSelectedList) - 1; i++) {
				with ds_list_find_value(objectsSelectedList, i) {
					if objectTeam == playerTeam {
						// Reset objectTarget so that it can be properly set in the movement script.
						objectTarget = noone;
						objectTargetType = noone;
						objectTargetTeam = noone;
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
								break;
							case 1:
								x_sign_ = -1;
								y_sign_ = -1;
								break;
							case 2:
								x_sign_ = -1;
								y_sign_ = 1;
								break;
							case 3:
								x_sign_ = 1;
								y_sign_ = 1;
								break;
						}
						x_start_ = 0;
						y_start_ = 0;
						// j is the Y axis iterator
						var x_check_, y_check_;
						for (j = 0; j < 22; j++) {
							// k is the X axis iterator
							for (k = 0; k < 22; k++) {
								// x_check_ and y_check_ iteration through a box 10x10 around the original location,
								// and search for any objects within that box. If one is found and it matches the same
								// team and type as the other clicked object, then set it as another potential target
								// in the temporary ds_list.
								x_check_ = (floor(obj_camera_inputs_and_gui.mouseClampedX / 16) * 16) - (11 * 16 * x_sign_) + (x_start_ * 16 * x_sign_);
								y_check_ = (floor(obj_camera_inputs_and_gui.mouseClampedY / 16) * 16) - (11 * 16 * y_sign_) + (y_start_ * 16 * y_sign_);
								instance_to_reference_ = instance_place(x_check_, y_check_, all);
								// If an object found inside that square is: 1) not the same object clicked on, 2) the
								// same team as the object clicked on, and 3) the same type of object as the originally
								// clicked on object, or a unit of the same team as the building that was clicked on,
								// or a building of the same team as the unit that was clicked on, set that as another
								// potential target.
								if (instance_to_reference_ != noone) && (instance_to_reference_ != object_at_location_) {
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
								// Iterate x_start_ after each for loop, to get the correct values throughout
								// the search.
								x_start_++;
							}
							// Iterate y_start_ after each for loop, to get the correct values throughout the
							// search. 
							y_start_++;
							
							// Reset x_start_.
							x_start_ = 0;
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
									objectTargetList = noone;
								}
							}
						}
						// Else if the object at target location is an enemy, attack it if the object selected
						// is an object that can attack it.
						else if object_at_location_.objectTeam != playerTeam {
							if objectClassification == "Unit" {
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
					}
				}
			}
		}
		// Else if the area that was clicked on is empty, just move normally.
		else {
			var i;
			for (i = 0; i <= ds_list_size(objectsSelectedList) - 1; i++) {
				with ds_list_find_value(objectsSelectedList, i) {
					if objectTeam == playerTeam {
						if objectTargetList == noone {
							targetToMoveToX = floor(obj_camera_inputs_and_gui.mouseClampedX / 16) * 16;
							targetToMoveToY = floor(obj_camera_inputs_and_gui.mouseClampedY / 16) * 16;
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
							tempCheckX = targetToMoveToX;
							tempCheckY = targetToMoveToY;
							groupRowWidth = 0;
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
						}
					}
				}
			}
		}
	}
}


