
/****************************
*  Preprocessor Macros
*****************************/

#define ASSERT_ARRAY if (typeName(_this) != "ARRAY") then {_this = [_this]}
#define DEFAULT_PARAM(idx,dft) if ((count _this) > idx) then {_this select idx} else {dft}

/****************************
*  Preprocessor Definitions
*****************************/

#define METHOD_DB_SEPERATOR '_'
#define DB_RECORD_SEPERATOR '_'

/****************************
*  Static Definitions
*****************************/

cm_core_storageKeys			= [];
cm_core_storageKeysLookup	= [];
cm_core_functionKeys		= [];
cm_core_variableKeys		= [];

if (isServer) then {
	cm_core_publicStorageKeys = [];
	publicVariable "cm_core_publicStorageKeys";
	cm_core_publicStorageKeyRequest = [-1, ObjNull, []]; // [I/O, Machine, RequestedKeys]
	publicVariable "cm_core_publicStorageKeyRequest";
};

/****************************
*  API Functions
*****************************/

CORE_fnc_callFunction = {
	ASSERT_ARRAY;
	private ["_functionName", "_parameters", "_function"];
	_functionName = _this select 0;
	_parameters = DEFAULT_PARAM(1,[]);
	_function = [_functionName] call CORE_fnc_getFunction;
	if (!isNil "_function") then {
		_parameters call _function;
	} else {nil};
};

CORE_fnc_compileFunction = {
	ASSERT_ARRAY;
	private ["_functionName", "_functionPath", "_function"];
	_functionName = _this select 0;
	_functionPath = _this select 1;
	_protected = DEFAULT_PARAM(2,false);
	_function = compile preProcessFileLineNumbers _functionPath;
	[_functionName, _function, _protected] call CORE_fnc_saveFunction;
};

CORE_fnc_getFunction = {
	ASSERT_ARRAY;
	private ["_functionName"];
	_functionName = _this select 0;
	[0,
		cm_core_functionDBMethod,
		cm_core_functionDB,
		_functionName
	] call cm_core_fnc_query;
};

CORE_fnc_getVariable = {
	ASSERT_ARRAY;
	private ["_variableName"];
	_variableName = _this select 0;
	[0,
		cm_core_variableDBMethod,
		cm_core_variableDB,
		_variableName
	] call cm_core_fnc_query;
};

CORE_fnc_saveFunction = {
	ASSERT_ARRAY;
	private ["_functionName", "_function", "_protected", "_success"];
	_functionName = _this select 0;
	_function = _this select 1;
	_protected = DEFAULT_PARAM(2,false);
	_success = [1,
		cm_core_functionDBMethod,
		cm_core_functionDB,
		_functionName,
		_function,
		false,
		_protected
	] call cm_core_fnc_query;
	if (_success) then {
		cm_core_functionKeys = cm_core_functionKeys + [_functionName];
	};
	_success
};

CORE_fnc_setVariable = {
	ASSERT_ARRAY;
	private ["_params", "_success"];
	_varName = _this select 0;
	_value = _this select 1;
	_broadcast = DEFAULT_PARAM(2,false);
	_protected = DEFAULT_PARAM(3,false);
	_success = [1,
		cm_core_functionDBMethod,
		cm_core_functionDB,
		_functionName,
		_function,
		_broadcast,
		_protected
	] call cm_core_fnc_query;
	if (_success) then {
		cm_core_variableKeys = cm_core_variableKeys + [_varName];
	};
	_success
};

