///@description Set up Variables

#region Start Menu UX
// Initialized here first, because the measurements for everything in the below struct
// are based off of these values.
startMenuBackgroundX = viewX + (viewW * (1 / 8)) * 2;
startMenuBackgroundY = viewY + (viewH * (1 / 8)) * 2;
startMenuBackgroundWidth = (viewX + (viewW * (7 / 8)) * 2) - startMenuBackgroundX;
startMenuBackgroundHeight = (viewY + (viewH * (7 / 8)) * 2) - startMenuBackgroundY;
titleTextString = "Pride of Pixels"

startMenu = {
	active : false,
	background : {
		x : startMenuBackgroundX,
		y : startMenuBackgroundY,
		width : startMenuBackgroundWidth,
		height : startMenuBackgroundHeight,
		backgroundColor : c_white
	},
	titleText : {
		x : viewX + (viewW * (2 / 8)) * 2,
		y : startMenuBackgroundY + (startMenuBackgroundHeight * (1 / 8)),
		// startMenu.startButton.width / width of title text
		xMultiplier : (((viewX + (viewW * (4 / 8)) * 2) / sprite_get_width(spr_start_menu_button_edge) * sprite_get_width(spr_start_menu_button_edge)) / string_width(titleTextString)),
		// startMenu.startButton.height * 2 / height of title text
		yMultiplier : (((startMenuBackgroundHeight * (1 / 8)) / sprite_get_height(spr_start_menu_button_edge) * sprite_get_height(spr_start_menu_button_edge)) * 2) / string_height("Y")
	},
	startButton : {
		x : viewX + (viewW * (2 / 8)) * 2,
		y : startMenuBackgroundY + (startMenuBackgroundHeight * (4 / 8)),
		xMultiplier : (viewX + (viewW * (4 / 8)) * 2) / sprite_get_width(spr_start_menu_button_edge),
		yMultiplier : (startMenuBackgroundHeight * (1 / 8)) / sprite_get_height(spr_start_menu_button_edge),
		// The width of the background is 6/8 of the total viewport width (viewW), so the width
		// of the buttons themselves should be 4/8 of that same value (viewW).
		width : (viewX + (viewW * (4 / 8)) * 2) / sprite_get_width(spr_start_menu_button_edge) * sprite_get_width(spr_start_menu_button_edge),
		// Base the heigh simply off the a fraction of the height of the background.
		height : (startMenuBackgroundHeight * (1 / 8)) / sprite_get_height(spr_start_menu_button_edge) * sprite_get_height(spr_start_menu_button_edge),
		backgroundColor : c_white,
		textColor : c_black
	},
	exitButton : {
		x : viewX + (viewW * (2 / 8)) * 2,
		y : startMenuBackgroundY + (startMenuBackgroundHeight * (6 / 8)),
		xMultiplier : (viewX + (viewW * (4 / 8)) * 2) / sprite_get_width(spr_start_menu_button_edge),
		yMultiplier : (startMenuBackgroundHeight * (1 / 8)) / sprite_get_height(spr_start_menu_button_edge),
		width : (viewX + (viewW * (4 / 8)) * 2) / sprite_get_width(spr_start_menu_button_edge) * sprite_get_width(spr_start_menu_button_edge),
		height : (startMenuBackgroundHeight * (1 / 8)) / sprite_get_height(spr_start_menu_button_edge) * sprite_get_height(spr_start_menu_button_edge),
		backgroundColor : c_white,
		textColor : c_black
	}
}
#endregion

#region In Game Menu UX
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
// The left side of the vertical divider starts at the point where the maximum value for a player's resource count would end, plus
// an equal amount of empty space at the end of that equal to the amount of empty space to the left of the resource icon in the same section.
toolbarLeftDividerX = toolbarResourceTextX + (string_width("9,999,999") * 2) + (toolbarWidth * 0.02);
toolbarDividerY = toolbarTopY;
toolbarDividerXScale = 0.01 * (toolbarWidth / sprite_get_width(spr_divider));
toolbarDividerYScale = 1 * (toolbarHeight / sprite_get_height(spr_divider));
toolbarRightDividerX = toolbarLeftDividerX + ((toolbarWidth - ((toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale)) - toolbarLeftX)) / 2)

