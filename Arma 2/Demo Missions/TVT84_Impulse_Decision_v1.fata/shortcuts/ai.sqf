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

/*
Unit Name Scheme:	side_pltNum_squadNum_ftNum_class
	ie.				blu_1_6_0_sl
*/

// [this] execVM 'shortcuts\ai.sqf';

waitUntil {!isNil "CBA_fnc_split"};

private ["_unit", "_class"];
_unit		= _this select 0;
_unitParams	= [(format["%1", _unit]), "_"] call CBA_fnc_split;
_class		= if ((count _this) > 1) then {_this select 1} else {_unitParams select 4};

if ((leader (group _unit)) == _unit) then {
	[_unit] execVM 'shortcuts\patrol.sqf';
};

[_unit, _class] execVM 'shortcuts\gear.sqf';
