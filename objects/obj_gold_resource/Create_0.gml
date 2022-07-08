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

mp_grid_add_rectangle(movementGrid, x, y - 16 + 1, x + sprite_get_width(sprite_index) - 1, y + 16 - 1);

// Object type, used for selection and targeting purposes
objectClassification = "Resource";
objectType = "Gold";
objectRealTeam = player[0].team;
objectVisibleTeam = objectRealTeam;
objectSelected = false;
objectOnScreen = false;
currentHP = 2000;
maxHP = 2000;

// Object weight, used to determine how much a single worker can carry
goldWeight = 5;


