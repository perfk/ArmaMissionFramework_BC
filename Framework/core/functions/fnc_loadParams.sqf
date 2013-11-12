
#define CFG_ENTRY_EQUAL(cfgEntry,var1)	((isNumber (cfgEntry)) && ((getNumber (cfgEntry)) == var1))
#define CFG_ENTRY_TRUE(cfgEntry)		CFG_ENTRY_EQUAL(cfgEntry,1)
#define CFG_ENTRY_FALSE(cfgEntry)		CFG_ENTRY_EQUAL(cfgEntry,0)

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