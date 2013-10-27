
private ["_index", "_recordValue", "_recordName", "_db"];

_db				= _this select 0;
_recordName		= _this select 1;
_recordValue	= _this select 2;

_index = (_db select 0) find _recordName;

if (_index >= 0) then {
	(_db select 1) set [_index, _recordValue];
} else {
	(_db select 1) set [(count (_db select 1)), _recordValue];
};

_db
