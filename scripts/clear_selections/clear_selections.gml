var i;
for (i = 0; i < argument_count; i++) {
	with argument[i] {
		if objectSelected {
			obj_camera_and_gui.numberOfObjectsSelected--;
			objectSelected = false;
		}
	}
}


