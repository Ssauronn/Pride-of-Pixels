///@function						unit_mine();
///@description						Allows workers to collect resources and deposit into
///									respective players' total resource count.
function unit_mine() {
	// Check to see if the unitAction should currently be mining - if not, then set to a different state.
	if (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Chop") || (objectCurrentCommand == "Farm") || (objectCurrentCommand == "Ruby Mine") {
		// Check to see if a target to mine exists and the target is a valid target, or if a target
		// to attack exists and is valid - otherwise, active variables to search for a new target.
		if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Resource") {
			currentDirection = floor((point_direction(x, y, objectTarget.x, objectTarget.y,) + 45) / 90);
			if currentDirection > 3 {
				currentDirection -= 4;
			}
			// Check if within mining range - if not, activate variables to move to the target.
			if distance_to_object(objectTarget) < 16 {
				// Here I detect if the animation for the current action is active, and only then do
				// I attempt to take that action.
				var i;
				var correct_animation_active_ = false;
				for (i = 0; i < unitDirection.length; i++) {
					if currentSprite == workerSprite[currentAction][i] {
						correct_animation_active_ = true;
						break;
					}
				}
				if correct_animation_active_ {
					switch objectTarget.objectType {
						case "Wood":
							if objectWoodChopSpeedTimer <= 0 {
								objectWoodChopSpeedTimer = objectWoodChopSpeed;
								objectTarget.currentHP -= objectWoodChopDamage;
								player[objectRealTeam].wood += objectWoodChopDamage;
							}
							break;
						case "Food":
							if objectFoodGatherSpeedTimer <= 0 {
								objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
								objectTarget.currentHP -= objectFoodGatherDamage;
								player[objectRealTeam].food += objectFoodGatherDamage;
							}
							break;
						case "Gold":
							if objectGoldMineSpeedTimer <= 0 {
								objectGoldMineSpeedTimer = objectGoldMineSpeed;
								objectTarget.currentHP -= objectGoldMineDamage;
								player[objectRealTeam].gold += objectGoldMineDamage;
							}
							break;
						case "Ruby":
							if objectRubyMineSpeedTimer <= 0 {
								objectRubyMineSpeedTimer = objectRubyMineSpeed;
								objectTarget.currentHP -= objectRubyMineDamage;
								player[objectRealTeam].rubies += objectRubyMineDamage;
							}
							break;
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
		else if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Unit") && (objectTarget.objectRealTeam != objectRealTeam) {
			currentDirection = floor((point_direction(x, y, objectTarget.x, objectTarget.y,) + 45) / 90);
			if currentDirection > 3 {
				currentDirection -= 4;
			}
			// Just send to attack script, and the attack script can handle the rest.
			currentAction = unitAction.attack;
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
		else if objectCurrentCommand == "Attack" {
			currentAction = unitAction.attack;
		}
	}
}


