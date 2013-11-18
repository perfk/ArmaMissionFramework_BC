
/******************************
*	Framework Driver Notes
*
*		Local Machine State:
*			Machine States:
*				1  - Client
*				2  - Player
*				4  - Headless Client
*				8  - Non-JIP
*				16 - JIP
*				32 - Server
*				64 - Dedicated
*			Figuring State:
*				To figure a machine's state, add the number of the machine's
*				characteristics above. For instance, a dedicated server would
*				have a machine state of 96, a HC would be 13 or 21 (depending
*				on when it joined the game, before game start or after), and
*				a JIP player would be 19.
*				But base numbers work too with some calculation, so all clients
*				can also be stated as 1.
*
******************************/

/****************************
*  Preprocessor Macros
*****************************/

#define CFG_ENTRY_EQUAL(cfgEntry,var1)	((isNumber (cfgEntry)) && ((getNumber (cfgEntry)) == var1))
#define CFG_ENTRY_TRUE(cfgEntry)		CFG_ENTRY_EQUAL(cfgEntry,1)
#define CFG_ENTRY_FALSE(cfgEntry)		CFG_ENTRY_EQUAL(cfgEntry,0)

/****************************
*  Static Definitions
*****************************/

CORE_LMS_all					= [1,32];
CORE_LMS_client 				= 1;
CORE_LMS_player 				= 2;
CORE_LMS_hc						= 4;
CORE_LMS_nonJIP 				= 8;
CORE_LMS_JIP 					= 16;
CORE_LMS_server			 		= 32;
CORE_LMS_aiHost 				= [4,32];
cm_core_initFunctions			= [];
cm_core_initAIFunctions			= [];
cm_core_priority_immediate		= 0;
cm_core_priority_high			= 1;
cm_core_priority_normal			= 10;
cm_core_priority_low			= 50;
cm_core_priority_last			= 100;

/****************************
*  API Functions
*****************************/

CORE_fnc_isMachine = {
	private ["_localMachine", "_testMachines", "_return"];
	_localMachine	= _this select 0;
	_testMachines	= _this select 1;
	_return			= false;
	if (typeName(_testMachines) == typeName(2)) then {
		_testMachines = [_testMachines];
	};
	if (typeName(_testMachines) == typeName([])) then {
		{
			if ([_localMachine, _x] call CORE_fnc_decHasBin) exitWith {
				_return = true;
			};
		} forEach _testMachines;
	};
	_return
};

/****************************
*  Internal Functions
*****************************/

cm_core_fnc_initComponents = {
	private ["_initFunctions"];
	_initFunctions	= +cm_core_initFunctions;
	// Sort by Priority
	_initFunctions	= [_initFunctions, 5] call CBA_fnc_sortNestedArray;
	/* Loading All Init Functions */
	for "_i" from 0 to ((count _initFunctions) - 1) do {
		private ["_function", "_run"];
		_function = _initFunctions select _i;
		_run = if ((count _function) > 4) then {
			if (typeName(_function select 4) == typeName(true)) then {
				(_function select 4);
			} else {
				[CORE_machine, (_function select 4)] call CORE_fnc_isMachine;
			};
		} else {true};
		if (_run) then {
			[(_function select 0), (_function select 2)] call CORE_fnc_spawnFunction;
		};
	};
};

