
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
			private ["_storageKey", "_tempData"];
			_storageKey = cm_core_storageKeys select _index;
			_tempData = _storageKey call cm_core_fnc_queryGet;
			_storageKey set [(count _storageKey), _tempData];
			_returnData = _returnData + [_storageKey];
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
