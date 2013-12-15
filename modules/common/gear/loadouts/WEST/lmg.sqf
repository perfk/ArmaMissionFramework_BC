private ["_unit", "_class", "_side", "_weapons", "_optics", "_items", "_mainMagazines", "_secondaryMagazines", "_ifak", "_result"];

_unit	= _this select 0;
_class	= _this select 1;
_side	= _this select 2;

//------------------------------------------------------------

/**************************************
*	Weapon Slots(addType)
*		Gear Normal(0)	x2
*		Ruck(1)			xInf
*		WOB(3)			x1
**************************************/
_weapons = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["BAF_L110A1_Aim"   	    , 0			, 1			]
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
		["ItemCompass"				, 0			, 1			],
		["ACE_Earplugs"				, 0			, 1			],
		["ACE_GlassesLHD_glasses"	, 0			, 1			],
		["ACRE_PRC343"				, 0			, 1			],
		["ACE_Map_Tools"			, 0			, 1			],
		["ACE_KeyCuffs"				, 0			, 1			],
		["ACE_GlassesGasMask_US"	, 0			, 1			]
];

/**************************************
*	Main Magazine Slots(addType)
*		Gear Normal(1)	x12
*		Ruck(1)			xInf
**************************************/
_mainMagazines = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["200Rnd_556x45_L110A1"	    , 0			, 4			],
		["HandGrenade_West"			, 0			, 2			],
		["SmokeShell"				, 0			, 2			]
];

/**************************************
*	Secondary Magazine Slots(addType)
*		Gear Small(0)	x8
*		Ruck(1)			xInf
**************************************/
_secondaryMagazines = [
	//	["ClassName"				, AddTypeInt, CountInt	],
		["ACE_Bandage"				, 0			, 2			],
		["ACE_LargeBandage"			, 0			, 1			],
		["ACE_Morphine"				, 0			, 1			],
		["ACE_Epinephrine"			, 0			, 1			]
];

/**************************************
*	IFAK
**************************************/
_ifak = [
	1,			// Slot 1
	1,			// Slot 2
	1,			// Slot 3
	false		// Set(true) or Add(false)
];

//------------------------------------------------------------

_result = [_unit, (_weapons + _optics + _items), (_mainMagazines + _secondaryMagazines), _ifak];

_result
