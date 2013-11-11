/******************************
*	Local Machine State
*
*		Notes:
*
*			Machine States:
*				1  - Client
*				2  - Player
*				4  - Headless Client
*				8  - Non-JIP
*				16 - JIP
*				32 - Server
*				64 - Dedicated
*
*			Figuring State:
*				To figure a machine's state, add the number of the machine's
*				characteristics above. For instance, a dedicated server would
*				have a machine state of 96, a HC would be 13 or 21 (depending
*				on when it joined the game, before game start or after), and
*				a JIP player would be 19.
*				But base numbers work too with some calculation, so all clients
*				can also be stated as 1.
*
******************************/

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
