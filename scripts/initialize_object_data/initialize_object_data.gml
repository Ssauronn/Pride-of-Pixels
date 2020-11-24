///@function							initialize_object_data();
///@description							Assign unit/building specific variables to each object

// State machine - this is initialized only once at the beginning of the game, as this declaration is
// outside of a function.
enum unitAction {
	idle,
	move,
	mine,
	attack
}
// Sprite setting enums
enum unitDirection {
	right,
	up,
	left,
	down
}


function initialize_object_data() {
	#region Units
	switch objectType {
		case "Worker":
			// Generic variables
			maxHP = 70;
			currentHP = maxHP;
			objectRange = 16;
			// Combat variables
			objectCombatAggroRange = 8; // This is half the width of the square in mp_grid unit sizes to detect enemies in, centered on this object
			objectAttackSpeed = 1.5 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 12;
			objectAttackDamageType = "Slash";
			// For resistances, they're multipliers. The closer to 0 the higher resistance it has.
			// Anything above 1 means it has a negative resistance and takes more damage than normal
			// from that damage type.
			objectSlashResistance = 0.9;
			objectPierceResistance = 1;
			objectCrushResistance = 0.7;
			objectMagicResistance = 1;
			// Mining variables (exclusive to obj_worker)
			objectWoodChopSpeed = room_speed; // Wood
			objectWoodChopSpeedTimer = 0; // Wood
			objectWoodChopDamage = 4; // Wood
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
			workerSprite[unitAction.idle][unitDirection.right] = spr_worker;
			workerSprite[unitAction.idle][unitDirection.up] = spr_worker;
			workerSprite[unitAction.idle][unitDirection.left] = spr_worker;
			workerSprite[unitAction.idle][unitDirection.down] = spr_worker;
			workerSprite[unitAction.move][unitDirection.right] = spr_worker;
			workerSprite[unitAction.move][unitDirection.up] = spr_worker;
			workerSprite[unitAction.move][unitDirection.left] = spr_worker;
			workerSprite[unitAction.move][unitDirection.down] = spr_worker;
			workerSprite[unitAction.mine][unitDirection.right] = spr_worker;
			workerSprite[unitAction.mine][unitDirection.up] = spr_worker;
			workerSprite[unitAction.mine][unitDirection.left] = spr_worker;
			workerSprite[unitAction.mine][unitDirection.down] = spr_worker;
			workerSprite[unitAction.attack][unitDirection.right] = spr_worker;
			workerSprite[unitAction.attack][unitDirection.up] = spr_worker;
			workerSprite[unitAction.attack][unitDirection.left] = spr_worker;
			workerSprite[unitAction.attack][unitDirection.down] = spr_worker;
			// Actual Sprite Value
			currentAction = unitAction.move;
			currentDirection = unitDirection.right;
			currentSprite = workerSprite[currentAction][currentDirection];
			// Index speed
			currentImageIndex = 0;
			currentImageIndexSpeed = 10 / room_speed;
			break;
		#endregion
		#region Buildings
		case "City Hall":
			// Generic variables
			maxHP = 1500;
			currentHP = maxHP;
			objectRange = 16 * 5;
			// Combat variables
			objectCombatAggroRange = 5;
			objectAttackSpeed = 1 * room_speed;
			objectAttackSpeedTimer = 0;
			objectAttackDamage = 12;
			objectAttackDamageType = "Pierce";
			objectSlashResistance = 0.9;
			objectPierceResistance = 1;
			objectCrushResistance = 0.7;
			objectMagicResistance = 1;
			sprite_index = spr_building_xlarge;
			var floor_x_ = floor(x / 16) * 16;
			var floor_y_ = floor(y / 16) * 16;
			mp_grid_add_rectangle(movementGrid, floor_x_, floor_y_ - (3 * 16), floor_x_ + (3 * 16) , floor_y_ + (16) - 1);
			break;
		#endregion
	}
}

