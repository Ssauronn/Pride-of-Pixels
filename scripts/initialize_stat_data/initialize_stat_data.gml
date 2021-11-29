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

function _city_hall() constructor {
	discovery = new _upgrade_stats("Discovery", "Upgrades to the first Age, unlocking your specialization and additional upgrades.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.noone,
				true, noone, "City Hall", "Player" /*available for the player[i].age struct value, set below.*/, 
				"age", "Choose Specialization", 1, room_speed * 30, 250, 150, 200, 0);
}

function _upgrade_stats() constructor {
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
	// boolean - Whether the upgrade is available to unlock.
	upgradeAvailableToUnlock = argument[6];
	// sprite ID or noone - The sprite of the icon respresenting this upgrade
	sprite = argument[7];
	// object ID - The object the upgrade is available on.
	upgradeAvailableOn = argument[8];
	// object ID or string - The object the upgrade applies to.
	upgradeAvailableFor = argument[9];
	// string - The specific stat, usually the variable name, the upgrade applies to.
	statToUpgrade = argument[10];
	// string or noone - the menu the upgrade should open when clicked on
	menuToOpen = argument[11];
	// integer - The value the stat should be incremented up by. All stats are numerical or boolean.
	upgradeValueToAddToCurrentStat = argument[12];
	// integer - The time, in seconds, the upgrade takes to complete.
	upgradeTime = argument[13];
	// integer - The food resource cost to begin the upgrade.
	upgradeFoodCost = argument[14];
	// integer - The wood resource cost to begin the upgrade.
	upgradeWoodCost = argument[15];
	// integer - The gold resource cost to begin the upgrade.
	upgradeGoldCost = argument[16];
	// integer - The ruby resource cost to begin the upgrade.
	upgradeRubyCost = argument[17];
}


