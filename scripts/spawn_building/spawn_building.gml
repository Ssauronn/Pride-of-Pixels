///@function	spawn_building();			
///@param	{string}	building_type	The type of building to spawn.
///@param	{real}	building_team		The team the building will belong to.
///@description							Spawn a building at location. The check for a valid location
///										to spawn the specific building should have happened previously
///										so this is just setting the spawn variables for the building.
function spawn_building(building_type_, building_team_){
	var unit_spawned_ = instance_create_depth(floor(check_x_ / 16) * 16, floor(check_y_ / 16) * 16, check_y_, obj_unit);
	with unit_spawned_ {
		justSpawned = true;
		objectRealTeam = building_team_;
		objectVisibleTeam = building_team_;
		objectClassification = "Building";
		objectType = building_type_;
		event_perform(ev_step, ev_step_normal);
	}
}