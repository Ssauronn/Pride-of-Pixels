// Draw sprite indicating selection
if objectSelected && objectOnScreen {
	draw_sprite_ext(spr_selected, 0, x, y, 1, 1, 0, c_white, 0.75);
}
// Draw self
draw_self();

/* Draw object coordinates
if ds_exists(objectTargetList, ds_type_list) {
	var i;
	for (i = 0; i < ds_list_size(objectTargetList); i++) {
		var instance_to_reference_ = ds_list_find_value(objectTargetList, i);
		if instance_exists(instance_to_reference_) {
			draw_text(instance_to_reference_.x, instance_to_reference_.y, string(i));
		}
	}
}
*/

//draw_text(x, y, string(currentAction))
draw_text(x, y, string(objectTeam));

