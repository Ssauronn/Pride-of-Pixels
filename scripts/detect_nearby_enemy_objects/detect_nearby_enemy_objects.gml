///@function					detect_nearby_enemy_objects();
///@parameter					{string} [optional] objectType
///@description				Detects all nearby hostile objects within a given range. Can take
///								optional arguments to determine if specific types of enemies are
///								nearby. Return a ds_list of all found objects.

function detect_nearby_enemy_objects() {
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
	if argument_count > 0 {
		target_specified_ = argument[0];
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
			var temp_x_search_area_ = (floor(x / 16) * 16) - (objectCombatAggroRange * 16) + (k * 16);
			var temp_y_search_area_ = (floor(y / 16) * 16) - (objectCombatAggroRange * 16) + (j * 16);
			var instance_at_location_ = instance_place(temp_x_search_area_, temp_y_search_area_, all);
			// If an object is at the check location, is not a resource, is not on the same team as the
			// object running this function, and either no specific target was specified, or the object
			// at location matches the specified target type, then add that object's ID to the list.
			if instance_exists(instance_at_location_) {
				if instance_at_location_.objectClassification != "Resource" {
					if instance_at_location_.objectTeam != objectTeam {
						if (!target_specified_) || (instance_at_location_.objectType == target_specified_) {
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
	return true;
}


