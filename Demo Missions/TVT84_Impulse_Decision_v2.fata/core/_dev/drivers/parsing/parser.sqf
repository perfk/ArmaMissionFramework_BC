
_construct = {
	#include "languages\xml.sqf"
};

//////////////////////////////////////////////////////////////
//
//	Function: CORE_fnc_parseText
//	---------------------------------
//
//	Description:
//
//		Parses arbitrary text with a parsing config (parseConfig) to SQF Array (parsedObject) output.
//
//	Parameters:
//
//		_text - The text to parse [String].
//		_parseConfig - The parsing configuration [Array].
//
//	Returns:
//
//		Parsed Object [Array].
//		False on failure [Boolean].
//
//	Examples:
//
//		> _parsedObject = [(loadFile "data.xml"), _xmlParseConfig] call CORE_fnc_getParsedValue;
//
//	About:
//
//		parsedObject - > [["Variable", Value], ... ];
//
//		parseConfig - > [["Char(s)"(, newLevelArray, bufferOptionInt)], ... ];
//
//		newLevelArray - parseConfig index 1
//			- "*"	= Wildcard (no-white-space)
//			- "~"	= Wildcard (white-space-inclusive)
//			- int	= GoTo Level (int > 0)
//			- []	= -1 = Do Not Shift Level
//
//		bufferOptionInt - parseConfig index 2
//			- -1	= Do Not Include in Buffer [current char(s) only]
//			- 0		= Flush Buffer [current char(s) inclusive]
//			- 1		= Save Buffer as Variable [excluding current char(s)]
//			- 2		= Save Buffer as Value [excluding current char(s)]
//			- 3		= Close Variable [excluding current char(s)]
//
//	Author:
//
//		Naught
//
//	See Also:
//
//		<CORE_fnc_getParsedValue>
//
//////////////////////////////////////////////////////////////
CORE_fnc_parseText = {
	private ["_text", "_parseConfig", "_textArray", "_charCount"];
	_text			= _this select 0;
	_parseConfig	= _this select 1;
	
	_textArray		= toArray _text;
	_charCount		= count _text;
	
	private ["_add", "_indexes", "_return", "_store", "_varStore", "_buffer", "_criticalError"];
	_add			= 1;
	_indexes		= [];
	_return			= false;
	_store			= [];
	_varStore		= [];
	_buffer			= [];
	_criticalError	= false;
	
	for [{_i = 0}, {_i <= _charCount}, {_i = _i + _add}] do {
		private ["_curCfg"];
		_add = 0;
		_curCfg =+ _parseConfig;
		{_curCfg = (_curCfg select _x) select 1} forEach _indexes;
		
		for "_j" from 0 to ((count _curCfg) - 1) do {
			private ["_cfg", "_syms", "_count", "_exit", "_bufferTemp"];
			_cfg		=+ _curCfg select _j;
			_syms		= toArray (_cfg select 0);
			_count		= count _syms;
			_exit		= true;
			_bufferTemp = [];
			
			for "_k" from 0 to (_count - 1) do {
				private ["_char", "_sym", "_exact", "_wcNS", "_wc"];
				_char	= _textArray select (_i + _k);
				_sym	= _syms select _k;
				_exact	= _char == _sym;
				_wcNS	= (_sym == ((toArray "*") select 0)) && (_char != ((toArray " ") select 0));
				_wc		= _sym == ((toArray "~") select 0);
				
				_bufferTemp = _bufferTemp + [_char];
				
				if !(_exact || _wcNS || _wc) then {
					_exit = false;
				};
			};
			
			if (_exit) exitWith { // Character matches config value
				
				if ((count _cfg) > 1) then { // New Configuration
					if (typeName(_cfg select 1) == typeName([])) then { // New Config Array
						if ((count (_cfg select 1)) > 0) then {
							_indexes = _indexes + [_j];
						};
					} else {
						if (typeName(_cfg select 1) == typeName(2)) then { // Jump to Level
							if ((_cfg select 1) >= 0) then {
								_indexes resize (_cfg select 1);
							};
						} else {
							[LOG_NOTICE, 'CORE_PARSER', "Invalid Pathway (Index 1) from Config Entry. Parsed Characters: %1. Config Level Path: %2.", [(_i + _count), _indexes], __FILE__, __LINE__] call CORE_fnc_log;
						};
					};
				};
				
				// Buffer Work
				private ["_action", "_save"];
				_action = if ((count _cfg) > 2) then {_cfg select 2} else {101};
				_save	= _action in [1,2,3];
				
				if (_save) then { // Save Variable | Value
					private ["_varCount", "_lastVar", "_addString"];
					_varCount	= count _varStore;
					_lastVar	= _varStore select (_varCount - 1);
					_addString	= toString(_buffer);
					
					if (_addString != "") then {
						switch (_action) do {
							case 1: { // Initialize Variable
								_varStore set [_varCount, [_addString, 0]];
								_addString = format["['%1',[", _addString];
							};
							case 2: { // Save Value
								private ["_varSaveCount"];
								_varSaveCount = (_lastVar select 1);
								_addString = format["['%1']", _addString];
								if (_varSaveCount > 0) then {_addString = "," + _addString};
								_lastVar set [1, (_varSaveCount + 1)];
								_varStore set [(_varCount - 1), _lastVar];
							};
							case 3: { // Save Variable
								if (_addString == (_lastVar select 0)) then {
									_addString = format["]]"];
									_varStore resize (_varCount - 1);
								} else {
									[LOG_ERROR, 'CORE_PARSER', "Variable Mismatch {'%1' != '%2'} in Parsing @ Character #%3. Buffer Array: %4.", [_addString, _lastVar, (_i + _count), _buffer], __FILE__, __LINE__] call CORE_fnc_log;
									_criticalError = true;
								};
							};
							default { // Invalid Action
								[LOG_NOTICE, 'CORE_PARSER', "Invalid Action Integer (%1) @ Character #%2. Lost Data: '%3'. Buffer Array: %4.", [_action, (_i + _count), _addString, _buffer], __FILE__, __LINE__] call CORE_fnc_log;
								_addString = "";
							};
						} else {
							[LOG_INFO, 'CORE_PARSER', "Empty Save (%1) Buffer @ Character #%2.", [_action, (_i + _count)], __FILE__, __LINE__] call CORE_fnc_log;
						};
						_store = _store + _addString;
					};
				};
				
				if (_action >= 0) then { // Flush Buffer
					_buffer = [];
				};
				if (_action > 0) then { // Add to Buffer
					_buffer = _buffer + _bufferTemp;
				};
				
				_add = _count;
			};
			if (_criticalError) exitWith {};
		};
		
		if (_add <= 0) then {
			[LOG_ERROR, 'CORE_PARSER', "Character not matched in Parsing Config. Parsed Characters: %1. Config Level Path: %2.", [(_i + _add), _indexes], __FILE__, __LINE__] call CORE_fnc_log;
			_criticalError = true;
		};
		
		if (_criticalError) exitWith {
			[LOG_ERROR, 'CORE_PARSER', "The CORE Parser experienced a critical error after %1 characters. Exiting...", [(_i + _add)], __FILE__, __LINE__] call CORE_fnc_log;
			_store = false;
		};
		
	};
	
	if (typeName(_store) == typeName("String")) then {
		_return = call compile _store;
	};
	
	_return
};

