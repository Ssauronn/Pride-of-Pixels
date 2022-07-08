function team_struct(team_) constructor {
	// ADJUST AS MORE BUILDINGS ARE ADDED
	cityHall = new _city_hall();
	temple = new _temple();
	laboratory = new _laboratory();
	barracks = new _barracks();
	storehouse = new _storehouse();
	obelisk = new _obelisk();
	outpost = new _outpost();
	wall = new _wall();
	//farm = new _farm();
	//thicket = new _thicket();
	//mine = new _mine();
	team = team_;
	food = 0;
	wood = 0;
	gold = 0;
	rubies = 0;
	population = 0;
	age = 0;
	specialization = noone;
	flaskChosen = "";
	flaskCooldownTimer = 120 * room_speed;
	flaskCooldown = 0;
	flaskUpgraded = false;
	shocktrooperAvailable = false;
	shocktrooperCooldownTimer = 120 * room_speed;
	shocktrooperCooldown = 0;
	combatSpecializationChosen = "";
	
	obeliskUpgradeOneChosen = "";
	obeliskUpgradeTwoChosen = "";
	specialBuildingChosen = "";
	stasisRevealsTargets = false;
	droneSwarmUnlocked = false;
	
	abominationOgreHeadPartsStored = 0;
	abominationOgreChestPartsStored = 0;
	abominationOgreLegsPartsStored = 0;
	abominationRobotHeadPartsStored = 0;
	abominationRobotChestPartsStored = 0;
	abominationRobotLegsPartsStored = 0;
	abominationWerewolfHeadPartsStored = 0;
	abominationWerewolfChestPartsStored = 0;
	abominationWerewolfLegsPartsStored = 0;
	
	// This function is called in count_down_timers(), which itself is called and relevant code ran in each step
	// event of buildings and units (obj_building and obj_unit). So this function is built with the variables already
	// existing in those objects in mind. KEEP IN MIND, this is only activated once on a random unit or building. So I
	// still need to check all of that type. Its only activated once because timers for upgrades are contained in the
	// global struct player[i], which has only 1 timer for all of whatever object the upgrade is for.
	///@function			upgrade_stats();
	///@param				team_upgrading_				The team (integer) this upgrade applies to.
	///@param				upgrade_available_for_		The object (ID) or objectType (string) that this applies to.
	///@param				stats_to_upgrade_			The stat (string) or stats (string separated by " ") this upgrade applies to
	///@param				upgrade_values_to_add_		
	upgrade_stats = function(team_upgrading_, upgrade_available_for_, stats_to_upgrade_, upgrade_values_to_add_) {
		var player_being_upgraded_, unit_being_upgrade_, building_being_upgrade_;
		player_being_upgraded_ = false;
		unit_being_upgrade_ = false;
		building_being_upgrade_ = false;
		if is_string(upgrade_available_for_) {
			if upgrade_available_for_ == "Player" {
				player_being_upgraded_ = true;
			}
			else if objectType == upgrade_available_for_ {
				if object_index == obj_building {
					building_being_upgrade_ = true;
				}
				else if object_index == obj_unit {
					unit_being_upgrade_ = true;
				}
			}
		}
		if is_string(upgrade_available_for_) {
			if (objectType == upgrade_available_for_) && (objectRealTeam == team_upgrading_) {
				var current_stat_to_add_to_in_string_ = stats_to_upgrade_;
				var current_value_to_add_to_stat_in_string_ = upgrade_values_to_add_;
				var space_at_ = 0;
				// While there's still a space in the string, keep adding to the relevant variables, and continuing
				// onto the next substring. After all spaces have been eliminated, I add whatever the last value is
				// to the last variable, as the while statement won't do that before ending.
				while string_pos(" ", stats_to_upgrade_) != 0 {
					space_at_ = string_pos(" ", stats_to_upgrade_);
					// Take the first string of letters in this and isolate them.
					string_delete(current_stat_to_add_to_in_string_, space_at_, (string_length(current_stat_to_add_to_in_string_) - space_at_));
					// Now that the first string of letters in this is isolated, remove them from the origin string.
					string_delete(stats_to_upgrade_, 1, space_at_);
					// Repeat the same process with the current_value_to_add_to_stat_in_string_ and upgrade_values_to_add_.
					space_at_ = string_pos(" ", upgrade_values_to_add_);
					string_delete(current_value_to_add_to_stat_in_string_, space_at_, (string_length(current_value_to_add_to_stat_in_string_) - space_at_));
					string_delete(upgrade_values_to_add_, 1, space_at_);
			
					// Now that two respective strings (the stat to add to, and the value itself to add), add that value
					// to the stat.
					if player_being_upgraded_ {
						variable_struct_set(player[team_upgrading_], current_stat_to_add_to_in_string_, (variable_struct_get(player[team_upgrading_], current_stat_to_add_to_in_string_) + real(current_value_to_add_to_stat_in_string_)));
					}
					else if unit_being_upgrade_ {
						with obj_unit {
							if objectType == upgrade_available_for_ {
								variable_instance_set(self.id, current_stat_to_add_to_in_string_, (variable_instance_get(self.id, current_stat_to_add_to_in_string_) + real(current_value_to_add_to_stat_in_string_)));
							}
						}
					}
					else if building_being_upgrade_ {
						with obj_building {
							if objectType == upgrade_available_for_ {
								variable_instance_set(self.id, current_stat_to_add_to_in_string_, (variable_instance_get(self.id, current_stat_to_add_to_in_string_) + real(current_value_to_add_to_stat_in_string_)));
							}
						}
					}
					
					// Now that that's done, set the two temporary variables here to the origin values (which have now
					// been editted). If the origin values no longer have a space in it and thus the while statement exits,
					// I can just use the temporary variables now to set the last variable to the last correct value.
					current_stat_to_add_to_in_string_ = stats_to_upgrade_;
					current_value_to_add_to_stat_in_string_ = upgrade_values_to_add_;
				}
				// Now the the while statement has exited, I can add the last value to the last stat here.
				variable_struct_set(player[team_upgrading_], current_stat_to_add_to_in_string_, (variable_struct_get(player[team_upgrading_], current_stat_to_add_to_in_string_) + real(current_value_to_add_to_stat_in_string_)));
			}
		}
		// Else if the upgrade_available_for_ wasn't a string, it then applies to an object index, and I can blanket apply
		// the upgrade to that object index.
		else {
			if obj_building.object_index == upgrade_available_for_.object_index {
				with obj_building {
					if objectRealTeam == team_upgrading_ {
						variable_instance_set(self.id, stats_to_upgrade_, variable_instance_get(self.id, stats_to_upgrade_) + upgrade_values_to_add_);
					}
				}
			}
			else if obj_unit.object_index == upgrade_available_for_.object_index {
				with obj_unit {
					if objectRealTeam == team_upgrading_ {
						variable_instance_set(self.id, stats_to_upgrade_, variable_instance_get(self.id, stats_to_upgrade_) + upgrade_values_to_add_);
					}
				}
			}
		}
	}
}

