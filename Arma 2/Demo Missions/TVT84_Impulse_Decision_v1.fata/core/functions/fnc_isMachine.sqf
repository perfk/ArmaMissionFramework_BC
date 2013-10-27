
private ["_localMachine", "_testMachines", "_return"];
_localMachine	= _this select 0;
_testMachines	= _this select 1;
_return			= false;

if (typeName(_testMachines) == typeName(2)) then {
	_testMachines = [_testMachines];
};

if (typeName(_testMachines) == typeName([])) then {
	{
		if ([_localMachine, _x] call CORE_fnc_decHasBin) exitWith {
			_return = true;
		};
	} forEach _testMachines;
};

_return
