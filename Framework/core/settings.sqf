
/*****************************/
/****    Core Settings    ****/
/*****************************/

cm_core_moduleCategories	= ["client", "common", "server"];

/******************************
*	Error Logging
*	
*		Log Levels:
*
*		LOG_NONE	= 0;	// None
*		LOG_CRIT	= 1;	// Critical
*		LOG_ERROR	= 2;	// Error
*		LOG_WARN	= 4;	// Warning
*		LOG_NOTICE	= 8;	// Notice
*		LOG_INFO	= 16;	// Info
*		LOG_ALL		= 31;	// All
*
*	Add (or subtract) log levels
*	ie. 'LOG_CRIT + LOG_ERROR'
*	or 'LOG_ALL - LOG_INFO'
*	or 'LOG_NONE'
*
*****************************/
CORE_logLevel				= LOG_ALL - LOG_INFO;	// Logging Level: Dev = LOG_ALL; Prod = LOG_ALL - LOG_INFO;

/******************************
*	Database Settings
*	
*		Notes:
*			Standard Database Storage Methods (Schemas):
*				"hashmap"		- JayArma2Lib HashMap
*				"missionNS"		- MissionNameSpace			(Global Variable)
*				"uiNS" 			- UINameSpace				(Peristant)
*				"hashmap_db"	- JayArma2Lib HashMap DB						(SLOW)
*				"missionNS_db"	- MissionNameSpace DB		(Global Variable)	(SLOW)
*				"uiNS_db" 		- UINameSpace DB			(Peristant)			(SLOW)
*
*		Caution: JayArma2Lib is largely broken at the moment, so I'd
*				 recommend against using it currently (9/15/2013).
*
*		DO NOT CHANGE DATABASE VARIABLES AFTER MISSION START
*				
******************************/
cm_core_functionDB			= "cm_functions";	// Name of the Functions Database
cm_core_functionDBMethod	= "missionNS";		// Method of DB Storage
cm_core_variableDB			= "cm_variables";	// Name of the Variables Database
cm_core_variableDBMethod	= "missionNS";		// Method of DB Storage

/* Local Initialization Settings */
private [ "_waitForXEHPostInit", "_waitForServer"];
_waitForXEHPostInit			= true;				// Delays init until XEH Post Init is done.
_waitForServer				= true;				// Delays client init until server's is done.
