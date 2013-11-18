
/*****************************/
/*  Core Pre-Initialization  */
/*****************************/

/* Core Static Definitions */
#define DRIVER_PATH			"core\drivers\"
#define LIBRARY_PATH		"core\libraries\"

/* Defining Core Macros */
#define COMPILE_FILE(file)	(compile preProcessFileLineNumbers (file))
#define CALL_FILE(file)		(call COMPILE_FILE(file))
#define CALL_FILE_EXT(file)	CALL_FILE(file + ".sqf")
#define LOAD_DRV(driver)	CALL_FILE_EXT(DRIVER_PATH + driver)
#define LOAD_LIB(lib)		CALL_FILE_EXT(LIBRARY_PATH + lib + "\init")

/* Loading Libraries */
LOAD_LIB("addons");
LOAD_LIB("arrays");
LOAD_LIB("conversions");
LOAD_LIB("math");
LOAD_LIB("time");

/* Loading Drivers */
LOAD_DRV("logging");
LOAD_DRV("database");
LOAD_DRV("framework");

/* Loading Core Settings */
#include "settings.sqf"

/* Starting Core Init */
private ["_startTime"];
_startTime = diag_tickTime;
[LOG_NOTICE, 'CORE', "Core Initialization Starting!", [], __FILE__, __LINE__] call CORE_fnc_log;

/* Setting Variables */
CORE_init = false;
if (isServer) then {
	CORE_serverInit = false;
	publicVariable "CORE_serverInit";
};

/*****************************/
/*    Core Synchronization   */
/*****************************/

/* Waiting for XEH Post Init */
if (_waitForXEHPostInit) then {
	[[{!(isNil "SLX_XEH_MACHINE") && {SLX_XEH_MACHINE select 8}}], 'XEH Post Init', 0, LOG_NOTICE] call CORE_fnc_waitUntil;
};

/* Waiting For Server */
if (!isServer && _waitForServer) then {
	[[{!(isNil "CORE_serverInit") && {CORE_serverInit}}], 'Server Init', 0, LOG_NOTICE] call CORE_fnc_waitUntil;
};

/*****************************/
/*    Core Initialization    */
/*****************************/

/* Load Mission Parameters */
[] call cm_core_fnc_loadParams;

/* Waiting for Player */
if (!isDedicated) then {
	waitUntil {!(isNull player)};
};

/* Initializing Internal Database Driver */
[] call cm_core_fnc_initDatabaseDriver;

/* Loading Modules */
[cm_core_moduleCategories] call cm_core_fnc_loadModules;

/* Executing Init Components */
[] call cm_core_fnc_initComponents;

/* Process setVehicleInit Code */
processInitCommands;

/* Finish World Initialization*/
finishMissionInit;

/* Finalizing Initialization */
CORE_init = true;
if (isServer) then {
	CORE_serverInit = true;
	publicVariable "CORE_serverInit";
};

/* Ending Core Init */
[LOG_NOTICE, 'CORE', "Core Initialization Finished! STATS: Machine=%1, Benchmark=%2, FuncDB=%3, VarDB=%4", [
	CORE_machine,
	(diag_tickTime - _startTime),
	cm_core_functionDBMethod,
	cm_core_variableDBMethod
], __FILE__, __LINE__] call CORE_fnc_log;

true
