
private ["_method", "_dbName", "_recordName", "_recordValue", "_return", "_db", "_broadcast", "_protected"];

_method			= _this select 0;
_dbName			= _this select 1;
_recordName		= _this select 2;
_recordValue	= _this select 3;
_broadcast		= if ((count _this) > 4) then {_this select 4} else {false};
_protected		= if ((count _this) > 5) then {_this select 5} else {false};

_db		= nil;
_return = false;

if (!isNil "_method" && !isNil "_dbName" && !isNil "_recordName" && !isNil "_recordValue" && !isNil "_broadcast" && !isNil "_protected") then {
	private ["_storageKey", "_isProtected"];
	_storageKey 	= [_method, _dbName, _recordName] call cm_core_fnc_getStorageKey;
	_isProtected	= false;
	if (!(isNil "_storageKey")) then {
		_isProtected = _storageKey select 3;
	};
	
	if (!_isProtected) then {
		switch (_method) do {
			case 0: {	// HASHMAP		
				_return = [_dbName, _recordName, _recordValue] call cm_core_fnc_setHashValue;
			};
			case 1: {	// MISSION NAMESPACE
				missionNameSpace setVariable [(_dbName + _recordName), _recordValue];
				_return = true;
			};
			case 2: {	// UI NAMESPACE
				uiNamespace setVariable [(_dbName + _recordName), _recordValue];
				_return = true;
			};
			case 3: {	// HASHMAP DB
				_db = [_dbName, _dbName] call jayarma2lib_fnc_hashmapGetValue;
				if (!isNil "_db") then {
					_db = call compile _db;
					_db = [_db, _recordName, _recordValue] call cm_core_fnc_dbAppend;
					_return = [_dbName, _dbName, _db] call cm_core_fnc_setHashValue;
				};
			};
			case 4: {	// MISSION NAMESPACE DB
				_db = missionNameSpace getVariable [_dbName, []];
				_db = [_db, _recordName, _recordValue] call cm_core_fnc_dbAppend;
				missionNameSpace setVariable [_dbName , _db];
				_return = true;
			};
			case 5: {	// UI NAMESPACE DB
				_db = uiNamespace getVariable [_dbName, []];
				_db = [_db, _recordName, _recordValue] call cm_core_fnc_dbAppend;
				uiNamespace setVariable [_dbName , _db];
				_return = true;
			};
		};
	};
};

if (_return) then {
	[_method, _dbName, _recordName, _broadcast, _protected] call cm_core_fnc_addStorageKey;
} else {
	[(if (_isProtected) then {LOG_NOTICE} else {LOG_ERROR}), 'CORE_QUERY', "Setting of variable '%1' failed. Method: %2. Protected: %3. Value: %4.", [_recordName, _method, _isProtected, _recordValue], __FILE__, __LINE__] call CORE_fnc_log;
};

_return
