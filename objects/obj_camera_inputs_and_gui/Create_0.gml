// Self evident
window_set_fullscreen(true);


cameraMovementSpeed = 12;

#region Mouse UI
mouseBufferDistanceToEdgeOfScreen = 3;

mbLeftPressedXCoordinate = -1;
mbLeftPressedYCoordinate = -1;
mouseHoverIconFrame = 0;
mouseHoverIconFrameCountdownStart = 30;
mouseHoverIconFrameCountdown = 30;
mouseClampedX = 0;
mouseClampedY = 0;

numberOfObjectsSelected = 0;
globalvar objectsSelectedList;
objectsSelectedList = noone;
#endregion

#region Menu UX
#region Toolbar
toolbarPercentOfEmptyScreenOnTop = 80;
toolbarTopY = (view_get_yport(view_camera[0]) + (view_get_hport(view_camera[0]) * (toolbarPercentOfEmptyScreenOnTop / 100)));
toolbarBottomY = view_get_yport(view_camera[0]) + view_get_hport(view_camera[0]);
toolbarHeight = toolbarBottomY - toolbarTopY;
toolbarPercentOfEmptyScreenOnEitherSide = 15;
toolbarLeftX = view_get_xport(view_camera[0]) + (view_get_wport(view_camera[0]) * (toolbarPercentOfEmptyScreenOnEitherSide / 100));
toolbarRightX = view_get_xport(view_camera[0]) + view_get_wport(view_camera[0]) - (view_get_wport(view_camera[0]) * (toolbarPercentOfEmptyScreenOnEitherSide / 100));
toolbarWidth = toolbarRightX - toolbarLeftX;
#endregion
#endregion


