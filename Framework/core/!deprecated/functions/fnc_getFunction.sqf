
private ["_functionName", "_function"];

if (typeName(_this) == "ARRAY") then {
	_functionName = _this select 0;
} else {
	_functionName = _this;
};

_function = [
	cm_core_functionDBMethod,
	cm_core_functionDB,
	_functionName
] call cm_core_fnc_queryGet;

_function
