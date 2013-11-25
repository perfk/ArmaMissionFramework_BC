#include "init_hashmap.sqf"

switch (_call) do {
	case 0: { // Read
		_return = [_db, _record] call jayarma2lib_fnc_hashmapGetValue;
		if (!isNil "_return") then {
			_return = call compile _return;
		};
	};
	case 1: { // Write
		_return = [_db, _record, str(_data)] call jayarma2lib_fnc_hashmapAddValue;
	};
};

_return