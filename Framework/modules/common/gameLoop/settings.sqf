
// Check out 'functions\fnc_missionObjCheck.sqf' for adding mission objectives to the end script

private ["_timeLimit", "_westPercLoss", "_eastPercLoss", "_guerPercLoss", "_civPercLoss", "_endMissionFunc"];

_timeLimit		= PARAMS_TimeLimit * 60;	// Mission Time Limit (in seconds)
_endTimeOut		= 30;						// End Screen Time Out (in seconds)

/* Use a percent > 100 to never lose due to casualties */
_westPercLoss	=  80;						// BLU - Percent of initial force LOST to lose game
_eastPercLoss	=  80;						// OP  - Percent of initial force LOST to lose game
_guerPercLoss	= 101;						// IND - Percent of initial force LOST to lose game
_civPercLoss	= 101;						// CIV - Percent of initial force LOST to lose game

_endMissionFunc	= {							// Function called (on all machines) to end current mission
	['gameLoop_endMission', _this] call CORE_fnc_callFunction;
};
