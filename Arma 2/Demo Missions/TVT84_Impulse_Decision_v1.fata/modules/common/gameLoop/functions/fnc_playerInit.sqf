
private ["_playerKilledEH"];

player setVariable ["gameLoop_playerSide", (side player)];

_playerKilledEH = player addEventHandler ["killed", {['gameLoop_onPlayerKilled'] call CORE_fnc_callFunction;}];
['gameLoop_playerKilledEH', _playerKilledEH] call CORE_fnc_setVariable;
