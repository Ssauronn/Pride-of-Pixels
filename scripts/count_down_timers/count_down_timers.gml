///@function					count_down_timers();
///@description				Counts down various timers for different objects


function count_down_timers() {
	// Universal Timers
	if objectAttackSpeedTimer > 0 {
		objectAttackSpeedTimer--;
	}
	if objectDetectTarget > 0 {
		objectDetectTarget--;
	}
	/// Object Specific Timers
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
	if (objectClassification == "Unit") {
		
	}
}