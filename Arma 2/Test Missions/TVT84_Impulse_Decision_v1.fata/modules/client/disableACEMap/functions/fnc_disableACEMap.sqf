
waitUntil {!isNil "ace_sys_map_fnc_determineMapLight"};

dam_ace_sys_map_fnc_determineMapLight = ace_sys_map_fnc_determineMapLight;

ace_sys_map_fnc_determineMapLight = {
	private ["_data", "_darkMap", "_color", "_fill", "_externalLight"];
	_data = call dam_ace_sys_map_fnc_determineMapLight;
	_darkMap = _data select 0;
	_color = _data select 1;
	_fill = _data select 2;
	_externalLight = _data select 3;
	
	if (dam_disableDarkMap) then {
		_darkMap = false;
	};
	if (dam_disableMapLight) then {
		_externalLight = false;
	};
	
	_data = [_darkMap, _color, _fill, _externalLight];
	_data
};