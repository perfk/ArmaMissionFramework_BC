
private ["_veh", "_class", "_side", "_weapons", "_magazines", "_result"];

_veh	= _this select 0;
_class	= _this select 1;
_side	= _this select 2;

//------------------------------------------------------------

/**************************************
*	Vehicle Weapons
**************************************/
_weapons = [
	//	["ClassName"				, typeInt	, CountInt	],
		["AK_47_M"					, 2			, 1			],
		["ACE_Backpack_Wood"		, 2			, 1			],
		["ACRE_PRC343"				, 2			, 1			]
];

/**************************************
*	Vehicle Magazines
**************************************/
_magazines = [
	//	["ClassName"				, typeInt	, CountInt	],
		["30Rnd_762x39_AK47"		, 2			, 16		],
		["ACE_30Rnd_762x39_T_AK47"	, 2			, 4			],
		["HandGrenade_East"			, 2			, 8			],
		["SmokeShell"				, 2			, 2			],
		["ACE_Bandage"				, 2			, 4			],
		["ACE_LargeBandage"			, 2			, 2			],
		["ACE_Morphine"				, 2			, 3			],
		["ACE_Epinephrine"			, 2			, 2			],
		["ACE_Medkit"				, 2			, 1			]
];

//------------------------------------------------------------

_result = [_veh, _weapons, _magazines];

_result