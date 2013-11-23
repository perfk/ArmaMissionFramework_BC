#include "h\oop.h"

CLASS("DynAI_CachedSquad")
	
	PRIVATE STATIC_VARIABLE("array","cachedGroups");
	PRIVATE VARIABLE("side","side");
	PRIVATE VARIABLE("group","group");
	PRIVATE VARIABLE("code","leader"); // Class type of "DynAI_CachedUnit"
	PRIVATE VARIABLE("array","units"); // Class type of "DynAI_CachedUnit"
	PRIVATE VARIABLE("array","position");
	PRIVATE VARIABLE("string","formation");
	PRIVATE VARIABLE("string","behaviour");
	PRIVATE VARIABLE("string","combatMode");
	
	PUBLIC FUNCTION("","getSpawnState") FUNC_GETVAR("spawned");
	PUBLIC FUNCTION("","getSide") FUNC_GETVAR("side");
	PUBLIC FUNCTION("","getGroup") FUNC_GETVAR("group");
	PUBLIC FUNCTION("","getLeader") FUNC_GETVAR("leader");
	PUBLIC FUNCTION("","getUnits") FUNC_GETVAR("units");
	PUBLIC FUNCTION("","getPosition") FUNC_GETVAR("position");
	PUBLIC FUNCTION("","getFormation") FUNC_GETVAR("formation");
	PUBLIC FUNCTION("","getBehaviour") FUNC_GETVAR("behaviour");
	PUBLIC FUNCTION("","getCombatMode") FUNC_GETVAR("combatMode");
	
	PUBLIC FUNCTION("array","constructor") {
		private ["_group", "_side", "_leader", "_units", "_pos", "_format", "_behave", "_cMode"];
		_group	= _this select 0;
		if (!(isNull _group)) then {
			_side	= side _group;
			_format	= formation _group;
			_behave	= behaviour _group;
			_cMode	= combatMode _group;
			if ((count (units _group)) > 0) then {
				_pos	= getPos (leader _group);
				_units	= units _group;
				_leader	= leader _group;
			} else {
				_pos	= [0,0,0];
				_leader	= nil;
				_units	= [];
			};
		} else {
			_side	= _this select 1;
			_leader	= DEFAULT_PARAM(2,nil);
			_units	= DEFAULT_PARAM(3,[]);
			_pos	= DEFAULT_PARAM(4,[0,0,0]);
			_format	= DEFAULT_PARAM(5,"WEDGE");
			_behave	= DEFAULT_PARAM(6,"SAFE");
			_cMode	= DEFAULT_PARAM(7,"YELLOW");
		};
		MEMBER("side",_side);
		MEMBER("group",_group);
		MEMBER("position",_pos);
		MEMBER("formation",_format);
		MEMBER("behaviour",_behave);
		MEMBER("combatMode",_cMode);
		if ((count _units) > 0) then {
			MEMBER("addUnits",_units);
			if (!isNil "_leader") then {
				MEMBER("setLeader",_leader);
			};
		};
		PUSH_ARR("cachedGroups",[_classID]);
	};
	
	PUBLIC FUNCTION("","deconstructor") {
		DELETE_VARIABLE("side");
		DELETE_VARIABLE("group");
		DELETE_VARIABLE("leader");
		DELETE_VARIABLE("units");
		DELETE_VARIABLE("position");
		DELETE_VARIABLE("formation");
		DELETE_VARIABLE("behaviour");
		DELETE_VARIABLE("combatMode");
		REM_ARR("cachedGroups",[_classID]);
		true;
	};
	
	PUBLIC FUNCTION("side","setSide") {
		if ( isNull MEMBER("group",nil) ) then {
			MEMBER("side",_args);
			true;
		} else {false};
	};
	
	PUBLIC FUNCTION("any","addUnit") {
		private ["_unit"];
		_unit = nil;
		switch (typeName _this) do {
			case "OBJECT": {
				_unit = ["new", _this] call DynAI_CachedUnit;
			};
			case "STRING": {
				_unit = _this;
			};
		};
		if (!isNil "_unit") then {
			PUSH_VAR("units",[_unit]);
		};
		_unit;
	};
	
	PUBLIC FUNCTION("array","addUnits") {
		{ // forEach
			MEMBER("addUnit",_x);
		} forEach _this;
	};
	
ENDCLASS;