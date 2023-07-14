///@function					add_self_to_storehouse_city_hall_list();
///@description					This script adds an obj_building object to the list of 
///								existing Storehouses and City Halls for the player.
function add_self_to_storehouse_city_hall_list(){
	if (objectType == "City Hall") || (objectType == "Storehouse") {
		// If the list already exists, add self
		if ds_exists(player[objectRealTeam].listOfStorehousesAndCityHalls, ds_type_list) {
			if ds_list_find_index(player[objectRealTeam].listOfStorehousesAndCityHalls, real(id)) == -1 {
				ds_list_add(player[objectRealTeam].listOfStorehousesAndCityHalls, real(id));
			}
		}
		// Otherwise, create the list, then add self.
		else {
			player[objectRealTeam].listOfStorehousesAndCityHalls = ds_list_create();
			ds_list_add(player[objectRealTeam].listOfStorehousesAndCityHalls, real(id));
		}
	}
}

///@function					remove_self_from_storehouse_city_hall_list();
///@description					This script removes a obj_building object from the list of 
///								existing Storehouses and City Halls for the player in the
///								event that the object calling this function is destroyed.
function remove_self_from_storehouse_city_hall_list(){
	if (objectType == "City Hall") || (objectType == "Storehouse") {
		// Just a check to stop fatal errors. If this function is called, the ds_list should
		// always exist.
		if ds_exists(player[objectRealTeam].listOfStorehousesAndCityHalls, ds_type_list) {
			if (!ds_list_empty(player[objectRealTeam].listOfStorehousesAndCityHalls)) && (ds_list_size(player[objectRealTeam].listOfStorehousesAndCityHalls) > 1) {
				ds_list_delete(player[objectRealTeam].listOfStorehousesAndCityHalls, ds_list_find_index(player[objectRealTeam].listOfStorehousesAndCityHalls, real(id)));
			}
			else {
				ds_list_destroy(player[objectRealTeam].listOfStorehousesAndCityHalls);
				player[objectRealTeam].listOfStorehousesAndCityHalls = noone;
			}
		}
	}
}


