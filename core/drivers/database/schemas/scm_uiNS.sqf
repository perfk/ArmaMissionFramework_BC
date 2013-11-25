
switch (_call) do {
	case 0: { // Read
		_return = uiNamespace getVariable [(_db + _record), nil];
	};
	case 1: { // Write
		uiNamespace setVariable [(_db + _record), _data];
		_return = true;
	};
};

_return