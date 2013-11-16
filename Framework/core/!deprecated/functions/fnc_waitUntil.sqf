
private ["_code", "_component", "_timeOut", "_logLevel", "_startTime", "_timeOutEnabled", "_textArray"];
_code			= _this select 0;
_component		= if ((count _this) > 1) then {_this select 1} else {""};
_timeOut		= if ((count _this) > 2) then {_this select 2} else {0};
_logLevel		= if ((count _this) > 3) then {_this select 3} else {LOG_INFO};
_startTime		= diag_tickTime;
_timeOutEnabled	= _timeOut > 0;

if (typeName(_code) != typeName([])) then {_code = [_code]};

_textArray = if (_component == "") then {
	["Waiting...", "Waiting"];
} else {
	["Waiting for " + _component + "...", _component];
};

[_logLevel, 'CORE_WAIT_UNTIL', (_textArray select 0), [], __FILE__, __LINE__] call CORE_fnc_log;

{
	if (typeName(_x) == typeName("")) then {_x = compile _x};
	waitUntil {(call _x) || (_timeOutEnabled && (_timeOut < diag_tickTime))};
} forEach (+_code);

[_logLevel, 'CORE_WAIT_UNTIL', ((_textArray select 1) + " done! Delay: %1 seconds. Proceeding."), [(diag_tickTime - _startTime)], __FILE__, __LINE__] call CORE_fnc_log;

true
