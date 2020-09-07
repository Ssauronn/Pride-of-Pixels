if objectSelected && objectOnScreen {
	draw_sprite_ext(spr_selected, 0, x, y, 1, 1, 0, c_white, 0.75);
}
draw_text(x + 16, y + 16, obj_camera_inputs_and_gui.numberOfObjectsSelected);
//draw_text(x + 16, y - 16, string(x) + ", " + string(y));
draw_self();

if path_exists(myPath) {
	draw_path(myPath, x, y, true);
}

if ds_exists(objectTargetList, ds_type_list) {
	var i;
	for (i = 0; i <= ds_list_size(objectTargetList) - 1; i++) {
		var instance_to_reference_ = ds_list_find_value(objectTargetList, i);
		if instance_exists(instance_to_reference_) {
			draw_text(instance_to_reference_.x, instance_to_reference_.y, string(i));
		}
	}
}

