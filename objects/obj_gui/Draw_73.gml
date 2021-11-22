///@description Draw UI Elements on Screen

if room_get_name(room) == "WarRoom" {
	#region Healthbars
	with all {
		if variable_instance_exists(self.id, "objectClassification") {
			// Draw healthbar
			// If the object is a resource, or unitAction, or building, and is either 
			// in combat, being highlighted by the player, or selected, make the 
			// healthbar visible.
			if ((objectClassification == "Unit") && ((objectCurrentCommand == "Attack") || (collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) || ((objectClassification == "Building") && ((instance_exists(objectTarget)) || (collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) || ((objectClassification == "Resource") && ((collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) {
				draw_sprite_ext(spr_healthbar_background, 0, x, y - 5, (16 / sprite_get_width(spr_healthbar_background)), 4 / sprite_get_height(spr_healthbar_background), 0, c_white, 1);
				draw_sprite_part_ext(spr_healthbar_fill, 0, 1, 1, (currentHP / maxHP) * 16, 3, x + 1, y - 4, (16 / sprite_get_width(spr_healthbar_background)), 4 / sprite_get_height(spr_healthbar_background), c_white, 1);
			}
		}
	}
	#endregion
}


