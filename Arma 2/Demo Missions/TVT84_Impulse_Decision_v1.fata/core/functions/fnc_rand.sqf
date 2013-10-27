
#define ICG_M	(2^16)
#define ICG_A	((2^8) + 1)
#define ICG_C	((2^11) + 1)

private ["_seed"];

if (typeName(_this) == typeName(1)) then {_this = [_this]};
if (typeName(_this) != typeName([])) then {_this = []};

_seed		= if ((count _this) > 0) then {_this select 0} else {random(ICG_M)};
_seed		= (ICG_A * _seed + ICG_C) mod ICG_M;
_seed
