
#include "settings.sqf"

// Load Functions
_functions = [
	["building_buildStruct", "modules\client\building\functions\fnc_buildStruct.sqf"],
	["building_init", "modules\client\building\functions\fnc_init.sqf", [_structures], true, CORE_LMS_player, cm_core_priority_last]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

building_playerBusy = false;

['building_buildMenuCondition', _buildMenuCond] call CORE_fnc_saveFunction;
['building_previewUpdateSpeed', _previewUpdateSpeed] call CORE_fnc_setVariable;
['building_previewMethod', _previewMethod] call CORE_fnc_setVariable;

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions