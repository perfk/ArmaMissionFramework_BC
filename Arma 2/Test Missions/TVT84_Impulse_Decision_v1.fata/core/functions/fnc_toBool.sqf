
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
