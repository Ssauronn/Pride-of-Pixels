///@function						unit_mine();
///@description						Allows workers to collect resources and deposit into
///									respective players' total resource count.
function unit_mine() {
	// Check to see if the unitAction should currently be mining - if not, then set to a different state.
	if (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Chop") || (objectCurrentCommand == "Farm") || (objectCurrentCommand == "Ruby Mine") {
		// Check to see if a target to collect from exists and the target is a valid target, or if
		// a target to attack exists and is valid - otherwise, active variables to search for a new
		// target.
		if (instance_exists(objectTarget)) && ((objectTarget.objectClassification == "Resource") || ((objectTarget.objectClassification == "Building") && ((objectTarget.objectType == "Farm") || (objectTarget.objectType == "Thicket") || (objectTarget.objectType == "Mine")))) {
			currentDirection = (point_direction(x, y, objectTarget.x, objectTarget.y,) + 45) div 90;
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
					if currentSprite == unitSprite[currentAction][i] {
						correct_animation_active_ = true;
						break;
					}
				}
				if correct_animation_active_ {
					switch objectTarget.objectType {
						case "Food":
							if objectFoodGatherSpeedTimer <= 0 {
								objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
								// Add the lesser of either the max amount of resources that can be collected right now,
								// or the max amount of resources that can be collected without forcing currentResourceWeightCarry
								// above maxResourceWeightCarry.
								var food_weight_ = obj_food_resource.foodWeight;
								var max_amount_of_food_obtainable_ = floor((maxResourceWeightCanCarry - currentResourceWeightCarry) / food_weight_)
								objectTarget.currentHP -= min(objectFoodGatherDamage, max_amount_of_food_obtainable_);
								currentFoodCarry += min(objectFoodGatherDamage, max_amount_of_food_obtainable_);
								currentResourceWeightCarry += min((objectFoodGatherDamage * food_weight_), (max_amount_of_food_obtainable_ * food_weight_));
								// Check to see if the Worker is maxed out by weight, and if so, move to deposit resources
								// into a Storehouse.
								if max_amount_of_food_obtainable_ < objectFoodGatherDamage {
									objectNeedsToMove = true;
									ds_list_sort_distance(player[objectRealTeam].listOfStorehousesAndCityHalls);
									objectTarget = ds_list_find_value(player[objectRealTeam].listOfStorehousesAndCityHalls, 0);
									targetToMoveToX = objectTarget.x;
									targetToMoveToY = objectTarget.y;
								}
							}
							break;
						case "Wood":
							if objectWoodChopSpeedTimer <= 0 {
								// Add the lesser of either the max amount of resources that can be collected right now,
								// or the max amount of resources that can be collected without forcing currentResourceWeightCarry
								// above maxResourceWeightCarry.
								objectWoodChopSpeedTimer = objectWoodChopSpeed;
								var wood_weight_ = obj_tree_resource.woodWeight;
								var max_amount_of_wood_obtainable_ = floor((maxResourceWeightCanCarry - currentResourceWeightCarry) / wood_weight_)
								objectTarget.currentHP -= min(objectWoodChopDamage, max_amount_of_wood_obtainable_);
								currentWoodCarry += min(objectWoodChopDamage, max_amount_of_wood_obtainable_);
								currentResourceWeightCarry += min((objectWoodChopDamage * wood_weight_), (max_amount_of_wood_obtainable_ * wood_weight_));
								
							}
							break;
						case "Gold":
							if objectGoldMineSpeedTimer <= 0 {
								// Add the lesser of either the max amount of resources that can be collected right now,
								// or the max amount of resources that can be collected without forcing currentResourceWeightCarry
								// above maxResourceWeightCarry.
								objectGoldMineSpeedTimer = objectGoldMineSpeed;
								var gold_weight_ = obj_gold_resource.goldWeight;
								var max_amount_of_gold_obtainable_ = floor((maxResourceWeightCanCarry - currentResourceWeightCarry) / gold_weight_)
								objectTarget.currentHP -= min(objectGoldMineDamage, max_amount_of_gold_obtainable_);
								currentGoldCarry += min(objectGoldMineDamage, max_amount_of_gold_obtainable_);
								currentResourceWeightCarry += min((objectGoldMineDamage * gold_weight_), (max_amount_of_wood_obtainable_ * gold_weight_));
							}
							break;
						case "Ruby":
							if objectRubyMineSpeedTimer <= 0 {
								// Add the lesser of either the max amount of resources that can be collected right now,
								// or the max amount of resources that can be collected without forcing currentResourceWeightCarry
								// above maxResourceWeightCarry.
								objectRubyMineSpeedTimer = objectRubyMineSpeed;
								var ruby_weight_ = obj_ruby_resource.rubyWeight;
								var max_amount_of_ruby_obtainable_ = floor((maxResourceWeightCanCarry - currentResourceWeightCarry) / ruby_weight_)
								objectTarget.currentHP -= min(objectRubyMineDamage, max_amount_of_ruby_obtainable_);
								currentRubyCarry += min(objectRubyMineDamage, max_amount_of_ruby_obtainable_);
								currentResourceWeightCarry += min((objectRubyMineDamage * ruby_weight_), (max_amount_of_ruby_obtainable_ * ruby_weight_));
							}
							break;
						case "Farm":
							if objectFoodGatherSpeedTimer <= 0 {
								objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
								player[objectRealTeam].food += objectFoodGatherDamage * (0.8);
							}
							break;
						case "Thicket":
							if objectWoodChopSpeedTimer <= 0 {
								objectWoodChopSpeedTimer = objectWoodChopSpeed;
								player[objectRealTeam].wood += objectWoodChopDamage * (0.8);
							}
							break;
						case "Mine":
							if objectGoldMineSpeedTimer <= 0 {
								objectGoldMineSpeedTimer = objectGoldMineSpeed;
								player[objectRealTeam].gold += objectGoldMineDamage * (0.8);
							}
							break;
					}
					// Now that resource collecting has happened, if the Worker is carrying its max
					// amount of resources, send the worker to a Storehouse or City Hall to deposit
					// the resources, and then back to it's original resource.
					
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
			currentDirection = (point_direction(x, y, objectTarget.x, objectTarget.y,) + 45) div 90;
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


