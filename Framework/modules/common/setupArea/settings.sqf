
private ["_globalSetupTime", "_setupAreas", "_exemptUnits"];

_globalSetupTime = (10 * 60); // Seconds

_setupAreas = [
	//	["SetupAreaMarker"		, timeSecInt		, enabledBool	],
		["setup_area_blufor"	, _globalSetupTime	, true			],
		["setup_area_opfor"		, _globalSetupTime	, true			]
];

_exemptUnits = [];
