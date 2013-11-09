
// Load Functions
_functions = [
	["msc_addExtractActions", "modules\common\missionSpecificCode\functions\fnc_addExtractActions.sqf", [], true, CORE_LMS_player, cm_core_priority_last],
	["msc_addIntelActions", "modules\common\missionSpecificCode\functions\fnc_addIntelActions.sqf", [], true, CORE_LMS_player, cm_core_priority_last],
	["msc_createExtracts", "modules\common\missionSpecificCode\functions\fnc_createExtracts.sqf", [], true, CORE_LMS_server],
	["msc_warlordUpdate", "modules\common\missionSpecificCode\functions\fnc_warlordUpdate.sqf", [], true, CORE_LMS_player, cm_core_priority_last]
];

/*****************************/
/* Initialization Code Below */
/*        NO WAITING!        */
/*****************************/

private ["_firedFunc", "_killedFunc"];

_firedFunc = {
	private ["_unit"];
	_unit = gunner (_this select 0);
	if (!(isNull _unit) && ((side _unit) != sideEnemy)) then {
		if ([_unit, "neutral_zone_area_1"] call CBA_fnc_inArea) then {
			_unit addRating -99999; // Had to over-do it
			['msc_revealUnit', _unit] call CBA_fnc_globalEvent;
		};
	};
};

_killedFunc = {
	private ["_unit", "_killer"];
	_unit = _this select 0;
	_killer = _this select 1;
	if (!(isNull _killer) && ((side _killer) != sideEnemy)) then {
		if ([_unit, "neutral_zone_area_1"] call CBA_fnc_inArea) then {
			if ((_killer distance (getMarkerPos tottah_patrol_center)) < 450) then {
				_killer addRating -99999; // Had to over-do it
				['msc_revealUnit', _killer] call CBA_fnc_globalEvent;
			};
		};
	};
};

if (isServer) then {
	
	civilian setFriend [sideEnemy, 0];
	resistance setFriend [sideEnemy, 0];
	west setFriend [sideEnemy, 0];
	east setFriend [sideEnemy, 0];
	
	msc_missionEnding = false;
	msc_warlords = [azagal_1_1_0_warlord, razzale_1_1_0_warlord];
	msc_prisoners = [civ_1_1_0_prisoner, civ_1_2_0_prisoner];
	msc_missionCO = [blu_1_6_0_sl, op_1_6_0_sl] + msc_warlords;
	msc_extraction = [[WEST, false, 0], [EAST, false, 0]];
	msc_timeToEnd = round((2 + random(3)) * 60);
	publicVariable "msc_missionEnding";
	publicVariable "msc_warlords";
	publicVariable "msc_prisoners";
	publicVariable "msc_missionCO";
	publicVariable "msc_extraction";
	publicVariable "msc_timeToEnd";
	
	['msc_revealUnit', {
		{
			if (local(leader _x)) then {
				_x reveal [_this, 4];
			};
		} forEach allGroups;
	}] call CBA_fnc_addEventHandler;
	
	{
		if (local _x) then {
			_x addEventHandler ["Killed", _killedFunc];
		};
	} forEach allUnits;
};

if ([CORE_machine, CORE_LMS_player] call CORE_fnc_isMachine) then {
	
	switch (side player) do {
		case RESISTANCE: {
			private ["_area"];
			_area = nil;
			{
				if ([player, _x] call CBA_fnc_inArea) then {
					_area = _x;
				};
			} forEach ["setup_area_orange_1", "setup_area_orange_2"];
			if (!isNil "_area") then {
				player setVariable ["build_area", _area, true];
			};
		};
		case CIVILIAN: {
			[] spawn {
				waitUntil {!isNil "msc_prisoners"};
				uiSleep 10;
				sleep 0.1;
				if (player in msc_prisoners) then {
					["ace_sys_interaction_swm2", [player, "CivilLying01"]] call CBA_fnc_GlobalEvent;
					player setVariable ["ace_sys_interaction_cuffed", true, true];
				};
			};
		};
	};
	
	player addEventHandler ["Fired", _firedFunc];
	player addEventHandler ["Killed", _killedFunc];
};

/*****************************/
/*  End Initialization Code  */
/*****************************/

_functions