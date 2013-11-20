
#include "init_hashmap.sqf"

switch (_call) do {
	case 0: { // Read
		private ["_result"];
		_result = [_db, _record] call jayarma2lib_fnc_hashmapGetValue;
		if (isNil "_result") then {
			_return = _data;
		} else {
			_return = call compile _result;
		};
	};
	case 1: { // Write
		_return = [_db, _record, str(_data)] call jayarma2lib_fnc_hashmapAddValue;
	};
};

_return