cm_core_fnc_loadModules = {
	private ["_modules", "_moduleCategories"];
	_modules			= [];
	_moduleCategories	= _this select 0;
	{
		private ["_manifest", "_path", "_maniPath", "_moduleArray"];
		_manifest = _x;
		_path = "modules\" + _manifest + "\";
		_maniPath = _path + "manifest.file";
		_moduleArray = call compile ("[" + (preProcessFile _maniPath) + "]");
		if (typeName(_moduleArray) != typeName([])) then {
			[LOG_ERROR, 'CORE_LOADMODULES', "Cannot load modules in the '%1' manifest! Manifest corrupted. Manifest File: '%2'.", [_manifest, _maniPath], __FILE__, __LINE__] call CORE_fnc_log;
		} else {
			{ // Load Modules
				if (typeName(_x) == typeName("String")) then {
					private ["_filePath", "_file"];
					_filePath	= _path + _x + "\init.sqf";
					_file		= preProcessFileLineNumbers _filePath;
					if (_file != "") then {
						/*
						private ["_handle"];
						_handle = [] spawn compile _file;
						*/
						private ["_return"];
						_return = call compile _file;
						if !(isNil "_return") then {
							if (typeName(_return) == typeName([])) then {
								{ // Load Returned Functions
									// _x = ['name', 'path'(, [params], execBool, machineInt, priority)];
									// Priority (any number): Immediate=0, High=1, Normal=10, Low=50, Last=100
									[(_x select 0), (_x select 1)] call CORE_fnc_compileFunction;
									if ((count _x) > 3) then {
										if (_x select 3) then {
											if ((count _x) <= 4) then {_x set [4, true]};
											if ((count _x) <= 5) then {_x set [5, cm_core_priority_normal]};
											cm_core_initFunctions = cm_core_initFunctions + [_x];
										};
									};
								} forEach _return;
							};
						};
						[LOG_INFO, 'CORE_LOADMODULES', "Loaded the '%1' module from the '%2' manifest. Module File: '%3'.", [_x, _manifest, _filePath], __FILE__, __LINE__] call CORE_fnc_log;
					};
				} else {
					[LOG_ERROR, 'CORE_LOADMODULES', "Cannot load module '%1' in the '%2' manifest! Ensure string format. Manifest File: '%3'.", [_x, _manifest, _maniPath], __FILE__, __LINE__] call CORE_fnc_log;
				};
			} forEach _moduleArray;
		};
	} forEach _moduleCategories;
};

cm_core_fnc_loadParams = {
	private ["_paramCfg", "_params", "_default"];
	_paramCfg	= missionConfigFile >> "Params";
	_params		= [];
	_default	= false;
	if (isNil "paramsArray") then {
		_default = true;
		paramsArray = [];
	};
	for "_i" from 0 to ((count _paramCfg) - 1) do {
		private ["_param", "_var", "_value"];
		_param		= _paramCfg select _i;
		if (isText (_param >> "varName")) then {
			_var = getText (_param >> "varName");
		} else {
			_var = format["PARAMS_%1", (configName _param)];
		};
		if (_default) then {
			_value = getNumber (_param >> "default");
			paramsArray set [_i, _value];
		} else {
			_value = paramsArray select _i;
		};
		if CFG_ENTRY_TRUE(_param >> "toBool") then {
			_value = [_value] call CORE_fnc_toBool;
		};
		if (isText (_param >> "executeCode")) then {
			_value = _value call compile (getText (_param >> "executeCode"));
		};
		if (_var != "") then {
			missionNameSpace setVariable [_var, _value];
		};
		_params = _params + [[getText(_param >> "title"), _var, _value]];
	};
	['parameters', _params, false, true] call CORE_fnc_setVariable;
};

cm_core_fnc_localMachineState = {
	private ["_machineState"];
	_machineState = 0;
	if (isServer) then {
		_machineState = _machineState + 32; // Server
	};
	if (isDedicated) then {
		_machineState = _machineState + 64; // Dedicated Server
	} else {
		_machineState = _machineState + 1; // Client
		if (hasInterface) then {
			_machineState = _machineState + 2; // Player
		} else {
			_machineState = _machineState + 4; // HC
		};
		
		if (isNull player) then {
			_machineState = _machineState + 16; // JIP
		} else {
			_machineState = _machineState + 8; // Non-JIP
		};
	};
	_machineState
};

/****************************
*  Finalizing Driver Load
*****************************/

CORE_machine = call cm_core_fnc_localMachineState;
