///@function	spawn_unit();			
///@param	{string}	unit_type		The type of unit to spawn.
///@param	{real}	unit_team			The team the unit will belong to.
///@description							Spawn a unit at a location. It will spawn at a random adjacent
///										location to the building if no rally point is established, 
///										and otherwise will spawn at a random adjacent location to the
///										building and move to the rally point.
function spawn_unit()	{
	var type_ = argument0;
	var team_ = argument1;
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
			horizontal_offset_ = 2;
			vertical_offset_ = 2;
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
		
		// Set the search location start point. If no rally point is set, the units will spawn
		// at the bottom.
		if (rallyPointX != x) || (rallyPointY != y) {
			var spawn_direction_ = floor((point_direction(x, y, rallyPointX, rallyPointY) + 45) / 90);
			if spawn_direction_ > 3 {
				spawn_direction_ = 0;
			}
			switch spawn_direction_ {
				case 0:
					iteration_ = horizontal_side_square_size_ + (round(vertical_side_square_size_ / 2)) - 3;
					break;
				case 1:
					iteration_ = round(horizontal_side_square_size_ / 2) - 3;
					break;
				case 2:
					iteration_ = (horizontal_side_square_size_ * 2) + vertical_side_square_size_ + (round(vertical_side_square_size_ / 2)) - 3;
					break;
				case 3:
					iteration_ = horizontal_side_square_size_ + vertical_side_square_size_ + (round(horizontal_side_square_size_ / 2)) - 3;
					break;
			}
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
				check_x_ = x - (square_iteration_ * 16) + ((horizontal_side_square_size_ - 1) * 16) - (iteration_ - (horizontal_side_square_size_ + vertical_side_square_size_));
				check_y_ = y - ((square_iteration_ + vertical_offset_) * 16) + ((vertical_side_square_size_ - 1) * 16);
			}
			else if iteration_ < total_square_size_perimeter_ {
				check_x_ = x - (square_iteration_ * 16);
				check_y_ = y - ((square_iteration_ + vertical_offset_) * 16) + ((vertical_side_square_size_ - 1) * 16) - (iteration_ - ((horizontal_side_square_size_ * 2) + vertical_side_square_size_));
			}
			
			// Check to see if the spawn point is valid, and if it is, set that as true.
			if mp_grid_get_cell(movementGrid, (check_x_ / 16), (check_y_ / 16)) == 0 {
				spawn_found_ = true;
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
		var unit_spawned_ = instance_create_depth(floor(check_x_ / 16) * 16, floor(check_y_ / 16) * 16, check_y_, obj_unit);
		unit_spawned_.justSpawned = true;
		unit_spawned_.objectVisibleTeam = objectRealTeam;
		unit_spawned_.objectRealTeam = objectRealTeam;
		unit_spawned_.objectClassification = "Unit";
		unit_spawned_.objectType = "Worker";
		unit_spawned_.objectCurrentCommand = "Attack";
		unit_spawned_.objectNeedsToMove = true;
		unit_spawned_.targetToMoveToX = rallyPointX;
		unit_spawned_.targetToMoveToY = rallyPointY;
		unit_spawned_.currentAction = unitAction.move;
		unit_spawned_.currentDirection = floor(point_direction(x, y, unit_spawned_.targetToMoveToX, unit_spawned_.targetToMoveToY) / 90);
		with unit_spawned_ {
			event_perform(ev_step, ev_step_normal);
		}
	}
	else {
		return false;
	}
}


