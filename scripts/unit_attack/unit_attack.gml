/// @function								unit_attack();
/// @description							Attack nearest enemy objects, whether they be buildings or units.

function unit_attack() {
	// Check to see if the object should be currently attacking - if not, swap to a different state.
	if objectCurrentCommand == "Attack" {
		if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Unit") && (objectTarget.objectTeam != objectTeam) {
			if distance_to_object(objectTarget) < objectRange {
				objectAttackSpeedTimer--;
				if objectAttackSpeedTimer <= 0 {
					objectAttackSpeedTimer = objectAttackSpeed;
					objectTarget.currentHP -= objectAttackDamage;
				}
			}
			else {
				objectNeedsToMove = true;
				targetToMoveToX = objectTarget.x;
				targetToMoveToY = objectTarget.y;
			}
		}
		else if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Resource") && (objectType == "Worker") {
			currentAction = worker.mine;
			currentDirection = floor(point_direction(x, y, objectTarget.x, objectTarget.y) / 16);
		}
		else {
			target_next_object();
			currentAction = worker.move;
		}
	}
	else {
		if objectCurrentCommand == "Move" {
			objectCurrentCommand = "Idle";
			currentAction = worker.idle;
		}
		else if (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Chop") || (objectCurrentCommand == "Farm") || (objectCurrentCommand == "Ruby Mine") {
			currentAction = worker.mine;
		}
	}
}