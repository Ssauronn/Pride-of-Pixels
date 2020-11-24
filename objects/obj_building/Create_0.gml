// Variable used to control one time inizialization of unit specific variables
initialized = false;

// Object classification and type, used for selection and targeting purposes
objectClassification = "Building";
objectSelected = false;
objectOnScreen = false;
rallyPointX = -1;
rallyPointY = -1;
// Team 1 is defaulted to player team.
objectTeam = 1;
// Timer to detect nearby enemy targets
objectDetectTargetTimer = irandom_range(0, room_speed);
objectDetectTarget = objectDetectTargetTimer;
objectDetectedList = noone;


