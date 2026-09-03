class RHD_MenuActions { class F6 { title="RHD Civilian"; }; class F7 { title="RHD Jobs"; }; class F8 { title="RHD Services"; }; };
class RHD_MenuDialog {
    idd=8800; movingEnable=0; enableSimulation=1;
    class controlsBackground {
        class Background: RscText { idc=1000; x=0.30; y=0.20; w=0.40; h=0.60; colorBackground[]={0,0,0,0.85}; };
        class Header: RscText { idc=1001; x=0.32; y=0.22; w=0.36; h=0.06; text="RHD LIFE"; sizeEx=0.04; };
    };
    class controls {
        class Action1: RscButton { idc=1601; x=0.34; y=0.31; w=0.32; h=0.07; text="Harvest Nearby Resource"; action="[0] call RHD_fnc_menuAction"; };
        class Action2: RscButton { idc=1602; x=0.34; y=0.40; w=0.32; h=0.07; text="Process Resources"; action="[1] call RHD_fnc_menuAction"; };
        class Action3: RscButton { idc=1603; x=0.34; y=0.49; w=0.32; h=0.07; text="Jobs / Contracts"; action="[2] call RHD_fnc_menuAction"; };
        class Action4: RscButton { idc=1604; x=0.34; y=0.58; w=0.32; h=0.07; text="Services / Marketplace"; action="[3] call RHD_fnc_menuAction"; };
        class Close: RscButton { idc=1605; x=0.34; y=0.68; w=0.32; h=0.07; text="Close"; action="closeDialog 0"; };
    };
};
