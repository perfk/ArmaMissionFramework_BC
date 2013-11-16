
/****************************
*  Preprocessor Definitions
*****************************/

#define METHOD_DB_SEPERATOR		'_'
#define DB_RECORD_SEPERATOR		'_'

/****************************
*  Static Definitions
*****************************/

cm_core_storageKeys				= [];
cm_core_storageKeysLookup		= [];
cm_core_functionKeys			= [];
cm_core_variableKeys			= [];

if (isServer) then {
	cm_core_publicStorageKeys		= [];
	publicVariable "cm_core_publicStorageKeys";
	cm_core_publicStorageKeyRequest	= [-1, ObjNull, []]; // [I/O, Machine, RequestedKeys]
	publicVariable "cm_core_publicStorageKeyRequest";
};

/****************************
*  API Functions
*****************************/

CORE_fnc_callFunction = {
	private ["_functionName", "_parameters", "_function"];
	if (typeName(_this) == "ARRAY") then {
		_functionName		= _this select 0;
		_parameters			= if ((count _this) > 1) then {_this select 1} else {[]};
	} else {
		_functionName = _this;
		_parameters = [];
	};
	_function = [_functionName] call CORE_fnc_getFunction;
	_parameters call _function;
};

CORE_fnc_compileFunction = {
	private ["_functionPath", "_function"];
	_functionPath		= _this select 1;
	_function = compile preProcessFileLineNumbers _functionPath;
	_this set [1, _function];
	_this call CORE_fnc_saveFunction;
	_function
};

CORE_fnc_getFunction = {
	private ["_functionName"];
	if (typeName(_this) == "ARRAY") then {
		_functionName = _this select 0;
	} else {
		_functionName = _this;
	};
	[
		cm_core_functionDBMethod,
		cm_core_functionDB,
		_functionName
	] call cm_core_fnc_queryGet;
};

CORE_fnc_getVariable = {
	private ["_variableName"];
	if (typeName(_this) == "ARRAY") then {
		_variableName = _this select 0;
	} else {
		_variableName = _this;
	};
	[
		cm_core_variableDBMethod,
		cm_core_variableDB,
		_variableName
	] call cm_core_fnc_queryGet;
};

CORE_fnc_saveFunction = {
	private ["_params", "_success"];
	_params = [cm_core_functionDBMethod, cm_core_functionDB] + _this;
	_success = _params call cm_core_fnc_querySetProxy;
	if (_success) then {
		cm_core_functionKeys = cm_core_functionKeys + [(_this select 0)];
	};
	_success
};

CORE_fnc_setVariable = {
	private ["_params", "_success"];
	_params = [cm_core_variableDBMethod, cm_core_variableDB] + _this;
	_success = _params call cm_core_fnc_querySetProxy;
	if (_success) then {
		cm_core_variableKeys = cm_core_variableKeys + [(_this select 0)];
	};
	_success
};

CORE_fnc_spawnFunction = {
	private ["_functionName", "_parameters", "_function", "_return"];
	if (typeName(_this) == "ARRAY") then {
		_functionName		= _this select 0;
		_parameters			= if ((count _this) > 1) then {_this select 1} else {[]};
	} else {
		_functionName = _this;
		_parameters = [];
	};
	_function = [_functionName] call CORE_fnc_getFunction;
	if (typeName(_function) == typeName({})) then {
		_return = _parameters spawn _function;
	};
	_return
};

/****************************
*  Internal Functions
*****************************/

cm_core_fnc_addStorageKey = {
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
};

cm_core_fnc_checkPublicKeys = {
	private ["_requestKeys", "_publicKeyCount"];
	_requestKeys = [];
	waitUntil {!(isNil "cm_core_publicStorageKeys")};
	{
		if (typeName(_x) == "STRING") then {
			if !(_x in cm_core_storageKeysLookup) then {
				_requestKeys = _requestKeys + [_x];
			};
		};
	} forEach cm_core_publicStorageKeys;
	_publicKeyCount = count _requestKeys;
	if (_publicKeyCount > 0) then {
		waitUntil {!(isNil "cm_core_publicStorageKeyRequest") && !(isNull player)};
		cm_core_publicStorageKeyRequest = [1, player, _requestKeys];
		publicVariable "cm_core_publicStorageKeyRequest";
		[LOG_INFO, 'CORE_PUBLIC_KEYS', "Sent request for public keys to server. Count: %1.", [_publicKeyCount], __FILE__, __LINE__] call CORE_fnc_log;
	};
};

cm_core_fnc_createHashMap = {
	private ["_hashmap", "_return"];
	_hashmap = _this select 0;
	[_hashmap] call jayarma2lib_fnc_hashmapDelete;
	_return = [_hashmap] call jayarma2lib_fnc_hashmapCreate;
	if (!_return) then {
		[LOG_ERROR, 'CORE_HASHMAP', " Cannot create HashMap! Check JayArma2Lib connection. HashMap Name: '%1'.", [_hashmap], __FILE__, __LINE__] call CORE_fnc_log;
	};
	_return
};

cm_core_fnc_dbAppend = {
	private ["_index", "_recordValue", "_recordName", "_db"];
	_db				= _this select 0;
	_recordName		= _this select 1;
	_recordValue	= _this select 2;
	_index = (_db select 0) find _recordName;
	if (_index >= 0) then {
		(_db select 1) set [_index, _recordValue];
	} else {
		(_db select 1) set [(count (_db select 1)), _recordValue];
	};
	_db
};

