///@function					detect_nearby_enemy_objects(x, y, objectType);
///@param	{real}	x_			The x value of the location to check
///@param	{real}	y_			The y value of the location to check
///@param	{string}			optional - the objectType looking for.
///@description					Detects all nearby hostile objects within a given range. Can take
///								optional arguments to determine if specific types of enemies are
///								nearby. Return a ds_list of all found objects.

function detect_nearby_enemy_objects(x_, y_) {
	/*
	Loop through the entirety of the area surrounding the object calling this script,
	using the objects aggro range as the parameters of the search. If an argument is
	provided, it'll be a string matching an object's possible Type. The script will only
	return a valid value (in this case, a list containing the ID's of all objects within
	range) if an object is found within range that matches the type given, and is not
	the same team as the object calling this script. Otherwise, if no string argument is
	given, the script will simply return the ID of all objects within range that are not
	part of the team of the object calling this script. And this script will return noone
	instead if no combat target within objectCombatAggroRange is found.
	*/
	// Firstly, wipe the previous list if it existed.
	if ds_exists(objectDetectedList, ds_type_list) {
		ds_list_destroy(objectDetectedList);
		objectDetectedList = noone;
	}
	
	// Now search.
	var j, k, closest_object_, target_specified_;
	closest_object_ = noone;
	if argument_count > 2 {
		target_specified_ = argument[2];
	}
	else {
		target_specified_ = false;
	}
	// The offset variables. Since the origin point is the top left corner of a 16x16 box in every
	// sprite, regardless of the actual sprite size, I need to adjust for that to get a search area
	// that searches each location around the sprite in equal directions relative to the edge of that
	// sprite.
	var x_offset_ = floor(sprite_get_width(self.sprite_index) / 16) * 16;
	var y_offset_ = (floor(sprite_get_height(self.sprite_index) / 16) * 16) - 16;
	// The vertical searches
	for (j = 0; j < (objectCombatAggroRange * 2) + 1 + (y_offset_ / 16); j++) {
		// The horizontal searches
		for (k = 0 - (x_offset_ / 16); k < (objectCombatAggroRange * 2) + 1; k++) {
			var temp_x_search_area_ = (floor(x_ / 16) * 16) - (objectCombatAggroRange * 16) + (k * 16);
			var temp_y_search_area_ = (floor(y_ / 16) * 16) - (objectCombatAggroRange * 16) + (j * 16);
			var instance_at_location_ = instance_place(temp_x_search_area_, temp_y_search_area_, all);
			// If an object is at the check location, is not a resource, is not on the same team as the
			// object running this function, and either no specific target was specified, or the object
			// at location matches the specified target type, then add that object's ID to the list.
			if instance_exists(instance_at_location_) {
				// As long as the nearby object isn't a resource or resource building, continue working.
				// I don't check for resource buildings because they shouldn't automatically be destroyed
				// by armies, because they're usable by all teams.
				// Or, if the nearby object is a resource or resource building, and the specified type
				// of object to look for is a resource or resource building, then continue working.
				if ((instance_at_location_.objectClassification != "Resource") && (instance_at_location_.objectType != "Farm") && (instance_at_location_.objectType != "Thicket") && (instance_at_location_.objectType != "Mine")) || (((target_specified_ == "Food") && (instance_at_location_.objectType == "Food")) || ((target_specified_ == "Wood") && (instance_at_location_.objectType == "Wood")) || ((target_specified_ == "Gold") && (instance_at_location_.objectType == "Gold")) || ((target_specified_ == "Ruby") && (instance_at_location_.objectType == "Ruby")) || ((target_specified_ == "Farm") && (instance_at_location_.objectType == "Farm")) || ((target_specified_ == "Thicket") && (instance_at_location_.objectType == "Thicket")) || ((target_specified_ == "Mine") && (instance_at_location_.objectType == "Mine"))) {
					// Specifically check to see if the visible team, AND real team is not equal to the
					// same team as the object calling this script. This prevents any automatic check from
					// registering friendly spies who are commanded to look like enemy units, or registering
					// enemy spies who are commanded to look like friendly units. 
					// Also, check to see if the unit calling this script is a Worker, in which case if
					// its command is to collect resources, then any nearby resources or resource buildings
					// should be found as well.
					if ((instance_at_location_.objectVisibleTeam != objectRealTeam) && (instance_at_location_.objectRealTeam != objectRealTeam)) || ((objectType == "Worker") && ((objectCurrentCommand == "Gather") || (objectCurrentCommand == "Chop") || (objectCurrentCommand == "Mine")) && ((instance_at_location_.objectType == "Farm") || (instance_at_location_.objectType == "Thicket") || (instance_at_location_.objectType == "Mine"))) {
						if (target_specified_ == false) || (instance_at_location_.objectType == target_specified_) {
							if !ds_exists(objectDetectedList, ds_type_list) {
								objectDetectedList = ds_list_create();
							}
							ds_list_add(objectDetectedList, instance_at_location_.id);
						}
					}
				}
			}
		}
	}
	// After creating the ds_list, just sort by distance to the object calling this function, just to be
	// careful.
	if ds_exists(objectDetectedList, ds_type_list) {
		if ds_list_size(objectDetectedList) > 1 {
			ds_list_sort_distance(x, y, objectDetectedList);
		}
	}
	return true;
}


