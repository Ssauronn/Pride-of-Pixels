// Function for setting rally point
function set_rally(x_, y_) {
	rallyPointX = x_;
	rallyPointY = y_;
}

// Variable used to attack friendly targets if the player or AI commands it
forceAttack = false;

// Variable used to control one time inizialization of unit specific variables
initialized = false;

// Object classification and type, used for selection and targeting purposes
objectClassification = "Building";
objectType = ""
objectSelected = false;
objectOnScreen = false;
objectTarget = noone;
forceAttack = false;
rallyPointX = (x div 16) * 16;
rallyPointY = (y div 16) * 16;

// Team 1 is defaulted to player team.
objectRealTeam = 1;
objectVisibleTeam = objectRealTeam;
// Timer to detect nearby enemy targets
objectDetectTarget = irandom_range(0, room_speed);
objectDetectedList = noone;

// Sprite Info
currentImageIndexSpeed = 8 / room_speed;
currentImageIndex = 0;



// Debugging variables
spawnUnit = 60;


