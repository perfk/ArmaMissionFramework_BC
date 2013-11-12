
private ["_variableName", "_variableValue"];

if (typeName(_this) == "ARRAY") then {
	_variableName = _this select 0;
} else {
	_variableName = _this;
};

_variableValue = [
	cm_core_variableDBMethod,
	cm_core_variableDB,
	_variableName
] call cm_core_fnc_queryGet;

_variableValue
