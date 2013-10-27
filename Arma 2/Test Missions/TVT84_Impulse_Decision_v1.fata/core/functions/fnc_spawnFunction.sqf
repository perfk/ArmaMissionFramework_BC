
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