CORE_fnc_spawnFunction = {
	ASSERT_ARRAY;
	private ["_functionName", "_parameters", "_function"];
	_functionName = _this select 0;
	_parameters = DEFAULT_PARAM(1,[]);
	_function = [_functionName] call CORE_fnc_getFunction;
	if (!isNil "_function") then {
		_parameters spawn _function;
	} else {nil};
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
	_keyName	= [_method, _dbName, _recordName] call cm_core_fnc_storageKeyName;
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

cm_core_fnc_initDatabaseDriver = {
	call cm_core_fnc_initLoadSchemas;
	["cm_core_publicQuerySet", cm_core_fnc_query] call CBA_fnc_addEventHandler;
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
	_keyName	= [_method, _dbName, _recordName] call cm_core_fnc_storageKeyName;
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

cm_core_fnc_initLoadSchemas = {
	private ["_schemas"];
	_schemas = ["core\drivers\database\schemas\manifest.file"] call cm_core_fnc_loadManifest;
	cm_core_db_schemas = [];
	{ // forEach
		if (typeName(_x) == "STRING") then {
			private ["_path", "_file"];
			_path = "core\drivers\database\schemas\scm_" + _x + ".sqf";
			_file = preProcessFileLineNumbers _path;
			if (_file != "") then {
				cm_core_db_schemas set [(count cm_core_db_schemas), [_x, (compile _file)]];
			} else {
				[LOG_ERROR, 'CORE_DATABASE', "Cannot load the '%1' schema in the schema manifest! Error: No matching schema file. Manifest File: '%2'.", [_x, _path], __FILE__, __LINE__] call CORE_fnc_log;
			};
		} else {
			[LOG_ERROR, 'CORE_DATABASE', "Cannot load a schema in the schema manifest! Error: Not a string. Manifest corrupted.", [], __FILE__, __LINE__] call CORE_fnc_log;
		};
	} forEach _schemas;
};

cm_core_fnc_opFlatDB = {
	private ["_call", "_dbData", "_record", "_data", "_return", "_index"];
	_call	= _this select 0;
	_dbData	= _this select 1;
	_record	= _this select 2;
	_data	= _this select 3;
	_return	= nil;
	_index	= (_dbData select 0) find _record;
	switch (_call) do {
		case 0: { // Read
			if (_index >= 0) then {
				_return = (_dbData select 1) select _index;
			} else {
				_return = _data;
			};
		};
		case 1: { // Write
			if (_index < 0) then {_index = count _dbData};
			(_dbData select 1) set [_index, _data];
			_return = true;
		};
	};
	_return
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
				_returnData = _returnData + [[_storageKey, ([0, (_storageKey select 0), (_storageKey select 1), (_storageKey select 2)] call cm_core_fnc_query)]];
			};
		} forEach _data;
		cm_core_publicStorageKeyRequest = [0, _target, _returnData];
		publicVariable "cm_core_publicStorageKeyRequest";
		[LOG_INFO, 'CORE_PUBLIC_KEYS', "Recieved request for public keys & sent data. Request Count: %1. Sent Count: %2. Target: '%3'.", [(count _data), (count _returnData), (name _target)], __FILE__, __LINE__] call CORE_fnc_log;
	};
	if ((_io == 0) && !isDedicated && {_target == player}) then {
		{
			private ["_storageKey", "_transData", "_method", "_db", "_record", "_broadcast", "_protected"];
			_storageKey	= _x select 0;
			_transData	= _x select 1;
			_method		= _storageKey select 0;
			_db			= _storageKey select 1;
			_record		= _storageKey select 2;
			_broadcast	= _storageKey select 3;
			_protected	= _storageKey select 4;
			[1, _method, _db, _record, _transData, _broadcast, _protected, false] call cm_core_fnc_query;
		} forEach _data;
		[LOG_INFO, 'CORE_PUBLIC_KEYS', "Recieved public key data from server. Count: %1.", [(count _data)], __FILE__, __LINE__] call CORE_fnc_log;
	};
};

cm_core_fnc_query = {
	private ["_call", "_method", "_db", "_record", "_data", "_exit", "_schema", "_return"];
	_call		= _this select 0;
	_method		= _this select 1;
	_db			= _this select 2;
	_record		= _this select 3;
	_data		= if ((count _this) > 4) then {_this select 4} else {nil};
	_exit		= false;
	_schema		= nil;
	_return		= nil;
	if (_call == 1) then {
		private ["_storageKey"];
		_storageKey = [_method, _db, _record] call cm_core_fnc_getStorageKey;
		if (!isNil "_storageKey" && {_storageKey select 3}) then {
			_exit = true;
		};
	};
	if (!_exit) then {
		{ // forEach
			if ((_x select 0) == _method) exitWith {
				_schema = _x select 1;
			};
		} forEach cm_core_db_schemas;
		if (!isNil "_schema") then {
			_return = _this call _schema;
			if ((_call == 1) && _return) then {
				private ["_broadcast", "_protected", "_local"];
				_broadcast	= if ((count _this) > 5) then {_this select 5} else {false};
				_protected	= if ((count _this) > 6) then {_this select 6} else {false};
				_local		= if ((count _this) > 7) then {_this select 7} else {true};
				[_method, _db, _record, _broadcast, _protected] call cm_core_fnc_addStorageKey;
				if (_broadcast && _local) then {
					["cm_core_publicQuerySet", [_call, _method, _db, _record, _data, _broadcast, _protected, false]] call CBA_fnc_remoteEvent;
					[LOG_INFO, 'CORE_QUERY', "Variable Set has been broadcasted with params '%1'.", [_this], __FILE__, __LINE__] spawn CORE_fnc_log;
				};
			};
		};
	};
	_return
};

cm_core_fnc_storageKeyName = {
	str(_this select 0) + METHOD_DB_SEPERATOR + (_this select 1) + DB_RECORD_SEPERATOR + (_this select 2);
};
