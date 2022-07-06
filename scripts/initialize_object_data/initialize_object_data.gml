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
	specialAttack,
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
// Abomination enums, used exclusively for setting Abomination body parts and reading that data
enum abominationHead { 
	ogre,
	werewolf,
	robot
}
enum abominationChest { 
	ogre,
	werewolf,
	robot
}
enum abominationLegs { 
	ogre,
	werewolf,
	robot
}
enum abominationBodyPartStats {
	baseHP = 30,
	baseMovementSpeed = 1 * (1 / 3),
	baseAttackDamage = 8,
	ogreHP = 55,
	werewolfMovementSpeed = 2 * (1 / 3),
	robotAttackDamage = 13
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
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 6 * 16;
			// Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			movementSpeedBonus = 1;
			movementSpeedBonusAvailable = false;
			movementSpeedBonusActive = false;
			randomBasicResourceGenerationActive = false;
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
			objectAttackRange = 16;
			objectCombatAggroRange = 3; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1.5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 12;
			objectAttackDamageType = "Slash";
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
			unitSprite[unitAction.idle][unitDirection.right] = spr_worker_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_worker_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_worker_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_worker_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_worker_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_worker_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_worker_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_worker_front_walk;
			unitSprite[unitAction.mine][unitDirection.right] = spr_worker_right_mine;
			unitSprite[unitAction.mine][unitDirection.up] = spr_worker_back_mine;
			unitSprite[unitAction.mine][unitDirection.left] = spr_worker_left_mine;
			unitSprite[unitAction.mine][unitDirection.down] = spr_worker_front_mine;
			unitSprite[unitAction.chop][unitDirection.right] = spr_worker_right_chop;
			unitSprite[unitAction.chop][unitDirection.up] = spr_worker_back_chop;
			unitSprite[unitAction.chop][unitDirection.left] = spr_worker_left_chop;
			unitSprite[unitAction.chop][unitDirection.down] = spr_worker_front_chop;
			unitSprite[unitAction.farm][unitDirection.right] = spr_worker_right_farm;
			unitSprite[unitAction.farm][unitDirection.up] = spr_worker_back_farm;
			unitSprite[unitAction.farm][unitDirection.left] = spr_worker_left_farm;
			unitSprite[unitAction.farm][unitDirection.down] = spr_worker_front_farm;
			unitSprite[unitAction.attack][unitDirection.right] = spr_worker_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_worker_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_worker_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_worker_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
			
		
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Berserker":
			// Generic variables
			maxHP = 90;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 7 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			enrageDamageBonus = 3;
			// Combat variables
			objectAttackRange = 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 17;
			objectAttackDamageType = "Slash";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.1;
			objectPierceResistance = 1.1;
			objectMagicResistance = 1.1;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_berserker_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_berserker_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_berserker_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_berserker_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_berserker_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_berserker_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_berserker_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_berserker_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_berserker_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_berserker_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_berserker_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_berserker_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Soldier":
			// Generic variables
			maxHP = 125;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 6 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			courageDamageBonus = 2;
			// Combat variables
			objectAttackRange = 16;
			objectCombatAggroRange = 4; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 27;
			objectAttackDamageType = "Slash";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 0.75;
			objectPierceResistance = 0.85;
			objectMagicResistance = 1.2;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_soldier_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_soldier_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_soldier_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_soldier_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_soldier_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_soldier_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_soldier_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_soldier_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_soldier_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_soldier_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_soldier_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_soldier_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		case "Knight":
			// Generic variables
			maxHP = 250;
			currentHP = maxHP;
			baseMovementSpeed = 0.5;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 6 * 16;
			// Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			tauntCooldown = 25 * room_speed;
			tauntCooldownTimer = -1;
			tauntDurationCooldown = 5 * room_speed;
			tauntDurationCooldownTimer = 5 * room_speed;
			tauntTarget = noone;
			// Combat variables
			objectAttackRange = 16;
			objectCombatAggroRange = 4; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2.5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 18;
			objectAttackDamageType = "Slash";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 0.65;
			objectPierceResistance = 0.65;
			objectMagicResistance = 0.85;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_knight_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_knight_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_knight_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_knight_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_knight_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_knight_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_knight_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_knight_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_knight_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_knight_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_knight_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_knight_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		case "Ranger":
			// Generic variables
			maxHP = 100;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 9 * 16;
			// Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			handheldRailGunActive = false;
			handheldRailGunDamageBonus = 8;
			// Combat variables
			objectAttackRange = 5 * 16;
			objectCombatAggroRange = 7; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1.5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 13;
			objectAttackDamageType = "Pierce";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 0.9;
			objectPierceResistance = 0.9;
			objectMagicResistance = 1.1;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_ranger_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_ranger_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_ranger_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_ranger_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_ranger_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_ranger_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_ranger_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_ranger_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_ranger_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_ranger_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_ranger_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_ranger_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Rogue":
			// Generic variables
			maxHP = 100;
			currentHP = maxHP;
			baseMovementSpeed = 1.5;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 6 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			ambushDamageBonus = 50;
			piercingStrikeActive = false;
			// Armor is a decimal value from 0 to 1, used to multiply against damage. The lower the value,
			// the higher the armor. So penetration temporarily adds to the armor multiplier, to increase
			// the damage taken by the target (when using the Ambush ability in this case).
			piercingStrikePenetration = 0.25;
			// Combat variables
			objectAttackRange = 1 * 16;
			objectCombatAggroRange = 4; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 12;
			objectAttackDamageType = "Pierce";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 0.90;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.00;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_rogue_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_rogue_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_rogue_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_rogue_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_rogue_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_rogue_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_rogue_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_rogue_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_rogue_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_rogue_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_rogue_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_rogue_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Wizard":
			// Generic variables
			maxHP = 80;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = true;
			objectSightRange = 7 * 16;
			// Availability variables
			// Special Ability in this case is Wizard's Fireball ability, which is always unlocked by default.
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			// Singed Circuit is an unlocked passive that reduces the cooldown of the Wizard's special
			// ability if it hits enough targets with a cast of that special ability.
			singedCircuitActive = false;
			singedCircuitSpecialAttackCooldownReduction = 3 * room_speed;
			// The Wizard's combat specialization ability is to redirect damage received by a chosen
			// target to a nearby Knight in combat. If there are no Knights nearby, the damage is instead
			// redirected to the Wizard.
			objectCombatSpecializationAbilityActive = false;
			objectCombatSpecializationTimer = 20 * room_speed;
			objectCombatSpecializationCooldown = -1;
			objectCombatSpecializationRange = 6 * 16;
			objectCombatSpecializationKnightInRange = false;
			objectCombatSpecializationRedirectKnightTarget = noone;
			objectCombatSpecializationRedirectProtectTarget = noone;
			objectCombatSpecializationRedirectProtectMultiplier = 0.7;
			objectCombatSpecializationDurationTimer = 5 * room_speed;
			objectCombatSpecializationDurationCooldown = -1;
			wizardsCanLink = false;
			wizardIsLinked = false;
			aoeLinkedSquareSize = 2;
			arcaneWeaponActive = false;
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			// Combat variables
			objectAttackRange = 3 * 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 25;
			objectAttackDamageType = "Magic";
			objectSpecialAttackDamage = 50;
			objectSpecialAttackAreaOfEffectUnitDamage = 15;
			objectSpecialAttackAreaOfEffectBuildingDamage = 50;
			objectSpecialAttackDamageType = "Magic";
			objectSpecialAttackCooldown = 10 * room_speed;
			objectSpecialAttackTimer = 0;
			objectSpecialAttackTimerSingedCircuitMultiplier = 0.5;
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.25;
			objectPierceResistance = 1;
			objectMagicResistance = 0.95;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_wizard_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_wizard_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_wizard_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_wizard_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_wizard_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_wizard_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_wizard_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_wizard_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_wizard_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_wizard_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_wizard_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_wizard_front_attack;
			unitSprite[unitAction.specialAttack][unitDirection.right] = spr_wizard_right_attack;
			unitSprite[unitAction.specialAttack][unitDirection.up] = spr_wizard_back_attack;
			unitSprite[unitAction.specialAttack][unitDirection.left] = spr_wizard_left_attack;
			unitSprite[unitAction.specialAttack][unitDirection.down] = spr_wizard_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Warlock":
			// Generic variables
			maxHP = 80;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = true;
			objectSightRange = 7 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			enslavementActive = false;
			arcaneWeaponActive = false;
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			// Combat variables
			objectAttackRange = 3 * 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 10;
			objectAttackDamageType = "Magic";
			objectSpecialAttackCooldown = 10 * room_speed;
			objectSpecialAttackTimer = 0;
			// Demons summoned by and bound to the Warlock by the Ritual Grounds structure will bind to the Warlock on their end
			// but will not be registered as soulbound to the Warlock on the Warlock's end. This is so that the Warlock can still
			// summon its regular amount of Demons when those specific Demons die without needing to wait for 20+ Demons to die
			// before casting its summon again.
			summonedDemonsLimit = 1;
			// The time limit is determined by the Warlock and it's upgrades, but the timer itself is managed by the Demon that
			// is summoned. This greatly simplifies the way summons are handled.
			summonedDemonsTimeLimit = 8 * room_speed;
			summonedDemonsList = noone;
			// The range at which Demons will run back to their master's sides no matter what their current action was.
			summonedDemonsMaxTetherRange = 12 * 16;
			// Demons will immediately die if they exceed this distance from their master, no matter their current action.
			summonedDemonsMaxDeathRange = 14 * 16;
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.25;
			objectPierceResistance = 1;
			objectMagicResistance = 0.95;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_warlock_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_warlock_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_warlock_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_warlock_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_warlock_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_warlock_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_warlock_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_warlock_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_warlock_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_warlock_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_warlock_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_warlock_front_attack;
			unitSprite[unitAction.specialAttack][unitDirection.right] = spr_warlock_right_attack;
			unitSprite[unitAction.specialAttack][unitDirection.up] = spr_warlock_back_attack;
			unitSprite[unitAction.specialAttack][unitDirection.left] = spr_warlock_left_attack;
			unitSprite[unitAction.specialAttack][unitDirection.down] = spr_warlock_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Demon":
			// Generic variables
			maxHP = 27;
			currentHP = maxHP;
			baseMovementSpeed = 2;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = true;
			objectSightRange = 5 * 16;
			// Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			enslavementActive = false;
			arcaneWeaponActive = false;
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			// Combat variables
			objectAttackRange = 1 * 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0.5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 8;
			objectAttackDamageType = "Pierce";
			// This is the time limit to determine how long the Demon should last before dying automatically if permanent pets 
			// aren't unlocked.
			// The time limit is determined by the Warlock and it's upgrades, but the timer itself is managed by the Demon that
			// is summoned. This greatly simplifies the way summons are handled.
			summonedDemonsTimeLimitTimer = -1;
			// If this is ever noone, the Demon will die shortly after. A Demon will always be attached to a Warlock.
			summonedDemonsSummonedByWarlockID = noone;
			// This countdown sits at 4 seconds. If the Warlock the Demon is attached to dies, this begins a countdown, and the
			// Demon dies at the end of the countdown.
			summonedDemonsDeathTimer = 4 * room_speed;
			// The range at which Demons will run back to their master's sides no matter what their current action was. Set by
			// the Warlock's parent variable by the same name.
			summonedDemonsMaxTetherRange = -1;
			// Demons will immediately die if they exceed this distance from their master, no matter their current action. Set by
			// the Warlock's parent variable by the same name.
			summonedDemonsMaxDeathRange = -1;
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.25;
			objectPierceResistance = 1.25;
			objectMagicResistance = 0.75;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_demon_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_demon_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_demon_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_demon_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_demon_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_demon_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_demon_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_demon_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_demon_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_demon_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_demon_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_demon_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Acolyte":
			// Generic variables
			maxHP = 100;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = true;
			objectSightRange = 7 * 16;
			// Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			acolytesCanLink = false;
			acolyteIsLinked = false;
			aoeLinkedSquareSize = 2;
			acolyteBlessedAuraActive = false;
			acolyteBlessedAuraRadius = 4 * 16;
			acolyteBlessedAuraMovementSpeedBonus = 0.25;
			acolyteSearingFieldActive = false;
			acolyteSearingFieldRadius = 2 * 16;
			acolyteSearingFieldAoEDamage = 6;
			acolyteSearingFieldCooldown = 1 * room_speed;
			acolyteSearingFieldCooldownTimer = -1;
			arcaneWeaponActive = false;
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final heal for Acolytes after all other adjustments
			// have been made.
			arcaneWeaponBonus = 1.15;
			// Combat variables
			objectAttackRange = 4 * 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 3 * room_speed;
			objectAttackSpeedTimer = 0;
			outOfCombatHealValue = 20;
			inCombatHealValue = 4;
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.25;
			objectPierceResistance = 1;
			objectMagicResistance = 0.95;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_wizard_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_wizard_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_wizard_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_wizard_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_wizard_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_wizard_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_wizard_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_wizard_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_wizard_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_wizard_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_wizard_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_wizard_front_attack;
			unitSprite[unitAction.specialAttack][unitDirection.right] = spr_wizard_right_attack;
			unitSprite[unitAction.specialAttack][unitDirection.up] = spr_wizard_back_attack;
			unitSprite[unitAction.specialAttack][unitDirection.left] = spr_wizard_left_attack;
			unitSprite[unitAction.specialAttack][unitDirection.down] = spr_wizard_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Subverter":
			// Generic variables
			maxHP = 50;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = true;
			objectSightRange = 7 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			preparationActive = false;
			arcaneWeaponActive = false;
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			// Combat variables - Subverters can't attack normally, they entirely rely on deception.
			objectAttackRange = 1 * 16; // The range at which the Subverter can sabotage a building.
			objectSpecialAttackDisableDuration = 30 * room_speed;
			objectCombatSpecializationAttackDamage = 500;
			objectCombatSpecializationAttackDamageType = "Magic";
			objectCombatSpecializationAttackAoERadius = 2 * 16;
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			// Because Subverters are designed to rely on deception, they take massive damage from any
			// attack if they're ever found.
			objectSlashResistance = 2;
			objectPierceResistance = 2;
			objectMagicResistance = 2;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_subverter_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_subverter_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_subverter_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_subverter_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_subverter_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_subverter_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_subverter_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_subverter_front_walk;
			unitSprite[unitAction.specialAttack][unitDirection.right] = spr_subverter_right_attack;
			unitSprite[unitAction.specialAttack][unitDirection.up] = spr_subverter_back_attack;
			unitSprite[unitAction.specialAttack][unitDirection.left] = spr_subverter_left_attack;
			unitSprite[unitAction.specialAttack][unitDirection.down] = spr_subverter_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Abomination":
			// Generic variables
			maxHP = 120;
			currentHP = maxHP;
			baseMovementSpeed = 1.5;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = true;
			objectSightRange = 6 * 16;
			// Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			abominationsCanSacrifice = false;
			bodyPartsProvideStats = false;
			arcaneWeaponActive = false;
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			// Combat variables
			objectAttackRange = 1 * 16;
			objectCombatAggroRange = 4; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 30;
			objectAttackDamageType = "Magic";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 0.95;
			objectPierceResistance = 1.15;
			objectMagicResistance = 0.85;
			// Body Part Variables. Each body part provides a different sprite for the object.
			headBodyPart = abominationHead.robot;
			chestBodyPart = abominationChest.ogre;
			legsBodyPart = abominationLegs.werewolf;
			// Sprite setting array
			// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED. In this case, I need to
			// adjust the sprites so that the three body parts of the Abomination are synced
			// and play animations in unison. I also need to add stat variables that are
			// set by the body parts and add said stats to the Abomination.
			#region Head
			// Ogre Head
			unitSprite[abominationHead.ogre][unitAction.idle][unitDirection.right] = spr_ogre_head_right_idle;
			unitSprite[abominationHead.ogre][unitAction.idle][unitDirection.up] = spr_ogre_head_back_idle;
			unitSprite[abominationHead.ogre][unitAction.idle][unitDirection.left] = spr_ogre_head_left_idle;
			unitSprite[abominationHead.ogre][unitAction.idle][unitDirection.down] = spr_ogre_head_front_idle;
			unitSprite[abominationHead.ogre][unitAction.move][unitDirection.right] = spr_ogre_head_right_walk;
			unitSprite[abominationHead.ogre][unitAction.move][unitDirection.up] = spr_ogre_head_back_walk;
			unitSprite[abominationHead.ogre][unitAction.move][unitDirection.left] = spr_ogre_head_left_walk;
			unitSprite[abominationHead.ogre][unitAction.move][unitDirection.down] = spr_ogre_head_front_walk;
			unitSprite[abominationHead.ogre][unitAction.attack][unitDirection.right] = spr_ogre_head_right_attack;
			unitSprite[abominationHead.ogre][unitAction.attack][unitDirection.up] = spr_ogre_head_back_attack;
			unitSprite[abominationHead.ogre][unitAction.attack][unitDirection.left] = spr_ogre_head_left_attack;
			unitSprite[abominationHead.ogre][unitAction.attack][unitDirection.down] = spr_ogre_head_front_attack;
			// Robot Head
			unitSprite[abominationHead.robot][unitAction.idle][unitDirection.right] = spr_robot_head_right_idle;
			unitSprite[abominationHead.robot][unitAction.idle][unitDirection.up] = spr_robot_head_back_idle;
			unitSprite[abominationHead.robot][unitAction.idle][unitDirection.left] = spr_robot_head_left_idle;
			unitSprite[abominationHead.robot][unitAction.idle][unitDirection.down] = spr_robot_head_front_idle;
			unitSprite[abominationHead.robot][unitAction.move][unitDirection.right] = spr_robot_head_right_walk;
			unitSprite[abominationHead.robot][unitAction.move][unitDirection.up] = spr_robot_head_back_walk;
			unitSprite[abominationHead.robot][unitAction.move][unitDirection.left] = spr_robot_head_left_walk;
			unitSprite[abominationHead.robot][unitAction.move][unitDirection.down] = spr_robot_head_front_walk;
			unitSprite[abominationHead.robot][unitAction.attack][unitDirection.right] = spr_robot_head_right_attack;
			unitSprite[abominationHead.robot][unitAction.attack][unitDirection.up] = spr_robot_head_back_attack;
			unitSprite[abominationHead.robot][unitAction.attack][unitDirection.left] = spr_robot_head_left_attack;
			unitSprite[abominationHead.robot][unitAction.attack][unitDirection.down] = spr_robot_head_front_attack;
			// Werewolf Head
			unitSprite[abominationHead.werewolf][unitAction.idle][unitDirection.right] = spr_werewolf_head_right_idle;
			unitSprite[abominationHead.werewolf][unitAction.idle][unitDirection.up] = spr_werewolf_head_back_idle;
			unitSprite[abominationHead.werewolf][unitAction.idle][unitDirection.left] = spr_werewolf_head_left_idle;
			unitSprite[abominationHead.werewolf][unitAction.idle][unitDirection.down] = spr_werewolf_head_front_idle;
			unitSprite[abominationHead.werewolf][unitAction.move][unitDirection.right] = spr_werewolf_head_right_walk;
			unitSprite[abominationHead.werewolf][unitAction.move][unitDirection.up] = spr_werewolf_head_back_walk;
			unitSprite[abominationHead.werewolf][unitAction.move][unitDirection.left] = spr_werewolf_head_left_walk;
			unitSprite[abominationHead.werewolf][unitAction.move][unitDirection.down] = spr_werewolf_head_front_walk;
			unitSprite[abominationHead.werewolf][unitAction.attack][unitDirection.right] = spr_werewolf_head_right_attack;
			unitSprite[abominationHead.werewolf][unitAction.attack][unitDirection.up] = spr_werewolf_head_back_attack;
			unitSprite[abominationHead.werewolf][unitAction.attack][unitDirection.left] = spr_werewolf_head_left_attack;
			unitSprite[abominationHead.werewolf][unitAction.attack][unitDirection.down] = spr_werewolf_head_front_attack;
			#endregion
			#region Chest
			// Ogre Chest
			unitSprite[abominationChest.ogre][unitAction.idle][unitDirection.right] = spr_ogre_chest_right_idle;
			unitSprite[abominationChest.ogre][unitAction.idle][unitDirection.up] = spr_ogre_chest_back_idle;
			unitSprite[abominationChest.ogre][unitAction.idle][unitDirection.left] = spr_ogre_chest_left_idle;
			unitSprite[abominationChest.ogre][unitAction.idle][unitDirection.down] = spr_ogre_chest_front_idle;
			unitSprite[abominationChest.ogre][unitAction.move][unitDirection.right] = spr_ogre_chest_right_walk;
			unitSprite[abominationChest.ogre][unitAction.move][unitDirection.up] = spr_ogre_chest_back_walk;
			unitSprite[abominationChest.ogre][unitAction.move][unitDirection.left] = spr_ogre_chest_left_walk;
			unitSprite[abominationChest.ogre][unitAction.move][unitDirection.down] = spr_ogre_chest_front_walk;
			unitSprite[abominationChest.ogre][unitAction.attack][unitDirection.right] = spr_ogre_chest_right_attack;
			unitSprite[abominationChest.ogre][unitAction.attack][unitDirection.up] = spr_ogre_chest_back_attack;
			unitSprite[abominationChest.ogre][unitAction.attack][unitDirection.left] = spr_ogre_chest_left_attack;
			unitSprite[abominationChest.ogre][unitAction.attack][unitDirection.down] = spr_ogre_chest_front_attack;
			// Robot Chest
			unitSprite[abominationChest.robot][unitAction.idle][unitDirection.right] = spr_robot_chest_right_idle;
			unitSprite[abominationChest.robot][unitAction.idle][unitDirection.up] = spr_robot_chest_back_idle;
			unitSprite[abominationChest.robot][unitAction.idle][unitDirection.left] = spr_robot_chest_left_idle;
			unitSprite[abominationChest.robot][unitAction.idle][unitDirection.down] = spr_robot_chest_front_idle;
			unitSprite[abominationChest.robot][unitAction.move][unitDirection.right] = spr_robot_chest_right_walk;
			unitSprite[abominationChest.robot][unitAction.move][unitDirection.up] = spr_robot_chest_back_walk;
			unitSprite[abominationChest.robot][unitAction.move][unitDirection.left] = spr_robot_chest_left_walk;
			unitSprite[abominationChest.robot][unitAction.move][unitDirection.down] = spr_robot_chest_front_walk;
			unitSprite[abominationChest.robot][unitAction.attack][unitDirection.right] = spr_robot_chest_right_attack;
			unitSprite[abominationChest.robot][unitAction.attack][unitDirection.up] = spr_robot_chest_back_attack;
			unitSprite[abominationChest.robot][unitAction.attack][unitDirection.left] = spr_robot_chest_left_attack;
			unitSprite[abominationChest.robot][unitAction.attack][unitDirection.down] = spr_robot_chest_front_attack;
			// Werewolf Chest
			unitSprite[abominationChest.werewolf][unitAction.idle][unitDirection.right] = spr_werewolf_chest_right_idle;
			unitSprite[abominationChest.werewolf][unitAction.idle][unitDirection.up] = spr_werewolf_chest_back_idle;
			unitSprite[abominationChest.werewolf][unitAction.idle][unitDirection.left] = spr_werewolf_chest_left_idle;
			unitSprite[abominationChest.werewolf][unitAction.idle][unitDirection.down] = spr_werewolf_chest_front_idle;
			unitSprite[abominationChest.werewolf][unitAction.move][unitDirection.right] = spr_werewolf_chest_right_walk;
			unitSprite[abominationChest.werewolf][unitAction.move][unitDirection.up] = spr_werewolf_chest_back_walk;
			unitSprite[abominationChest.werewolf][unitAction.move][unitDirection.left] = spr_werewolf_chest_left_walk;
			unitSprite[abominationChest.werewolf][unitAction.move][unitDirection.down] = spr_werewolf_chest_front_walk;
			unitSprite[abominationChest.werewolf][unitAction.attack][unitDirection.right] = spr_werewolf_chest_right_attack;
			unitSprite[abominationChest.werewolf][unitAction.attack][unitDirection.up] = spr_werewolf_chest_back_attack;
			unitSprite[abominationChest.werewolf][unitAction.attack][unitDirection.left] = spr_werewolf_chest_left_attack;
			unitSprite[abominationChest.werewolf][unitAction.attack][unitDirection.down] = spr_werewolf_chest_front_attack;
			#endregion
			#region Legs
			// Ogre Legs
			unitSprite[abominationLegs.ogre][unitAction.idle][unitDirection.right] = spr_ogre_legs_right_idle;
			unitSprite[abominationLegs.ogre][unitAction.idle][unitDirection.up] = spr_ogre_legs_back_idle;
			unitSprite[abominationLegs.ogre][unitAction.idle][unitDirection.left] = spr_ogre_legs_left_idle;
			unitSprite[abominationLegs.ogre][unitAction.idle][unitDirection.down] = spr_ogre_legs_front_idle;
			unitSprite[abominationLegs.ogre][unitAction.move][unitDirection.right] = spr_ogre_legs_right_walk;
			unitSprite[abominationLegs.ogre][unitAction.move][unitDirection.up] = spr_ogre_legs_back_walk;
			unitSprite[abominationLegs.ogre][unitAction.move][unitDirection.left] = spr_ogre_legs_left_walk;
			unitSprite[abominationLegs.ogre][unitAction.move][unitDirection.down] = spr_ogre_legs_front_walk;
			unitSprite[abominationLegs.ogre][unitAction.attack][unitDirection.right] = spr_ogre_legs_right_attack;
			unitSprite[abominationLegs.ogre][unitAction.attack][unitDirection.up] = spr_ogre_legs_back_attack;
			unitSprite[abominationLegs.ogre][unitAction.attack][unitDirection.left] = spr_ogre_legs_left_attack;
			unitSprite[abominationLegs.ogre][unitAction.attack][unitDirection.down] = spr_ogre_legs_front_attack;
			// Robot Legs
			unitSprite[abominationLegs.robot][unitAction.idle][unitDirection.right] = spr_robot_legs_right_idle;
			unitSprite[abominationLegs.robot][unitAction.idle][unitDirection.up] = spr_robot_legs_back_idle;
			unitSprite[abominationLegs.robot][unitAction.idle][unitDirection.left] = spr_robot_legs_left_idle;
			unitSprite[abominationLegs.robot][unitAction.idle][unitDirection.down] = spr_robot_legs_front_idle;
			unitSprite[abominationLegs.robot][unitAction.move][unitDirection.right] = spr_robot_legs_right_walk;
			unitSprite[abominationLegs.robot][unitAction.move][unitDirection.up] = spr_robot_legs_back_walk;
			unitSprite[abominationLegs.robot][unitAction.move][unitDirection.left] = spr_robot_legs_left_walk;
			unitSprite[abominationLegs.robot][unitAction.move][unitDirection.down] = spr_robot_legs_front_walk;
			unitSprite[abominationLegs.robot][unitAction.attack][unitDirection.right] = spr_robot_legs_right_attack;
			unitSprite[abominationLegs.robot][unitAction.attack][unitDirection.up] = spr_robot_legs_back_attack;
			unitSprite[abominationLegs.robot][unitAction.attack][unitDirection.left] = spr_robot_legs_left_attack;
			unitSprite[abominationLegs.robot][unitAction.attack][unitDirection.down] = spr_robot_legs_front_attack;
			// Werewolf Legs
			unitSprite[abominationLegs.werewolf][unitAction.idle][unitDirection.right] = spr_werewolf_legs_right_idle;
			unitSprite[abominationLegs.werewolf][unitAction.idle][unitDirection.up] = spr_werewolf_legs_back_idle;
			unitSprite[abominationLegs.werewolf][unitAction.idle][unitDirection.left] = spr_werewolf_legs_left_idle;
			unitSprite[abominationLegs.werewolf][unitAction.idle][unitDirection.down] = spr_werewolf_legs_front_idle;
			unitSprite[abominationLegs.werewolf][unitAction.move][unitDirection.right] = spr_werewolf_legs_right_walk;
			unitSprite[abominationLegs.werewolf][unitAction.move][unitDirection.up] = spr_werewolf_legs_back_walk;
			unitSprite[abominationLegs.werewolf][unitAction.move][unitDirection.left] = spr_werewolf_legs_left_walk;
			unitSprite[abominationLegs.werewolf][unitAction.move][unitDirection.down] = spr_werewolf_legs_front_walk;
			unitSprite[abominationLegs.werewolf][unitAction.attack][unitDirection.right] = spr_werewolf_legs_right_attack;
			unitSprite[abominationLegs.werewolf][unitAction.attack][unitDirection.up] = spr_werewolf_legs_back_attack;
			unitSprite[abominationLegs.werewolf][unitAction.attack][unitDirection.left] = spr_werewolf_legs_left_attack;
			unitSprite[abominationLegs.werewolf][unitAction.attack][unitDirection.down] = spr_werewolf_legs_front_attack;
			#endregion
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			// Abomination is unique in the sense that 3 sprites, not just 1, are drawn every frame to match body parts
			// with what is currently equipped. The setup above takes effort but the payoff here is clean and simple to manage.
			currentSprite = noone;
			currentHeadSprite = unitSprite[headBodyPart][currentAction][currentDirection];
			currentChestSprite = unitSprite[chestBodyPart][currentAction][currentDirection];
			currentLegsSprite = unitSprite[legsBodyPart][currentAction][currentDirection];
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Automaton":
			// Generic variables
			maxHP = 130;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = true;
			objectSightRange = 7 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			chronicEmpowermentPossible = false;
			chronicEmpowermentActive = false;
			chronicEmpowermentTimer = 10 * room_speed;
			chronicEmpowermentCooldown = 0;
			chronicEmpowermentBonus = 1.25; // This is a multiplier to be used with Automaton's damage output
			arcaneWeaponActive = false;
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			// Combat variables
			objectAttackRange = 1 * 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1.5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 20;
			objectAttackDamageType = "Magic";
			objectCombatSpecializationActive = false;
			objectCombatSpecializationTimer = 5 * room_speed;
			objectCombatSpecializationCooldown = -1;
			objectCombatSpecializationRange = 4 * 16;
			objectCombatSpecializationAttackDamage = objectAttackDamage / 2; // This damage is applied once per second.
			objectCombatSpecializationAttackTimer = 1 * room_speed;
			objectCombatSpecializationAttackCooldown = -1;
			objectCombatSpecializationEnemiesWithinRangeThreshold = 3;
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.25;
			objectPierceResistance = 1;
			objectMagicResistance = 0.95;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_wizard_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_wizard_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_wizard_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_wizard_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_wizard_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_wizard_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_wizard_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_wizard_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_wizard_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_wizard_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_wizard_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_wizard_front_attack;
			unitSprite[unitAction.specialAttack][unitDirection.right] = spr_wizard_right_attack;
			unitSprite[unitAction.specialAttack][unitDirection.up] = spr_wizard_back_attack;
			unitSprite[unitAction.specialAttack][unitDirection.left] = spr_wizard_left_attack;
			unitSprite[unitAction.specialAttack][unitDirection.down] = spr_wizard_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
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
			maxHP = 2500;
			currentHP = maxHP;
			populationProvided = 25;
			objectSightRange = 13 * 16;
			maxAmountOfThisBuildingAllowed = 6;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = true;
			objectAttackRange = 8 * 16;
			objectCombatAggroRange = 8; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 12;
			objectAttackDamageType = "Pierce";
			objectSlashResistance = 1;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.25;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			// Sprites
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			
			break;
		case "House":
			// Generic variables
			maxHP = 500;
			currentHP = maxHP;
			populationProvided = 5;
			objectSightRange = 4 * 16;
			maxAmountOfThisBuildingAllowed = 10;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = false;
			objectAttackRange = 0 * 16;
			objectCombatAggroRange = 0; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 0;
			objectAttackDamageType = "";
			objectSlashResistance = 1.25;
			objectPierceResistance = 1;
			objectMagicResistance = 1.5;
			// Rally Point
			rallyPointX = x;
			rallyPointY = y + 16;
			// Sprites
			currentSprite = spr_building_small;
			sprite_index = currentSprite;
			mask_index = spr_16_16;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			
			break;
		case "Temple":
			// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, all the generic variables need to be added here, 
			// in addition to the building specific variable
			// Generic Variables
			maxHP = 2500;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 9 * 16;
			maxAmountOfThisBuildingAllowed = 10;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = false;
			objectAttackRange = 0 * 16;
			objectCombatAggroRange = 0; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 0;
			objectAttackDamageType = "";
			objectSlashResistance = 1;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.25;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			// Sprites
			baseTemple = spr_building_large;
			sprite_index = baseTemple;
			mask_index = spr_48_48;
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			canTrainRubyUnits = false;
			canTrainAbominations = false;
			canTrainAutomatons = false;
			break;
		case "Obelisk":
			// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, all the generic variables need to be added here, 
			// in addition to the building specific variable
			// Generic Variables
			maxHP = 500;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 15 * 16;
			maxAmountOfThisBuildingAllowed = 20;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = true;
			objectAttackRange = 8 * 16;
			objectCombatAggroRange = 8; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 7;
			objectAttackDamageType = "Magic";
			objectSlashResistance = 1;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.25;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			// Sprites
			currentSprite = spr_obelisk_building;
			sprite_index = currentSprite;
			mask_index = spr_32_16;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			telescopesActive = false;
			telescopesRangeIncreaseValue = 2 * 16; // How much further Obelisks can see when Telescopes are active
			hardeningMistActive = false;
			hardeningMistRange = 4 * 16;
			hardeningMistSlashArmorBonus = -0.1;
			hardeningMistPierceArmorBonus = -0.1;
			hardeningMistMagicArmorBonus = -0.1;
			trueSightChosen = false;
			trueSightActive = false;
			lingeringGazeActive = false;
			lingeringGazeDuration = 3 * room_speed; // How long units will be revealed after exiting the Obelisk's range in seconds
			freezingGazeActive = false;
			freezingGazeSlowValue = 0.75; // Multiplier for ow much enemy unit movement speed is slowed by when in range of the Obelisk; currently at a 25% slow
			demonSentryChosen = false;
			demonSentryActive = false;
			awokenActive = false;
			trojanHorseActive = false;
			soulLinkChosen = false;
			soulLinkActive = false;
			lifelineActive = false;
			lifelineHealValue = 13; // how much the Soul Linked unit heals per second while out of combat
			gaiasGrowthActive = false; // When active, the radius is equal to the Obelisk's sight range
			gaiasGrowthHealValue = 3; // how much surrounding buildings are healed by per second
			waygatesChosen = false;
			waygatesActive = false;
			energizingFieldActive = false;
			energizingFieldSpeedBoostValue = 1.2; // 20% extra speed
			energizingFieldSpeedBoostDuration = 10 * room_speed; // how long the speed boost lasts in seconds
			battleVigorActive = false;
			lasersChosen = false;
			lasersActive = false;
			lasersDamage = 7;
			highIntensityBeamActive = false;
			plasmaBeamActive = false;
			plasmaBeamDamageBoost = 5;
			telescopicLenseActive = false;
			telescopicLenseSightRangeIncrease = 2 * 16;
			mysticalStrengthActive = false;
			mysticalStrengthDamageBonus = 3;
			mysticalConnectionActive = false;
			hardenedObsidianActive = false;
			hardenedObsidianArmorBonus = -0.1;
		case "Soul Subjugator":
			// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, all the generic variables need to be added here, 
			// in addition to the building specific variable
			// Generic Variables
			// Generic variables
			maxHP = 800;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 7 * 16;
			maxAmountOfThisBuildingAllowed = 1;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = false;
			objectAttackRange = 0 * 16;
			objectCombatAggroRange = 0; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 0;
			objectAttackDamageType = "";
			objectSlashResistance = 1;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.25;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			// Sprites
			currentSprite = spr_soul_subjugator_building;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			soulwellActive = false;
			break;
		case "Ritual Grounds":
			// Generic variables
			maxHP = 800;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 7 * 16;
			maxAmountOfThisBuildingAllowed = 1;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = false;
			objectAttackRange = 0 * 16;
			objectCombatAggroRange = 0; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 0;
			objectAttackDamageType = "";
			objectSlashResistance = 1;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.25;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			// Sprites
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			massEnslavementActive = false;
			break;
		case "Unholy Ziggurat":
			// Generic variables
			maxHP = 800;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 7 * 16;
			maxAmountOfThisBuildingAllowed = 1;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = false;
			objectAttackRange = 0 * 16;
			objectCombatAggroRange = 0; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 0;
			objectAttackDamageType = "";
			objectSlashResistance = 1;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.25;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			// Sprites
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			cyclingActive = false;
			break;
		case "Outpost":
			// Generic variables
			maxHP = 400;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 9 * 16;
			maxAmountOfThisBuildingAllowed = 12;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = true;
			objectAttackRange = 7 * 16;
			objectCombatAggroRange = 7; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 12;
			objectAttackDamageType = "Pierce";
			objectSlashResistance = 1;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.25;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			// Sprites
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			bonfireActive = false;
			bonfireSightRangeIncrease = 3 * 16;
			towerActive = false;
			towerAttackRangeIncrease = 2 * 16;
			towerAttackDamageIncrease = 2;
			towerSprite = noone;
			serratedArrowheadsActive = false;
			serratedArrowheadsDamageIncrease = 2;
			ironPlatingActive = false;
			ironPlatingArmorBonus = -0.1;
			fittedStoneActive = false;
			fittedStoneMaxHPBonus = 100;
			basicGarrisonActive = false;
			basicGarrisonUnitGarrisoned = false;
			basicGarrisonUnitTypeGarrisoned = "";
			basicGarrisonHealValue = 5;
			basicGarrisonArmorValue = -0.1;
			magicSpireActive = false;
			magicSpireMagicDamageBonus = 4;
			magicSpireSprite = noone;
			oilPotsAttackDamageIncrease = 2;
			brickAndMortarArmorBonus = -0.1;
			magicShieldingMaxHPBonus = 100;
			enhancedGarrisonActive = false;
			enhancedGarrisonUnitGarrisoned = false;
			enhancedGarrisonUnitTypeGarrisoned = "";
			enhancedGarrisonDoubleAttackActive = false;
			enhancedGarrisonBoulderLaunchActive = false;
			enhancedGarrisonBoulderDamage = 40;
			enhancedGarrisonFireballActive = false;
			enhancedGarrisonFireballDamage = 35;
			enhancedGarrisonFireballRadius = 1 * 16;
			enhancedGarrisonFireballAttackSpeedBoost = 0.5 * room_speed; // This is a debuff because an addition of a positive number reduces the attack speed.
			break;
		case "Wall":
			// Generic variables
			maxHP = 400;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 2 * 16;
			maxAmountOfThisBuildingAllowed = 10000;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = false;
			objectAttackRange = 0 * 16;
			objectCombatAggroRange = 0; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 0;
			objectAttackDamageType = "";
			objectSlashResistance = 0.9;
			objectPierceResistance = 0.9;
			objectMagicResistance = 0.9;
			// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			// Sprites
			currentSprite = spr_building_small;
			sprite_index = currentSprite;
			mask_index = spr_16_16;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			stoneWallsActive = false;
			stoneWallsArmorBonus = -0.07; // Armor bonus here should only apply to basic damage types, to make magic damage powerful vs otherwise super tanky walls.
			stoneWallsMaxHPBonus = 50;
			stoneWallsSprite = noone;
			reinforcedWallsActive = false;
			reinforcedWallsArmorBonus = -0.13;// Armor bonus here should only apply to basic damage types, to make magic damage powerful vs otherwise super tanky walls.
			reinforcedWallsMaxHPBonus = 150;
			reinforcedWallsSprite = noone;
			ironWallsActive = false;
			ironWallsArmorBonus = -0.15;// Armor bonus here should only apply to basic damage types, to make magic damage powerful vs otherwise super tanky walls.
			ironWallsMaxHPBonus = 200;
			ironWallsSprite = noone;
			magicWallsActive = false;
			magicWallsArmorBonus = -0.25;// Armor bonus here should only apply to basic damage types, to make magic damage powerful vs otherwise super tanky walls.
			magicWallsMaxHPBonus = 300;
			magicWallsSprite = noone;
			break;
		#endregion
	}
}


