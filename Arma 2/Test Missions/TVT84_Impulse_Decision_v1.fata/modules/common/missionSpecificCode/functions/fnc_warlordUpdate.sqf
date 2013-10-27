
if (player in msc_warlords) then {
	
	[] spawn {
		private ["_i", "_markerUpdates"];
		_i = 0;
		
		if (isNil "wlu_fnc_getAvgPos") then {
			wlu_fnc_getAvgPos = {
				private ["_side", "_xPos", "_yPos", "_i"];
				_side	= _this select 0;
				_xPos	= 0;
				_yPos	= 0;
				_i		= 0;
				{
					if ((alive _x) && ((side _x) == _side) && !(_x getVariable ['gdtmod_isSpectating', false])) then {
						private ["_pos"];
						_pos = getPos (vehicle _x);
						_xPos = _xPos + (_pos select 0);
						_yPos = _yPos + (_pos select 1);
						_i = _i + 1;
					};
				} forEach allUnits;
				if (_i != 0) then {
					_xPos = _xPos / _i;
					_yPos = _yPos / _i;
				};
				[_xPos, _yPos, 0]
			};
		};
		
		_markerUpdates = [
			//	["MarkerName"		, {TrackingPosCode}						, "MarkerType"		, "MarkerColor"	, "MarkerText"		, loopInt	],
				["blufor_co_pos"	, {getPos (msc_missionCO select 0)}		, "dot"				, "ColorBlue"	, "Blufor CO"		, 60		],
				["opfor_co_pos"		, {getPos (msc_missionCO select 1)}		, "dot"				, "ColorRed"	, "Opfor CO"		, 60		],
				["prisoner_1_pos"	, {getPos (msc_prisoners select 0)}		, "dot"				, "ColorGreen"	, "Prisoner 1"		, 120		],
				["prisoner_2_pos"	, {getPos (msc_prisoners select 1)}		, "dot"				, "ColorGreen"	, "Prisoner 2"		, 120		],
				["truck_1_pos"		, {getPos blu_supply_1}					, "SupplyVehicle"	, "ColorBlue"	, "Supply Truck 1"	, 90		],
				["truck_2_pos"		, {getPos blu_supply_2}					, "SupplyVehicle"	, "ColorBlue"	, "Supply Truck 2"	, 90		],
				["truck_3_pos"		, {getPos blu_supply_3}					, "SupplyVehicle"	, "ColorBlue"	, "Supply Truck 3"	, 90		],
				["blu_average_pos"	, {[WEST] call wlu_fnc_getAvgPos}		, "b_inf"			, "ColorBlue"	, "Blufor"			, 15		],
				["op_average_pos"	, {[EAST] call wlu_fnc_getAvgPos}		, "o_inf"			, "ColorRed"	, "Opfor"			, 15		]
		];
		
		sleep 0.5;
		waitUntil {
			{ /* FOREACH */
				private ["_marker", "_posCode", "_type", "_color", "_text", "_loopInt", "_pos"];
				_loopInt		= _x select 5;
				if ((_i % _loopInt) == 0) then {
					_marker		= _x select 0;
					_posCode	= _x select 1;
					_pos		= _marker call _posCode;
					if (((count _pos) == 3) && !(((_pos select 0) == 0) && ((_pos select 1) == 0) && ((_pos select 2) == 0))) then {
						if (_i == 0) then { // Init Run
							_type	= _x select 2;
							_color	= _x select 3;
							_text	= _x select 4;
							createMarkerLocal [_marker, _pos];
							_marker setMarkerShapeLocal "ICON";
							_marker setMarkerAlphaLocal 1;
							_marker setMarkerColorLocal _color;
							_marker setMarkerTypeLocal _type;
							_marker setMarkerTextLocal _text;
						};
						_marker setMarkerPosLocal _pos;
					};
				};
			} forEach _markerUpdates;
			_i = _i + 1;
			sleep 1;
			false;
		};
	};
};