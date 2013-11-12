
private ["_hashmap", "_return"];

_hashmap = _this select 0;

[_hashmap] call jayarma2lib_fnc_hashmapDelete;
_return = [_hashmap] call jayarma2lib_fnc_hashmapCreate;

if (!_return) then {
	[LOG_ERROR, 'CORE_HASHMAP', " Cannot create HashMap! Check JayArma2Lib connection. HashMap Name: '%1'.", [_hashmap], __FILE__, __LINE__] call CORE_fnc_log;
};

_return
