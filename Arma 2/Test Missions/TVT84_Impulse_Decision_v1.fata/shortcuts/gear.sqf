/*
    Copyright 2013 Dylan Plecki

    This file is part of Naught's Mission Framework.

    Naught's Mission Framework is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Naught's Mission Framework is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Naught's Mission Framework. If not, see <http://www.gnu.org/licenses/>.

*/

/************************************************
*	Load Gear & Equipment
*
*	Description:
*		This File serves as an entry point to the
*		Gear Module. You may call it within the
*		mission editor text fields to load a
*		unit's gear easily.
*
*	Example:
*		[this, 'sl'] execVM 'editor\gear.sqf';
*		[this, 'mtvr'] execVM 'editor\gear.sqf';
*		[this, 'r', 'WEST'] execVM 'editor\gear.sqf';
*
************************************************/

call compile preProcessFileLineNumbers "modules\common\gear\init.sqf";

private ["_unit", "_class", "_file", "_gear", "_func", "_side"];
_unit		= _this select 0;
_class		= _this select 1;
_func		= nil;

_type = if ((count _this) > 2) then {_this select 2} else { // 0 = Man, 1 = Vehicle
	if (_unit isKindOf "Man") then {0} else {1};
};

switch (_type) do {
	case 0: { // Man
		_func = gear_setLoadout;
		_side = format["%1", (side _unit)];
	};
	case 1: { // Vehicle
		if (_unit isKindOf "AllVehicles") then { // Ensure Vehicle
			_func = gear_setVehLoadout;
			_side = "VEHICLES";
		};
	};
};

if ((count _this) > 3) then {_side = _this select 3};

if !(isNil "_func") then {
	_file		= "modules\common\gear\loadouts\" + _side + "\" + _class + ".sqf";
	_gear		= [_unit, _class, _side] call compile preProcessFileLineNumbers _file;
	
	if ((_gear select 0) != _unit) then {
		_gear = [_unit] + _gear;
	};
	
	_gear call _func;
};
