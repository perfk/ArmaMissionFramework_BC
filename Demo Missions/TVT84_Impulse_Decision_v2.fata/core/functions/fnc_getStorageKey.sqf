
private ["_method", "_dbName", "_recordName", "_broadcast", "_index", "_return", "_keyName"];

_method		= _this select 0;
_dbName		= _this select 1;
_recordName	= _this select 2;
_keyName	= [_method, _dbName, _recordName] call cm_core_fnc_getStorageKeyName;

_index = cm_core_storageKeysLookup find _keyName;

if (_index < 0) then {
	_return = nil;
} else {
	_return = cm_core_storageKeys select _index;
};

if (isNil "_return") then {
	nil;
} else {
	_return;
};