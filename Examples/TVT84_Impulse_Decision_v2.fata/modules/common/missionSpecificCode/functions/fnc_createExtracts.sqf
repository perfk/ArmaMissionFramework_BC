
if (isNil "msc_extractMarkers") then {
	msc_extractMarkers = [];
};

private ["_fnc_getPos"];

_fnc_getPos = {
	private ["_index", "_pos", "_size", "_newSize", "_return"];
	_index		= _this select 0;
	_pos		= (_this select 1) select _index;
	_size		= (_this select 2) select _index;
	_newSize	= (_this select 3) select _index;
	_size		= _size - _newSize;
	_return		= (_pos - (_size / 2)) + random(_size);
	_return
};

{
	private ["_side", "_areaMarker", "_newSize", "_size", "_pos", "_posX", "_posY", "_color", "_marker", "_textMark"];
	
	_side		= _x select 0;
	_areaMarker	= _x select 1;
	_newSize	= _x select 2;
	
	_areaMarker setMarkerAlpha 0;
	
	_size = getMarkerSize _areaMarker;
	_pos  = getMarkerPos  _areaMarker;
	
	_posX = [0, _pos, _size, _newSize] call _fnc_getPos;
	_posY = [1, _pos, _size, _newSize] call _fnc_getPos;
	
	_color = switch (_side) do {
		case WEST: {"ColorBlue"};
		case EAST: {"ColorRed"};
		case INDEPENDENT: {"ColorGreen"};
		case CIVILIAN: {"ColorYellow"};
		default {"Default"};
	};
	
	_marker = createMarker [(format["%1_extractionPointArea", _side]), [_posX, _posY]];
	_marker setMarkerAlpha 0; 
	_marker setMarkerShape "RECTANGLE";
	_marker setMarkerSize _newSize;
	_marker setMarkerBrush "Border";
	_marker setMarkerColor _color;
	
	_textMark = createMarker [(format["%1_extractionPointText", _side]), [_posX, _posY]];
	_textMark setMarkerAlpha 0; 
	_textMark setMarkerShape "ICON";
	_textMark setMarkerType "mil_end";
	_textMark setMarkerText format["%1 Extraction", _side];
	_textMark setMarkerColor _color;
	
	msc_extractMarkers = msc_extractMarkers + [[_side, _marker, _textMark]];
	
} forEach [
	//	[side	, extractAreaMarker		, [newMarkerDem]],
		[WEST	, "west_extractArea"	, [200, 200]],
		[EAST	, "east_extractArea"	, [200, 200]]
];

publicVariable "msc_extractMarkers";