function _upgrade_options() constructor {
	if argument_count != 23 {
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
	// This string can be a list of stats, separated by a space " ".
	statsToUpgrade = argument[12];
	// string or noone - the menu the upgrade should open when clicked on
	menuToOpen = argument[13];
	// integer or string - The value the stat should be incremented up by. All stats are numerical or
	// strings.
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
	// ID or noone - The ID of an object or struct that contains a secondary variable the current upgrade
	// in question is reliant on. Will be set to noone if none exists.
	upgradeSecondaryRequirementLocationID = argument[20];
	// string or noone - The variable located in the ID of the object or struct given above that contains
	// the value the current upgrade in question is reliant on. Will be set to noone if none exists.
	upgradeSecondaryRequirementVariable = argument[21];
	// anything or noone - The value of the secondary variable that the current upgrade in question is
	// reliant on. Will be set to noone if none exists.
	upgradeSecondaryRequirementValue = argument[22];
}

// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
// In this case, I need to add a constructor named after the building type for each building that
// can be upgraded or has upgrades available on it.

function _city_hall() constructor {
	statUpdated = false;
	discovery = new _upgrade_options("Discovery", "Upgrades to the first Age, unlocking your chosen specialization and additional upgrades.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.noone,
				false, 0, true, spr_discovery_icon, "City Hall", "Player" /*available for the
				player[i].age struct value, set below.*/, "age", "Age One", 1, 30, 250, 150, 200, 0, noone, noone, noone);
	foundations = new _upgrade_options("Foundations", "Increases the pierce and slash armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1,  false, noone, "City Hall", obj_building, "objectSlashResistance and objectPierceResistance", 
				noone, "-0.15 and -0.1" /*resistance is a decimal multiplier between 0 to 1, 0 being full damage
				resisted and 1 being full damage taken*/, 45, 0, 200, 150, 0, noone, noone, noone);
	parapets = new _upgrade_options("Parapets", "Increases the damage of all buildings with offensive capabilities.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1, false, noone, "City Hall", obj_building, "objectAttackDamage", noone, 5, 30, 0, 
				50, 200, 0, noone, noone, noone);
	farming = new _upgrade_options("Farming", "Unlocks the Farm structure and allows it to be built by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.a,
				false, 1, false, noone, "City Hall", "Worker", "canBuildFarm", noone, 1, 60, 200, 200, 0, 
				0, noone, noone, noone);
	// Drones is also available on the Storehouse building
	drones = new _upgrade_options("Drones", "Workers no longer need to drop Food, Wood, or Gold off at Storehouses.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 1, false, noone, "City Hall", "Worker", "canUseDrones", noone, 1, 30, 50, 50, 250, 
				0, noone, noone, noone);
	experimentation = new _upgrade_options("Experimentation", "Upgrades to the second Age, unlocking additional upgrades.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 1, false, noone, "City Hall", "Player", "age", "Age Two", 1, 120, 
				400, 500, 700, 0, noone, noone, noone);
	ramparts = new _upgrade_options("Ramparts", "Further increases the pierce and slash armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "City Hall", obj_building, "objectSlashResistance and objectPierceResistance", 
				noone, "-0.1 and -0.1", 30, 0, 500, 300, 0, noone, noone, noone);
	thickets = new _upgrade_options("Thickets", "Unlocks the Thicket structure and allows it to be built by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "City Hall", "Worker", "canBuildThicket", noone, 1, 30, 200, 300, 
				100, 0, noone, noone, noone);
	// Drilling is also available on the Storehouse building
	drilling = new _upgrade_options("Drilling", "Allows Workers to mine Rubies", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.a, 
				false, 2, false, noone, "City Hall", "Worker", "canMineRuby", noone, 1, 45, 0, 0, 800, 0, noone, noone, noone);
	refinement = new _upgrade_options("Refinement", "Upgrades to the third Age, unlocking additional upgrades.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 2, false, noone, "City Hall", "Player", "age", "Age Three", 1, 150, 300, 500, 
				500, 200, noone, noone, noone);
	bastion = new _upgrade_options("Bastion", "Further increases the pierce and slash armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 3, false, noone, "City Hall", obj_building, "objectSlashResistance and objectPierceResistance", 
				noone, "-0.1 and -0.1", 30, 0, 600, 400, 100, noone, noone, noone);
	shielding = new _upgrade_options("Shielding", "Increases the magic armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.four, eUpgradeSibling.noone, 
				false, 3, false, noone, "City Hall", obj_building, "objectMagicResistance", noone, -0.1, 
				40, 300, 300, 300, 300, noone, noone, noone);
	ballroom = new _upgrade_options("Ballroom", "Each City Hall and House provides additional population.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.c, 
				false, 3, false, noone, "City Hall", "City Hall and House", "populationProvided", noone, "10 and 5", 80, 100, 
				100, 400, 100, noone, noone, noone);
	mines = new _upgrade_options("Mines", "Unlocks the Mine structure and allows it to be built by Workers", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.a, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildMine", noone, 1, 45, 200, 200, 
				400, 300, noone, noone, noone);
	soulSubjugator = new _upgrade_options("Soul Subjugator", "Unlocks the Soul Subjugator structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildSoulSubjugator", noone, 1, 90, 200, 
				200, 200, 200, noone, noone, noone);
	ritualGrounds = new _upgrade_options("Ritual Grounds", "Unlocks the Ritual Grounds structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildRitualGrounds", noone, 1, 90, 200, 
				200, 200, 200, noone, noone, noone);
	unholyZiggurat = new _upgrade_options("Unholy Ziggurat", "Unlocks the Unholy Ziggurat structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildUnholyZiggurat", noone, 1, 90, 200, 
				200, 200, 200, noone, noone, noone);
	railGun = new _upgrade_options("Rail Gun", "Unlocks the Rail Gun structure and allows it to be built by Workers.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildRailGun", noone, 1, 90, 200, 
				200, 200, 200, noone, noone, noone);
	stasisField = new _upgrade_options("Stasis Field", "Unlocks the Stasis Field structure and allows it to be built by Workers.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildStasisField", noone, 1, 90, 200, 
				200, 200, 200, noone, noone, noone);
	launchSite = new _upgrade_options("Launch Site", "Unlocks the Launch Site structure and allows it to be built by Workers.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildLaunchSite", noone, 1, 90, 200, 
				200, 200, 200, noone, noone, noone);
}
function _temple() constructor {
	statUpdated = false;
	rubyUnits = new _upgrade_options("Ruby Units", "Allows Ruby Units to be built.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Temple", obj_building, "canTrainRubyUnits", noone, 1, 60, 100, 
				100, 200, 50, noone, noone, noone);
	specialAbilities = new _upgrade_options("Special Abilities", "Unlocks Ruby Unit Special Abilities and allows them to be used in combat.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 2, true, noone, "Temple", "Ruby", "objectCanUseSpecialAbility", noone, 1, 60, 
				100, 0, 200, 0, noone, noone, noone);
	abominations = new _upgrade_options("Abominations", "Allows Abominations to be built.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 2, false, noone, "Temple", obj_building, "canTrainAbominations", noone, 1, 
				60, 100, 0, 200, 100, noone, noone, noone);
	automatons = new _upgrade_options("Automatons", "Allows Automatons to be built.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 2, false, noone, "Temple", obj_building, "canTrainAutomatons", noone, 1, 
				60, 100, 0, 200, 100, noone, noone, noone);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	subverterCombatSpecialAbilities = new _upgrade_options("Subverter Combat Special Abilities", "Unlocks the Combat Special Abilities for the Subverter.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 2, false, noone, "Temple", "Subverter", "objectCanUseCombatSpecializationAbility", 
				noone, 1, 60, 150, 50, 100, 100, "Player", "combatSpecializationChosen", "Stealth");
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	automatonCombatSpecialAbilities = new _upgrade_options("Automaton Combat Special Abilities", "Unlocks the Combat Special Abilities for the Automaton.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 2, false, noone, "Temple", "Automaton", "objectCanUseCombatSpecializationAbility", 
				noone, 1, 60, 150, 50, 100, 100, "Player", "combatSpecializationChosen", "Recklessness");
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	wizardCombatSpecialAbilities = new _upgrade_options("Wizard Combat Specialization Abilities", "Unlocks the Combat Special Abilities for the Wizard.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 2, false, noone, "Temple", "Wizard", "objectCanUseCombatSpecializationAbility", 
				noone, 1, 60, 150, 50, 100, 100, "Player", "combatSpecializationChosen", "Protectorate");
	ordained = new _upgrade_options("Ordained", "Acolyte healing is increased.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.a, 
				false, 2, false, noone, "Temple", "Acolyte", "outOfCombatHealValue and inCombatHealValue", 
				noone, "20 and 2", 45, 150, 0, 150, 0, noone, noone, noone);
	swiftFooted = new _upgrade_options("Swift Footed", "Subverters gain additional movement speed.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 2, false, noone, "Temple", "Subverter", "baseMovementSpeed", noone, 1, 45, 150, 0, 
				150, 0, noone, noone, noone);
	enlightened = new _upgrade_options("Enlightened", "Increases the damage of all Ruby Units.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Temple", "Ruby", "objectAttackDamage", noone, 8, 90, 
				50, 100, 150, 200, noone, noone, noone);
	hideArmor = new _upgrade_options("Hide Armor", "Increases the slash armor of Wizards and Warlocks.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.a, 
				false, 2, false, noone, "Temple", "Wizard and Warlock", "objectSlashResistance", noone, 
				-0.1, 60, 200, 0, 100, 0, noone, noone, noone);
	cover = new _upgrade_options("Cover", "Increases the pierce armor of Subverters and Acolytes.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 2, false, noone, "Temple", "Subverter and Acolyte", "objectPierceResistance", noone, 
				-0.1, 60, 50, 200, 100, 0, noone, noone, noone);
	fireLinked = new _upgrade_options("Fire Linked", "Unlockes the Fire Link ability for Wiards, allowing three Wizards to link with each other. The group of Linked Wizards lose the ability to fight normally, but the player gains the ability to choose a location within a large range for all Fire Linked Wizards to attack. The Linked Wizards launch a volley of fireballs at the target location, dealing Magic damage to all enemies within that location. Long shared cooldown for all Linked Wizards.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 2, false, noone, "Temple", "Wizard", "wizardsCanLink", noone, 1, 90, 50, 
				0, 50, 100, noone, noone, noone);
	vitalityLinked = new _upgrade_options("Vitality Linked", "Unlocks the Vitality Link ability for Acolytes, allowing three Acolytes to link with each other. The group of Linked Acolytes lose the ability to fight and heal normally, but the player gains the ability to choose a location within a large range for all Vitality Linked Acolytes to heal. The Linked Acolytes infuse the area with healing magic, healing all friendly units within that location. Long shared cooldown for all Linked Acolytes.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 2, false, noone, "Temple", "Acolyte", "acolytesCanLink", noone, 1, 90, 50, 
				0, 50, 100, noone, noone, noone);
	shocktrooper = new _upgrade_options("Shocktrooper", "Unlocks the Shocktrooper ability for Automaton, allowing the player to teleport all Automatons not currently in combat to a location within a wide range of any friendly unit that is in combat. This ability has a long cooldown.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "Temple", "Player", "shocktrooperAvailable", noone, 1, 90, 
				100, 0, 100, 200, noone, noone, noone);
	fireball = new _upgrade_options("Singed Circuit", "Reduces the cooldown for the Wizard's Fireball special ability if it hits 2 or more targets with the area of effect, in addition to the primary target.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.a, 
				false, 3, false, noone, "Temple", "Wizard", "singedCircuitActive", noone, 1, 30, 
				0, 0, 200, 300, noone, noone, noone);
	enslavement = new _upgrade_options("Enslavement", "Demons summoned by Warlocks are now permanent. Demons will die if they wander too far from the Warlock that summoned them.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "Temple", "Warlock and Demon", "enslavementActive", noone, 1, 30, 
				0, 0, 200, 300, noone, noone, noone);
	sanctified = new _upgrade_options("Sanctified", "Acolyte's healing is increased.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.c, 
				false, 3, false, noone, "Temple", "Acolyte", "objectAttackDamage", noone, 10, 30, 
				250, 0, 0, 300, noone, noone, noone);
	empowered = new _upgrade_options("Empowered", "Increases the damage and healing of all Ruby Units.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 3, false, noone, "Temple", "Ruby", "objectAttackDamage", noone, 5, 60, 
				50, 350, 250, 300, noone, noone, noone);
	powerPotions = new _upgrade_options("Power Potions", "Increases the damage of Wizards, Warlocks, and Demons summoned by Warlocks.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.three, eUpgradeSibling.a, 
				false, 3, false, noone, "Temple", "Wizard and Warlock and Demon", "objectAttackDamage and objectSpecialAttackDamage", 
				noone, "10 and 5", 45, 50, 200, 100, 175, noone, noone, noone);
	preparation = new _upgrade_options("Preparation", "Increases the effectiveness of all Subverter effects on buildings.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "Temple", "Subverter", "objectSpecialAttackDisableDuration", 
				noone, 15 * room_speed, 45, 0, 200, 100, 175, noone, noone, noone);
	magicBarrier = new _upgrade_options("Magic Barrier", "Increases the magic armor of all Ruby units.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 3, false, noone, "Temple", "Ruby", "objectMagicResistance", noone, -0.1, 30, 
				50, 0, 300, 350, noone, noone, noone);
	thickenedSkin = new _upgrade_options("Thickened Skin", "Increases the slash armor of all Ruby units.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 3, false, noone, "Temple", "Ruby", "objectSlashResistance", noone, -0.1, 45, 
				50, 200, 300, 150, noone, noone, noone);
	slowingField = new _upgrade_options("Slowing Field", "Increases the pierce armor of all Ruby units.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.c, 
				false, 3, false, noone, "Temple", "Ruby", "objectPierceResistance", noone, -0.1, 45, 
				150, 150, 200, 150, noone, noone, noone);
	sacrifice = new _upgrade_options("Sacrifice", "Abominations can now be sacrificed at a Temple, which provides the player with the body parts the Abomination was created with. The player can then create Abominations with those body parts, thereby allowing the player to create Abominations with specific body parts.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.a, 
				false, 3, false, noone, "Temple", "Abomination", "abominationsCanSacrifice", noone, 1, 90, 
				150, 250, 400, 400, noone, noone, noone);
	frankensteins = new _upgrade_options("Frankensteins", "Abominations are now given bonuses depending on the parts they're created with. Each Werewolf part increases the movement speed of the Abomination. Each Robot part increases the damage of the Abomination. Each Ogre part increases the health of the Abomination.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.b, 
				false, 3, false, noone, "Temple", "Abomination", "bodyPartsProvideStats", noone, 1, 90, 
				300, 0, 500, 400, noone, noone, noone);
	soulwell = new _upgrade_options("Soulwell", "All Ruby units are granted addition health. Ruby units spawned with Soul Subjugator do not spawn with additional health.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.c, 
				false, 3, false, noone, "Temple", "Soul Subjugator", "soulwellActive", noone, 1, 
				120, 500, 0, 200, 600, noone, noone, noone);
	massEnslavement = new _upgrade_options("Mass Enslavement", "Warlocks now summon 3 Demons at once. The Warlock will not summon additional Demons until all 3 previous Demons are dead.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.c, 
				false, 3, false, noone, "Temple", "Ritual Grounds", "massEnslavementActive", noone, 1, 
				120, 500, 0, 200, 600, noone, noone, noone);
	cycling = new _upgrade_options("Cycling", "Any unit currently empowered by Unholy Ziggurat can be sacrificed at an Unholy Ziggurat to immediately recharge the Unholy Ziggurat to the charge level it was previously at, minus one charge level. No more than one unit empowered by Unholy Ziggurat may be sacrificed per use.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.c, 
				false, 3, false, noone, "Temple", "Unholy Ziggurat", "cyclingActive", noone, 1, 
				120, 500, 0, 200, 600, noone, noone, noone);
	blessedAura = new _upgrade_options("Blessed Aura", "Acolytes now increase the movement speed of themselves and all friendly units within range.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.a, 
				false, 3, false, noone, "Temple", "Acolyte", "acolyteBlessedAuraActive", noone, 1, 105, 
				0, 400, 500, 400, noone, noone, noone);
	searingField = new _upgrade_options("Searing Field", "Acolytes now have greater control over their nano tech and deal constant damage to all enemies within a medium range.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.b, 
				false, 3, false, noone, "Temple", "Acolyte", "acolyteSearingFieldActive", noone, 1, 120, 
				200, 200, 600, 500, noone, noone, noone);
	// If the Rail Gun is chosen as the Technology tree's final building unlock:
	handheldRailGun = new _upgrade_options("Handheld Rail Guns", "Rangers are given Handheld Rail Guns. Their shots now over-penetrate targets and deal damage to enemies behind their target. However, their attack speed is reduced.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.c, 
				false, 3, false, noone, "Temple", "Ranger", "handheldRailGunActive and objectAttackSpeed", noone, "1 and 90", 
				/*The value "90" in the previous argument is the amount of frames that the objectAttackSpeed is increased by*/
				120, 200, 400, 600, 400, "Player", "specialBuildingChosen", "Rail Gun");
	// If the Stasis Field is chosen as the Technology tree's final building unlock:
	revealingStasis = new _upgrade_options("Revealing Stasis", "You reveal any invisible units on the location that your Stasis Field is effecting for its duration.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.c, 
				false, 3, false, noone, "Temple", "Player", "stasisRevealsTargets", noone, 1, 120, 
				250, 250, 250, 250, "Player", "specialBuildingChosen", "Stasis Field");
	// If the Launch Site is chosen as the Technology tree's final building unlock:
	droneSwarm = new _upgrade_options("Drone Swarm", "Choose any location on the map to deploy a swarm of Drones to. Drones spawn at your Launch Site, move extremely fast, and deal high damage, but have extremely low health. This ability is on a long cooldown.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.c, 
				false, 3, false, noone, "Temple", "Player", "droneSwarmUnlocked", noone, 1, 120, 
				400, 300, 900, 500, "Player", "specialBuildingChosen", "Launch Site");
	rechargeableBatteries = new _upgrade_options("Rechargeable Batteries", "Reduces the cooldown of your Shocktrooper ability.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.four, eUpgradeSibling.noone, 
				false, 3, false, noone, "Temple", "Player", "shocktrooperCooldownTimer", noone, (45 * room_speed) * -1, 120, 
				500, 100, 600, 400, noone, noone, noone);
}
function _laboratory() constructor {
	alchemy = new _upgrade_options("Alchemy", "Improves the effectiveness of Flasks.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1, false, noone, "Laboratory", "Player", "flaskUpgraded", noone, 1, 60, 
				200, 200, 200, 0, noone, noone, noone);
	skillful = new _upgrade_options("Skillful", "Improves the effectiveness of basic unit special abilities.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1, false, noone, "Laboratory", "Basic", "objectSpecialAbilityUpgraded", noone, 1, 60, 
				200, 200, 200, 0, noone, noone, noone);
	fullMetalJacket = new _upgrade_options("Full Metal Jacket", "Increases the damage that all buildings deal.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Laboratory", "Building", "objectAttackDamage", noone, 5, 45, 
				0, 350, 200, 0, noone, noone, noone);
	reinforcement = new _upgrade_options("Reinforcement", "Increases the magic armor of all buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Laboratory", "Building", "objectMagicResistance", noone, -0.1, 60, 
				0, 400, 200, 200, noone, noone, noone);
	improvedMagicks = new _upgrade_options("Improved Magicks", "Increases the area of effect by 1 square for the targeted area when dealing damage with Wizard's Fire Linked ability, or Acolyte's Vitality Linked ability.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "Laboratory", "Wizard and Acolyte", "aoeLinkedSquareSize", noone, 1, 120, 
				200, 0, 200, 400, noone, noone, noone);
	chronicEmpowerment = new _upgrade_options("Chronic Empowerment", "Increases the damage of all Automatons upon teleporting with the ability Shocktrooper for a short amount of time.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "Laboratory", "Shocktrooper", "chronicEmpowermentPossible", noone, 1, 120, 
				200, 0, 200, 400, noone, noone, noone);
	arcaneWeaponResearch = new _upgrade_options("Arcane Weapon Research", "Increases all magic damage and healing dealt by all Ruby units.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 3, false, noone, "Laboratory", "Ruby", "arcaneWeaponActive", noone, 1, 180, 
				400, 500, 600, 600, noone, noone, noone);
	arcaneArmorResearch = new _upgrade_options("Arcane Armor Research", "Increases all Magic armor for Ruby units.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 3, false, noone, "Laboratory", "Ruby", "objectMagicResistance", noone, -0.15, 180, 
				600, 500, 400, 600, noone, noone, noone);
}
function _barracks() constructor {
	enrage = new _upgrade_options("Enrage", "Unlocks the Berserker's Standard Ability, Enrage.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.a, 
				false, 1, false, noone, "Barracks", "Berserker", "objectCanUseSpecialAbility", noone, 
				1, 45, 150, 0, 0, 0, noone, noone, noone);
	invisibility = new _upgrade_options("Invisibility", "Unlocks the Rogue's Standard Ability, Invisibility.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 1, false, noone, "Barracks", "Rogue", "objectCanUseSpecialAbility", noone, 1, 45, 
				0, 0, 150, 0, noone, noone, noone);
	rally = new _upgrade_options("Rally", "Unlocks the Soldier's Standard Ability, Rally.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.c, 
				false, 1, false, noone, "Barracks", "Soldier", "objectCanUseSpecialAbility", noone, 1, 45, 
				0, 150, 0, 0, noone, noone, noone);
	scope = new _upgrade_options("Scope", "Increases the range of Rangers.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.a, 
				false, 1, false, noone, "Barracks", "Ranger", "objectAttackRange", noone, 1, 45, 
				0, 200, 0, 0, noone, noone, noone);
	angerManagement = new _upgrade_options("Anger Management", "Increases the attack damage bonus of Berserker's Enrage ability.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 1, false, noone, "Barracks", "Berserker", "enrageDamageBonus", noone, 3, 60, 
				200, 0, 0, 0, noone, noone, noone);
	backstab = new _upgrade_options("Backstab", "Increases the damage of Rogue's Ambush ability.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.c, 
				false, 1, false, noone, "Barracks", "Rogue", "ambushBonusDamage", noone, 25, 60, 
				0, 0, 200, 0, noone, noone, noone);
	resolute = new _upgrade_options("Resolute", "Increases the health of Soldiers and Knights.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1, false, noone, "Barracks", "Soldier and Knight", "maxHP", noone, "75 and 140", 90, 
				250, 250, 250, 0, noone, noone, noone);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	rogueCombatSpecialAbilities = new _upgrade_options("Rogue Combat Special Abilities", "Unlocks the Combat Special Abilities for the Rogue.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 2, false, noone, "Barracks", "Rogue", "objectCanUseCombatSpecializationAbility",
				noone, 1, 60, 150, 50, 100, 0, "Player" /*Located in the player struct for each player*/, 
				"combatSpecializationChosen", "Stealth");
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	berserkerCombatSpecialAbilities = new _upgrade_options("Berserker Combat Special Abilities", "Unlocks the Combat Special Abilities for the Berserker.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 2, false, noone, "Barracks", "Berserker", "objectCanUseCombatSpecializationAbility", 
				noone, 1, 60, 150, 50, 100, 0, "Player" /*Located in the player struct for each player*/, 
				"combatSpecializationChosen", "Recklessness");
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	knightCombatSpecialAbilities = new _upgrade_options("Knight Combat Special Abilities", "Unlocks the Combat Special Abilities for the Knight.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 2, false, noone, "Barracks", "Knight", "objectCanUseCombatSpecializationAbility", 
				noone, 1, 60, 150, 50, 100, 0, "Player" /*Located in the player struct for each player*/, 
				"combatSpecializationChosen", "Protectorate");
	piercingStrike = new _upgrade_options("Piercing Strike", "Rogues are able to find the weak point in their target's armor when using their Ambush ability. Rogues now ignore a quarter of their target's armor when dealing damage with Ambush.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 2, false, noone, "Barracks", "Rogue", "piercingStrikeActive", noone, 1, 90, 
				100, 100, 50, 0, noone, noone, noone);
	stabilizedWeapons = new _upgrade_options("Stabilized Weapons", "Further increases the range of Rangers.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 2, false, noone, "Barracks", "Ranger", "objectAttackRange", noone, 1, 105, 
				0, 300, 100, 0, noone, noone, noone);
	moraleBoost = new _upgrade_options("Morale Boost", "Increases the damage bonus for Soldiers when surrounded by other friendly Soldiers.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.two, eUpgradeSibling.c, 
				false, 2, false, noone, "Barracks", "Soldier", "courageDamageBonus", noone, 2, 105, 
				200, 50, 300, 0, noone, noone, noone);
	steelArmor = new _upgrade_options("Steel Armor", "Increases the magic armor of Knights.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 2, false, noone, "Barracks", "Knight", "objectMagicResistance", noone, -0.10, 120, 
				100, 300, 300, 0, noone, noone, noone);
	hardenedLeather = new _upgrade_options("Hardened Leather", "Increases the slash armor of Berserkers.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 2, false, noone, "Barracks", "Berserker", "objectSlashResistance", noone, -0.10, 105, 
				300, 100, 200, 0, noone, noone, noone);
	flamingArrows = new _upgrade_options("Flaming Arrows", "Rangers now ignite their shots with magic, dealing a small amount of additional damage.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 3, false, noone, "Barracks", "Ranger", "objectAttackDamage", noone, 3, 105, 
				200, 500, 400, 0, noone, noone, noone);
	sharpenedWeapons = new _upgrade_options("Sharpened Weapons", "Increases the damage of all basic units.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 3, false, noone, "Barracks", "Basic", "objectAttackDamage", noone, 2, 120, 
				400, 400, 800, 0, noone, noone, noone);
	chainMail = new _upgrade_options("Chain Mail", "Increases the slash and pierce armor of all basic units.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.three, eUpgradeSibling.a, 
				false, 3, false, noone, "Barracks", "Basic", "objectSlashResistance and objectPierceResistance", 
				noone, "-0.05 and -0.15", 120, 300, 500, 800, 0, noone, noone, noone);
	blessedArmor = new _upgrade_options("Blessed Armor", "Increases the magic armor of all basic units.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "Barracks", "Basic", "objectMagicResistance", noone, -0.10, 120, 
				200, 600, 800, 0, noone, noone, noone);
}
function _storehouse() constructor {
	trainedWorkers = new _upgrade_options("Trained Workers", "Increases the gathering speed of all basic resources by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.a, 
				false, 1, false, noone, "Storehouse", "Worker", "objectFoodGatherDamage and objectWoodChopDamage and objectGoldMineDamage", 
				noone, 1, 60, 100, 200, 200, 0, noone, noone, noone);
	// Drones is also available on the City Hall building
	drones = new _upgrade_options("Drones", "Workers no longer need to drop Food, Wood, or Gold off at Storehouses.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 1, false, noone, "Storehouse", "Worker", "canUseDrones", noone, 1, 30, 50, 50, 250, 
				0, noone, noone, noone);
	advancedTooling = new _upgrade_options("Advanced Tooling", "Further increases the gathering speed of all basic resources by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "Storehouse", "Worker", "objectFoodGatherDamage and objectWoodChopDamage and objectGoldMineDamage", 
				noone, 1, 120, 200, 400, 400, 0, noone, noone, noone);
	// Drilling is also available on the City Hall building
	drilling = new _upgrade_options("Drilling", "Allows Workers to mine Rubies", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Storehouse", "Worker", "canMineRuby", noone, 1, 45, 0, 0, 800, 0, noone, noone, noone);
	magicTraining = new _upgrade_options("Magic Training", "Increases the gathering speed of Rubies by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 2, false, noone, "Storehouse", "Worker", "objectRubyMineDamage", noone, 2, 90, 
				100, 200, 200, 150, noone, noone, noone);
	speedyHands = new _upgrade_options("Speedy Hands", "Further increases the gathering speed of all basic resources by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.four, eUpgradeSibling.noone, 
				false, 3, false, noone, "Storehouse", "Worker", "objectFoodGatherDamage and objectWoodChopDamage and objectGoldMineDamage", 
				noone, 2, 180, 400, 800, 800, 0, noone, noone, noone);
	rollerSkates = new _upgrade_options("Roller Skates", "Increases the movement speed of Workers while not in combat.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 3, false, noone, "Storehouse", "Worker", "movementSpeedBonusAvailable", noone, 1, 45, 
				600, 0, 400, 0, noone, noone, noone);
	futuristicTooling = new _upgrade_options("Futuristic Tooling", "When gathering basic resources, Workers have a random chance to obtain additional resources on collection.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 3, false, noone, "Storehouse", "Worker", "randomBasicResourceGenerationActive", noone, 1, 120, 
				600, 600, 600, 400, noone, noone, noone);
}
function _obelisk() constructor {
	telescopes = new _upgrade_options("Telescopes", "Increases the sight range of Obelisks.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Obelisk", "Obelisk", "objectSightRange", noone, 3 * 16, 45, 
				200, 200, 200, 0, noone, noone, noone);
	hardeningMist = new _upgrade_options("Hardening Mist", "Obelisks now provide an armor bonus for all units and buildings within range.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Obelisk", "Obelisk", "hardeningMistActive", noone, 1, 75, 
				200, 400, 300, 0, noone, noone, noone);
	// This opens a menu to choose two specializations for the Obelisk building out of three options.
	// It affects multiple variables, so I include it here really as just a placeholder to make the menu
	// appear when the talent is clicked.
	obeliskSpecialization = new _upgrade_options("Obelisk Specialization", "Choose two of the following upgrade tree paths.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "Obelisk", "Player", "", "Obelisk Specialization", "", 15,
				200, 200, 200, 0, noone, noone, noone);
	// If True Sight is chosen as one of two upgrades for obeliskSpecialization, listed above
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	trueSight = new _upgrade_options("True Sight", "Provides True Sight, revealing all Rogues and Subverters within range.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.a, 
				false, 2, false, noone, "Obelisk", "Obelisk", "trueSightActive", noone, 1, 75, 
				100, 400, 400, 0, "Obelisk", "trueSightChosen", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	lingeringGaze = new _upgrade_options("Lingering Gaze", "You retain True Sight on Rogues and Subverters revealed by your Obelisks for a short time after they leave the Obelisk's range.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 2, false, noone, "Obelisk", "Obelisk", "lingeringGazeActive", noone, 1, 90, 
				200, 0, 500, 100, "Obelisk", "trueSightActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	freezingGaze = new _upgrade_options("Freezing Gaze", "All enemy units are slowed while in range of the Obelisk.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.a, 
				false, 2, false, noone, "Obelisk", "Obelisk", "freezingGazeActive", noone, 1, 90, 
				0, 400, 200, 100, "Obelisk", "trueSightActive", 1);
	// If Demon Sentry is chosen as one ofthe two upgrades for obeliskSpecialization, listed above
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	demonSentry = new _upgrade_options("Demon Sentry", "Demons will be summoned while enemies are in range of the Obelisk. The Demons will die after a short while. Short internal cooldown.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 2, false, noone, "Obelisk", "Obelisk", "demonSentryActive", noone, 1, 90, 
				400, 0, 300, 0, "Obelisk", "demonSentryChosen", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	awoken = new _upgrade_options("Awoken", "The Obelisk now summons more Demons while enemies are in range.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 2, false, noone, "Obelisk", "Obelisk", "awokenActive", noone, 1, 120, 
				400, 0, 500, 100, "Obelisk", "demonSentryActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	trojanHorse = new _upgrade_options("Trojan Horse", "The Obelisk will summon a pair of Warlocks under your control if destroyed by an enemy.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.b, 
				false, 2, false, noone, "Obelisk", "Obelisk", "trojanHorseActive", noone, 1, 60, 
				300, 200, 300, 100, "Obelisk", "demonSentryActive", 1);
	// If Soul Link is chosen as one of the two upgrades for ObeliskSpecialization, listed above
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	soulLink = new _upgrade_options("Soul Link", "An Obelisk can now link to one unit. Once Linked, if that unit would have been killed, the unit is instead: saved from death, it's HP is set to 1, teleported to the Obelisk, and the Obelisk is then destroyed. An Obelisk cannot be Linked to a unit if the Obelisk is not at full HP.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.c, 
				false, 2, false, noone, "Obelisk", "Obelisk", "soulLinkActive", noone, 1, 45, 
				100, 300, 0, 0, "Obelisk", "soulLinkChosen", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	lifeline = new _upgrade_options("Lifeline", "Units Soul Linked to Obelisks heal rapidly while not in combat.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.c, 
				false, 2, false, noone, "Obelisk", "Obelisk", "lifelineActive", noone, 1, 75, 
				400, 0, 0, 100, "Obelisk", "soulLinkActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	gaiasGrowth = new _upgrade_options("Gaia's Growth", "Buildings within range of the Obelisk slowly heal over time.", 
				eUpgradeTree.magic, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.c, 
				false, 2, false, noone, "Obelisk", "Obelisk", "gaiasGrowthActive", noone, 1, 45, 
				0, 400, 100, 100, "Obelisk", "soulLinkActive", 1);
	// If Waygates is chosen as one of the two upgrades for ObeliskSpecialization, listed above
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	waygates = new _upgrade_options("Waygates", "Allows units to teleport between Obelisks.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 2, false, noone, "Obelisk", "Obelisk", "waygatesActive", noone, 1, 120, 
				0, 300, 200, 0, "Obelisk", "waygatesChosen", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	energizingField = new _upgrade_options("Energizing Field", "Units gain a temporary movement speed boost after teleporting between Obelisks.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 2, false, noone, "Obelisk", "Obelisk", "energizingFieldActive", noone, 1, 45, 
				200, 0, 300, 100, "Obelisk", "waygatesActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	battleVigor = new _upgrade_options("Battle Vigor", "Units are healed to full when teleporting between Obelisks if there are enemies either: in range of the Obelisk the units enter, or in range of the Obelisk the units exit.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.b, 
				false, 2, false, noone, "Obelisk", "Obelisk", "battleVigorActive", noone, 1, 45, 
				500, 0, 0, 100, "Obelisk", "waygatesActive", 1);
	// If Lasers is chosen as one of the two upgrades for ObeliskSpecialization, listed above
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	lasers = new _upgrade_options("Lasers", "Fires beams of lasers at single targets, dealing high damage over time.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.c, 
				false, 2, false, noone, "Obelisk", "Obelisk", "lasersActive", noone, 1, 60, 
				0, 200, 200, 0, "Obelisk", "lasersChosen", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	highIntensityBeam = new _upgrade_options("High Intensity Beam", "The Obelisk now ignore's the armor of it's targets.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.c, 
				false, 2, false, noone, "Obelisk", "Obelisk", "highIntensityBeamActive", noone, 1, 75, 
				0, 200, 300, 100, "Obelisk", "lasersActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	plasmaBeam = new _upgrade_options("Plasma Beam", "Lasers are upgraded to Plasma Beam, dealing even more damage.", 
				eUpgradeTree.technology, eUpgradeType.special, eUpgradeOrder.four, eUpgradeSibling.c, 
				false, 2, false, noone, "Obelisk", "Obelisk", "plasmaBeamActive", noone, 1, 90, 
				0, 400, 100, 100, "Obelisk", "lasersActive", 1);
	telescopicLense = new _upgrade_options("Telescopic Lense", "Further increases the sight range of Obelisks.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 3, false, noone, "Obelisk", "Obelisk", "telescopicLenseActive", noone, 1, 60, 
				0, 300, 500, 0, noone, noone, noone);
	mysticalStrength = new _upgrade_options("Mystical Strength", "Obelisks now provide an attack bonus for all units and buildings within range.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.five, eUpgradeSibling.noone, 
				false, 3, false, noone, "Obelisk", "Obelisk", "mysticalStrengthActive", noone, 1, 90, 
				400, 0, 300, 100, noone, noone, noone);
	mysticalConnection = new _upgrade_options("Mystical Connection", "You may now choose one sight target for each Obelisk. The sight target must be another Obelisk. A narrow line of vision is constantly provided between the original Obelisk and it's sight target. Enemies can see your sight lines.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.six, eUpgradeSibling.noone, 
				false, 3, false, noone, "Obelisk", "Obelisk", "mysticalConnectionActive", noone, 1, 90, 
				100, 100, 100, 400, noone, noone, noone);
	hardenedObsidian = new _upgrade_options("Hardened Obsidian", "Increases all armor of Obelisks.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 3, false, noone, "Obelisk", "Obelisk", "hardenedObsidianActive", noone, 1, 90, 
				100, 500, 300, 100, noone, noone, noone);
}
function _outpost() constructor {
	bonfire = new _upgrade_options("Bonfire", "Increases Outpost sight range.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.a, 
				false, 1, false, noone, "Outpost", "Obelisk", "bonfireActive", noone, 1, 45, 
				0, 200, 100, 0, noone, noone, noone);
	tower = new _upgrade_options("Bonfire", "Upgrades Outpost to a Tower, with further attack range and more damage.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Outpost", "Obelisk", "towerActive", noone, 1, 60, 
				200, 200, 200, 0, noone, noone, noone);
	serratedArrowheads = new _upgrade_options("Serrated Arrowheads", "Increases the damage of the Tower.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 2, false, noone, "Outpost", "Outpost", "serratedArrowheadsActive", noone, 1, 45, 
				0, 300, 100, 0, noone, noone, noone);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	ironPlating = new _upgrade_options("Iron Plating", "Increases all Tower armor.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.a, 
				false, 2, false, noone, "Outpost", "Outpost", "ironPlatingActive", noone, 1, 45, 
				200, 300, 100, 0, "Outpost", "towerActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	fittedStone = new _upgrade_options("Fitted Stone", "Upgrades Tower HP.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 2, false, noone, "Outpost", "Outpost", "fittedStone", noone, 1, 60, 
				400, 100, 100, 0, "Outpost", "towerActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	basicGarrison = new _upgrade_options("Basic Garrison", "Allows the player to Garrison one Basic unit. The Tower gains bonuses depending on the type of unit Garrisoned. Garrisoned units will spawn back if the Tower is destroyed.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 2, false, noone, "Outpost", "Outpost", "basicGarrisonActive", noone, 1, 30, 
				400, 100, 100, 0, "Outpost", "towerActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	oilPots = new _upgrade_options("Oil Pots", "Increases the damage of the Tower.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 3, false, noone, "Outpost", "Outpost", "oilPotsActive", noone, 1, 60, 
				0, 100, 400, 100, "Outpost", "towerActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	magicSpire = new _upgrade_options("Magic Spire", "Upgrades the Tower to a Magic Spire, with additional magic damage applied to each attack.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 3, false, noone, "Outpost", "Outpost", "magicSpireActive", noone, 1, 60, 
				400, 400, 400, 200, "Outpost", "towerActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	brickAndMortar = new _upgrade_options("Brick and Mortar", "Increases all Tower armor.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.a, 
				false, 3, false, noone, "Outpost", "Outpost", "brickAndMortarActive", noone, 1, 60, 
				300, 400, 200, 100, "Outpost", "magicSpireActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	magicShielding = new _upgrade_options("Magic Shielding", "Upgrades Magic Spire's HP.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.b, 
				false, 3, false, noone, "Outpost", "Outpost", "magicShieldingActive", noone, 1, 75, 
				0, 500, 200, 200, "Outpost", "magicSpireActive", 1);
	// The next option will only appear if the variable given (second to last argument) located in the object
	// or struct (third to last argument) is equal to the value expected (last argument).
	enhancedGarrison = new _upgrade_options("Enhanced Garrison", "Allows the player to Garrison one Ruby unit, in addition to the Garrisoned Basic unit. The Magic Spire gains additional bonuses depending on the type of Ruby unit Garrisoned. Garrisoned units will spawn back if the Magic Spire is destroyed.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.c, 
				false, 3, false, noone, "Outpost", "Outpost", "enhancedGarrisonActive", noone, 1, 45, 
				600, 300, 300, 200, "Outpost", "magicSpireActive", 1);
}
function _wall() constructor {
	stoneWalls = new _upgrade_options("Stone Walls", "Upgrades Walls to Stone Walls, with more HP and armor.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 0, false, noone, "Wall", "Wall", "stoneWallsActive", noone, 1, 30, 
				0, 200, 100, 0, noone, noone, noone);
	reinforcedWalls = new _upgrade_options("Reinforced Walls", "Upgrades Stone Walls to Reinforced Walls, with more HP and armor.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 1, false, noone, "Wall", "Wall", "reinforcedWallsActive", noone, 1, 45, 
				0, 300, 200, 0, noone, noone, noone);
	ironWalls = new _upgrade_options("Iron Walls", "Upgrades Reinforced Walls to Iron Walls, with more HP and armor.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 2, false, noone, "Wall", "Wall", "ironWallsActive", noone, 1, 60, 
				0, 400, 300, 100, noone, noone, noone);
	magicWalls = new _upgrade_options("Magic Walls", "Upgrades Iron Walls to Magic Walls, with more HP and armor.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.four, eUpgradeSibling.noone, 
				false, 3, false, noone, "Wall", "Wall", "magicWallsActive", noone, 1, 75, 
				0, 500, 400, 200, noone, noone, noone);
}


/*
	ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
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
	- each xxx.statsToUpgrade needs to be evaluated for an empty " " string located inside, and for each one 
	found, the previous and subsequent string need to be evaluated as stats adjusted.
		- if xxx.statsToUpgrade is found to have an empty " " string located inside, 
		  xxx.upgradeValueToAddToCurrentStat will also be set as a string and have an
		  empty " " string located inside. Each of those numbers needs to be converted to
		  an integer type and increment the respective stat listed in xxx.statsToUpgrade

*/


