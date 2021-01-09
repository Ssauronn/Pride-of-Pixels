// Self evident
window_set_fullscreen(true);


cameraMovementSpeed = 12;

#region Mouse UI
mouseBufferDistanceToEdgeOfScreen = 7;

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
toolbarHeight = view_get_hport(view_camera[0]) / 5;
toolbarTopY = (view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) - toolbarHeight;
#endregion
#endregion


