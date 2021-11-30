function team_struct(team_) constructor {
	cityHall = new _city_hall();
	team = team_;
	food = 0;
	wood = 0;
	gold = 0;
	rubies = 0;
	population = 0;
	age = 0;
	specialization = noone;
}

function _upgrade_stats() constructor {
	if argument_count != 20 {
		show_debug_message(string(argument[0]) + " provides the wrong number of arguments. It is currently providing " + string(argument_count));
		exit;
	}
	// string - The name of the upgrade
	name = argument[0];
	// string - Full description of the upgrade
	description = argument[1];
	// enum - What specialization the upgrade is available to
	upgradeTree = argument[2];
	// enum - What column the upgrade will go in on the UI when selecting the object
	upgradeType = argument[3];
	// enum - The order all upgrades for this object are unlocked in.
	upgradeOrder = argument[4];
	// enum - If multiple upgrades can be obtained at the same time, they'll be listed as siblings.
	upgradeSibling = argument[5];
	// boolean - Whether the upgrade is active
	upgradeActive = argument[6]
	// boolean - Whether the upgrade is currently being unlocked.
	upgradeBeingUnlocked = false;
	// integer - The age requirement for the upgrade to be unlocked, beginning at age 0.
	upgradeAgeRequirement = argument[7]
	// boolean - Whether the upgrade is available to unlock.
	upgradeAvailableToUnlock = argument[8];
	// sprite ID or noone - The sprite of the icon respresenting this upgrade
	sprite = argument[9];
	// object ID or string - The object the upgrade is available on.
	upgradeAvailableOn = argument[10];
	// object ID or string - The object the upgrade applies to.
	upgradeAvailableFor = argument[11];
	// string - The specific stat, usually the variable name, the upgrade applies to.
	// This string can be a list of stats, separated by the word " and ".
	statsToUpgrade = argument[12];
	// string or noone - the menu the upgrade should open when clicked on
	menuToOpen = argument[13];
	// integer or string - The value the stat should be incremented up by. All stats are numerical or 
	// boolean.
	upgradeValueToAddToCurrentStat = argument[14];
	// integer - The time, given in seconds, the upgrade takes to complete.
	upgradeStartTime = room_speed * argument[15];
	// integer - The time, in seconds, the upgrade's current countdown is at. Incremented downwards to 0.
	upgradeCurrentTime = room_speed * argument[15];
	// integer - The food resource cost to begin the upgrade.
	upgradeFoodCost = argument[16];
	// integer - The wood resource cost to begin the upgrade.
	upgradeWoodCost = argument[17];
	// integer - The gold resource cost to begin the upgrade.
	upgradeGoldCost = argument[18];
	// integer - The ruby resource cost to begin the upgrade.
	upgradeRubyCost = argument[19];
}

function _city_hall() constructor {
	discovery = new _upgrade_stats("Discovery", "Upgrades to the first Age, unlocking your chosen specialization and additional upgrades.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.noone,
				false, 0, true, noone, "City Hall", "Player" /*available for the player[i].age struct value,
				set below.*/, "age", "Choose Specialization", 1, 30, 250, 150, 200, 0);
	foundations = new _upgrade_stats("Discovery", "Increases the pierce and slash armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1,  true, noone, "City Hall", obj_building, "objectSlashResistance and objectPierceResistance", 
				noone, "-0.15 and -0.1" /*resistance is a decimal multiplier between 0 to 1, 0 being full damage
				resisted and 1 being full damage taken*/, 45, 0, 200, 150, 0);
	parapets = new _upgrade_stats("Parapets", "Increases the damage of all buildings with offensive capabilities.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1, true, noone, "City Hall", obj_building, "objectAttackDamage", noone, 5, 30, 0, 
				50, 200, 0);
	farming = new _upgrade_stats("Farming", "Unlocks the farm structure and allows it to be built by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.a,
				false, 1, true, noone, "City Hall", "Worker", "canBuildFarm", noone, 1, 60, 200, 200, 0, 
				0);
	
}

/*
	- On spawn, the new unit or building needs to loop through the struct location in player[i] and apply 
	all currently active upgrades to it's stats.
	- On upgrade COMPLETION, need to loop through all objects the stat upgrade applies to and apply that 
	upgrade to all of those applicable objects.
	- count_down_timers script needs to count down any timers created in player[i] struct located at 
	xxx.upgradeCurrentTime that have their xxx.upgradeBeingUnlocked variable set to true. If the player 
	cancels that upgrade, xxx.upgradeBeingUnlocked needs to be set to false and xxx.upgradeCurrentTime 
	needs to be set back to xxx.upgradeStartTime.
	- everytime a new upgrade is achieved, xxx.upgradeAvailableToUnlock needs to be re-evaluated by each 
	stat in that same object struct. if xxx.upgradeAgeRequirement is met and previous numerical upgrades 
	to its own xxx.upgradeOrder are active for that building, then xxx.upgradeAvailableToUnlock is set 
	to true.
	- if xxx.menuToOpen is not set to noone, the string provided needs to be evaluated and the correct 
	menu needs to open.
	- each xxx.statsToUpgrade needs to be evaluated for a " and " string located inside, and for each one 
	found, the previous and subsequent string need to be evaluated as stats adjusted.
		- if xxx.statsToUpgrade is found to have an " and " string located inside, 
		  xxx.upgradeValueToAddToCurrentStat will also be set as a string and have an
		  " and " string located inside. Each of those numbers needs to be converted to
		  an integer type and increment the respective stat listed in xxx.statsToUpgrade

*/


