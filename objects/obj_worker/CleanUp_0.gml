// Clean up potential memory leaks
if ds_exists(unitGridLocation, ds_type_grid) {
	if ds_grid_value_exists(unitGridLocation, 0, 0, 1, ds_grid_height(unitGridLocation) - 1, self.id) {
		if ds_grid_height(unitGridLocation) > 1 {
			var x_location_ = ds_grid_value_x(unitGridLocation, 0, 0, 1, ds_grid_height(unitGridLocation) - 1, self.id);
			var y_location_ = ds_grid_value_y(unitGridLocation, 0, 0, 1, ds_grid_height(unitGridLocation) - 1, self.id);
			ds_grid_set_grid_region(unitGridLocation, unitGridLocation, x_location_, y_location_ + 1, x_location_, ds_grid_height(unitGridLocation) - 1, x_location_, y_location_);
			ds_grid_resize(unitGridLocation, ds_grid_width(unitGridLocation), ds_grid_height(unitGridLocation) - 1);
		}
		else {
			ds_grid_destroy(unitGridLocation);
			unitGridLocation = noone;
		}
	}
}


