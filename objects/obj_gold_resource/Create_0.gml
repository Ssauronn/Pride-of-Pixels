// Set each resource depth to the inverse of their y coordinates, to automatically
// sort the objects on screen between higher and lower on the screen.
depth = -y;

// Randomly set the sprite for the tree objects
var sprite_choice_ = irandom_range(1, 3);
switch sprite_choice_ {
	case 1: sprite_index = spr_gold_mine_1;
		break;
	case 2: sprite_index = spr_gold_mine_2;
		break;
	case 3: sprite_index = spr_gold_mine_3;
		break;
}

mp_grid_add_rectangle(movementGrid, x, y, x + sprite_get_width(sprite_index) - 1, y + sprite_get_height(sprite_index) - 1);

// Object type, used for selection and targeting purposes
objectType = "Resource";
objectTeam = "Neutral";
objectSelected = false;
objectOnScreen = false;


