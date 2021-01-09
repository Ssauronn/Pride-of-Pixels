///@description Track Global Stats
// Create the function used to create a struct for each team in the game
team_struct = function(team_) constructor {
	team = team_;
	food = 0;
	wood = 0;
	gold = 0;
	rubies = 0;
}
// Create an array and assign it to globalvar player, then give each array a struct to hold.
globalvar player, totalAmountOfTeams;
// Neutral, player, and enemy team means that this number will normally never dip below 3.
totalAmountOfTeams = 3;
var i;
for (i = 0; i < totalAmountOfTeams; i++) {
	if i == 0 {
		player[i] = new team_struct("Neutral");
	}
	else {
		player[i] = new team_struct(i);
	}
}



