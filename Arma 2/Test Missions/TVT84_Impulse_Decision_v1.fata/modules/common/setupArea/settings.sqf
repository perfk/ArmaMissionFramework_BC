
private ["_globalSetupTime", "_setupAreas"];

_globalSetupTime = (10 * 60); // Seconds

_setupAreas = [
	//	["SetupAreaMarker"		, timeSecInt		, enabledBool	],
		["setup_area_blue"		, _globalSetupTime	, true			],
		["setup_area_red"		, _globalSetupTime	, true			],
		["setup_area_orange_1"	, _globalSetupTime	, true			],
		["setup_area_orange_2"	, _globalSetupTime	, true			]
];

_exemptUnits = [];
