/* Optional Headless Client population manager. */
if (!isHeadlessClient) exitWith {false};
missionNamespace setVariable ['RHD_HCCivilianAgents',[]];
missionNamespace setVariable ['RHD_HCPopulationReady',true,true];
true
