///@function swap_data_position_in_structure(_data_structure, _structure_type_string, _id_one, id_two);
///@argument0 _data_structure				Data Structure
///@argument1 _structure_type_string		String, can be "list" or "grid"
///@argument2 _id_one						Identifying value to swap y index with the second value
///@argument3 _id_two						Identifying value to swap y index with the first value
///@description								Takes two identifying values (generally will be an
///											object ID, but can be any unique value in the data
///											structure), and swaps Y indices with another data
///											structure.

function swap_data_position_in_structure(_data_structure, _structure_type_string, _id_one, _id_two) {
	if _structure_type_string == "list" {
		if ds_exists(_data_structure, ds_type_list) {
			var first_value_index_ = ds_list_find_index(_data_structure, _id_one);
			var second_value_index_ = ds_list_find_index(_data_structure, _id_two);
			if (first_value_index_ != -1) && (second_value_index_ != -1) {
				ds_list_set(_data_structure, first_value_index_, _id_two);
				ds_list_set(_data_structure, second_value_index_, _id_one);
				return true;
			}
			// If the values don't exist in the list, then return false.
			else return false;
		}
		// If there is not a list with the given index, then return false.
		else return false;
	}
	else if _structure_type_string == "grid" {
		if ds_exists(_data_structure, ds_type_grid) {
			var structure_width_ = ds_grid_width(_data_structure);
			var structure_height_ = ds_grid_width(_data_structure);
			var first_value_index_ = ds_grid_value_y(_data_structure, 0, 0, structure_width_ - 1, structure_height_ - 1, _id_one);
			var second_value_index_ = ds_grid_value_y(_data_structure, 0, 0, structure_width_ - 1, structure_height_ - 1, _id_two);
			if (first_value_index_ != -1) && (second_value_index_ != -1) && (structure_height_ > 1) {
				var x_value_at_first_index_ = noone;
				var i;
				for (i = 0; i < structure_width_; i++) {
					// Copy the value at the x, y index of the first value into a temporary variable
					x_value_at_first_index_ = ds_grid_get(_data_structure, i, first_value_index_);
					// Now that the first value has been copied, overwrite it with the second value
					// at the same x value, but obviously different y value.
					ds_grid_set(_data_structure, i, first_value_index_, ds_grid_get(_data_structure, i, second_value_index_));
					// Now that the first value has been overwritten, overwrite the second index value
					// using the data stored in the temporary variable.
					ds_grid_set(_data_structure, i, second_value_index_, x_value_at_first_index_);
				}
				return true;
			}
			// If the values don't exist in the grid, then return false.
			else return false;
		}
		// If there is not a grid with the given index, then return false
		else return false;
	}
	else return false;
}