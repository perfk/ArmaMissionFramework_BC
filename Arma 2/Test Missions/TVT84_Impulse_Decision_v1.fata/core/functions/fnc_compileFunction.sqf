
private ["_functionPath", "_function", "_success"];
_functionPath		= _this select 1;

_function = compile preProcessFileLineNumbers _functionPath;
_this set [1, _function];
_success = _this call CORE_fnc_saveFunction;

_function