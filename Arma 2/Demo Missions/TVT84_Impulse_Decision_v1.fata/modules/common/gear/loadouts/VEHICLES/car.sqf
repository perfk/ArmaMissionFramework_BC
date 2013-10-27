
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
];

/**************************************
*	Vehicle Magazines
**************************************/
_magazines = [
	//	["ClassName"				, typeInt	, CountInt	],
];

//------------------------------------------------------------

_result = [_veh, _weapons, _magazines];

_result