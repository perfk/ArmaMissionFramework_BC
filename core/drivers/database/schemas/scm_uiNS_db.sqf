#include "schema_header.sqf"

private ["_dbData"];
_dbData = uiNamespace getVariable [_db, [[],[]]];

// Modify _dbData by reference
_return = [_call, _dbData, _record, _data] call cm_core_fnc_opFlatDB;

if (_call == 1) then { // Write
	uiNamespace setVariable [_db, _dbData];
};

_return