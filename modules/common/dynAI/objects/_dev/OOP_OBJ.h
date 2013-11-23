/*
	This file is part of RBS (Realistic Battleground Simulator).

	Copyright © 2013 RBS Development Team.
	All rights reserved.

	RBS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	RBS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//////////////////////////////////////////////////////////////
//
//	Title: RBS Object Oriented SQF Scripting - Objects
//	--------------------------------------------------
//	File: OOP_OBJ.h
//	Author: Naught <dylanplecki@gmail.com>
//
//	Description:
//	Contains preprocessor definitions and macros for designing
//	and implementing object oriented code into the SQF
//	scripting language. Uses game logic objects.
//
//	Note:
//	All API documentation can be found below in the
//	<Interactive (API) Macros and Definitions> group.
//
//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
//  Group: Basic Macros
//////////////////////////////////////////////////////////////

#define QUOTE(var) #var
#define DOUBLES(var1,var2) ##var1##_##var2
#define TRIPLES(var1,var2,var3) ##var1##_##var2##_##var3
#define DEFAULT_PARAM(idx,dft) if ((count _this) > idx) then {_this select idx} else {dft}

//////////////////////////////////////////////////////////////
//  Group: Internal Defines
//////////////////////////////////////////////////////////////

#define INIT_POS [0,0,0]
#define CENTER_VAR cm_gvar_oopObjCenter
#define GROUP_VAR cm_gvar_oopObjGroup

//////////////////////////////////////////////////////////////
//  Group: Internal Macros
//////////////////////////////////////////////////////////////

#define CALL_CLASS(var1,className) var1 getVariable ['className',{nil}]
#define CALL_MISSION_CLASS(className) CALL_CLASS(missionNamespace,className)
#define VERIFY_CENTER if (isNil QUOTE(CENTER_VAR)) then {CENTER_VAR = createCenter sideLogic}
#define VERIFY_GROUP if (isNil QUOTE(GROUP_VAR)) then {GROUP_VAR = createGroup CENTER_VAR}
#define OBJ_INIT_CODE(className) DOUBLES(obj,className) = this
#define CLASS_INIT_CODE(className) className = {_this call (DOUBLES(obj,className) getVariable ['className',{nil}]);}
#define INSTANTIATE_CLASS(className) ("LOGIC" createUnit [INIT_POS, GROUP_VAR, "OBJ_INIT_CODE(className); CLASS_INIT_CODE(className);", 0])

//////////////////////////////////////////////////////////////
//  Group: Interactive (API) Macros and Definitions
//////////////////////////////////////////////////////////////

/*
	Macro: CLASS(className)
	Initializes a new class, or overwrites an existing one.
	Interaction with the class can be performed with the following code:
		["memberName", args] call ClassName;
	This code must be executed in the correct namespace, and will only have access to public members.
	
	Parameters:
		className - The name of the class [string].
	
	See Also:
		<CLASSEXTENDS>
*/
#define CLASS(className) VERIFY_CENTER; VERIFY_GROUP; INSTANTIATE_CLASS(className) call

/*
	Macro: CLASSEXTENDS(childClassName,parentClassName)
	Initializes a new class extending a parent class, or overwrites an existing class.
	Interaction with the class can be performed with the following code:
		["memberName", args] call ClassName;
	This code must be executed in the correct namespace, and will only have access to public members.
	
	Parameters:
		childClassName - The name of the child class [string].
		parentClassName - The name of the parent class [string].
	
	See Also:
		<CLASS>
*/
#define CLASSEXTENDS(childClassName,parentClassName) INSTANTIATE_CLASS(childClassName) default {CALLCLASS(parentClassName,_member,_args,1);};

/*
	Defines:
	- PRIVATE
		Initializes a private member within a class.
		Private members may only be accessed by members of its own class.
	- PROTECTED
		Initializes a protected member within a class.
		Protected members may only be accessed by members of its own class or child classes.
	- PRIVATE
		Initializes a public member within a class.
		Public members may be accessed by anyone.
*/
#define PRIVATE CHECK_ACCESS(2)
#define PROTECTED CHECK_ACCESS(1)
#define PUBLIC CHECK_ACCESS(0)

/*
	Macro: FUNCTION(typeStr,fncName)
	Initializes a new function member of a class.
	
	Parameters:
		typeStr - The typeName of the argument. Reference <http://community.bistudio.com/wiki/typeName> [string].
		fncName - The name of the function member [string].
	
	See Also:
		<VARIABLE>
*/
#define FUNCTION(typeStr,fncName) {CHECK_MEMBER(fncName)} && {CHECK_TYPE(typeStr)}):

/*
	Macro: VARIABLE(varName)
	Initializes a new variable member of a class. Due to the way SQF is coded,
	variables do not have specified typeNames and may represent any and all types of data.
	
	Parameters:
		varName - The name of the variable member [string].
	
	See Also:
		<FUNCTION>
*/
#define VARIABLE(varName) {CHECK_MEMBER(varName)}): {if (_in) then {NAMESPACE setVariable [GETVAR(varName), _args]} else {NAMESPACE getVariable [GETVAR(varName), nil]};}

/*
	Macro: MEMBER(memberStr,args)
	Calls a member function or gets/sets a member variable. This will only work on members
	of the current class. All class members (private, protected, public) can be accessed through this
	macro. All public and protected members of parent classes will be available while using this macro.
	If accessing a variable member, passing a nil argument will retrieve the variable while anything else
	will set the variable to the value of the argument.
	
	Parameters:
		memberStr - The name of the member function or variable [string].
		args - The arguments to be passed to the member function or variable [any].
*/
#define MEMBER(memberStr,args) CALLCLASS(_class,memberStr,args,2)

/*
	Define: ENDCLASS
	Ends a class's initializaton and finalizes SQF output.
*/
#define ENDCLASS };}]
