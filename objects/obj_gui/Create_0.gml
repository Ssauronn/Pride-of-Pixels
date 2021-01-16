///@description Set up Variables

#region Menu UX
#region Toolbar Base Units
// Toolbar background
toolbarPercentOfEmptyScreenOnTop = 80;
toolbarTopY = (viewY + (viewH * (toolbarPercentOfEmptyScreenOnTop / 100))) * 2;
toolbarBottomY = (viewY + viewH) * 2;
toolbarHeight = toolbarBottomY - toolbarTopY;
toolbarPercentOfEmptyScreenOnEitherSide = 15;
toolbarLeftX = (viewX + (viewW * (toolbarPercentOfEmptyScreenOnEitherSide / 100))) * 2;
toolbarRightX = (viewX + viewW - (viewW * (toolbarPercentOfEmptyScreenOnEitherSide / 100))) * 2;
toolbarWidth = toolbarRightX - toolbarLeftX;

// Toolbar resource icons
toolbarResourceIconX = toolbarLeftX + (toolbarWidth * 0.02);
toolbarResourceTextX = toolbarLeftX + (toolbarWidth * 0.06);

// Toolbar borders and dividers
toolbarLeftDividerX = toolbarResourceTextX + (string_width("123456") * 2) + (toolbarWidth * 0.01);
toolbarDividerY = toolbarTopY;
toolbarDividerXScale = 0.01 * (toolbarWidth / sprite_get_width(spr_divider));
toolbarDividerYScale = 1 * (toolbarHeight / sprite_get_height(spr_divider));
toolbarMidDividerX = toolbarLeftDividerX + ((toolbarWidth - ((toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale)) - toolbarLeftX)) / 2)

// Toolbar button placements
toolbarCommandButtonSectionWidth = toolbarMidDividerX - toolbarLeftDividerX;

#endregion
#endregion


