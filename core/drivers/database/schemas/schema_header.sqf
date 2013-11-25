private ["_call", "_method", "_db", "_record", "_data"];
_call		= _this select 0;
_method		= _this select 1;
_db			= _this select 2;
_record		= _this select 3;
_data		= if ((count _this) > 4) then {_this select 4} else {nil};