
#define METHOD_DB_SEPERATOR		'_'
#define DB_RECORD_SEPERATOR		'_'

private ["_method", "_dbName", "_recordName", "_keyName"];

_method		= _this select 0;
_dbName		= _this select 1;
_recordName	= _this select 2;

_keyName	= str(_method) + METHOD_DB_SEPERATOR + _dbName + DB_RECORD_SEPERATOR + _recordName;

_keyName
