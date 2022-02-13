///@function								unit_attack();
///@description							Attack nearest enemy objects, whether they be buildings or units.

function unit_attack() {
	// Check to see if the object should be currently attacking - if not, swap to a different state.
	if objectCurrentCommand == "Attack" {
		if (instance_exists(objectTarget)) && ((objectTarget.objectClassification == "Unit") || (objectTarget.objectClassification == "Building")) && (objectTarget.objectRealTeam != objectRealTeam) {
			currentDirection = (point_direction(x, y, objectTarget.x, objectTarget.y,) + 45) div 90;
			if currentDirection > 3 {
				currentDirection = 0;
			}
			if distance_to_object(objectTarget) < objectAttackRange {
				// Here I detect if the animation for the current action is active, and only then do
				// I attempt to take that action.
				var i;
				var correct_animation_active_ = false;
				for (i = 0; i < unitDirection.length; i++) {
					if currentSprite == unitSprite[currentAction][i] {
						correct_animation_active_ = true;
						break;
					}
				}
				if correct_animation_active_ {
					if objectAttackSpeedTimer <= 0 {
						objectAttackSpeedTimer = objectAttackSpeed;
						deal_damage(objectAttackDamage, objectAttackDamageType, objectTarget);
					}
				}
			}
			else {
				objectNeedsToMove = true;
				if (objectTarget.objectClassification == "Unit") && (objectTarget.currentAction == unitAction.move) {
					targetToMoveToX = objectTarget.targetToMoveToX;
					targetToMoveToY = objectTarget.targetToMoveToY;
					targetToMoveToX = objectTarget.x;
					targetToMoveToY = objectTarget.y;
				}
				else {
					targetToMoveToX = objectTarget.x;
					targetToMoveToY = objectTarget.y;
				}
			}
		}
		// If the unit has a target, the target is a resource, and the unit is a worker, make it collect from
		// that resource.
		else if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Resource") && (objectType == "Worker") {
			currentDirection = (point_direction(x, y, objectTarget.x, objectTarget.y,) + 45) div 90;
			if currentDirection > 3 {
				currentDirection -= 4;
			}
			switch (objectTarget.objectType) {
				case "Gold":
					currentAction = unitAction.mine;
					break;
				case "Ruby":
					currentAction = unitAction.mine;
					break;
				case "Wood":
					currentAction = unitAction.chop;
					break;
				case "Food":
					currentAction = unitAction.farm;
					break;
			}
		}
		else {
			target_next_object();
			currentAction = unitAction.move;
			// Run this script to determine if it should be making its own path, or following the path
			// of another.
			determine_leader_or_follower();
		}
	}
	else {
		if objectCurrentCommand == "Move" {
			objectCurrentCommand = "Idle";
			currentAction = unitAction.idle;
		}
		else if (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Chop") || (objectCurrentCommand == "Farm") || (objectCurrentCommand == "Ruby Mine") {
			currentAction = unitAction.mine;
		}
	}
}