// Toolbar button sizes and placements
toolbarCommandButtonSectionWidth = toolbarRightDividerX - toolbarLeftDividerX;
// Toolbar buttons are (and should always be) a square, so setting just the width is needed.
// The value that toolbarHeight is divided by is setting the size of the button by how many
// buttons could fit top to bottom inside the toolbar.
toolbarButtonsToFitTopToBottom = 6;
toolbarButtonWidth = toolbarHeight / toolbarButtonsToFitTopToBottom;
// The spacing value is set by taking the amount of buttons I want to fit top to bottom,
// adding 1 to that (since I want space between the top and bottom, not just above all
// buttons or below all buttons), and then dividing that into the height of the toolbar. 
// I then finally multiply that by a multiplier, to reduce the size of the spacers down
// to a small percent of the total space of the bar.
toolbarButtonSpacing = (toolbarHeight / (toolbarButtonsToFitTopToBottom + 1)) * 0.2;
toolbarButtonScale = toolbarButtonWidth / sprite_get_width(spr_square_button);

toolbarHorizontalDividerXScale = (toolbarCommandButtonSectionWidth - (sprite_get_width(spr_divider) * toolbarDividerXScale) - (toolbarButtonSpacing * 2)) / sprite_get_height(spr_divider);
toolbarHorizontalDividerY = toolbarTopY + (toolbarHeight / 2);
toolbarSolidDividerYScale = (toolbarHeight - (toolbarButtonWidth * 2) - (toolbarButtonSpacing * 5) - (sprite_get_width(spr_divider) * toolbarDividerXScale)) / sprite_get_height(spr_solid_divider);
toolbarSolidDividerXScale = (sprite_get_width(spr_divider) * toolbarDividerXScale) / sprite_get_width(spr_solid_divider) / 2;

toolbarCircleButtonX = toolbarRightDividerX - toolbarButtonSpacing - toolbarButtonWidth;
toolbarCircleButtonIconOffset = toolbarButtonWidth * 0.2;
// This value is equal to one minus double the above value's multiplier. That's because the icon will be centered mid,
// and so the icon needs to be cut smaller on both sides, not just one.
toolbarCircleButtonRallyIconScale = (toolbarButtonWidth / sprite_get_width(spr_rally_point)) * 0.6;
toolbarCircleButtonSwordIconScale = (toolbarButtonWidth / sprite_get_width(spr_sword)) * 0.6;
toolbarCircleButtonUpgradeTreeIconScale = (toolbarButtonWidth / sprite_get_width(spr_upgrade_tree_icon)) * 0.6;

toolbarQueuedButtonX = toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (sprite_get_width(spr_solid_divider) * toolbarSolidDividerXScale) + (toolbarButtonSpacing * 2);
toolbarQueuedButtonY = toolbarBottomY - (((toolbarBottomY - (toolbarHorizontalDividerY + (sprite_get_width(spr_divider) * toolbarDividerXScale))) / 2) + (toolbarButtonWidth / 2));
toolbarQueuedTopTimerInfoY = (toolbarQueuedButtonY - ((toolbarQueuedButtonY - (toolbarHorizontalDividerY + (sprite_get_width(spr_divider) * toolbarDividerXScale))) / 2)) - (string_height("y") / 2);
toolbarQueuedCollectiveTimerInfoX = toolbarRightDividerX - toolbarButtonSpacing - string_width("10 min. 59 sec.");
toolbarQueuedCollectiveCountInfoX = toolbarRightDividerX - ((toolbarCommandButtonSectionWidth - (sprite_get_width(spr_divider) * toolbarDividerXScale)) / 2) - (string_width("15 / 15") / 2);

// Divide by 8 because I want to fit 5 bars in this section, plus spaces between equal to half the bar length, which is 6 extra half bars, equaling to 5 + 3.
toolbarUpgradeHorizontalDividerXScale = ((toolbarCommandButtonSectionWidth + (sprite_get_width(spr_divider) * toolbarDividerXScale)) / 8) / sprite_get_width(spr_horizontal_solid_divider);
toolbarUpgradeHorizontalDividerYScale = (sprite_get_width(spr_solid_divider) * toolbarSolidDividerXScale) / sprite_get_height(spr_horizontal_solid_divider);
toolbarUpgradeHorizontalDividerSpacing = (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale) / 2;
toolbarUpgradeButtonXOffsetFromDividerX = ((sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale) - toolbarButtonWidth) / 2;
toolbarUpgradeHorizontalDividerFirstX = toolbarRightDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + toolbarUpgradeHorizontalDividerSpacing;

