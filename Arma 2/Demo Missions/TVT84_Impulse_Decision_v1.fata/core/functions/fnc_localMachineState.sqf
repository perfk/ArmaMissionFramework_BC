
private ["_machineState"];

_machineState = 0;

if (isServer) then {
	_machineState = _machineState + 32; // Server
};

if (isDedicated) then {
	_machineState = _machineState + 64; // Dedicated Server
} else {
	
	_machineState = _machineState + 1; // Client
	
	if (hasInterface) then {
		_machineState = _machineState + 2; // Player
	} else {
		_machineState = _machineState + 4; // HC
	};
	
	if (isNull player) then {
		_machineState = _machineState + 16; // JIP
	} else {
		_machineState = _machineState + 8; // Non-JIP
	};
};

_machineState
