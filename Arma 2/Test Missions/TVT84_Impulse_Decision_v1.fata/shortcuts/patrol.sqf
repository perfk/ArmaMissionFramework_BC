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

#define DEFAULT_PPOS	"tottah_patrol_center"
#define DEFAULT_RADIUS	255

waitUntil {!isNil "CBA_fnc_getPos" && !isNil "CBA_fnc_taskPatrol"};

private ["_group", "_patrolPos", "_radius"];

if (typeName(_this) != typeName([])) then {_this = [_this]};

_group		= group(_this select 0);
_patrolPos	= if ((count _this) > 1) then {_this select 1} else {DEFAULT_PPOS};
_radius		= if ((count _this) > 2) then {_this select 2} else {DEFAULT_RADIUS};

_patrolPos	= _patrolPos call CBA_fnc_getPos;

[_group, _patrolPos, _radius, 8, "MOVE", "SAFE", "YELLOW", "LIMITED", "COLUMN", "", [0,0,0]] call CBA_fnc_taskPatrol;
