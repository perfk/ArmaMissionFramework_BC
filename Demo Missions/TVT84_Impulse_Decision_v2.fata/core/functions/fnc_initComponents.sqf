
private ["_initFunctions"];

_initFunctions	= +cm_core_initFunctions;

// Sort by Priority
_initFunctions	= [_initFunctions, 5] call CBA_fnc_sortNestedArray;

/* Loading All Init Functions */
for "_i" from 0 to ((count _initFunctions) - 1) do {
	private ["_function", "_run"];
	_function = _initFunctions select _i;
	_run = if ((count _function) > 4) then {
		if (typeName(_function select 4) == typeName(true)) then {
			(_function select 4);
		} else {
			[CORE_machine, (_function select 4)] call CORE_fnc_isMachine;
		};
	} else {true};
	
	if (_run) then {
		[(_function select 0), (_function select 2)] call CORE_fnc_spawnFunction;
	};
};
