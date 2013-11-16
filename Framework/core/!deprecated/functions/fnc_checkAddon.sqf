
/***********************
*
*	Common Addons:
*
*		cba
*		CBA_A2
*		CBA_OA
*		jayarma2lib
*		ace
*		acex
*		acre
*
***********************/

private ["_addon", "_result"];

_addon	= _this select 0;
_suffix	= if ((count _this) > 1) then {_this select 1} else {true};
_result	= nil;

if (!isNil "_addon") then {
	if (_suffix) then {_addon = _addon + "_main"};
	_result = isClass(configFile >> "CfgPatches" >> _addon);
};

_result
