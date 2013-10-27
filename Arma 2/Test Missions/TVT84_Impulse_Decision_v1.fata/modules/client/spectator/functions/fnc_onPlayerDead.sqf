
private ["_deathMessage"];

_deathMessage = 'gdtmod_deathMessage' call CORE_fnc_getVariable;

titleText [_deathMessage, "BLACK", 0.2];
sleep 1;
titleText [_deathMessage, "BLACK FADED", 10];

waitUntil {alive player};

player setPos ([('gdtmod_specPen' call CORE_fnc_getVariable)] call CBA_fnc_getPos);
[player] join grpNull;

private ["_hdEH"];
_hdEH = player addEventHandler ["HandleDamage", {false}];
['gdtmod_hdEH', _hdEH] call CORE_fnc_setVariable;

player setCaptive true;

removeAllWeapons player;
removeAllItems player;
removebackpack player;

[true] call acre_api_fnc_setSpectator;