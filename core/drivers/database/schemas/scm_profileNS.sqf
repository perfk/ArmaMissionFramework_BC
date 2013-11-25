#include "schema_header.sqf"

switch (_call) do {
	case 0: { // Read
		_return = profileNamespace getVariable [(_db + _record), _data];
	};
	case 1: { // Write
		profileNamespace setVariable [(_db + _record), _data];
		_return = true;
	};
};

_return