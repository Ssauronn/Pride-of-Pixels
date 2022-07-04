// Draw sprite indicating selection
if objectOnScreen {
	if objectSelected {
		draw_sprite_ext(spr_selected, 0, x, y, 1, 1, 0, c_white, 0.75);
	}
	// Draw self
	if currentSprite != noone {
		draw_sprite(currentSprite, currentImageIndex, x, y);
	}
	else {
		draw_sprite(currentHeadSprite, currentImageIndex, x, y);
		draw_sprite(currentChestSprite, currentImageIndex, x, y);
		draw_sprite(currentLegsSprite, currentImageIndex, x, y);
	}
}

if path_exists(myPath) {
	draw_path(myPath, x, y, true);
}



// Debugging stuff
//draw_text(x, y, string(currentAction))
//draw_text(x, y, string(objectRealTeam) + " = Real Team");
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


