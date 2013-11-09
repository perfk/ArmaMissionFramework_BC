
/****************************************
*	Mission Objective Check
*
*		This is the area to put all
*		mission-specific game loop checks
*		for the end conditions.
*
*		ie. This is where you can check
*			if a briefcase was recovered.
*
*		Note: This function MUST return
*			  an array value. Index 0 must
*			  be boolean. True for
*			  mission end, false to
*			  continue the mission. Index
*			  1 is an array of the end
*			  condition's title and desc.
*			    ie. To end a mission:
*			    [true, ["Blufor Won!", 
*			    "Blufor killed the HVT"]]
****************************************/

private ["_endMission", "_header", "_description"];
_endMission		= false;
_header			= "";
_description	= "";

{
	if ((_x select 1) && (time > (_x select 2))) exitWith {
		_endMission		= true;
		_header			= format["%1 has extracted.", ([(_x select 0)] call CORE_fnc_sideToText)];
		_description	= _description + "The warlords' primary objective has been completed. ";
		
		private ["_prisonerCount", "_truckCount"];
		_prisonerCount = 0;
		_truckCount = 0;
		
		{
			if (!(isNull _x) && [_x, format["%1_extractionPointArea", WEST]] call CBA_fnc_inArea) then {
				_prisonerCount = _prisonerCount + 1;
			};
		} forEach msc_prisoners;
		if (_prisonerCount > 1) then {
			_description = _description + format["Blufor was able to successfully extract all (%1) of the prisoners: Primary Objective Completed. ", _prisonerCount];
		};
		
		{
			if (!(isNull _x) && (alive _x) && [_x, format["%1_extractionPointArea", EAST]] call CBA_fnc_inArea) then {
				_truckCount = _truckCount + 1;
			};
		} forEach [blu_supply_1, blu_supply_2, blu_supply_3];
		if (_truckCount > 2) then {
			_description = _description + format["Opfor was able to successfully extract %1 of the supply trucks: Primary Objective Completed. ", _truckCount];
		};
		
		{
			if (!(isNull _x) && (!(alive _x) || (_x getVariable ['gdtmod_isSpectating', false]))) then {
				_description = _description + format["Warlord %1 has been killed. ", (name _x)];
			};
		} forEach msc_warlords;
		{
			if (!(isNull _x) && (!(alive _x) || (_x getVariable ['gdtmod_isSpectating', false]))) then {
				_description = _description + format["Mission CO %1 (%2) has been killed: Opponent's Secondary Objective Completed. ", (name _x), (([_x] call CORE_fnc_sideToText) + (if (_x in msc_warlords) then {" - Warlord"} else {""}))];
			};
		} forEach msc_missionCO;
		
		private ["_sides", "_count"];
		_sides = [west, east, resistance, civilian];
		_count = [0,0,0,0];
		
		{
			private ["_unit"];
			_unit = _x;
			if (isPlayer _unit) then {
				{
					if (((_x select 0) == (side _unit)) && ([_unit, (_x select 1)] call CBA_fnc_inArea)) exitWith {
						private ["_index"];
						_index = _sides find (side _unit);
						if (_index >= 0) then {
							_count set [_index, ((_count select _index) + 1)];
						};
					};
				} forEach msc_extractMarkers;
			};
		} forEach allUnits;
		
		for "_i" from 0 to ((count _count) - 1) do {
			private ["_num"];
			_num = _count select _i;
			if (_num > 0) then {
				_description = _description + format["%1 was able to extract %2 soldiers. ", ([(_sides select _i)] call CORE_fnc_sideToText), _num];
			};
		};
	};
} forEach msc_extraction;

[
	_endMission,		// End Mission? (Bool)
	[
		_header,		// End Mission Header
		_description	// End Mission Description
	]
]
