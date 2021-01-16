///@description Set up Variables

#region Menu UX
#region Toolbar
toolbarPercentOfEmptyScreenOnTop = 80;
toolbarTopY = (viewY + (viewH * (toolbarPercentOfEmptyScreenOnTop / 100))) * 2;
toolbarBottomY = (viewY + viewH) * 2;
toolbarHeight = toolbarBottomY - toolbarTopY;
toolbarPercentOfEmptyScreenOnEitherSide = 15;
toolbarLeftX = (viewX + (viewW * (toolbarPercentOfEmptyScreenOnEitherSide / 100))) * 2;
toolbarRightX = (viewX + viewW - (viewW * (toolbarPercentOfEmptyScreenOnEitherSide / 100))) * 2;
toolbarWidth = toolbarRightX - toolbarLeftX;
#endregion
#endregion


