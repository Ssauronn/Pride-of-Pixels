// Stop certain sections of code if not on screen
if point_in_rectangle(x, y, view_get_xport(view_camera[0]), view_get_yport(view_camera[0]), view_get_xport(view_camera[0]) + view_get_wport(view_camera[0]), view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) {
	objectOnScreen = true;
}
else {
	objectOnScreen = false;
}

// Set sprite index and sprite frame
sprite_index = currentSprite;
currentImageIndex += currentImageIndexSpeed;
if currentImageIndex > (sprite_get_number(sprite_index) - 1) {
	currentImageIndex = 0;
}
image_index = currentImageIndex;

// Manage targets
if ds_exists(objectTargetList, ds_type_list) {
	if instance_exists(ds_list_find_value(objectTargetList, 0)) {
		objectTarget = ds_list_find_value(objectTargetList, 0);
		objectTargetType = objectTarget.objectType;
		objectTargetTeam = objectTarget.objectTeam;
	}
	else if ds_list_size(objectTargetList) > 1 {
		while (ds_list_size(objectTargetList) > 1) && (!instance_exists(ds_list_find_value(objectTargetList, 0))) {
			ds_list_delete(objectTargetList, 0);
		}
		if instance_exists(ds_list_find_value(objectTargetList, 0)) {
			objectTarget = ds_list_find_value(objectTargetList, 0);
			objectTargetType = objectTarget.objectType;
			objectTargetTeam = objectTarget.objectTeam;
		}
	}
	if ds_list_size(objectTargetList) <= 1 {
		ds_list_destroy(objectTargetList);
		objectTargetList = noone;
		objectTarget = noone;
		objectTargetType = noone;
		objectTargetTeam = noone;
	}
}

switch currentAction {
	case worker.idle:
		
		break;
	case worker.move:
		worker_move();
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


