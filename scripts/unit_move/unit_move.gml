///@function								target_next_object();
///@description								If there are other entries in the target list, remove the entry 
///											that turned out to be an invalid target and search for the next entry.

function target_next_object() {
	if ds_exists(objectTargetList, ds_type_list) {
		if ds_list_size(objectTargetList) >= 1 {
			ds_list_delete(objectTargetList, 0);
			if !is_undefined(ds_list_find_value(objectTargetList, 0)) {
				while (ds_exists(objectTargetList, ds_type_list)) && ((is_undefined(ds_list_find_value(objectTargetList, 0))) || (!instance_exists(ds_list_find_value(objectTargetList, 0)))) {
					if ds_list_size(objectTargetList) > 1 {
						ds_list_delete(objectTargetList, 0);
					}
					else {
						objectCurrentCommand = "Move";
						targetToMoveToX = originalTargetToMoveToX;
						targetToMoveToY = originalTargetToMoveToY;
						squareIteration = 0;
						squareTrueIteration = 0;
						squareSizeIncreaseCount = 0;
						baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
						groupDirectionToMoveInAdjusted = 0;
						objectTarget = noone;
						if ds_exists(objectTargetList, ds_type_list) {
							ds_list_destroy(objectTargetList);
							objectTargetList = noone;
						}
					}
				}
				if ds_exists(objectTargetList, ds_type_list) {
					objectTarget = ds_list_find_value(objectTargetList, 0);
					targetToMoveToX = floor(objectTarget.x / 16) * 16;
					targetToMoveToY = floor(objectTarget.y / 16) * 16;
					squareIteration = 0;
					squareTrueIteration = 0;
					squareSizeIncreaseCount = 0;
					baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
					// Variables specifically used by object to move
					changeVariablesWhenCloseToTarget = true;
					notAtTargetLocation = true;
					validLocationFound = true;
					validPathFound = false;
					specificLocationNeedsToBeChecked = false;
					specificLocationToBeCheckedX = targetToMoveToX;
					specificLocationToBeCheckedY = targetToMoveToY;
					tempCheckX = targetToMoveToX;
					tempCheckY = targetToMoveToY;
					groupDirectionToMoveInAdjusted = 0;
				}
			}
			else {
				objectCurrentCommand = "Move";
				targetToMoveToX = originalTargetToMoveToX;
				targetToMoveToY = originalTargetToMoveToY;
				squareIteration = 0;
				squareTrueIteration = 0;
				squareSizeIncreaseCount = 0;
				baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
				groupDirectionToMoveInAdjusted = 0;
				objectTarget = noone;
				if ds_exists(objectTargetList, ds_type_list) {
					ds_list_destroy(objectTargetList);
					objectTargetList = noone;
				}
			}
		}
		else {
			objectCurrentCommand = "Move";
			objectTargetList = noone;
			objectTarget = noone;
			targetToMoveToX = originalTargetToMoveToX;
			targetToMoveToY = originalTargetToMoveToY;
			squareIteration = 0;
			squareTrueIteration = 0;
			squareSizeIncreaseCount = 0;
			baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
			groupDirectionToMoveInAdjusted = 0;
			objectTarget = noone;
			if ds_exists(objectTargetList, ds_type_list) {
				ds_list_destroy(objectTargetList);
				objectTargetList = noone;
			}
		}
	}
	else {
		if objectCurrentCommand == "Attack" {
			check_for_new_target();
		}
	}
	if !ds_exists(objectTargetList, ds_type_list) {
		objectCurrentCommand = "Move";
		targetToMoveToX = originalTargetToMoveToX;
		targetToMoveToY = originalTargetToMoveToY;
		squareIteration = 0;
		squareTrueIteration = 0;
		squareSizeIncreaseCount = 0;
		baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
		groupDirectionToMoveInAdjusted = 0;
		objectTarget = noone;
		if ds_exists(objectTargetList, ds_type_list) {
			ds_list_destroy(objectTargetList);
			objectTargetList = noone;
		}
	}
}