cm_core_fnc_initDatabaseDriver = {
	if (['jayarma2lib'] call CORE_fnc_checkAddon) then {
		{
			if ((_x select 1) in [0,3]) then {
				(_x select 0) call cm_core_fnc_createHashMap;
			};
		} forEach [
			[cm_core_functionDB, cm_core_functionDBMethod],
			[cm_core_variableDB, cm_core_variableDBMethod]
		];
	} else {
		if (cm_core_functionDBMethod in [0,3]) then {cm_core_functionDBMethod = 1};
		if (cm_core_variableDBMethod in [0,3]) then {cm_core_variableDBMethod = 1};
		[LOG_NOTICE, 'CORE', "JayArma2Lib not available. HashMaps cannot be used.", [], __FILE__, __LINE__] call CORE_fnc_log;
	};
	["cm_core_publicQuerySet", cm_core_fnc_querySet] call CBA_fnc_addEventHandler;
	'cm_core_publicStorageKeyRequest' addPublicVariableEventHandler cm_core_fnc_publicKeyRequestHandler;
	if (!isDedicated) then {
		[] spawn cm_core_fnc_checkPublicKeys;
	};
};

cm_core_fnc_getStorageKey = {
	private ["_method", "_dbName", "_recordName", "_broadcast", "_index", "_return", "_keyName"];
	_method		= _this select 0;
	_dbName		= _this select 1;
	_recordName	= _this select 2;
	_keyName	= [_method, _dbName, _recordName] call cm_core_fnc_getStorageKeyName;
	_index		= cm_core_storageKeysLookup find _keyName;
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
};

cm_core_fnc_getStorageKeyName = {
	private ["_method", "_dbName", "_recordName"];
	_method		= _this select 0;
	_dbName		= _this select 1;
	_recordName	= _this select 2;
	str(_method) + METHOD_DB_SEPERATOR + _dbName + DB_RECORD_SEPERATOR + _recordName;
};

cm_core_fnc_publicKeyRequestHandler = {
	private ["_varName", "_requestParams"];
	_varName		= _this select 0;
	_requestParams	= _this select 1;
	_io				= _requestParams select 0;
	_target			= _requestParams select 1;
	_data			= _requestParams select 2;
	if ((_io == 1) && isServer) then {
		private ["_returnData"];
		_returnData = [];
		{
			private ["_index"];
			_index = cm_core_storageKeysLookup find _x;
			if (_index >= 0) then {
				private ["_storageKey"];
				_storageKey = cm_core_storageKeys select _index;
				_returnData = _returnData + [[(_storageKey select 0), (_storageKey select 1), (_storageKey select 2), (_storageKey call cm_core_fnc_queryGet)]];
			};
		} forEach _data;
		cm_core_publicStorageKeyRequest = [0, _target, _returnData];
		publicVariable "cm_core_publicStorageKeyRequest";
		[LOG_INFO, 'CORE_PUBLIC_KEYS', "Recieved request for public keys & sent data. Request Count: %1. Sent Count: %2. Target: '%3'.", [(count _data), (count _returnData), (name _target)], __FILE__, __LINE__] call CORE_fnc_log;
	};
	if ((_io == 0) && !isDedicated && (_target == player)) then {
		{
			_x call cm_core_fnc_querySet;
		} forEach _data;
		[LOG_INFO, 'CORE_PUBLIC_KEYS', "Recieved public key data from server. Count: %1.", [(count _data)], __FILE__, __LINE__] call CORE_fnc_log;
	};
};

cm_core_fnc_queryGet = {
	private ["_method", "_dbName", "_recordName", "_defaultValue", "_return", "_db"];
	_method			= _this select 0;
	_dbName			= _this select 1;
	_recordName		= _this select 2;
	_defaultValue	= if ((count _this) > 3) then {_this select 3} else {nil};
	_db				= nil;
	_return			= nil;
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
};

cm_core_fnc_querySet = {
	private ["_method", "_dbName", "_recordName", "_recordValue", "_return", "_db", "_broadcast", "_protected"];
	_method			= _this select 0;
	_dbName			= _this select 1;
	_recordName		= _this select 2;
	_recordValue	= _this select 3;
	_broadcast		= if ((count _this) > 4) then {_this select 4} else {false};
	_protected		= if ((count _this) > 5) then {_this select 5} else {false};
	_db				= nil;
	_return			= false;
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
};

cm_core_fnc_querySetProxy = {
	private ["_broadcast", "_return"];
	_broadcast = if ((count _this) > 4) then {_this select 4} else {false};
	_return = _this call cm_core_fnc_querySet;
	if (_broadcast) then {
		["cm_core_publicQuerySet", _this] call CBA_fnc_remoteEvent;
		[LOG_INFO, 'CORE_QUERY', "Variable Set has been broadcasted with params '%1'.", [_this], __FILE__, __LINE__] call CORE_fnc_log;
	};
	_return
};

cm_core_fnc_setHashValue = {
	private ["_hashTable", "_hashKey", "_hashValue"];
	_hashTable		= _this select 0;
	_hashKey		= _this select 1;
	_hashValue		= _this select 2;
	[_hashTable, _hashKey] call jayarma2lib_fnc_hashmapDeleteValue;
	[_hashTable, _hashKey, str(_hashValue)] call jayarma2lib_fnc_hashmapAddValue;
};
