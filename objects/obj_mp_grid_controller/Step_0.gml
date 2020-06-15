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
				groupRowWidth = 0;
				sizeOfGroupSelectedToMoveWith = 0;
				specificLocationNeedsToBeChecked = false;
				specificLocationToBeCheckedX = targetToMoveToX;
				specificLocationToBeCheckedY = targetToMoveToY;
				tempCheckX = targetToMoveToX;
				tempCheckY = targetToMoveToY;
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


