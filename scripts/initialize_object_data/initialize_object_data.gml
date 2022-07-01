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
			movementSpeed = 1;
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
			movementSpeed = 1;
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
			movementSpeed = 1;
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
			spriteWaitTimer = 0;
			movementLeaderOrFollowing = noone;
			mask_index = spr_16_16;
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 8 / room_speed;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Rogue":
			ambushBonusDamage = 50;
			piercingStrikeActive = false;
			// Armor is a decimal value from 0 to 1, used to multiply against damage. The lower the value,
			// the higher the armor. So penetration temporarily adds to the armor, to increase the damage
			// taken by the target (when using the Ambush ability in this case).
			piercingStrikePenetration = 0.25;
			break;
		// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
		case "Wizard":
			// Generic variables
			maxHP = 100;
			currentHP = maxHP;
			movementSpeed = 1.5;
			objectIsRubyUnit = true;
			objectSightRange = 7 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			singedCircuitActive = false;
			wizardsCanLink = false;
			aoeLinkedSquareSize = 2;
			arcaneWeaponActive = false;
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false;
			arcaneArmorBonus = -0.15;
			// Combat variables
			objectAttackRange = 16 * 4;
			objectCombatAggroRange = 10; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
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
			objectCombatSpecializationTarget = noone;
			objectCombatSpecializationDuration = 5 * room_speed;
			objectCombatSpecializationTimer = 0;
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
			maxHP = 100;
			currentHP = maxHP;
			movementSpeed = 1.5;
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
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false;
			arcaneArmorBonus = -0.15;
			// Combat variables
			objectAttackRange = 16 * 5;
			objectCombatAggroRange = 10; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 10;
			objectAttackDamageType = "Magic";
			objectSpecialAttackCooldown = 10 * room_speed;
			objectSpecialAttackTimer = 0;
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
			movementSpeed = 1.5;
			objectIsRubyUnit = true;
			objectSightRange = 7 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			acolytesCanLink = false;
			aoeLinkedSquareSize = 2;
			acolyteBlessedAuraActive = false;
			acolyteSearingFieldActive = false;
			arcaneWeaponActive = false;
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false;
			arcaneArmorBonus = -0.15;
			// Combat variables
			objectAttackRange = 16 * 8;
			objectCombatAggroRange = 10; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
				// For Acolytes, attack speed and damage are how fast and how much it heals allies.
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 15;
			objectAttackDamageType = "Magic";
				// For Acolytes, special attack speed and damage are how fast and how much it heals itself.
			objectSpecialAttackDamage = 10;
			objectSpecialAttackDamageType = "Magic";
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
			movementSpeed = 1.5;
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
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false;
			arcaneArmorBonus = -0.15;
			// Combat variables
			objectAttackRange = 16 * 1;
			objectCombatAggroRange = 10; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 10;
			objectAttackDamageType = "Magic";
			objectSpecialAttackDisableDuration = 60 * room_speed;
			objectCombatSpecializationAttackDamage = 250;
			objectCombatSpecializationAttackDamageType = "Magic";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.25;
			objectPierceResistance = 1;
			objectMagicResistance = 0.95;
			// Sprite setting array
			unitSprite[unitAction.idle][unitDirection.right] = spr_subverter_right_idle;
			unitSprite[unitAction.idle][unitDirection.up] = spr_subverter_back_idle;
			unitSprite[unitAction.idle][unitDirection.left] = spr_subverter_left_idle;
			unitSprite[unitAction.idle][unitDirection.down] = spr_subverter_front_idle;
			unitSprite[unitAction.move][unitDirection.right] = spr_subverter_right_walk;
			unitSprite[unitAction.move][unitDirection.up] = spr_subverter_back_walk;
			unitSprite[unitAction.move][unitDirection.left] = spr_subverter_left_walk;
			unitSprite[unitAction.move][unitDirection.down] = spr_subverter_front_walk;
			unitSprite[unitAction.attack][unitDirection.right] = spr_subverter_right_attack;
			unitSprite[unitAction.attack][unitDirection.up] = spr_subverter_back_attack;
			unitSprite[unitAction.attack][unitDirection.left] = spr_subverter_left_attack;
			unitSprite[unitAction.attack][unitDirection.down] = spr_subverter_front_attack;
			unitSprite[unitAction.specialAttack][unitDirection.right] = spr_subverter_right_attack;
			unitSprite[unitAction.specialAttack][unitDirection.up] = spr_subverter_back_attack;
			unitSprite[unitAction.specialAttack][unitDirection.left] = spr_subverter_left_attack;
			unitSprite[unitAction.specialAttack][unitDirection.down] = spr_subverter_front_attack;
			// Actual Sprite Value
			currentAction = unitAction.idle;
			currentDirection = unitDirection.right;
			currentSprite = unitSprite[currentAction][currentDirection];
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
			maxHP = 100;
			currentHP = maxHP;
			movementSpeed = 1.5;
			objectIsRubyUnit = true;
			objectSightRange = 8 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = false;
			objectCanUseCombatSpecializationAbility = false;
			abominationsCanSacrifice = false;
			bodyPartsProvideStats = false;
			arcaneWeaponActive = false;
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false;
			arcaneArmorBonus = -0.15;
			// Combat variables
			objectAttackRange = 16 * 1;
			objectCombatAggroRange = 10; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 30;
			objectAttackDamageType = "Magic";
			objectSpecialAttackDamage = 50;
			objectSpecialAttackDamageType = "Magic";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 1.25;
			objectPierceResistance = 1;
			objectMagicResistance = 0.95;
			// Sprite setting array
			// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED. In this case, I need to
			// adjust the sprites so that the three body parts of the Abomination are synced
			// and play animations in unison. I also need to add stat variables that are
			// set by the body parts and add said stats to the Abomination.
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
			maxHP = 100;
			currentHP = maxHP;
			movementSpeed = 1.5;
			objectIsRubyUnit = true;
			objectSightRange = 6 * 16;
			// Availability variables
			objectHasSpecialAbility = true;
			objectCanUseSpecialAbility = false;
			objectSpecialAbilityUpgraded = false;
			objectHasCombatSpecializationAbility = true;
			objectCanUseCombatSpecializationAbility = false;
			automatonsCanShocktrooper = false;
			chronicEmpowermentPossible = false;
			chronicEmpowermentActive = -1; // This is the timer variable. Whenever this is active, Automaton's damage output is multiplied by the below variable.
			chronicEmpowermentBonus = 1.25; // This is a multiplier to be used with Automaton's damage output
			arcaneWeaponActive = false;
			arcaneWeaponBonus = 1.15;
			arcaneArmorActive = false;
			arcaneArmorBonus = -0.15;
			// Combat variables
			objectAttackRange = 16 * 1;
			objectCombatAggroRange = 10; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 2 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 30;
			objectAttackDamageType = "Magic";
			objectSpecialAttackDamage = 50;
			objectSpecialAttackDamageType = "Magic";
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
			objectSightRange = 10 * 16;
			// The distance at which attacks can used, in pixels
			objectAttackRange = 16 * 8;
			canAttack = true;
			// Combat variables
			// The distance at which the object will aggro to enemies, in 16x16 block units
			objectCombatAggroRange = 8;
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
			// In this case, all the generic variables need to be added here, 
			// in addition to the building specific variable
			// Generic Variables
			
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
			objectSightRange = 10 * 16;
			
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
			
			// Specific Variables
			soulwellActive = false;
			break;
		case "Ritual Grounds":
			
			// Specific Variables
			massEnslavementActive = false;
			break;
		case "Unholy Ziggurat":
			
			// Specific Variables
			cyclingActive = false;
			break;
		case "Outpost":
			
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


