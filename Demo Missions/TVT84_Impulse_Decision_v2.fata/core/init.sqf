
/*****************************/
/*  Core Pre-Initialization  */
/*****************************/

private ["_startTime"];

/* Defining Core Macros */
#define COMPILE_FILE(file)		(compile preProcessFileLineNumbers file)
#define CALL_FILE(file)			(call COMPILE_FILE(file))

/* Setting Logging Variables */
LOG_NONE	= 0;	// None
LOG_CRIT	= 1;	// Critical
LOG_ERROR	= 2;	// Error
LOG_WARN	= 4;	// Warning
LOG_NOTICE	= 8;	// Notice
LOG_INFO	= 16;	// Info
LOG_ALL		= 31;	// All

/* Loading Core Settings */
#include "settings.sqf"

/* Loading Logging Script */
CORE_fnc_log = COMPILE_FILE("core\functions\fnc_log.sqf");

/* Starting Core Init */
_startTime = diag_tickTime;
[LOG_NOTICE, 'CORE', "Core Initialization Starting!", [], __FILE__, __LINE__] call CORE_fnc_log;

/* Setting Variables */
CORE_init							= false;
cm_core_storageKeys					= [];
cm_core_storageKeysLookup			= [];
cm_core_functionKeys				= [];
cm_core_variableKeys				= [];
cm_core_initFunctions				= [];
cm_core_initAIFunctions				= [];
cm_core_priority_immediate			= 0;
cm_core_priority_high				= 1;
cm_core_priority_normal				= 10;
cm_core_priority_low				= 50;
cm_core_priority_last				= 100;

if (isServer) then {
	/* Server Variables */
	cm_core_publicStorageKeys		= [];
	cm_core_publicStorageKeyRequest	= [-1, ObjNull, []]; // [I/O, Machine, RequestedKeys]
	CORE_serverInit					= false;
	
	/* Broadcasting Variables */
	publicVariable "cm_core_publicStorageKeys";
	publicVariable "cm_core_publicStorageKeyRequest";
	publicVariable "CORE_serverInit";
};

/* Loading Core Internal Functions */
cm_core_fnc_addStorageKey			= COMPILE_FILE("core\functions\fnc_addStorageKey.sqf");
cm_core_fnc_checkPublicKeys			= COMPILE_FILE("core\functions\fnc_checkPublicKeys.sqf");
cm_core_fnc_createHashMap			= COMPILE_FILE("core\functions\fnc_createHashMap.sqf");
cm_core_fnc_dbAppend				= COMPILE_FILE("core\functions\fnc_dbAppend.sqf");
cm_core_fnc_getStorageKey			= COMPILE_FILE("core\functions\fnc_getStorageKey.sqf");
cm_core_fnc_getStorageKeyName		= COMPILE_FILE("core\functions\fnc_getStorageKeyName.sqf");
cm_core_fnc_initComponents			= COMPILE_FILE("core\functions\fnc_initComponents.sqf");
cm_core_fnc_loadModules				= COMPILE_FILE("core\functions\fnc_loadModules.sqf");
cm_core_fnc_loadParams				= COMPILE_FILE("core\functions\fnc_loadParams.sqf");
cm_core_fnc_localMachineState		= COMPILE_FILE("core\functions\fnc_localMachineState.sqf");
cm_core_fnc_publicKeyRequestHandler	= COMPILE_FILE("core\functions\fnc_publicKeyRequestHandler.sqf");
cm_core_fnc_queryGet				= COMPILE_FILE("core\functions\fnc_queryGet.sqf");
cm_core_fnc_querySet				= COMPILE_FILE("core\functions\fnc_querySet.sqf");
cm_core_fnc_querySetProxy			= COMPILE_FILE("core\functions\fnc_querySetProxy.sqf");
cm_core_fnc_setHashValue			= COMPILE_FILE("core\functions\fnc_setHashValue.sqf");

/*****************************/
/*  Core API Initialization  */
/*****************************/

/* Loading API Constants */
CORE_LMS_all						= [1,32];
CORE_LMS_client 					= 1;
CORE_LMS_player 					= 2;
CORE_LMS_hc							= 4;
CORE_LMS_nonJIP 					= 8;
CORE_LMS_JIP 						= 16;
CORE_LMS_server			 			= 32;
CORE_LMS_aiHost 					= [4,32];

