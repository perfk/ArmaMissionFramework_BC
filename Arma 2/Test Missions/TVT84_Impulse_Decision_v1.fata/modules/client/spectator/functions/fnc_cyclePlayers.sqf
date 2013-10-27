
private ["_step", "_players", "_playerCount", "_selectedPlayer", "_return"];

_step			= _this select 0;
_players		= call CBA_fnc_players;
_playerCount	= count _players;
_selection		= gdtmod_seagull_players_select;
_selectedPlayer	= objNull;
_return			= 'gdtmod_specPen' call CORE_fnc_getVariable;

if (_playerCount > 0) then {
	
	private ["_loopCount"];
	_loopCount = 0;
	
	waitUntil {
		_selection = _selection + _step;
		_loopCount = _loopCount + _step;
		if (_selection < 0) then {_selection = (_playerCount - 1)};
		if (_selection > (_playerCount - 1)) then {_selection = 0};
		_selectedPlayer	= _players select _selection;
		(['gdtmod_isValidTarget', [_selectedPlayer]] call CORE_fnc_callFunction) || (_loopCount > _playerCount);
	};
	
	if (_loopCount <= _playerCount) then {
		_return = vehicle _selectedPlayer;
		gdtmod_seagull_players_select = _selection;
		gdtmod_seagull_target = _selectedPlayer;
	};
};

_return