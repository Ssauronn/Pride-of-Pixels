///@function								target_next_object();
///@description								If there are other entries in the target list, remove the entry 
///											that turned out to be an invalid target and search for the next entry.

function target_next_object() {
	var original_target_to_attack_ = objectTarget;
	if ds_exists(objectTargetList, ds_type_list) {
		if ds_list_size(objectTargetList) >= 1 {
			forceAttack = false;
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
						forceAttack = false;
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
			// Else if the next target is undefined, it means I ran out of targets in the current list.
			// In this case, I destroy the current list, check for new targets nearby, and if nothing
			// is around, then I reset variables. Otherwise, I set the new target.
			else {
				// Destroy the current target list
				if ds_exists(objectTargetList, ds_type_list) {
					ds_list_destroy(objectTargetList);
					objectTargetList = noone;
				}
				// As long as the unit's command is still to attack, check for a new target
				if objectCurrentCommand == "Attack" {
					check_for_new_target(x, y);
				}
				var assign_target_values_from_list_ = false;
				var target_list_exists_ = ds_exists(objectTargetList, ds_type_list);
				// If a new target does exist, then set variables to attack that target
				if target_list_exists_ {
					// As long as the first target in the list isn't the original target
					// that the function needs to de-target, then set that as the new target.
					if ds_list_find_value(objectTargetList, 0) != original_target_to_attack_ {
						assign_target_values_from_list_ = true;
					}
					// Otherwise, as long as the target list is greater than one, then find a
					// new target.
					else if ds_list_size(objectTargetList) > 1 {
						// First, delete the first entry, since we know the first entry is
						// the original target, which again, we're trying to de-target.
						ds_list_delete(objectTargetList, 0);
						// As a redundancy check, loop through the list, removing any undefined
						// or non-existent objects from the list, until either the first entry
						// in the list is a valid object, or the list is destroyed.
						while target_list_exists_ && ((ds_exists(objectTargetList, ds_type_list)) && ((is_undefined(ds_list_find_value(objectTargetList, 0))) || (!instance_exists(ds_list_find_value(objectTargetList, 0))))) {
							if ds_list_size(objectTargetList) > 1 {
								ds_list_delete(objectTargetList, 0);
							}
							else {
								target_list_exists_ = false;
							}
						}
						// Now, after the above checks, as long as the list still has valid
						// objects to target, then I can assign the next target to the new
						// first entry in the target list.
						if target_list_exists_ {
							assign_target_values_from_list_ = true;
						}
					}
					// Otherwise, if the list is just one target long to start out with, that
					// means there's no other valid targets to target, after I de-target the
					// current target, and so I need to de-aggro and set to just moving along.
					else {
						target_list_exists_ = false;
						ds_list_destroy(objectTargetList);
						objectTargetList = noone;
					}
					if assign_target_values_from_list_ {
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
					else {
						target_list_exists_ = false;
					}
				}
				// If no targets are around, then set variables to return to movement script.
				if !target_list_exists_ {
					objectCurrentCommand = "Move";
					
					targetToMoveToX = originalTargetToMoveToX;
					targetToMoveToY = originalTargetToMoveToY;
					specificLocationNeedsToBeChecked = false;
					specificLocationToBeCheckedX = targetToMoveToX;
					specificLocationToBeCheckedY = targetToMoveToY;
					tempCheckX = targetToMoveToX;
					tempCheckY = targetToMoveToY;
					objectTarget = noone;
					forceAttack = false;
					squareIteration = 0;
					squareTrueIteration = 0;
					squareSizeIncreaseCount = 0;
					baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
					groupDirectionToMoveInAdjusted = 0;
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
					groupRowWidth = 0;
					searchHasJustBegun = true;
					totalTimesSearched = 0;
					closestPointsToObjectsHaveBeenSet = false;
					if ds_exists(objectTargetList, ds_type_list) {
						ds_list_destroy(objectTargetList);
						objectTargetList = noone;
					}
				}
			}
		}
		else {
			objectCurrentCommand = "Move";
			objectTargetList = noone;
			objectTarget = noone;
			forceAttack = false;
			targetToMoveToX = originalTargetToMoveToX;
			targetToMoveToY = originalTargetToMoveToY;
			squareIteration = 0;
			squareTrueIteration = 0;
			squareSizeIncreaseCount = 0;
			baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
			groupDirectionToMoveInAdjusted = 0;
			if ds_exists(objectTargetList, ds_type_list) {
				ds_list_destroy(objectTargetList);
				objectTargetList = noone;
			}
		}
	}
	else {
		if objectCurrentCommand == "Attack" {
			check_for_new_target(x, y);
		}
	}
	if !ds_exists(objectTargetList, ds_type_list) {
		objectCurrentCommand = "Move";
		targetToMoveToX = originalTargetToMoveToX;
		targetToMoveToY = originalTargetToMoveToY;
		specificLocationNeedsToBeChecked = false;
		specificLocationToBeCheckedX = targetToMoveToX;
		specificLocationToBeCheckedY = targetToMoveToY;
		tempCheckX = targetToMoveToX;
		tempCheckY = targetToMoveToY;
		objectTarget = noone;
		forceAttack = false;
		squareIteration = 0;
		squareTrueIteration = 0;
		squareSizeIncreaseCount = 0;
		baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
		groupDirectionToMoveInAdjusted = 0;
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
		groupRowWidth = 0;
		searchHasJustBegun = true;
		totalTimesSearched = 0;
		closestPointsToObjectsHaveBeenSet = false;
		if ds_exists(objectTargetList, ds_type_list) {
			ds_list_destroy(objectTargetList);
			objectTargetList = noone;
		}
	}
}

///@function							remove_self_from_only_moving_grid();
///@description							Removes the unit calling this function from the grid unitsCurrentlyOnlyMovingGrid.
function remove_self_from_only_moving_grid() {
	// If the unit is still part of the grid containing the info of units only assigned to move, then remove it, since it is no
	// longer going to move.
	if ds_exists(unitsCurrentlyOnlyMovingGrid, ds_type_grid) {
		var only_moving_grid_height_ = ds_grid_height(unitsCurrentlyOnlyMovingGrid);
		if ds_grid_height(unitsCurrentlyOnlyMovingGrid) > 1 {
			var self_id_index_;
			self_id_index_ = ds_grid_value_y(unitsCurrentlyOnlyMovingGrid, 0, 0, 0, only_moving_grid_height_ - 1, self.id);
			if self_id_index_ != -1 {
				ds_grid_set_grid_region(unitsCurrentlyOnlyMovingGrid, unitsCurrentlyOnlyMovingGrid, 0, self_id_index_ + 1, 3, only_moving_grid_height_ - 1, 0, self_id_index_);
				ds_grid_resize(unitsCurrentlyOnlyMovingGrid, 4, only_moving_grid_height_ - 1);
			}
		}
		else {
			ds_grid_destroy(unitsCurrentlyOnlyMovingGrid);
			unitsCurrentlyOnlyMovingGrid = noone;
		}
	}
}


///@function							unit_move();
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
			// If the unit is still part of the grid containing the info of units only assigned to move, then remove it, since it is no
			// longer going to only move. In this case, it has a target and shouldn't be part of the list of objects only moving anymore.
			remove_self_from_only_moving_grid();
			
			if !path_exists(myPath) {
				if distance_to_object(objectTarget) < objectAttackRange {
					// Change below to set target to closest location within a square
					// checking each corner of x+/-8 and y+/-8.
					var original_x_ = x;
					var original_y_ = y;
					var point_distance_ = distance_to_object(objectTarget);
					var choice_ = 0;
					// Check the square the unit is currently on.
					x = original_x_ + 8;
					y = original_y_ + 8;
					if (distance_to_object(objectTarget) <= point_distance_) && (position_empty(floor(x / 16) * 16, floor(y / 16) * 16)) {
						point_distance_ = distance_to_object(objectTarget);
						choice_ = 1;
					}
					// Check the square above the unit
					x = original_x_ + 8;
					y = original_y_ - 8;
					if (distance_to_object(objectTarget) < point_distance_) && (position_empty(floor(x / 16) * 16, floor(y / 16) * 16)) {
						point_distance_ = distance_to_object(objectTarget);
						choice_ = 2;
					}
					// Check the square to the left of the unit
					x = original_x_ - 8;
					y = original_y_ + 8;
					if (distance_to_object(objectTarget) < point_distance_) && (position_empty(floor(x / 16) * 16, floor(y / 16) * 16)) {
						point_distance_ = distance_to_object(objectTarget);
						choice_ = 3;
					}
					// Check the square above and to the left of the unit
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
					if ((floor(x / 16) * 16) == targetToMoveToX) && ((floor(y / 16) * 16) == targetToMoveToY) {
						squareIteration = 0;
						squareTrueIteration = 0;
						squareSizeIncreaseCount = 0;
						baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
						groupDirectionToMoveInAdjusted = 0;
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
				if objectType == "Worker" {
					if objectCurrentCommand == "Move" {
						if ds_exists(player[objectRealTeam].listOfStorehousesAndCityHalls, ds_type_list) {
							ds_list_sort_distance(x, y, player[objectRealTeam].listOfStorehousesAndCityHalls);
							if distance_to_object(real(ds_list_find_value(player[objectRealTeam].listOfStorehousesAndCityHalls, 0))) < 16 {
								player[objectRealTeam].food += currentFoodCarry;
								player[objectRealTeam].wood += currentWoodCarry;
								player[objectRealTeam].gold += currentGoldCarry;
								player[objectRealTeam].rubies += currentRubyCarry;
								currentFoodCarry = 0;
								currentWoodCarry = 0;
								currentGoldCarry = 0;
								currentRubyCarry = 0;
								currentResourceWeightCarry = 0;
							}
						}
					}
				}
				squareIteration = 0;
				squareTrueIteration = 0;
				squareSizeIncreaseCount = 0;
				baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
				groupDirectionToMoveInAdjusted = 0;
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
			
			// If the unit is searching for a location, and it's target location to search for is both empty and the same as other units,
			// then add it to a list. That list is later used to sort by front liners and back liners, so that units that are more tanky
			// are up in the front relative to the direction they were moving, and the less tanky units are in the back.
			var k, x_location_to_check_is_taken_, y_location_to_check_is_taken_, target_location_is_taken_;
			target_location_is_taken_ = false;
			// If the unit doesn't have a target it needs to move to, meaning it's doing nothing but moving
			if (objectTarget == noone) && (objectCurrentCommand == "Move") {
				// And if the target location is not occupied in the movementGrid, meaning there isn't a building or resource there
				if mp_grid_get_cell(movementGrid, floor(targetToMoveToX / 16), floor(targetToMoveToY / 16)) == 0 {
					// If the above is true, then add the unit to the list unitsCurrentlyOnlyMovingGrid, to use later in this
					// script to swap unit places with other units in order to put the tankier units up front and weaker units
					// in the back, regardless of formation.
					if ds_exists(unitsCurrentlyOnlyMovingGrid, ds_type_grid) {
						// If the instance ID isn't yet added to the grid
						if ds_grid_value_exists(unitsCurrentlyOnlyMovingGrid, 0, 0, 0, ds_grid_height(unitsCurrentlyOnlyMovingGrid) - 1, self.id) == false {
							ds_grid_resize(unitsCurrentlyOnlyMovingGrid, 4, ds_grid_height(unitsCurrentlyOnlyMovingGrid) + 1);
							// Get the directional quadrant to the target, then add the unit to the list of objects that are doing nothing
							// but moving to a specific target location.
							var directional_quadrant_, point_direction_to_target_location_;
							point_direction_to_target_location_ = point_direction(x, y, targetToMoveToX, targetToMoveToY) + 45;
							if point_direction_to_target_location_ >= 360 {
								point_direction_to_target_location_ -= 360;
							}
							directional_quadrant_ = floor(point_direction_to_target_location_ / 90);
							ds_grid_add(unitsCurrentlyOnlyMovingGrid, 0, ds_grid_height(unitsCurrentlyOnlyMovingGrid) - 1, self.id);
							ds_grid_add(unitsCurrentlyOnlyMovingGrid, 1, ds_grid_height(unitsCurrentlyOnlyMovingGrid) - 1, floor(targetToMoveToX / 16) * 16);
							ds_grid_add(unitsCurrentlyOnlyMovingGrid, 2, ds_grid_height(unitsCurrentlyOnlyMovingGrid) - 1, floor(targetToMoveToY / 16) * 16);
							ds_grid_add(unitsCurrentlyOnlyMovingGrid, 3, ds_grid_height(unitsCurrentlyOnlyMovingGrid) - 1, directional_quadrant_);
						}
					}
					else {
						// Get the directional quadrant to the target, then add the unit to the list of objects that are doing nothing
						// but moving to a specific target location.
						var directional_quadrant_, point_direction_to_target_location_;
						point_direction_to_target_location_ = point_direction(x, y, targetToMoveToX, targetToMoveToY) + 45;
						if point_direction_to_target_location_ >= 360 {
							point_direction_to_target_location_ -= 360;
						}
						directional_quadrant_ = floor(point_direction_to_target_location_ / 90);
						unitsCurrentlyOnlyMovingGrid = ds_grid_create(4, 1);
						ds_grid_add(unitsCurrentlyOnlyMovingGrid, 0, 0, self.id);
						ds_grid_add(unitsCurrentlyOnlyMovingGrid, 1, 0, floor(targetToMoveToX / 16) * 16);
						ds_grid_add(unitsCurrentlyOnlyMovingGrid, 2, 0, floor(targetToMoveToY / 16) * 16);
						ds_grid_add(unitsCurrentlyOnlyMovingGrid, 3, 0, directional_quadrant_);
					}
				}
			}
			
			if ds_exists(unitsCurrentlyOnlyMovingGrid, ds_type_grid) {
				var yeet_ = ds_grid_height(unitsCurrentlyOnlyMovingGrid);
				if yeet_ > 1 {
					var yeet_ = 1;
				}
			}
			
			// Move the unit while waiting for a path to be found.
			if point_distance(x, y, targetToMoveToX, targetToMoveToY) > groupRowWidth * 16 {
				// I don't move the unit while waiting for a path if it's currently in combat, because it's causing too
				// many issues. It also looks better in testing, to have slight delays after killing it's current target
				// and looking for a new one.
				if objectCurrentCommand != "Attack" {
					var orig_x_, orig_y_;
					orig_x_ = x;
					orig_y_ = y;
					mp_potential_step(targetToMoveToX, targetToMoveToY, currentMovementSpeed, false);
					// Because origin points for objects are set to the top left of the object, I check to make sure a 1x1 object
					// won't clip into any objects not yet colliding with the origin point (i.e., to the right, or below).
					if (mp_grid_get_cell(movementGrid, floor(x / 16), floor(y / 16)) == -1) || (mp_grid_get_cell(movementGrid, floor((x + 15) / 16), floor(y / 16)) == -1) || (mp_grid_get_cell(movementGrid, floor((x + 15) / 16), floor((y + 15) / 16)) == -1) || (mp_grid_get_cell(movementGrid, floor(x / 16), floor((y + 15) / 16)) == -1) {
						x = orig_x_;
						y = orig_y_;
					}
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
									targetToMoveToX = floor(originalTargetToMoveToX / 16) * 16;
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
				else if (movementLeaderOrFollowing.currentAction == unitAction.move) && (point_distance(movementLeaderOrFollowing.x, movementLeaderOrFollowing.y, movementLeaderOrFollowing.targetToMoveToX, movementLeaderOrFollowing.targetToMoveToY) > currentMovementSpeed) {
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
				squareIteration = 0;
				squareTrueIteration = 0;
				squareSizeIncreaseCount = 0;
				baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
				groupDirectionToMoveInAdjusted = 0;
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
				squareIteration = 0;
				squareTrueIteration = 0;
				squareSizeIncreaseCount = 0;
				baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
				groupDirectionToMoveInAdjusted = 0;
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
			if ((!instance_exists(objectTarget)) && (point_distance(x, y, targetToMoveToX, targetToMoveToY) >= (currentMovementSpeed * 2))) || ((instance_exists(objectTarget)) && ((point_distance(x, y, targetToMoveToX, targetToMoveToY)) >= (currentMovementSpeed * 2))) || (!original_location_is_valid_) {
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
								// at the max distance allowed by their objectAttackRange.
								if objectAttackRange <= 16 {
									melee_unit_ = true;
									ranged_unit_starting_ring_ = -1;
								}
								else {
									melee_unit_ = false;
									ranged_unit_starting_ring_ = (floor(objectAttackRange / 16) * 16) / 16;
									if (ds_exists(objectTargetList, ds_type_list)) && (instance_exists(objectTarget)) {
										// If the ranged object is already in range of target, don't move! It can act already.
										if ((instance_exists(objectTarget)) && (point_distance(x, y, objectTarget.x, objectTarget.y)) <= objectAttackRange) || (point_distance(x, y, targetToMoveToX, targetToMoveToY) <= currentMovementSpeed) {
											if objectType == "Worker" {
												if objectCurrentCommand == "Move" {
													if ds_exists(player[objectRealTeam].listOfStorehousesAndCityHalls, ds_type_list) {
														ds_list_sort_distance(x, y, player[objectRealTeam].listOfStorehousesAndCityHalls);
														if distance_to_object(real(ds_list_find_value(player[objectRealTeam].listOfStorehousesAndCityHalls, 0))) < 16 {
															player[objectRealTeam].food += currentFoodCarry;
															player[objectRealTeam].wood += currentWoodCarry;
															player[objectRealTeam].gold += currentGoldCarry;
															player[objectRealTeam].rubies += currentRubyCarry;
															currentFoodCarry = 0;
															currentWoodCarry = 0;
															currentGoldCarry = 0;
															currentRubyCarry = 0;
															currentResourceWeightCarry = 0;
														}
													}
												}
											}
											targetToMoveToX = floor(x / 16) * 16;
											targetToMoveToY = floor(y / 16) * 16;
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
											forceAttack = false;
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
												objectGoldMineSpeedTimer = objectGoldMineSpeed;
											}
											else if objectCurrentCommand == "Chop" {
												currentAction = unitAction.chop;
												objectWoodChopSpeedTimer = objectWoodChopSpeed;
											}
											else if objectCurrentCommand == "Farm" {
												currentAction = unitAction.farm;
												objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
											}
											else if objectCurrentCommand == "Ruby Mine" {
												currentAction = unitAction.mine;
												objectRubyMineSpeedTimer = objectRubyMineSpeed;
											}
											currentImageIndex = 0;
											objectAttackSpeedTimer = objectAttackSpeed;
											exit;
										}
										// Else continue the movement process.
										else {
											squareSizeIncreaseCount = ranged_unit_starting_ring_;
										}
									}
									// If the ranged unit doesn't have a target, then move like any other unit
									else {
										squareSizeIncreaseCount = 0;
										ranged_unit_starting_ring_ = 0;
									}
									ranged_unit_direction_moving_in_ = groupDirectionToMoveIn + groupDirectionToMoveInAdjusted;
								}
							}
							// If the object's target doesn't exist but alternative targets do exist,
							// find a new target.
							if (ds_exists(objectTargetList, ds_type_list)) && (objectTarget == noone) {
								target_next_object();
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
								// If the object's target doesn't exist but alternative targets do exist,
								// find a new target.
								if (ds_exists(objectTargetList, ds_type_list)) && (objectTarget == noone) {
									target_next_object();
								}
								if !instance_exists(objectTarget) {
									var yeet_ = 1;
								}
								// Set the size of the minimum pattern.
								var horizontal_edge_size_, vertical_edge_size_;
								// If the search area is surrounding a 1x1 grid area
								if (objectTarget.objectClassification == "Unit") || (objectTarget.objectType == "Food") || (objectTarget.objectType == "Wood") {
									horizontal_edge_size_ = 1;
									vertical_edge_size_ = 1;
								}
								else {
									horizontal_edge_size_ = sprite_get_width(objectTarget.mask_index) / 16;
									vertical_edge_size_ = sprite_get_height(objectTarget.mask_index) / 16;
								}
							}
							
							// Now, perform the actual search.
							while still_need_to_search_ {
								// If, after checking for a specific location, it still wasn't valid,
								// move on and continue the search.
								if still_need_to_search_ {
									
									/// Set variables that will auto set the rest of the formation based on what formation the Unit is set to
									if unitFormation == "Hollow Square" {
										// I only set the units to form up in a hollow square if there is no target, because otherwise
										// units would never reach their target and just keep their target in the empty center.
										if !instance_exists(objectTarget) {
											if squareSizeIncreaseCount == 0 {
												if ds_exists(objectsSelectedList, ds_type_list) {
													if ds_list_size(objectsSelectedList) > 23 {
														squareSizeIncreaseCount = 2;
													}
													else {
														squareSizeIncreaseCount = 1;
													}
												}
												else {
													squareSizeIncreaseCount = 1;
												}
											}
										}
									}
									baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
									var square_horizontal_edge_sizes_ = baseSquareEdgeSize + (horizontal_edge_size_ - 1);
									var square_vertical_edge_sizes_ = baseSquareEdgeSize + (vertical_edge_size_ - 1);
									// Finally, if the formation set is rows, adjust the square sizes AFTER the default row sizes are set,
									// so that all I'm doing is overwriting the previous values only when needed.
									if unitFormation == "Rows" {
										// This is done AFTER the local variables are set here, because if the formation is set to lines, the
										// object should adjust it's edge sizes based on the direction to the target.
										if !instance_exists(objectTarget) { 
											var point_direction_to_target_ = point_direction(x, y, targetToMoveToX, targetToMoveToY) + 45;
											if point_direction_to_target_ >= 360 {
												point_direction_to_target_ -= 360;
											}
											if point_direction_to_target_ >= 0 && point_direction_to_target_ < 90 {
												// The unit's target location is in the right quadrant, meaning the vertical rows should be long
												// and static, and the horizontal rows should iterate as normal.
												// THIS VALUE CAN ONLY BE ODD (faaaaaar cleaner in game to keep this value odd than to set it even).
												square_vertical_edge_sizes_ = 7;
												if ds_exists(objectsSelectedList, ds_type_list) {
													square_vertical_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
													if square_vertical_edge_sizes_ mod 2 == 0 {
														square_vertical_edge_sizes_--;
													}
												}
												// Set this to the quadrant value, because later I use this variable again to correctly search along
												// a rectangle path.
												point_direction_to_target_ = 0;
											}
											else if point_direction_to_target_ >= 90 && point_direction_to_target_ < 180 {
												// The unit's target location is in the right quadrant, meaning the horizontal rows should be long
												// and static, and the vertical rows should iterate as normal.
												square_horizontal_edge_sizes_ = 7;
												if ds_exists(objectsSelectedList, ds_type_list) {
													square_horizontal_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
													if square_horizontal_edge_sizes_ mod 2 == 0 {
														square_horizontal_edge_sizes_--;
													}
												}
												point_direction_to_target_ = 1;
											}
											else if point_direction_to_target_ >= 180 && point_direction_to_target_ < 270 {
												// The unit's target location is in the left quadrant, meaning the vertical rows should be long
												// and static, and the horizontal rows should iterate as normal.
												square_vertical_edge_sizes_ = 7;
												if ds_exists(objectsSelectedList, ds_type_list) {
													square_vertical_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
													if square_vertical_edge_sizes_ mod 2 == 0 {
														square_vertical_edge_sizes_--;
													}
												}
												point_direction_to_target_ = 2;
											}
											else {
												// The unit's target location is in the right quadrant, meaning the horizontal rows should be long
												// and static, and the vertical rows should iterate as normal.
												square_horizontal_edge_sizes_ = 7;
												if ds_exists(objectsSelectedList, ds_type_list) {
													square_horizontal_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
													if square_horizontal_edge_sizes_ mod 2 == 0 {
														square_horizontal_edge_sizes_--;
													}
												}
												point_direction_to_target_ = 3;
											}
										}
									}
									// After all of the square_... variables have been set correctly based on the formation ordered into, set the
									// perimeter size variable.
									var square_peremeter_size_ = (square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2);
									
									/// Set squareIteration (the variable used to move the search across the perimeter of the current search square)
									// equal to 0 or 1 if the search has just started. This only executes once, at the start of the search.
									if squareTrueIteration < ((square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2)) {
										if squareIteration == square_peremeter_size_ {
											squareIteration = 0;
										}
										else if squareIteration > square_peremeter_size_ {
											squareIteration = 1;
										}
									}
									
									/// Top edge, moving left to right
									if squareIteration < (square_horizontal_edge_sizes_) {
										if (melee_unit_) || ((!melee_unit_) && (ranged_unit_direction_moving_in_ == 3) && (instance_exists(objectTarget))) || ((!melee_unit_) && (!instance_exists(objectTarget))) {
											// Start at the left corner and move right
											tempCheckX = targetToMoveToX - (squareSizeIncreaseCount * 16) + (squareIteration * 16);
											// Shift the temporary check upwards to the top edge
											tempCheckY = targetToMoveToY - ((squareSizeIncreaseCount + (vertical_edge_size_ - 1)) * 16);
											// Adjust the size to start at the actual correct location in case the formation ordered
											// into is Rows.
											if unitFormation == "Rows" {
													tempCheckY = targetToMoveToY - (((square_vertical_edge_sizes_ - 1) / 2) * 16);
													tempCheckX = targetToMoveToX - (((square_horizontal_edge_sizes_ - 1) / 2) * 16) + (squareIteration * 16);
											}
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
											// Adjust the size to start at the actual correct location in case the formation ordered
											// into is Rows.
											if unitFormation == "Rows" {
												tempCheckY = targetToMoveToY - (((square_vertical_edge_sizes_ - 1) / 2) * 16) + ((squareIteration - square_horizontal_edge_sizes_) * 16);
												tempCheckX = targetToMoveToX + (((square_horizontal_edge_sizes_ - 1) / 2) * 16);
											}
										}
										else {
											squareIteration += (square_horizontal_edge_sizes_ + square_vertical_edge_sizes_) - squareIteration;
											squareTrueIteration += (square_horizontal_edge_sizes_ + square_vertical_edge_sizes_) - squareIteration;
										}
									}
									// Bottom edge, moving right to left
									else if squareIteration < ((square_horizontal_edge_sizes_ * 2) + square_vertical_edge_sizes_) {
										if (melee_unit_) || ((!melee_unit_) && (ranged_unit_direction_moving_in_ == 1) && (instance_exists(objectTarget))) || ((!melee_unit_) && (!instance_exists(objectTarget))) {
											/// Start at the bottom right corner, and move left. How it works:
											// Start at origin point targetToMoveToX. Shift over to the right
											// edge. Move left by subtracting squareIteration * 16. Adjust for
											// the previous two sides that have already been run through by
											// adding the equivalent pixel size of two sides to the coordinates.
											tempCheckX = targetToMoveToX + ((squareSizeIncreaseCount + (horizontal_edge_size_ - 1)) * 16) - (squareIteration * 16) + ((((squareSizeIncreaseCount * 2) + 1) + (horizontal_edge_size_ - 1)) * 16) + ((((squareSizeIncreaseCount * 2) + 1) + (vertical_edge_size_ - 1)) * 16);
											// Shift the temporary check downwards to the bottom edge
											tempCheckY = targetToMoveToY + (squareSizeIncreaseCount * 16);
											
											// Adjust the size to start at the actual correct location in case the formation ordered
											// into is Rows.
											if unitFormation == "Rows" {
												tempCheckY = targetToMoveToY + (((square_vertical_edge_sizes_ - 1) / 2) * 16);
												tempCheckX = targetToMoveToX + (((square_horizontal_edge_sizes_ - 1) / 2) * 16) - ((squareIteration - square_horizontal_edge_sizes_ - square_vertical_edge_sizes_) * 16);
											}
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
											
											// Adjust the size to start at the actual correct location in case the formation ordered
											// into is Rows.
											if unitFormation == "Rows" {
												tempCheckY = targetToMoveToY + (((square_vertical_edge_sizes_ - 1) / 2) * 16) - ((squareIteration - (square_horizontal_edge_sizes_ * 2) - square_vertical_edge_sizes_) * 16);
												tempCheckX = targetToMoveToX - (((square_horizontal_edge_sizes_ - 1) / 2) * 16);
											}
										}
										else {
											squareIteration += ((square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2)) - squareIteration;
											squareTrueIteration += ((square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2)) - squareIteration;
										}
									}
									if point_distance(tempCheckX, tempCheckY, mouse_x, mouse_y) > 5 * 16 {
										var yeet_ = 0;
									}
									// Iterate the count that moves along the edges up by one
									squareIteration++;
									squareTrueIteration++;
									// If the iteration count reaches the max amount of squares on the perimeter
									// of the search square, reset the iteration count, increment the size increase
									// count by one, and set baseSquareEdgeSize to equal the correct values based off
									// of the new squareSizeIncreaseCount value.
									if squareTrueIteration >= (square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2) {
									//if squareTrueIteration >= ((((squareSizeIncreaseCount * 2) + 1) + (horizontal_edge_size_ - 1)) * 2) + ((((squareSizeIncreaseCount * 2) + 1) + (vertical_edge_size_ - 1)) * 2) {
										// If the search is being made by a melee object or a ranged unitAction that isn't targeting
										// anything, then expand the search outwards.
										if melee_unit_ || (ranged_unit_starting_ring_ == 0) {
											squareSizeIncreaseCount++;
										}
										// Otherwise, expand the search inwards if the search is being made by a ranged unitAction
										// that has a valid target, and is set to a "Square" formation.
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
										
										/// Set variables that will auto set the rest of the formation based on what formation the Unit is set to
										if unitFormation == "Hollow Square" {
											// I only set the units to form up in a hollow square if there is no target, because otherwise
											// units would never reach their target and just keep their target in the empty center.
											if !instance_exists(objectTarget) {
												if squareSizeIncreaseCount == 0 {
													if ds_exists(objectsSelectedList, ds_type_list) {
														if ds_list_size(objectsSelectedList) > 23 {
															squareSizeIncreaseCount = 2;
														}
														else {
															squareSizeIncreaseCount = 1;
														}
													}
													else {
														squareSizeIncreaseCount = 1;
													}
												}
											}
										}
										baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
										var square_horizontal_edge_sizes_ = baseSquareEdgeSize + (horizontal_edge_size_ - 1);
										var square_vertical_edge_sizes_ = baseSquareEdgeSize + (vertical_edge_size_ - 1);
										// Finally, if the formation set is rows, adjust the square sizes AFTER the default row sizes are set,
										// so that all I'm doing is overwriting the previous values only when needed.
										if unitFormation == "Rows" {
											// This is done AFTER the local variables are set here, because if the formation is set to lines, the
											// object should adjust it's edge sizes based on the direction to the target.
											if !instance_exists(objectTarget) { 
												var point_direction_to_target_ = point_direction(x, y, targetToMoveToX, targetToMoveToY) + 45;
												if point_direction_to_target_ >= 360 {
													point_direction_to_target_ -= 360;
												}
												if point_direction_to_target_ >= 0 && point_direction_to_target_ < 90 {
													// The unit's target location is in the right quadrant, meaning the vertical rows should be long
													// and static, and the horizontal rows should iterate as normal.
													// THIS VALUE CAN ONLY BE ODD (faaaaaar cleaner in game to keep this value odd than to set it even).
													square_vertical_edge_sizes_ = 7;
													if ds_exists(objectsSelectedList, ds_type_list) {
														square_vertical_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
														if square_vertical_edge_sizes_ mod 2 == 0 {
															square_vertical_edge_sizes_--;
														}
													}
													// Set this to the quadrant value, because later I use this variable again to correctly search along
													// a rectangle path.
													point_direction_to_target_ = 0;
												}
												else if point_direction_to_target_ >= 90 && point_direction_to_target_ < 180 {
													// The unit's target location is in the right quadrant, meaning the horizontal rows should be long
													// and static, and the vertical rows should iterate as normal.
													square_horizontal_edge_sizes_ = 7;
													if ds_exists(objectsSelectedList, ds_type_list) {
														square_horizontal_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
														if square_horizontal_edge_sizes_ mod 2 == 0 {
															square_horizontal_edge_sizes_--;
														}
													}
													point_direction_to_target_ = 1;
												}
												else if point_direction_to_target_ >= 180 && point_direction_to_target_ < 270 {
													// The unit's target location is in the left quadrant, meaning the vertical rows should be long
													// and static, and the horizontal rows should iterate as normal.
													square_vertical_edge_sizes_ = 7;
													if ds_exists(objectsSelectedList, ds_type_list) {
														square_vertical_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
														if square_vertical_edge_sizes_ mod 2 == 0 {
															square_vertical_edge_sizes_--;
														}
													}
													point_direction_to_target_ = 2;
												}
												else {
													// The unit's target location is in the right quadrant, meaning the horizontal rows should be long
													// and static, and the vertical rows should iterate as normal.
													square_horizontal_edge_sizes_ = 7;
													if ds_exists(objectsSelectedList, ds_type_list) {
														square_horizontal_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
														if square_horizontal_edge_sizes_ mod 2 == 0 {
															square_horizontal_edge_sizes_--;
														}
													}
													point_direction_to_target_ = 3;
												}
											}
										}
										// After all of the square_... variables have been set correctly based on the formation ordered into, set the
										// perimeter size variable.
										var square_peremeter_size_ = (square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2);
										
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
									if squareTrueIteration == (square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2) {
									//if squareTrueIteration == ((((squareSizeIncreaseCount * 2) + 1) + (horizontal_edge_size_ - 1)) * 2) + ((((squareSizeIncreaseCount * 2) + 1) + (vertical_edge_size_ - 1)) * 2) {
										// If the search is being made by a melee object or a ranged unitAction that isn't targeting
										// anything, then expand the search outwards.
										if melee_unit_ || (ranged_unit_starting_ring_ == 0) {
											squareSizeIncreaseCount++;
										}
										// Otherwise, expand the search inwards if the search is being made by a ranged unitAction
										// that has a valid target, and is set to a "Square" formation.
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
										
										/// Set variables that will auto set the rest of the formation based on what formation the Unit is set to
										if unitFormation == "Hollow Square" {
											// I only set the units to form up in a hollow square if there is no target, because otherwise
											// units would never reach their target and just keep their target in the empty center.
											if !instance_exists(objectTarget) {
												if squareSizeIncreaseCount == 0 {
													if ds_exists(objectsSelectedList, ds_type_list) {
														if ds_list_size(objectsSelectedList) > 23 {
															squareSizeIncreaseCount = 2;
														}
														else {
															squareSizeIncreaseCount = 1;
														}
													}
													else {
														squareSizeIncreaseCount = 1;
													}
												}
											}
										}
										baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
										var square_horizontal_edge_sizes_ = baseSquareEdgeSize + (horizontal_edge_size_ - 1);
										var square_vertical_edge_sizes_ = baseSquareEdgeSize + (vertical_edge_size_ - 1);
										// Finally, if the formation set is rows, adjust the square sizes AFTER the default row sizes are set,
										// so that all I'm doing is overwriting the previous values only when needed.
										if unitFormation == "Rows" {
											// This is done AFTER the local variables are set here, because if the formation is set to lines, the
											// object should adjust it's edge sizes based on the direction to the target.
											if !instance_exists(objectTarget) { 
												var point_direction_to_target_ = point_direction(x, y, targetToMoveToX, targetToMoveToY) + 45;
												if point_direction_to_target_ >= 360 {
													point_direction_to_target_ -= 360;
												}
												if point_direction_to_target_ >= 0 && point_direction_to_target_ < 90 {
													// The unit's target location is in the right quadrant, meaning the vertical rows should be long
													// and static, and the horizontal rows should iterate as normal.
													// THIS VALUE CAN ONLY BE ODD (faaaaaar cleaner in game to keep this value odd than to set it even).
													square_vertical_edge_sizes_ = 7;
													if ds_exists(objectsSelectedList, ds_type_list) {
														square_vertical_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
														if square_vertical_edge_sizes_ mod 2 == 0 {
															square_vertical_edge_sizes_--;
														}
													}
													// Set this to the quadrant value, because later I use this variable again to correctly search along
													// a rectangle path.
													point_direction_to_target_ = 0;
												}
												else if point_direction_to_target_ >= 90 && point_direction_to_target_ < 180 {
													// The unit's target location is in the right quadrant, meaning the horizontal rows should be long
													// and static, and the vertical rows should iterate as normal.
													square_horizontal_edge_sizes_ = 7;
													if ds_exists(objectsSelectedList, ds_type_list) {
														square_horizontal_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
														if square_horizontal_edge_sizes_ mod 2 == 0 {
															square_horizontal_edge_sizes_--;
														}
													}
													point_direction_to_target_ = 1;
												}
												else if point_direction_to_target_ >= 180 && point_direction_to_target_ < 270 {
													// The unit's target location is in the left quadrant, meaning the vertical rows should be long
													// and static, and the horizontal rows should iterate as normal.
													square_vertical_edge_sizes_ = 7;
													if ds_exists(objectsSelectedList, ds_type_list) {
														square_vertical_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
														if square_vertical_edge_sizes_ mod 2 == 0 {
															square_vertical_edge_sizes_--;
														}
													}
													point_direction_to_target_ = 2;
												}
												else {
													// The unit's target location is in the right quadrant, meaning the horizontal rows should be long
													// and static, and the vertical rows should iterate as normal.
													square_horizontal_edge_sizes_ = 7;
													if ds_exists(objectsSelectedList, ds_type_list) {
														square_horizontal_edge_sizes_ = min(ds_list_size(objectsSelectedList), 7);
														if square_horizontal_edge_sizes_ mod 2 == 0 {
															square_horizontal_edge_sizes_--;
														}
													}
													point_direction_to_target_ = 3;
												}
											}
										}
										// After all of the square_... variables have been set correctly based on the formation ordered into, set the
										// perimeter size variable.
										var square_peremeter_size_ = (square_horizontal_edge_sizes_ * 2) + (square_vertical_edge_sizes_ * 2);
										
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
									
									// Here I check for whether the unit running this movement is targeting something
									// to attack, and if so, I target the next object if the search exceeds the attack
									// range of the unit. However, I double check to make sure the list of targets has
									// another target to focus, and if it doesn't, then I do nothing, and the search
									// for a spot to move to continues, with the exception that now the unit won't
									// be able to attack a target.
									if melee_unit_ {
										if ds_exists(objectTargetList, ds_type_list) {
											if squareSizeIncreaseCount > 1 {
												if ds_list_size(objectTargetList) != 1 {
													target_next_object();
												}
											}
										}
									}
									// Specifically in ranged unit's cases, since they start at their maximum range
									// and move their search inwards, if there is no valid location to move to
									// around their target and no other target to focus, then the search is converted
									// to a melee unit search and the search expands outwards from there. This does mean
									// I check many locations twice, but it also means that I guarantee I'll find the
									// location closest to the mass of units surrounding it's nearest target.
									else if !melee_unit_ {
										if ds_exists(objectTargetList, ds_type_list) {
											if squareSizeIncreaseCount == 0 {
												if ds_list_size(objectTargetList) != 1 {
													target_next_object();
												}
												else {
													melee_unit_ = true;
													ranged_unit_starting_ring_ = -1;
													squareIteration = 0;
													squareTrueIteration = 0;
													squareSizeIncreaseCount = 0;
													baseSquareEdgeSize = (squareSizeIncreaseCount * 2) + 1;
												}
											}
										}
									}
						
					
									// Now that y axis has been incremented, perform preliminary searches and
									// check for a path, or increment x_n_ further until correct location found.
									// First, check to see if the cell itself is a valid location. If not, its
									// automatically excluded.
									if mp_grid_get_cell(movementGrid, tempCheckX / 16, tempCheckY / 16) == 0 {
										if tempCheckX == -1 {
											var yeet_ = 1;
										}
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
										if instance_exists(movementLeaderOrFollowing) {
											if path_exists(movementLeaderOrFollowing.myPath) {
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
											}
											else {
												create_new_path_ = true;
											}
										}
										else {
											create_new_path_ = true;
										}
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
										path_found_ = true;
									}
									// THIS NEEDS TO BE ADJUSTED TO ACCOMMODATE FOR FORMATIONS - in this case, no matter the formation,
									// front liners need to take the front, relative to the direction clicked in.
									// I can manipulate the objects located in the global list objectsSelectedList, because the only
									// time a formation should occur is if the player commands movement, and it only takes 2-3 frames
									// for every selected object to find their pathing.
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
								// I only check for a unit, because units can potentially move. This chunk of code below is to
								// check to see if the target object is moving, and if it is, I attempt to force the unit to find
								// a spot that would meet the target unit on its current path.
								if objectTarget.objectClassification == "Unit" {
									if objectTarget.currentAction == unitAction.move {
										// If the distance to the target is less than its attack range, and the target its chasing
										// is also moving, set a new target to move to equal to its own location once its within range.
										var adjusted_object_range_ = objectAttackRange;
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
											tempCheckX = targetToMoveToX;
											tempCheckY = targetToMoveToY;
											groupRowWidth = 0;
											specificLocationNeedsToBeChecked = false;
											specificLocationToBeCheckedX = targetToMoveToX;
											specificLocationToBeCheckedY = targetToMoveToY;
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
										// one, and if I ran this every frame, no object with a valid target further than its objectAttackRange would
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
											tempCheckX = targetToMoveToX;
											tempCheckY = targetToMoveToY;
											groupRowWidth = 0;
											specificLocationNeedsToBeChecked = false;
											specificLocationToBeCheckedX = targetToMoveToX;
											specificLocationToBeCheckedY = targetToMoveToY;
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
						- vector is determined by direction to colliding objects
						- strength of vector grows as the object is closer
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
											if sign(lengthdir_x(currentMovementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8))) == sign(x_clip_vector_add_) {
												x_clip_vector_add_ = 0;
												x_needs_to_be_removed_ = true;
											}
											if sign(lengthdir_y(currentMovementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8))) == sign(y_clip_vector_add_) {
												y_clip_vector_add_ = 0;
												y_needs_to_be_removed_ = true;
											}
										}
										else if point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) > currentMovementSpeed * 2 {
											if sign(lengthdir_x(currentMovementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)))) == sign(x_clip_vector_add_) {
												x_clip_vector_add_ = 0;
												x_needs_to_be_removed_ = true;
											}
											if sign(lengthdir_y(currentMovementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)))) == sign(y_clip_vector_add_) {
												y_clip_vector_add_ = 0;
												y_needs_to_be_removed_ = true;
											}
										}
									}
									else if point_distance(x, y, targetToMoveToX, targetToMoveToY) >= currentMovementSpeed * 2 {
										if sign(lengthdir_x(currentMovementSpeed, point_direction(x, y, targetToMoveToX, targetToMoveToY))) == sign(x_clip_vector_add_) {
											x_clip_vector_add_ = 0;
											x_needs_to_be_removed_ = true;
										}
										if sign(lengthdir_y(currentMovementSpeed, point_direction(x, y, targetToMoveToX, targetToMoveToY))) == sign(y_clip_vector_add_) {
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
						// Set x and y vectors equal to a percentage of currentMovementSpeed, where that percentage is determine by how
						// close the unit is currently to the center of all colliding objects. That percentage can only max out at
						// 1/4 of max speed, to prevent movement from being stopped while its supposed to be moving.
						if x_clip_vector_ != 0 {
							x_clip_vector_ = (currentMovementSpeed * (x_clip_vector_ / ((abs(x_clip_vector_ div 16) + 1) * 16))) / 4;
						}
						if y_clip_vector_ != 0 {
							y_clip_vector_ = (currentMovementSpeed * (y_clip_vector_ / ((abs(y_clip_vector_ div 16) + 1) * 16))) / 4;
						}
					}
					// Destroy the clipped_objects_ list after I'm finished with it to avoid memory leaks.
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
						if point_distance(x, y, targetToMoveToX, targetToMoveToY) >= currentMovementSpeed * 2 {
							// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
							// Specifically, I just need to change/add the local variables "front_liner_moving_",
							// "middle_liner_moving_", and "back_liner_moving_" for any units that I add or change,
							// so that they're sorted correctly by their assigned placements once they form up
							// into a formation.
							// If this unit is assigned to a position that is in the front, and it's not a front liner, then check
							// to see if there's a front liner that is assigned further back, that can take it's place. To be clear,
							// I'm not necessarily checking for distance to the initial target click location, but rather which is
							// further forward relative to the direction given in the ds_grid.
							var units_moving_to_same_location_ = noone;
							if ds_exists(unitsCurrentlyOnlyMovingGrid, ds_type_grid) {
								var only_moving_grid_height_ = ds_grid_height(unitsCurrentlyOnlyMovingGrid);
								var self_found_original_index_ = ds_grid_value_y(unitsCurrentlyOnlyMovingGrid, 0, 0, 0, only_moving_grid_height_ - 1, self.id);
								// If the unit is part of the grid containing units who are just moving, great! Make a copy of that grid, containing
								// that unit and only other units who are moving to the same location, stored in the local variable 
								// units_move_to_same_location_. Regardless of what happens after, this grid is deleted after this code section,
								// ensuring a memory leak doesn't occur.
								if self_found_original_index_ != -1 {
									units_moving_to_same_location_ = ds_grid_create(4, 1,);
									ds_grid_add(units_moving_to_same_location_, 0, 0, self.id);
									ds_grid_add(units_moving_to_same_location_, 1, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, self_found_original_index_));
									ds_grid_add(units_moving_to_same_location_, 2, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, self_found_original_index_));
									ds_grid_add(units_moving_to_same_location_, 3, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 3, self_found_original_index_));
									
									// Knights, Berserkers, and Abominations/Automatons should be up front.
									// Warlocks, Wizards, Rangers, and Acolytes should be in the back.
									// Soldiers, Rogues, Workers, and Demons should be in the middle.
									var self_liner_ = "";
									var front_liner_moving_ = false;
									var middle_liner_moving_ = false;
									var back_liner_moving_ = false;
									if (objectType == "Knight") || (objectType == "Berserker") || (objectType == "Abomination") || (objectType == "Automaton") {
										front_liner_moving_ = true;
										self_liner_ = "Front";
									}
									else if (objectType == "Warlock") || (objectType == "Wizard") || (objectType == "Ranger") || (objectType == "Acolyte") {
										back_liner_moving_ = true;
										self_liner_ = "Back";
									}
									else if (objectType == "Soldier") || (objectType == "Rogue") || (objectType == "Demon") || (objectType == "Worker") {
										middle_liner_moving_ = true;
										self_liner_ = "Middle";
									}
									
									// Now that the temporary grid exists, go through the original grid and add any units that are set to travel
									// to the same location to the temporary grid. I check to make sure the unit isn't a duplicate of itself, and
									// to make sure the unit being added is on the same team, meaning they're traveling together (or at least
									// will end up together).
									var k = 0;
									for (k = 0; k < ds_grid_height(unitsCurrentlyOnlyMovingGrid); k++) {
										var unit_original_index_id_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 0, k);
										var unit_original_index_target_x_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, k);
										var unit_original_index_target_y_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, k);
										var unit_original_index_target_direction_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 3, k);
										if (k != self_found_original_index_) && (objectRealTeam == unit_original_index_id_.objectRealTeam) {
											// If the unit in the list is moving to the same location that this current unit (the unit running
											// this code) is moving to, then add it to the temporary ds_grid.
											if (ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, self_found_original_index_) == unit_original_index_target_x_) && (ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, self_found_original_index_) == unit_original_index_target_y_) {
												// Finally, if the two different units in question are verified to be on the same team and
												// moving to the same location, add the unit not yet added to the temporary ds_grid, to the
												// temporary ds_grid.
												var temp_grid_height_ = ds_grid_height(units_moving_to_same_location_);
												ds_grid_resize(units_moving_to_same_location_, 4, temp_grid_height_ + 1);
												ds_grid_add(units_moving_to_same_location_, 0, temp_grid_height_, unit_original_index_id_);
												ds_grid_add(units_moving_to_same_location_, 1, temp_grid_height_, unit_original_index_target_x_);
												ds_grid_add(units_moving_to_same_location_, 2, temp_grid_height_, unit_original_index_target_y_);
												ds_grid_add(units_moving_to_same_location_, 3, temp_grid_height_, unit_original_index_target_direction_);
											}
										}
									}
									// Now that the temporary grid exists, and all units who are currently just moving to a location, and are
									// moving to the same location while on the same team are all added into the temporary grid, I can manipulate
									// target positions to move to, and adjust paths as needed.
									// If the grid height is only 1 or less, then that means no other units moving to the same location were found
									// and it's moving by itself, so none of the below code will run.
									if ds_grid_height(units_moving_to_same_location_) > 1 {
										var self_target_x_ = ds_grid_get(units_moving_to_same_location_, 1, 0);
										var self_target_y_ = ds_grid_get(units_moving_to_same_location_, 2, 0);
										var self_target_direction_ = ds_grid_get(units_moving_to_same_location_, 3, 0);
										var self_distance_from_initial_target_ = 0;
										switch self_target_direction_ {
											case 0:
												var self_distance_from_initial_target_ = targetToMoveToX - self_target_x_;
												break;
											case 1:
												var self_distance_from_initial_target_ = self_target_y_ - targetToMoveToY;
												break;
											case 2:
												var self_distance_from_initial_target_ = self_target_x_ - targetToMoveToX;
												break;
											case 3:
												var self_distance_from_initial_target_ = targetToMoveToY - self_target_y_;
												break;
										}
										// I set the iteration value to 1, since the first value in the for loop is guaranteed to be the unit running
										// this code.
										k = 1;
										for (k = 1; k < ds_grid_height(units_moving_to_same_location_) - 1; k++) {
											var needs_to_swap_with_unit_target_ = false;
											var other_liner_ = "";
											var other_target_id_ = ds_grid_get(units_moving_to_same_location_, 0, k);
											var other_target_x_ = ds_grid_get(units_moving_to_same_location_, 1, k);
											var other_target_y_ = ds_grid_get(units_moving_to_same_location_, 2, k);
											var other_target_direction_ = ds_grid_get(units_moving_to_same_location_, 3, k);
											var other_current_target_x_ = other_target_id_.targetToMoveToX;
											var other_current_target_y_ = other_target_id_.targetToMoveToY;
											with other_target_id_ {
												if (objectType == "Knight") || (objectType == "Berserker") || (objectType == "Abomination") || (objectType == "Automaton") {
													front_liner_moving_ = true;
													other_liner_ = "Front";
												}
												else if (objectType == "Warlock") || (objectType == "Wizard") || (objectType == "Ranger") || (objectType == "Acolyte") {
													back_liner_moving_ = true;
													other_liner_ = "Back";
												}
												else if (objectType == "Soldier") || (objectType == "Rogue") || (objectType == "Demon") || (objectType == "Worker") {
													middle_liner_moving_ = true;
													other_liner_ = "Middle";
												}
											}
											// If they're moving in the same direction, meaning they're in the in same formation,
											// or close enough to each other that it doesn't matter if their formation is the same
											if self_target_direction_ == other_target_direction_ {
												// Check object types for the units. 
												// Knights, Berserkers, and Abominations/Automatons should be up front.
												// Warlocks, Wizards, Rangers, and Acolytes should be in the back.
												// Soldiers, Rogues, Workers, and Demons should be in the middle.
												
												// Keep in mind, this is only swapping the target location for the one unit that is running this
												// code - so only this unit, and one other unit, should be swapping locations at a time. I also
												// make sure to update the unitsCurrentlyOnlyMovingGrid information, so that I don't continually
												// swap places over and over.
												switch other_target_direction_ {
													case 0:
														var other_distance_from_initial_target_ = other_current_target_x_ - other_target_x_;
														break;
													case 1:
														var other_distance_from_initial_target_ = other_target_y_ - other_current_target_y_;
														break;
													case 2:
														var other_distance_from_initial_target_ = other_target_x_ - other_current_target_x_;
														break;
													case 3:
														var other_distance_from_initial_target_ = other_current_target_y_ - other_target_y_;
														break;
												}
												
												/// Check for units in different locations than itself to swap with.
												// If the unit is a front liner, I only need to check for a unit that is further forward than this
												// unit.
												if (self_liner_ == "Front") && (other_liner_ != "Front") {
													// The moment of truth. It all comes together here.
													// If the unit in the temporary grid, added initially because it's an ally moving to the same
													// initial target location, is now set to move to a location that is further behind another unit
													// relative to the direction moving in, and that other unit that it's behind is supposed to be
													// behind the current unit, along with both units having found a valid path and location, then
													// swap target locations.
													if self_distance_from_initial_target_ < other_distance_from_initial_target_ {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												else if self_liner_ == "Middle" {
													if ((self_distance_from_initial_target_ < other_distance_from_initial_target_) && (other_liner_ == "Back")) || ((self_distance_from_initial_target_ > other_distance_from_initial_target_) && (other_liner_ == "Front")) {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												else if (self_liner_ == "Back") && (other_liner_ != "Back") {
													if self_distance_from_initial_target_ > other_distance_from_initial_target_ {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												
												// Make sure to update the temporary grid, the global grid, the grid containing unit locations,
												// and the paths for both units, along with the current targetToMoveToX and targetToMoveToY
												// values.
												if needs_to_swap_with_unit_target_ {
													// Before swapping, check for path status. This can vary between units, so I need to handle
													// each combination of path existence separately.
													needs_to_swap_with_unit_target_ = false;
													var both_have_paths_ = false;
													var self_has_path_ = false;
													var other_has_path_ = false;
													if path_exists(myPath) {
														self_has_path_ = true;
													}
													if path_exists(other_target_id_.myPath) {
														other_has_path_ = true;
													}
													if self_has_path_ && other_has_path_ {
														both_have_paths_ = true;
													}
													
													// After checking for path status, swap target locations and adjust for every possibile
													// combination of pathing.
													if both_have_paths_ {
														// If a line of sight exists between the two end points of the path, then just take
														// the last points on both paths and swap them, before adjusting relevant info in
														// data structures.
														if line_of_sight_exists_to_target(path_get_x(myPath, 1), path_get_y(myPath, 1), path_get_x(other_target_id_.myPath, 1), path_get_y(other_target_id_.myPath, 1)) {
															var self_last_path_point_index_ = path_get_number(myPath) - 1;
															var self_last_path_point_x_ = path_get_point_x(myPath, self_last_path_point_index_);
															var self_last_path_point_y_ = path_get_point_y(myPath, self_last_path_point_index_);
															var other_last_path_point_index_ = path_get_number(other_target_id_.myPath) - 1;
															var other_last_path_point_x_ = path_get_point_x(other_target_id_.myPath, other_last_path_point_index_);
															var other_last_path_point_y_ = path_get_point_y(other_target_id_.myPath, other_last_path_point_index_);
															// Change the last path points
															path_change_point(myPath, self_last_path_point_index_, other_last_path_point_x_, other_last_path_point_y_, 0);
															path_change_point(other_target_id_.myPath, other_last_path_point_index_, self_last_path_point_x_, self_last_path_point_y_, 0);
														}
														// If no line of sight exists between the points to move to, then I need to remove
														// the end points of the two paths, then create a path for each starting at the new
														// endpoints and going to the new target to move to, and finally combine the original
														// paths and the new paths.
														else {
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													else if other_has_path_ {
														// If a line of sight exists between the current unit's target to move to, and the last
														// point on the path of the other unit, then change the path of the other unit, and then
														// do nothing else (since the target to move to variables will be swapped later.
														if line_of_sight_exists_to_target(targetToMoveToX, targetToMoveToY, path_get_x(other_target_id_.myPath, 1), path_get_y(other_target_id_.myPath, 1)) {
															var other_last_path_point_index_ = path_get_number(other_target_id_.myPath) - 1;
															var other_last_path_point_x_ = path_get_point_x(other_target_id_.myPath, other_last_path_point_index_);
															var other_last_path_point_y_ = path_get_point_y(other_target_id_.myPath, other_last_path_point_index_);
															// Change the last path point
															path_change_point(other_target_id_.myPath, other_last_path_point_index_, targetToMoveToX, targetToMoveToY, 0);
														}
														// If no line of sight exists between the target to move to and the last point of the other
														// unit's path, then create a path for the current unit, and then modify the paths exactly
														// like I do above.
														else {
															// Create a path and set it to move to the target.
															myPath = path_add();
															mp_grid_path(movementGrid, myPath, x, y, targetToMoveToX, targetToMoveToY, true);
															// Identical to the code adjusting for 2 paths.
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													else if self_has_path_ {
														if line_of_sight_exists_to_target(path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY) {
															var self_last_path_point_index_ = path_get_number(myPath) - 1;
															var self_last_path_point_x_ = path_get_point_x(myPath, self_last_path_point_index_);
															var self_last_path_point_y_ = path_get_point_y(myPath, self_last_path_point_index_);
															// Change the last path point
															path_change_point(myPath, self_last_path_point_index_, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, 0);
														}
														// If no line of sight exists between the last point of this unit's path and the
														// other unit's target to move to, then create a path for the other unit, and 
														// then modify the paths exactly like I do above.
														else {
															with other_target_id_ {
																// Create a path and set it to move to the target.
																myPath = path_add();
																mp_grid_path(movementGrid, myPath, x, y, targetToMoveToX, targetToMoveToY, true);
															}
															// Identical to the code adjusting for 2 paths.
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													// Otherwise, if neither of the units in question have a path, then check for line of sight.
													// If one exists, then I don't do anything, because all I need to do at that point is adjust
													// the target variables, which are done below. If no line of sight exists however, I create
													// a path for both objects and automatically set those PATHS to the target locations of the
													// other unit, while leaving the target variables themselves alone still, as those will be
													// adjust below.
													else if !line_of_sight_exists_to_target(targetToMoveToX, targetToMoveToY, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY) {
														var self_id_ = self.id;
														myPath = path_add();
														mp_grid_path(movementGrid, myPath, x, y, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
														with other_target_id_ {
															myPath = path_add();
															mp_grid_path(movementGrid, myPath, x, y, self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
														}
													}
													// Now update variables
													other_target_id_.targetToMoveToX = targetToMoveToX;
													other_target_id_.targetToMoveToY = targetToMoveToY;
													targetToMoveToX = other_current_target_x_;
													targetToMoveToY = other_current_target_y_;
													
													/// Finally, update ds_grids
													// Temporary ds_grid, units_moving_to_same_location_
													swap_data_position_in_structure(units_moving_to_same_location_, "grid", self.id, other_target_id_);
													
													// unitsCurrentlyOnlyMovingGrid
													swap_data_position_in_structure(unitsCurrentlyOnlyMovingGrid, "grid", self.id, other_target_id_);
													
													// unitGridLocation
													swap_data_position_in_structure(unitGridLocation, "grid", self.id, other_target_id_);
												}
											}
										}
									}
								}
							}
							if ds_exists(units_moving_to_same_location_, ds_type_grid) {
								ds_grid_destroy(units_moving_to_same_location_);
								units_moving_to_same_location_ = noone;
							}
							
							var x_vector_, y_vector_;
							x_vector_ = lengthdir_x(currentMovementSpeed, point_direction(x, y, targetToMoveToX, targetToMoveToY));
							y_vector_ = lengthdir_y(currentMovementSpeed, point_direction(x, y, targetToMoveToX, targetToMoveToY));
							currentDirection = (point_direction(x, y, targetToMoveToX, targetToMoveToY) + 45) div 90;
							if currentDirection > 3 {
								currentDirection -= 4;
							}
							x += x_vector_ + x_clip_vector_;
							y += y_vector_ + y_clip_vector_;
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
							
							// If the unit is still part of the grid containing the info of units only assigned to move, then remove it, since it is no
							// longer going to move.
							remove_self_from_only_moving_grid();
						}
					}
					// Else a path must exist
					else {
						// If the path has more than 1 point to move along, move it
						if path_get_number(myPath) > 1 {
							// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
							// Specifically, I just need to change/add the local variables "front_liner_moving_",
							// "middle_liner_moving_", and "back_liner_moving_" for any units that I add or change,
							// so that they're sorted correctly by their assigned placements once they form up
							// into a formation.
							// If this unit is assigned to a position that is in the front, and it's not a front liner, then check
							// to see if there's a front liner that is assigned further back, that can take it's place. To be clear,
							// I'm not necessarily checking for distance to the initial target click location, but rather which is
							// further forward relative to the direction given in the ds_grid.
							var units_moving_to_same_location_ = noone;
							if ds_exists(unitsCurrentlyOnlyMovingGrid, ds_type_grid) {
								var only_moving_grid_height_ = ds_grid_height(unitsCurrentlyOnlyMovingGrid);
								var self_found_original_index_ = ds_grid_value_y(unitsCurrentlyOnlyMovingGrid, 0, 0, 0, only_moving_grid_height_ - 1, self.id);
								// If the unit is part of the grid containing units who are just moving, great! Make a copy of that grid, containing
								// that unit and only other units who are moving to the same location, stored in the local variable 
								// units_move_to_same_location_. Regardless of what happens after, this grid is deleted after this code section,
								// ensuring a memory leak doesn't occur.
								if self_found_original_index_ != -1 {
									units_moving_to_same_location_ = ds_grid_create(4, 1,);
									ds_grid_add(units_moving_to_same_location_, 0, 0, self.id);
									ds_grid_add(units_moving_to_same_location_, 1, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, self_found_original_index_));
									ds_grid_add(units_moving_to_same_location_, 2, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, self_found_original_index_));
									ds_grid_add(units_moving_to_same_location_, 3, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 3, self_found_original_index_));
									
									// Knights, Berserkers, and Abominations/Automatons should be up front.
									// Warlocks, Wizards, Rangers, and Acolytes should be in the back.
									// Soldiers, Rogues, Workers, and Demons should be in the middle.
									var self_liner_ = "";
									var front_liner_moving_ = false;
									var middle_liner_moving_ = false;
									var back_liner_moving_ = false;
									if (objectType == "Knight") || (objectType == "Berserker") || (objectType == "Abomination") || (objectType == "Automaton") {
										front_liner_moving_ = true;
										self_liner_ = "Front";
									}
									else if (objectType == "Warlock") || (objectType == "Wizard") || (objectType == "Ranger") || (objectType == "Acolyte") {
										back_liner_moving_ = true;
										self_liner_ = "Back";
									}
									else if (objectType == "Soldier") || (objectType == "Rogue") || (objectType == "Demon") || (objectType == "Worker") {
										middle_liner_moving_ = true;
										self_liner_ = "Middle";
									}
									
									// Now that the temporary grid exists, go through the original grid and add any units that are set to travel
									// to the same location to the temporary grid. I check to make sure the unit isn't a duplicate of itself, and
									// to make sure the unit being added is on the same team, meaning they're traveling together (or at least
									// will end up together).
									var k = 0;
									var height_ = ds_grid_height(unitsCurrentlyOnlyMovingGrid);
									for (k = 0; k < ds_grid_height(unitsCurrentlyOnlyMovingGrid); k++) {
										var unit_original_index_id_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 0, k);
										var unit_original_index_target_x_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, k);
										var unit_original_index_target_y_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, k);
										var unit_original_index_target_direction_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 3, k);
										if (k != self_found_original_index_) && (objectRealTeam == unit_original_index_id_.objectRealTeam) {
											// If the unit in the list is moving to the same location that this current unit (the unit running
											// this code) is moving to, then add it to the temporary ds_grid.
											if (ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, self_found_original_index_) == unit_original_index_target_x_) && (ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, self_found_original_index_) == unit_original_index_target_y_) {
												// Finally, if the two different units in question are verified to be on the same team and
												// moving to the same location, add the unit not yet added to the temporary ds_grid, to the
												// temporary ds_grid.
												var temp_grid_height_ = ds_grid_height(units_moving_to_same_location_);
												ds_grid_resize(units_moving_to_same_location_, 4, temp_grid_height_ + 1);
												ds_grid_add(units_moving_to_same_location_, 0, temp_grid_height_, unit_original_index_id_);
												ds_grid_add(units_moving_to_same_location_, 1, temp_grid_height_, unit_original_index_target_x_);
												ds_grid_add(units_moving_to_same_location_, 2, temp_grid_height_, unit_original_index_target_y_);
												ds_grid_add(units_moving_to_same_location_, 3, temp_grid_height_, unit_original_index_target_direction_);
											}
										}
									}
									// Now that the temporary grid exists, and all units who are currently just moving to a location, and are
									// moving to the same location while on the same team are all added into the temporary grid, I can manipulate
									// target positions to move to, and adjust paths as needed.
									// If the grid height is only 1 or less, then that means no other units moving to the same location were found
									// and it's moving by itself, so none of the below code will run.
									if ds_grid_height(units_moving_to_same_location_) > 1 {
										var self_target_x_ = ds_grid_get(units_moving_to_same_location_, 1, 0);
										var self_target_y_ = ds_grid_get(units_moving_to_same_location_, 2, 0);
										var self_target_direction_ = ds_grid_get(units_moving_to_same_location_, 3, 0);
										var self_distance_from_initial_target_ = 0;
										switch self_target_direction_ {
											case 0:
												var self_distance_from_initial_target_ = targetToMoveToX - self_target_x_;
												break;
											case 1:
												var self_distance_from_initial_target_ = self_target_y_ - targetToMoveToY;
												break;
											case 2:
												var self_distance_from_initial_target_ = self_target_x_ - targetToMoveToX;
												break;
											case 3:
												var self_distance_from_initial_target_ = targetToMoveToY - self_target_y_;
												break;
										}
										// I set the iteration value to 1, since the first value in the for loop is guaranteed to be the unit running
										// this code.
										k = 1;
										for (k = 1; k < ds_grid_height(units_moving_to_same_location_) - 1; k++) {
											var needs_to_swap_with_unit_target_ = false;
											var other_liner_ = "";
											var other_target_id_ = ds_grid_get(units_moving_to_same_location_, 0, k);
											var other_target_x_ = ds_grid_get(units_moving_to_same_location_, 1, k);
											var other_target_y_ = ds_grid_get(units_moving_to_same_location_, 2, k);
											var other_target_direction_ = ds_grid_get(units_moving_to_same_location_, 3, k);
											var other_current_target_x_ = other_target_id_.targetToMoveToX;
											var other_current_target_y_ = other_target_id_.targetToMoveToY;
											with other_target_id_ {
												if (objectType == "Knight") || (objectType == "Berserker") || (objectType == "Abomination") || (objectType == "Automaton") {
													front_liner_moving_ = true;
													other_liner_ = "Front";
												}
												else if (objectType == "Warlock") || (objectType == "Wizard") || (objectType == "Ranger") || (objectType == "Acolyte") {
													back_liner_moving_ = true;
													other_liner_ = "Back";
												}
												else if (objectType == "Soldier") || (objectType == "Rogue") || (objectType == "Demon") || (objectType == "Worker") {
													middle_liner_moving_ = true;
													other_liner_ = "Middle";
												}
											}
											// If they're moving in the same direction, meaning they're in the in same formation,
											// or close enough to each other that it doesn't matter if their formation is the same
											if self_target_direction_ == other_target_direction_ {
												// Check object types for the units. 
												// Knights, Berserkers, and Abominations/Automatons should be up front.
												// Warlocks, Wizards, Rangers, and Acolytes should be in the back.
												// Soldiers, Rogues, Workers, and Demons should be in the middle.
												
												// Keep in mind, this is only swapping the target location for the one unit that is running this
												// code - so only this unit, and one other unit, should be swapping locations at a time. I also
												// make sure to update the unitsCurrentlyOnlyMovingGrid information, so that I don't continually
												// swap places over and over.
												switch other_target_direction_ {
													case 0:
														var other_distance_from_initial_target_ = other_current_target_x_ - other_target_x_;
														break;
													case 1:
														var other_distance_from_initial_target_ = other_target_y_ - other_current_target_y_;
														break;
													case 2:
														var other_distance_from_initial_target_ = other_target_x_ - other_current_target_x_;
														break;
													case 3:
														var other_distance_from_initial_target_ = other_current_target_y_ - other_target_y_;
														break;
												}
												
												/// Check for units in different locations than itself to swap with.
												// If the unit is a front liner, I only need to check for a unit that is further forward than this
												// unit.
												if (self_liner_ == "Front") && (other_liner_ != "Front") {
													// The moment of truth. It all comes together here.
													// If the unit in the temporary grid, added initially because it's an ally moving to the same
													// initial target location, is now set to move to a location that is further behind another unit
													// relative to the direction moving in, and that other unit that it's behind is supposed to be
													// behind the current unit, along with both units having found a valid path and location, then
													// swap target locations.
													if self_distance_from_initial_target_ < other_distance_from_initial_target_ {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												else if self_liner_ == "Middle" {
													if ((self_distance_from_initial_target_ < other_distance_from_initial_target_) && (other_liner_ == "Back")) || ((self_distance_from_initial_target_ > other_distance_from_initial_target_) && (other_liner_ == "Front")) {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												else if (self_liner_ == "Back") && (other_liner_ != "Back") {
													if self_distance_from_initial_target_ > other_distance_from_initial_target_ {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												
												// Make sure to update the temporary grid, the global grid, the grid containing unit locations,
												// and the paths for both units, along with the current targetToMoveToX and targetToMoveToY
												// values.
												if needs_to_swap_with_unit_target_ {
													// Before swapping, check for path status. This can vary between units, so I need to handle
													// each combination of path existence separately.
													needs_to_swap_with_unit_target_ = false;
													var both_have_paths_ = false;
													var self_has_path_ = false;
													var other_has_path_ = false;
													if path_exists(myPath) {
														self_has_path_ = true;
													}
													if path_exists(other_target_id_.myPath) {
														other_has_path_ = true;
													}
													if self_has_path_ && other_has_path_ {
														both_have_paths_ = true;
													}
													
													// After checking for path status, swap target locations and adjust for every possibile
													// combination of pathing.
													if both_have_paths_ {
														// If a line of sight exists between the two end points of the path, then just take
														// the last points on both paths and swap them, before adjusting relevant info in
														// data structures.
														if line_of_sight_exists_to_target(path_get_x(myPath, 1), path_get_y(myPath, 1), path_get_x(other_target_id_.myPath, 1), path_get_y(other_target_id_.myPath, 1)) {
															var self_last_path_point_index_ = path_get_number(myPath) - 1;
															var self_last_path_point_x_ = path_get_point_x(myPath, self_last_path_point_index_);
															var self_last_path_point_y_ = path_get_point_y(myPath, self_last_path_point_index_);
															var other_last_path_point_index_ = path_get_number(other_target_id_.myPath) - 1;
															var other_last_path_point_x_ = path_get_point_x(other_target_id_.myPath, other_last_path_point_index_);
															var other_last_path_point_y_ = path_get_point_y(other_target_id_.myPath, other_last_path_point_index_);
															// Change the last path points
															path_change_point(myPath, self_last_path_point_index_, other_last_path_point_x_, other_last_path_point_y_, 0);
															path_change_point(other_target_id_.myPath, other_last_path_point_index_, self_last_path_point_x_, self_last_path_point_y_, 0);
														}
														// If no line of sight exists between the points to move to, then I need to remove
														// the end points of the two paths, then create a path for each starting at the new
														// endpoints and going to the new target to move to, and finally combine the original
														// paths and the new paths.
														else {
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													else if other_has_path_ {
														// If a line of sight exists between the current unit's target to move to, and the last
														// point on the path of the other unit, then change the path of the other unit, and then
														// do nothing else (since the target to move to variables will be swapped later.
														if line_of_sight_exists_to_target(targetToMoveToX, targetToMoveToY, path_get_x(other_target_id_.myPath, 1), path_get_y(other_target_id_.myPath, 1)) {
															var other_last_path_point_index_ = path_get_number(other_target_id_.myPath) - 1;
															var other_last_path_point_x_ = path_get_point_x(other_target_id_.myPath, other_last_path_point_index_);
															var other_last_path_point_y_ = path_get_point_y(other_target_id_.myPath, other_last_path_point_index_);
															// Change the last path point
															path_change_point(other_target_id_.myPath, other_last_path_point_index_, targetToMoveToX, targetToMoveToY, 0);
														}
														// If no line of sight exists between the target to move to and the last point of the other
														// unit's path, then create a path for the current unit, and then modify the paths exactly
														// like I do above.
														else {
															// Create a path and set it to move to the target.
															myPath = path_add();
															mp_grid_path(movementGrid, myPath, x, y, targetToMoveToX, targetToMoveToY, true);
															// Identical to the code adjusting for 2 paths.
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													else if self_has_path_ {
														if line_of_sight_exists_to_target(path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY) {
															var self_last_path_point_index_ = path_get_number(myPath) - 1;
															var self_last_path_point_x_ = path_get_point_x(myPath, self_last_path_point_index_);
															var self_last_path_point_y_ = path_get_point_y(myPath, self_last_path_point_index_);
															// Change the last path point
															path_change_point(myPath, self_last_path_point_index_, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, 0);
														}
														// If no line of sight exists between the last point of this unit's path and the
														// other unit's target to move to, then create a path for the other unit, and 
														// then modify the paths exactly like I do above.
														else {
															with other_target_id_ {
																// Create a path and set it to move to the target.
																myPath = path_add();
																mp_grid_path(movementGrid, myPath, x, y, targetToMoveToX, targetToMoveToY, true);
															}
															// Identical to the code adjusting for 2 paths.
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													// Otherwise, if neither of the units in question have a path, then check for line of sight.
													// If one exists, then I don't do anything, because all I need to do at that point is adjust
													// the target variables, which are done below. If no line of sight exists however, I create
													// a path for both objects and automatically set those PATHS to the target locations of the
													// other unit, while leaving the target variables themselves alone still, as those will be
													// adjust below.
													else if !line_of_sight_exists_to_target(targetToMoveToX, targetToMoveToY, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY) {
														var self_id_ = self.id;
														myPath = path_add();
														mp_grid_path(movementGrid, myPath, x, y, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
														with other_target_id_ {
															myPath = path_add();
															mp_grid_path(movementGrid, myPath, x, y, self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
														}
													}
													// Now update variables
													other_target_id_.targetToMoveToX = targetToMoveToX;
													other_target_id_.targetToMoveToY = targetToMoveToY;
													targetToMoveToX = other_current_target_x_;
													targetToMoveToY = other_current_target_y_;
													
													/// Finally, update ds_grids
													// Temporary ds_grid, units_moving_to_same_location_
													swap_data_position_in_structure(units_moving_to_same_location_, "grid", self.id, other_target_id_);
													
													// unitsCurrentlyOnlyMovingGrid
													swap_data_position_in_structure(unitsCurrentlyOnlyMovingGrid, "grid", self.id, other_target_id_);
													
													// unitGridLocation
													swap_data_position_in_structure(unitGridLocation, "grid", self.id, other_target_id_);
												}
											}
										}
									}
								}
							}
							if ds_exists(units_moving_to_same_location_, ds_type_grid) {
								ds_grid_destroy(units_moving_to_same_location_);
								units_moving_to_same_location_ = noone;
							}
							
							var x_vector_, y_vector_;
							x_vector_ = lengthdir_x(currentMovementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8));
							y_vector_ = lengthdir_y(currentMovementSpeed, point_direction(x, y, path_get_point_x(myPath, 0) - 8, path_get_point_y(myPath, 0) - 8));
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
							}
						}
						// Otherwise if the path only has 1 point on it, move it
						else if point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) > currentMovementSpeed * 2 {
							// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
							// Specifically, I just need to change/add the local variables "front_liner_moving_",
							// "middle_liner_moving_", and "back_liner_moving_" for any units that I add or change,
							// so that they're sorted correctly by their assigned placements once they form up
							// into a formation.
							// If this unit is assigned to a position that is in the front, and it's not a front liner, then check
							// to see if there's a front liner that is assigned further back, that can take it's place. To be clear,
							// I'm not necessarily checking for distance to the initial target click location, but rather which is
							// further forward relative to the direction given in the ds_grid.
							var units_moving_to_same_location_ = noone;
							if ds_exists(unitsCurrentlyOnlyMovingGrid, ds_type_grid) {
								var only_moving_grid_height_ = ds_grid_height(unitsCurrentlyOnlyMovingGrid);
								var self_found_original_index_ = ds_grid_value_y(unitsCurrentlyOnlyMovingGrid, 0, 0, 0, only_moving_grid_height_ - 1, self.id);
								// If the unit is part of the grid containing units who are just moving, great! Make a copy of that grid, containing
								// that unit and only other units who are moving to the same location, stored in the local variable 
								// units_move_to_same_location_. Regardless of what happens after, this grid is deleted after this code section,
								// ensuring a memory leak doesn't occur.
								if self_found_original_index_ != -1 {
									units_moving_to_same_location_ = ds_grid_create(4, 1,);
									ds_grid_add(units_moving_to_same_location_, 0, 0, self.id);
									ds_grid_add(units_moving_to_same_location_, 1, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, self_found_original_index_));
									ds_grid_add(units_moving_to_same_location_, 2, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, self_found_original_index_));
									ds_grid_add(units_moving_to_same_location_, 3, 0, ds_grid_get(unitsCurrentlyOnlyMovingGrid, 3, self_found_original_index_));
									
									// Knights, Berserkers, and Abominations/Automatons should be up front.
									// Warlocks, Wizards, Rangers, and Acolytes should be in the back.
									// Soldiers, Rogues, Workers, and Demons should be in the middle.
									var self_liner_ = "";
									var front_liner_moving_ = false;
									var middle_liner_moving_ = false;
									var back_liner_moving_ = false;
									if (objectType == "Knight") || (objectType == "Berserker") || (objectType == "Abomination") || (objectType == "Automaton") {
										front_liner_moving_ = true;
										self_liner_ = "Front";
									}
									else if (objectType == "Warlock") || (objectType == "Wizard") || (objectType == "Ranger") || (objectType == "Acolyte") {
										back_liner_moving_ = true;
										self_liner_ = "Back";
									}
									else if (objectType == "Soldier") || (objectType == "Rogue") || (objectType == "Demon") || (objectType == "Worker") {
										middle_liner_moving_ = true;
										self_liner_ = "Middle";
									}
									
									// Now that the temporary grid exists, go through the original grid and add any units that are set to travel
									// to the same location to the temporary grid. I check to make sure the unit isn't a duplicate of itself, and
									// to make sure the unit being added is on the same team, meaning they're traveling together (or at least
									// will end up together).
									var k = 0;
									for (k = 0; k < ds_grid_height(unitsCurrentlyOnlyMovingGrid); k++) {
										var unit_original_index_id_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 0, k);
										var unit_original_index_target_x_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, k);
										var unit_original_index_target_y_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, k);
										var unit_original_index_target_direction_ = ds_grid_get(unitsCurrentlyOnlyMovingGrid, 3, k);
										if (k != self_found_original_index_) && (objectRealTeam == unit_original_index_id_.objectRealTeam) {
											// If the unit in the list is moving to the same location that this current unit (the unit running
											// this code) is moving to, then add it to the temporary ds_grid.
											if (ds_grid_get(unitsCurrentlyOnlyMovingGrid, 1, self_found_original_index_) == unit_original_index_target_x_) && (ds_grid_get(unitsCurrentlyOnlyMovingGrid, 2, self_found_original_index_) == unit_original_index_target_y_) {
												// Finally, if the two different units in question are verified to be on the same team and
												// moving to the same location, add the unit not yet added to the temporary ds_grid, to the
												// temporary ds_grid.
												var temp_grid_height_ = ds_grid_height(units_moving_to_same_location_);
												ds_grid_resize(units_moving_to_same_location_, 4, temp_grid_height_ + 1);
												ds_grid_add(units_moving_to_same_location_, 0, temp_grid_height_, unit_original_index_id_);
												ds_grid_add(units_moving_to_same_location_, 1, temp_grid_height_, unit_original_index_target_x_);
												ds_grid_add(units_moving_to_same_location_, 2, temp_grid_height_, unit_original_index_target_y_);
												ds_grid_add(units_moving_to_same_location_, 3, temp_grid_height_, unit_original_index_target_direction_);
											}
										}
									}
									// Now that the temporary grid exists, and all units who are currently just moving to a location, and are
									// moving to the same location while on the same team are all added into the temporary grid, I can manipulate
									// target positions to move to, and adjust paths as needed.
									// If the grid height is only 1 or less, then that means no other units moving to the same location were found
									// and it's moving by itself, so none of the below code will run.
									if ds_grid_height(units_moving_to_same_location_) > 1 {
										var self_target_x_ = ds_grid_get(units_moving_to_same_location_, 1, 0);
										var self_target_y_ = ds_grid_get(units_moving_to_same_location_, 2, 0);
										var self_target_direction_ = ds_grid_get(units_moving_to_same_location_, 3, 0);
										var self_distance_from_initial_target_ = 0;
										switch self_target_direction_ {
											case 0:
												var self_distance_from_initial_target_ = targetToMoveToX - self_target_x_;
												break;
											case 1:
												var self_distance_from_initial_target_ = self_target_y_ - targetToMoveToY;
												break;
											case 2:
												var self_distance_from_initial_target_ = self_target_x_ - targetToMoveToX;
												break;
											case 3:
												var self_distance_from_initial_target_ = targetToMoveToY - self_target_y_;
												break;
										}
										// I set the iteration value to 1, since the first value in the for loop is guaranteed to be the unit running
										// this code.
										k = 1;
										for (k = 1; k < ds_grid_height(units_moving_to_same_location_) - 1; k++) {
											var needs_to_swap_with_unit_target_ = false;
											var other_liner_ = "";
											var other_target_id_ = ds_grid_get(units_moving_to_same_location_, 0, k);
											var other_target_x_ = ds_grid_get(units_moving_to_same_location_, 1, k);
											var other_target_y_ = ds_grid_get(units_moving_to_same_location_, 2, k);
											var other_target_direction_ = ds_grid_get(units_moving_to_same_location_, 3, k);
											var other_current_target_x_ = other_target_id_.targetToMoveToX;
											var other_current_target_y_ = other_target_id_.targetToMoveToY;
											with other_target_id_ {
												if (objectType == "Knight") || (objectType == "Berserker") || (objectType == "Abomination") || (objectType == "Automaton") {
													front_liner_moving_ = true;
													other_liner_ = "Front";
												}
												else if (objectType == "Warlock") || (objectType == "Wizard") || (objectType == "Ranger") || (objectType == "Acolyte") {
													back_liner_moving_ = true;
													other_liner_ = "Back";
												}
												else if (objectType == "Soldier") || (objectType == "Rogue") || (objectType == "Demon") || (objectType == "Worker") {
													middle_liner_moving_ = true;
													other_liner_ = "Middle";
												}
											}
											// If they're moving in the same direction, meaning they're in the in same formation,
											// or close enough to each other that it doesn't matter if their formation is the same
											if self_target_direction_ == other_target_direction_ {
												// Check object types for the units. 
												// Knights, Berserkers, and Abominations/Automatons should be up front.
												// Warlocks, Wizards, Rangers, and Acolytes should be in the back.
												// Soldiers, Rogues, Workers, and Demons should be in the middle.
												
												// Keep in mind, this is only swapping the target location for the one unit that is running this
												// code - so only this unit, and one other unit, should be swapping locations at a time. I also
												// make sure to update the unitsCurrentlyOnlyMovingGrid information, so that I don't continually
												// swap places over and over.
												switch other_target_direction_ {
													case 0:
														var other_distance_from_initial_target_ = other_current_target_x_ - other_target_x_;
														break;
													case 1:
														var other_distance_from_initial_target_ = other_target_y_ - other_current_target_y_;
														break;
													case 2:
														var other_distance_from_initial_target_ = other_target_x_ - other_current_target_x_;
														break;
													case 3:
														var other_distance_from_initial_target_ = other_current_target_y_ - other_target_y_;
														break;
												}
												
												/// Check for units in different locations than itself to swap with.
												// If the unit is a front liner, I only need to check for a unit that is further forward than this
												// unit.
												if (self_liner_ == "Front") && (other_liner_ != "Front") {
													// The moment of truth. It all comes together here.
													// If the unit in the temporary grid, added initially because it's an ally moving to the same
													// initial target location, is now set to move to a location that is further behind another unit
													// relative to the direction moving in, and that other unit that it's behind is supposed to be
													// behind the current unit, along with both units having found a valid path and location, then
													// swap target locations.
													if self_distance_from_initial_target_ < other_distance_from_initial_target_ {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												else if self_liner_ == "Middle" {
													if ((self_distance_from_initial_target_ < other_distance_from_initial_target_) && (other_liner_ == "Back")) || ((self_distance_from_initial_target_ > other_distance_from_initial_target_) && (other_liner_ == "Front")) {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												else if (self_liner_ == "Back") && (other_liner_ != "Back") {
													if self_distance_from_initial_target_ > other_distance_from_initial_target_ {
														if (other_target_id_.validPathFound) && (other_target_id_.validLocationFound) {
															needs_to_swap_with_unit_target_ = true;
														}
													}
												}
												
												// Make sure to update the temporary grid, the global grid, the grid containing unit locations,
												// and the paths for both units, along with the current targetToMoveToX and targetToMoveToY
												// values.
												if needs_to_swap_with_unit_target_ {
													// Before swapping, check for path status. This can vary between units, so I need to handle
													// each combination of path existence separately.
													needs_to_swap_with_unit_target_ = false;
													var both_have_paths_ = false;
													var self_has_path_ = false;
													var other_has_path_ = false;
													if path_exists(myPath) {
														self_has_path_ = true;
													}
													if path_exists(other_target_id_.myPath) {
														other_has_path_ = true;
													}
													if self_has_path_ && other_has_path_ {
														both_have_paths_ = true;
													}
													
													// After checking for path status, swap target locations and adjust for every possibile
													// combination of pathing.
													if both_have_paths_ {
														// If a line of sight exists between the two end points of the path, then just take
														// the last points on both paths and swap them, before adjusting relevant info in
														// data structures.
														if line_of_sight_exists_to_target(path_get_x(myPath, 1), path_get_y(myPath, 1), path_get_x(other_target_id_.myPath, 1), path_get_y(other_target_id_.myPath, 1)) {
															var self_last_path_point_index_ = path_get_number(myPath) - 1;
															var self_last_path_point_x_ = path_get_point_x(myPath, self_last_path_point_index_);
															var self_last_path_point_y_ = path_get_point_y(myPath, self_last_path_point_index_);
															var other_last_path_point_index_ = path_get_number(other_target_id_.myPath) - 1;
															var other_last_path_point_x_ = path_get_point_x(other_target_id_.myPath, other_last_path_point_index_);
															var other_last_path_point_y_ = path_get_point_y(other_target_id_.myPath, other_last_path_point_index_);
															// Change the last path points
															path_change_point(myPath, self_last_path_point_index_, other_last_path_point_x_, other_last_path_point_y_, 0);
															path_change_point(other_target_id_.myPath, other_last_path_point_index_, self_last_path_point_x_, self_last_path_point_y_, 0);
														}
														// If no line of sight exists between the points to move to, then I need to remove
														// the end points of the two paths, then create a path for each starting at the new
														// endpoints and going to the new target to move to, and finally combine the original
														// paths and the new paths.
														else {
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													else if other_has_path_ {
														// If a line of sight exists between the current unit's target to move to, and the last
														// point on the path of the other unit, then change the path of the other unit, and then
														// do nothing else (since the target to move to variables will be swapped later.
														if line_of_sight_exists_to_target(targetToMoveToX, targetToMoveToY, path_get_x(other_target_id_.myPath, 1), path_get_y(other_target_id_.myPath, 1)) {
															var other_last_path_point_index_ = path_get_number(other_target_id_.myPath) - 1;
															var other_last_path_point_x_ = path_get_point_x(other_target_id_.myPath, other_last_path_point_index_);
															var other_last_path_point_y_ = path_get_point_y(other_target_id_.myPath, other_last_path_point_index_);
															// Change the last path point
															path_change_point(other_target_id_.myPath, other_last_path_point_index_, targetToMoveToX, targetToMoveToY, 0);
														}
														// If no line of sight exists between the target to move to and the last point of the other
														// unit's path, then create a path for the current unit, and then modify the paths exactly
														// like I do above.
														else {
															// Create a path and set it to move to the target.
															myPath = path_add();
															mp_grid_path(movementGrid, myPath, x, y, targetToMoveToX, targetToMoveToY, true);
															// Identical to the code adjusting for 2 paths.
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													else if self_has_path_ {
														if line_of_sight_exists_to_target(path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY) {
															var self_last_path_point_index_ = path_get_number(myPath) - 1;
															var self_last_path_point_x_ = path_get_point_x(myPath, self_last_path_point_index_);
															var self_last_path_point_y_ = path_get_point_y(myPath, self_last_path_point_index_);
															// Change the last path point
															path_change_point(myPath, self_last_path_point_index_, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, 0);
														}
														// If no line of sight exists between the last point of this unit's path and the
														// other unit's target to move to, then create a path for the other unit, and 
														// then modify the paths exactly like I do above.
														else {
															with other_target_id_ {
																// Create a path and set it to move to the target.
																myPath = path_add();
																mp_grid_path(movementGrid, myPath, x, y, targetToMoveToX, targetToMoveToY, true);
															}
															// Identical to the code adjusting for 2 paths.
															var self_id_ = self.id;
															if path_get_number(myPath) > 1 {
																path_delete_point(myPath, path_get_number(myPath) - 1);
																var path_to_add_ = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
																path_append(myPath, path_to_add_);
																path_delete(path_to_add_);
																path_to_add_ = noone;
															}
															else {
																path_delete(myPath);
																myPath = noone;
																myPath = path_add();
																mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
															}
															// Here I do the same as above, except with the unit that is being swapped with.
															with other_target_id_ {
																if path_get_number(myPath) > 1 {
																	path_delete_point(myPath, path_get_number(myPath) - 1);
																	var path_to_add_ = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																	path_append(myPath, path_to_add_);
																	path_delete(path_to_add_);
																	path_to_add_ = noone;
																}
																else {
																	path_delete(myPath);
																	myPath = noone;
																	myPath = path_add();
																	mp_grid_path(movementGrid, path_to_add_, path_get_x(myPath, 1), path_get_y(myPath, 1), self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
																}
															}
														}
													}
													// Otherwise, if neither of the units in question have a path, then check for line of sight.
													// If one exists, then I don't do anything, because all I need to do at that point is adjust
													// the target variables, which are done below. If no line of sight exists however, I create
													// a path for both objects and automatically set those PATHS to the target locations of the
													// other unit, while leaving the target variables themselves alone still, as those will be
													// adjust below.
													else if !line_of_sight_exists_to_target(targetToMoveToX, targetToMoveToY, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY) {
														var self_id_ = self.id;
														myPath = path_add();
														mp_grid_path(movementGrid, myPath, x, y, other_target_id_.targetToMoveToX, other_target_id_.targetToMoveToY, true);
														with other_target_id_ {
															myPath = path_add();
															mp_grid_path(movementGrid, myPath, x, y, self_id_.targetToMoveToX, self_id_.targetToMoveToY, true);
														}
													}
													// Now update variables
													other_target_id_.targetToMoveToX = targetToMoveToX;
													other_target_id_.targetToMoveToY = targetToMoveToY;
													targetToMoveToX = other_current_target_x_;
													targetToMoveToY = other_current_target_y_;
													
													/// Finally, update ds_grids
													// Temporary ds_grid, units_moving_to_same_location_
													swap_data_position_in_structure(units_moving_to_same_location_, "grid", self.id, other_target_id_);
													
													// unitsCurrentlyOnlyMovingGrid
													swap_data_position_in_structure(unitsCurrentlyOnlyMovingGrid, "grid", self.id, other_target_id_);
													
													// unitGridLocation
													swap_data_position_in_structure(unitGridLocation, "grid", self.id, other_target_id_);
												}
											}
										}
									}
								}
							}
							if ds_exists(units_moving_to_same_location_, ds_type_grid) {
								ds_grid_destroy(units_moving_to_same_location_);
								units_moving_to_same_location_ = noone;
							}
							var x_vector_, y_vector_;
							x_vector_ = lengthdir_x(currentMovementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)));
							y_vector_ = lengthdir_y(currentMovementSpeed, point_direction(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)));
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
							
							// If the unit is still part of the grid containing the info of units only assigned to move, then remove it, since it is no
							// longer going to move.
							remove_self_from_only_moving_grid();
						}
						// Clear each point on the path as the unit passes that point
						if ((path_get_number(myPath) > 1) && (point_distance((x + 8), (y + 8), path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) <= (sprite_width / 2))) || ((path_get_number(myPath) == 1) && (point_distance(x, y, path_get_point_x(myPath, 0), path_get_point_y(myPath, 0)) <= currentMovementSpeed)) {
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
				if objectType == "Worker" {
					if objectCurrentCommand == "Move" {
						if ds_exists(player[objectRealTeam].listOfStorehousesAndCityHalls, ds_type_list) {
							ds_list_sort_distance(x, y, player[objectRealTeam].listOfStorehousesAndCityHalls);
							if distance_to_object(real(ds_list_find_value(player[objectRealTeam].listOfStorehousesAndCityHalls, 0))) < 16 {
								player[objectRealTeam].food += currentFoodCarry;
								player[objectRealTeam].wood += currentWoodCarry;
								player[objectRealTeam].gold += currentGoldCarry;
								player[objectRealTeam].rubies += currentRubyCarry;
								currentFoodCarry = 0;
								currentWoodCarry = 0;
								currentGoldCarry = 0;
								currentRubyCarry = 0;
								currentResourceWeightCarry = 0;
							}
						}
					}
				}
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
					forceAttack = false;
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
					objectGoldMineSpeedTimer = objectGoldMineSpeed;
				}
				else if objectCurrentCommand == "Chop" {
					currentAction = unitAction.chop;
					objectWoodChopSpeedTimer = objectWoodChopSpeed;
				}
				else if objectCurrentCommand == "Farm" {
					currentAction = unitAction.farm;
					objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
				}
				else if objectCurrentCommand == "Ruby Mine" {
					currentAction = unitAction.mine;
					objectRubyMineSpeedTimer = objectRubyMineSpeed;
				}
				currentImageIndex = 0;
				objectAttackSpeedTimer = objectAttackSpeed;
				// If the unit is still part of the grid containing the info of units only assigned to move, then remove it, since it is no
				// longer going to move.
				remove_self_from_only_moving_grid();
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
		if objectType == "Worker" {
			if objectCurrentCommand == "Move" {
				if ds_exists(player[objectRealTeam].listOfStorehousesAndCityHalls, ds_type_list) {
					ds_list_sort_distance(x, y, player[objectRealTeam].listOfStorehousesAndCityHalls);
					if distance_to_object(real(ds_list_find_value(player[objectRealTeam].listOfStorehousesAndCityHalls, 0))) < 16 {
						player[objectRealTeam].food += currentFoodCarry;
						player[objectRealTeam].wood += currentWoodCarry;
						player[objectRealTeam].gold += currentGoldCarry;
						player[objectRealTeam].rubies += currentRubyCarry;
						currentFoodCarry = 0;
						currentWoodCarry = 0;
						currentGoldCarry = 0;
						currentRubyCarry = 0;
						currentResourceWeightCarry = 0;
					}
				}
			}
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
			forceAttack = false;
			objectTargetType = noone;
			objectTargetTeam = noone;
		}
		else if objectCurrentCommand == "Attack" {
			currentAction = unitAction.attack;
		}
		else if objectCurrentCommand == "Mine" {
			currentAction = unitAction.mine;
			objectGoldMineSpeedTimer = objectGoldMineSpeed;
		}
		else if objectCurrentCommand == "Chop" {
			currentAction = unitAction.chop;
			objectWoodChopSpeedTimer = objectWoodChopSpeed;
		}
		else if objectCurrentCommand == "Farm" {
			currentAction = unitAction.farm;
			objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
		}
		else if objectCurrentCommand == "Ruby Mine" {
			currentAction = unitAction.mine;
			objectRubyMineSpeedTimer = objectRubyMineSpeed;
		}
		currentImageIndex = 0;
		objectAttackSpeedTimer = objectAttackSpeed;
		x = floor(x / 16) * 16;
		y = floor(y / 16) * 16;
		
		// If the unit is still part of the grid containing the info of units only assigned to move, then remove it, since it is no
		// longer going to move.
		remove_self_from_only_moving_grid();
	}
}