/* Loading API Functions */
CORE_fnc_callFunction				= COMPILE_FILE("core\functions\fnc_callFunction.sqf");
CORE_fnc_checkAddon					= COMPILE_FILE("core\functions\fnc_checkAddon.sqf");
CORE_fnc_compileFunction			= COMPILE_FILE("core\functions\fnc_compileFunction.sqf");
CORE_fnc_decHasBin					= COMPILE_FILE("core\functions\fnc_decHasBin.sqf");
CORE_fnc_decToBin					= COMPILE_FILE("core\functions\fnc_decToBin.sqf");
CORE_fnc_getFunction				= COMPILE_FILE("core\functions\fnc_getFunction.sqf");
CORE_fnc_getVariable				= COMPILE_FILE("core\functions\fnc_getVariable.sqf");
CORE_fnc_isFilePath					= COMPILE_FILE("core\functions\fnc_isFilePath.sqf");
CORE_fnc_isMachine					= COMPILE_FILE("core\functions\fnc_isMachine.sqf");
CORE_fnc_rand						= COMPILE_FILE("core\functions\fnc_rand.sqf");
CORE_fnc_saveFunction				= COMPILE_FILE("core\functions\fnc_saveFunction.sqf");
CORE_fnc_setVariable				= COMPILE_FILE("core\functions\fnc_setVariable.sqf");
CORE_fnc_sideToText					= COMPILE_FILE("core\functions\fnc_sideToText.sqf");
CORE_fnc_sortArray					= COMPILE_FILE("core\functions\fnc_sortArray.sqf");
CORE_fnc_spawnFunction				= COMPILE_FILE("core\functions\fnc_spawnFunction.sqf");
CORE_fnc_timeOut					= COMPILE_FILE("core\functions\fnc_timeOut.sqf");
CORE_fnc_toBool						= COMPILE_FILE("core\functions\fnc_toBool.sqf");
CORE_fnc_waitUntil					= COMPILE_FILE("core\functions\fnc_waitUntil.sqf");

/* Getting Local Machine State and Saving to API Constant */
CORE_machine = call cm_core_fnc_localMachineState;

/*****************************/
/*    Core Synchronization   */
/*****************************/

/* Waiting for XEH Post Init */
if (_waitForXEHPostInit) then {
	[[{!(isNil "SLX_XEH_MACHINE")}, {SLX_XEH_MACHINE select 8}], 'XEH Post Init', 0, LOG_NOTICE] call CORE_fnc_waitUntil;
};

/* Waiting For Server */
if (!isServer && _waitForServer) then {
	[[{!(isNil "CORE_serverInit") && {CORE_serverInit}}], 'Server Init', 0, LOG_NOTICE] call CORE_fnc_waitUntil;
};

/*****************************/
/*    Core Initialization    */
/*****************************/

/* Jay Arma 2 Library Plugin Initialization */
if (['jayarma2lib'] call CORE_fnc_checkAddon) then {
	{
		if ((_x select 1) in [0,3]) then {
			(_x select 0) call cm_core_fnc_createHashMap;
		};
	} forEach [
		[cm_core_functionDB, cm_core_functionDBMethod],
		[cm_core_variableDB, cm_core_variableDBMethod]
	];
} else {
	if (cm_core_functionDBMethod in [0,3]) then {cm_core_functionDBMethod = 1};
	if (cm_core_variableDBMethod in [0,3]) then {cm_core_variableDBMethod = 1};
	[LOG_NOTICE, 'CORE', "JayArma2Lib not available. HashMaps cannot be used.", [], __FILE__, __LINE__] call CORE_fnc_log;
};

/* Load Mission Parameters */
[] call cm_core_fnc_loadParams;

/* Waiting for Player */
if (!isDedicated) then {
	waitUntil {!(isNull player)};
};

/* Adding Event Handlers */
["cm_core_publicQuerySet", cm_core_fnc_querySet] call CBA_fnc_addEventHandler;

/* Adding Public Key Request Handler */
'cm_core_publicStorageKeyRequest' addPublicVariableEventHandler cm_core_fnc_publicKeyRequestHandler;

/* Handling Public Keys */
if (!isDedicated) then {
	[] spawn cm_core_fnc_checkPublicKeys;
};

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
