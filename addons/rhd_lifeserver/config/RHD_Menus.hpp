class RHD_MenuActions { class F6 { title="RHD Civilian"; }; class F7 { title="RHD Jobs"; }; class F8 { title="RHD Services"; }; };
class RHD_MenuDialog {
    idd=8800; movingEnable=0; enableSimulation=1;
    class controlsBackground {
        class Background: RscText { idc=1000; x=0.30; y=0.16; w=0.40; h=0.68; colorBackground[]={0,0,0,0.85}; };
        class Header: RscText { idc=1001; x=0.32; y=0.18; w=0.36; h=0.06; text="RHD LIFE"; sizeEx=0.04; };
    };
    class controls {
        class Action1: RscButton { idc=1601; x=0.34; y=0.27; w=0.32; h=0.065; text="Action 1"; action="[0] call RHD_fnc_menuAction"; };
        class Action2: RscButton { idc=1602; x=0.34; y=0.345; w=0.32; h=0.065; text="Action 2"; action="[1] call RHD_fnc_menuAction"; };
        class Action3: RscButton { idc=1603; x=0.34; y=0.420; w=0.32; h=0.065; text="Action 3"; action="[2] call RHD_fnc_menuAction"; };
        class Action4: RscButton { idc=1604; x=0.34; y=0.495; w=0.32; h=0.065; text="Action 4"; action="[3] call RHD_fnc_menuAction"; };
        class Action5: RscButton { idc=1605; x=0.34; y=0.570; w=0.32; h=0.065; text="Action 5"; action="[4] call RHD_fnc_menuAction"; };
        class Action6: RscButton { idc=1606; x=0.34; y=0.645; w=0.32; h=0.065; text="Action 6"; action="[5] call RHD_fnc_menuAction"; };
        class Close: RscButton { idc=1607; x=0.34; y=0.720; w=0.32; h=0.065; text="Close"; action="closeDialog 0"; };
    };
};
