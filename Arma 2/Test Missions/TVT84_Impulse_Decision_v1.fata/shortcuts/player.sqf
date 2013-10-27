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

// _this = [_unit, 'team', 'squadName', 'class', pltNum, squadNum]
// [this] execVM 'editor\player.sqf';

waitUntil {!isNil "CBA_fnc_split" && !isNil "CBA_fnc_capitalize"};

private ["_unit", "_class", "_team", "_platoon", "_squad", "_squadName"];
_unit		= _this select 0;

_unitParams	= [(format["%1", _unit]), "_"] call CBA_fnc_split;

_team		= if ((count _this) > 1) then {_this select 1} else {
	switch (parseNumber(_unitParams select 3)) do {
		case 1: {"BLUE"};
		case 2: {"RED"};
		case 3: {"GREEN"};
		case 4: {"YELLOW"};
		default {"MAIN"};
	};
};

_class		= if ((count _this) > 3) then {_this select 3} else {_unitParams select 4};
_platoon	= if ((count _this) > 4) then {_this select 4} else {parseNumber(_unitParams select 1)};
_squad		= if ((count _this) > 5) then {_this select 5} else {parseNumber(_unitParams select 2)};

_squadName	= if ((count _this) > 2) then {_this select 2} else {format["%1 %2'%3", ([_unitParams select 0] call CBA_fnc_capitalize), _platoon, _squad]};

{
	_unit disableAI _x;
} forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM"];

if ((leader (group _unit)) == _unit) then {
	(group _unit) setGroupId [_squadName, "GroupColor0"];
};

_unit assignTeam _team;
_unit setVariable ["ST_FTHud_assignedTeam", _team, true];

[_unit, _class] execVM 'editor\gear.sqf';
