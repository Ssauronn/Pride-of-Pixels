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

if mouse_check_button_pressed(mb_right) {
	if instance_exists(obj_worker) {
		with obj_worker {
			if objectSelected {
				if ds_exists(unitGridLocation, ds_type_grid) {
					var i, instance_to_reference_, instance_to_reference_x_, instance_to_reference_y_, self_found_;
					self_found_ = -1;
					for (i = 0; i <= ds_grid_height(unitGridLocation) - 1; i++) {
						instance_to_reference_ = ds_grid_get(unitGridLocation, 0, i);
						instance_to_reference_x_ = ds_grid_get(unitGridLocation, 1, i);
						instance_to_reference_y_ = ds_grid_get(unitGridLocation, 2, i);
						if (self.id == instance_to_reference_) && (x = instance_to_reference_x_) && (y == instance_to_reference_y_) {
							self_found_ = i;
							break;
						}
					}
					// If self exists in unitGridLocation (which it always should) remove it from the ds_grid
					// by shifting all below values up by one and then removing the very bottom row (which is now
					// a duplicate row).
					if self_found_ != -1 {
						if ds_grid_height(unitGridLocation) > 1 {
							ds_grid_set_grid_region(unitGridLocation, unitGridLocation, 0, self_found_ + 1, 2, ds_grid_height(unitGridLocation) - 1, 0, self_found_);
							ds_grid_resize(unitGridLocation, 3, ds_grid_height(unitGridLocation) - 1);
						}
						else {
							ds_grid_destroy(unitGridLocation);
							unitGridLocation = noone;
						}
					}
				}
				targetToMoveToX = floor(mouse_x / 16) * 16;
				targetToMoveToY = floor(mouse_y / 16) * 16;
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
				validPathFound = false;
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
				sizeOfGroupSelectedToMoveWith = 0;
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
			}
		}
	}
}


