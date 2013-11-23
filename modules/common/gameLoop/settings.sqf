
private ["_timeLimit", "_glCheckFreq", "_endTimeOut", "_westPercLoss", "_eastPercLoss", "_guerPercLoss", "_civPercLoss", "_endMissionFunc", "_missionObjCheckFunc"];

_timeLimit		= PARAMS_TimeLimit * 60;	// Mission Time Limit (in seconds)
_glCheckFreq	= 30;						// Game Loop Check Frequency (in seconds)
_endTimeOut		= 30;						// End Screen Time Out (in seconds)

/* Use a percent > 100 to never lose due to casualties */
_westPercLoss	=  80;						// BLU - Percent of initial force LOST to lose game
_eastPercLoss	=  80;						// OP  - Percent of initial force LOST to lose game
_guerPercLoss	= 101;						// IND - Percent of initial force LOST to lose game
_civPercLoss	= 101;						// CIV - Percent of initial force LOST to lose game

_endMissionFunc	= {							// Function called (on all machines) to end current mission
	['gameLoop_endMission', _this] call CORE_fnc_callFunction;
};

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
_missionObjCheckFunc = {
	/* This is the basics of a standard mission objective check function */
	private ["_endMission", "_header", "_description"];
	_endMission		= false;
	_header			= "";
	_description	= "";
	
	/***************************/
	/* No need to change above */
	/***************************/
	/**** Start Custom Code ****/
	/***************************/
	
	// REPLACE THIS WITH CODE
	
	/***************************/
	/****  End Custom Code  ****/
	/***************************/
	/* No need to change below */
	/***************************/
	
	[
		_endMission,		// End Mission? (Bool)
		[
			_header,		// End Mission Header
			_description	// End Mission Description
		]
	]
};