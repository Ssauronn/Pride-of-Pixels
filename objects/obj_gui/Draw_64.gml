///@description Draw UI Elements on Screen

#region Toolbar
// Draw the name of the object selected, if one exists
draw_text_transformed(toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 1), toolbarTopY - (toolbarButtonSpacing * 0.5) - (string_height("Building") * 3), "Building", 3, 3, 0);
// Draw the toolbar
draw_sprite_ext(spr_toolbar_background, 0, universalGUI.background.x, universalGUI.background.y, universalGUI.background.xScaling, universalGUI.background.yScaling, 0, c_white, 1);
// Resource Icons - Always Present
draw_sprite_ext(spr_ruby_icon, 0, universalGUI.rubyIcon.x, universalGUI.rubyIcon.y, universalGUI.rubyIcon.xScaling, universalGUI.rubyIcon.yScaling, 0, c_white, 1);
draw_sprite_ext(spr_gold_icon, 0, universalGUI.goldIcon.x, universalGUI.goldIcon.y, universalGUI.goldIcon.xScaling, universalGUI.goldIcon.yScaling, 0, c_white, 1);
draw_sprite_ext(spr_wood_icon, 0, universalGUI.woodIcon.x, universalGUI.woodIcon.y, universalGUI.woodIcon.xScaling, universalGUI.woodIcon.yScaling, 0, c_white, 1);
draw_sprite_ext(spr_food_icon, 0, universalGUI.foodIcon.x, universalGUI.foodIcon.y, universalGUI.foodIcon.xScaling, universalGUI.foodIcon.xScaling, 0, c_white, 1);
draw_sprite_ext(spr_worker_front_idle, 0, universalGUI.popIcon.x, universalGUI.popIcon.y, universalGUI.popIcon.xScaling, universalGUI.popIcon.yScaling, 0, c_white, 1);
// Resource Text - Always Present
draw_text_transformed(universalGUI.rubyAmount.x, universalGUI.rubyAmount.y - 1, string(player[1].rubies), universalGUI.rubyAmount.xScaling, universalGUI.rubyAmount.yScaling, 0);
draw_text_transformed(universalGUI.goldAmount.x, universalGUI.goldAmount.y - 1, string(player[1].gold), universalGUI.goldAmount.xScaling, universalGUI.goldAmount.yScaling, 0);
draw_text_transformed(universalGUI.woodAmount.x, universalGUI.woodAmount.y - 1, string(player[1].wood), universalGUI.woodAmount.xScaling, universalGUI.woodAmount.yScaling, 0);
draw_text_transformed(universalGUI.foodAmount.x, universalGUI.foodAmount.y - 1, string(player[1].food), universalGUI.foodAmount.xScaling, universalGUI.foodAmount.yScaling, 0);
draw_text_transformed(universalGUI.popAmount.x, universalGUI.popAmount.y - 1, string(player[1].population), universalGUI.popAmount.xScaling, universalGUI.popAmount.yScaling, 0);
// Dividers
// Vertical Dividers
draw_sprite_ext(spr_divider, 0, universalGUI.leftDivider.x, universalGUI.leftDivider.y, universalGUI.leftDivider.xScaling, universalGUI.leftDivider.yScaling, 0, c_white, 1);
draw_sprite_ext(spr_divider, 0, universalGUI.rightDivider.x, universalGUI.rightDivider.y, universalGUI.rightDivider.xScaling, universalGUI.rightDivider.yScaling, 0, c_white, 1);
// Solid Dividers - Left Section
draw_sprite_ext(spr_horizontal_divider, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + toolbarButtonSpacing, toolbarHorizontalDividerY, toolbarHorizontalDividerXScale, toolbarDividerXScale, 0, c_white, 1);
draw_sprite_ext(spr_solid_divider, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + toolbarButtonSpacing, toolbarTopY + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 4) + (sprite_get_width(spr_divider) * toolbarDividerXScale), toolbarSolidDividerXScale, toolbarSolidDividerYScale, 0, c_white, 1); 
// First row of buttons
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 1), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 2), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 3), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 4), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 5), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 5) + (toolbarButtonSpacing * 6), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
// Second row of buttons
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 1), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 2), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 3), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 4), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 5), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 5) + (toolbarButtonSpacing * 6), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
// Circular buttons, multiple rows
draw_sprite_ext(spr_circle_button, 0, toolbarCircleButtonX, toolbarTopY + toolbarButtonSpacing, (toolbarButtonWidth / sprite_get_width(spr_circle_button)), (toolbarButtonWidth / sprite_get_width(spr_circle_button)), 0, c_white, 1);
draw_sprite_ext(spr_rally_point, 0, toolbarCircleButtonX + toolbarCircleButtonIconOffset, toolbarTopY + toolbarButtonSpacing + toolbarCircleButtonIconOffset, toolbarCircleButtonRallyIconScale, toolbarCircleButtonRallyIconScale, 0, c_white, 1);
draw_sprite_ext(spr_circle_button, 0, toolbarCircleButtonX, toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), (toolbarButtonWidth / sprite_get_width(spr_circle_button)), (toolbarButtonWidth / sprite_get_width(spr_circle_button)), 0, c_white, 1);
draw_sprite_ext(spr_sword, 0, toolbarCircleButtonX + toolbarCircleButtonIconOffset, toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2) + toolbarCircleButtonIconOffset, toolbarCircleButtonSwordIconScale, toolbarCircleButtonSwordIconScale, 0, c_white, 1);
// Third row of buttons
draw_sprite_ext(spr_square_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 0), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 1), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 2), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 3), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 4), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 5) + (toolbarButtonSpacing * 5), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 6) + (toolbarButtonSpacing * 6), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_gray, 1);
// Third row of buttons' information
draw_text(toolbarQueuedButtonX, toolbarQueuedTopTimerInfoY, "20 sec.");
// The text here is alligned to the right. The variable toolbarQueuedCollectiveTimerInfoX should change based on the
// length of the string currently provided, so that it's always aligned correctly to the right. 
draw_text_transformed(toolbarQueuedCollectiveTimerInfoX, toolbarQueuedTopTimerInfoY, "10 min. 59 sec.", 1, buildingGUI.leftSection.queueSection.information.individualTimer.yScaling, 0);
draw_text(toolbarQueuedCollectiveCountInfoX, toolbarQueuedTopTimerInfoY, "15 / 15");
draw_text_transformed(buildingGUI.leftSection.queueSection.information.extraQueued.x, buildingGUI.leftSection.queueSection.information.extraQueued.y, "+2", buildingGUI.leftSection.queueSection.information.extraQueued.xScaling, buildingGUI.leftSection.queueSection.information.extraQueued.yScaling, 0);
// Divider Bars for Upgrade Trees
draw_sprite_ext(spr_horizontal_solid_divider, 0, toolbarUpgradeHorizontalDividerFirstX, toolbarTopY + toolbarButtonSpacing, toolbarUpgradeHorizontalDividerXScale, toolbarUpgradeHorizontalDividerYScale, 0, c_white, 1);
draw_sprite_ext(spr_horizontal_solid_divider, 0, toolbarUpgradeHorizontalDividerFirstX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 1) + (toolbarUpgradeHorizontalDividerSpacing * 1), toolbarTopY + toolbarButtonSpacing, toolbarUpgradeHorizontalDividerXScale, toolbarUpgradeHorizontalDividerYScale, 0, c_white, 1);
draw_sprite_ext(spr_horizontal_solid_divider, 0, toolbarUpgradeHorizontalDividerFirstX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 2) + (toolbarUpgradeHorizontalDividerSpacing * 2), toolbarTopY + toolbarButtonSpacing, toolbarUpgradeHorizontalDividerXScale, toolbarUpgradeHorizontalDividerYScale, 0, c_white, 1);
draw_sprite_ext(spr_horizontal_solid_divider, 0, toolbarUpgradeHorizontalDividerFirstX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 3) + (toolbarUpgradeHorizontalDividerSpacing * 3), toolbarTopY + toolbarButtonSpacing, toolbarUpgradeHorizontalDividerXScale, toolbarUpgradeHorizontalDividerYScale, 0, c_white, 1);
// First row of upgrade buttons
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX, toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 1) + (toolbarUpgradeHorizontalDividerSpacing * 1), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 2) + (toolbarUpgradeHorizontalDividerSpacing * 2), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 3) + (toolbarUpgradeHorizontalDividerSpacing * 3), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
// Second row of upgrade buttons
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX, toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 3) + (toolbarButtonWidth * 1), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 1) + (toolbarUpgradeHorizontalDividerSpacing * 1), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 3) + (toolbarButtonWidth * 1), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 2) + (toolbarUpgradeHorizontalDividerSpacing * 2), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 3) + (toolbarButtonWidth * 1), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 3) + (toolbarUpgradeHorizontalDividerSpacing * 3), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 3) + (toolbarButtonWidth * 1), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
// Third row of upgrade buttons
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX, toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 4) + (toolbarButtonWidth * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 1) + (toolbarUpgradeHorizontalDividerSpacing * 1), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 4) + (toolbarButtonWidth * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 2) + (toolbarUpgradeHorizontalDividerSpacing * 2), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 4) + (toolbarButtonWidth * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_square_button, 0, toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 3) + (toolbarUpgradeHorizontalDividerSpacing * 3), toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 4) + (toolbarButtonWidth * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
// Upgrade tree access button
draw_sprite_ext(spr_circle_button, 0, toolbarRightX - toolbarButtonSpacing - toolbarButtonWidth, toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_upgrade_tree_icon, 0, toolbarRightX - toolbarButtonSpacing - toolbarButtonWidth + toolbarCircleButtonIconOffset, toolbarTopY + toolbarButtonSpacing + toolbarCircleButtonIconOffset, toolbarCircleButtonUpgradeTreeIconScale, toolbarCircleButtonUpgradeTreeIconScale, 0, c_white, 1);


// Set up variables used to determine what is selected.
var selected_instance_, unit_selected_, building_selected_, resource_selected_, nothing_selected_;
selected_instance_ = noone;
unit_selected_ = false;
building_selected_ = false;
resource_selected_ = false;
nothing_selected_ = false;
if ds_exists(objectsSelectedList, ds_type_list) {
	var selected_instance_ = ds_list_find_value(objectsSelectedList, 0);
	if instance_exists(selected_instance_) {
		switch selected_instance_.objectClassification {
			case "Unit":
				unit_selected_ = true;
				break;
			case "Building":
				building_selected_ = true;
				break;
			case "Resource":
				resource_selected_ = true;
				break;
		}
	}
}
else {
	nothing_selected_ = true;
}

// Draw the selected specific GUI elements depending on what is selected.
if unit_selected_ {
	
}
else if building_selected_ {
	
}
else if resource_selected_ {
	
}
else if nothing_selected_ {
	
}
#endregion


// Debugging - draw the mouse coordinates to screen
draw_text(0, 0, string(floor(mouse_x / 16) * 16) + ", " + string(floor(mouse_y / 16) * 16));


