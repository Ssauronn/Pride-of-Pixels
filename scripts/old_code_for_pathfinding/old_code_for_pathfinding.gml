// Set variables
var check_x_, check_y_, check_right_x_, check_top_y_, check_left_x_, check_bottom_y_, i, grid_location_empty_, previous_grid_location_invalid_, previous_grid_location_taken_, row_width_, temp_amount_of_times_shifted_;
check_x_ = floor(targetToMoveToX / 16) * 16;
check_y_ = floor(targetToMoveToY / 16) * 16;
check_right_x_ = check_x_ + (right_n_ * 16);
check_top_y_ = check_y_ - (top_n_ * 16);
check_left_x_ = check_x_ - (left_n_ * 16);
check_top_y_ = check_y_ + (bottom_n_ * 16);
temp_amount_of_times_shifted_ = amountOfTimesShifted;

// Set the row width to the correct width, which is automatically set inside obj_camera_and_gui
row_width_ = floor(sqrt(obj_camera_and_gui.numberOfObjectsSelected));


if point_distance(x, y, check_x_, check_y_) > movementSpeed {
	if !validPathFound {
		/*
		check for a line to target
		If that line doesn't intersect with any collision objects, then a valid path MUST exist
		and I can just search for a valid location that isn't taken by another object.
		If that line does intersect with collision objects, then check to see if the first empty
		box in grid (use mp_grid_get_cell) in a spiral pattern is a valid path. If it is not, 
		send out a line in 4 directions looking for the first collision object, and then check 
		BEHIND that line for an object. If the valid path does not exist behind that, then continue
		on checking behind collision objects. Ater a valid path is found at each location along
		the four lines, whichever is closest to the original click location, the object should move to.
		At that point, just do normal pathfinding - first check for if another unit is/will occupying
		that location, then check with mp_grid_get_cell to see if anything is occupying it, and then
		check for a path. The pattern to check in should be an expanding circle where only empty spaces
		adjacent to the original or other empty spaces that were adjacent are checked for paths. Any 
		occupied spaces are not checked.
		*/
		
		// Check the queue ds_list and make sure I can check for a valid location. If I can't, just generally
		// move towards target in the mean time.
		// Check the queue list to determine if this object can search for a valid path this frame. If the object's
		// index in the list is within the unitQueueMax, then it can search for a valid path. Otherwise, it can't.
		// If the list doesn't exist yet, then create the list and then search for a target. The list is destroyed
		// at the end of every frame if there are less objects looking for a valid path than the maximum amount, allowed,
		// but this isn't a problem because we re-create it here and all other objects can add themselves to it.
		// If the list exists but it hasn't yet been added to the list, then add itself, then verify whether its within
		// the queue range to be allowed to search for a valid path this frame.
		var index_ = -1;
		var can_be_evaluated_this_frame_ = false;
		if ds_exists(unitQueueForPathfindingList, ds_type_list) {
			index_ = ds_list_find_index(unitQueueForPathfindingList, self.id);
			if (index_ != -1) && (index_ < unitQueueMax) && (unitQueueCount < unitQueueMax) {
				unitQueueCount++;
				can_be_evaluated_this_frame_ = true;
			}
			else if index_ == -1 {
				ds_list_add(unitQueueForPathfindingList, self.id);
				index_ = ds_list_find_index(unitQueueForPathfindingList, self.id);
				if (index_ < unitQueueMax) && (unitQueueCount < unitQueueMax) {
					unitQueueCount++;
					can_be_evaluated_this_frame_ = true;
				}
			}
		}
		else {
			index_ = 0;
			unitQueueForPathfindingList = ds_list_create();
			ds_list_add(unitQueueForPathfindingList, self.id);
			unitQueueCount++;
			can_be_evaluated_this_frame_ = true;
		}
		// If I haven't started a search yet, and if I haven't yet determined original click location isn't valid and started
		// looking for new locations, then start the first search for a valid location to original target.
		if ((can_be_evaluated_this_frame_) && (unitQueueCount < unitQueueMax)) {
			if specificLocationNeedsToBeChecked {
				if path_exists(myPath) {
					path_delete(myPath);
					myPath = -1;
				}
				myPath = path_add();
				var location_is_already_taken_ = false;
				if ds_exists(unitGridLocation, ds_type_grid) {
					var i;
					for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
						var instance_to_reference_ = ds_grid_get(unitGridLocation, 0, i);
						if instance_to_reference_ != self.id {
							var instance_to_reference_x_ = ds_grid_get(unitGridLocation, 1, i);
							if instance_to_reference_x_ == specificLocationToBeCheckedX {
								var instance_to_reference_y_ = ds_grid_get(unitGridLocation, 2, i);
								if instance_to_reference_y_ == specificLocationToBeCheckedY {
									location_is_already_taken_ = true;
									break;
								}
							}
						}
					}
				}
			}
			if specificLocationNeedsToBeChecked && !location_is_already_taken_ {
				specificLocationNeedsToBeChecked = false;
				if mp_grid_path(movementGrid, myPath, x, y, specificLocationToBeCheckedX, specificLocationToBeCheckedY, true) {
					targetToMoveToX = specificLocationToBeCheckedX;
					targetToMoveToY = specificLocationToBeCheckedY;
					var i, self_exists_in_ds_grid_;
					self_exists_in_ds_grid_ = false;
					if ds_exists(unitGridLocation, ds_type_grid) {
						for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
							var instance_to_reference_ = ds_grid_get(unitGridLocation, 0, i);
							if instance_to_reference_ == self.id {
								self_exists_in_ds_grid_ = true;
								ds_grid_set(unitGridLocation, 1, i, specificLocationToBeCheckedX);
								ds_grid_set(unitGridLocation, 2, i, specificLocationToBeCheckedY);
								break;
							}
						}
						if !self_exists_in_ds_grid_ {
							ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) + 1) {
								ds_grid_set(unitGridLocation, 0, ds_grid_height(unitGridLocation) - 1, self.id);
								ds_grid_set(unitGridLocation, 1, ds_grid_height(unitGridLocation) - 1, specificLocationToBeCheckedX);
								ds_grid_set(unitGridLocation, 2, ds_grid_height(unitGridLocation) - 1, specificLocationToBeCheckedY);
							}
						}
					}
					else {
						unitGridLocation = ds_grid_create(3, 0);
						ds_grid_set(unitGridLocation, 0, 0, self.id);
						ds_grid_set(unitGridLocation, 1, 0, specificLocationToBeCheckedX);
						ds_grid_set(unitGridLocation, 2, 0, specificLocationToBeCheckedY);
					}
					right_n_ = 0;
					top_n_ = 0;
					left_n_ = 0;
					bottom_n_ = 0;
					x_n_ = 0;
					iteration_ = 0;
					validPathFound = true;
					amountOfTimesDirectionRotated = 0;
					amountOfTimesShifted = 0;
					selectedObjectDirectionToFaceIfNoneSet = -1;
					specificLocationNeedsToBeChecked = false;
				}
			}
			else {
				// Increase x_n_ by one before calculating anything else if a location from the previous
				// frame needed to be checked but it was found to be already filled.
				if specificLocationNeedsToBeChecked {
					specificLocationNeedsToBeChecked = false;
					x_n_++;
					if x_n_ > row_width_ {
						x_n_ = 1;
						//amountOfTimesShifted++;
						if (sign(amountOfTimesShifted) == 0) || (sign(amountOfTimesShifted) == 1) {
							amountOfTimesShifted++;
						}
						else {
							amountOfTimesShifted--;
						}
					}
					// Alternate between sides of the target location, for areas to search for.
					if amountOfTimesShifted & 1 {
						temp_amount_of_times_shifted_ = floor(abs(amountOfTimesShifted) / 2);
					}
					else {
						temp_amount_of_times_shifted_ = floor(abs(amountOfTimesShifted) / 2) * -1;
					}
				}
				var tempCheckX, tempCheckY, right_wall_found_, top_wall_found_, left_wall_found_, bottom_wall_found_, location_found_, edge_of_map_, sign_;
				// I can just add right_n_ and left_n_ together immediately, and then also add that to both
				// tempCheckX and tempCheckY all at once because no more than a single direction will be
				// larger than 0 at a time. sign_ is set by checking whether the value should move up or down,
				// which is automatically set by multiplying the amount that should be shifted by sign_.
				sign_ = 1;
				if (left_n_ > 0) || (top_n_ > 0) {
					sign_ = -1;
				}
				// Set tempCheckX and tempCheckY
				tempCheckX = check_x_ + ((right_n_ + left_n_) * 16 * sign_);
				tempCheckY = check_y_ + ((top_n_ + bottom_n_) * 16 * sign_);
			
				var currently_checking_x_, currently_checking_y_;
				currently_checking_x_ = tempCheckX;
				currently_checking_y_ = tempCheckY;
					
				// Clear any path before creating a new one, if it exists, to have a clean slate.
				if path_exists(myPath) {
					path_delete(myPath);
					myPath = noone;
				}
				myPath = path_add();
				// Check to see if the area is empty and then if it is, if a path exists.
				if (mp_grid_get_cell(movementGrid, tempCheckX / 16, tempCheckY / 16) != -1) && (mp_grid_path(movementGrid, myPath, x, y, tempCheckX, tempCheckY, true)) {
					// Now that I know the empty spot is a valid path location, I can now check all adjacent
					// empty locations and start checking those.
					var valid_location_found_, need_to_check_path_to_potential_location_, location_is_already_taken_, right_searched_, top_searched_, left_searched_, bottom_searched_;
					valid_location_found_ = false;
					need_to_check_path_to_potential_location_ = false;
					right_searched_ = false;
					top_searched_ = false;
					left_searched_ = false;
					bottom_searched_ = false;
				
					// Check to see if the current spot is occupied by a different unit. If it isn't, then I don't even have
					// to enter for loop to search for something else.
					location_is_already_taken_ = false;
					if ds_exists(unitGridLocation, ds_type_grid) {
						var i;
						for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
							var instance_to_reference_ = ds_grid_get(unitGridLocation, 0, i);
							if instance_to_reference_ != self.id {
								var instance_to_reference_x_ = ds_grid_get(unitGridLocation, 1, i);
								if instance_to_reference_x_ == floor(tempCheckX / 16) * 16 {
									var instance_to_reference_y_ = ds_grid_get(unitGridLocation, 2, i);
									if instance_to_reference_y_ == floor(tempCheckY / 16) * 16 {
										location_is_already_taken_ = true;
										break;
									}
								}
							}
						}
					}
					if !location_is_already_taken_ {
						valid_location_found_ = true;
					}
					if !valid_location_found_ {
						while !need_to_check_path_to_potential_location_ {
							// If x_n_ is odd, move in the negative direction. div will always round towards 0, whereas
							// floor always rounds towards negative infinity, so I use div. Or I can use normal division
							// and then multiply by negative afterwards.
							if x_n_ & 1 {
								iteration_ = floor(x_n_ / 2) * -1;
							}
							// Otherwise, move in the positive direction
							else {
								iteration_ = x_n_ / 2;
							}
					
							// Set the current checking position that's changed ONLY by checking for a position that isn't taken
							// by a unit.
							if right_n_ > 0 {
								currently_checking_x_ = tempCheckX + (temp_amount_of_times_shifted_ * 16);
								currently_checking_y_ = tempCheckY + (iteration_ * 16);
							}
							else if top_n_ > 0 {
								currently_checking_x_ = tempCheckX + (iteration_ * 16);
								currently_checking_y_ = tempCheckY - (temp_amount_of_times_shifted_ * 16);
							}
							else if left_n_ > 0 {
								currently_checking_x_ = tempCheckX - (temp_amount_of_times_shifted_ * 16);
								currently_checking_y_ = tempCheckY + (iteration_ * 16);
							}
							else if bottom_n_ > 0 {
								currently_checking_x_ = tempCheckX + (iteration_ * 16);
								currently_checking_y_ = tempCheckY + (temp_amount_of_times_shifted_ * 16);
							}
							else {
								var current_direction_facing_ = 0;
								if selectedUnitsDefaultDirectionToFace == -1 {
									if (point_direction(x, y, targetToMoveToX, targetToMoveToY) >= 45) && (point_direction(x, y, targetToMoveToX, targetToMoveToY) < 135) {
										current_direction_facing_ = 1;
									}
									else if (point_direction(x, y, targetToMoveToX, targetToMoveToY) >= 135) && (point_direction(x, y, targetToMoveToX, targetToMoveToY) < 225) {
										current_direction_facing_ = 2;
									}
									else if (point_direction(x, y, targetToMoveToX, targetToMoveToY) >= 225) && (point_direction(x, y, targetToMoveToX, targetToMoveToY) < 315) {
										current_direction_facing_ = 3;
									}
									selectedUnitsDefaultDirectionToFace = current_direction_facing_;
									selectedObjectDirectionToFaceIfNoneSet = current_direction_facing_;
								}
								else {
									selectedObjectDirectionToFaceIfNoneSet = current_direction_facing_;
								}
								switch (selectedObjectDirectionToFaceIfNoneSet) {
									case 0: 
										currently_checking_x_ = tempCheckX + (temp_amount_of_times_shifted_ * 16);
										currently_checking_y_ = tempCheckY + (iteration_ * 16);
										break;
									case 1:
										currently_checking_x_ = tempCheckX + (iteration_ * 16);
										currently_checking_y_ = tempCheckY - (temp_amount_of_times_shifted_ * 16);
										break;
									case 2:
										currently_checking_x_ = tempCheckX - (temp_amount_of_times_shifted_ * 16);
										currently_checking_y_ = tempCheckY + (iteration_ * 16);
										break;
									case 3:
										currently_checking_x_ = tempCheckX + (iteration_ * 16);
										currently_checking_y_ = tempCheckY + (temp_amount_of_times_shifted_ * 16);
										break;
								}
							}
					
							location_is_already_taken_ = false;
							if ds_exists(unitGridLocation, ds_type_grid) {
								var i;
								for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
									var instance_to_reference_ = ds_grid_get(unitGridLocation, 0, i);
									if instance_to_reference_ != self.id {
										var instance_to_reference_x_ = ds_grid_get(unitGridLocation, 1, i);
										if instance_to_reference_x_ == floor(currently_checking_x_ / 16) * 16 {
											var instance_to_reference_y_ = ds_grid_get(unitGridLocation, 2, i);
											if instance_to_reference_y_ == floor(currently_checking_y_ / 16) * 16 {
												location_is_already_taken_ = true;
											}
										}
									}
								}
							}
							// If the location isn't already taken by objects, I can now check for a potential path to that location
							// in the next frame that it'll be available to be checked.
							if !location_is_already_taken_ {
								if (mp_grid_get_cell(movementGrid, currently_checking_x_ / 16, currently_checking_y_ / 16) != -1) {
									need_to_check_path_to_potential_location_ = true;
									specificLocationNeedsToBeChecked = true;
									specificLocationToBeCheckedX = currently_checking_x_;
									specificLocationToBeCheckedY = currently_checking_y_;
								}
							}
							if !need_to_check_path_to_potential_location_ {
								x_n_++;
								if x_n_ > row_width_ {
									x_n_ = 1;
									//amountOfTimesShifted++;
									if (sign(amountOfTimesShifted) == 0) || (sign(amountOfTimesShifted) == 1) {
										amountOfTimesShifted++;
									}
									else {
										amountOfTimesShifted--;
									}
								}
							}
							// Alternate between sides of the target location, for areas to search for.
							if amountOfTimesShifted & 1 {
								temp_amount_of_times_shifted_ = floor(abs(amountOfTimesShifted) / 2);
							}
							else {
								temp_amount_of_times_shifted_ = floor(abs(amountOfTimesShifted) / 2) * -1;
							}
						}
					}
					else {
						targetToMoveToX = currently_checking_x_;
						targetToMoveToY = currently_checking_y_;
						var i, self_exists_in_ds_grid_;
						self_exists_in_ds_grid_ = false;
						if ds_exists(unitGridLocation, ds_type_grid) {
							for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
								var instance_to_reference_ = ds_grid_get(unitGridLocation, 0, i);
								if instance_to_reference_ == self.id {
									self_exists_in_ds_grid_ = true;
									ds_grid_set(unitGridLocation, 1, i, currently_checking_x_);
									ds_grid_set(unitGridLocation, 2, i, currently_checking_y_);
								}
							}
							if !self_exists_in_ds_grid_ {
								ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) + 1) {
									ds_grid_set(unitGridLocation, 0, ds_grid_height(unitGridLocation) - 1, self.id);
									ds_grid_set(unitGridLocation, 1, ds_grid_height(unitGridLocation) - 1, currently_checking_x_);
									ds_grid_set(unitGridLocation, 2, ds_grid_height(unitGridLocation) - 1, currently_checking_y_);
								}
							}
						}
						else {
							unitGridLocation = ds_grid_create(3, 1);
							ds_grid_set(unitGridLocation, 0, 0, self.id);
							ds_grid_set(unitGridLocation, 1, 0, currently_checking_x_);
							ds_grid_set(unitGridLocation, 2, 0, currently_checking_y_);
						}
						right_n_ = 0;
						top_n_ = 0;
						left_n_ = 0;
						bottom_n_ = 0;
						x_n_ = 0;
						iteration_ = 0;
						validPathFound = true;
						amountOfTimesDirectionRotated = 0;
						amountOfTimesShifted = 0;
						selectedObjectDirectionToFaceIfNoneSet = -1;
						specificLocationNeedsToBeChecked = false;
					}
				
				}
				// If no valid path exists or the area is not empty, obviously one won't be valid until I pass 
				// over at least one occupied area. So start checking boxes in the direction towards the unit 
				// until I first find an occupied box, and then find an unoccupied box. That final unoccupied 
				// box is the only possible location that could have a valid point to move to.
				else {
					check_x_ = originalTargetToMoveToX;
					check_y_ = originalTargetToMoveToY;
					var direction_to_search_in_ = 3;
					if ((point_direction(x, y, check_x_, check_y_) < 45) && (point_direction(x, y, check_x_, check_y_) >= 0)) || ((point_direction(x, y, check_x_, check_y_) >= 315) && (point_direction(x, y, check_x_, check_y_) < 360)) {
						direction_to_search_in_ = 2;
					}
					else if (point_direction(x, y, check_x_, check_y_) < 135) && (point_direction(x, y, check_x_, check_y_) >= 45) {
						direction_to_search_in_ = 3;
					}
					else if (point_direction(x, y, check_x_, check_y_) < 225) && (point_direction(x, y, check_x_, check_y_) >= 135) {
						direction_to_search_in_ = 0;
					}
					else if (point_direction(x, y, check_x_, check_y_) < 315) && (point_direction(x, y, check_x_, check_y_) >= 225) {
						direction_to_search_in_ = 1;
					}
					location_found_ = false;
					right_wall_found_ = false;
					top_wall_found_ = false;
					left_wall_found_ = false;
					bottom_wall_found_ = false;
					edge_of_map_ = false;
					tempCheckX = check_x_;
					tempCheckY = check_x_;
					// Ascertain the right_n_, top_n_, left_n_, and bottom_n_ variables based on any single variable that is above 0 before
					// the search begins. If any of those variables are above 0, that means the search has already begun before, and I should
					// start from original search point. I know only one variable will be above 0 because I manually set the rest to 0 below,
					// near the end of the while statement.
					
					// NOT CURRENTLY WORKING
					var set_value_;
					if right_n_ > 0 {
						set_value_ = right_n_ - 1;
						direction_to_search_in_ = 0;
						right_n_ = set_value_;
						top_n_ = set_value_;
						left_n_ = set_value_;
						bottom_n_ = set_value_;
					}
					else if top_n_ > 0 {
						set_value_ = top_n_ - 1;
						direction_to_search_in_ = 1;
						right_n_ = set_value_;
						top_n_ = set_value_;
						left_n_ = set_value_;
						bottom_n_ = set_value_;
					}
					else if left_n_ > 0 {
						set_value_ = left_n_ - 1;
						direction_to_search_in_ = 2;
						right_n_ = set_value_;
						top_n_ = set_value_;
						left_n_ = set_value_;
						bottom_n_ = set_value_;
					}
					else if bottom_n_ > 0 {
						set_value_ = bottom_n_ - 1;
						direction_to_search_in_ = 3;
						right_n_ = set_value_;
						top_n_ = set_value_;
						left_n_ = set_value_;
						bottom_n_ = set_value_;
					}
					// THIS WILL ONLY ACTIVATE if the original cell clicked on, before evaluating any other cell, was
					// already occupied by a box. In this case, I'll be checking the nearest empty location first, instead
					// of looking for another wall and then a blank space behind that.
					else if mp_grid_get_cell(movementGrid, check_x_ / 16, check_y_ / 16) == -1 {
						right_wall_found_ = true;
						top_wall_found_ = true;
						left_wall_found_ = true;
						bottom_wall_found_ = true;
					}
					// Else if the original spot isn't occupied and no other search has occured before this, then search through
					// the original box first.
					else {
						direction_to_search_in_ = -1;
						right_n_ = -1;
					}
					while (!location_found_) && (amountOfTimesDirectionRotated <= 3) {
						// First, rotate the search and start from the original location if the search 
						// went off the map
						if edge_of_map_ {
							right_n_ = 0;
							top_n_ = 0;
							left_n_ = 0;
							bottom_n_ = 0;
							edge_of_map_ = false;
							// If the original cell clicked on is empty, then reset all variables to base. Otherwise,
							// reset variables to what they would be if original click is on a wall.
							if mp_grid_get_cell(movementGrid, check_x_ / 16, check_y_ / 16) != -1 {
								right_wall_found_ = false;
								top_wall_found_ = false;
								left_wall_found_ = false;
								bottom_wall_found_ = false;
							}
							else {
								right_wall_found_ = true;
								top_wall_found_ = true;
								left_wall_found_ = true;
								bottom_wall_found_ = true;
							}
							tempCheckX = check_x_;
							tempCheckY = check_y_;
							switch direction_to_search_in_ {
								case 0: 
									rightForbidden = true;
									break;
								case 1:
									topForbidden = true;
									break;
								case 2:
									leftForbidden = true;
									break;
								case 3:
									bottomForbidden = true;
									break;
							}
						}
						direction_to_search_in_++;
						// If any direction is forbidden, make sure that direction isn't being searched in, and if it is, don't
						// search in that direction again.
						if !rightForbidden || !topForbidden || !leftForbidden || !bottomForbidden {
							if (rightForbidden && direction_to_search_in_ == 0) || (topForbidden && direction_to_search_in_ == 1) || (leftForbidden && direction_to_search_in_ == 2) || (bottomForbidden && direction_to_search_in_ == 3) {
								direction_to_search_in_++;
							}
						}
						while direction_to_search_in_ > 3 {
							direction_to_search_in_ -= 4;
						}
						// Adjust variables first, then look for an empty grid spot
						switch direction_to_search_in_ {
							case 0:
								right_n_++;
								tempCheckX = check_x_ + (right_n_ * 16);
								tempCheckY = check_y_;
								break;
							case 1:
								top_n_++;
								tempCheckX = check_x_;
								tempCheckY = check_y_ - (top_n_ * 16);
								break;
							case 2:
								left_n_++;
								tempCheckX = check_x_ - (left_n_ * 16);
								tempCheckY = check_y_;
								break;
							case 3:
								bottom_n_++;
								tempCheckX = check_x_;
								tempCheckY = check_y_ + (bottom_n_ * 16);
								break;
						}
						// If no wall has been found yet
						if (direction_to_search_in_ == 0 && !right_wall_found_) || (direction_to_search_in_ == 1 && !top_wall_found_) || (direction_to_search_in_ == 2 && !left_wall_found_) || (direction_to_search_in_ == 3 && !bottom_wall_found_) {
							// As long as the search isn't going off the map, start the legit search
							if ((tempCheckX >= 0) && (tempCheckX <= (room_width - 16))) && ((tempCheckY >= 0) && (tempCheckY <= (room_width - 16))) {
								// If a full grid spot is found after variable adjustments, mark it as such.
								if mp_grid_get_cell(movementGrid, tempCheckX / 16, tempCheckY / 16) == -1 {
									switch direction_to_search_in_ {
										case 0:
											right_wall_found_ = true;
											break;
										case 1:
											top_wall_found_ = true;
											break;
										case 2:
											left_wall_found_ = true;
											break;
										case 3:
											bottom_wall_found_ = true;
											break;
									}
								}
							}
							// If the search is trying to go off the map, mark it as such for a readjustment later.
							else {
								edge_of_map_ = true;
								amountOfTimesDirectionRotated++;
							}
						}
						// Otherwise if a wall has been found
						else {
							// As long as the search isn't going off the map, start the legit search
							if ((tempCheckX >= 0) && (tempCheckX <= (room_width - 16))) && ((tempCheckY >= 0) && (tempCheckY <= (room_height - 16))){
								// If no more occupied space is found, then mark that as the new spot to check.
								if mp_grid_get_cell(movementGrid, tempCheckX / 16, tempCheckY / 16) != -1 {
									location_found_ = true;
									// Set every direction_n_ to 0 except the one that found a legit spot.
									switch direction_to_search_in_ {
										case 0:
											top_n_ = 0;
											left_n_ = 0;
											bottom_n_ = 0;
											break;
										case 1:
											right_n_ = 0;
											left_n_ = 0;
											bottom_n_ = 0;
											break;
										case 2:
											right_n_ = 0;
											top_n_ = 0;
											bottom_n_ = 0;
											break;
										case 3:
											right_n_ = 0;
											top_n_ = 0;
											left_n_ = 0;
											break;
									}
								}
							}
							else {
								edge_of_map_ = true;
								amountOfTimesDirectionRotated++;
							}
						}
					}
					// If absolutely no valid spot exists, then just exit and give up the search. Make sure
					// to add self back to grid, so that objects don't try to stand on it.
					if amountOfTimesDirectionRotated > 3 {
						if ds_exists(unitGridLocation, ds_type_grid) {
							var i, self_found_;
							self_found_ = false;
							for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
								var instance_to_reference_, instance_to_reference_x_, instance_to_reference_y_;
								instance_to_reference_ = ds_grid_get(unitGridLocation, 0, i);
								instance_to_reference_x_ = ds_grid_get(unitGridLocation, 1, i);
								instance_to_reference_y_ = ds_grid_get(unitGridLocation, 2, i);
								if (self.id == instance_to_reference_) && (x == instance_to_reference_x_) && (y == instance_to_reference_y_) {
									self_found_ = true;
									break;
								}
							}
							if !self_found_ {
								ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) + 1);
								ds_grid_set(unitGridLocation, 0, ds_grid_height(unitGridLocation) - 1, self.id);
								ds_grid_set(unitGridLocation, 1, ds_grid_height(unitGridLocation) - 1, x);
								ds_grid_set(unitGridLocation, 2, ds_grid_height(unitGridLocation) - 1, y);
							}
						}
						else {
							unitGridLocation = ds_grid_create(3, 1);
							ds_grid_set(unitGridLocation, 0, 0, self.id);
							ds_grid_set(unitGridLocation, 1, 0, x);
							ds_grid_set(unitGridLocation, 2, 0, y);
						}
						amountOfTimesDirectionRotated = 0;
						x = floor(x / 16) * 16;
						y = floor(y / 16) * 16;
						targetToMoveToX = x;
						targetToMoveToY = y;
						x_n_ = 0;
						iteration_ = 0;
						right_n_ = 0;
						top_n_ = 0;
						left_n_ = 0;
						bottom_n_ = 0;
						specificLocationNeedsToBeChecked = false;
						exit;
					}
				}
			}
		}
		// If its not yet this object's turn to do anything, don't do anything.
	}
}

