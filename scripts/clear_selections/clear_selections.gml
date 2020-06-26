var i;
for (i = 0; i < argument_count; i++) {
	with argument[i] {
		if objectSelected {
			obj_camera_and_gui.numberOfObjectsSelected--;
			objectSelected = false;
			if ds_exists(objectsSelectedList, ds_type_list) {
				if ds_list_size(objectsSelectedList) > 1 {
					ds_list_delete(objectsSelectedList, ds_list_find_index(objectsSelectedList, self.id));
				}
				else {
					ds_list_destroy(objectsSelectedList);
					objectsSelectedList = noone;
				}
			}
		}
	}
}


