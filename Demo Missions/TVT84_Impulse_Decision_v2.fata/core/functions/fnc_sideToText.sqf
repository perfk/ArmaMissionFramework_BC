
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
