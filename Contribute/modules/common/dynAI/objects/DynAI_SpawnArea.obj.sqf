#include "h\oop.h"

CLASS("DynAI_SpawnArea")
	
	PRIVATE VARIABLE("string","marker");
	PRIVATE VARIABLE("bool","enabled");
	PRIVATE VARIABLE("scalar","globalUnitLimit");
	PRIVATE VARIABLE("array","spawnGroups"); // [[side(, ["typeOfClass", ["randomly", "choose", "classes"], ...], groupLimitInt)], ...]
	PRIVATE VARIABLE("array","squads"); // Class type of "DynAI_CachedSquad"
	
	
	
ENDCLASS;