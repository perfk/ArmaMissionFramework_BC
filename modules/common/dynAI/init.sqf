
// Load Settings
#include "settings.sqf"

// Load Functions
private ["_functions"];
_functions = [
	["gameLoop_serverLoop", 	"modules\common\dynAI\functions\fnc_serverLoop.sqf", false, true, [], CORE_LMS_server]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/



/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