///@function								unit_move();
///@description							Expanded upon below
/*
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

function unit_move() {
	if !justSpawned {
		if instance_exists(objectTarget) {
			if !path_exists(myPath) {
				if distance_to_object(objectTarget) < objectRange {
					// Change below to set target to closest location within a square
					// checking each corner of x+/-8 and y+/-8.
					var original_x_ = x;
					var original_y_ = y;
					var point_distance_ = distance_to_object(objectTarget);
					var choice_ = 0;
					x = original_x_ + 8;
					y = original_y_ + 8;
					if (distance_to_object(objectTarget) <= point_distance_) && (position_empty(floor(x / 16) * 16, floor(y / 16) * 16)) {
						point_distance_ = distance_to_object(objectTarget);
						choice_ = 1;
					}
					x = original_x_ + 8;
					y = original_y_ - 8;
					if (distance_to_object(objectTarget) < point_distance_) && (position_empty(floor(x / 16) * 16, floor(y / 16) * 16)) {
						point_distance_ = distance_to_object(objectTarget);
						choice_ = 2;
					}
					x = original_x_ - 8;
					y = original_y_ + 8;
					if (distance_to_object(objectTarget) < point_distance_) && (position_empty(floor(x / 16) * 16, floor(y / 16) * 16)) {
						point_distance_ = distance_to_object(objectTarget);
						choice_ = 3;
					}
					x = original_x_ - 8;
					y = original_y_ - 8;
					if (distance_to_object(objectTarget) < point_distance_) && (position_empty(floor(x / 16) * 16, floor(y / 16) * 16)) {
						point_distance_ = distance_to_object(objectTarget);
						choice_ = 4;
					}
					x = original_x_;
					y = original_y_;
					switch choice_ {
						case 0:
							targetToMoveToX = floor(x / 16) * 16;
							targetToMoveToY = floor(y / 16) * 16;
							break;
						case 1:
							targetToMoveToX = floor((x + 8) / 16) * 16;
							targetToMoveToY = floor((y + 8) / 16) * 16;
							break;
						case 2:
							targetToMoveToX = floor((x + 8) / 16) * 16;
							targetToMoveToY = floor((y - 8) / 16) * 16;
							break;
						case 3:
							targetToMoveToX = floor((x - 8) / 16) * 16;
							targetToMoveToY = floor((y + 8) / 16) * 16;
							break;
						case 4:
							targetToMoveToX = floor((x - 8) / 16) * 16;
							targetToMoveToY = floor((y - 8) / 16) * 16;
							break;
					}
					changeVariablesWhenCloseToTarget = false;
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
					tempCheckX = -1;
					tempCheckY = -1;
					groupRowWidth = 0;
					specificLocationNeedsToBeChecked = false;
					specificLocationToBeCheckedX = -1;
					specificLocationToBeCheckedY = -1;
					searchHasJustBegun = true;
					totalTimesSearched = 0;
					closestPointsToObjectsHaveBeenSet = false;
					movementLeaderOrFollowing = noone;
					if path_exists(myPath) {
						path_delete(myPath);
						myPath = -1;
					}
				}
			}
		}
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
					for (i = 0; i < ds_grid_height(unitGridLocation); i++) {
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
				changeVariablesWhenCloseToTarget = true;
				notAtTargetLocation = false;
				validLocationFound = true;
				validPathFound = true;
				cannot_move_without_better_coordinates_ = false;
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
				movementLeaderOrFollowing = noone;
				if path_exists(myPath) {
					path_delete(myPath);
					myPath = -1;
				}
				if objectCurrentCommand == "Move" {
					objectCurrentCommand = "Idle";
					currentAction = unitAction.idle;
				}
				else if objectCurrentCommand == "Attack" {
					currentAction = unitAction.attack;
				}
				else if objectCurrentCommand == "Mine" {
					currentAction = unitAction.mine;
				}
				else if objectCurrentCommand == "Chop" {
					currentAction = unitAction.chop;
				}
				else if objectCurrentCommand == "Farm" {
					currentAction = unitAction.farm;
				}
				else if objectCurrentCommand == "Ruby Mine" {
					currentAction = unitAction.mine;
				}
			}
		}
	}
	if notAtTargetLocation {
		/// Initialize just a few more variables
		var x_, y_, target_grid_x_, target_grid_y_, current_target_to_move_to_x_, current_target_to_move_to_y_, cannot_move_without_better_coordinates_;
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
		// location within the search area to the object that's also within a plus sign shape
		// around the object.
		cannot_move_without_better_coordinates_ = false;
		
		
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
		groupRowWidth = floor(sqrt(obj_inputs.numberOfObjectsSelected));
		#endregion

		#region Start the search
		// ---Firstly, determine if this object can search for a path this frame in the first place.
		// Since this code is only run while in the movement state, I can add and remove self from
		// the grid entirely within this script.
		var index_ = -1;
		var can_be_evaluated_this_frame_ = false;
		if !validPathFound || !validLocationFound {
			if ds_exists(unitQueueForPathfindingList, ds_type_list) {
				if (unitQueueTimer == unitQueueTimerStart) {
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
			}
			else {
				if (unitQueueTimer == unitQueueTimerStart) {
					index_ = 0;
					unitQueueForPathfindingList = ds_list_create();
					ds_list_add(unitQueueForPathfindingList, self.id);
					unitQueueCount++;
					can_be_evaluated_this_frame_ = true;
				}
			}
			// Move the unit while waiting for a path to be found.
			if point_distance(x, y, targetToMoveToX, targetToMoveToY) > groupRowWidth * 16 {
				var orig_x_, orig_y_;
				orig_x_ = x;
				orig_y_ = y;
				mp_potential_step(targetToMoveToX, targetToMoveToY, movementSpeed, false);
				if objectRealTeam != 1 {
					var yeet_ = 1;
				}
				if (mp_grid_get_cell(movementGrid, floor(x / 16), floor(y / 16)) == -1) || (mp_grid_get_cell(movementGrid, floor((x + 15) / 16), floor(y / 16)) == -1) || (mp_grid_get_cell(movementGrid, floor((x + 15) / 16), floor((y + 15) / 16)) == -1) || (mp_grid_get_cell(movementGrid, floor(x / 16), floor((y + 15) / 16)) == -1) {
					x = orig_x_;
					y = orig_y_;
				}
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
					for (i = 0; i < ds_grid_height(unitGridLocation); i++) {
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
		// Only check for a straight shot to the target location if the current command is to move. Otherwise, I should be
		// checking for a path anyways to resources or enemies.
		if (line_of_sight_exists_to_target(x_, y_, targetToMoveToX, targetToMoveToY) && line_of_sight_exists_to_target(x_ + 15, y_ + 15, targetToMoveToX, targetToMoveToY)) && (objectCurrentCommand == "Move") {
			validPathFound = true;
			can_be_evaluated_this_frame_ = true;
		}
		// If no list of targets exists, and no target is currently set, that means this target was commanded to A) an empty
		// location or B) a target location invalid to the type of object being commanded, then just run pathfinding as normal.
		if (!ds_exists(objectTargetList, ds_type_list)) && (objectTarget == noone) {
			
			// if the unit is a follower, it shouldn't go through this process of determining a path, it should wait here with 
			// validPathFound and validLocationFound set to false until the leader finds a path, at which point it should set
			// validPathFound to true and keep validLocationFound to false until a valid path to the appended location can be
			// found. validPathFound is subsequently set in the else statement after the below if statement.
			// Finally, start searching for a preliminary valid location to move to.
			if !validPathFound && (movementLeaderOrFollowing == "Leader") {
				// If I haven't started a search yet, and if I haven't yet determined original click location isn't valid and started
				// looking for new locations, then start the first search for a valid location to original target.
				if ((can_be_evaluated_this_frame_) && (unitQueueCount < unitQueueMax)) {
					if (unitQueueTimer == unitQueueTimerStart) {
						unitQueueTimer--;
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
							determine_leader_or_follower();
						}
						// If the search has just begun and the box is not occupied yet, mark it to be searched later.
						else if (mp_grid_get_cell(movementGrid, target_grid_x_, target_grid_y_) == 0) && (searchHasJustBegun) {
							new_location_needs_to_be_checked_ = false;
							determine_leader_or_follower();
						}
						// Reset path
						if path_exists(myPath) {
							path_delete(myPath);
							myPath = noone;
						}
						myPath = path_add();
						// If a search has already happened before, and a location seperate from the click location is now needing
						// to be checked, check that location instead.
						var specificLocationNeedsToBeChecked_was_true_ = false;
						if specificLocationNeedsToBeChecked {
							specificLocationNeedsToBeChecked = false;
							specificLocationNeedsToBeChecked_was_true_ = true;
							current_target_to_move_to_x_ = originalTargetToMoveToX + ((right_n_ - left_n_) * 16);
							current_target_to_move_to_y_ = originalTargetToMoveToY + ((bottom_n_ - top_n_) * 16);
							// I can check here to see if a direct line of sight exists, and if so, I don't
							// even need to check for a path below, just set the variables that are set below
							// and include a movement section using mp_potential to move the unit.
							if ((line_of_sight_exists_to_target(x_, y_, current_target_to_move_to_x_, current_target_to_move_to_y_)) && (line_of_sight_exists_to_target(x_ + 15, y_ + 15, current_target_to_move_to_x_, current_target_to_move_to_y_))) && (objectCurrentCommand == "Move") {
								// Reset path
								if path_exists(myPath) {
									path_delete(myPath);
									myPath = noone;
								}
								// If a direct line of sight exists, no need to check for a path, just go.
								validPathFound = true;
								targetToMoveToX = current_target_to_move_to_x_;
								targetToMoveToY = current_target_to_move_to_y_;
								new_location_needs_to_be_checked_ = false;
							}
							else if (mp_grid_path(movementGrid, myPath, x_, y_, current_target_to_move_to_x_, current_target_to_move_to_y_, true)) {
								// If a path does exist to the newly checked location, great!
								validPathFound = true;
								targetToMoveToX = current_target_to_move_to_x_;
								targetToMoveToY = current_target_to_move_to_y_;
								new_location_needs_to_be_checked_ = false;
							}
							// Else if the new location to check for is still not valid, mark it as such, reset the x_n_ variables
							// to pick up where they left off in the search, and continue the search.
							else {
								// Reset path
								if path_exists(myPath) {
									path_delete(myPath);
									myPath = noone;
								}
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
						if (!specificLocationNeedsToBeChecked_was_true_) || new_location_needs_to_be_checked_ {
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
								if path_exists(myPath) {
									path_delete(myPath);
									myPath = noone;
								}
								myPath = path_add();
								// I can check here to see if a direct line of sight exists, and if so, I don't
								// even need to check for a path below, just set the variables that are set below
								// and include a movement section using mp_potential to move the unit.
								if ((line_of_sight_exists_to_target(x_, y_, originalTargetToMoveToX, originalTargetToMoveToY)) && (line_of_sight_exists_to_target(x_ + 15, y_ + 15, originalTargetToMoveToX, originalTargetToMoveToY))) && (objectCurrentCommand == "Move") {
									// Reset path
									if path_exists(myPath) {
										path_delete(myPath);
										myPath = noone;
									}
									// If a direct line of sight exists, no need to check for a path, just go.
									validPathFound = true;
									targetToMoveToX = floor(originalTargetToMoveToX / 16) * 16;;
									targetToMoveToY = floor(originalTargetToMoveToY / 16) * 16;
									new_location_needs_to_be_checked_ = false;
								}
								// If a path exists, great!
								else if mp_grid_path(movementGrid, myPath, x_, y_, originalTargetToMoveToX, originalTargetToMoveToY, true) {
									validPathFound = true;
									targetToMoveToX = floor(originalTargetToMoveToX / 16) * 16;
									targetToMoveToY = floor(originalTargetToMoveToY / 16) * 16;
									new_location_needs_to_be_checked_ = false;
								}
								// Else if a path doesn't exist, adjust variables to continue searching.
								else {
									searchHasJustBegun = false;
									// Reset path
									if path_exists(myPath) {
										path_delete(myPath);
										myPath = noone;
									}
								}
							}
							// Else expand outwards, searching for a wall until one is found, and after one is found, 
							// the empty space after that wall can be a potential check area.
							else if !validPathFound {
								// Reset path
								if path_exists(myPath) {
									path_delete(myPath);
									myPath = noone;
								}
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
			}
			// Else if the unit is set to follow another unit, determine various situations where it should or should not 
			// wait for the leader unit to create a path to follow along.
			else if movementLeaderOrFollowing != "Leader" && instance_exists(movementLeaderOrFollowing) {
				if ((line_of_sight_exists_to_target(x, y, targetToMoveToX, targetToMoveToY)) && (line_of_sight_exists_to_target(x + 15, y + 15, targetToMoveToX, targetToMoveToY))) && (!path_exists(myPath)) {
					validPathFound = false;
					movementLeaderOrFollowing = "Leader";
				}
				else if path_exists(movementLeaderOrFollowing.myPath) {
					validPathFound = true;
				}
				else if (movementLeaderOrFollowing.currentAction == unitAction.move) && (point_distance(movementLeaderOrFollowing.x, movementLeaderOrFollowing.y, movementLeaderOrFollowing.targetToMoveToX, movementLeaderOrFollowing.targetToMoveToY) > movementSpeed) {
					validPathFound = true;
				}
				else if (movementLeaderOrFollowing.currentAction != unitAction.move) && path_exists(myPath) {
					validPathFound = true;
				}
				else if !path_exists(myPath) {
					validPathFound = false;
					movementLeaderOrFollowing = "Leader";
				}
			}
			else if movementLeaderOrFollowing != "Leader" && !instance_exists(movementLeaderOrFollowing) {
				validPathFound = false;
				movementLeaderOrFollowing = "Leader";
			}
			if cannot_move_without_better_coordinates_ {
				cannot_move_without_better_coordinates_ = false;
				targetToMoveToX = floor(closestSearchPointToObjectX / 16) * 16;
				targetToMoveToY = floor(closestSearchPointToObjectY / 16) * 16;
				originalTargetToMoveToX = targetToMoveToX;
				originalTargetToMoveToY = targetToMoveToY;
				changeVariablesWhenCloseToTarget = true;
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
			var i, original_location_is_valid_;
			original_location_is_valid_ = true;
			if ds_exists(unitGridLocation, ds_type_grid) {
				if ds_grid_height(unitGridLocation) > 0 {
					for (i = 0; i < ds_grid_height(unitGridLocation); i++) {
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
			if ((!instance_exists(objectTarget)) && (point_distance(x, y, targetToMoveToX, targetToMoveToY) >= (movementSpeed * 2))) || ((instance_exists(objectTarget)) && ((point_distance(x, y, targetToMoveToX, targetToMoveToY)) >= (movementSpeed * 2))) || (!original_location_is_valid_) {
				// Continue the search for a valid location if no valid location currently exists
				if !validLocationFound {
					// Redundant check to see if the unit is following a leader object, and if it is but the
					// leader object no longer exists, just set itself as a leader.
					if movementLeaderOrFollowing != "Leader" && !instance_exists(movementLeaderOrFollowing) {
						movementLeaderOrFollowing = "Leader";
					}
					// If the unit is a leader, or its a follower but the leader has found a path, then it can determine a valid path
					// to an adjusted location.
					var follower_can_find_path_ = false;
					if movementLeaderOrFollowing == "Leader" {
						follower_can_find_path_ = true;
					}
					else if (instance_exists(movementLeaderOrFollowing)) && (path_exists(movementLeaderOrFollowing.myPath)) {
						follower_can_find_path_ = true;
					}
					// If the follower is not in line of sight, but the leader is, and the leader doesn't 
					// make a path but begins moving towards the target location, the follower needs to
					// set itself to a leader to make its own path.
					else if (instance_exists(movementLeaderOrFollowing)) && (!path_exists(movementLeaderOrFollowing.myPath)) && movementLeaderOrFollowing.validLocationFound && movementLeaderOrFollowing.validPathFound {
						movementLeaderOrFollowing = "Leader";
						follower_can_find_path_ = true;
					}
					// Figure out a valid path to an adjusted location if allowed
					if follower_can_find_path_ {
						if ((can_be_evaluated_this_frame_) && (unitQueueCount < unitQueueMax)) {
							var still_need_to_search_;
							still_need_to_search_ = true;
							// Set the pattern starting area - further away if the object is ranged, and only
							// adjacent to target if the object is melee.
							var melee_unit_, ranged_unit_starting_ring_, ranged_unit_direction_moving_in_;
							if objectClassification == "Unit" {
								// If the unitAction running this code is melee, mark it as such. Otherwise,
								// set the ring to start the search at for ranged units, moving inwards,
								// at the max distance allowed by their objectRange.
								if objectRange <= 16 {
									melee_unit_ = true;
									ranged_unit_starting_ring_ = -1;
								}
								else {
									melee_unit_ = false;
									ranged_unit_starting_ring_ = (floor(objectRange / 16) * 16) / 16;
									if (ds_exists(objectTargetList, ds_type_list)) && (instance_exists(objectTarget)) {
										// If the ranged object is already in range of target, don't move! It can act already.
										if point_distance(x, y, targetToMoveToX, targetToMoveToY) <= objectRange {
											changeVariablesWhenCloseToTarget = true;
											notAtTargetLocation = false;
											validLocationFound = true;
											validPathFound = true;
											justSpawned = false;
											cannot_move_without_better_coordinates_ = false;
											still_need_to_search_ = false;
											needToStartGridSearch = false;
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
											baseSquareEdgeSize = 0;
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
											movementLeaderOrFollowing = noone;
											objectTarget = noone;
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
													for (i = 0; i < ds_grid_height(unitGridLocation); i++) {
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
											if ds_exists(objectTargetList, ds_type_list) {
												ds_list_destroy(objectTargetList);
												objectTargetList = noone;
											}
											// After resetting all necessary variables, revert back to idle.
											if objectCurrentCommand == "Move" {
												objectCurrentCommand = "Idle";
												currentAction = unitAction.idle;
											}
											else if objectCurrentCommand == "Attack" {
												currentAction = unitAction.attack;
											}
											else if objectCurrentCommand == "Mine" {
												currentAction = unitAction.mine;
											}
											else if objectCurrentCommand == "Chop" {
												currentAction = unitAction.chop;
											}
											else if objectCurrentCommand == "Farm" {
												currentAction = unitAction.farm;
											}
											else if objectCurrentCommand == "Ruby Mine" {
												currentAction = unitAction.mine;
											}
											exit;
										}
										// Else continue the movement process.
										else {
											squareSizeIncreaseCount = ranged_unit_starting_ring_;
										}
									}
									else {
										squareSizeIncreaseCount = 0;
										ranged_unit_starting_ring_ = 0;
									}
									ranged_unit_direction_moving_in_ = groupDirectionToMoveIn + groupDirectionToMoveInAdjusted;
								}
							}
							// As long as the object doesn't have a specific target to focus, perform normal
							// pathfinding.
							if (!ds_exists(objectTargetList, ds_type_list)) && (objectTarget == noone) {
								var horizontal_edge_size_, vertical_edge_size_;
								horizontal_edge_size_ = 1;
								vertical_edge_size_ = 1;
							}
							// Else if the object has a specific target to focus, set adjuster variables
							// and use those variables in the search afterwards.
							else {
								// Set the size of the minimum pattern.
								var horizontal_edge_size_, vertical_edge_size_;
								// If the search area is surrounding a 1x1 grid area
								// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
								// Currently I'm just checking for "objectTarget.objectClassification == "Building"
								// I need to change that to check specifically for different building type sizes once
								// I have a set idea of each building type and size.
								if (objectTarget.objectClassification == "Unit") || (objectTarget.objectType == "Food") || (objectTarget.objectType == "Wood") {
									horizontal_edge_size_ = 1;
									vertical_edge_size_ = 1;
								}
								// If the search area is surrounding a 1(vertical)x3(horizontal) grid area
								else if (objectTarget.objectType == "Ruby") {
									horizontal_edge_size_ = 4;
									vertical_edge_size_ = 1;
								}
								// If the search area is surrounding a 2(vertical)x3(horizontal) grid area
								else if (objectTarget.objectType == "Gold") {
									horizontal_edge_size_ = 3;
									vertical_edge_size_ = 2;
								}
								else if (objectTarget.objectClassification == "Building") {
									horizontal_edge_size_ = 4;
									vertical_edge_size_ = 4;
								}
							}
							while still_need_to_search_ {
								// If, after checking for a specific location, it still wasn't valid,
								// move on and continue the search.
								if still_need_to_search_ {
									baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
									var square_horizontal_edge_sizes_ = baseSquareEdgeSize + (horizontal_edge_size_ - 1);
									var square_vertical_edge_sizes_ = baseSquareEdgeSize + (vertical_edge_size_ - 1);
									var square_peremeter_size_ = (square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2);
									if squareTrueIteration < ((square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2)) {
										if squareIteration == square_peremeter_size_ {
											squareIteration = 0;
										}
										else if squareIteration > square_peremeter_size_ {
											squareIteration = 1;
										}
									}
									// Top edge, moving left to right
									if squareIteration < (square_horizontal_edge_sizes_) {
										if (melee_unit_) || ((!melee_unit_) && (ranged_unit_direction_moving_in_ == 3) && (instance_exists(objectTarget))) || ((!melee_unit_) && (!instance_exists(objectTarget))) {
											// Start at the left corner and move right
											tempCheckX = targetToMoveToX - (squareSizeIncreaseCount * 16) + (squareIteration * 16);
											// Shift the temporary check upwards to the top edge
											tempCheckY = targetToMoveToY - ((squareSizeIncreaseCount + (vertical_edge_size_ - 1)) * 16);
										}
										else {
											squareIteration += square_horizontal_edge_sizes_ - squareIteration;
											squareTrueIteration += square_horizontal_edge_sizes_ - squareIteration;
										}
									}
									// Right edge, moving top to bottom
									else if squareIteration < (square_horizontal_edge_sizes_ + square_vertical_edge_sizes_) {
										if (melee_unit_) || ((!melee_unit_) && (ranged_unit_direction_moving_in_ == 2) && (instance_exists(objectTarget))) || ((!melee_unit_) && (!instance_exists(objectTarget))) {
											// Shift the temporary check rightwards to the right edge
											tempCheckX = targetToMoveToX + ((squareSizeIncreaseCount + (horizontal_edge_size_ - 1)) * 16);
											// Start at the top right corner and move down. Subtracted the size
											// of one side from the coordinates, since I've already iterated through
											// a side.
											tempCheckY = targetToMoveToY - ((squareSizeIncreaseCount + (vertical_edge_size_ - 1)) * 16) + (squareIteration * 16) - ((((squareSizeIncreaseCount * 2) + 1) + (horizontal_edge_size_ - 1)) * 16);
										}
										else {
											squareIteration += (square_horizontal_edge_sizes_ + square_vertical_edge_sizes_) - squareIteration;
											squareTrueIteration += (square_horizontal_edge_sizes_ + square_vertical_edge_sizes_) - squareIteration;
										}
									}
									// Bottom edge, moving right to left
									else if squareIteration < ((square_horizontal_edge_sizes_ * 2) + square_vertical_edge_sizes_) {
										if (melee_unit_) || ((!melee_unit_) && (ranged_unit_direction_moving_in_ == 1) && (instance_exists(objectTarget))) || ((!melee_unit_) && (!instance_exists(objectTarget))) {
											// Start at the bottom right corner, and move left. How it works:
											// Start at origin point targetToMoveToX. Shift over to the right
											// edge. Move left by subtracting squareIteration * 16. Adjust for
											// the previous two sides that have already been run through by
											// adding the equivalent pixel size of two sides to the coordinates.
											tempCheckX = targetToMoveToX + ((squareSizeIncreaseCount + (horizontal_edge_size_ - 1)) * 16) - (squareIteration * 16) + ((((squareSizeIncreaseCount * 2) + 1) + (horizontal_edge_size_ - 1)) * 16) + ((((squareSizeIncreaseCount * 2) + 1) + (vertical_edge_size_ - 1)) * 16);
											// Shift the temporary check downwards to the bottom edge
											tempCheckY = targetToMoveToY + (squareSizeIncreaseCount * 16);
										}
										else {
											squareIteration += ((square_horizontal_edge_sizes_ * 2) + square_vertical_edge_sizes_) - squareIteration;
											squareTrueIteration += ((square_horizontal_edge_sizes_ * 2) + square_vertical_edge_sizes_) - squareIteration;
										}
									}
									// Left edge, moving bottom to top
									else if squareIteration < ((square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2)) {
										if (melee_unit_) || ((!melee_unit_) && (ranged_unit_direction_moving_in_ == 0) && (instance_exists(objectTarget))) || ((!melee_unit_) && (!instance_exists(objectTarget))) {
											// Shift the temporary check leftwards to the left edge
											tempCheckX = targetToMoveToX - (squareSizeIncreaseCount * 16);
											// Start at the bottom left corner and move up. Works in the same
											// way the check in the else if statement above works with the x axis.
											tempCheckY = targetToMoveToY + (squareSizeIncreaseCount * 16) - (squareIteration * 16) + (((((squareSizeIncreaseCount * 2) + 1) + (horizontal_edge_size_ - 1)) * 16) * 2) + ((((squareSizeIncreaseCount * 2) + 1) + (vertical_edge_size_ - 1)) * 16);
										}
										else {
											squareIteration += ((square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2)) - squareIteration;
											squareTrueIteration += ((square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2)) - squareIteration;
										}
									}
						
									// Iterate the count that moves along the edges up by one
									squareIteration++;
									squareTrueIteration++;
									// If the iteration count reaches the max amount of squares on the perimeter
									// of the search square, reset the iteration count, increment the size increase
									// count by one, and set baseSquareEdgeSize to equal the correct values based off
									// of the new squareSizeIncreaseCount value.
									if squareTrueIteration >= ((((squareSizeIncreaseCount * 2) + 1) + (horizontal_edge_size_ - 1)) * 2) + ((((squareSizeIncreaseCount * 2) + 1) + (vertical_edge_size_ - 1)) * 2) {
										// If the search is being made by a melee object or a ranged unitAction that isn't targeting
										// anything, then expand the search outwards.
										if melee_unit_ || (ranged_unit_starting_ring_ == 0) {
											squareSizeIncreaseCount++;
										}
										// Otherwise, expand the search inwards if the search is being made by a ranged unitAction
										// that has a valid target.
										else {
											// If its still possible to adjust the search inwards, do so
											if squareSizeIncreaseCount > 0 {
												squareSizeIncreaseCount--;
											}
											// Else if its no longer possible to adjust the search inwards, rotate the
											// search by 90 degrees and start a new one. If the search has already been entirely
											// rotated, eliminate the target, since its not valid, and either move onto the next one,
											// or restart the search without a single target.
											else {
												if groupDirectionToMoveInAdjusted < 3 {
													squareSizeIncreaseCount = ranged_unit_starting_ring_;
													groupDirectionToMoveInAdjusted++;
													ranged_unit_direction_moving_in_ = groupDirectionToMoveIn + groupDirectionToMoveInAdjusted;
													if ranged_unit_direction_moving_in_ > 3 {
														ranged_unit_direction_moving_in_ -= 4;
													}
												}
												else {
													groupDirectionToMoveInAdjusted = 0;
													target_next_object();
												}
											}
										}
										baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
										square_horizontal_edge_sizes_ = baseSquareEdgeSize + (horizontal_edge_size_ - 1);
										square_vertical_edge_sizes_ = baseSquareEdgeSize + (vertical_edge_size_ - 1);
										square_peremeter_size_ = (square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2);
										var point_direction_from_target_to_unit_ = point_direction(targetToMoveToX, targetToMoveToY, x, y) + 45;
										if point_direction_from_target_to_unit_ >= 360 {
											point_direction_from_target_to_unit_ -= 360;
										}
										point_direction_from_target_to_unit_ = floor(point_direction_from_target_to_unit_ / 90);
										switch point_direction_from_target_to_unit_ {
											case 0:
												squareIteration = square_horizontal_edge_sizes_ - 1;
												break;
											case 1:
												squareIteration = 0;
												break;
											case 2:
												squareIteration = ((square_horizontal_edge_sizes_ * 2) + square_vertical_edge_sizes_ - 1);
												break;
											case 3:
												squareIteration = square_horizontal_edge_sizes_ + square_vertical_edge_sizes_ - 1;
												break;
										}
										squareTrueIteration = 0;
									}
									// If the iteration is divisible by the size of an edge, meaning its at a corner,
									// skip the corner. The previous frame will have already searched that corner -
									// this skips redundant checks.
									if (squareIteration == ((squareSizeIncreaseCount * 2) + 1 + (horizontal_edge_size_ - 1))) || (squareIteration == ((squareSizeIncreaseCount * 2) + 1 + (horizontal_edge_size_ - 1)) + ((squareSizeIncreaseCount * 2) + 1 + (vertical_edge_size_ - 1))) || (squareIteration == (((squareSizeIncreaseCount * 2) + 1 + (horizontal_edge_size_ - 1)) * 2) + ((squareSizeIncreaseCount * 2) + 1 + (vertical_edge_size_ - 1))) || (squareIteration == (((squareSizeIncreaseCount * 2) + 1 + (horizontal_edge_size_ - 1)) * 2) + (((squareSizeIncreaseCount * 2) + 1 + (vertical_edge_size_ - 1)) * 2)) {
										squareIteration++;
										squareTrueIteration++;
									}
									// If the iteration count reaches the max amount of squares on the perimeter
									// of the search square, reset the iteration count, increment the size increase
									// count by one, and set baseSquareEdgeSize to equal the correct values based off
									// of the new squareSizeIncreaseCount value.
									if squareTrueIteration == ((((squareSizeIncreaseCount * 2) + 1) + (horizontal_edge_size_ - 1)) * 2) + ((((squareSizeIncreaseCount * 2) + 1) + (vertical_edge_size_ - 1)) * 2) {
										// If the search is being made by a melee object or a ranged unitAction that isn't targeting
										// anything, then expand the search outwards.
										if melee_unit_ || (ranged_unit_starting_ring_ == 0) {
											squareSizeIncreaseCount++;
										}
										// Otherwise, expand the search inwards if the search is being made by a ranged unitAction
										// that has a valid target.
										else {
											// If its still possible to adjust the search inwards, do so
											if squareSizeIncreaseCount > 0 {
												squareSizeIncreaseCount--;
											}
											// Else if its no longer possible to adjust the search inwards, rotate the
											// search by 90 degrees and start a new one. If the search has already been entirely
											// rotated, eliminate the target, since its not valid, and either move onto the next one,
											// or restart the search without a single target.
											else {
												if groupDirectionToMoveInAdjusted < 3 {
													squareSizeIncreaseCount = ranged_unit_starting_ring_;
													groupDirectionToMoveInAdjusted++;
													ranged_unit_direction_moving_in_ = groupDirectionToMoveIn + groupDirectionToMoveInAdjusted;
													if ranged_unit_direction_moving_in_ > 3 {
														ranged_unit_direction_moving_in_ -= 4;
													}
												}
												else {
													groupDirectionToMoveInAdjusted = 0;
													target_next_object();
												}
											}
										}
										baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
										square_horizontal_edge_sizes_ = baseSquareEdgeSize + (horizontal_edge_size_ - 1);
										square_vertical_edge_sizes_ = baseSquareEdgeSize + (vertical_edge_size_ - 1);
										square_peremeter_size_ = (square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2);
										var point_direction_from_target_to_unit_ = point_direction(targetToMoveToX, targetToMoveToY, x, y) + 45;
										if point_direction_from_target_to_unit_ >= 360 {
											point_direction_from_target_to_unit_ -= 360;
										}
										point_direction_from_target_to_unit_ = floor(point_direction_from_target_to_unit_ / 90);
										switch point_direction_from_target_to_unit_ {
											case 0:
												squareIteration = square_horizontal_edge_sizes_ - 1;
												break;
											case 1:
												squareIteration = 0;
												break;
											case 2:
												squareIteration = ((square_horizontal_edge_sizes_ * 2) + square_vertical_edge_sizes_ - 1);
												break;
											case 3:
												squareIteration = square_horizontal_edge_sizes_ + square_vertical_edge_sizes_ - 1;
												break;
										}
										squareTrueIteration = 0;
									}
								
									if melee_unit_ {
										if ds_exists(objectTargetList, ds_type_list) {
											if squareSizeIncreaseCount > 1 {
												target_next_object();
											}
										}
									}
									else if !melee_unit_ {
										if ds_exists(objectTargetList, ds_type_list) {
											if squareSizeIncreaseCount == 0 {
												target_next_object();
											}
										}
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
											for (i = 0; i < ds_grid_height(unitGridLocation); i++) {
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
								// If I need to check for a specific location, check it
								if specificLocationNeedsToBeChecked {
									specificLocationNeedsToBeChecked = false;
									if path_exists(myPath) {
										path_delete(myPath);
										myPath = noone;
									}
									myPath = path_add();
								
									// This while statement is run during movement, and as such it can be run while the object is clipping
									// into the corners of objects during movement. Because my movement system only allows clipping into objects
									// at corners, and because it prioritizes staying near the edge of the clipped object, all I need to do 
									// to prevent trying to determine a path from inside a solid object is to shift the check out of the corner.
									// So, check if the current coordinates for the moving unit is inside a solid object, and if so assume its
									// clipping into a corner and shift the check coordinates outwards.
									var shifted_x_ = 0;
									var shifted_y_ = 0; 
									if mp_grid_get_cell(movementGrid, x_ / 16, y_ / 16) == -1 {
										// If closer to the left edge, shift left, otherwise shift right.
										if x - x_ < 8 {
											shifted_x_ = -16;
										}
										else {
											shifted_x_ = 16;
										}
										// If closer to the top edge, shift upwards, otherwise shift downwards.
										if y - y_ < 8 {
											shifted_y_ = -16;
										}
										else {
											shifted_y_ = 16;
										}
									}
									// Check to see if a direct line of sight exists to the move target - and if not, check to see if a path exists
									// to the move target. If neither of those are the case, that's fine, just continue the search.
									var path_found_ = false;
									var create_new_path_ = false;
									if ((line_of_sight_exists_to_target(x_ + shifted_x_, y_ + shifted_y_, specificLocationToBeCheckedX, specificLocationToBeCheckedY)) && (line_of_sight_exists_to_target(x_ + shifted_x_ + 15, y_ + shifted_y_ + 15, specificLocationToBeCheckedX, specificLocationToBeCheckedY))) && (objectCurrentCommand == "Move") {
										path_found_ = true;
										if path_exists(myPath) {
											path_delete(myPath);
											myPath = noone;
										}
									}
									/*
									else if a line of sight exists between the checked location and the leader's target location, set the path
									equal to the leader's path. then check for a line of sight between the SECOND TO LAST point in the path and
									the checked location - if it exists, use path_delete_point to delete the last point in the path and then use
									path_add_point to add the checked location to the end of the path. Otherwise if no line of sight exists
									between the second to last point in the path and the checked location, check for a line of sight between the
									LAST point in the path and the checked location. If one exists, use path_add_point to add the checked location
									to the end of the path. Otherwise, if no line of sight exists between EITHER the SECOND TO LAST, or LAST point
									on the path to the checked location, ignore the leader's path and create its own path completely.
									*/
									else if (movementLeaderOrFollowing != "Leader") {
										myPath = path_duplicate(movementLeaderOrFollowing.myPath);
										var check_for_alt_paths_ = false;
										if !line_of_sight_exists_to_target(x + 8, y + 8, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) {
											create_new_path_ = true;
										}
										else if path_get_number(myPath) > 1 {
											if path_get_number(myPath) > 2 {
												// - 2 because path_get_number gets the number of points on a path, while the points are ordered
												// starting at 0, so I subtract 1 to get to the index of the last point in the path, and then I
												// subtract 1 more to get the second to last point in the path.
												if line_of_sight_exists_to_target(path_get_point_x(myPath, path_get_number(myPath) - 2), path_get_point_y(myPath, path_get_number(myPath) - 2), specificLocationToBeCheckedX, specificLocationToBeCheckedY) {
													path_delete_point(myPath, path_get_number(myPath) - 1);
													path_add_point(myPath, specificLocationToBeCheckedX, specificLocationToBeCheckedY, 0);
													path_found_ = true;
												}
												else {
													check_for_alt_paths_ = true;
												}
											}
											else {
												check_for_alt_paths_ = true;
											}
											if check_for_alt_paths_ {
												// Check to see if a line of sight exists between the last point in the leader's path
												// and the valid point to check.
												if line_of_sight_exists_to_target(path_get_point_x(myPath, path_get_number(myPath) - 1), path_get_point_y(myPath, path_get_number(myPath) - 1), specificLocationToBeCheckedX, specificLocationToBeCheckedY) {
													path_add_point(myPath, specificLocationToBeCheckedX, specificLocationToBeCheckedY, 0);
													path_found_ = true;
												}
												// Else just make a new path.
												else {
													create_new_path_ = true;
												}
											}
										}
										else {
											create_new_path_ = true;
										}
										check_for_alt_paths_ = false;
										if create_new_path_ {
											create_new_path_ = false;
											if path_exists(myPath) {
												path_delete(myPath);
												myPath = noone;
											}
											myPath = path_add();
											if mp_grid_path(movementGrid, myPath, x_ + shifted_x_, y_ + shifted_y_, specificLocationToBeCheckedX, specificLocationToBeCheckedY, true) {
												path_found_ = true;
											}
										}
									}
									// If the unit is a leader, and either no attack target exists, or the attack target is within
									// line of sight of the new location to move to, then set that new location to move to as a valid
									// path target. Otherwise, keep searching.
									else if mp_grid_path(movementGrid, myPath, x_ + shifted_x_, y_ + shifted_y_, specificLocationToBeCheckedX, specificLocationToBeCheckedY, true) {
										// If the unit has a target
										if instance_exists(objectTarget) {
											// If the target is within line of sight, then that's a valid path
											if line_of_sight_exists_to_target(specificLocationToBeCheckedX, specificLocationToBeCheckedY, objectTarget.x + 8, objectTarget.y + 8) {
												path_found_ = true;
											}
											// If the target isn't within line of sight, then that isn't a valid path
											else {
												path_found_ = false;
												if path_exists(myPath) {
													path_delete(myPath);
													myPath = noone;
												}
											}
										}
										// If the unit doesn't have a target, then its a valid path
										else {
											path_found_ = true;
										}
									}
									if path_found_ {
										still_need_to_search_ = false;
										validPathFound = true;
										targetToMoveToX = specificLocationToBeCheckedX;
										targetToMoveToY = specificLocationToBeCheckedY;
										validLocationFound = true;
										// Now that a full valid path exists, just set unit as leader until it exits this unit_move
										// script, so that in case something dynamic changes during movement, it can change its own
										// path freely.
										movementLeaderOrFollowing = "Leader";
										// If this unit is targeting another unit, erase the first path point. It might be placed
										// behind this unit, in which case this unit would perform a weird backtrack before continuing
										// to chase, which I don't want.
										if instance_exists(objectTarget) {
											// If the path has more than a single path point on it, delete the first point.
											//if path_get_number(myPath) > 1 {
											//	path_delete_point(myPath, 0);
											//}
											// Else if the path only has a single movement point on it, which normally shouldn't
											// ever happen, move that point down towards the center of the square its on.
											//else if path_get_number(myPath) == 1 {
												path_change_point(myPath, 0, path_get_point_x(myPath, 0) + 8, path_get_point_y(myPath, 0) + 8, 0);
											//}
										}
										// Add self back to the unitGridLocation, so that other objects don't
										// move on the same square.
										if ds_exists(unitGridLocation, ds_type_grid) {
											var i, self_is_found_;
											self_is_found_ = noone;
											if ds_grid_height(unitGridLocation) > 0 {
												for (i = 0; i < ds_grid_height(unitGridLocation); i++) {
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
										still_need_to_search_ = true;
										// Reset path
										if path_exists(myPath) {
											path_delete(myPath);
											myPath = noone;
										}
									}
								}
							}
						}
					}
				}
				// Potentially move the object if a valid location exists.
				else /*if valid location exists*/{
					if changeVariablesWhenCloseToTarget {
						if instance_exists(objectTarget) && ds_exists(unitGridLocation, ds_type_grid) {
						    var target_ = ds_grid_value_y(unitGridLocation, 0, 0, ds_grid_width(unitGridLocation) - 1, ds_grid_height(unitGridLocation) - 1, objectTarget.id);
							if target_ != -1 {
								if objectTarget.objectClassification == "Unit" {
									if objectTarget.currentAction == unitAction.move {
										// If the distance to the target is less than its attack range, and the target its chasing
										// is also moving, set a new target to move to equal to its own location once its within range.
										var adjusted_object_range_ = objectRange;
										if (distance_to_object(objectTarget) <= adjusted_object_range_) && (path_get_number(myPath) < ((adjusted_object_range_ / 16) * 2)) {
											notAtTargetLocation = true;
											validLocationFound = false;
											validPathFound = false;
											var target_path_exists_ = false;
											with objectTarget {
												if variable_instance_exists(self.id, "myPath") {
													if path_exists(myPath) {
														target_path_exists_ = true;
														var target_paths_target_x_ = path_get_point_x(myPath, path_get_number(myPath) - 1);
														var target_paths_target_y_ = path_get_point_y(myPath, path_get_number(myPath) - 1)
													}
												}
											}
											if target_path_exists_ {
												var distance_to_target_end_path_location_ = distance_to_point(target_paths_target_x_, target_paths_target_y_);
												// If this object's target is itself, they're moving towards each other and they
												// should meet in the middle.
												if objectTarget.objectTarget == self.id {
													changeVariablesWhenCloseToTarget = false;
													var halfway_x_ = (objectTarget.x - x) / 2;
													var halfway_y_ = (objectTarget.y - y) / 2;
													targetToMoveToX = floor((x + halfway_x_) / 16) * 16;
													targetToMoveToY = floor((y + halfway_y_) / 16) * 16;
												}
												// Else if this object's target's target is not itself, determine the target's target location.
												else if (distance_to_target_end_path_location_ < adjusted_object_range_) {
													// If this object's target is not attacking any other object to begin with, then just move to
													// it's target's end movement location.
													if objectTarget.objectCurrentCommand != "Attack" {
														changeVariablesWhenCloseToTarget = false;
														targetToMoveToX = floor(target_paths_target_x_ / 16) * 16;
														targetToMoveToY = floor(target_paths_target_y_ / 16) * 16;
													}
													// Else if this object's target is attacking, and the target's target exists, but this object's
													// target's target is not itself (already checked above) then just move to the target's end location.
													else if instance_exists(objectTarget.objectTarget) {
														changeVariablesWhenCloseToTarget = false;
														targetToMoveToX = floor(target_paths_target_x_ / 16) * 16;
														targetToMoveToY = floor(target_paths_target_y_ / 16) * 16;
													}
												}
												// If the target's end location after moving is not within range, then just keep following
												// the target.
												else {
													targetToMoveToX = floor(objectTarget.x / 16) * 16;
													targetToMoveToY = floor(objectTarget.y / 16) * 16;
												}
											}
											else {
												targetToMoveToX = floor(objectTarget.x / 16) * 16;
												targetToMoveToY = floor(objectTarget.y / 16) * 16;
											}
											cannot_move_without_better_coordinates_ = false;
											needToStartGridSearch = false;
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
											baseSquareEdgeSize = 0;
											squareSizeIncreaseCount = 0;
											squareIteration = 0;
											squareTrueIteration = 0;
											tempCheckX = -1;
											tempCheckY = -1;
											groupRowWidth = 0;
											specificLocationNeedsToBeChecked = false;
											specificLocationToBeCheckedX = -1;
											specificLocationToBeCheckedY = -1;
											searchHasJustBegun = true;
											totalTimesSearched = 0;
											closestPointsToObjectsHaveBeenSet = false;
											movementLeaderOrFollowing = "Leader";
											if path_exists(myPath) {
												path_delete(myPath);
												myPath = -1;
											}
											exit;
										}
										// If the object is not within range of the target, and the target its chasing is also moving,
										// set the target to move to equal to the target's exact location. I don't do this every frame,
										// only once every second or so, because this is deleting the path to take each time to make a new
										// one, and if I ran this every frame, no object with a valid target further than its objectRange would
										// ever move, because no path would ever exist.
										else if (objectDetectTarget % (room_speed - 1) == 0) && ((distance_to_object(objectTarget) > adjusted_object_range_) || (path_get_number(myPath) >= ((adjusted_object_range_ / 16) * 2))) {
											changeVariablesWhenCloseToTarget = true;
											notAtTargetLocation = true;
											validLocationFound = false;
											validPathFound = false;
											targetToMoveToX = floor(objectTarget.x / 16) * 16;
											targetToMoveToY = floor(objectTarget.y / 16) * 16;
											cannot_move_without_better_coordinates_ = false;
											needToStartGridSearch = false;
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
											baseSquareEdgeSize = 0;
											squareSizeIncreaseCount = 0;
											squareIteration = 0;
											squareTrueIteration = 0;
											tempCheckX = -1;
											tempCheckY = -1;
											groupRowWidth = 0;
											specificLocationNeedsToBeChecked = false;
											specificLocationToBeCheckedX = -1;
											specificLocationToBeCheckedY = -1;
											searchHasJustBegun = true;
											totalTimesSearched = 0;
											closestPointsToObjectsHaveBeenSet = false;
											movementLeaderOrFollowing = "Leader";
											if path_exists(myPath) {
												path_delete(myPath);
												myPath = -1;
											}
											exit;
										}
									}
								}
							}
						}
					}
					// Local avoidance and preventing clipping, before movement
					var clipped_objects_ = ds_list_create();
					/*
					check distance between each colliding object and store those into a vector
						vector is determined by direction to colliding objects
						strength of vector grows as the object is closer
					take averaged power and direction of each vector and move the object in those directions
					*/
					var w, clipped_instance_to_reference_, clipped_instance_distance_, clipped_instance_direction_, x_clip_vector_, y_clip_vector_, x_clip_vector_add_, y_clip_vector_add_, x_needs_to_be_removed_, y_needs_to_be_removed_, x_number_of_removed_clipped_objects_, y_number_of_removed_clipped_objects_;
					var origin_instance_mid_x_, origin_instance_mid_y_, clipped_instance_mid_x_, clipped_instance_mid_y_, clipped_instance_width_, clipped_instance_height_;
					x_clip_vector_ = 0;
					y_clip_vector_ = 0;
					x_number_of_removed_clipped_objects_ = 0;
					y_number_of_removed_clipped_objects_ = 0;
					if collision_rectangle_list(x, y, x + 15, y + 15, all, true, true, clipped_objects_, true) > 0 {
						origin_instance_mid_x_ = (bbox_left + bbox_right) / 2;
						origin_instance_mid_y_ = (bbox_top + bbox_bottom) / 2;
						for (w = 0; w < ds_list_size(clipped_objects_); w++) {
							x_needs_to_be_removed_ = false;
							y_needs_to_be_removed_ = false;
							clipped_instance_to_reference_ = ds_list_find_value(clipped_objects_, w);
							// Don't include the colliding object if it isn't a friendly unit, or if the unit is stationary and
							// thus doesn't need to worry about object avoidance.
							if clipped_instance_to_reference_.object_index == obj_unit && (clipped_instance_to_reference_.objectVisibleTeam == objectVisibleTeam) {
								if clipped_instance_to_reference_.currentAction == unitAction.move {
									clipped_instance_mid_x_ = (clipped_instance_to_reference_.bbox_left + clipped_instance_to_reference_.bbox_right) / 2;
									clipped_instance_mid_y_ = (clipped_instance_to_reference_.bbox_top + clipped_instance_to_reference_.bbox_bottom) / 2;
									clipped_instance_width_ = clipped_instance_to_reference_.bbox_right - clipped_instance_to_reference_.bbox_left;
									clipped_instance_height_ = clipped_instance_to_reference_.bbox_bottom - clipped_instance_to_reference_.bbox_top;
									clipped_instance_distance_ = point_distance(origin_instance_mid_x_, origin_instance_mid_y_, clipped_instance_mid_x_, clipped_instance_mid_y_);
									clipped_instance_direction_ = point_direction(origin_instance_mid_x_, origin_instance_mid_y_, clipped_instance_mid_x_, clipped_instance_mid_y_);
									// Set the temporary vector values to add to the total vector value
									x_clip_vector_add_ = (clipped_instance_width_ - abs(lengthdir_x(clipped_instance_distance_, clipped_instance_direction_))) * sign(lengthdir_x(clipped_instance_distance_, clipped_instance_direction_)) * -1;
									y_clip_vector_add_ = (clipped_instance_height_ - abs(lengthdir_y(clipped_instance_distance_, clipped_instance_direction_))) * sign(lengthdir_y(clipped_instance_distance_, clipped_instance_direction_)) * -1;
									// Remove those temporary vector values if they're not helping a unit slow down when it runs into
									// a friendly unit.
									if path_exists(myPath) {
										if path_get_number(myPath) > 1 {
											if sign(lengthdir_x(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8))) == sign(x_clip_vector_add_) {
												x_clip_vector_add_ = 0;
												x_needs_to_be_removed_ = true;
											}
											if sign(lengthdir_y(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8))) == sign(y_clip_vector_add_) {
												y_clip_vector_add_ = 0;
												y_needs_to_be_removed_ = true;
											}
										}
										else if point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) > movementSpeed * 2 {
											if sign(lengthdir_x(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)))) == sign(x_clip_vector_add_) {
												x_clip_vector_add_ = 0;
												x_needs_to_be_removed_ = true;
											}
											if sign(lengthdir_y(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)))) == sign(y_clip_vector_add_) {
												y_clip_vector_add_ = 0;
												y_needs_to_be_removed_ = true;
											}
										}
									}
									else if point_distance(x, y, targetToMoveToX, targetToMoveToY) >= movementSpeed * 2 {
										if sign(lengthdir_x(movementSpeed, point_direction(x, y, targetToMoveToX, targetToMoveToY))) == sign(x_clip_vector_add_) {
											x_clip_vector_add_ = 0;
											x_needs_to_be_removed_ = true;
										}
										if sign(lengthdir_y(movementSpeed, point_direction(x, y, targetToMoveToX, targetToMoveToY))) == sign(y_clip_vector_add_) {
											y_clip_vector_add_ = 0;
											y_needs_to_be_removed_ = true;
										}
									}
									x_clip_vector_ += x_clip_vector_add_;
									y_clip_vector_ += y_clip_vector_add_;
									if x_needs_to_be_removed_ {
										x_number_of_removed_clipped_objects_++;
									}
									if y_needs_to_be_removed_ {
										y_number_of_removed_clipped_objects_++;
									}
								}
								else {
									x_number_of_removed_clipped_objects_++;
									y_number_of_removed_clipped_objects_++;
								}
							}
							else {
								x_number_of_removed_clipped_objects_++;
								y_number_of_removed_clipped_objects_++;
							}
						}
						// Take the average of the vector values
						if (ds_list_size(clipped_objects_) - x_number_of_removed_clipped_objects_) > 1 {
							x_clip_vector_ = x_clip_vector_ / (ds_list_size(clipped_objects_) - 1 - x_number_of_removed_clipped_objects_);
						}
						if (ds_list_size(clipped_objects_) - y_number_of_removed_clipped_objects_) > 1 {
							y_clip_vector_ = y_clip_vector_ / (ds_list_size(clipped_objects_) - 1 - y_number_of_removed_clipped_objects_);
						}
						// Set x and y vectors equal to a percentage of movementSpeed, where that percentage is determine by how
						// close the unit is currently to the center of all colliding objects. That percentage can only max out at
						// 1/4 of max speed, to prevent movement from being stopped while its supposed to be moving.
						if x_clip_vector_ != 0 {
							x_clip_vector_ = (movementSpeed * (x_clip_vector_ / ((abs(x_clip_vector_ div 16) + 1) * 16))) / 4;
						}
						if y_clip_vector_ != 0 {
							y_clip_vector_ = (movementSpeed * (y_clip_vector_ / ((abs(y_clip_vector_ div 16) + 1) * 16))) / 4;
						}
					}
					ds_list_destroy(clipped_objects_);
					
					// Set the unit's next point to move to equal to the closest point
					// in range - which will not necessarily be point 0
					if path_exists(myPath) {
						while (path_get_number(myPath) > 1) && (point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) > point_distance(x, y, path_get_point_x(myPath, 1), path_get_point_y(myPath, 1))) {
							path_delete_point(myPath, 0);
						}
					}
					
					// If a valid location exists, no need to search for one, just move.
					if !path_exists(myPath) {
						if point_distance(x, y, targetToMoveToX, targetToMoveToY) >= movementSpeed * 2 {
							var x_vector_, y_vector_;
							x_vector_ = lengthdir_x(movementSpeed, point_direction(x, y, targetToMoveToX, targetToMoveToY));
							y_vector_ = lengthdir_y(movementSpeed, point_direction(x, y, targetToMoveToX, targetToMoveToY));
							currentDirection = (point_direction(x, y, targetToMoveToX, targetToMoveToY) + 45) div 90;
							if currentDirection > 3 {
								currentDirection -= 4;
							}
							x += x_vector_ + x_clip_vector_;
							y += y_vector_ + y_clip_vector_;
							if objectRealTeam != 1 {
								var yeet_;
							}
						}
						else {
							if path_exists(myPath) {
								path_delete(myPath);
								myPath = noone;
							}
							validPathFound = true;
							validLocationFound = true;
							// Increment all mining and attack timers each frame at the beginning of this script
							// Also, don't snap to grid if currently chasing an enemy unitAction that is also in a movement script - instead, just attack.
							// I'll have to include ways to snap back to grid in weird cases, like if the target swaps to a non-moving state while
							// the original object is attacking while not snapped to grid.
							x = floor(targetToMoveToX / 16) * 16;
							y = floor(targetToMoveToY / 16) * 16;
						}
					}
					// Else a path must exist
					else {
						// If the path has more than 1 point to move along, move it
						if path_get_number(myPath) > 1 {
							var x_vector_, y_vector_;
							x_vector_ = lengthdir_x(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8));
							y_vector_ = lengthdir_y(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8));
							currentDirection = (point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8) + 45) div 90;
							if currentDirection > 3 {
								currentDirection -= 4;
							}
							// Set the vector to avoid clipping into solid objects
							var p, x_adjustor_, y_adjustor_, x_avoidance_vector_, y_avoidance_vector_;
							x_adjustor_ = 0;
							y_adjustor_ = 0;
							x_avoidance_vector_ = 0;
							y_avoidance_vector_ = 0;
							for (p = 0; p < 4; p++) {
								// If the count for the for loop is odd or even, set various variables
								if p & 1 {
									if p == 3 {
										x_adjustor_ = 0;
										y_adjustor_ = 15;
									}
									else {
										x_adjustor_ = 15;
										y_adjustor_ = 0;
									}
								}
								else {
									if p == 0 {
										x_adjustor_ = 0;
										y_adjustor_ = 0;
									}
									else {
										x_adjustor_ = 15;
										y_adjustor_ = 15;
									}
								}
								if mp_grid_get_cell(movementGrid, floor(((x + x_adjustor_) + x_vector_ + x_clip_vector_) / 16), floor(((y + y_adjustor_) + y_vector_ + y_clip_vector_) / 16)) == -1 {
									if mp_grid_get_cell(movementGrid, floor(((x + x_adjustor_) + x_vector_ + x_clip_vector_) / 16), floor((y + y_adjustor_) / 16)) == 0 {
										x_avoidance_vector_ = abs(y_vector_) * sign(x_vector_);
										y_vector_ = 0;
										y_clip_vector_ = 0;
										break;
									}
									if mp_grid_get_cell(movementGrid, floor((x + x_adjustor_) / 16), floor(((y + y_adjustor_) + y_vector_ + y_clip_vector_) / 16)) == 0 {
										y_avoidance_vector_ = abs(x_vector_) * sign(y_vector_);
										x_vector_ = 0;
										x_clip_vector_ = 0;
										break;
									}
								}
							}
							// Finally, check to see if there's movement. I discovered there are rare instances where rounding 
							// ends up with a decimal number that shifts the unit into a situation where it can't move due to a
							// tiny decimal off placing the unit. So I just round the value to the nearest whole number if no
							// movement exists to fix that automatically.
							if ((x_vector_ + x_clip_vector_ + x_avoidance_vector_) == 0) && ((y_vector_ + y_clip_vector_ + y_avoidance_vector_) == 0) {
								x = round(x);
								y = round(y);
							}
							else {
								x += x_vector_ + x_clip_vector_ + x_avoidance_vector_;
								y += y_vector_ + y_clip_vector_ + y_avoidance_vector_;
								if objectRealTeam != 1 {
									var yeet_;
								}
							}
						}
						// Otherwise if the path only has 1 point on it, move it
						else if point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) > movementSpeed * 2 {
							var x_vector_, y_vector_;
							x_vector_ = lengthdir_x(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)));
							y_vector_ = lengthdir_y(movementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)));
							currentDirection = (point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) + 45) div 90;
							if currentDirection > 3 {
								currentDirection -= 4;
							}
							// Set the vector to avoid clipping into solid objects
							var p, x_adjustor_, y_adjustor_, x_avoidance_vector_, y_avoidance_vector_;
							x_adjustor_ = 0;
							y_adjustor_ = 0;
							x_avoidance_vector_ = 0;
							y_avoidance_vector_ = 0;
							for (p = 0; p < 4; p++) {
								// If the count for the for loop is odd or even, set various variables
								if p & 1 {
									if p == 3 {
										x_adjustor_ = 0;
										y_adjustor_ = 15;
									}
									else {
										x_adjustor_ = 15;
										y_adjustor_ = 0;
									}
								}
								else {
									if p == 0 {
										x_adjustor_ = 0;
										y_adjustor_ = 0;
									}
									else {
										x_adjustor_ = 15;
										y_adjustor_ = 15;
									}
								}
								if mp_grid_get_cell(movementGrid, floor(((x + x_adjustor_) + x_vector_ + x_clip_vector_) / 16), floor(((y + y_adjustor_) + y_vector_ + y_clip_vector_) / 16)) == -1 {
									if mp_grid_get_cell(movementGrid, floor(((x + x_adjustor_) + x_vector_ + x_clip_vector_) / 16), floor((y + y_adjustor_) / 16)) == 0 {
										x_avoidance_vector_ = abs(y_vector_) * sign(x_vector_);
										y_vector_ = 0;
										y_clip_vector_ = 0;
										break;
									}
									if mp_grid_get_cell(movementGrid, floor((x + x_adjustor_) / 16), floor(((y + y_adjustor_) + y_vector_ + y_clip_vector_) / 16)) == 0 {
										y_avoidance_vector_ = abs(x_vector_) * sign(y_vector_);
										x_vector_ = 0;
										x_clip_vector_ = 0;
										break;
									}
								}
							}
							// Finally, check to see if there's movement. I discovered there are rare instances where rounding 
							// ends up with a decimal number that shifts the unit into a situation where it can't move due to a
							// tiny decimal off placing the unit. So I just round the value to the nearest whole number if no
							// movement exists to fix that automatically.
							if ((x_vector_ + x_clip_vector_ + x_avoidance_vector_) == 0) && ((y_vector_ + y_clip_vector_ + y_avoidance_vector_) == 0) {
								x = round(x);
								y = round(y);
							}
							else {
								x += x_vector_ + x_clip_vector_ + x_avoidance_vector_;
								y += y_vector_ + y_clip_vector_ + y_avoidance_vector_;
								if objectRealTeam != 1 {
									var yeet_;
								}
							}
						}
						// Else if the unit is close enough that a path is not needed, finish movement.
						else {
							if path_exists(myPath) {
								path_delete(myPath);
								myPath = noone;
							}
							validPathFound = true;
							validLocationFound = true;
							x = floor(targetToMoveToX / 16) * 16;
							y = floor(targetToMoveToY / 16) * 16;
						}
						// Clear each point on the path as the unit passes that point
						if ((path_get_number(myPath) > 1) && (point_distance((x + 8), (y + 8), path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) <= (sprite_width / 2))) || ((path_get_number(myPath) == 1) && (point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) <= movementSpeed)) {
							path_delete_point(myPath, 0);
						}
						// If the unit is within a narrow angle of the next pathway, but no line of sight exists to it's path point,
						// the only possible situation is that its on the edge of a wall in the way. Simplest fix is to simply add another
						// path point going around the wall.
						var path_0_x_, path_0_y_;
						path_0_x_ = path_get_point_x(myPath, 0);
						path_0_y_ = path_get_point_y(myPath, 0);
						var direction_to_path_point_0_ = point_direction((x + 8), (y + 8), path_0_x_, path_0_y_);
						var deviation_from_right_angle_directions_ = direction_to_path_point_0_ mod 90;
						if (deviation_from_right_angle_directions_ <= 10) || (deviation_from_right_angle_directions_ >= 80) {
							if (!line_of_sight_exists_to_target((x + 8), (y + 8), path_0_x_, path_0_y_)) && (((x_vector_ + x_clip_vector_ + x_avoidance_vector_) == 0) || ((y_vector_ + y_clip_vector_ + y_avoidance_vector_) == 0)) {
								var adjusted_direction_to_path_point_0_ = (direction_to_path_point_0_ + 45) div 90;
								if adjusted_direction_to_path_point_0_ > 3 {
									adjusted_direction_to_path_point_0_ -= 4;
								}
								if adjusted_direction_to_path_point_0_ > 1 {
									adjusted_direction_to_path_point_0_ -= 2;
								}
								var mid_x_, mid_y_;
								mid_x_ = (x + 8) + (lengthdir_x(point_distance((x + 8), (y + 8), path_0_x_, path_0_y_), direction_to_path_point_0_) / 2);
								mid_y_ = (y + 8) + (lengthdir_y(point_distance((x + 8), (y + 8), path_0_x_, path_0_y_), direction_to_path_point_0_) / 2);
								switch adjusted_direction_to_path_point_0_ {
									case 0:
										if mp_grid_get_cell(movementGrid, floor(mid_x_ / 16), (floor(mid_y_ / 16) + 1)) == 0 {
											path_insert_point(myPath, 0, (floor(mid_x_ / 16) * 16) + 7, ((floor(mid_y_ / 16) * 16) + 16 + 7), 0);
										}
										else if mp_grid_get_cell(movementGrid, floor(mid_x_ / 16), (floor(mid_y_ / 16) - 1)) == 0 {
											path_insert_point(myPath, 0, (floor(mid_x_ / 16) * 16) + 7, ((floor(mid_y_ / 16) * 16) - 16 - 8), 0);
										}
										break;
									case 1:
										if mp_grid_get_cell(movementGrid, (floor(mid_x_ / 16) + 1), floor(mid_y_ / 16)) == 0 {
											path_insert_point(myPath, 0, ((floor(mid_x_ / 16) * 16) + 16 + 7), (floor(mid_y_ / 16) * 16) + 7, 0);
										}
										else if mp_grid_get_cell(movementGrid, (floor(mid_x_ / 16) - 1), floor(mid_y_ / 16)) == 0 {
											path_insert_point(myPath, 0, ((floor(mid_x_ / 16) * 16) - 16 - 8), (floor(mid_y_ / 16) * 16) + 7, 0);
										}
										break;
								}
							}
						}
					}
				}
			}
			// Else if point distance between object and target location is less than the move
			// speed during two frames, just teleport the object to that location and reset ALL
			// variables.
			else {
				changeVariablesWhenCloseToTarget = true;
				notAtTargetLocation = false;
				validLocationFound = true;
				validPathFound = true;
				justSpawned = false;
				x = targetToMoveToX;
				y = targetToMoveToY;
				cannot_move_without_better_coordinates_ = false;
				needToStartGridSearch = false;
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
				baseSquareEdgeSize = 0;
				squareSizeIncreaseCount = 0;
				squareIteration = 0;
				squareTrueIteration = 0;
				tempCheckX = -1;
				tempCheckY = -1;
				groupRowWidth = 0;
				specificLocationNeedsToBeChecked = false;
				specificLocationToBeCheckedX = -1;
				specificLocationToBeCheckedY = -1;
				searchHasJustBegun = true;
				totalTimesSearched = 0;
				closestPointsToObjectsHaveBeenSet = false;
				movementLeaderOrFollowing = noone;
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
						for (i = 0; i < ds_grid_height(unitGridLocation); i++) {
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
				if objectCurrentCommand == "Move" {
					// Specifically if the unitAction's only command was to move, then remove any targeting that's going on.
					objectTarget = noone;
					if ds_exists(objectTargetList, ds_type_list) {
						ds_list_destroy(objectTargetList);
						objectTargetList = noone;
					}
					objectCurrentCommand = "Idle";
					currentAction = unitAction.idle;
					objectTargetType = noone;
					objectTargetTeam = noone;
				}
				else if objectCurrentCommand == "Attack" {
					currentAction = unitAction.attack;
				}
				else if objectCurrentCommand == "Mine" {
					currentAction = unitAction.mine;
				}
				else if objectCurrentCommand == "Chop" {
					currentAction = unitAction.chop;
				}
				else if objectCurrentCommand == "Farm" {
					currentAction = unitAction.farm;
				}
				else if objectCurrentCommand == "Ruby Mine" {
					currentAction = unitAction.mine;
				}
				exit;
			}
		}
	}
	// Else if its at target location, then exit script.
	else {
		if ds_exists(unitGridLocation, ds_type_grid) {
			var i, self_is_found_;
			self_is_found_ = noone;
			if ds_grid_height(unitGridLocation) > 0 {
				for (i = 0; i < ds_grid_height(unitGridLocation); i++) {
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
		changeVariablesWhenCloseToTarget = true;
		notAtTargetLocation = false;
		validLocationFound = true;
		validPathFound = true;
		justSpawned = false;
		cannot_move_without_better_coordinates_ = false;
		notAtTargetLocation = false;
		needToStartGridSearch = false;
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
		baseSquareEdgeSize = 0;
		squareSizeIncreaseCount = 0;
		squareIteration = 0;
		squareTrueIteration = 0;
		tempCheckX = -1;
		tempCheckY = -1;
		groupRowWidth = 0;
		specificLocationNeedsToBeChecked = false;
		specificLocationToBeCheckedX = -1;
		specificLocationToBeCheckedY = -1;
		searchHasJustBegun = true;
		totalTimesSearched = 0;
		closestPointsToObjectsHaveBeenSet = false;
		movementLeaderOrFollowing = noone;
		if path_exists(myPath) {
			path_delete(myPath);
			myPath = -1;
		}
		if objectCurrentCommand == "Move" {
			objectCurrentCommand = "Idle";
			currentAction = unitAction.idle;
			objectTarget = noone;
			objectTargetType = noone;
			objectTargetTeam = noone;
		}
		else if objectCurrentCommand == "Attack" {
			currentAction = unitAction.attack;
		}
		else if objectCurrentCommand == "Mine" {
			currentAction = unitAction.mine;
		}
		else if objectCurrentCommand == "Chop" {
			currentAction = unitAction.chop;
		}
		else if objectCurrentCommand == "Farm" {
			currentAction = unitAction.farm;
		}
		else if objectCurrentCommand == "Ruby Mine" {
			currentAction = unitAction.mine;
		}
		x = floor(x / 16) * 16;
		y = floor(y / 16) * 16;
	}
}


