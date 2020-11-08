/// @function							unit_mine();
/// @description						Allows workers to collect resources and deposit into
///										respective players' total resource count.
function unit_mine() {
	// Check to see if the unit should currently be mining - if not, then set to a different state.
	if (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Chop") || (objectCurrentCommand == "Farm") || (objectCurrentCommand == "Ruby Mine") {
		// Check to see if a target to mine exists and the target is a valid target, or if a target
		// to attack exists and is valid - otherwise, active variables to search for a new target.
		if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Resource") {
			// Check if within mining range - if not, activate variables to move to the target.
			if distance_to_object(objectTarget) < 16 {
				switch objectTarget.objectType {
					case "Wood":
						if objectWoodChopSpeedTimer <= 0 {
							objectWoodChopSpeedTimer = objectWoodChopSpeed;
							objectTarget.currentHP -= objectWoodChopDamage;
						}
						break;
					case "Food":
						if objectFoodGatherSpeedTimer <= 0 {
							objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
							objectTarget.currentHP -= objectFoodGatherDamage;
						}
						break;
					case "Gold":
						if objectGoldMineSpeedTimer <= 0 {
							objectGoldMineSpeedTimer = objectGoldMineSpeed;
							objectTarget.currentHP -= objectGoldMineDamage;
						}
						break;
					case "Ruby":
						if objectRubyMineSpeedTimer <= 0 {
							objectRubyMineSpeedTimer = objectRubyMineSpeed;
							objectTarget.currentHP -= objectRubyMineDamage;
						}
						break;
				}
			}
			else {
				objectNeedsToMove = true;
				if (objectTarget.objectClassification == "Unit") && (objectTarget.currentAction == unit.move) {
					targetToMoveToX = objectTarget.targetToMoveToX;
					targetToMoveToY = objectTarget.targetToMoveToY;
				}
				else {
					targetToMoveToX = objectTarget.x;
					targetToMoveToY = objectTarget.y;
				}
			}
		}
		else if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Unit") && (objectTarget.objectTeam != objectTeam) {
			// Just send to attack script, and the attack script can handle the rest.
			currentAction = unit.attack;
			currentDirection = floor(point_direction(x, y, objectTarget.x, objectTarget.y) / 16);
		}
		else {
			target_next_object();
			currentAction = unit.move;
		}
	}
	else {
		if objectCurrentCommand == "Move" {
			objectCurrentCommand = "Idle";
			currentAction = unit.idle;
		}
		else if objectCurrentCommand == "Attack" {
			currentAction = unit.attack;
		}
	}
}


