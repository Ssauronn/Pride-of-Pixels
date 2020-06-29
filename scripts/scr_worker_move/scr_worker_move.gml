/*
Description of script's functions:

If original click spot not valid
	Search in rotating and expanding cross shape until the first potentially valid spot is found (path exists)
	-This search is done by starting from the original click area, expanding outwards until a solid object is found,
	-and then checking the next empty spot aftr that object. This way I drastically cut down on the empty spots I'm checking,
	-and what's more I'm only checking spots that legit could be valid, because the only way an invalid search will become
	-valid is after it passes an object that could have been making it invalid.
	If able to search this frame, check to see if that spot is valid
		If valid, mark as starting search area

Once a valid starting search area is determined, start checking for if the spot is occupied by a physical object
	If not occupied, check one final time for a path
	If occupied
		Move the search out in an expanding area, moving first alternating between sides on a row and then, after the row matches
		the standard row width, alternating between the other sides with alternating columns of rows. Final search will look 
		something like this:
		
		25 15 5 10 20
		23 13 3 8 18
		21 11 1 6 16
		22 12 2 7 17
		24 14 4 9 19
		
		First checked area is right on the click spot, followed by alternating first up and down/left and right, and then left and
		right/up and down. It also means that if the original click spot is up against a line of trees or a long wall, it doesn't
		matter, because the units will form up just behind it.
*/

