///@description Track Global Stats
// Create the function used to create a struct for each team in the game
enum eUpgradeTree {
	universal,
	magic,
	technology
}
enum eUpgradeType {
	offensive,
	defensive,
	innovation,
	special
}
enum eUpgradeOrder {
	one,
	two,
	three,
	four,
	five,
	six,
	seven,
	eight,
	nine,
	ten
}
enum eUpgradeSibling {
	a,
	b,
	c,
	noone
}
/// Some basic stat tracking variables
// Set once any stat has finished an update to true, otherwise always set to false
anyStatUpdated = false;
// Set to false by default, else set to a string equal to the building type that is currently
// being updated. If multiple building types are counting down upgrade timers, this will be set
// to any of those buildings' types (the specific type doesn't matter as once an upgrade finishes,
// another check goes through all stats to see if anything else is being updated).
anyStatBeingUpdated = false;

// Create an array and assign it to globalvar player, then give each array a struct to hold.
globalvar player, totalAmountOfTeams;
// Neutral, player, and enemy team means that the count will normally never dip below 3.
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

// Debug testing
show_debug_message(string(player[1].cityHall.discovery.description));

