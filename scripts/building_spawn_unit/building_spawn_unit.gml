///@function	building_spawn_unit();			
///@param	{string}	unit_type		The type of unit to spawn.
///@param	{real}	unit_team			The team the unit will belong to.
///@description							Spawn a unit at a location. It will spawn at a random adjacent
///										location to the building if no rally point is established, 
///										and otherwise will spawn at a random adjacent location to the
///										building and move to the rally point.
function building_spawn_unit(type_, team_) {
	var i, iteration_, square_iteration_, check_x_, check_y_, horizontal_offset_, vertical_offset_, horizontal_side_square_size_, vertical_side_square_size_, total_square_size_perimeter_, spawn_found_;
	iteration_ = 0;
	square_iteration_ = 1;
	spawn_found_ = false;
	
	// Determine the offset for vertical and horizontal distances that the building spawning
	// units should have when spawning the units at its border.
	switch objectType {
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		// In this case, I'll need to add a case for any new building that I add, to match its dimensions.
		case "City Hall":
			horizontal_offset_ = 3;
			vertical_offset_ = 3;
			break;
		case "House":
			horizontal_offset_ = 0;
			vertical_offset_ = 0;
			break;
		case "Barracks":
			
			break;
		case "Temple":
			
			break;
		case "Laboratory":
			
			break;
		case "Outpost":
			
			break;
		case "Tower":
			
			break;
	}
	var total_iteration_ = 0;
	while ((!spawn_found_) && (total_iteration_ <= 10)) {
		// Increment the total_iteration_ variable, used to stop endless loops, and limit the search
		// area around a building to 10 total spaces outwards.
		total_iteration_++;
		// Set the variables used to determine side length in squares each full iteration
		horizontal_side_square_size_ = (square_iteration_ * 2) + 1 + horizontal_offset_;
		vertical_side_square_size_ = (square_iteration_ * 2) + 1 + vertical_offset_;
		total_square_size_perimeter_ = (horizontal_side_square_size_ * 2) + (vertical_side_square_size_ * 2);
		
		// Set the search location start point.
		var center_x_, center_y_, left_side_, right_side_, top_side_, bottom_side_, x_offset_, y_offset_, width_, height_;
		width_ = sprite_get_width(sprite_index);
		height_ = sprite_get_height(sprite_index);
		x_offset_ = sprite_get_xoffset(sprite_index);
		y_offset_ = sprite_get_yoffset(sprite_index);
		
		right_side_ = x + width_ - x_offset_;
		left_side_ = x - x_offset_;
		center_x_ = x + ((right_side_ - left_side_) / 2);
		
		top_side_ = y + height_ - y_offset_;
		bottom_side_ = y - y_offset_;
		center_y_ = y + ((bottom_side_ - top_side_) / 2);
		
		var spawn_direction_ = (point_direction(center_x_, center_y_, rallyPointX, rallyPointY) + 45) div 90;
		if spawn_direction_ > 3 {
			spawn_direction_ = 0;
		}
		switch spawn_direction_ {
			case 0:
				iteration_ = horizontal_side_square_size_ + (round(vertical_side_square_size_ / 2));
				break;
			case 1:
				iteration_ = round(horizontal_side_square_size_ / 2);
				break;
			case 2:
				iteration_ = (horizontal_side_square_size_ * 2) + vertical_side_square_size_ + (round(vertical_side_square_size_ / 2));
				break;
			case 3:
				iteration_ = horizontal_side_square_size_ + vertical_side_square_size_ + (round(horizontal_side_square_size_ / 2));
				break;
		}
		
		// Start the search for a valid location to move to
		for (i = 0; i < total_square_size_perimeter_; i++) {
			if iteration_ < horizontal_side_square_size_ {
				check_x_ = x - (square_iteration_ * 16) + (iteration_ * 16);
				check_y_ = y - ((square_iteration_ + vertical_offset_) * 16);
			}
			else if iteration_ < horizontal_side_square_size_ + vertical_side_square_size_ {
				check_x_ = x - (square_iteration_ * 16) + ((horizontal_side_square_size_ - 1) * 16);
				check_y_ = y - ((square_iteration_ + vertical_offset_) * 16) + ((iteration_ - horizontal_side_square_size_) * 16);
			}
			else if iteration_ < (horizontal_side_square_size_ * 2) + vertical_side_square_size_ {
				check_x_ = x - (square_iteration_ * 16) + ((horizontal_side_square_size_ - 1) * 16) - ((iteration_ - (horizontal_side_square_size_ + vertical_side_square_size_)) * 16);
				check_y_ = y - ((square_iteration_ + vertical_offset_) * 16) + ((vertical_side_square_size_ - 1) * 16);
			}
			else if iteration_ < total_square_size_perimeter_ {
				check_x_ = x - (square_iteration_ * 16);
				check_y_ = y - ((square_iteration_ + vertical_offset_) * 16) + ((vertical_side_square_size_ - 1) * 16) - ((iteration_ - ((horizontal_side_square_size_ * 2) + vertical_side_square_size_)) * 16);
			}
			
			// Check to see if the spawn point is valid, and if it is, set that as true.
			if mp_grid_get_cell(movementGrid, (check_x_ / 16), (check_y_ / 16)) == 0 {
				spawn_found_ = true;
				break;
			}
			
			// If no valid spawn location found yet, iterate correct values and start the search
			// again, one further space outwards.
			if !spawn_found_ {
				// Increment iteration, the actual variable being used to wrap around the search area
				iteration_++;
				if (iteration_ == round((total_square_size_perimeter_ * 0.25))) || (iteration_ == round((total_square_size_perimeter_ * 0.5))) || (iteration_ == round((total_square_size_perimeter_ * 0.75))) {
					iteration_++;
				}
				if iteration_ >= total_square_size_perimeter_ {
					iteration_ = 0;
				}
			}
		}
	}
	
	// Check to see if a spawn location has been found, and if so, spawn a unit there.
	if spawn_found_ {
		var self_ = self.id;
		var unit_spawned_ = instance_create_depth(floor(check_x_ / 16) * 16, floor(check_y_ / 16) * 16, check_y_, obj_unit);
		with unit_spawned_ {
			justSpawned = true;
			objectVisibleTeam = self_.objectRealTeam;
			objectRealTeam = self_.objectRealTeam;
			objectClassification = "Unit";
			objectType = type_;
			objectCurrentCommand = "Move";
			objectNeedsToMove = true;
			targetToMoveToX = floor(self_.rallyPointX / 16) * 16;
			targetToMoveToY = floor(self_.rallyPointY / 16) * 16;
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
			currentAction = unitAction.move;
			currentDirection = floor(point_direction(x, y, targetToMoveToX, targetToMoveToY) / 90);
			movementLeaderOrFollowing = "Leader";
			event_perform(ev_step, ev_step_normal);
		}
	}
	else {
		return false;
	}
}


