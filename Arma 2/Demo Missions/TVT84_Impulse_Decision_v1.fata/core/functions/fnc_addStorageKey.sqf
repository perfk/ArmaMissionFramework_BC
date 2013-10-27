
// Returns (bool) if key had to override another key

private ["_method", "_dbName", "_recordName", "_broadcast", "_protected", "_index", "_overRide", "_keyName"];

_method		= _this select 0;
_dbName		= _this select 1;
_recordName	= _this select 2;
_broadcast	= _this select 3;
_protected	= _this select 4;
_overRide	= true;
_keyName	= [_method, _dbName, _recordName] call cm_core_fnc_getStorageKeyName;

_index = cm_core_storageKeysLookup find _keyName;
if (_index < 0) then {_index = count cm_core_storageKeysLookup; _overRide = false;};

cm_core_storageKeys set [_index, [_method, _dbName, _recordName, _protected]];
cm_core_storageKeysLookup set [_index, _keyName];

if (isServer && _broadcast) then {
	private ["_publicIndex"];
	_publicIndex = cm_core_publicStorageKeys find _keyName;
	if (_publicIndex < 0) then {_publicIndex = count cm_core_publicStorageKeys};
	
	cm_core_publicStorageKeys set [_publicIndex, _keyName];
	publicVariable "cm_core_publicStorageKeys";
};

_overRide
