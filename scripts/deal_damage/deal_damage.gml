///@function						deal_damage();
///@param	{real} damageValue		The damage value of the attack
///@param	{string} damageType		The type of damage - used to determine what defenses are relevant.
///@param	{index} targetID		The target that is being hit with the damage.
///@description						Deal damage to the target. Takes into account the 
//									damage value and damage type to correctly calculate
//									actual damage dealt to target.

function deal_damage(damage_value_, damage_type_, target_) {
	// Multiply the base damage by the target's resistance to that damage type to get the true value
	var true_damage_value_ = 0;
	switch damage_type_ {
		case "Slash":
			true_damage_value_ = damage_value_ * target_.objectSlashResistance;
			break;
		case "Pierce":
			true_damage_value_ = damage_value_ * target_.objectPierceResistance;
			break;
		case "Magic":
			true_damage_value_ = damage_value_ * target_.objectMagicResistance;
			break;
	}
	// Just making sure a resistance cannot heal the target.
	if true_damage_value_ < 0 {
		true_damage_value_ = 0;
	}
	// If the true damage value is not a whole number, always round up to the next integer.
	if frac(true_damage_value_) != 0 {
		true_damage_value_ = ceil(true_damage_value_);
	}
	target_.currentHP -= true_damage_value_;
}


