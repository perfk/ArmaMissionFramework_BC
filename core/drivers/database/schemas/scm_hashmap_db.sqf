#include "schema_header.sqf"
#include "init_hashmap.sqf"

private ["_dbData"];
_dbData = [_db, _db] call jayarma2lib_fnc_hashmapGetValue;

if (isNil "_dbData") then {
	_dbData = [[],[]];
} else {
	_dbData = call compile _dbData;
};

// Modify _dbData by reference
_return = [_call, _dbData, _record, _data] call cm_core_fnc_opFlatDB;

if (_call == 1) then { // Write
	[_db, _db, str(_dbData)] call jayarma2lib_fnc_hashmapSetValue;
};

_return