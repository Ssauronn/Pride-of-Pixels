// Set each resource depth to the inverse of their y coordinates, to automatically
// sort the objects on screen between higher and lower on the screen.
depth = -y;

// Randomly set the sprite for the tree objects
var sprite_choice_ = irandom_range(1, 3);
switch sprite_choice_ {
	case 1: sprite_index = spr_tree_1;
		break;
	case 2: sprite_index = spr_tree_2;
		break;
	case 3: sprite_index = spr_tree_3;
		break;
}

mp_grid_add_cell(movementGrid, floor(x / 16), floor(y / 16));

// Object type, used for selection and targeting purposes
objectClassification = "Resource";
objectType = "Wood";
objectRealTeam = "Neutral";
objectVisibleTeam = objectRealTeam;
objectSelected = false;
objectOnScreen = false;
currentHP = 200;
maxHP = 200;


