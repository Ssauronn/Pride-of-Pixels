///@function									ds_list_sort_distance();
///@param										{real} DSListToSort
///@description									Sort objects in a ds_list by distance, in pixels, relative to the object
///												calling this function. Only works with objects.
function ds_list_sort_distance() {
	var original_list_ = argument0;
	// After the target_list_ is created, go through and sort that list by closest to furthest,
	// with closest being at index 0.
	if ds_exists(original_list_, ds_type_list) {
		// No need to sort if there's only 1 value in the list
		if ds_list_size(original_list_) > 1 {
			var holding_list_ = ds_list_create();
			ds_list_copy(holding_list_, original_list_);
			var t, p;
			// Start at the top of the list, to get the value to search for.
			for (t = 0; t < ds_list_size(holding_list_); t++) {
				var temp_instance_to_reference_ = ds_list_find_value(holding_list_, t);
				var temp_instance_distance_ = distance_to_object(temp_instance_to_reference_);
				// Now that I have the value and distance to search for, compare it against the 
				// actual list, sorting downwards.
				for (p = ds_list_size(original_list_) - 1; p >= 0; p--) {
					var instance_to_compare_against_ = ds_list_find_value(original_list_, p);
					var temp_compare_instance_distance_ = distance_to_object(instance_to_compare_against_);
					// If the instance in the list is at a distance less than the instance at the bottom of the list,
					// move it to above that further object's index in the original list.
					if temp_instance_distance_ > temp_compare_instance_distance_ {
						// First, delete the line that contains that instance's value
						ds_list_delete(original_list_, ds_list_find_index(original_list_, temp_instance_to_reference_));
						// Then, insert a new line at the correct location that contains the instance's value
						ds_list_insert(original_list_, ds_list_find_index(original_list_, instance_to_compare_against_) + 1, temp_instance_to_reference_.id);
						break;
					}
				}
			}
			ds_list_destroy(holding_list_);
			holding_list_ = noone;
		}
	}
}


