#include "h\oop.h"

CLASS("DynAI_CachedUnit")
	
	PRIVATE STATIC_VARIABLE("array","cachedUnits");
	PRIVATE VARIABLE("object","unit");
	PRIVATE VARIABLE("string","class");
	PRIVATE VARIABLE("string","rank");
	PRIVATE VARIABLE("scalar","skill");
	PRIVATE VARIABLE("array","weapons");
	PRIVATE VARIABLE("array","magazines");
	
	PUBLIC FUNCTION("","getUnit") FUNC_GETVAR("unit");
	PUBLIC FUNCTION("","getClass") FUNC_GETVAR("class");
	PUBLIC FUNCTION("","getRank") FUNC_GETVAR("rank");
	PUBLIC FUNCTION("","getSkill") FUNC_GETVAR("skill");
	PUBLIC FUNCTION("","getWeapons") FUNC_GETVAR("weapons");
	PUBLIC FUNCTION("","getMagazines") FUNC_GETVAR("magazines");
	
	PUBLIC FUNCTION("array","constructor") {
		private ["_unit", "_class", "_rank", "_skill", "_weps", "_mags"];
		_unit	= _this select 0;
		if (!(isNull _unit)) then {
			_class	= typeOf _unit;
			_rank	= rank _unit;
			_skill	= skill _unit;
			_weps	= weapons _unit;
			_mags	= magazines _unit;
		} else {
			_class	= _this select 1;
			_rank	= DEFAULT_PARAM(3,"PRIVATE");
			_skill	= DEFAULT_PARAM(4,0.2);
			_weps	= DEFAULT_PARAM(5,[]);
			_mags	= DEFAULT_PARAM(6,[]);
		};
		MEMBER("unit",_unit);
		MEMBER("class",_class);
		MEMBER("rank",_rank);
		MEMBER("skill",_skill);
		MEMBER("weapons",_weps);
		MEMBER("magazines",_mags);
		PUSH_ARR("cachedUnits",[_classID]);
	};
	
	PUBLIC FUNCTION("","deconstructor") {
		DELETE_VARIABLE("unit");
		DELETE_VARIABLE("class");
		DELETE_VARIABLE("rank");
		DELETE_VARIABLE("skill");
		DELETE_VARIABLE("weapons");
		DELETE_VARIABLE("magazines");
		REM_ARR("cachedGroups",[_classID]);
		true;
	};
	
ENDCLASS;