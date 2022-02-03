/// @description Manage Global Stats
if anyStatBeingUpdated {
	count_down_timers();
}

if anyStatUpdated {
	var i;
	for (i = 1; i < totalAmountOfTeams - 1; i++) {
		with player[i] {
			// ADJUST AS MORE UNITS AND/OR BUILDINGS ARE ADDED
			// In this case, I need to add a manual check for each unit or structure that has a list of
			// possible upgrades. If any upgrades have finished, I need to run through, update the stat
			// list for any possible stat upgrades, and notify obj_gui to update the GUI.
			
			// Check for City Hall upgrades
			if cityHall.statUpdated {
				with cityHall {
					statUpdated = false;
					// Go through all struct variables to see what, if anything needs to be updated
					
				}
			}
		}
	}
}
