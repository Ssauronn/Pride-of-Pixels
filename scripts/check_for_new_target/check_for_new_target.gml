///@function				check_for_new_target();
///@description				Checks for a new set of targets within range using detect_nearby_enemy_objects() script.
///							Called usually after the current list of targets has expired but the object is still in
///							combat, meaning there are potentially other, not-yet-found valid targets within range.
function check_for_new_target() {
	if detect_nearby_enemy_objects() {
		if ds_exists(objectDetectedList, ds_type_list) {
			// If the ds_list for current targets doesn't exist, checked above, but current targets exist
			// within range, checked in detect_nearby_enemy_objects() script and verified above, then 
			// copy that list over to the actual target list and then set the nearest enemy target as the
			// next valid target to attack.
			objectTargetList = ds_list_create();
			ds_list_copy(objectTargetList, objectDetectedList);
			ds_list_destroy(objectDetectedList);
			objectDetectedList = noone;
			var i, closest_target_, distance_;
			for (i = 0; i < ds_list_size(objectTargetList); i++) {
				var instance_to_reference_ = ds_list_find_value(objectTargetList, i);
				if i == 0 {
					closest_target_ = instance_to_reference_.id;
					distance_ = distance_to_object(closest_target_);
				}
				else if distance_to_object(instance_to_reference_) < distance_ {
					closest_target_ = instance_to_reference_.id;
					distance_ = distance_to_object(closest_target_);
				}
			}
	
			objectTarget = closest_target_;
			var current_target_index_ = ds_list_find_index(objectTargetList, closest_target_);
			if current_target_index_ != 0 {
				ds_list_delete(objectTargetList, current_target_index_)
				ds_list_insert(objectTargetList, 0, closest_target_);
			}
		}
	}
}