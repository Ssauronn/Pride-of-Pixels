// Draw sprite indicating selection
if objectOnScreen {
	if objectSelected {
		switch mask_index {
			case spr_16_16:
				draw_sprite_ext(spr_selected, 0, x, y, 1, 1, 0, c_white, 0.75);
				break;
			case 32:
				draw_sprite_ext(spr_selected, 0, x, y - 16, 2, 2, 0, c_white, 0.75);
				break;
			case 48:
				draw_sprite_ext(spr_selected, 0, x, y - 32, 3, 3, 0, c_white, 0.75);
				break;
			case 64:
				draw_sprite_ext(spr_selected, 0, x, y - 48, 4, 4, 0, c_white, 0.75);
				break;
		}
		draw_sprite(spr_rally_point, 1, floor(rallyPointX / 16) * 16, floor(rallyPointY / 16) * 16);
	}
	if !obj_gui.startMenu.active {
		// Draw self
		if objectType == "Obelisk" {
			var teet_ = 1;
		}
		if objectType == "City Hall" {
			var teet_ = 1;
		}
		draw_sprite(currentSprite, currentImageIndex, x, y)
	}
}


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
draw_text(x, y, string(objectVisibleTeam));


