if objectSelected && objectOnScreen {
	draw_sprite_ext(spr_selected, 0, x, y, 1, 1, 0, c_white, 0.75);
}
draw_text(x + 16, y + 16, obj_camera_and_gui.numberOfObjectsSelected);
//draw_text(x + 16, y - 16, string(x) + ", " + string(y));
draw_self();

if path_exists(myPath) {
	draw_path(myPath, x, y, true);
}