#region GUI Information in Structs
universalGUI = {
	background : {
		x : toolbarLeftX,
		y : toolbarTopY,
		xScaling : toolbarWidth / sprite_get_width(spr_toolbar_background),
		yScaling : toolbarHeight / sprite_get_height(spr_toolbar_background)
	},
	rubyIcon : {
		x : toolbarResourceIconX,
		// I add (toolbarButtonWidth * 0.2 * 1-5) because the size of each
		y : toolbarTopY + ((toolbarHeight / 5) * 0) + toolbarButtonSpacing,
		xScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, (toolbarButtonWidth / sprite_get_width(spr_ruby_icon))),
		yScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, (toolbarButtonWidth / sprite_get_height(spr_ruby_icon)))
	},
	rubyAmount : {
		x : toolbarResourceTextX,
		y : toolbarTopY + ((toolbarHeight / 5) * 0) + toolbarButtonSpacing,
		xScaling : toolbarButtonWidth / string_height("y"),
		yScaling : toolbarButtonWidth / string_height("y")
	},
	goldIcon : {
		x : toolbarResourceIconX,
		y : toolbarTopY + ((toolbarHeight / 5) * 1) + toolbarButtonSpacing,
		xScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, (toolbarButtonWidth / sprite_get_width(spr_gold_icon))),
		yScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, (toolbarButtonWidth / sprite_get_height(spr_gold_icon)))
	},
	goldAmount : {
		x : toolbarResourceTextX,
		y : toolbarTopY + ((toolbarHeight / 5) * 1) + toolbarButtonSpacing,
		xScaling : toolbarButtonWidth / string_height("y"),
		yScaling : toolbarButtonWidth / string_height("y")
	},
	woodIcon : {
		x : toolbarResourceIconX,
		y : toolbarTopY + ((toolbarHeight / 5) * 2) + toolbarButtonSpacing,
		xScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, (toolbarButtonWidth / sprite_get_width(spr_wood_icon))),
		yScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, (toolbarButtonWidth / sprite_get_height(spr_wood_icon)))
	},
	woodAmount : {
		x : toolbarResourceTextX,
		y : toolbarTopY + ((toolbarHeight / 5) * 2) + toolbarButtonSpacing,
		xScaling : toolbarButtonWidth / string_height("y"),
		yScaling : toolbarButtonWidth / string_height("y")
	},
	foodIcon : {
		x : toolbarResourceIconX,
		y : toolbarTopY + ((toolbarHeight / 5) * 3) + toolbarButtonSpacing,
		xScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, (toolbarButtonWidth / sprite_get_width(spr_food_icon))),
		yScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, (toolbarButtonWidth / sprite_get_height(spr_food_icon)))
	},
	foodAmount : {
		x : toolbarResourceTextX,
		y : toolbarTopY + ((toolbarHeight / 5) * 3) + toolbarButtonSpacing,
		xScaling : toolbarButtonWidth / string_height("y"),
		yScaling : toolbarButtonWidth / string_height("y")
	},
	popIcon : {
		x : toolbarResourceIconX,
		y : toolbarTopY + ((toolbarHeight / 5) * 4) + toolbarButtonSpacing,
		// Different scaling than the rest because the Population Icon uses the sprite of the worker icon, which isn't normalized
		// like the rest of the icon sprites.
		xScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, ((sprite_get_width(spr_food_icon) * (toolbarButtonWidth / sprite_get_width(spr_food_icon))) / sprite_get_width(spr_worker_front_idle) * (sprite_get_width(spr_food_icon) / sprite_get_width(spr_worker_front_idle)))),
		yScaling : min((toolbarLeftDividerX - toolbarLeftX) * 0.8, ((sprite_get_height(spr_food_icon) * (toolbarButtonWidth / sprite_get_height(spr_food_icon))) / sprite_get_height(spr_worker_front_idle) * (sprite_get_height(spr_food_icon) / sprite_get_height(spr_worker_front_idle))))
	},
	popAmount : {
		x : toolbarResourceTextX,
		y : toolbarTopY + ((toolbarHeight / 5) * 4) + toolbarButtonSpacing,
		xScaling : toolbarButtonWidth / string_height("y"),
		yScaling : toolbarButtonWidth / string_height("y")
	},
	leftDivider : {
		x : toolbarLeftDividerX,
		y : toolbarDividerY,
		xScaling : toolbarDividerXScale,
		yScaling : toolbarDividerYScale
	},
	rightDivider : {
		x : toolbarRightDividerX,
		y : toolbarDividerY,
		xScaling : toolbarDividerXScale,
		yScaling : toolbarDividerYScale
	}
};
buildingGUI = {
	name : {
		x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + toolbarButtonSpacing,
		y :  toolbarTopY - (toolbarButtonSpacing * 0.5) - (string_height("Building") * 3),
		xScaling : 3,
		yScaling : 3
	},
	leftSection : {
		topRow : {
			rallyButton : {
				x : toolbarCircleButtonX,
				y : toolbarTopY + toolbarButtonSpacing,
				xScaling : toolbarButtonWidth / sprite_get_width(spr_circle_button),
				yScaling : toolbarButtonWidth / sprite_get_width(spr_circle_button)
			},
			rallyButtonIcon : {
				x : toolbarCircleButtonX + toolbarCircleButtonIconOffset,
				y : toolbarTopY + toolbarButtonSpacing + toolbarCircleButtonIconOffset,
				xScaling : toolbarCircleButtonRallyIconScale,
				yScaling : toolbarCircleButtonRallyIconScale
			},
			first : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 1),
				y : toolbarTopY + toolbarButtonSpacing,
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			second : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 2),
				y : toolbarTopY + toolbarButtonSpacing,
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			third : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 3),
				y : toolbarTopY + toolbarButtonSpacing,
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			fourth : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 4),
				y : toolbarTopY + toolbarButtonSpacing,
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			fifth : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 5),
				y : toolbarTopY + toolbarButtonSpacing,
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			}
		},
		bottomRow : {
			attackButton : {
				x : toolbarCircleButtonX,
				y : toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2),
				xScaling : toolbarButtonWidth / sprite_get_width(spr_circle_button),
				yScaling : toolbarButtonWidth / sprite_get_width(spr_circle_button)
			},
			attackButtonIcon : {
				x : toolbarCircleButtonX + toolbarCircleButtonIconOffset,
				y : toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2) + toolbarCircleButtonIconOffset,
				xScaling : toolbarCircleButtonSwordIconScale,
				yScaling : toolbarCircleButtonSwordIconScale
			},
			first : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 1),
				y : toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2),
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			second : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 2),
				y : toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2),
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			third : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 3),
				y : toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2),
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			fourth : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 4),
				y : toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2),
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			fifth : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 5),
				y : toolbarTopY + toolbarButtonWidth + (toolbarButtonSpacing * 2),
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			}
		},
		dividers : {
			horizontal : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_divider) * toolbarDividerXScale) + toolbarButtonSpacing,
				y : toolbarHorizontalDividerY,
				xScaling : toolbarHorizontalDividerXScale,
				yScaling : toolbarDividerXScale
			},
			vertical : {
				x : toolbarLeftDividerX + (sprite_get_width(spr_solid_divider) * toolbarDividerXScale) + toolbarButtonSpacing,
				y : toolbarHorizontalDividerY + (toolbarUpgradeHorizontalDividerYScale * sprite_get_height(spr_divider)) + toolbarButtonSpacing,
				xScaling : toolbarSolidDividerXScale,
				yScaling : toolbarSolidDividerYScale
			}
		},
		queueSection : {
			information : {
				individualTimer : {
					x : toolbarQueuedButtonX,
					y : toolbarQueuedTopTimerInfoY,
					xScaling : 1,
					yScaling : (toolbarQueuedButtonY - (toolbarHorizontalDividerY + (sprite_get_height(spr_horizontal_divider) * toolbarDividerXScale))) / string_height("Building") * 0.86
				},
				collectiveTimer : {
					x : toolbarQueuedCollectiveTimerInfoX,
					y : toolbarQueuedTopTimerInfoY,
					xScaling : 1,
					yScaling : (toolbarQueuedButtonY - (toolbarHorizontalDividerY + (sprite_get_height(spr_horizontal_divider) * toolbarDividerXScale))) / string_height("Building") * 0.86
				},
				queueCount : {
					x : toolbarQueuedCollectiveCountInfoX,
					y : toolbarQueuedTopTimerInfoY,
					xScaling : 1,
					yScaling : (toolbarQueuedButtonY - (toolbarHorizontalDividerY + (sprite_get_height(spr_horizontal_divider) * toolbarDividerXScale))) / string_height("Building") * 0.86
				},
				extraQueued : {
					x : toolbarQueuedButtonX + (toolbarButtonWidth * 6) + (toolbarButtonSpacing * 6) + ((toolbarButtonWidth - (string_height("Building") * (toolbarButtonWidth * 0.9) / string_height("Building"))) / 2),
					y : toolbarQueuedButtonY + ((toolbarButtonWidth - (string_height("Building") * (toolbarButtonWidth * 0.9) / string_height("Building"))) / 2),
					xScaling : (toolbarButtonWidth * 0.9) / string_height("Building"),
					yScaling : (toolbarButtonWidth * 0.9) / string_height("Building")
				}
			},
			queueButtons : {
				first : {
					x : toolbarQueuedButtonX + (toolbarButtonWidth * 0) + (toolbarButtonSpacing * 0),
					y : toolbarQueuedButtonY,
					xScaling : toolbarButtonScale,
					yScaling : toolbarButtonScale
				},
				second : {
					x : toolbarQueuedButtonX + (toolbarButtonWidth * 1) + (toolbarButtonSpacing * 1),
					y : toolbarQueuedButtonY,
					xScaling : toolbarButtonScale,
					yScaling : toolbarButtonScale
				},
				third : {
					x : toolbarQueuedButtonX + (toolbarButtonWidth * 2) + (toolbarButtonSpacing * 2),
					y : toolbarQueuedButtonY,
					xScaling : toolbarButtonScale,
					yScaling : toolbarButtonScale
				},
				fourth : {
					x : toolbarQueuedButtonX + (toolbarButtonWidth * 3) + (toolbarButtonSpacing * 3),
					y : toolbarQueuedButtonY,
					xScaling : toolbarButtonScale,
					yScaling : toolbarButtonScale
				},
				fifth : {
					x : toolbarQueuedButtonX + (toolbarButtonWidth * 4) + (toolbarButtonSpacing * 4),
					y : toolbarQueuedButtonY,
					xScaling : toolbarButtonScale,
					yScaling : toolbarButtonScale
				}
			}
		}
	},
	rightSection : {
		dividers : {
			horizontal : {
				first : {
					x : toolbarUpgradeHorizontalDividerFirstX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 0) + (toolbarUpgradeHorizontalDividerSpacing * 0),
					y : toolbarTopY + toolbarButtonSpacing,
					xScaling : toolbarUpgradeHorizontalDividerXScale,
					yScaling : toolbarUpgradeHorizontalDividerYScale
				},
				second : {
					x : toolbarUpgradeHorizontalDividerFirstX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 1) + (toolbarUpgradeHorizontalDividerSpacing * 1),
					y : toolbarTopY + toolbarButtonSpacing,
					xScaling : toolbarUpgradeHorizontalDividerXScale,
					yScaling : toolbarUpgradeHorizontalDividerYScale
				},
				third : {
					x : toolbarUpgradeHorizontalDividerFirstX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 2) + (toolbarUpgradeHorizontalDividerSpacing * 2),
					y : toolbarTopY + toolbarButtonSpacing,
					xScaling : toolbarUpgradeHorizontalDividerXScale,
					yScaling : toolbarUpgradeHorizontalDividerYScale
				},
				fourth : {
					x : toolbarUpgradeHorizontalDividerFirstX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 3) + (toolbarUpgradeHorizontalDividerSpacing * 3),
					y : toolbarTopY + toolbarButtonSpacing,
					xScaling : toolbarUpgradeHorizontalDividerXScale,
					yScaling : toolbarUpgradeHorizontalDividerYScale
				}
			}
		},
		upgradeButtons : {
			upgradeTreeBackground : {
				x : toolbarRightX - toolbarButtonSpacing - toolbarButtonWidth,
				y : toolbarTopY + toolbarButtonSpacing,
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			upgradeTreeIcon : {
				x : toolbarRightX - toolbarButtonSpacing - toolbarButtonWidth + toolbarCircleButtonIconOffset,
				y : toolbarTopY + toolbarButtonSpacing + toolbarCircleButtonIconOffset,
				xScaling : toolbarCircleButtonUpgradeTreeIconScale,
				yScaling : toolbarCircleButtonUpgradeTreeIconScale
			},
			firstRow : {
				x : toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 0) + (toolbarUpgradeHorizontalDividerSpacing * 0),
				y : toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 2) + (toolbarButtonWidth * 0),
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			secondRow : {
				x : toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 1) + (toolbarUpgradeHorizontalDividerSpacing * 1),
				y : toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 3) + (toolbarButtonWidth * 1),
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			},
			thirdRow : {
				x : toolbarUpgradeHorizontalDividerFirstX + toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerXScale * 2) + (toolbarUpgradeHorizontalDividerSpacing * 2),
				y : toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * toolbarUpgradeHorizontalDividerYScale) + (toolbarButtonSpacing * 4) + (toolbarButtonWidth * 2),
				xScaling : toolbarButtonScale,
				yScaling : toolbarButtonScale
			}
		}
	}
};
#endregion
#endregion
#endregion


