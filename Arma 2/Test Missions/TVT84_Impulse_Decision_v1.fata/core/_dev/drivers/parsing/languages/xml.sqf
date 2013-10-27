
CORE_fnc_parseXML = {
	
	if (typeName(_this) != typeName([])) then {_this = [_this]};
	
	private ["_xml", "_xmlType", "_return"];
	_xml		= _this select 0;
	_return		= false;
	_xmlType	= if ((count _this) > 1) then {_this select 1} else {
		if ([_xml] call CORE_fnc_isFilePath) then {1} else {0};
	};
	
	if (typeName(_xml) == typeName("String")) then {
		
		if (_xmlType == 1) then { // Process XML File
			_xml = loadFile _xml;
		};
		
		if (_xml != "") then { // Parse XML
			_return = [_xml, parsing_xmlParseConfig] call CORE_fnc_parseText;
		};
	};
	
	_return
};

CORE_fnc_getXMLValue = CORE_fnc_getParsedValue; // Pseudonym Function

parsing_xmlParseConfig = // XML Parsing Configuration, no need to edit
[ // L0
	[
		"<!--",
		[ // L1
			[
				"-->",
				0,
				-1
			],
			[
				"~",
				-1,
				-1
			]
		],
		-1
	],
	[
		"<",
		[ // L1
			[
				"/",
				[ // L2
					[
						">",
						0,
						0
					],
					[
						"*",
						[ // L3
							[
								">",
								0,
								3
							],
							["*"]
						]
					]
				],
				0
			],
			[
				"*",
				[ // L2
					[
						" ",
						1,
						1
					],
					[
						"=",
						[ // L3
							[
								'"',
								[ // L4
									[
										'"',
										1,
										2
									],
									["~"]
								],
								0
							]
						],
						1
					],
					[
						">",
						0,
						1
					],
					["*"]
				]
			],
			[" "]
		],
		2
	],
	["~"]
];