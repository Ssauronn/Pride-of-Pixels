///@function						set_return_resource_variables_noone()
///@description						Set returnToResourceX, returnToResourceY, and
///									returnToResourceID to noone once done with those variables.
function set_return_resource_variables_noone() {
	returnToResourceX = noone;
	returnToResourceY = noone;
	returnToResourceID = noone;
	returnToResourceType = noone;
	returnToResourceDropPointID = noone;
}


///@function							set_return_resource_variables()
///@param	{real}		x				The x value of the resource to return to
///@param	{real}		y				The y value of the resource to return to
///@param	{real}	instance_id_	The type of resource to return to
///@description							Set returnToResourceX, returnToResourceY, and
///										returnToResourceID to the correct values once a Worker
///										unit has filled up with resources and needs to return to
///										a drop point.
function set_return_resource_variables(x_, y_, instance_id_, drop_point_id_) {
	if objectClassification == "Unit" && objectType == "Worker" {
		returnToResourceX = x_;
		returnToResourceY = y_;
		returnToResourceID = real(instance_id_);
		returnToResourceType = instance_id_.objectType;
		returnToResourceDropPointID = drop_point_id_
	}
}


