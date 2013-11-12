
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
		["ACE_M4_F"					, 2			, 6			],
		["SCAR_L_CQC_Holo"			, 2			, 2			],
		["Mk13_EP1"					, 2			, 1			],
		["M9"						, 2			, 4			],
		["M136"						, 2			, 4			],
		["ACE_Backpack_US"			, 2			, 8			],
		["ACRE_PRC343"				, 2			, 2			]
];

/**************************************
*	Vehicle Magazines
**************************************/
_magazines = [
	//	["ClassName"				, typeInt	, CountInt	],
		["30Rnd_556x45_Stanag"		, 2			, 64		],
		["ACE_30Rnd_556x45_T_Stanag", 2			, 48		],
		["ACE_200Rnd_556x45_T_M249"	, 2			, 8			],
		["200Rnd_556x45_M249"		, 2			, 4			],
		["ACE_5Rnd_127x99_B_TAC50"	, 2			, 8			],
		["ACE_5Rnd_127x99_T_TAC50"	, 2			, 4			],
		["HandGrenade_West"			, 2			, 64		],
		["SmokeShell"				, 2			, 48		],
		["SmokeShellGreen"			, 2			, 24		],
		["SmokeShellRed"			, 2			, 24		],
		["SmokeShellPurple"			, 2			, 24		],
		["SmokeShellBlue"			, 2			, 24		],
		["ACE_C4_M"					, 2			, 8			],
		["ACE_CLAYMORE_M"			, 2			, 2			],
		["ACE_TRIPFLARE_M"			, 2			, 4			],
		["PipeBomb"					, 2			, 1			],
		["15Rnd_9x19_M9"			, 2			, 24		],
		["ACE_1Rnd_HE_M203"			, 2			, 96		],
		["1Rnd_Smoke_M203"			, 2			, 48		],
		["1Rnd_SmokeGreen_M203"		, 2			, 48		],
		["1Rnd_SmokeRed_M203"		, 2			, 48		],
		["1Rnd_SmokeYellow_M203"	, 2			, 48		]
];

//------------------------------------------------------------

_result = [_veh, _weapons, _magazines];

_result