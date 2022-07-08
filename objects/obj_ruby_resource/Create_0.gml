// Set each resource depth to the inverse of their y coordinates, to automatically
// sort the objects on screen between higher and lower on the screen.
depth = -y;

mask_index = spr_64_32;
mp_grid_add_instances(movementGrid, self, true);


// Object type, used for selection and targeting purposes
objectClassification = "Resource";
objectType = "Ruby";
objectRealTeam = player[0].team;
objectVisibleTeam = objectRealTeam;
objectSelected = false;
objectOnScreen = false;

// Stats
currentHP = 1000;
maxHP = 1000;
regenerationPerSecond = (maxHP / room_speed) / 60; // Takes 1 minute precisely to regenerate its full HP

// Object weight, used to determine how much a single worker can carry
rubyWeight = 8;


