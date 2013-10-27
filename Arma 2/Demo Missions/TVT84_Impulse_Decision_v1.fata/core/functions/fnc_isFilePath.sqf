
if (typeName(_this) != typeName([])) then {_this = [_this]};

private ["_string", "_stringArray"];
_string			= _this select 0;
_stringArray	= toArray(_string);

((_stringArray find 46) >= 0) && ((_stringArray find 34) < 0) && ((_stringArray find 39) < 0) // 46='.', 34=("), 39=(') (ie: 'path\file.sqf')