// Object type, used for selection and targeting purposes
objectType = "Unit";
objectSelected = false;
selectedObjectDirectionToFaceIfNoneSet = -1;
objectOnScreen = false;

// Depth setting
depth = -y;

// Pathfinding
myPath = path_add();
validPathFound = false;
path_set_kind(myPath, 1);
path_set_precision(myPath, 1);
targetToMoveToX = floor(x / 16) * 16;
targetToMoveToY = floor(y / 16) * 16;
originalTargetToMoveToX = floor(x / 16) * 16;
originalTargetToMoveToY = floor(y / 16) * 16;
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
n_ = 0;
iteration_ = 0;
amountOfTimesShifted = 0;
sizeOfGroupSelectedToMoveWith = 0;
groupRowWidth = 0;
amountOfTimesDirectionRotated = 0;
specificLocationNeedsToBeChecked = false;
specificLocationToBeCheckedX = -1;
specificLocationToBeCheckedY = -1;
movementSpeed = 2;
searchHasJustBegun = true;
totalTimesSearched = 0;

// State machine
enum worker {
	idle,
	move,
	chop,
	farm,
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
workerSprite[worker.idle, workerDirection.right] = spr_worker;
workerSprite[worker.idle, workerDirection.up] = spr_worker;
workerSprite[worker.idle, workerDirection.left] = spr_worker;
workerSprite[worker.idle, workerDirection.down] = spr_worker;
workerSprite[worker.move, workerDirection.right] = spr_worker;
workerSprite[worker.move, workerDirection.up] = spr_worker;
workerSprite[worker.move, workerDirection.left] = spr_worker;
workerSprite[worker.move, workerDirection.down] = spr_worker;
workerSprite[worker.chop, workerDirection.right] = spr_worker;
workerSprite[worker.chop, workerDirection.up] = spr_worker;
workerSprite[worker.chop, workerDirection.left] = spr_worker;
workerSprite[worker.chop, workerDirection.down] = spr_worker;
workerSprite[worker.farm, workerDirection.right] = spr_worker;
workerSprite[worker.farm, workerDirection.up] = spr_worker;
workerSprite[worker.farm, workerDirection.left] = spr_worker;
workerSprite[worker.farm, workerDirection.down] = spr_worker;
workerSprite[worker.mine, workerDirection.right] = spr_worker;
workerSprite[worker.mine, workerDirection.up] = spr_worker;
workerSprite[worker.mine, workerDirection.left] = spr_worker;
workerSprite[worker.mine, workerDirection.down] = spr_worker;
workerSprite[worker.attack, workerDirection.right] = spr_worker;
workerSprite[worker.attack, workerDirection.up] = spr_worker;
workerSprite[worker.attack, workerDirection.left] = spr_worker;
workerSprite[worker.attack, workerDirection.down] = spr_worker;
// Actual Sprite Value
workerCurrentAction = worker.move;
workerCurrentDirection = workerDirection.right;
workerCurrentSprite = workerSprite[workerCurrentAction, workerCurrentDirection];

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



