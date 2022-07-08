///@function					draw_all_buttons();
///@description					This script is used to draw the GUI buttons
function draw_all_buttons() {
	var first_row_y_value_ = obj_gui.toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerYScale) + (obj_gui.toolbarButtonSpacing * 2);
	var second_row_y_value_ = obj_gui.toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerYScale) + (obj_gui.toolbarButtonSpacing * 3) + (obj_gui.toolbarButtonWidth * 1);
	var third_row_y_value_ = obj_gui.toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerYScale) + (obj_gui.toolbarButtonSpacing * 4) + (obj_gui.toolbarButtonWidth * 2);
	var special_row_x_value_ = obj_gui.toolbarUpgradeHorizontalDividerFirstX + obj_gui.toolbarUpgradeButtonXOffsetFromDividerX;
	var innovation_row_x_value_ = obj_gui.toolbarUpgradeHorizontalDividerFirstX + obj_gui.toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerXScale * 1) + (obj_gui.toolbarUpgradeHorizontalDividerSpacing * 1);
	var offensive_row_x_value_ = obj_gui.toolbarUpgradeHorizontalDividerFirstX + obj_gui.toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerXScale * 2) + (obj_gui.toolbarUpgradeHorizontalDividerSpacing * 2);
	var defensive_row_x_value_ = obj_gui.toolbarUpgradeHorizontalDividerFirstX + obj_gui.toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerXScale * 3) + (obj_gui.toolbarUpgradeHorizontalDividerSpacing * 3);
	if player[1].age == 0 {
		// If the upgrade is available to unlock and it is not currently being unlocked
		// Discovery - Special.1
		if (player[1].cityHall.discovery.upgradeAvailableToUnlock) && (!player[1].cityHall.discovery.upgradeBeingUnlocked) {
			with obj_gui {
				draw_sprite_ext(spr_discovery_icon, 0, special_row_x_value_, first_row_y_value_, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
			}
		}
	}
	else if player[1].age == 1 {
		// Experimentation - Special.2
		
		var innovation_sibling_shift_up_ = false;
		// Farming - Innovation.1.a
		if (player[1].cityHall.farming.upgradeAvailableToUnlock) && (!player[1].cityHall.farming.upgradeBeingUnlocked) {
			with obj_gui {
				draw_sprite_ext(spr_square_button, 0, innovation_row_x_value_, first_row_y_value_, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
			}
		}
		else {
			innovation_sibling_shift_up_ = true;
		}
		// Drones - Innovation.1.b
		if (player[1].cityHall.drones.upgradeAvailableToUnlock) && (!player[1].cityHall.drones.upgradeBeingUnlocked) {
			if innovation_sibling_shift_up_ {
				with obj_gui {
					draw_sprite_ext(spr_square_button, 0, innovation_row_x_value_, first_row_y_value_, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
				}
			}
			else {
				with obj_gui {
					draw_sprite_ext(spr_square_button, 0, innovation_row_x_value_, second_row_y_value_, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
				}
			}
		}
		// 
	}
	else if player[1].age == 2 {
		
	}
	else if player[1].age == 3 {
		
	}
}