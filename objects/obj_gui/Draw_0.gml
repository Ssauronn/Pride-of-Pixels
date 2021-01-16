///@description Draw UI Elements on Map

#region Healthbars
with all {
	if variable_instance_exists(self.id, "objectClassification") {
		// Draw healthbar
		// If the object is a resource, or unitAction, or building, and is either 
		// in combat, being highlighted by the player, or selected, make the 
		// healthbar visible.
		if ((objectClassification == "Unit") && ((objectCurrentCommand == "Attack") || (collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) || ((objectClassification == "Building") && ((instance_exists(objectTarget)) || (collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) || ((objectClassification == "Resource") && ((collision_point(mouse_x, mouse_y, self.id, true, false)) || (objectSelected))) {
			// Set depth to be equal to the y value of the object. This makes it so that health bars stack
			// on top of all other objects that are there.
			depth = y;
			draw_healthbar(x, y - 5, x + 16, y - 2, (currentHP / maxHP) * 100, c_black, c_red, c_lime, 0, true, true);
			depth = -y;
		}
	}
}
#endregion


