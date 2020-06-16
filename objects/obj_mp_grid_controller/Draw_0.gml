// Draw grid - commented out because not necessary except for debugging purposes
if ds_exists(unitGridLocation, ds_type_grid) {
	draw_text_ext_transformed(400, 400, string(ds_grid_height(unitGridLocation)), 10, 10, 2, 2, 0);
}
/*
draw_set_alpha(0.5);
mp_grid_draw(movementGrid);
draw_set_alpha(1);



