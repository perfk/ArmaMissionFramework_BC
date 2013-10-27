
#define ISNILS(var,value) if (isNil 'var') then {var=value}

private ["_level", "_component", "_text", "_params", "_file", "_line", "_result"];

_level		= _this select 0;
_component	= _this select 1;
_text		= _this select 2;
_params		= if ((count _this) > 3) then {_this select 3} else {[]};
_file		= if ((count _this) > 4) then {_this select 4} else {''};
_line		= if ((count _this) > 5) then {':' + str(_this select 5)} else {''};
_result		= false;

ISNILS(LOG_NONE,	0);	// None
ISNILS(LOG_CRIT,	1);	// Critical
ISNILS(LOG_ERROR,	2);	// Error
ISNILS(LOG_WARN,	4);	// Warning
ISNILS(LOG_NOTICE,	8);	// Notice
ISNILS(LOG_INFO,	16);// Info
ISNILS(LOG_ALL,		31);// All

if (CORE_logLevel > 0) then {
	private ["_proceed"];
	_proceed = if !(isNil 'CORE_fnc_decHasBin') then {[CORE_logLevel, _level] call CORE_fnc_decHasBin} else {true};
	
	if (_proceed) then {
		private ["_string", "_endString", "_rtime"];
		_string = "";
		_endString = "";
		//_rtime = [(if (isClass(configFile >> "CfgPatches" >> "jayarma2lib_common")) then {([] call jayarma2lib_fnc_getLocalTime) * 3600} else {diag_tickTime}), 'H:MM:SS'] call CBA_fnc_formatElapsedTime;
		_rtime = [diag_tickTime, 'H:MM:SS'] call CBA_fnc_formatElapsedTime;
		
		switch (_level) do {
			
			/****************************************/
			case LOG_CRIT: {	// Game-Breaking Errors
				_string = _string + '\n' + "=====================================================================" + '\n';
				_string = _string + format["== %1: CRITICAL - %2", _component, _rtime] + '\n';
				_string = _string + format["== Frame: %1 | GameTime: %2 | TickTime: %3", diag_frameNo, time, diag_tickTime] + '\n';
				if (_file != '') then {
					_string = _string + format["== File: '%1%2'", _file, _line] + '\n';
				};
				_string = _string + "== Message: ";
				_endString = _endString + '\n' + "=====================================================================" + '\n';
			};
			/****************************************/
			
			/****************************************/
			case LOG_ERROR: {	// Recoverable Errors
				_string = _string + '\n' + format["-- %1: ERROR [Frame: %2 | Time: %3 | GameTime: %4 | TickTime: %5]", _component, diag_frameNo, _rtime, time, diag_tickTime] + '\n';
				if (_file != '') then {
					_string = _string + format["-- File: '%1%2'", _file, _line] + '\n';
				};
				_string = _string + "-- Message: ";
				_endString = _endString + '\n';
			};
			/****************************************/
			
			/****************************************/
			case LOG_WARN: {	// Possible Error or Delay
				_string = _string + format["%1: Warning [Time: %2 | GameTime: %3 | TickTime: %4", _component, _rtime, time, diag_tickTime];
				if (_file != '') then {
					_string = _string + format[" | File: '%1%2'", _file, _line];
				};
				_string = _string + "]\n	Message: ";
				_endString = _endString + "\n	End Warning.";
			};
			/****************************************/
			
			/****************************************/
			case LOG_NOTICE: {	// Warning with no possible errors
				_string = _string + format["%1: Notice [Time: %2 | GameTime: %3 | TickTime: %4", _component, _rtime, time, diag_tickTime];
				if (_file != '') then {
					_string = _string + format[" | File: '%1%2'", _file, _line];
				};
				_string = _string + "]\n	Message: ";
				_endString = _endString + "\n	End Notice.";
			};
			/****************************************/
			
			/****************************************/
			default {			// Informational
				_string = _string + format["%1: Info [Time: %2 | GameTime: %3 | TickTime: %4", _component, _rtime, time, diag_tickTime];
				if (_file != '') then {
					_string = _string + format[" | File: '%1%2'", _file, _line];
				};
				_string = _string + " | Message: '";
				_endString = _endString + "']";
			};
			/****************************************/
			
		};
		
		_string = _string + format([_text] + _params) + _endString;
		
		{diag_log text _x} forEach ([_string, "\n"] call CBA_fnc_split);
		
		_result = true;
	};
};

_result
