// Clean up potential memory leaks
if ds_exists(unitGridLocation, ds_type_grid) {
	if ds_exists(objectDetectedList, ds_type_list) {
		ds_list_destroy(objectDetectedList);
		objectDetectedList = noone;
	}
}


