
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
