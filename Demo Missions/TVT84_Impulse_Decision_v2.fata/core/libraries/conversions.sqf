
CORE_fnc_decToBin = {
	/* Converts a decimal number to a binary array */
	private ["_decimal", "_return", "_base"];
	_decimal	= _this select 0;
	_return		= [];
	_base 		= 2;
	if ((_decimal % 1) == 0) then { // Needs to be a whole number 
		private ["_i"];
		_i = 0;
		while {_decimal > 0} do {
			_return set [_i, (_decimal mod _base)];
			_decimal = floor(_decimal / _base);		// (_decimal - _rem) / _base
			_i = _i + 1;
		};
	};
	_return
};

CORE_fnc_sideToText = {
	private ["_side", "_return"];
	_side = _this select 0;
	_return = switch (_side) do {
		case WEST: {'Blufor'};
		case EAST: {'Opfor'};
		case RESISTANCE: {'Independent'};
		case CIVILIAN: {'Civilian'};
		case SIDEENEMY: {'Renegade'};
		case SIDEFRIENDLY: {'Friendlies'};
		case default {'NULL'};
	};
	_return
};

CORE_fnc_toBool = {
	/* WARNING: Do not use this for raw input or persistant data */
	private ["_eval", "_params"];
	_eval		= _this select 0;
	_params		= if ((count _this) > 1) then {_this select 1} else {[]};
	if (typeName(_eval) == typeName("")) then {
		_eval = if (_eval == "") then {false} else {compile _eval};
	};
	if (typeName(_eval) == typeName({})) then {
		_eval = _params call _eval;
	};
	if (typeName(_eval) == typeName(1)) then {
		switch (_eval) do {
			case 0: {_eval = false;};
			case 1: {_eval = true;};
		};
	};
	if (typeName(_eval) != typeName(true)) then {
		_eval = false;
	};
	_eval
};