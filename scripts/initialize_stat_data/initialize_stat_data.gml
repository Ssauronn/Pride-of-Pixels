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
	flaskChosen = "";
	combatSpecialtyChosen = "";
	obeliskUpgradeOneChosen = "";
	obeliskUpgradeTwoChosen = "";
	specialBuildingChosen = "";
	
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
	// This string can be a list of stats, separated by a space " ".
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

// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
// In this case, I need to add a constructor named after the building type for each building that
// can be upgraded or has upgrades available on it.

function _city_hall() constructor {
	statUpdated = false;
	discovery = new _upgrade_options("Discovery", "Upgrades to the first Age, unlocking your chosen specialization and additional upgrades.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.one, eUpgradeSibling.noone,
				false, 0, true, spr_discovery_icon, "City Hall", "Player" /*available for the
				player[i].age struct value, set below.*/, "age", "Age One", 1, 30, 250, 150, 200, 0);
	foundations = new _upgrade_options("Foundations", "Increases the pierce and slash armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1,  true, noone, "City Hall", obj_building, "objectSlashResistance and objectPierceResistance", 
				noone, "-0.15 and -0.1" /*resistance is a decimal multiplier between 0 to 1, 0 being full damage
				resisted and 1 being full damage taken*/, 45, 0, 200, 150, 0);
	parapets = new _upgrade_options("Parapets", "Increases the damage of all buildings with offensive capabilities.", 
				eUpgradeTree.universal, eUpgradeType.offensive, eUpgradeOrder.one, eUpgradeSibling.noone, 
				false, 1, true, noone, "City Hall", obj_building, "objectAttackDamage", noone, 5, 30, 0, 
				50, 200, 0);
	farming = new _upgrade_options("Farming", "Unlocks the Farm structure and allows it to be built by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.a,
				false, 1, true, noone, "City Hall", "Worker", "canBuildFarm", noone, 1, 60, 200, 200, 0, 
				0);
	drones = new _upgrade_options("Drones", "Workers no longer need to drop Food, Wood, or Gold off at Storehouses.", 
				eUpgradeTree.technology, eUpgradeType.innovation, eUpgradeOrder.one, eUpgradeSibling.b, 
				false, 1, true, noone, "City Hall", "Worker", "canUseDrones", noone, 1, 30, 50, 50, 250, 
				0);
	experimentation = new _upgrade_options("Experimentation", "Upgrades to the second Age, unlocking additional upgrades.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 1, false, noone, "City Hall", "Player", "age", "Age Two", 1, 120, 
				400, 500, 700, 0);
	ramparts = new _upgrade_options("Ramparts", "Further increases the pierce and slash armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "City Hall", obj_building, "objectSlashResistance and objectPierceResistance", 
				noone, "-0.1 and -0.1", 30, 0, 500, 300, 0);
	thickets = new _upgrade_options("Thickets", "Unlocks the Thicket structure and allows it to be built by Workers.", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.two, eUpgradeSibling.noone, 
				false, 2, false, noone, "City Hall", "Worker", "canBuildThicket", noone, 1, 30, 200, 300, 
				100, 0);
	drilling = new _upgrade_options("Drilling", "Allows Workers to mine Rubies", eUpgradeTree.universal,
				eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.a, false, 2, false, noone, 
				"City Hall", "Worker", "canMineRuby", noone, 1, 45, 0, 0, 800, 0);
	refinement = new _upgrade_options("Refinement", "Upgrades to the third Age, unlocking additional upgrades.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 2, false, noone, "City Hall", "Player", "age", "Age Three", 1, 150, 300, 500, 
				500, 200);
	bastion = new _upgrade_options("Bastion", "Further increases the pierce and slash armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.three, eUpgradeSibling.noone, 
				false, 3, false, noone, "City Hall", obj_building, "objectSlashResistance and objectPierceResistance", 
				noone, "-0.1 and -0.1", 30, 0, 600, 400, 100);
	shielding = new _upgrade_options("Shielding", "Increases the magic armor of all controlled buildings.", 
				eUpgradeTree.universal, eUpgradeType.defensive, eUpgradeOrder.four, eUpgradeSibling.noone, 
				false, 3, false, noone, "City Hall", obj_building, "objectMagicResistance", noone, -0.1, 
				40, 300, 300, 300, 300);
	ballroom = new _upgrade_options("Ballroom", "Each City Hall and House provides additional population.", 
				eUpgradeTree.universal, eUpgradeType.special, eUpgradeOrder.three, eUpgradeSibling.c, 
				false, 3, false, noone, "City Hall", obj_building, "populationProvided", noone, 5, 80, 100, 
				100, 400, 100);
	mines = new _upgrade_options("Mines", "Unlocks the Mine structure and allows it to be built by Workers", 
				eUpgradeTree.universal, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.a, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildMine", noone, 1, 45, 200, 200, 
				400, 300);
	soulSubjugator = new _upgrade_options("Soul Subjugator", "Unlocks the Soul Subjugator structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildSoulSubjugator", noone, 1, 90, 200, 
				200, 200, 200);
	ritualGround = new _upgrade_options("Ritual Grounds", "Unlocks the Ritual Grounds structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildRitualGrounds", noone, 1, 90, 200, 
				200, 200, 200);
	unholyZiggurat = new _upgrade_options("Unholy Ziggurat", "Unlocks the Unholy Ziggurat structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildUnholyZiggurat", noone, 1, 90, 200, 
				200, 200, 200);
	railGun = new _upgrade_options("Rail Gun", "Unlocks the Rail Gun structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildRailGun", noone, 1, 90, 200, 
				200, 200, 200);
	stasisField = new _upgrade_options("Stasis Field", "Unlocks the Stasis Field structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildStasisField", noone, 1, 90, 200, 
				200, 200, 200);
	launchSite = new _upgrade_options("Launch Site", "Unlocks the Launch Site structure and allows it to be built by Workers.", 
				eUpgradeTree.magic, eUpgradeType.innovation, eUpgradeOrder.three, eUpgradeSibling.b, 
				false, 3, false, noone, "City Hall", "Worker", "canBuildLaunchSite", noone, 1, 90, 200, 
				200, 200, 200);
	function draw_all_buttons() {
		var first_row_y_value_ = obj_gui.toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerYScale) + (obj_gui.toolbarButtonSpacing * 2);
		var second_row_y_value_ = obj_gui.toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerYScale) + (obj_gui.toolbarButtonSpacing * 3) + (obj_gui.toolbarButtonWidth * 1);
		var third_row_y_value_ = obj_gui.toolbarTopY + (sprite_get_height(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerYScale) + (obj_gui.toolbarButtonSpacing * 4) + (obj_gui.toolbarButtonWidth * 2);
		var special_row_x_value_ = obj_gui.toolbarUpgradeHorizontalDividerFirstX + obj_gui.toolbarUpgradeButtonXOffsetFromDividerX;
		var innovation_row_x_value_ = obj_gui.toolbarUpgradeHorizontalDividerFirstX + obj_gui.toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerXScale * 1) + (obj_gui.toolbarUpgradeHorizontalDividerSpacing * 1);
		var offensive_row_x_value_ = obj_gui.toolbarUpgradeHorizontalDividerFirstX + obj_gui.toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerXScale * 2) + (obj_gui.toolbarUpgradeHorizontalDividerSpacing * 2);
		var defensive_row_x_value_ = obj_gui.toolbarUpgradeHorizontalDividerFirstX + obj_gui.toolbarUpgradeButtonXOffsetFromDividerX + (sprite_get_width(spr_horizontal_solid_divider) * obj_gui.toolbarUpgradeHorizontalDividerXScale * 3) + (obj_gui.toolbarUpgradeHorizontalDividerSpacing * 3);
		if player[1].age == 0 {
			// If the upgrade is available to unlock and it is not currently being unlocked
			// Discovery - Special.1
			if (player[1].cityHall.discovery.upgradeAvailableToUnlock) && (!player[1].cityHall.discovery.upgradeBeingUnlocked) {
				with obj_gui {
					draw_sprite_ext(spr_discovery_icon, 0, special_row_x_value_, first_row_y_value_, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
				}
			}
		}
		else if player[1].age == 1 {
			// Experimentation - Special.2
			
			var innovation_sibling_shift_up_ = false;
			// Farming - Innovation.1.a
			if (player[1].cityHall.farming.upgradeAvailableToUnlock) && (!player[1].cityHall.farming.upgradeBeingUnlocked) {
				with obj_gui {
					draw_sprite_ext(spr_square_button, 0, innovation_row_x_value_, first_row_y_value_, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
				}
			}
			else {
				innovation_sibling_shift_up_ = true;
			}
			// Drones - Innovation.1.b
			if (player[1].cityHall.drones.upgradeAvailableToUnlock) && (!player[1].cityHall.drones.upgradeBeingUnlocked) {
				if innovation_sibling_shift_up_ {
					with obj_gui {
						draw_sprite_ext(spr_square_button, 0, innovation_row_x_value_, first_row_y_value_, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
					}
				}
				else {
					with obj_gui {
						draw_sprite_ext(spr_square_button, 0, innovation_row_x_value_, second_row_y_value_, toolbarButtonScale, toolbarButtonScale, 0, c_white, 1);
					}
				}
			}
			// 
		}
		else if player[1].age == 2 {
			
		}
		else if player[1].age == 3 {
			
		}
	}
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
	- each xxx.statsToUpgrade needs to be evaluated for an empty " " string located inside, and for each one 
	found, the previous and subsequent string need to be evaluated as stats adjusted.
		- if xxx.statsToUpgrade is found to have an empty " " string located inside, 
		  xxx.upgradeValueToAddToCurrentStat will also be set as a string and have an
		  empty " " string located inside. Each of those numbers needs to be converted to
		  an integer type and increment the respective stat listed in xxx.statsToUpgrade

*/


