///@function				count_down_timers();
///@description				Counts down various timers for different units and buildings


function count_down_timers() {
	if !obj_gui.startMenu.active {
		// Universal Timers for Units
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
}