#region Initialize variables necessary for the whole script
if point_distance(x, y, targetToMoveToX, targetToMoveToY) == 0 {
	// Just in case the object is on the target location to move to, make sure object is
	// in the ds_grid before exiting to idle. This will only happen if the original click
	// location wasn't valid, but a new, closer click was location was found and the first
	// valid location in reference to the new click location is precisely where this
	// object is already at. tl;dr this will only activate if the local var 
	// cannot_move_without_better_coordinates_ is set to true.
	var i, originally_self_is_found_, ds_did_not_exist_, original_location_is_valid_;
	originally_self_is_found_ = noone;
	original_location_is_valid_ = true;
	if ds_exists(unitGridLocation, ds_type_grid) {
		ds_did_not_exist_ = true;
		if ds_grid_height(unitGridLocation) > 0 {
			for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
				var temp_instance_, temp_instance_x_, temp_instance_y_;
				temp_instance_ = ds_grid_get(unitGridLocation, 0, i);
				temp_instance_x_ = ds_grid_get(unitGridLocation, 1, i);
				temp_instance_y_ = ds_grid_get(unitGridLocation, 2, i);
				if (self.id != temp_instance_.id) && (targetToMoveToX == temp_instance_x_) && (targetToMoveToY == temp_instance_y_) {
					original_location_is_valid_ = false;
				}
				if self.id == temp_instance_.id {
					originally_self_is_found_ = i;
				}
			}
		}
		// If self doesn't exist in the grid, which will happen only if the original
		// click spot was not valid but a new valid click location was found, resize the
		// grid to accomodate new information and add this object's information in it.
		if (originally_self_is_found_ == noone) && (original_location_is_valid_) {
			ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) + 1);
			ds_grid_set(unitGridLocation, 0, ds_grid_height(unitGridLocation) - 1, self.id);
			ds_grid_set(unitGridLocation, 1, ds_grid_height(unitGridLocation) - 1, targetToMoveToX);
			ds_grid_set(unitGridLocation, 2, ds_grid_height(unitGridLocation) - 1, targetToMoveToY);
		}
	}
	// If the ds_grid doesn't exist, which is possible (but unlikely), then just recreate
	// the grid and add the object's info.
	else {
		ds_did_not_exist_ = false;
		unitGridLocation = ds_grid_create(3, 1);
		ds_grid_set(unitGridLocation, 0, 0, self.id);
		ds_grid_set(unitGridLocation, 1, 0, targetToMoveToX);
		ds_grid_set(unitGridLocation, 2, 0, targetToMoveToY);
	}
	// As long as the object is in the click area AND its a valid location
	// to move to, either because there are no previous objects registered to
	// be there, or there are no previous objects registered, period, then reset
	// the variables and exit script.
	if (!ds_did_not_exist_) || ((originally_self_is_found_ == noone) && (original_location_is_valid_)) {
		notAtTargetLocation = false;
		validLocationFound = true;
		validPathFound = true;
		cannot_move_without_better_coordinates_ = false;
		notAtTargetLocation = false;
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
		tempCheckX = -1;
		tempCheckY = -1;
		groupRowWidth = 0;
		specificLocationNeedsToBeChecked = false;
		specificLocationToBeCheckedX = -1;
		specificLocationToBeCheckedY = -1;
		searchHasJustBegun = true;
		totalTimesSearched = 0;
		closestPointsToObjectsHaveBeenSet = false;
		if path_exists(myPath) {
			path_delete(myPath);
			myPath = -1;
		}
		/*
		exit to different state
		*/
	}
}
if notAtTargetLocation {
	var x_, y_, target_grid_x_, target_grid_y_, path_next_x_, path_next_y_, current_target_to_move_to_x_, current_target_to_move_to_y_, cannot_move_without_better_coordinates_;
	// x and y position of this object on the grid at all times - separate from the true x and y position, 
	// which can change during movement and is not always stuck to the 16/16 grid.
	x_ = floor(x / 16) * 16;
	y_ = floor(y / 16) * 16;
	// x and y cell position on the mp_grid
	target_grid_x_ = originalTargetToMoveToX / 16;
	target_grid_y_ = originalTargetToMoveToY / 16;
	if !closestPointsToObjectsHaveBeenSet {
		closestPointsToObjectsHaveBeenSet = true;
		closestSearchPointToObjectX = originalTargetToMoveToX;
		closestSearchPointToObjectY = originalTargetToMoveToY;
	}
	// Used only if click area does not have any valid spots to move to - in which case,
	// this variable takes over, reassigns originalTargetToMoveTo variables to nearest
	// location within the search area to the object that's also within a plus sign design
	// around the object.
	cannot_move_without_better_coordinates_ = false;
	#endregion


	#region Check for valid start for search
	var direction_to_search_in_, original_direction_to_search_in_;
	// Search towards the object first starting at the click point
	direction_to_search_in_ = floor(point_direction(originalTargetToMoveToX, originalTargetToMoveToY, x_, y_) / 45);
	switch direction_to_search_in_ {
		case 0:
			direction_to_search_in_ = 0;
			break;
		case 1:
			direction_to_search_in_ = 1;
			break;
		case 2:
			direction_to_search_in_ = 1;
			break;
		case 3:
			direction_to_search_in_ = 2;
			break;
		case 4:
			direction_to_search_in_ = 2;
			break;
		case 5:
			direction_to_search_in_ = 3;
			break;
		case 6:
			direction_to_search_in_ = 3;
			break;
		case 7:
			direction_to_search_in_ = 0;
			break;
		case 8:
			direction_to_search_in_ = 0;
			break;
	}
	original_direction_to_search_in_ = direction_to_search_in_;
	groupRowWidth = floor(sqrt(obj_camera_and_gui.numberOfObjectsSelected));
	#endregion

	#region Start the search
	// ---Firstly, determine if this object can search for a path this frame in the first place.
	// Since this code is only run while in the movement state, I can add and remove self from
	// the grid entirely within this script.
	var index_ = -1;
	var can_be_evaluated_this_frame_ = false;
	if !validPathFound || !validLocationFound {
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
	}
	else {
		can_be_evaluated_this_frame_ = true;
	}
	// Secondly, remove self from the grid that tracks object locations - this is so that in case
	// other objects are also looking for a location to move to, it doesn't occupy a space that will
	// become available anyways.
	if !validLocationFound {
		var i;
		if ds_exists(unitGridLocation, ds_type_grid) {
			if ds_grid_height(unitGridLocation) > 1 {
				for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
					var temp_instance_;
					temp_instance_ = ds_grid_get(unitGridLocation, 0, i);
					// If self is found (which is should be, at the beginning of this script), then
					// remove it from the location to look for.
					if (self.id == temp_instance_.id) {
						// If the y location of this object's data in the unitGridLocation is not at
						// the end, just shift all data below that y location upwards by one, and then resize
						// the grid by one.
						if i != (ds_grid_height(unitGridLocation) - 1) {
							ds_grid_set_grid_region(unitGridLocation, unitGridLocation, 0, i + 1, 2, ds_grid_height(unitGridLocation) - 1, 0, i);
							ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) - 1);
						}
						// Otherwise, if the y location of this object's data in the unitGridLocation
						// is at the end, don't bother copying anything, just resize the ds_grid which
						// will remove this object's data from the unitGridLocation ds_grid.
						else {
							ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) - 1);
						}
						break;
					}
				}
			}
			// If the unitGridLocation only contains this object's data, cool! Just delete the ds_grid.
			else if ds_grid_get(unitGridLocation, 0, 0) == self.id {
				ds_grid_destroy(unitGridLocation);
				unitGridLocation = noone;
			}
		}
	}
	// If no list of targets exists, and no target is currently set, that means this target was commanded to A) an empty
	// location or B) a target location invalid to the type of object being commanded, then just run pathfinding as normal.
	if (!ds_exists(objectTargetList, ds_type_list)) && (objectTarget != noone) {
		// Finally, start searching for a preliminary valid location to move to.
		if !validPathFound {
			// If I haven't started a search yet, and if I haven't yet determined original click location isn't valid and started
			// looking for new locations, then start the first search for a valid location to original target.
			if ((can_be_evaluated_this_frame_) && (unitQueueCount < unitQueueMax)) {
				var new_location_needs_to_be_checked_ = false;
				// If the original cell clicked on is already occupied, mark it as invalid and just start a check for a 
				// different location. This only executes if the original click location is invalid, and the search for
				// other locations has not begun yet.
				if searchHasJustBegun {
					if ((right_n_ > 0) || (top_n_ > 0) || (left_n_ > 0) || (bottom_n_ > 0)) {
						searchHasJustBegun = false;
					}
				}
				else {
					new_location_needs_to_be_checked_ = true;
				}
				// If the search has just begun and the box is already occupied, mark a variable as true so that the
				// beginning box will simply be skipped over later and the search will begin.
				if (mp_grid_get_cell(unitGridLocation, target_grid_x_, target_grid_y_) == -1) && (searchHasJustBegun) {
					new_location_needs_to_be_checked_ = true;
					rightWallFound = true;
					topWallFound = true;
					leftWallFound = true;
					bottomWallFound = true;
				}
				// If the search has just begun and the box is not occupied yet, mark it to be searched later.
				else if (mp_grid_get_cell(movementGrid, target_grid_x_, target_grid_y_) == 0) && (searchHasJustBegun) {
					new_location_needs_to_be_checked_ = false;
				}
				// Reset path
				if path_exists(myPath) {
					path_delete(myPath);
					myPath = noone;
				}
				myPath = path_add();
				// If a search has already happened before, and a location seperate from the click location is now needing
				// to be checked, check that location instead.
				if specificLocationNeedsToBeChecked {
					specificLocationNeedsToBeChecked = false;
					current_target_to_move_to_x_ = originalTargetToMoveToX + ((right_n_ - left_n_) * 16);
					current_target_to_move_to_y_ = originalTargetToMoveToY + ((bottom_n_ - top_n_) * 16);
					if mp_grid_path(movementGrid, myPath, x_, y_, current_target_to_move_to_x_, current_target_to_move_to_y_, true) {
						// If a path does exist to the newly checked location, great!
						validPathFound = true;
						targetToMoveToX = current_target_to_move_to_x_;
						targetToMoveToY = current_target_to_move_to_y_;
						new_location_needs_to_be_checked_ = false;
					}
					// Else if the new location to check for is still not valid, mark it as such, reset the x_n_ variables
					// to pick up where they left off in the search, and continue the search.
					else {
						// Reset direction to search in, since the for loop using totalTimesSearched will
						// correctly set it back.
						direction_to_search_in_ = original_direction_to_search_in_;
						// Reset x_n_ variables before starting to make sure I'm not needlessly adding.
						right_n_ = 0;
						top_n_ = 0;
						left_n_ = 0;
						bottom_n_ = 0;
						var i;
						for (i = 0; i < totalTimesSearched; i++) {
							switch direction_to_search_in_ {
								case 0:
									right_n_++;
									break;
								case 1:
									top_n_++;
									break;
								case 2:
									left_n_++;
									break;
								case 3:
									bottom_n_++;
									break;
							}
							direction_to_search_in_++;
							if direction_to_search_in_ > 3 {
								direction_to_search_in_ -= 4;
							}
						}
						// After resetting variables to where they were before pausing the search,
						// I need to increment direction_to_search_in_, since that is normally
						// done at the end of the while loop but is always skipped over in case 
						// another location needs to be checked first.
						direction_to_search_in_++;
						if direction_to_search_in_ > 3 {
							direction_to_search_in_ -= 4;
						}
						new_location_needs_to_be_checked_ = true;
					}
				}
				// If a specific location doesn't need to be checked, or a specific location was already checked
				// and it was found to be invalid, start searching for a new specific location to check, if needed.
				// On the very first time this code is run, it will check for an mp_grid_path to original location
				// and never run that line again.
				if (!specificLocationNeedsToBeChecked) || new_location_needs_to_be_checked_ {
					// Check for a path only if there wasn't already a previous check at a different location
					// in this frame. Since new_location_needs_to_be_checked_ is set to true when the
					// specificLocationNeedsToBeChecked wasn't valid, this will only activate a path check
					// when new_location_needs_to_be_checked_ wasn't activated - when there wasn't a previous
					// check at a different location in this frame. It can also be set to true if the original
					// click location was invalid in the first place
					// MEANING
					// This will only activate at the very beginning, when specificLocationNeedsToBeChecked is set to false
					// and so is new_location_needs_to_be_checked_.
					if !new_location_needs_to_be_checked_ {
						// If a path exists, great!
						if mp_grid_path(movementGrid, myPath, x_, y_, originalTargetToMoveToX, originalTargetToMoveToY, true) {
							validPathFound = true;
							targetToMoveToX = floor(originalTargetToMoveToX / 16) * 16;
							targetToMoveToY = floor(originalTargetToMoveToY / 16) * 16;
							new_location_needs_to_be_checked_ = false;
						}
						// Else if a path doesn't exist, adjust variables to continue searching.
						else {
							searchHasJustBegun = false;
						}
					}
					// Else expand outwards, searching for a wall until one is found, and after one is found, 
					// the empty space after that wall can be a potential check area.
					else if !validPathFound {
						// If all 4 directions to search in aren't exhausted yet, then always continue the
						// search.
						var still_need_to_search_ = true;
						var valid_direction_to_search_in_ = false;
						var forbidden_to_search_ = false;
						while still_need_to_search_ {
							// Increment the search by 1
							switch direction_to_search_in_ {
								case 0:
									right_n_++;
									break;
								case 1:
									top_n_++;
									break;
								case 2:
									left_n_++;
									break;
								case 3:
									bottom_n_++;
									break;
							}
							// If there are no more valid spots to check for, just exit and reset variables,
							// so that the object doesn't move anywhere.
							var iteration_ = 0;
							var invalid_direction_exists_ = false;
							if (rightForbidden) && (topForbidden) && (leftForbidden) && (bottomForbidden) {
								cannot_move_without_better_coordinates_ = true;
								forbidden_to_search_ = true;
								still_need_to_search_ = false;
							}
							// Else if there are still valid spaces that can be checked for, move the search
							// out of any invalid spaces before searching.
							else while (!valid_direction_to_search_in_) && (iteration_ <= 4) {
								iteration_++;
								if (rightForbidden) && (direction_to_search_in_ == 0) {
									direction_to_search_in_++;
									rightWallFound = false;
									invalid_direction_exists_ = true;
								}
								else if (topForbidden) && (direction_to_search_in_ == 1) {
									direction_to_search_in_++;
									topWallFound = false;
									invalid_direction_exists_ = true;
								}
								else if (leftForbidden) && (direction_to_search_in_ == 2) {
									direction_to_search_in_++;
									leftWallFound = false;
									invalid_direction_exists_ = true;
								}
								else if (bottomForbidden) && (direction_to_search_in_ == 3) {
									direction_to_search_in_++;
									bottomWallFound = false;
									invalid_direction_exists_ = true;
								}
								else {
									valid_direction_to_search_in_ = true;
									// Prevent it from going over
									if direction_to_search_in_ > 3 {
										direction_to_search_in_ -= 4;
									}
									if invalid_direction_exists_ {
										switch direction_to_search_in_ {
											case 0:
												right_n_++;
												break;
											case 1:
												top_n_++;
												break;
											case 2:
												left_n_++;
												break;
											case 3:
												bottom_n_++;
												break;
										}
									}
								}
								// Prevent it from going over
								if direction_to_search_in_ > 3 {
									direction_to_search_in_ -= 4;
								}
							}
							if iteration_ > 4 {
								forbidden_to_search_ = true;
								still_need_to_search_ = false;
							}
							// In case the direction_to_search_in_ incrementing has pushed it over max
							// value, just reset it back to what it needs to stay in range with.
							if direction_to_search_in_ > 3 {
								direction_to_search_in_ -= 4;
							}
							// Finally, after incrementing the search and verifying the search location
							// isn't automatically invalid, assign variables.
							switch direction_to_search_in_ {
								case 0:
									current_target_to_move_to_x_ = originalTargetToMoveToX + (right_n_ * 16);
									current_target_to_move_to_y_ = originalTargetToMoveToY;
									break;
								case 1:
									current_target_to_move_to_x_ = originalTargetToMoveToX;
									current_target_to_move_to_y_ = originalTargetToMoveToY - (top_n_ * 16);
									break;
								case 2:
									current_target_to_move_to_x_ = originalTargetToMoveToX - (left_n_ * 16);
									current_target_to_move_to_y_ = originalTargetToMoveToY;
									break;
								case 3:
									current_target_to_move_to_x_ = originalTargetToMoveToX;
									current_target_to_move_to_y_ = originalTargetToMoveToY + (bottom_n_ * 16);
									break;
							}
							// If the new target location to check is invalid, mark it as such so I don't
							// check it later on and throw an error.
							if (current_target_to_move_to_x_ < 0) || (current_target_to_move_to_x_ > (room_width - 16)) || (current_target_to_move_to_y_ < 0) || (current_target_to_move_to_y_ > (room_height - 16)) {
								switch direction_to_search_in_ {
									case 0:
										forbidden_to_search_ = true;
										rightForbidden = true;
										rightWallFound = false;
										break;
									case 1:
										forbidden_to_search_ = true;
										topForbidden = true;
										topWallFound = false;
										break;
									case 2:
										forbidden_to_search_ = true;
										leftForbidden = true;
										leftWallFound = false;
										break;
									case 3:
										forbidden_to_search_ = true;
										bottomForbidden = true;
										bottomWallFound = false;
										break;
								}
							}
							// If the direction to search in is a valid direction
							if !forbidden_to_search_ {
								// If the current point to test is closer than the previously closest point to test, and
								// importantly, as long as the current point to test is not the original click area, then
								// set that point as the closest point to the object, in case its needed later.
								if (point_distance(current_target_to_move_to_x_, current_target_to_move_to_y_, x_, y_) < point_distance(closestSearchPointToObjectX, closestSearchPointToObjectY, x_, y_)) && !((current_target_to_move_to_x_ == originalTargetToMoveToX) && (current_target_to_move_to_y_ == originalTargetToMoveToY)) {
									if (abs(current_target_to_move_to_x_ - x_) < 16) || (abs(current_target_to_move_to_y_ - y_) < 16) {
										closestSearchPointToObjectX = current_target_to_move_to_x_;
										closestSearchPointToObjectY = current_target_to_move_to_y_;
									}
								}
								// If the location to be checked is a wall, mark it as such and watch out for
								// the next available spot.
								if mp_grid_get_cell(movementGrid, (current_target_to_move_to_x_ / 16), (current_target_to_move_to_y_ / 16)) == -1 {
									switch direction_to_search_in_ {
										case 0:
											rightWallFound = true;
											break;
										case 1:
											topWallFound = true;
											break;
										case 2:
											leftWallFound = true;
											break;
										case 3:
											bottomWallFound = true;
											break;
									}
								}
								// Else if no wall is found, I should check if a previous wall was found. If one
								// already was, then I can mark this spot as an area to check next.
								else {
									if (direction_to_search_in_ == 0) && (rightWallFound) {
										rightWallFound = false;
										specificLocationNeedsToBeChecked = true;
										specificLocationToBeCheckedX = current_target_to_move_to_x_;
										specificLocationToBeCheckedY = current_target_to_move_to_y_;
										still_need_to_search_ = false;
									}
									else if (direction_to_search_in_ == 1) && (topWallFound) {
										topWallFound = false;
										specificLocationNeedsToBeChecked = true;
										specificLocationToBeCheckedX = current_target_to_move_to_x_;
										specificLocationToBeCheckedY = current_target_to_move_to_y_;
										still_need_to_search_ = false;
									}
									else if (direction_to_search_in_ == 2) && (leftWallFound) {
										leftWallFound = false;
										specificLocationNeedsToBeChecked = true;
										specificLocationToBeCheckedX = current_target_to_move_to_x_;
										specificLocationToBeCheckedY = current_target_to_move_to_y_;
										still_need_to_search_ = false;
									}
									else if (direction_to_search_in_ == 3) && (bottomWallFound) {
										bottomWallFound = false;
										specificLocationNeedsToBeChecked = true;
										specificLocationToBeCheckedX = current_target_to_move_to_x_;
										specificLocationToBeCheckedY = current_target_to_move_to_y_;
										still_need_to_search_ = false;
									}
								}
							}
				
							// If a new location needs to be checked, search that new location.
							// This is redundant, but I do the check just in case. I'll remove after
							// I'm sure the other code works.
							if specificLocationNeedsToBeChecked {
								still_need_to_search_ = false;
							}
							// ---Reset and increment variables that need it before the while loop continues.---
							// Only increment direction_to_search_in_ if I still need to search for a valid
							// location. Otherwise, don't increment it.
							if still_need_to_search_ {
								direction_to_search_in_++;
								if direction_to_search_in_ > 3 {
									direction_to_search_in_ -= 4;
								}
							}
							// If I don't need to search anymore, reset right_n_, top_n_, left_n_, and bottom_n_
							// except for the x_n_ that corresponds to the current direction. All x_n_'s will be 
							// set back to orgiinal values in case I still need to search later.
							else switch direction_to_search_in_ {
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
							// Increment an important variable
							totalTimesSearched++;
							// Reset local variables that need resetting
							forbidden_to_search_ = false;
						}
					}
				}
			}
		}
		if cannot_move_without_better_coordinates_ {
			cannot_move_without_better_coordinates_ = false;
			targetToMoveToX = floor(closestSearchPointToObjectX / 16) * 16;
			targetToMoveToY = floor(closestSearchPointToObjectY / 16) * 16;
			originalTargetToMoveToX = targetToMoveToX;
			originalTargetToMoveToY = targetToMoveToY;
			validPathFound = false;
			validLocationFound = false;
			needToStartGridSearch = true;
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
			searchHasJustBegun = true;
			totalTimesSearched = 0;
			if path_exists(myPath) {
				path_delete(myPath);
				myPath = -1;
			}
		}
	}
	// Else if either a list of targets exists (this object was commanded to move towards a target)
	// or its target variable, objectTarget, is already set, then just reset variables that allow
	// next section of code to run.
	else {
		validPathFound = true;
	}


	#endregion
	if validPathFound {
		if needToStartGridSearch {
			needToStartGridSearch = false;
			validLocationFound = false;
			// Only reset variables if this is the first time running this code.
			cannot_move_without_better_coordinates_ = false;
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
			searchHasJustBegun = true;
			totalTimesSearched = 0;
			if path_exists(myPath) {
				path_delete(myPath);
				myPath = -1;
			}
		}
		// Find a valid location to move to and then move there.
		// I'll be reusing a lot of variables in the previous section, but its fine
		// since they're no longer used otherwise after the first section is complete.
		
		var i, original_location_is_valid_;
		original_location_is_valid_ = true;
		if ds_exists(unitGridLocation, ds_type_grid) {
			if ds_grid_height(unitGridLocation) > 0 {
				for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
					var temp_instance_, temp_instance_x_, temp_instance_y_;
					temp_instance_ = ds_grid_get(unitGridLocation, 0, i);
					temp_instance_x_ = ds_grid_get(unitGridLocation, 1, i);
					temp_instance_y_ = ds_grid_get(unitGridLocation, 2, i);
					if (self.id != temp_instance_.id) && (x == temp_instance_x_) && (y == temp_instance_y_) {
						original_location_is_valid_ = false;
					}
				}
			}
		}
		if (point_distance(x, y, targetToMoveToX, targetToMoveToY) >= (movementSpeed * 2)) || (!original_location_is_valid_) {
			if !validLocationFound {
				if ((can_be_evaluated_this_frame_) && (unitQueueCount < unitQueueMax)) {
					var still_need_to_search_;
					still_need_to_search_ = true;
					while still_need_to_search_ {
						// If, after checking for a specific location, it still wasn't valid,
						// move on and continue the search.
						if still_need_to_search_ {
							// As long as the object doesn't have a specific target to focus, perform normal
							// pathfinding.
							if (!ds_exists(objectTargetList, ds_type_list)) && (objectTarget != noone) {
								squareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
								// Top edge, moving left to right
								if squareIteration < squareEdgeSize {
									// Start at the left corner and move right
									tempCheckX = targetToMoveToX - (squareSizeIncreaseCount * 16) + (squareIteration * 16);
									// Shift the temporary check upwards to the top edge
									tempCheckY = targetToMoveToY - (squareSizeIncreaseCount * 16);
								}
								// Right edge, moving top to bottom
								else if squareIteration < (squareEdgeSize * 2) {
									// Shift the temporary check rightwards to the right edge
									tempCheckX = targetToMoveToX + (squareSizeIncreaseCount * 16);
									// Start at the top right corner and move down. Subtracted the size
									// of one side from the coordinates, since I've already iterated through
									// a side.
									tempCheckY = targetToMoveToY - (squareSizeIncreaseCount * 16) + (squareIteration * 16) - (((squareSizeIncreaseCount * 2) + 1) * 16);
								}
								// Bottom edge, moving right to left
								else if squareIteration < (squareEdgeSize * 3) {
									// Start at the bottom right corner, and move left. How it works:
									// Start at origin point targetToMoveToX. Shift over to the right
									// edge. Move left by subtracting squareIteration * 16. Adjust for
									// the previous two sides that have already been run through by
									// adding the equivalent pixel size of two sides to the coordinates.
									tempCheckX = targetToMoveToX + (squareSizeIncreaseCount * 16) - (squareIteration * 16) + ((((squareSizeIncreaseCount * 2) + 1) * 16) * 2);
									// Shift the temporary check downwards to the bottom edge
									tempCheckY = targetToMoveToY + (squareSizeIncreaseCount * 16);
								}
								// Left edge, moving bottom to top
								else if squareIteration < (squareEdgeSize * 4) {
									// Shift the temporary check leftwards to the left edge
									tempCheckX = targetToMoveToX - (squareSizeIncreaseCount * 16);
									// Start at the bottom left corner and move up. Works in the same
									// way the check in the else if statement above works with the x axis.
									tempCheckY = targetToMoveToY + (squareSizeIncreaseCount * 16) - (squareIteration * 16) + ((((squareSizeIncreaseCount * 2) + 1) * 16) * 3);
								}
							
								// Iterate the count that moves along the edges up by one
								squareIteration++;
								// If the iteration count reaches the max amount of squares on the perimeter
								// of the search square, reset the iteration count, increment the size increase
								// count by one, and set squareEdgeSize to equal the correct values based off
								// of the new squareSizeIncreaseCount value.
								if squareIteration >= ((squareSizeIncreaseCount * 2) + 1) * 4 {
									squareIteration = 0;
									squareSizeIncreaseCount++;
									squareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
								}
								// If the iteration is divisible by the size of an edge, meaning its at a corner,
								// skip the corner. The previous frame will have already searched that corner -
								// this skips redundant checks.
								if (squareIteration mod ((squareSizeIncreaseCount * 2) + 1) == 0) {
									squareIteration++;
								}
								// If the iteration count reaches the max amount of squares on the perimeter
								// of the search square, reset the iteration count, increment the size increase
								// count by one, and set squareEdgeSize to equal the correct values based off
								// of the new squareSizeIncreaseCount value.
								if squareIteration == ((squareSizeIncreaseCount * 2) + 1) * 4 {
									squareIteration = 0;
									squareSizeIncreaseCount++;
									squareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
								}
							
						
								// Now that y axis has been incremented, perform preliminary searches and
								// check for a path, or increment x_n_ further until correct location found.
								// First, check to see if the cell itself is a valid location. If not, its
								// automatically excluded.
								if mp_grid_get_cell(movementGrid, tempCheckX / 16, tempCheckY / 16) == 0 {
									var i, temp_instance_, temp_instance_x_, temp_instance_y_;
									var location_occupied_ = false;
									// Check to see if any object currently has that space occupied, and if not,
									// occupy it.
									if ds_exists(unitGridLocation, ds_type_grid) {
										for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
											temp_instance_ = ds_grid_get(unitGridLocation, 0, i);
											temp_instance_x_ = ds_grid_get(unitGridLocation, 1, i);
											temp_instance_y_ = ds_grid_get(unitGridLocation, 2, i);
											if (temp_instance_.id != self.id) && (temp_instance_x_ == tempCheckX) && (temp_instance_y_ == tempCheckY) {
												location_occupied_ = true;
											}
										}
										if !location_occupied_ {
											specificLocationNeedsToBeChecked = true;
											specificLocationToBeCheckedX = tempCheckX;
											specificLocationToBeCheckedY = tempCheckY;
										}
									}
									else {
										specificLocationNeedsToBeChecked = true;
										specificLocationToBeCheckedX = tempCheckX;
										specificLocationToBeCheckedY = tempCheckY;
									}
								}
							}
							// Else if the object running this script has an active target to move to, then
							// move to an adjacent spot next to that target. If none is found, search through
							// the objectTargetList (if it exists) for any other valid targets within range of 
							// the original click location, and if no valid target exists, or no valid adjacent
							// spot to any valid targets exist, reset variables and restart this script as 
							// normal pathfinding without a target.
							else {
								
							}
						}
						// If I need to check for a specific location, check it
						if specificLocationNeedsToBeChecked {
							specificLocationNeedsToBeChecked = false;
							if path_exists(myPath) {
								path_delete(myPath);
								myPath = noone;
							}
							myPath = path_add();
							if mp_grid_path(movementGrid, myPath, x, y, specificLocationToBeCheckedX, specificLocationToBeCheckedY, true) {
								still_need_to_search_ = false;
								validPathFound = true;
								targetToMoveToX = specificLocationToBeCheckedX;
								targetToMoveToY = specificLocationToBeCheckedY;
								validLocationFound = true;
								// Add self back to the unitGridLocation, so that other objects don't
								// move on the same square.
								if ds_exists(unitGridLocation, ds_type_grid) {
									var i, self_is_found_;
									self_is_found_ = noone;
									if ds_grid_height(unitGridLocation) > 0 {
										for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
											var temp_instance_;
											temp_instance_ = ds_grid_get(unitGridLocation, 0, i);
											if self.id == temp_instance_.id {
												self_is_found_ = i;
												break;
											}
										}
									}
									// If self is found in the ds_grid, which it shouldn't be, then overwrite
									// the existing values and replace with correct values. This is just here
									// as redundancy.
									if self_is_found_ != noone {
										//ds_grid_set(unitGridLocation, 1, self_is_found_, targetToMoveToX);
										//ds_grid_set(unitGridLocation, 2, self_is_found_, targetToMoveToY);
									}
									// If self doesn't exist in the grid, which it normally shouldn't, then
									// resize the grid to accomodate it and add values.
									else {
										ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) + 1);
										ds_grid_set(unitGridLocation, 0, ds_grid_height(unitGridLocation) - 1, self.id);
										ds_grid_set(unitGridLocation, 1, ds_grid_height(unitGridLocation) - 1, targetToMoveToX);
										ds_grid_set(unitGridLocation, 2, ds_grid_height(unitGridLocation) - 1, targetToMoveToY);
									}
								}
								// If the ds_grid doesn't exist, which is possible (but unlikely), then just recreate
								// the grid and add the object's info.
								else {
									unitGridLocation = ds_grid_create(3, 1);
									ds_grid_set(unitGridLocation, 0, 0, self.id);
									ds_grid_set(unitGridLocation, 1, 0, targetToMoveToX);
									ds_grid_set(unitGridLocation, 2, 0, targetToMoveToY);
								}
							}
							else {
								still_need_to_search_ = false;
							}
						}
					}
				}
			}
			// Else if a valid location exists, no need to search for one, just move.
			else {
				if path_get_number(myPath) > 1 {
					var x_vector_, y_vector_;
					x_vector_ = lengthdir_x(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8));
					y_vector_ = lengthdir_y(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8));
					x += x_vector_;
					y += y_vector_;
				}
				else if point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) > movementSpeed * 2 {
					var x_vector_, y_vector_;
					x_vector_ = lengthdir_x(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)));
					y_vector_ = lengthdir_y(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)));
					x += x_vector_;
					y += y_vector_;
				}
				else {
					path_delete(myPath);
					myPath = noone;
					validPathFound = true;
					validLocationFound = true;
					x = floor(targetToMoveToX / 16) * 16;
					y = floor(targetToMoveToY / 16) * 16;
				}
				if ((path_get_number(myPath) > 1) && (point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) <= sprite_width)) || ((path_get_number(myPath) == 1) && (point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) <= movementSpeed)) {
					path_delete_point(myPath, 0);
				}
			}
		}
		// Else if point distance between object and target location is less than the move
		// speed during two frames, just teleport the object to that location and reset ALL
		// variables.
		else {
			notAtTargetLocation = false;
			validLocationFound = true;
			validPathFound = true;
			x = targetToMoveToX;
			y = targetToMoveToY;
			cannot_move_without_better_coordinates_ = false;
			notAtTargetLocation = false;
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
			squareEdgeSize = 0;
			squareSizeIncreaseCount = 0;
			squareIteration = 0;
			tempCheckX = -1;
			tempCheckY = -1;
			groupRowWidth = 0;
			specificLocationNeedsToBeChecked = false;
			specificLocationToBeCheckedX = -1;
			specificLocationToBeCheckedY = -1;
			searchHasJustBegun = true;
			totalTimesSearched = 0;
			closestPointsToObjectsHaveBeenSet = false;
			if path_exists(myPath) {
				path_delete(myPath);
				myPath = -1;
			}
			// Just in case the object was already close enough to move location,
			// and its still in the middle of this move script (meaning it won't be
			// in the ds_grid containing all moving object's locations), add itself
			// to that grid.
			if ds_exists(unitGridLocation, ds_type_grid) {
				var i, self_is_found_;
				self_is_found_ = noone;
				if ds_grid_height(unitGridLocation) > 0 {
					for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
						var temp_instance_;
						temp_instance_ = ds_grid_get(unitGridLocation, 0, i);
						if self.id == temp_instance_.id {
							self_is_found_ = i;
							break;
						}
					}
				}
				// If self is found in the ds_grid, which it shouldn't be, then overwrite
				// the existing values and replace with correct values. This is just here
				// as redundancy.
				if self_is_found_ != noone {
					ds_grid_set(unitGridLocation, 1, self_is_found_, targetToMoveToX);
					ds_grid_set(unitGridLocation, 2, self_is_found_, targetToMoveToY);
				}
				// If self doesn't exist in the grid, which it normally shouldn't, then
				// resize the grid to accomodate it and add values.
				else {
					ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) + 1);
					ds_grid_set(unitGridLocation, 0, ds_grid_height(unitGridLocation) - 1, self.id);
					ds_grid_set(unitGridLocation, 1, ds_grid_height(unitGridLocation) - 1, targetToMoveToX);
					ds_grid_set(unitGridLocation, 2, ds_grid_height(unitGridLocation) - 1, targetToMoveToY);
				}
			}
			// If the ds_grid doesn't exist, which is possible (but unlikely), then just recreate
			// the grid and add the object's info.
			else {
				unitGridLocation = ds_grid_create(3, 1);
				ds_grid_set(unitGridLocation, 0, 0, self.id);
				ds_grid_set(unitGridLocation, 1, 0, targetToMoveToX);
				ds_grid_set(unitGridLocation, 2, 0, targetToMoveToY);
			}
			// After resetting all necessary variables, revert back to idle.
			// If no action is commanded {
				//currentAction = worker.idle;
			//}
		}
	}
}
// Else if its at target location, then exit script.
else {
	notAtTargetLocation = false;
	validLocationFound = true;
	validPathFound = true;
	cannot_move_without_better_coordinates_ = false;
	notAtTargetLocation = false;
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
	squareEdgeSize = 0;
	squareSizeIncreaseCount = 0;
	squareIteration = 0;
	tempCheckX = -1;
	tempCheckY = -1;
	groupRowWidth = 0;
	specificLocationNeedsToBeChecked = false;
	specificLocationToBeCheckedX = -1;
	specificLocationToBeCheckedY = -1;
	searchHasJustBegun = true;
	totalTimesSearched = 0;
	closestPointsToObjectsHaveBeenSet = false;
	if path_exists(myPath) {
		path_delete(myPath);
		myPath = -1;
	}
	/*
	exit to different state
	*/
}



/*
Variables to be reset at the necessary times
x = targetToMoveToX;
y = targetToMoveToY;
cannot_move_without_better_coordinates_ = false;
notAtTargetLocation = false;
needToStartGridSearch = true;
squareEdgeSize = 0;
squareSizeIncreaseCount = 0;
squareIteration = 0;
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
groupRowWidth = 0;
specificLocationNeedsToBeChecked = false;
specificLocationToBeCheckedX = -1;
specificLocationToBeCheckedY = -1;
searchHasJustBegun = true;
totalTimesSearched = 0;
closestPointsToObjectsHaveBeenSet = false;
myPath = -1;
*/


