// Variable used to control one time inizialization of unit specific variables
initialized = false;

// Object classification and type, used for selection and targeting purposes
objectClassification = "Unit";
// Team 1 is defaulted to player team.
objectTeam = 1;
// Possible commands align with state machine: Idle, Move, Mine, Attack
objectCurrentCommand = "Idle";
// Timer to detect nearby enemy targets
objectDetectTargetTimer = irandom_range(0, room_speed);
objectDetectTarget = objectDetectTargetTimer;
objectDetectedList = noone;


// Pathfinding
objectNeedsToMove = false;
myPath = noone;
validPathFound = true;
validLocationFound = true;
notAtTargetLocation = false;
path_set_kind(myPath, 1);
path_set_precision(myPath, 1);
targetToMoveToX = floor(x / 16) * 16;
targetToMoveToY = floor(y / 16) * 16;
originalTargetToMoveToX = floor(x / 16) * 16;
originalTargetToMoveToY = floor(y / 16) * 16;
needToStartGridSearch = true;
x_n_ = 0;
y_n_ = 0;
right_n_ = 0;
top_n_ = 0;
left_n_ = 0;
bottom_n_ = 0;
rightForbidden = false;
topForbidden = false;
leftForbidden = false;
bottomForbidden = false;
rightWallFound = false;
topWallFound = false;
leftWallFound = false;
bottomWallFound = false;
baseSquareEdgeSize = 0;
squareSizeIncreaseCount = 0;
squareIteration = 0;
squareTrueIteration = 0;
tempCheckX = -1;
tempCheckY = -1;
amountOfTimesShifted = 0;
groupRowWidth = 0;
specificLocationNeedsToBeChecked = false;
specificLocationToBeCheckedX = -1;
specificLocationToBeCheckedY = -1;
movementSpeed = 2;
searchHasJustBegun = true;
totalTimesSearched = 0;
closestSearchPointToObjectX = -1;
closestSearchPointToObjectY = -1;
closestPointsToObjectsHaveBeenSet = false;
groupDirectionToMoveIn = 0;
groupDirectionToMoveInAdjusted = 0;



// Add self to the location grid if it hasn't been added yet
if ds_exists(unitGridLocation, ds_type_grid) {
	if !ds_grid_value_exists(unitGridLocation, 0, 0, 1, ds_grid_height(unitGridLocation) - 1, self.id) {
		ds_grid_resize(unitGridLocation, ds_grid_width(unitGridLocation), ds_grid_height(unitGridLocation) + 1);
		ds_grid_set(unitGridLocation, 0, ds_grid_height(unitGridLocation) - 1, self.id);
		ds_grid_set(unitGridLocation, 1, ds_grid_height(unitGridLocation) - 1, x);
		ds_grid_set(unitGridLocation, 2, ds_grid_height(unitGridLocation) - 1, y);
	}
}
else {
	unitGridLocation = ds_grid_create(3, 1);
	ds_grid_set(unitGridLocation, 0, 0, self.id);
	ds_grid_set(unitGridLocation, 1, 0, x);
	ds_grid_set(unitGridLocation, 2, 0, y);
}



