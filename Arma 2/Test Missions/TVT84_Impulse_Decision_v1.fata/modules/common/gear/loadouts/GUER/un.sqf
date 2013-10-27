
private ["_unit", "_class", "_side", "_weapons", "_optics", "_items", "_mainMagazines", "_secondaryMagazines", "_ifak", "_result"];

_unit	= _this select 0;
_class	= _this select 1;
_side	= _this select 2;

//------------------------------------------------------------

/* Start Random Gear Script */

_gearTemp = [
	//	["Weapon"				, "Magazine"				, probInt	],
		["RPK_74"				, "30Rnd_545x39_AK"			, 6.25		],
		["ACE_RPK"				, "30Rnd_762x39_AK47"		, 12.5		],
		["ACE_AKMS"				, "30Rnd_762x39_AK47"		, 25		],
		["AKS_74"				, "30Rnd_545x39_AK"			, 25		],
		["ACE_AKM"				, "30Rnd_762x39_AK47"		, 50		],
		["AK_74"				, "30Rnd_545x39_AK"			, 50		]
];

private ["_wep", "_mag", "_totalProb", "_prob", "_curProb"];
_wep		= "";
_mag		= "";
_totalProb	= 0;
_curProb	= 0;

{_totalProb = _totalProb + (_x select 2)} forEach _gearTemp;

_prob = random(_totalProb);

{
	_curProb = _curProb + (_x select 2);
	if (_prob <= _curProb) exitWith {
		_wep = _x select 0;
		_mag = _x select 1;
	};
} forEach _gearTemp;

/* End Random Gear Script */

/**************************************
*	Weapon Slots(addType)
*		Gear Normal(0)	x2
*		Ruck(1)			xInf
*		WOB(2)			x1
**************************************/
_weapons = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		[_wep						, 0			, 1			]
];

/**************************************
*	Optic Slots(addType)
*		Gear Optics(0)	x2
*		Ruck(1)			xInf
**************************************/
_optics = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["NVGoggles"				, 0			, 1			]
];

/**************************************
*	Item Slots(addType)
*		Gear Items(0)	x12
*		Ruck(1)			xInf
**************************************/
_items = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["ItemMap"					, 0			, 1			],
		["ItemWatch"				, 0			, 1			],
		["ItemCompass"				, 0			, 1			]
];

/**************************************
*	Main Magazine Slots(addType)
*		Gear Normal(1)	x12
*		Ruck(1)			xInf
**************************************/
_mainMagazines = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		[_mag						, 0			, 6			],
		["HandGrenade_East"			, 0			, 2			],
		["SmokeShell"				, 0			, 1			]
];

/**************************************
*	Secondary Magazine Slots(addType)
*		Gear Small(0)	x8
*		Ruck(1)			xInf
**************************************/
_secondaryMagazines = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["ACE_Bandage"				, 0			, 1			]
];

/**************************************
*	IFAK
**************************************/
_ifak = [
	0,			// Morphine
	0,			// Bandages
	0,			// Epinephrine
	true		// Set(true) or Add(false)
];

//------------------------------------------------------------

_result = [_unit, (_weapons + _optics + _items), (_mainMagazines + _secondaryMagazines), _ifak];

_result