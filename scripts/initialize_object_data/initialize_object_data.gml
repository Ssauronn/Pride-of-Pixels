///@function							initialize_object_data();
///@description							Assign unit/building specific variables to each object

// State machine - this is initialized only once at the beginning of the game, as this declaration is
// outside of a function.
// I add a "length" enum at the very end of each list to be able to access the length of this list
// to correctly run for loops.
enum unitAction {
	idle,
	move,
	mine,
	chop,
	farm,
	attack,
	length
}
// Sprite setting enums
enum unitDirection {
	right,
	up,
	left,
	down,
	length
}

// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
// In this case, I need to have a function that loops through all possible stats and all applicable
// upgrades available on each building, and apply those on spawn to each unit and/or building that
// is fresthly spawned. Stat upgrades are located in the script initialize_stat_data and the object
// obj_stat_manager.
function apply_all_upgrades_at_spawn() {
	/*
		// keep in mind, all this code is called in initialize_object_data(), which itself is ran in
		// the object step event (obj_unit or obj_building). So the code below is built using
		// variables already set in initialize_object_data().
		if (object_index == ...) {
			- apply only the upgrades of player[i] that correspond to that players' upgrades. For
			  example, if player[1] has all upgrades, a building spawned by player[2] should not be
			  given all upgrades afforded to player[1].
			with player[objectRealTeam] {
				- loop through each possible upgrade for each object where broad object upgrades apply
			}
		}
		if objectType == "..." {
			// If an upgrade listed below applies to the object type listed above, apply that upgrade.
			if player[objectRealTeam].... {
				
			}
			if player[objectRealTeam].... {
				
			}
			etc. {
				
			}
		}
		else if objectType == "..." {
			// If an upgrade listed below applies to the object type listed above, apply that upgrade.
			if player[objectRealTeam].... {
				
			}
			if player[objectRealTeam].... {
				
			}
			etc. {
				
			}
		}
	}
	*/
}

function initialize_object_data() {
	objectVisibleTeam = objectRealTeam;
	switch objectType {
		#region Units
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Worker":
			// Generic variables
			maxHP = 70;
			currentHP = maxHP;
			objectRange = 16;
			// Availability variables
			canBuildFarm = false;
			canBuildThicket = false;
			canBuildMine = false;
			canBuildRubyPit = false;
			canBuildObelisk = false;
			canBuildSoulSubjugator = false;
			canBuildRitualGrounds = false;
			canBuildUnholyZiggurat = false;
			canBuildRailGun = false;
			canBuildStasisField = false;
			canBuildLaunchSite = false;
			canMineRuby = false;
			// Combat variables
			objectCombatAggroRange = 8; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1.5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 12;
			objectAttackDamageType = "Slash";
			objectIsRubyUnit = false;
			objectCanUseSpecialAbility = false;
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 0.9;
			objectPierceResistance = 1;
			objectMagicResistance = 1;
			// Mining variables (exclusive to obj_worker)
			objectWoodChopSpeed = room_speed; // Wood
			objectWoodChopSpeedTimer = 0; // Wood
			objectWoodChopDamage = 20; // Wood
			objectFoodGatherSpeed = room_speed; // Food
			objectFoodGatherSpeedTimer = 0; // Food
			objectFoodGatherDamage = 5; // Food
			objectGoldMineSpeed = room_speed; // Gold
			objectGoldMineSpeedTimer = 0; // Gold
			objectGoldMineDamage = 4; // Gold
			objectRubyMineSpeed = room_speed; // Ruby
			objectRubyMineSpeedTimer = 0; // Ruby
			objectRubyMineDamage = 2; // Ruby
			// Sprite setting array
			workerSprite[unitAction.idle][unitDirection.right] = spr_worker_right_idle;
			workerSprite[unitAction.idle][unitDirection.up] = spr_worker_back_idle;
			workerSprite[unitAction.idle][unitDirection.left] = spr_worker_left_idle;
			workerSprite[unitAction.idle][unitDirection.down] = spr_worker_front_idle;
			workerSprite[unitAction.move][unitDirection.right] = spr_worker_right_walk;
			workerSprite[unitAction.move][unitDirection.up] = spr_worker_back_walk;
			workerSprite[unitAction.move][unitDirection.left] = spr_worker_left_walk;
			workerSprite[unitAction.move][unitDirection.down] = spr_worker_front_walk;
			workerSprite[unitAction.mine][unitDirection.right] = spr_worker_right_mine;
			workerSprite[unitAction.mine][unitDirection.up] = spr_worker_back_mine;
			workerSprite[unitAction.mine][unitDirection.left] = spr_worker_left_mine;
			workerSprite[unitAction.mine][unitDirection.down] = spr_worker_front_mine;
			workerSprite[unitAction.chop][unitDirection.right] = spr_worker_right_chop;
			workerSprite[unitAction.chop][unitDirection.up] = spr_worker_back_chop;
			workerSprite[unitAction.chop][unitDirection.left] = spr_worker_left_chop;
			workerSprite[unitAction.chop][unitDirection.down] = spr_worker_front_chop;
			workerSprite[unitAction.farm][unitDirection.right] = spr_worker_right_farm;
			workerSprite[unitAction.farm][unitDirection.up] = spr_worker_back_farm;
			workerSprite[unitAction.farm][unitDirection.left] = spr_worker_left_farm;
			workerSprite[unitAction.farm][unitDirection.down] = spr_worker_front_farm;
			workerSprite[unitAction.attack][unitDirection.right] = spr_worker_right_attack;
			workerSprite[unitAction.attack][unitDirection.up] = spr_worker_back_attack;
			workerSprite[unitAction.attack][unitDirection.left] = spr_worker_left_attack;
			workerSprite[unitAction.attack][unitDirection.down] = spr_worker_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = workerSprite[currentAction][currentDirection];
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		#endregion
		#region Buildings
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "City Hall":
			// Generic variables
			maxHP = 1500;
			currentHP = maxHP;
			populationProvided = 25;
			// The distance at which attacks can used, in pixels
			objectRange = 16 * 5;
			canAttack = true;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			objectCombatAggroRange = 5;
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 12;
			objectAttackDamageType = "Pierce";
			objectSlashResistance = 0.9;
			objectPierceResistance = 1;
			objectMagicResistance = 1;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			sprite_index = spr_building_xlarge;
			var floor_x_ = floor(x / 16) * 16;
			var floor_y_ = floor(y / 16) * 16;
			mask_index = spr_64_64;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			
			
			break;
		case "Temple":
			// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, all the generic variables need to be added here, copied from City Hall,
			// in addition to the building specific variable
			// Generic Variables
			
			// Specific Variables
			canTrainRubyUnits = false;
			break;
		#endregion
	}
}


