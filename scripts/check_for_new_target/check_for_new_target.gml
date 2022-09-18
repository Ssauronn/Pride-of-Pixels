///@function				check_for_new_target(x_, y_);
///@param	{real}	x_		x_
///@param	{real}	y_		y_
///@param	{string}		optional - the object type looking for
///@description				Checks for a new set of targets within range using detect_nearby_enemy_objects() script.
///							Called usually after the current list of targets has expired but the object is still in
///							combat, meaning there are potentially other, not-yet-found valid targets within range.
function check_for_new_target(x_, y_) {
	// If the object type is provided
	if argument_count > 2 {
		var object_type_ = argument[2];
	}
	else {
		var object_type_ = noone;
	}
	// If the object type was provided, give that to the script.
	if object_type_ != noone {
		detect_nearby_enemy_objects(x_, y_, object_type_);
	}
	else {
		detect_nearby_enemy_objects(x_, y_);
	}
	if ds_exists(objectDetectedList, ds_type_list) {
		// If the ds_list for current targets doesn't exist, checked above, but current targets exist
		// within range, checked in detect_nearby_enemy_objects() script and verified above, then 
		// copy that list over to the actual target list and then set the nearest enemy target as the
		// next valid target to attack.
		if ds_exists(objectTargetList, ds_type_list) {
			ds_list_destroy(objectTargetList);
			objectTargetList = noone;
		}
		objectTargetList = ds_list_create();
		ds_list_copy(objectTargetList, objectDetectedList);
		ds_list_destroy(objectDetectedList);
		objectDetectedList = noone;
		var i, closest_target_, distance_;
		for (i = 0; i < ds_list_size(objectTargetList); i++) {
			var instance_to_reference_ = ds_list_find_value(objectTargetList, i);
			if i == 0 {
				closest_target_ = real(instance_to_reference_.id);
				distance_ = point_distance(x_, y_, closest_target_.x, closest_target_.y);
			}
			else if distance_to_object(instance_to_reference_) < distance_ {
				closest_target_ = real(instance_to_reference_.id);
				distance_ = point_distance(x_, y_, closest_target_.x, closest_target_.y);
			}
		}

		objectTarget = closest_target_;
		var current_target_index_ = ds_list_find_index(objectTargetList, closest_target_);
		if current_target_index_ != 0 {
			ds_list_delete(objectTargetList, current_target_index_)
			ds_list_insert(objectTargetList, 0, closest_target_);
		}
	}
	else {
		return noone;
	}
}