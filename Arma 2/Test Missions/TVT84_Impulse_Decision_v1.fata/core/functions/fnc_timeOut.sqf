
private ["_variable", "_timeOut", "_varCheck", "_startTime", "_endTime"];

_func		= _this select 0;
_timeOut	= _this select 1;
_varCheck	= nil;
_startTime	= diag_tickTime;
_endTime	= _startTime + _timeOut;

if (typeName(_func) == typeName("")) then {
	_func = compile _func;
};

if (typeName(_func) == typeName({})) then {
	waitUntil {
		_varCheck = [_startTime, _timeOut, _endTime] call _func;
		((!isNil "_varCheck") OR (diag_tickTime > _endTime));
	};
};

if (isNil "_varCheck") then {
	[LOG_INFO, 'CORE', "Function Check timed-out after %1 seconds.", [round(diag_tickTime - _startTime)], __FILE__, __LINE__] call CORE_fnc_log;
};

_varCheck
