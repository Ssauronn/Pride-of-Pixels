// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, view_get_xport(view_camera[0]), view_get_yport(view_camera[0]), view_get_xport(view_camera[0]) + view_get_wport(view_camera[0]), view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) {
	objectOnScreen = true;
}
else {
	objectOnScreen = false;
}

sprite_index = currentSprite;

switch currentAction {
	case worker.idle:
		
		break;
	case worker.move:
		script_execute(scr_worker_move);
		break;
	case worker.chop:
		
		break;
	case worker.farm:
		
		break;
	case worker.mine:
		
		break;
	case worker.attack:
		
		break;
}


