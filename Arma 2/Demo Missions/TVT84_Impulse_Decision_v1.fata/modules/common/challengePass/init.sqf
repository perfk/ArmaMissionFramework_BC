
#include "settings.sqf"

private ["_functions"];

// Load Functions
_functions = [];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

if (isServer) then {
	private ["_challengePassword", "_usedWordIndexes", "_usedNumberComb"];
	_challengePassword = [];
	_usedWordIndexes = [];
	_usedNumberComb = [];
	{
		private ["_randomChallenge", "_randomPassword", "_numberComb", "_runningPassword"];
		_randomChallenge = -1;
		_randomPassword = -1;
		_numberComb = -1;
		_runningPassword = -1;
		
		while {
			(_randomChallenge <= 0) || (_randomPassword <= 0) || (_numberComb <= 0) || (_runningPassword <= 0) ||
			(_randomChallenge == _randomPassword) || (_runningPassword == _randomPassword) || (_runningPassword == _randomChallenge) ||
			(_randomChallenge in _usedWordIndexes) || (_randomPassword in _usedWordIndexes) || (_runningPassword in _usedWordIndexes) || (_numberComb in _usedNumberComb)
		} do {
			_randomChallenge = round(random((count _dictionary) - 1));
			_randomPassword = round(random((count _dictionary) - 1));
			_runningPassword = round(random((count _dictionary) - 1));
			_numberComb = round(random(100));
		};
		
		_usedWordIndexes = _usedWordIndexes + [_randomChallenge, _randomPassword, _runningPassword];
		_usedNumberComb = _usedNumberComb + [_numberComb];
		_challengePassword = _challengePassword + [[_x, (_dictionary select _randomChallenge), (_dictionary select _randomPassword), (_dictionary select _runningPassword), _numberComb]];
	} forEach _groups;
	cp_allChallenges = _challengePassword;
	publicVariable "cp_allChallenges";
};

if (!isDedicated) then {
	[] spawn {
		private ["_group"];
		if ((side player) == RESISTANCE) then {
			_group = player getVariable ["build_area", str(side player)];
		} else {
			_group = str(side player);
		};
		
		waitUntil {!isNil "cp_allChallenges"};
		
		{
			if ((_x select 0) == _group) exitWith {
				cp_challengePassComb = [(_x select 1), (_x select 2), (_x select 3), (_x select 4)];
			};
		} forEach cp_allChallenges;
	};
};

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions
