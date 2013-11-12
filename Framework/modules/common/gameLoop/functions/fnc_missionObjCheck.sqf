
/****************************************
*	Mission Objective Check
*
*		This is the area to put all
*		mission-specific game loop checks
*		for the end conditions.
*
*		ie. This is where you can check
*			if a briefcase was recovered.
*
*		Note: This function MUST return
*			  an array value. Index 0 must
*			  be boolean. True for
*			  mission end, false to
*			  continue the mission. Index
*			  1 is an array of the end
*			  condition's title and desc.
*			    ie. To end a mission:
*			    [true, ["Blufor Won!", 
*			    "Blufor killed the HVT"]]
****************************************/

private ["_endMission", "_header", "_description"];
_endMission		= false;
_header			= "";
_description	= "";

/* Process Mission Objective Checking Here */

[
	_endMission,		// End Mission? (Bool)
	[
		_header,		// End Mission Header
		_description	// End Mission Description
	]
]
