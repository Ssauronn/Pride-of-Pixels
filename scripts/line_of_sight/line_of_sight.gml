///@function line_of_sight_exists_to_target();
///@argument0 StartX
///@argument1 StartY
///@argument2 TargetX
///@argument3 TargetY
function line_of_sight_exists_to_target(x_, y_, target_x_, target_y_) {
	// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
	var building_, tree_, food_, gold_, ruby_;
	building_ = collision_line(x_, y_, target_x_, target_y_, obj_building, true, true);
	tree_ = collision_line(x_, y_, target_x_, target_y_, obj_tree_resource, true, true);
	food_ = collision_line(x_, y_, target_x_, target_y_, obj_food_resource, true, true);
	gold_ = collision_line(x_, y_, target_x_, target_y_, obj_gold_resource, true, true);
	ruby_ = collision_line(x_, y_, target_x_, target_y_, obj_ruby_resource, true, true);
	if (building_ == noone) && (tree_ == noone) && (food_ == noone) && (gold_ == noone) && (ruby_ == noone) {
		return true;
	}
	else return false;
}


