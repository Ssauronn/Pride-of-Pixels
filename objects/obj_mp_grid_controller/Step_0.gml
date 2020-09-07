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


