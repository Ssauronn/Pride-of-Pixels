///@function						deal_damage();
///@parameter						damageValue
///@parameter						damageType
///@parameter						targetID
///@description						Deal damage to the target. Takes into account the 
//									damage value and damage type to correctly calculate
//									actual damage dealt to target.

function deal_damage() {
	var damage_value_ = argument0;
	var damage_type_ = argument1;
	var target_ = argument2;
	// Multiply the base damage by the target's resistance to that damage type to get the true value
	var true_damage_value_ = 0;
	switch damage_type_ {
		case "Slash":
			true_damage_value_ = damage_value_ * target_.objectSlashResistance;
			break;
		case "Crush":
			true_damage_value_ = damage_value_ * target_.objectCrushResistance;
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
		true_damage_value_ = floor(true_damage_value_) + 1;
	}
	target_.currentHP -= true_damage_value_;
}

