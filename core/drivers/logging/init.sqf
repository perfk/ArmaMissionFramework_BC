
/****************************
*  Preprocessor Macros
*****************************/

#define ISNILS(var,value) if (isNil 'var') then {var=value}

/****************************
*  Preprocessor Definitions
*****************************/

#define GVAR_PREFIX "cm_core_logging_template_"
#define DIARY_SUBJ_NAME "Framework"
#define LEVELS_ARRAY [ \
	["critical", 1], \
	["error", 2], \
	["warning", 4], \
	["notice", 8], \
	["info", 16] \
]

/****************************
*  Static Definitions
*****************************/

ISNILS(LOG_NONE,	0);	// None
ISNILS(LOG_CRIT,	1);	// Critical
ISNILS(LOG_ERROR,	2);	// Error
ISNILS(LOG_WARN,	4);	// Warning
ISNILS(LOG_NOTICE,	8);	// Notice
ISNILS(LOG_INFO,	16);// Info
ISNILS(LOG_ALL,		31);// All

/****************************
*  API Functions
*****************************/

CORE_fnc_log = {
	private ["_level", "_component", "_message", "_params", "_file", "_line", "_result"];
	_level		= _this select 0;
	_component	= _this select 1;
	_message	= _this select 2;
	_params		= if ((count _this) > 3) then {_this select 3} else {[]};
	_file		= if ((count _this) > 4) then {_this select 4} else {'No File Specified'};
	_line		= if ((count _this) > 5) then {':' + str(_this select 5)} else {''};
	_result		= false;
	if (CORE_logLevel > 0) then {
		private ["_proceed"];
		_proceed = if !(isNil 'CORE_fnc_decHasBin') then {[CORE_logLevel, _level] call CORE_fnc_decHasBin} else {true};
		if (_proceed) then {
			private ["_template"];
			_template = nil;
			{ // forEach
				if ((_x select 1) == _level) exitWith {
					_template = missionNamespace getVariable [(GVAR_PREFIX + (_x select 0)), nil];
				};
			} forEach LEVELS_ARRAY;
			if (!isNil "_template") then {
				private ["_text"];
				_text = format [_template,
					_component,
					diag_frameno,
					time,
					diag_tickTime,
					_file,
					_line,
					(format ([_message] + _params))
				];
				if (!isDedicated && CORE_logToDiary) then {
					_text spawn {
						if (!(player diarySubjectExists "framework")) then {
							player createDiarySubject ["framework", DIARY_SUBJ_NAME];
						};
						player createDiaryRecord ["framework", ["Diagnostics Log", ("<font face='Zeppelin33' size='10'>" + ([_this, newLineChar, "<br/>"] call CBA_fnc_replace) + "</font>")]];
					};
				};
				diag_log text _text;
				_result = true;
			};
		};
	};
	_result
};

/****************************
*  Finalizing Driver Load
*****************************/

{ // forEach
	missionNamespace setVariable [(GVAR_PREFIX + (_x select 0)), (loadFile ("core\drivers\logging\templates\log_" + (_x select 0) + ".sqf"))];
} forEach LEVELS_ARRAY;