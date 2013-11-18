
private ["_visible", "_action"];

waitUntil {!isNil "msc_missionCO" && !isNil "msc_extractMarkers"};

if (player in msc_missionCO) then {
	if (playerSide in [EAST, WEST]) then {
		player setVariable ["msc_coSide", playerSide, true];
	};
	
	private ["_shownSides"];
	_shownSides = switch (playerSide) do {
		case WEST: {[EAST]};
		case EAST: {[WEST]};
		case RESISTANCE: {[WEST, EAST]};
		default {[]};
	};
	
	{
		if ((_x select 0) in _shownSides) then {
			(_x select 1) setMarkerAlpha 1;
			(_x select 2) setMarkerAlpha 1;
		};
	} forEach msc_extractMarkers;
};

_visible = "
	private ['_target', '_targetSide', '_return'];
	_target = _this select 0;
	_targetSide = _target getVariable ['msc_coSide', nil];
	_return = false;
	if (!(isNil '_targetSide') && !msc_takenExtractIntel) then {
		_return = if (((_targetSide getFriend playerSide) < 0.6) && (_target != player)) then {true} else {false};
	};
	_return
";

_action = "
	{
		if ((_x select 0) == playerSide) then {
			(_x select 1) setMarkerAlpha 1;
			(_x select 2) setMarkerAlpha 1;
		};
	} forEach msc_extractMarkers;
	msc_takenExtractIntel = true;
";

['fmh_addFlexiButton', [
	'interaction',
	"<t color='#ffc600'>Take Enemy Intel</t>",
	_action,
	"main",
	true,
	_visible,
	"",
	"This will reveal the Extraction Route for your team."
]] call CORE_fnc_callFunction;