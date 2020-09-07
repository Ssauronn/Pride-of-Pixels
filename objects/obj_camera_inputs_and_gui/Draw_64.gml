// Draw the toolbar
draw_sprite_ext(spr_toolbar_background, 0, view_get_xport(view_camera[0]), (view_get_yport(view_camera[0]) + view_get_hport(view_camera[0])) - (view_get_hport(view_camera[0]) / 7), view_get_wport(view_hport[0]), toolbarHeight, 0, c_white, 1);

draw_text(0, 0, string(floor(mouse_x / 16) * 16) + ", " + string(floor(mouse_y / 16) * 16));
