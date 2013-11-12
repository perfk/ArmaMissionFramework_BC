
private ["_visible", "_action"];

_visible = "
	private ['_return'];
	_return = false;
	{
		if (((_x select 0) == playerSide) && ([player, (_x select 1)] call CBA_fnc_inArea) && !(msc_missionEnding)) exitWith {
			_return = true;
		};
	} forEach msc_extractMarkers;
	_return
";

_action = "
	for '_i' from 0 to ((count msc_extraction) - 1) do {
		private ['_extract', '_side'];
		_extract = msc_extraction select _i;
		_side = _extract select 0;
		if ((_side == playerSide) && !(_extract select 1)) then {
			[0, {
				private ['_extract'];
				_extract = _this select 0;
				_extract set [1, true];
				_extract set [2, (time + msc_timeToEnd)];
				msc_extraction set [(_this select 1), _extract];
				publicVariable 'msc_extraction';
			}, [_extract, _i]] call CBA_fnc_globalExecute;
			if (!msc_missionEnding) then {
				msc_missionEnding = true;
				publicVariable 'msc_missionEnding';
				[-1, {hint format['An extraction is commencing. The mission will end in approximately %1 minute(s).', round(_this / 60)];}, msc_timeToEnd] call CBA_fnc_globalExecute;
			};
		};
	};
";

['fmh_addFlexiButton', [
	'selfInteraction',
	"<t color='#ffc600'>Call Extraction</t>",
	_action,
	"main",
	true,
	_visible,
	"",
	"This will end the mission."
]] call CORE_fnc_callFunction;