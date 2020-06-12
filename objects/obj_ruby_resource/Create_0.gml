// Set each resource depth to the inverse of their y coordinates, to automatically
// sort the objects on screen between higher and lower on the screen.
depth = -y;

mp_grid_add_rectangle(movementGrid, x - 33, y - 32, x + 33, y - 1);

// Object type, used for selection and targeting purposes
objectType = "Resource";
objectSelected = false;
objectOnScreen = false;


