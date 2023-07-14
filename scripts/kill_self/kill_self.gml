///@function									kill_self();
///@description								Clean up all ds_lists, removing self's ID from each of them before
///												eliminating self from the game.
function kill_self() {
	// Cleanse objectsSelectedList
	if ds_exists(objectsSelectedList, ds_type_list) {
		var instance_found_ = ds_list_find_index(objectsSelectedList, id);
		if instance_found_ != -1 {
			if ds_list_size(objectsSelectedList) > 1 {
				ds_list_delete(objectsSelectedList, instance_found_);
			}
			else {
				ds_list_destroy(objectsSelectedList);
				objectsSelectedList = noone;
			}
		}
	}
	// Cleanse unitQueueForPathfindingList
	if ds_exists(unitQueueForPathfindingList, ds_type_list) {
		var instance_found_ = ds_list_find_index(unitQueueForPathfindingList, id);
		if instance_found_ != -1 {
			if ds_list_size(unitQueueForPathfindingList) > 1 {
				ds_list_delete(unitQueueForPathfindingList, instance_found_);
			}
			else {
				ds_list_destroy(unitQueueForPathfindingList);
				unitQueueForPathfindingList = noone;
			}
		}
	}
	/*
	I don't bother cleansing objectTargetList for other objects, which is a local list for each unitAction, because 
	all units already have automatic handling for situations where the object or target in the list doesn't exist.
	I do however still destroy the list that this object controls.
	*/
	if variable_instance_exists(self, "objectTargetList") {
		if ds_exists(objectTargetList, ds_type_list) {
			var instance_found_ = ds_list_find_index(objectTargetList, id);
			if instance_found_ != -1 {
				if ds_list_size(objectTargetList) > 1 {
					ds_list_delete(objectTargetList, instance_found_);
				}
				else {
					ds_list_destroy(objectTargetList);
					objectTargetList = noone;
				}
			}
		}
	}
	
	// Remove self from the list of Storehouses and City Halls for that specific player if the object
	// being destroyed here is a Storehouse or City Hall.
	remove_self_from_storehouse_city_hall_list();
	
	
	// Destroy self finally
	instance_destroy(self);
}


