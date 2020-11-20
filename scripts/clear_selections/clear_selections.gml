///@function					clear_selections();
///@parameter					{index} [optional] idOrObjectIndex
///@description				Takes a variable number of parameters {index} and resets
///								selection variables on the object(s).

function clear_selections() {
	if argument_count > 0 {
		var i;
		for (i = 0; i < argument_count; i++) {
			with argument[i] {
				if objectSelected {
					obj_camera_inputs_and_gui.numberOfObjectsSelected--;
					objectSelected = false;
					if ds_exists(objectsSelectedList, ds_type_list) {
						if ds_list_size(objectsSelectedList) > 1 {
							if ds_list_find_index(objectsSelectedList, self.id) != -1 {
								ds_list_delete(objectsSelectedList, ds_list_find_index(objectsSelectedList, self.id));
							}
						}
						else {
							ds_list_destroy(objectsSelectedList);
							objectsSelectedList = noone;
						}
					}
				}
			}
		}
		return true;
	}
	else {
		return false;
	}
}


