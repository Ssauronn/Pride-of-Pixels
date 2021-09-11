///@function					determine_leader_or_follower();
///@description					This script is used to group units based on their target to move to.
function determine_leader_or_follower() {
	var h, v, i, check_x_, check_y_, instance_to_reference_, objects_at_location_list_, leader_objects_list_;
	objects_at_location_list_ = noone;
	leader_objects_list_ = noone;
	// Horizontal search
	for (h = 0; h < 20; h++) {
		check_x_ = (floor(x / 16) * 16) - (16 * 10) + (16 * h);
		// Vertical search
		for (v = 0; v < 20; v++) {
			check_y_ = (floor(y / 16) * 16) - (16 * 10) + (16 * v);
			objects_at_location_list_ = ds_list_create();
			collision_point_list(check_x_, check_y_, all, true, true, objects_at_location_list_, true);
			if ds_exists(objects_at_location_list_, ds_type_list) && (ds_list_find_value(objects_at_location_list_, 0) != 0) {
				// Check for any and all objects at each check location, sort through any units, and determine
				// if any of them are potential leaders through the following criteria: same team, within line
				// of sight, is a unit, currently assigned to move, currently assigned as a leader, and is
				// moving to the same target or unit.
				for (i = 0; i < ds_list_size(objects_at_location_list_); i++) {
					instance_to_reference_ = ds_list_find_value(objects_at_location_list_, i);
					// If the instance is a unit, is on the same team, is within line of sight, is currently
					// taking a move action, is either targeting the same target, or moving to the same location,
					// and is assigned as a leader, set that unit as a potential leader.
					if instance_to_reference_.object_index == obj_unit {
						if instance_to_reference_.movementLeaderOrFollowing == "Leader" {
							foundALeaderYeet = true;
							if instance_to_reference_.objectRealTeam == objectRealTeam {
								if line_of_sight_exists_to_target(x, y, instance_to_reference_.x, instance_to_reference_.y) {
									if instance_to_reference_.currentAction == unitAction.move {
										if (instance_exists(instance_to_reference_.objectTarget) && instance_exists(objectTarget)) && instance_to_reference_.objectTarget == objectTarget {
											if !ds_exists(leader_objects_list_, ds_type_list) {
												leader_objects_list_ = ds_list_create();
											}
											ds_list_add(leader_objects_list_, instance_to_reference_);
										}
										else if (instance_to_reference_.originalTargetToMoveToX == originalTargetToMoveToX) && (instance_to_reference_.originalTargetToMoveToY == originalTargetToMoveToY) {
											if !ds_exists(leader_objects_list_, ds_type_list) {
												leader_objects_list_ = ds_list_create();
											}
											ds_list_add(leader_objects_list_, instance_to_reference_);
										}
									}
								}
							}
						}
					}
				}
			}
			ds_list_destroy(objects_at_location_list_);
		}
		if ds_exists(objects_at_location_list_, ds_type_list) {
			ds_list_destroy(objects_at_location_list_);
		}
	}
	if ds_exists(objects_at_location_list_, ds_type_list) {
		ds_list_destroy(objects_at_location_list_);
	}
	// Check between all potential leaders, if they exist, and determine which is closest to move with.
	// Otherwise, set self as leader.
	if ds_exists(leader_objects_list_, ds_type_list) {
		ds_list_sort_distance(leader_objects_list_);
		movementLeaderOrFollowing = ds_list_find_value(leader_objects_list_, 0);
		validPathFound = true;
		ds_list_destroy(leader_objects_list_);
		leader_objects_list_ = noone;
	}
	else {
		// Assign self as a leader
		movementLeaderOrFollowing = "Leader";
	}
}

/*
check 10x10 square for nearby units
if a unit exists, check team
if team is same, check action
if action is movement, check target
if same target, check line of sight
	if checked unit in line of sight and also moving and set to leader, then follow
if not same target, check target location
	if same target location and also moving and set to leader, then follow
if no units in range where the above apply to follow, set self as lead
*/
