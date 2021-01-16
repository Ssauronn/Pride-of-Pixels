/// @description Set Camera Variables
camera_set_view_size(view_camera[0], viewW, viewH);

// Set up camera variables before setting the position.
camera_set_view_pos(view_camera[0], target.x - (viewW / 2), target.y - (viewH / 2));


