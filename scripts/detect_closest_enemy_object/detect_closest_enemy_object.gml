///@function					detect_closest_enemy_object();
///@param	{string}			optional - objectType
///@description					Detects all nearby objects within a given range. Can take optional
///								arguments to determine if specific types of enemies are nearby.

function detect_closest_enemy_object() {
	/*
	Loop through the entirety of the area surrounding the object calling this script,
	using the objects aggro range as the parameters of the search. If an argument is
	provided, it'll be a string matching an object's possible Type. The script will only
	return a valid value (in this case, the ID of the closest object that matches the
	given Type) if an object is found within range that matches the type given, and is not
	the same team as the object calling this script. Otherwise, if no string argument is
	given, the script will simply return the ID of the closest object that is not part of
	the team of the object calling this script. And this script will return noone instead
	if no combat target within objectCombatAggroRange is found.
	*/
	var j, k, closest_object_, target_specified_;
	closest_object_ = noone;
	if argument_count > 0 {
		target_specified_ = argument[0];
	}
	else {
		target_specified_ = false;
	}
	// The vertical searches
	for (j = 0; j < (objectCombatAggroRange * 2) + 1; j++) {
		// The horizontal searches
		for (k = 0; k < (objectCombatAggroRange * 2) + 1; k++) {
			var temp_x_search_area_ = (floor(x / 16) * 16) - (objectCombatAggroRange * 16) + (k * 16);
			var temp_y_search_area_ = (floor(y / 16) * 16) - (objectCombatAggroRange * 16) + (j * 16);
			var instance_at_location_ = instance_place(temp_x_search_area_, temp_y_search_area_, all);
			// If an object is at the check location, is not a resource, is not on the same team as the
			// object running this function, and either no specific target was specified, or the object
			// at location matches the specified target type, then determine if its the closest target,
			// and if so, attack that target.
			if instance_exists(instance_at_location_) {
				if instance_at_location_.objectClassification != "Resource" {
					// Specifically check to see if the visible team, AND real team is not equal to the
					// same team as the object calling this script. This prevents any automatic check from
					// registering friendly spies who are commanded to look like enemy units, or registering
					// enemy spies who are commanded to look like friendly units. 
					if (instance_at_location_.objectVisibleTeam != objectRealTeam) && (instance_at_location_.objectRealTeam != objectRealTeam) {
						if line_of_sight_exists_to_target(floor(x / 16) * 16, floor(y / 16) * 16, floor(instance_at_location_.x / 16) * 16, floor(instance_at_location_.y / 16) * 16) {
							if (!target_specified_) || (instance_at_location_.objectType == target_specified_) {
								if !instance_exists(closest_object_) {
									closest_object_ = instance_at_location_.id;
								}
								else if (point_distance(x, y, instance_at_location_.x, instance_at_location_.y)) < (point_distance(x, y, closest_object_.x, closest_object_.y)) {
									closest_object_ = instance_at_location_.id;
								}
							}
						}
					}
				}
			}
		}
	}
	return closest_object_;
}

