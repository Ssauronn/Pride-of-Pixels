///@description Draw UI Elements on Screen

if room_get_name(room) == "WarRoom" {
	#region Healthbars
	with all {
		if variable_instance_exists(self.id, "objectClassification") {
			// Draw healthbar
			// If the object is a resource, or unitAction, or building, and is either 
			// in combat, being highlighted by the player, or selected, make the 
			// healthbar visible.
			if ((objectClassification == "Unit") && ((objectCurrentCommand == "Attack") || (collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) || ((objectClassification == "Building") && ((instance_exists(objectTarget)) || (point_in_rectangle(mouse_x, mouse_y, x, y - sprite_height + 16, x + sprite_width, self.y + 16)) || (objectSelected))) || ((objectClassification == "Resource") && ((collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) {
				if objectClassification != "Unit" {
					draw_sprite_ext(spr_healthbar_background, 0, x, y - 5, (1 / sprite_get_width(spr_healthbar_background)) * sprite_width, 4 / sprite_get_height(spr_healthbar_background), 0, c_white, 1);
					draw_sprite_part_ext(spr_healthbar_fill, 0, 1, 1, (currentHP / maxHP) * 16, 3, x + 1, y - 4, (1 / sprite_get_width(spr_healthbar_background)) * sprite_width, 4 / sprite_get_height(spr_healthbar_background), c_white, 1);
				}
				else {
					draw_sprite_ext(spr_healthbar_background, 0, x, y - 5, (1 / sprite_get_width(spr_healthbar_background)) * 16, 4 / sprite_get_height(spr_healthbar_background), 0, c_white, 1);
					draw_sprite_part_ext(spr_healthbar_fill, 0, 1, 1, (currentHP / maxHP) * 16, 3, x + 1, y - 4, (1 / sprite_get_width(spr_healthbar_background)) * 16, 4 / sprite_get_height(spr_healthbar_background), c_white, 1);
				}
			}
		}
	}
	#endregion
}


