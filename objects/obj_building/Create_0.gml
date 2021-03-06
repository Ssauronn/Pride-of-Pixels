// Function for setting rally point
function set_rally(x_, y_) {
	rallyPointX = x_;
	rallyPointY = y_;
}

// Variable used to control one time inizialization of unit specific variables
initialized = false;

// Object classification and type, used for selection and targeting purposes
objectClassification = "Building";
objectSelected = false;
objectOnScreen = false;
objectTarget = noone;
rallyPointX = floor((x / 16) * 16);
rallyPointY = floor((y / 16) * 16);

// Team 1 is defaulted to player team.
objectRealTeam = 1;
objectVisibleTeam = objectRealTeam;
// Timer to detect nearby enemy targets
objectDetectTarget = irandom_range(0, room_speed);
objectDetectedList = noone;

spawnUnit = 60;


