
private ["_dictionary", "_groups"];

_dictionary		= call compile ('[' + (preProcessFile "modules\common\challengePass\dictionary.txt") + ']');
_groups			= ["WEST", "EAST", "setup_area_orange_1", "setup_area_orange_2"];