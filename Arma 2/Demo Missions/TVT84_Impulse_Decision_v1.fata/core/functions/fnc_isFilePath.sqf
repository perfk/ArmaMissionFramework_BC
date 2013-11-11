
if (typeName(_this) != typeName([])) then {_this = [_this]};

private ["_stringArray"];
_stringArray = toArray(_this select 0);

((_stringArray find 46) >= 0) && ((_stringArray find 34) < 0) && ((_stringArray find 39) < 0) // 46='.', 34=("), 39=(') (ie: 'path\file.sqf')