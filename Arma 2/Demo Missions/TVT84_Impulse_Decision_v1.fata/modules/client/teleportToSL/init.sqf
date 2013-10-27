
private ["_functions"];

#include "settings.sqf"

// Load Functions
_functions = [
	["teleportToSL","modules\client\teleportToSL\functions\fnc_teleportToSL.sqf"],
	["ttSL_addToSelfInteract","modules\client\teleportToSL\functions\fnc_addToSelfInteract.sqf", [], true, CORE_LMS_player]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/



/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions