if (isNil "cm_core_db_hashMaps") then {cm_core_db_hashMaps = []};
if (isNil "cm_core_db_jalEnabled") then {cm_core_db_jalEnabled = ['jayarma2lib'] call CORE_fnc_checkAddon};

if !(_db in cm_core_db_hashMaps) then {
	if (cm_core_db_jalEnabled) then {
		[_db] call cm_core_fnc_createHashMap;
		cm_core_db_hashMaps = cm_core_db_hashMaps + [_db];
	} else {
		[LOG_CRIT, 'CORE', "JayArma2Lib not available. HashMap '%1' cannot be created.", [_db], __FILE__, __LINE__] call CORE_fnc_log;
	};
};