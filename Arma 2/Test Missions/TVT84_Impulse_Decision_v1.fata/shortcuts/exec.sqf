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

// This file is for executing addAction code without creating new files, uses passed params to execute

private ["_target", "_caller", "_actionID", "_code", "_handle"];
_target		= _this select 0;
_caller		= _this select 1;
_actionID	= _this select 2;
_code		= _this select 3;
_handle		= nil;

if (typeName(_code) == typeName("")) then {
	_code = compile _code;
};

if (typeName(_code) == typeName({})) then {
	_handle = [_target, _caller, _actionID] spawn _code;
};

_handle