//////////////////////////////////////////////////////////////
//
//	Function: CORE_fnc_getParsedValue
//	---------------------------------
//
//	Description:
//
//		Retrieves value(s) from a passed parsedObject (generated from <CORE_fnc_parseText>) via a given variablePath.
//		Values may either be strings or arrays (parsedObjects).
//
//		> variablePath = ["EncapsulatedVar1"(, ... )];
//
//	Parameters:
//
//		_parsedObject - Parsed Object Array [Array].
//		_variablePath - The path of variable(s) to retrieve the value(s) [Array].
//
//	Returns:
//
//		All values that match variablePath [Array].
//
//	Examples:
//
//		- XML:
//			> <module><function name="func1" path="scripts\fnc_func1.sqf"/></module>
//		- To Get Function Path(s):
//			> _values = [_parsedXML, ["module", "function", "path"]] call CORE_fnc_getParsedValue;
//
//	Author:
//
//		Naught
//
//	See Also:
//
//		<CORE_fnc_parseText>
//
//////////////////////////////////////////////////////////////
CORE_fnc_getParsedValue = {
	private ["_parsedObject", "_variablePath", "_index", "_totalPaths", "_parsedObjects", "_result"];
	_parsedObject	= _this select 0;
	_variablePath	= _this select 1;
	
	_index			= 0;
	_totalPaths		= count _variablePath;
	_parsedObjects	= [[0, (+_parsedObject)]];
	_result			= [];
	
	while {_index = ((count _parsedObjects) - 1); _index >= 0} do {
		private ["_tempParsedObj", "_tempObj", "_objLevel", "_tempObjCount"];
		_tempParsedObj	= _parsedObjects select _index;
		_objLevel		= _tempParsedObj select 0;
		_tempObj		= _tempParsedObj select 1;
		_tempObjCount	= count _tempObj;
		
		_parsedObjects resize ((count _parsedObjects) - 1);
		
		for [{_i = 0}, {_i <= (_tempObjCount - 1)}, {_i = _i + 1}] do {
			private ["_obj"];
			_obj	= _tempObj select _i;
			
			if ((_obj select 0) == (_variablePath select _objLevel)) then {
				if (_objLevel == (_totalPaths - 1)) then {
					_result = _result + [(_obj select 1)];
				} else {
					_objLevel = _objLevel + 1;
					_parsedObjects set [((count _parsedObjects) - 1), [_objLevel, _tempObj]];
				};
			};
		};
	};
	
	_result
};
