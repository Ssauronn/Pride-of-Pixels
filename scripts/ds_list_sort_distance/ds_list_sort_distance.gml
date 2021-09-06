///@function									ds_list_sort_distance();
///@param	{real} DSListToSort					The ds_list to sort.
///@description									Sort objects in a ds_list by distance, in pixels, relative to the object
///												calling this function. Only works with objects.
function ds_list_sort_distance(original_list_) {
	// After the target_list_ is created, go through and sort that list by closest to furthest,
	// with closest being at index 0.
	if ds_exists(original_list_, ds_type_list) {
		// No need to sort if there's only 1 value in the list
		if ds_list_size(original_list_) > 1 {
			var total_, current_, longest_distance_, furthest_object_;
			furthest_object_ = noone;
			for (total_ = 0; total_ < ds_list_size(original_list_); total_++) {
				for (current_ = total_; current_ < ds_list_size(original_list_); current_++) {
					var instance_to_reference_ = ds_list_find_value(original_list_, current_);
					var distance_to_referenced_instance_ = distance_to_object(instance_to_reference_);
					if furthest_object_ == noone {
						furthest_object_ = instance_to_reference_;
						longest_distance_ = distance_to_referenced_instance_;
					}
					else if distance_to_referenced_instance_ > longest_distance_ {
						furthest_object_ = instance_to_reference_;
						longest_distance_ = distance_to_referenced_instance_;
					}
				}
				ds_list_delete(original_list_, ds_list_find_index(original_list_, furthest_object_));
				ds_list_insert(original_list_, 0, furthest_object_);
				furthest_object_ = noone;
			}
		}
	}
}


