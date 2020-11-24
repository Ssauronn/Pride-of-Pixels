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
	// Object Specific Timers
	// Worker Timers
	if (objectClassification == "Unit") && (objectType == "Worker") {
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