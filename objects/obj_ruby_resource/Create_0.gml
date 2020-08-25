// Set each resource depth to the inverse of their y coordinates, to automatically
// sort the objects on screen between higher and lower on the screen.
depth = -y;

mp_grid_add_rectangle(movementGrid, x, y + sprite_get_height(sprite_index) - 16, x + (sprite_get_width(sprite_index) -1), y + (sprite_get_height(sprite_index) - 1));


// Object type, used for selection and targeting purposes
objectClassification = "Resource";
objectType = "Ruby";
objectTeam = "Neutral";
objectSelected = false;
objectOnScreen = false;


