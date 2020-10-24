/// @function					count_down_timers();
/// @description				Counts down various timers for different objects


function count_down_timers() {
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
	if objectAttackSpeedTimer > 0 {
		objectAttackSpeedTimer--;
	}
	if objectCheckForEnemyTimer > 0 {
		objectCheckForEnemyTimer--;
	}
}