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

// Toolbar button sizes and placements
toolbarCommandButtonSectionWidth = toolbarMidDividerX - toolbarLeftDividerX;
// This corresponds with toolbarButtonSpacing. Depending on that division number, the division number
// below should be set to at least double the toolbarButtonSpacing division number plus two. That means
// that the width of each button would allow for the correct amount of buttons, plus two extra, to fit
// along both the upper and lower halves of the toolbar combined.
toolbarButtonWidth = toolbarHeight / 6;
// Allows for 2 buttons in the upper half and 2 buttons in the lower half to be evenly spaced. Change
// number at the end to adjust how many buttons will fit in each upper and lower half.
toolbarButtonSpacing = ((toolbarHeight / 2) - (toolbarButtonWidth * 2)) / 2;
toolbarButtonScale = toolbarButtonWidth / sprite_get_width(spr_square_button);

toolbarHorizontalDividerXScale = (toolbarCommandButtonSectionWidth - (sprite_get_width(spr_divider) * toolbarDividerXScale) - (toolbarButtonSpacing * 2)) / sprite_get_height(spr_divider);
toolbarHorizontalDividerY = toolbarTopY + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 3);
toolbarSolidDividerYScale = (toolbarHeight - (toolbarButtonWidth * 2) - (toolbarButtonSpacing * 5) - (sprite_get_width(spr_divider) * toolbarDividerXScale)) / sprite_get_height(spr_solid_divider);
toolbarSolidDividerXScale = (sprite_get_width(spr_divider) * toolbarDividerXScale) / sprite_get_width(spr_solid_divider) / 2;

toolbarCircleButtonX = toolbarMidDividerX - toolbarButtonSpacing - toolbarButtonWidth;
toolbarCircleButtonIconOffset = toolbarButtonWidth * 0.2;
// This value is equal to one minus double the above value's multiplier. That's because the icon will be centered mid,
// and so the icon needs to be cut smaller on both sides, not just one.
toolbarCircleButtonRallyIconScale = (toolbarButtonWidth / sprite_get_width(spr_rally_point)) * 0.6;
toolbarCircleButtonSwordIconScale = (toolbarButtonWidth / sprite_get_width(spr_sword)) * 0.6;

toolbarQueuedButtonX = toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (sprite_get_width(spr_solid_divider) * toolbarSolidDividerXScale) + (toolbarButtonSpacing * 2);
toolbarQueuedButtonY = toolbarBottomY - (((toolbarBottomY - (toolbarHorizontalDividerY + (sprite_get_width(spr_divider) * toolbarDividerXScale))) / 2) + (toolbarButtonWidth / 2));
toolbarQueuedTopTimerInfoY = (toolbarQueuedButtonY - ((toolbarQueuedButtonY - (toolbarHorizontalDividerY + (sprite_get_width(spr_divider) * toolbarDividerXScale))) / 2)) - (string_height("y") / 2);
toolbarQueuedCollectiveTimerInfoX = toolbarMidDividerX - toolbarButtonSpacing - string_width("10 min. 59 sec.");
toolbarQueuedCollectiveCountInfoX = toolbarMidDividerX - ((toolbarCommandButtonSectionWidth - (sprite_get_width(spr_divider) * toolbarDividerXScale)) / 2) - (string_width("15 / 15") / 2);

// Divide by 8 because I want to fit 5 bars in this section, plus spaces between equal to half the bar length, which is 6 extra half bars, equaling to 5 + 3.
toolbarUpgradeHorizontalDividerXScale = ((toolbarCommandButtonSectionWidth + (sprite_get_width(spr_divider) * toolbarDividerXScale)) / 8) / sprite_get_width(spr_horizontal_solid_divider);
toolbarUpgradeHorizontalDividerYScale = (sprite_get_width(spr_solid_divider) * toolbarSolidDividerXScale) / sprite_get_height(spr_horizontal_solid_divider);
toolbarUpgradeHorizontalDividerSpacing = (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale) / 2;
toolbarUpgradeButtonXOffsetFromDividerX = ((sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale) - toolbarButtonWidth) / 2;
#endregion
#endregion


