
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
