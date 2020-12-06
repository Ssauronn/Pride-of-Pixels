// Clean up potential memory leaks
if ds_exists(unitGridLocation, ds_type_grid) {
	if ds_grid_value_exists(unitGridLocation, 0, 0, 1, ds_grid_height(unitGridLocation) - 1, self.id) {
		if ds_grid_height(unitGridLocation) > 1 {
			var y_location_ = ds_grid_value_y(unitGridLocation, 0, 0, 1, ds_grid_height(unitGridLocation) - 1, self.id);
			if y_location_ != -1 {
				ds_grid_set_grid_region(unitGridLocation, unitGridLocation, 0, y_location_ + 1, 2, ds_grid_height(unitGridLocation) - 1, 0, y_location_);
				ds_grid_resize(unitGridLocation, ds_grid_width(unitGridLocation), ds_grid_height(unitGridLocation) - 1);
			}
		}
		else {
			ds_grid_destroy(unitGridLocation);
			unitGridLocation = noone;
		}
	}
	if ds_exists(objectDetectedList, ds_type_list) {
		ds_list_destroy(objectDetectedList);
		objectDetectedList = noone;
	}
}


