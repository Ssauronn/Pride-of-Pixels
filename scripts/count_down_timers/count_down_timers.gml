///@function				count_down_timers();
///@description				Counts down various timers for different units and buildings


function count_down_timers() {
	if !obj_gui.startMenu.active {
		if (object_index == obj_building) || (object_index == obj_unit) {
			// Universal Timers for Units and Buildings
			if objectAttackSpeedTimer > 0 {
				objectAttackSpeedTimer--;
			}
			if objectDetectTarget > 0 {
				objectDetectTarget--;
			}
			// Unit Specific Timers
			if (objectClassification == "Unit") {
				if spriteWaitTimer > 0 {
					spriteWaitTimer--;
				}
				// Worker Specific Timers
				if (objectType == "Worker") {
					if objectWoodChopSpeedTimer > 0 {
						objectWoodChopSpeedTimer--;
					}
					if objectFoodGatherSpeedTimer > 0 {
						objectFoodGatherSpeedTimer--;
					}
					if objectGoldMineSpeedTimer > 0 {
						objectGoldMineSpeedTimer--;
					}
					if objectRubyMineSpeedTimer > 0 {
						objectRubyMineSpeedTimer--;
					}
				}
			}
			// Building Specific Timers
			if (objectClassification == "Building") {
		
			}
		}
		// If the stat manager is running this, its tracking global TEAM stats, team being a
		// struct with global team data located inside for each team.
		else if object_index == obj_stat_manager {
			if obj_stat_manager.anyStatBeingUpdated != false {
				var i;
				for (i = 1; i < totalAmountOfTeams - 1; i++) {
					with player[i] {
						// Count each count down timer here.
						/*
						MAKE SURE to update obj_stat_manager.anyStatUpdated so that its 
						set to true, where obj_stat_manager will then update all relevant 
						variables in it's step event, and set obj_stat_manager.anyStatBeingUpdated 
						to false here if no other stats are being updated or counted down after 
						a stat finished it's upgrade.
						*/
						// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
						// In this case, for each building type, all potential upgrades should
						// be checked.
						if obj_stat_manager.anyStatBeingUpdated == "City Hall" {
							
						}
					}
				}
			}
		}
	}
}