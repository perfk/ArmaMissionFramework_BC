
private ["_method", "_dbName", "_recordName", "_defaultValue", "_return", "_db"];

_method			= _this select 0;
_dbName			= _this select 1;
_recordName		= _this select 2;
_defaultValue	= if ((count _this) > 3) then {_this select 3} else {nil};

_db		= nil;
_return = nil;

if (!isNil "_method" && !isNil "_dbName" && !isNil "_recordName") then {
	switch (_method) do {
		case 0: {	// HASHMAP
			_return = [_dbName, _recordName] call jayarma2lib_fnc_hashmapGetValue;
			if (!isNil "_return") then {
				_return = call compile _return;
			};
		};
		case 1: {	// MISSION NAMESPACE
			_return = missionNameSpace getVariable [(_dbName + _recordName), nil];
		};
		case 2: {	// UI NAMESPACE
			_return = uiNamespace getVariable [(_dbName + _recordName), nil];
		};
		case 3: {	// HASHMAP DB
			_db = [_dbName, _dbName] call jayarma2lib_fnc_hashmapGetValue;
			if (!isNil "_return") then {
				_db = call compile _db;
			};
		};
		case 4: {	// MISSION NAMESPACE DB
			_db = missionNameSpace getVariable [_dbName, nil];
		};
		case 5: {	// UI NAMESPACE DB
			_db = uiNamespace getVariable [_dbName, nil];
		};
	};
};

if (!isNil "_db") then {
	
	private ["_index"];
	
	_index = (_db select 0) find _recordName;
	
	if (_index >= 0) then {
		_return = (_db select 1) select _index;
	};
};

if (isNil "_return") then {
	if (!(isNil "_defaultValue")) then {
		_return = _defaultValue;
	} else {
		[LOG_INFO, 'CORE_QUERY', "Variable '%1' returned nil.", [_recordName], __FILE__, __LINE__] spawn CORE_fnc_log;
	};
};

_return
