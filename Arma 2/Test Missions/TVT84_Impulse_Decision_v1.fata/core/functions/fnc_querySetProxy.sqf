
private ["_broadcast", "_return"];

_broadcast = if ((count _this) > 4) then {_this select 4} else {false};

_return = _this call cm_core_fnc_querySet;

if (_broadcast) then {
	["cm_core_publicQuerySet", _this] call CBA_fnc_remoteEvent;
	[LOG_INFO, 'CORE_QUERY', "Variable Set has been broadcasted with params '%1'.", [_this], __FILE__, __LINE__] call CORE_fnc_log;
};

_return
