
private ["_params", "_success"];

_params = [cm_core_variableDBMethod, cm_core_variableDB] + _this;
_success = _params call cm_core_fnc_querySetProxy;

if (_success) then {
	cm_core_variableKeys = cm_core_variableKeys + [(_this select 0)];
};

_success
