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
	ogreHP = 55,
	werewolfMovementSpeed = 2 * (1 / 3),
	robotAttackDamage = 13
}

/// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
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
			maxHP = 700;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 6 * 16;
			
			// Path setting variables
			returnToResourceX = noone;
			returnToResourceY = noone;
			returnToResourceID = noone;
			returnToResourceType = noone;
			returnToResourceDropPointID = noone;
			
			// Special Ability Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSkillfulUpgradeActive = false; // Laboratory Innovation 1
			// This is a multiplier to be used with the collection speed of all resources,
			// effectively reducing the time it takes to chop, or farm, or mine a resource
			// by a percentage equal to the difference between the value below and 1. I.e.,
			// if the value below is 0.85, the collection speed of all resources will be
			// increased by 15%.
			objectSkillfulUpgradeSupportMultiplier = 0.85;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			
			// Various Capability Variables
			movementSpeedBonusAvailable = false; // Storehouse Special 2a
			movementSpeedBonus = 1;
			movementSpeedBonusActive = false;
			randomBasicResourceGenerationActive = false; // Storehouse Special 2b
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
			canMineRuby = false; // Storehouse Special 1
			
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
			// Resource gathering variables (exclusive to obj_worker)
			maxResourceWeightCanCarry = 40;
			currentResourceWeightCarry = 0;
			objectWoodChopSpeed = 2.5 * room_speed; // Wood
			objectWoodChopSpeedTimer = 0; // Wood
			objectWoodChopDamage = 3; // Wood
			currentWoodCarry = 0;
			objectFoodGatherSpeed = 2 * room_speed; // Food
			objectFoodGatherSpeedTimer = 0; // Food
			objectFoodGatherDamage = 5; // Food
			currentFoodCarry = 0;
			objectGoldMineSpeed = 3 * room_speed; // Gold
			objectGoldMineSpeedTimer = 0; // Gold
			objectGoldMineDamage = 3; // Gold
			currentGoldCarry = 0;
			objectRubyMineSpeed = 5 * room_speed; // Ruby
			objectRubyMineSpeedTimer = 0; // Ruby
			objectRubyMineDamage = 2; // Ruby
			currentRubyCarry = 0;
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
			
			/// Specific Variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
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
			
			// Special Ability Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			enrageActive = false; // Special Ability
			enrageDamageBonus = 10;
			enrageCooldown = 20 * room_speed;
			enrageCooldownTimer = -1;
			enrageDuration = 6 * room_speed;
			enrageDurationTimer = -1;
			objectSkillfulUpgradeActive = false; // Laboratory Innovation 1
			// This is a value to be added to the variable enrageDamageBonus. E.g., if the variable
			// below is set to 1, enrageDamageBonus should have the value below added to it, to set 
			// the total enrageDamageBonus value to it's original value plus 1.
			objectSkillfulUpgradeRecklessnessEnhancement = 4;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false
			recklessLeapActive = false; // Combat Specialization Ability
			recklessLeapDamage = 30;
			recklessLeapRange = 4 * 16;
			recklessLeapCooldown = 12 * room_speed;
			recklessLeapCooldownTimer = -1;
			recklessLeapInAirDuration = 0.75 * room_speed;
			recklessLeapInAirTimer = -1;
			
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
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
			
			// Special Ability Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			// Morale Boost is a special ability available to all players from the
			// Barracks upgrade tree which increases the damage of all units in range of
			// the friendly Soldier by the amount given below, and same thing goes for 
			// the range.
			// The value is lower than most other damage values because it is a passive
			// damage bonus that applies to all units within range with no cooldown
			// and no downtime, while stacking.
			moraleBoostActive = false;
			moraleBoostDamageBonus = 1;
			moraleBoostRange = 3 * 16;
			objectSkillfulUpgradeActive = false; // Laboratory Innovation 1
			// This is a value to be added to the variable moraleBoostDamageBonus.
			// E.g., if the variable below is set to 1, then moraleBoostDamageBonus
			// will be increased by 1, totalling the object's base damage, plus
			// moraleBoostDamageBonus's additional damage, plus this variables
			// additional 1 damage.
			objectSkillfulUpgradeSwarmDamageEnhancement = 0.5;
			objectSkillfulUpgradeSwarmRangeEnhancement = 1 * 16;
			objectCourageUpgradeActive = false; // Barracks Offensive 2c
			// This is a value to be added to the variable moraleBoostDamageBonus.
			// E.g., if the variable below is set to 1, then moraleBoostDamageBonus
			// will be increased by 1, totalling the object's base damage, plus
			// moraleBoostDamageBonus's additional damage, plus this variables
			// additional 1 damage.
			objectCourageUpgradeDamageEnhancement = 0.5;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
			break;
		case "Knight":
			// Generic variables
			maxHP = 250;
			currentHP = maxHP;
			baseMovementSpeed = 0.5;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 6 * 16;
			
			// Special Ability Availability variables
			objectHasSpecialAbility = true; // Special ability
			objectCanUseSpecialAbility = false;
			shieldingAuraActive = false; // Special Ability
			shieldingAuraCooldown = 25 * room_speed;
			shieldingAuraCooldownTimer = -1;
			shieldingAuraDuration = 5 * room_speed;
			shieldingAuraDurationTimer = 5 * room_speed;
			shieldingAuraRadius = 4 * 16;
			// For resistance enhancements, these are subtractors to be used in conjunction with
			// the object's resistances while in range of the Knight and while Shielding Aura is
			// active. As resistances are multipliers and get stronger the closer to 0 they get, 
			// these being subtractors means all friendly units within range of Shielding Aura 
			// have their resistances effectively increased. E.g., if shieldingAuraSlashResistanceEnhancement
			// is set to 0.1 and a friendly object within range has their base slash resistance at
			// 0.75, their resistance is now set to 0.65 while in range of Shielding Aura and all
			// incoming damage is multiplied against 0.65, reducing damage taken by slash damage by
			// a *further* 10% on top of the 25% base slash resistance the object already had.
			shieldingAuraSlashResistanceEnhancement = 0.2;
			shieldingAuraPierceResistanceEnhancement = 0.2;
			shieldingAuraMagicResistanceEnhancement = 0.1;
			objectSkillfulUpgradeActive = false; // Laboratory Innovation 1
			// This is a value to be added to the variables
			// shieldingAura[Slash/Pierce/Magic]ResistanceEnhancement. As those
			// variables increase resistances as they go up (read their description
			// for details), adding the variable below to the listed variables will
			// increase the effective resistance while Shielding Aura is active. E.g.,
			// if this variable is set to 0.05, then all resistances of all friendly
			// units within range that are affected by Shielding Aura will be increased 
			// by an additional 5%.
			// Read descriptions of the listed variables, as well as descriptions of 
			// base resistances, for additional information on how this is calculated.
			objectSkillfulUpgradeRalliedDamageEnhancement = 0.05;
			objectSkillfulUpgradeRalliedRangeEnhancement = 1 * 16;
			objectCourageUpgradeActive = false; // Barracks Offensive 2c
			objectCourageUpgradeResistanceEnhancement = 0.1;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			nanobotEncasementActive = false; // Combat Specialization Ability
			nanobotEncasementCooldown = 30 * room_speed;
			nanobotEncasementCooldownTimer = 0;
			nanobotEncasementDuration = 5 * room_speed;
			nanobotEncasementDurationTimer = 0;
			// The HP of the nanobot encasement. Any incoming damage to the Knight while
			// nanobot encasement is active is instead dealt to the nanobot encasement
			// first. Once the encasement's HP hits 0 it disappears. Damage does NOT carry
			// over, meaning if the encasement's HP is at 1 and it takes 100 damage, the
			// Knight still does not take any damage.
			nanobotEncasementMaxHealth = 40;
			
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
			break;
		case "Ranger":
			// Generic variables
			maxHP = 100;
			currentHP = maxHP;
			baseMovementSpeed = 1;
			currentMovementSpeed = baseMovementSpeed;
			objectIsRubyUnit = false;
			objectSightRange = 9 * 16;
			
			// Special Ability Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSkillfulUpgradeActive = false; // Laboratory Innovation 1
			// This is a value to be added to objectAttackDamage, which is the Ranger's
			// base damage. This is simply a flat increase at all times to the base 
			// damage of Rangers once the upgrade is unlocked at the Laboratory.
			objectSkillfulUpgradeRangeTrainingEnhancement = 3;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			
			// Various Capability Upgrades
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
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
			
			// Special Ability Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			isInvisible = false;
			ambushDamageBonus = 50;
			objectSkillfulUpgradeActive = false; // Laboratory Innovation 1
			// This is a value to be added to the variable ambushDamageBonus. E.g., if the variable
			// below is set to 20, ambushDamageBonus should have the value below added to it, to set 
			// the total ambushDamageBonus value to it's original value plus 20.
			objectSkillfulUpgradeViciousEnhancement = 20;
			piercingStrikeActive = false; // Barracks Offensive 2a
			// Armor is a decimal value from 0 to 1, or higher, used to multiply against damage. The lower the value,
			// the higher the armor. So penetration is temporarily multiplied with the armor multiplier, to
			// increase the damage taken by the target (when using the Ambush ability in this case). E.g. if
			// piercingStrikePenetration is set to 1.5, and the target's pierce armor is 0.5, the target now takes
			// 1.5x damage, or (1.5 * 0.5 = 0.75).
			piercingStrikePenetration = 1.5;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			assassinInvisibilityResetAvailable = false;
			assassinInvisibilityResetCooldown = room_speed * 15;
			assassinInvisibilityResetCooldownTimer = 0;
			
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
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
			
			// Special Ability Availability variables
			// Special Ability in this case is Wizard's Fireball ability, which is always unlocked by default.
			// To be crystal clear, this is different than the Wizard's basic attack, which is a series of 3
			// arcane missiles launched slightly offset from one another at the Wizard's target, all guaranteed
			// to hit.
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = true;
			objectSkillfulUpgradeActive = false;
			objectSpecialAttackDamage = 50;
			objectSpecialAttackAreaOfEffectUnitDamage = 50;
			objectSpecialAttackAreaOfEffectBuildingDamage = 100;
			objectSpecialAttackDamageType = "Magic";
			objectSpecialAttackCooldown = 10 * room_speed;
			objectSpecialAttackCooldownTimer = 0;
			// Singed Circuit is an unlocked passive that reduces the cooldown of the Wizard's special
			// ability if it hits enough targets with a cast of that special ability.
			singedCircuitActive = false; // Temple Innovation 3a
			singedCircuitSpecialAttackCooldownReduction = 5 * room_speed;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			// The Wizard's combat specialization ability Redirect is to redirect damage received by a chosen
			// target to a nearby Knight in combat. If there are no Knights nearby, the damage is instead
			// redirected to the Wizard.
			redirectAbilityActive = false;
			redirectCooldown = 20 * room_speed;
			redirectCooldownTimer = -1;
			redirectRange = 6 * 16;
			redirectKnightInRange = false;
			redirectKnightTarget = noone;
			redirectProtectTarget = noone;
			redirectProtectMultiplier = 0.7;
			redirectDuration = 5 * room_speed;
			redirectDurationTimer = -1;
			
			// Various Capability Upgrades
			wizardsCanLink = false; // Temple Innovation 2a
			wizardIsLinked = false;
			aoeLinkedSquareSize = 2;
			arcaneWeaponActive = false; // Laboratory Offensive 2
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false; // Laboratory Defensive 2
			// Because armor is a multiplier, the lower it is (closer to 0) the better. Meaning this is added to the magic
			// armor of the unit in question to lower the resistance multiplier *value*, thereby increasing the resistance's
			// *overall reduction*.
			arcaneArmorMagicArmorBonus = -0.15;
			
			// Combat variables
			objectAttackRange = 4 * 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 8; // Each magic missile deals this amount of damage, meaning because there are 3 in each attack volley, the Wizard's total damage is 3x this value.
			objectAttackDamageType = "Magic";
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
			soulwellActive = false;
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
			
			// Special Ability Availability variables
			// Special Attack is just summoning a demon. As it's the Warlock's signature ability, it's the only special
			// ability in the game that is unlocked by default.
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = true;
			objectSpecialAttackCooldown = 10 * room_speed;
			objectSpecialAttackCooldownTimer = 0;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			
			// Various Capability Upgrades
			// Enslavement makes Demons summoned permanent. By default they expire after a time limit set by the variable
			// summonedDemonsTimeLimit.
			summonedDemonsLimit = 1;
			// The time limit is determined by the Warlock and it's upgrades, but the timer itself is managed by the Demon that
			// is summoned. This greatly simplifies the way summons are handled. This is affected by the upgrade enslavement
			// found in the Temple, which removes the time limit and makes the Demons permanent.
			summonedDemonsTimeLimit = 10 * room_speed;
			summonedDemonsList = noone;
			// The range at which Demons will run back to their master's sides no matter what their current action was.
			summonedDemonsMaxTetherRange = 12 * 16;
			// Demons will immediately die if they exceed this distance from their master, no matter their current action.
			summonedDemonsMaxDeathRange = 15 * 16;
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			enslavementActive = false; // Temple Innovation 3b
			// Demons summoned by and bound to the Warlock by the Ritual Grounds structure will bind to the Warlock on their end
			// but will not be registered as soulbound to the Warlock on the Warlock's end. This is so that the Warlock can still
			// summon its regular amount of Demons when those specific Demons die without needing to wait for 20+ Demons to die
			// before casting its summon again.
			// If enslavement is active, then the variables summonedDemonsLimit should be set to enslavementDemonsLimit, to increase
			// the amount of Demons able to be summoned by the Warlock.
			enslavementDemonsLimit = 3;
			arcaneWeaponActive = false; // Laboratory Offensive 2
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false; // Laboratory Defensive 2
			// Because armor is a multiplier, the lower it is (closer to 0) the better. Meaning this is added to the magic
			// armor of the unit in question to lower the resistance multiplier *value*, thereby increasing the resistance's
			// *overall reduction*.
			arcaneArmorMagicArmorBonus = -0.15;
			objectSkillfulUpgradeActive = false; // Only applies to basic units, here to avoid issues calling variables
			
			// Combat variables
			objectAttackRange = 3 * 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 10;
			objectAttackDamageType = "Magic";
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
			soulwellActive = false;
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
			
			// Special and Combat Specialization Availability variables (none for Demon)
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectSkillfulUpgradeActive = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			
			// Various Capability Upgrades
			enslavementActive = false; // Temple Innovation 3b
			arcaneWeaponActive = false; // Laboratory Offensive 2
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false; // Laboratory Defensive 2
			// Because armor is a multiplier, the lower it is (closer to 0) the better. Meaning this is added to the magic
			// armor of the unit in question to lower the resistance multiplier *value*, thereby increasing the resistance's
			// *overall reduction*.
			arcaneArmorMagicArmorBonus = -0.15;
			// This is the time limit to determine how long the Demon should last before dying automatically if permanent pets 
			// aren't unlocked.
			// The time limit is determined by the Warlock and it's upgrades, but the timer itself is managed by the Demon that
			// is summoned. This greatly simplifies the way summons are handled.
			summonedDemonsTimeLimitTimer = -1;
			// If this is ever noone, the Demon will die shortly after. A Demon must always be attached to a Warlock.
			summonedDemonsSummonedByWarlockID = noone;
			// This countdown sits at 4 seconds. If the Warlock the Demon is attached to dies, this begins a countdown, and the
			// Demon dies at the end of the countdown.
			summonedDemonsDeathTimer = 4 * room_speed;
			// The range at which Demons will run back to their master's sides no matter what their current action was. Set by
			// the Warlock's parent variable by the same name, so this is by default set to -1.
			summonedDemonsMaxTetherRange = -1;
			// Demons will immediately die if they exceed this distance from their master, no matter their current action. Set by
			// the Warlock's parent variable by the same name, so this is by default set to -1.
			summonedDemonsMaxDeathRange = -1;
			
			// Combat variables
			objectAttackRange = 1 * 16;
			objectCombatAggroRange = 5; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0.5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 8;
			objectAttackDamageType = "Pierce";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.25;
			objectPierceResistance = 1.25;
			objectMagicResistance = 0.75;
			/// Sprite setting array
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
			/// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
			currentHeadSprite = noone;
			currentChestSprite = noone;
			currentLegsSprite = noone;
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			/// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			
			/// Specific variables
			// This is a standard variable for obj_unit, but I set it to false here because I do not want
			// players sacrificing Demons to the Unholy Ziggurat, since they're free units.
			canBeSacrificedToUnholyZiggurat = false;
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
			soulwellActive = false;
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
			
			// Special Ability Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			
			// Various Capability Upgrades
			acolytesCanLink = false; // Temple Innovation 2b
			acolyteIsLinked = false;
			aoeLinkedSquareSize = 2;
			acolyteBlessedAuraActive = false; // Temple Special 4a
			acolyteBlessedAuraRadius = 4 * 16;
			acolyteBlessedAuraMovementSpeedBonus = 0.25;
			acolyteSearingFieldActive = false; // Temple Special 4b
			acolyteSearingFieldRadius = 2 * 16;
			acolyteSearingFieldAoEDamage = 6;
			acolyteSearingFieldCooldown = 1 * room_speed;
			acolyteSearingFieldCooldownTimer = -1;
			arcaneWeaponActive = false; // Laboratory Offensive 2
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final heal for Acolytes after all other adjustments
			// have been made.
			arcaneWeaponBonus = 1.15;
			objectSkillfulUpgradeActive = false;
			arcaneArmorActive = false; // Laboratory Defensive 2
			// Because armor is a multiplier, the lower it is (closer to 0) the better. Meaning this is added to the magic
			// armor of the unit in question to lower the resistance multiplier *value*, thereby increasing the resistance's
			// *overall reduction*.
			arcaneArmorMagicArmorBonus = -0.15;
			
			// Combat variables - In Acolyte's case, they cannot attack, only heal, so these are healing values and apply
			// to friendly units.
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
			
			/// Special variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
			soulwellActive = false;
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
			
			// Special Ability Availability variables
			// The Subverter's special ability is unlocked by default, and allows it to take the appearance of another
			// unit. The Subverter does not gain any abilities of that unit, only the appearance.
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = true;
			// I need a script here that sets the Subverter's movement and idle sprite tables to the copied unit based
			// on the string given here. It also needs to reset the Subverter's sprites if it is attacked or the ability
			// is cancelled.
			subverterCopiedUnit = "";
			subverterCopyCooldown = 30 * room_speed;
			subverterCopyCooldownTimer = 0;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			// The Subverter's Combat Specialization Ability "Explode" is to explode itself and adjacent squares, dealing MASSIVE magic damage.
			explodeAttackDamage = 500;
			explodeAttackDamageType = "Magic";
			explodeAttackAoERadius = 2 * 16; // A range of 2 means only the adjacent squares will be affected.
			
			// Various Capability Upgrades
			preparationActive = false; // Temple Offensive 3b
			preparationDisableBonusTime = 10 * room_speed;
			arcaneWeaponActive = false; // Laboratory Offensive 2
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			objectSkillfulUpgradeActive = false;
			arcaneArmorActive = false; // Laboratory Defensive 2
			// Because armor is a multiplier, the lower it is (closer to 0) the better. Meaning this is added to the magic
			// armor of the unit in question to lower the resistance multiplier *value*, thereby increasing the resistance's
			// *overall reduction*.
			arcaneArmorMagicArmorBonus = -0.15;
			
			// Combat variables - Subverters can't attack normally, they entirely rely on deception.
			objectAttackRange = 1 * 16; // The range at which the Subverter can sabotage a building.
			disableDuration = 30 * room_speed;
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
			soulwellActive = false;
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
			
			// Special and Combat Specialization Ability Availability variables (none for Abomination)
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			
			// Various Capability Variables
			// Abominations being able to sacrifice changes the way Abominations are handled. When the player creates
			// an Abomination from body parts, it does not cost any resources. Additionally, the Laboratory has an
			// upgrade available that allows any unit killed by the player to have a chance to reward a free body part.
			abominationsCanSacrifice = false; // Temple Special 4a
			// Body part stats provided by each body part to make a full Abomination are provided in the enum
			// abominationBodyPartStats.
			bodyPartsProvideStats = false; // Temple Special 4b
			arcaneWeaponActive = false; // Laboratory Offensive 2
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			objectSkillfulUpgradeActive = false;
			arcaneArmorActive = false; // Laboratory Defensive 2
			// Because armor is a multiplier, the lower it is (closer to 0) the better. Meaning this is added to the magic
			// armor of the unit in question to lower the resistance multiplier *value*, thereby increasing the resistance's
			// *overall reduction*.
			arcaneArmorMagicArmorBonus = -0.15;
			
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
			
			/// Specific variables
			profaneSpeedActive = false;
			// Profane speed should be ADDED to the unit's movement speed
			profaneSpeedMovementBonus = 0.15;
			lifewellActive = false;
			soulwellActive = false;
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
			
			// Special Ability Availability variables
			objectHasSpecialAbility = false;
			objectCanUseSpecialAbility = false;
			
			// Combat Specialization Ability Availability variables
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			
			// Various Capability Variables
			// Chronic Empowerment is a damage boost that applies when the Automaton is teleported using the Shocktrooper
			// ability (Temple Innovation 2). The upgrade is applied to the player directly, hence why Shocktrooper doesn't
			// appear in Automaton stats.
			chronicEmpowermentPossible = false;
			chronicEmpowermentActive = false;
			chronicEmpowermentTimer = 10 * room_speed;
			chronicEmpowermentCooldown = 0;
			chronicEmpowermentBonus = 1.25; // This is a multiplier to be used with Automaton's damage output
			arcaneWeaponActive = false; // Laboratory Offensive 2
			// This is a multiplier, hence why its not just a value added to the unit damage to avoid bloat. Instead, 
			// this variable should be multiplied once against the final damage value of every unit before the damage
			// is applied.
			arcaneWeaponBonus = 1.15;
			objectSkillfulUpgradeActive = false;
			arcaneArmorActive = false; // Laboratory Defensive 2
			// Because armor is a multiplier, the lower it is (closer to 0) the better. Meaning this is added to the magic
			// armor of the unit in question to lower the resistance multiplier *value*, thereby increasing the resistance's
			// *overall reduction*.
			arcaneArmorMagicArmorBonus = -0.15;
			
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
			
			/// Special variables
			
			break;
		
		#endregion
		#region Buildings
		/// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "City Hall":
			// Generic variables
			maxHP = 2500;
			currentHP = maxHP;
			populationProvided = 25;
			objectSightRange = 13 * 16;
			maxAmountOfThisBuildingAllowed = 6;
			/// Combat variables
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
			// The variables used to spawn units with player set default aggressiveness levels and formations
			unitDefaultAggressiveness = "Aggressive";
			unitDefaultFormation = "Square";
			/// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			/// Sprites
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			
			break;
		case "Barracks":
			// Generic variables
			maxHP = 1250;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 10 * 16;
			maxAmountOfThisBuildingAllowed = 5;
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
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.25;
			// The variables used to spawn units with player set default aggressiveness levels and formations
			unitDefaultAggressiveness = "Aggressive";
			unitDefaultFormation = "Square";
			// Rally Point
			rallyPointX = x;
			rallyPointY = y + 32;
			// Sprites
			currentSprite = spr_building_large;
			sprite_index = currentSprite;
			mask_index = spr_48_48;
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
			/// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, all the generic variables need to be added here, 
			// in addition to the building specific variable
			/// Generic Variables
			maxHP = 2500;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 9 * 16;
			maxAmountOfThisBuildingAllowed = 10;
			/// Combat variables
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
			// The variables used to spawn units with player set default aggressiveness levels and formations
			unitDefaultAggressiveness = "Aggressive";
			unitDefaultFormation = "Square";
			/// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			/// Sprites
			baseTemple = spr_building_large;
			sprite_index = baseTemple;
			mask_index = spr_48_48;
			mp_grid_add_instances(movementGrid, self, true);
			
			/// Specific Variables
			canTrainRubyUnits = false;
			canTrainAbominations = false;
			canTrainAutomatons = false;
			headRecycled = "";
			chestRecycled = "";
			legsRecycled = "";
			bodyPartsAddedToTemple = false;
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
			objectAttackDamage = 0;
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
			break;
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
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			// Specific Variables
			lifewellActive = false;
			lifewellHealthBonus = 50;
			soulwellActive = false;
			soulwellHealthBonus = 75;
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
			massEnslavementActive = false; // Ritual Grounds Special 1b
			strengthOfXulActive = false;
			strengthOfXulDamageBonus = 4;
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
			profaneSpeedActive = false;
			lastUnitTypeSacrificed = "";
			break;
		case "Rail Gun":
			/// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, all the generic variables need to be added here, 
			// in addition to the building specific variable
			// Generic Variables
			maxHP = 1500;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 25 * 16;
			maxAmountOfThisBuildingAllowed = 1;
			/// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = true;
			objectAttackRange = objectSightRange;
			objectCombatAggroRange = 12; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 200;
			objectAttackDamageType = "Pierce";
			objectSlashResistance = 0.75;
			objectPierceResistance = 0.75;
			objectMagicResistance = 2;
			/// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			/// Sprites
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			/// Specific Variables
			// I DO NOT ADD the upgrade found in initialize_stat_data to Rail Gun, as the upgrade
			// for the Rail Gun is learned on the Temple and the stat is stored in player data
			railGunTurnSpeed = 90 / room_speed; // The amount the Rail Gun is allowed to turn per second in degrees. 90 / room_speed for this value means it can do 1 quarter turn every 1 second.
			railGunUnitsHitMax = 7; // The amount of units the Rail Gun can hit before the projectile finally stops.
			railGunDamageFallOffPerUnitHit = objectAttackDamage / railGunUnitsHitMax; // The amount of damage the Rail Gun's damage is reduced by for each unit beyond the first that it hits.
			railGunUnitsHitList = noone;
			break;
		case "Stasis Field":
			/// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, all the generic variables need to be added here, 
			// in addition to the building specific variable
			// Generic Variables
			maxHP = 1000;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 6 * 16;
			maxAmountOfThisBuildingAllowed = 1;
			/// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = false;
			objectAttackRange = objectSightRange;
			objectCombatAggroRange = 0; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 0;
			objectAttackDamageType = "";
			objectSlashResistance = 1.75;
			objectPierceResistance = 0.75;
			objectMagicResistance = 0.75;
			/// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			/// Sprites
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			/// Specific variables
			// I DO NOT ADD the upgrade found in initialize_stat_data to Stasis Field, as the upgrade
			// for the Stasis Field is learned on the Temple and the stat is stored in player data
			stasisFieldActive = false;
			stasisFieldCooldown = 60 * room_speed;
			stasisFieldCooldownTimer = -1;
			stasisFieldTargetRange = 75 * 16; // The range at which you can target a chosen location in a radius around the Stasis Field.
			stasisFieldTargetLocationX = -1;
			stasisFieldTargetLocationY = -1;
			stasisFieldTargetRadius = 3 * 16; // The radius of the circle that the Stasis Field will affect.
			stasisFieldTargetsHitList = noone;
			break;
		case "Launch Site":
			/// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, all the generic variables need to be added here, 
			// in addition to the building specific variable
			// Generic Variables
			maxHP = 1000;
			currentHP = maxHP;
			populationProvided = 0;
			objectSightRange = 6 * 16;
			maxAmountOfThisBuildingAllowed = 1;
			/// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			// The distance at which attacks can used, in pixels
			canAttack = false;
			objectAttackRange = objectSightRange;
			objectCombatAggroRange = 0; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 0 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 0;
			objectAttackDamageType = "";
			objectSlashResistance = 1.25;
			objectPierceResistance = 0.75;
			objectMagicResistance = 1.5;
			/// Rally Point
			rallyPointX = x + 32;
			rallyPointY = y + 32;
			/// Sprites
			currentSprite = spr_building_xlarge;
			sprite_index = currentSprite;
			mask_index = spr_64_64;
			//var floor_x_ = floor(x / 16) * 16;
			//var floor_y_ = floor(y / 16) * 16;
			//mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			mp_grid_add_instances(movementGrid, self, true);
			
			/// Specific variables
			// I DO NOT ADD the upgrade found in initialize_stat_data to Launch Site, as the upgrade
			// for the Launch Site is learned on the Temple and the stat is stored in player data
			launchSiteSalvoSent = false;
			// The total cooldown for the Orbital Bombardment power is the cooldown of the Salvo + the cooldown of the Orbital Bombardment.
			launchSiteSalvoCooldown = 20 * room_speed; // First the rocket salvo needs to be sent into space each time the player uses the Orbital Bombardment power
			launchSiteSalvoCooldownTimer = -1;
			launchSiteOrbitalBombardmentCooldown = 75 * room_speed; // The timer between when the player can use the Orbital Bombardment power. Only begins once the rocket salvo is sent.
			launchSiteOrbitalBombardmentCooldownTimer = launchSiteOrbitalBombardmentCooldown;
			launchSiteOrbitalBombardmentRadius = 3 * 16; // The radius of the circle that the Orbital Bombardment power will affect.
			launchSiteOrbitalBombardmentDamage = 300;
			launchSiteOrbitalBombardmentDamageTimesDealt = 3; // Orbital Bombardment deals duplicate damage equal to the amount given here, slightly spaced apart. This allows for an animation showing slightly offset rockets.
			launchSiteOrbitalBombardmentRepeatDamageCooldown = 5 / room_speed; // The amount of salvos that should land in the animation per second
			launchSiteOrbitalBombardmentRepeatDamageCooldownTimer = -1; // Play another animation of a rocket landing each time this timer ends, and repeat that animation until the count of damage dealt has reached it's max.
			launchSiteDroneSwarmCooldown = 45 * room_speed; // The time between when another Drone Swarm can be sent to the target location.
			launchSiteDroneSwarmCooldownTimer = -1;
			launchSiteDroneSwarmTargetRange = 40 * 16;
			launchSiteDroneSwarmTargetX = -1;
			launchSiteDroneSwarmTargetY = -1;
			launchSiteDroneSwarmRadius = 4 * 16; // The radius on which the Drone Swarm will affect
			launchSiteDroneSwarmBaseMovementSpeed = 5;
			launchSiteDroneSwarmCurrentMovementSpeed = 0;
			launchSiteDroneSwarmAcceleration = launchSiteDroneSwarmBaseMovementSpeed / (3 * room_speed); // Because Drone Swarms will rise first out of the Launch Site, and then fly away, they're given an initial acceleration.
			launchSiteDroneSwarmDuration = 15 * room_speed; // The amount in seconds a Drone Swarm will last on the map.
			launchSiteDroneSwarmDurationTimer = -1;
			launchSiteDroneSwarmDamage = 40 / room_speed; // The amount of damage the Drone Swarm deals per frame while any enemy is inside the swarm.
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
		case "Farm":
			
			break;
		case "Mine":
			
			break;
		#endregion
	}
}


