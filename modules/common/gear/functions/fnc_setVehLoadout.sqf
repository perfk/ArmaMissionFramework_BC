
private ["_veh", "_weapons", "_magazines"];

_veh			= _this select 0;
_weapons		= _this select 1;
_magazines		= _this select 2;

clearMagazineCargo _veh;
clearWeaponCargo _veh;

{
	[_veh, (_x select 0), (_x select 1), (_x select 2)] call gear_addGear;
} forEach (_magazines + _weapons);