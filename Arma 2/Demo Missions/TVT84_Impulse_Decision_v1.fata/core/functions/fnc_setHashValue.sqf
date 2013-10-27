
private ["_hashTable", "_hashKey", "_hashValue"];

_hashTable		= _this select 0;
_hashKey		= _this select 1;
_hashValue		= _this select 2;

[_hashTable, _hashKey] call jayarma2lib_fnc_hashmapDeleteValue;
_return = [_hashTable, _hashKey, str(_hashValue)] call jayarma2lib_fnc_hashmapAddValue;

_return
