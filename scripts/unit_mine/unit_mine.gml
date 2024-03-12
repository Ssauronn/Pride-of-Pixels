///@function						unit_mine();
///@description						Allows workers to collect resources and deposit into
///									respective players' total resource count.
function unit_mine() {
	if instance_exists(objectTarget) {
		var object_type_ = objectTarget.objectType;
	}
	else {
		var object_type_ = noone;
	}
	// Check to see if the unitAction should currently be mining - if not, then set to a different state.
	if (objectCurrentCommand == "Mine") || (objectCurrentCommand == "Chop") || (objectCurrentCommand == "Farm") || (objectCurrentCommand == "Ruby Mine") {
		// Check to see if a target to collect from exists and the target is a valid target, or if
		// a target to attack exists and is valid, or if the object is nearby a drop point
		// - otherwise, activate variables to search for a new target.
		if (instance_exists(objectTarget)) && ((objectTarget.objectClassification == "Resource") || ((objectTarget.objectClassification == "Building") && ((object_type_ == "Farm") || (object_type_ == "Thicket") || (object_type_ == "Mine")))) {
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
					set_return_resource_variables_noone();
					switch object_type_ {
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
								currentResourceWeightCarry += min((objectGoldMineDamage * gold_weight_), (max_amount_of_gold_obtainable_ * gold_weight_));
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
		// Else if the object's target is a drop point, or if the object has no target
		// but is adjacent to a drop point, drop the resources off and then continue onwards.
		else if (((instance_exists(objectTarget)) && ((object_type_ == "City Hall") || (object_type_ == "Storehouse"))) || (instance_exists(returnToResourceDropPointID) && (distance_to_object(returnToResourceDropPointID) <= 32))) && (currentResourceWeightCarry > 0) {
			player[objectRealTeam].food += currentFoodCarry;
			player[objectRealTeam].wood += currentWoodCarry;
			player[objectRealTeam].gold += currentGoldCarry;
			player[objectRealTeam].rubies += currentRubyCarry;
			currentFoodCarry = 0;
			currentWoodCarry = 0;
			currentGoldCarry = 0;
			currentRubyCarry = 0;
			currentResourceWeightCarry = 0;
			if !instance_exists(returnToResourceID) {
				// If the resource to return to no longer exists, find a new one. I specifically only
				// search for a new resource, and not a new resource building, because if the building
				// was destroyed, then it was either unwanted or in combat recently, and either way,
				// the Worker will look more intelligent if it moves somewhere else automatically.
				switch(objectCurrentCommand) {
					case "Mine":
						returnToResourceID = instance_nearest(returnToResourceX, returnToResourceY, obj_gold_resource);
						break;
					case "Farm":
						returnToResourceID = instance_nearest(returnToResourceX, returnToResourceY, obj_food_resource);
						break;
					case "Ruby Mine":
						returnToResourceID = instance_nearest(returnToResourceX, returnToResourceY, obj_ruby_resource);
						break;
					case "Chop":
						returnToResourceID = instance_nearest(returnToResourceX, returnToResourceY, obj_tree_resource);
						break;
				}
			}
			objectTarget = returnToResourceID;
			objectTargetType = returnToResourceType;
			targetToMoveToX = returnToResourceX;
			targetToMoveToY = returnToResourceY;
			objectNeedsToMove = true;
			currentAction = unitAction.move;
			// Run this script to determine if it should be making its own path, or following the path
			// of another.
			determine_leader_or_follower();
		}
		else {
			var object_current_command_ = objectCurrentCommand;
			target_next_object();
			if objectTarget == noone {
				if !ds_exists(objectTargetList, ds_type_list) {
					switch object_current_command_ {
						case "Mine":
							var resource_type_ = "Gold";
							break;
						case "Ruby Mine":
							var resource_type_ = "Ruby";
							break;
						case "Chop":
							var resource_type_ = "Wood";
							break;
						case "Farm":
							var resource_type_ = "Food";
							break;
					}
					objectCurrentCommand = object_current_command_;
					check_for_new_target(x, y, resource_type_);
					// Now that new targets have been (potentially) found by the above line, sort by 
					// distance and set the closest potential target as the new target.
					if ds_exists(objectTargetList, ds_type_list) {
						ds_list_sort_distance(x, y, objectTargetList);
						objectTarget = ds_list_find_value(objectTargetList, 0);
						var target_x_ = objectTarget.x;
						var target_y_ = objectTarget.y;
						if (returnToResourceX != noone) && (returnToResourceY != noone) {
							target_x_ = returnToResourceX;
							target_y_ = returnToResourceY;
						}
						targetToMoveToX = floor(target_x_ / 16) * 16;
						targetToMoveToY = floor(target_y_ / 16) * 16;
					}
				}
			}
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
			currentImageIndex = 0;
			objectAttackSpeedTimer = objectAttackSpeed;
			objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
			objectWoodChopSpeedTimer = objectWoodChopSpeed;
			objectGoldMineSpeedTimer = objectGoldMineSpeed;
			objectRubyMineSpeedTimer = objectRubyMineSpeed;
		}
	}
	// Check to see if the Worker is maxed out by weight, and if so, move to deposit resources
	// into a Storehouse.
	var remaining_weight_available_ = maxResourceWeightCanCarry - currentResourceWeightCarry;
	var resource_gather_weight_ = noone;
	switch object_type_ {
		case "Food":
			resource_gather_weight_ = objectFoodGatherDamage * obj_food_resource.foodWeight;
			break;
		case "Wood":
			resource_gather_weight_ = objectWoodChopDamage * obj_tree_resource.woodWeight;
			break;
		case "Gold":
			resource_gather_weight_ = objectGoldMineDamage * obj_gold_resource.goldWeight;
			break;
		case "Ruby":
			resource_gather_weight_ = objectRubyMineDamage * obj_ruby_resource.rubyWeight;
			break;
	}
	if (resource_gather_weight_ > remaining_weight_available_) && (resource_gather_weight_ != noone) {
		// Set a variable up to set the current resource target as the 
		// target to move to after the Worker deposits the resources
		// held. If the Worker ends up executing any action or commanded
		// to execute any action other than returning the resources, this
		// needs to be wiped.
		var object_target_x_, object_target_y_, object_target_id_, drop_point_id_;
		object_target_x_ = objectTarget.x;
		object_target_y_ = objectTarget.y;
		object_target_id_ = objectTarget.id;
		// First, go through the list of drop points, to make sure that a drop point still exists. If none do,
		// the unit needs to stand still instead.
		var j, drop_point_exists_;
		drop_point_exists_ = true;
		// If a list of storehouses and drop points exists, then use that list. Otherwise, exit straight to idle.
		if ds_exists(player[objectRealTeam].listOfStorehousesAndCityHalls, ds_type_list) {
			for (j = 0; j < ds_list_size(player[objectRealTeam].listOfStorehousesAndCityHalls); j++) {
				var temp_drop_point_id_ = ds_list_find_value(player[objectRealTeam].listOfStorehousesAndCityHalls, j);
				// Begin cleaning the list out. If any don't exist in that list, destroy that line in the list.
				// If the list runs out of lines, destroy the list, and exit straight to idle.
				if !instance_exists(temp_drop_point_id_) {
					if ds_list_size(player[objectRealTeam].listOfStorehousesAndCityHalls) > 1 {
						ds_list_delete(player[objectRealTeam].listOfStorehousesAndCityHalls, j);
					}
					else {
						ds_list_destroy(player[objectRealTeam].listOfStorehousesAndCityHalls);
						player[objectRealTeam].listOfStorehousesAndCityHalls = noone;
						drop_point_exists_ = false;
					}
				}
			}
		}
		else {
			drop_point_exists_ = false;
		}
		// If the list of drop points exists, then proceed as normally to movement towards the closest drop point.
		if drop_point_exists_ {
			ds_list_sort_distance(x, y, player[objectRealTeam].listOfStorehousesAndCityHalls);
			drop_point_id_ = real(ds_list_find_value(player[objectRealTeam].listOfStorehousesAndCityHalls, 0));
			set_return_resource_variables(object_target_x_, object_target_y_, object_target_id_, drop_point_id_);
			objectNeedsToMove = true;
			objectTarget = drop_point_id_;
			targetToMoveToX = drop_point_id_.x;
			targetToMoveToY = drop_point_id_.y;
			currentAction = unitAction.move;
			// Run this script to determine if it should be making its own path, or following the path
			// of another.
			determine_leader_or_follower();
			// Make sure the target list is destroyed, so no checking for the target occurs in the first place.
			if ds_exists(objectTargetList, ds_type_list) {
				ds_list_destroy(objectTargetList);
				objectTargetList = noone;
			}
		}
		// Otherwise, if no drop point exists, then exit to idle.
		else {
			objectNeedsToMove = false;
			objectTarget = noone;
			targetToMoveToX = floor(x / 16) * 16;
			targetToMoveToY = floor(y / 16) * 16;
			currentAction = unitAction.idle;
			objectCurrentCommand = "Idle";
			// Make sure the target list is destroyed, so no checking for the target occurs in the first place.
			if ds_exists(objectTargetList, ds_type_list) {
				ds_list_destroy(objectTargetList);
				objectTargetList = noone;
			}
			objectAttackSpeedTimer = objectAttackSpeed;
			objectFoodGatherSpeedTimer = objectFoodGatherSpeed;
			objectWoodChopSpeedTimer = objectWoodChopSpeed;
			objectGoldMineSpeedTimer = objectGoldMineSpeed;
			objectRubyMineSpeedTimer = objectRubyMineSpeed;
		}
	}
}


