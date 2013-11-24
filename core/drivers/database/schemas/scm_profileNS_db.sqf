
private ["_dbData"];
_dbData = profileNamespace getVariable [_db, [[],[]]];

// Modify _dbData by reference
_return = [_call, _dbData, _record, _data] call cm_core_fnc_opFlatDB;

if (_call == 1) then { // Write
	profileNamespace setVariable [_db, _dbData];
};

_return