
CORE_fnc_checkAddon = {
	private ["_addon", "_result"];
	_addon	= _this select 0;
	_suffix	= if ((count _this) > 1) then {_this select 1} else {true};
	_result	= nil;
	if (!isNil "_addon") then {
		if (_suffix) then {_addon = _addon + "_main"};
		_result = isClass(configFile >> "CfgPatches" >> _addon);
	};
	_result
};

CORE_fnc_isFilePath = {
	if (typeName(_this) != typeName([])) then {_this = [_this]};
	private ["_stringArray"];
	_stringArray = toArray(_this select 0);
	((_stringArray find 46) >= 0) && ((_stringArray find 34) < 0) && ((_stringArray find 39) < 0) // 46='.', 34=("), 39=(') (ie: 'path\file.sqf')
};