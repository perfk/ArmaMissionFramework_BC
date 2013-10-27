
private ["_params", "_success"];

_params = [cm_core_functionDBMethod, cm_core_functionDB] + _this;
_success = _params call cm_core_fnc_querySetProxy;

if (_success) then {
	cm_core_functionKeys = cm_core_functionKeys + [(_this select 0)];
};

_success
