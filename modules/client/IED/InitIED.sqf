// Script para IED
// Example for the IED obj init : x= [this,70,50,30,2,false,1,3] execVM "scripts\IED\InitIED.sqf";
// Parameters
// 1- IED ob
// 2- chance of beeing IED . 100 always IED, 0 ¿¿never?? xDD
// 3- Dificulty to disarm the bomb. 100 easy, 0 imposible
// 4- Actication radio. if x(parameter 7) soldiers or a vehicle are closer than this meters, the IED explodes
// 5 - Explosive power, from 1 to 7
// 6 - Always show the IED action even if it is not an IED. If false only the active IEDs will show the action to interact.
// 7 - Max number of soldiers that can come close to the IED before explode. For example if 1, only 1 soldier can go near the IED, if 2 or more are too close it will detonate.
// 8 - Random time delay for IED explosion.
// 9 - Side who activate the IEDs, default its west. Puede ser: 'west', 'east', 'resistance', 'civilian' (IMPORTATE, comillas INCLUIDAS)
//other example x= [this,50,30,50,2,false,1,5] execVM "scripts\IED\InitIED.sqf";
//50% of beeing IED, 30% of beeing disabled( well more or less :P), activation radio of 50m, if not IED it won't show any action,if 2 or more soldier or a vehicle come closer than 50 m it will detonate in 0-5 seconds.
//ther more x= [this,70,50,30,1,true,2,3] execVM "scripts\IED\InitIED.sqf";
//70% of beeing, 50%  of beeing disabled( well more or less :P) radio of 30m, minimum power(1), even if not ID it will show the action to examine, if 3 or more soldiers or a vehicle come too close it will detonate in 0-3 seconds.

private["_IED","_IED_ID", "_radius","_probaIED","_probaDes","_vehicle","_TypoExplosivo","_TypeExplosivo","_MostrarInactivos","_Tiempo","_bando","_Soldados","_Terrorista"];
_IED = _this select 0;
_probaIED = _this select 1;
_probaDes = _this select 2;
_radius = if ((count _this) > 3) then {_this select 3} else {20};
_TypoExplosivo=if ((count _this) > 4) then {_this select 4} else {-1};
_MostrarInactivos=if ((count _this) > 5) then {_this select 5} else {true};
_Soldados=if ((count _this) > 6) then {_this select 6} else {1};
_Tiempo=if ((count _this) > 7) then {_this select 7} else {4};
_bando=if ((count _this) > 8) then {_this select 8} else {'west'};
_Terrorista=if ((count _this) > 9) then {_this select 9} else {objnull};

_TypeExplosivo=switch (_TypoExplosivo) do {
	case 1 : {'R_57mm_HE'};
	case 2 : {'Bomb'};
	case 3 : {'ARTY_Sh_81_HE'};
	case 4 : {'ARTY_Sh_105_HE'};
	case 5 : {'ARTY_R_227mm_HE'}; 
	case 6 : {'BO_GBU12_LGB'};
	case 7 : {'Especial_De_La_Casa'};
	default {'R_57mm_HE'};
};



if (isnil 'IED_fn_IsVehicle') then {call compile preprocessFileLineNumbers "Scripts\IED\FuncionesIED.sqf"};

if (isnil "ListaIEDs") then {ListaIEDs = []};
_IED_ID= count ListaIEDs;
ListaIEDs= ListaIEDs +[_IED];

if (!isDedicated) then { [_IED,_probaDes,_MostrarInactivos] call IED_Anadir_Acciones};
if (!isServer) exitWith {};

if (_probaIED <(random 100)) exitWith {}; //its an IED or not, based on chance


// vehicles
if ([_IED] call IED_fn_IsVehicle) then
{
  _vehicle = _IED;
  
  if (!alive _vehicle) exitWith {};
  
  // detonate if engine is started
 call compile format['_vehicle addEventHandler ["engine", {if (side (driver (_this select 0)) == %1) then { [_this select 0] spawn IED_Detonar}}];',_bando];
};

//-----------------------------------------------------------------------------
// detonate if destroyed
_IED addEventHandler ["killed", { [_this select 0] spawn IED_Detonar }];

  // 35% chance of explosion on hit
_IED addEventHandler ["Hit", { if ((random 1) < 0.35) then {[_this select 0] spawn IED_Detonar}}];

//-----------------------------------------------------------------------------
// add trigger
_trig = createTrigger ["EmptyDetector", getPos _IED];


_condition = format["( ({([_x] call IED_fn_IsVehicle)&&(_x != (ListaIEDs select %1))&&(side _x == %3)&& (((getpos _x) select 2) < 3)} count thisList > 0)"+ 
    " || ({(side _x == %3)&& (((getpos _x) select 2) < 3)} count thisList > %2) )", _IED_ID,_Soldados,_bando]; 

_trig setTriggerArea [_radius, _radius, 0, false];

_trig setTriggerStatements [
  _condition,
  format["nul=[ListaIEDs select %1] spawn IED_Detonar_Trigg", _IED_ID],
  ""];
_trig setTriggerActivation ["ANY", "PRESENT", true]; 
_trig setTriggerType "SWITCH";
_trig setTriggerTimeout [0, _Tiempo/2, _Tiempo, false];

_trig attachTo [_IED,[0,0,0]]; //pegamos el triger al vehiculo :D

_IED setvariable ["IED_Activo", true,true];
_IED setvariable ["IED_Typo", _TypeExplosivo];
_IED setvariable ["IED_Trigger", _trig];
if (!isnull _Terrorista) then {
	_IED setvariable ["IED_Terrorista", _Terrorista];
	call compile format["_Terrorista addEventHandler ['killed', { 
	_trig = (ListaIEDs select %1) getvariable 'IED_Trigger';
	deletevehicle _trig }]", _IED_ID];
	
};
