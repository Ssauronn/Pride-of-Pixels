// Object classification and type, used for selection and targeting purposes
objectClassification = "Unit";
objectType = "Worker";
// Possible commands align with state machine: Idle, Move, Mine, Attack
objectCurrentCommand = "Idle";
objectTakeAction = false;
// Combat variables
objectAttackSpeed = 1.5 * room_speed;
objectAttackSpeedTimer = 0;
objectAttackDamage = 12;
objectSlashResistance = 0.9;
objectPierceResistance = 1;
objectCrushResistance = 0.7;
objectMagicResistance = 1;
// Mining variables (exclusive to obj_worker)
objectWoodChopSpeed = room_speed; // Wood
objectWoodChopSpeedTimer = 0; // Wood
objectWoodChopDamage = 4; // Wood
objectFoodGatherSpeed = room_speed; // Food
objectFoodGatherSpeedTimer = 0; // Food
objectFoodGatherDamage = 5; // Food
objectGoldMineSpeed = room_speed; // Gold
objectGoldMineSpeedTimer = 0; // Gold
objectGoldMineDamage = 4; // Gold
objectRubyMineSpeed = room_speed; // Ruby
objectRubyMineSpeedTimer = 0; // Ruby
objectRubyMineDamage = 2; // Ruby
// Other generic variables
maxHP = 70;
currentHP = maxHP;
objectRange = 16;
objectTeam = 1;
objectSelected = false;
objectOnScreen = false;
objectTargetList = noone;
objectTarget = noone;
objectTargetTeam = noone;
objectTargetType = noone;


// Depth setting
depth = -y;

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


// State machine
enum worker {
	idle,
	move,
	mine,
	attack
}
// Sprite setting enums
enum workerDirection {
	right,
	up,
	left,
	down
}
// Sprite setting array
workerSprite[worker.idle][workerDirection.right] = spr_worker;
workerSprite[worker.idle][workerDirection.up] = spr_worker;
workerSprite[worker.idle][workerDirection.left] = spr_worker;
workerSprite[worker.idle][workerDirection.down] = spr_worker;
workerSprite[worker.move][workerDirection.right] = spr_worker;
workerSprite[worker.move][workerDirection.up] = spr_worker;
workerSprite[worker.move][workerDirection.left] = spr_worker;
workerSprite[worker.move][workerDirection.down] = spr_worker;
workerSprite[worker.mine][workerDirection.right] = spr_worker;
workerSprite[worker.mine][workerDirection.up] = spr_worker;
workerSprite[worker.mine][workerDirection.left] = spr_worker;
workerSprite[worker.mine][workerDirection.down] = spr_worker;
workerSprite[worker.attack][workerDirection.right] = spr_worker;
workerSprite[worker.attack][workerDirection.up] = spr_worker;
workerSprite[worker.attack][workerDirection.left] = spr_worker;
workerSprite[worker.attack][workerDirection.down] = spr_worker;
// Actual Sprite Value
currentAction = worker.move;
currentDirection = workerDirection.right;
currentSprite = workerSprite[currentAction][currentDirection];
// Index speed
currentImageIndex = 0;
currentImageIndexSpeed = 10 / room_speed;


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



