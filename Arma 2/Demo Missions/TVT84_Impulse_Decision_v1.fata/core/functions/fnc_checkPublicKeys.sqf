
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