// Actually move the object.
if point_distance(x, y, targetToMoveToX, targetToMoveToY) > movementSpeed {
	if validPathFound {
		if path_get_number(myPath) > 0 {
			mp_potential_step(path_get_point_x(myPath, 0), path_get_point_y(myPath, 0), movementSpeed, false);
		}
		else {
			path_delete(myPath);
			myPath = noone;
			validPathFound = false;
			x = floor(targetToMoveToX / 16) * 16;
			y = floor(targetToMoveToY / 16) * 16;
		}
		if ((path_get_number(myPath) > 1) && (point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) <= sprite_width)) || ((path_get_number(myPath) == 1) && (point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) <= movementSpeed)) {
			path_delete_point(myPath, 0);
		}
	}
	else {
		mp_potential_step(targetToMoveToX, targetToMoveToY, movementSpeed, false);
	}
}
else {
	rightForbidden = false;
	topForbidden = false;
	leftForbidden = false;
	bottomForbidden = false;
	right_n_ = 0;
	top_n_ = 0;
	left_n_ = 0;
	bottom_n_ = 0;
	x = floor(targetToMoveToX / 16) * 16;
	y = floor(targetToMoveToY / 16) * 16;
}

// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, view_get_xport(view_camera[0]), view_get_yport(view_camera[0]), view_get_xport(view_camera[0]) + view_get_wport(view_camera[0]), view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) {
	objectOnScreen = true;
}
else {
	objectOnScreen = false;
}


