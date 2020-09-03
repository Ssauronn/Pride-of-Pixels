/// @function							unit_mine();
/// @description						Allows workers to collect resources and deposit into
///										respective players' total resource count.
function unit_mine() {
	// Check to see if the unit should currently be mining - if not, then set to a different state.
	if objectCurrentCommand == "Mine" {
		// Check to see if a target to mine exists and the target is a valid target, or if a target
		// to attack exists and is valid - otherwise, active variables to search for a new target.
		if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Resource") {
			// Check if within mining range - if not, activate variables to move to the target.
			if distance_to_object(objectTarget) < 16 {
				
			}
			else {
				
			}
		}
		else if (instance_exists(objectTarget)) && (objectTarget.objectClassification == "Unit") && (objectTarget.objectTeam != objectTeam) {
			// Check to see if within attack range - if not, activate variables to move closer to
			// the target.
			if distance_to_object(objectTarget) <= objectRange {
				
			}
			else {
				
			}
		}
		else {
			
		}
	}
	else {
		
	}
}