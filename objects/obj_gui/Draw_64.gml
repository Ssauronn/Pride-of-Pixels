///@description Draw UI Elements on Screen

#region Toolbar
// Draw the toolbar
draw_sprite_ext(spr_toolbar_background, 0, toolbarLeftX, toolbarTopY, toolbarWidth, toolbarHeight, 0, c_white, 1);
// Resource Icons - Always Present
draw_sprite(spr_ruby_icon, 0, toolbarResourceIconX, toolbarTopY + ((toolbarHeight * 0.2) * 1) - (toolbarHeight * 0.07) - string_height("y"));
draw_sprite(spr_gold_icon, 0, toolbarResourceIconX, toolbarTopY + ((toolbarHeight * 0.2) * 2) - (toolbarHeight * 0.07) - string_height("y"));
draw_sprite(spr_wood_icon, 0, toolbarResourceIconX, toolbarTopY + ((toolbarHeight * 0.2) * 3) - (toolbarHeight * 0.07) - string_height("y"));
draw_sprite(spr_food_icon, 0, toolbarResourceIconX, toolbarTopY + ((toolbarHeight * 0.2) * 4) - (toolbarHeight * 0.07) - string_height("y"));
draw_sprite_ext(spr_worker_front_idle, 0, toolbarResourceIconX, toolbarTopY + ((toolbarHeight * 0.2) * 5) - (toolbarHeight * 0.07) - string_height("y"), 2, 2, 0, c_white, 1);
// Resource Text - Always Present
draw_text_transformed(toolbarResourceTextX, toolbarTopY + ((toolbarHeight * 0.2) * 1) - (toolbarHeight * 0.07) - string_height("y") - 1, string(player[1].rubies), 2, 2, 0);
draw_text_transformed(toolbarResourceTextX, toolbarTopY + ((toolbarHeight * 0.2) * 2) - (toolbarHeight * 0.07) - string_height("y") - 1, string(player[1].gold), 2, 2, 0);
draw_text_transformed(toolbarResourceTextX, toolbarTopY + ((toolbarHeight * 0.2) * 3) - (toolbarHeight * 0.07) - string_height("y") - 1, string(player[1].wood), 2, 2, 0);
draw_text_transformed(toolbarResourceTextX, toolbarTopY + ((toolbarHeight * 0.2) * 4) - (toolbarHeight * 0.07) - string_height("y") - 1, string(player[1].food), 2, 2, 0);
draw_text_transformed(toolbarResourceTextX, toolbarTopY + ((toolbarHeight * 0.2) * 5) - (toolbarHeight * 0.07) - string_height("y") - 1, string(player[1].population), 2, 2, 0);
// Dividers
// Vertical Dividers
draw_sprite_ext(spr_divider, 0, toolbarLeftDividerX, toolbarDividerY, toolbarDividerXScale, toolbarDividerYScale, 0, c_white, 1);
draw_sprite_ext(spr_divider, 0, toolbarMidDividerX, toolbarDividerY, toolbarDividerXScale, toolbarDividerYScale, 0, c_white, 1);
// Horizontal Dividers
draw_sprite_ext(spr_horizontal_divider, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + toolbarButtonSpacing, toolbarHorizontalDividerY, toolbarHorizontalDividerXScale, toolbarDividerXScale, 0, c_white, 1);
draw_sprite_ext(spr_solid_divider, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + toolbarButtonSpacing, toolbarTopY + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 4) + (sprite_get_width(spr_divider) * toolbarDividerXScale), toolbarSolidDividerXScale, toolbarSolidDividerYScale, 0, c_white, 1); 
// First row of buttons
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 1), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 2), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 3), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 4), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 5), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 5) + (toolbarButtonSpacing * 6), toolbarTopY + toolbarButtonSpacing, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
// Second row of buttons
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 1), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 2), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 3), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 4), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 5), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 5) + (toolbarButtonSpacing * 6), toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2), toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
// Third row of buttons
draw_sprite_ext(spr_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 0), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 1), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 2), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 3), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 4), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
draw_sprite_ext(spr_button, 0, toolbarQueuedButtonX + (toolbarButtonWidth * 5) + (toolbarButtonSpacing * 5), toolbarQueuedButtonY, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
// Third row of buttons' information
draw_text(toolbarQueuedButtonX, toolbarQueuedTopTimerInfoY, "20 sec.");
// The text here is alligned to the right. The variable toolbarQueuedCollectiveTimerInfoX should change based on the
// length of the string currently provided, so that it's always aligned correctly to the right. 
draw_text(toolbarQueuedCollectiveTimerInfoX, toolbarQueuedTopTimerInfoY, "10 min. 59 sec.");
draw_text(toolbarQueuedCollectiveCountInfoX, toolbarQueuedTopTimerInfoY, "15 / 15");


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


