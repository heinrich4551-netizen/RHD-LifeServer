class RHD_MenuActions {
    class F6 { title="RHD Civilian"; };
    class F7 { title="RHD Jobs"; };
    class F8 { title="RHD Services"; };
};

class RHD_MenuDialog {
    idd=8800;
    movingEnable=0;
    enableSimulation=1;

    class controlsBackground {
        class Background {
            idc=1000;
            type=0;
            style=0;
            x=0.30;
            y=0.16;
            w=0.40;
            h=0.68;
            text="";
            colorBackground[]={0,0,0,0.85};
            colorText[]={1,1,1,1};
            font="PuristaMedium";
            sizeEx=0.04;
        };
        class Header {
            idc=1001;
            type=0;
            style=2;
            x=0.32;
            y=0.18;
            w=0.36;
            h=0.06;
            text="RHD LIFE";
            colorBackground[]={0,0,0,0};
            colorText[]={1,1,1,1};
            font="PuristaMedium";
            sizeEx=0.04;
        };
    };

    class controls {
        class Action1 {
            idc=1601; type=1; style=2;
            x=0.34; y=0.27; w=0.32; h=0.065;
            text="Action 1";
            action="[0] call RHD_fnc_menuAction";
            font="PuristaMedium"; sizeEx=0.035;
        };
        class Action2 {
            idc=1602; type=1; style=2;
            x=0.34; y=0.345; w=0.32; h=0.065;
            text="Action 2";
            action="[1] call RHD_fnc_menuAction";
            font="PuristaMedium"; sizeEx=0.035;
        };
        class Action3 {
            idc=1603; type=1; style=2;
            x=0.34; y=0.420; w=0.32; h=0.065;
            text="Action 3";
            action="[2] call RHD_fnc_menuAction";
            font="PuristaMedium"; sizeEx=0.035;
        };
        class Action4 {
            idc=1604; type=1; style=2;
            x=0.34; y=0.495; w=0.32; h=0.065;
            text="Action 4";
            action="[3] call RHD_fnc_menuAction";
            font="PuristaMedium"; sizeEx=0.035;
        };
        class Action5 {
            idc=1605; type=1; style=2;
            x=0.34; y=0.570; w=0.32; h=0.065;
            text="Action 5";
            action="[4] call RHD_fnc_menuAction";
            font="PuristaMedium"; sizeEx=0.035;
        };
        class Action6 {
            idc=1606; type=1; style=2;
            x=0.34; y=0.645; w=0.32; h=0.065;
            text="Action 6";
            action="[5] call RHD_fnc_menuAction";
            font="PuristaMedium"; sizeEx=0.035;
        };
        class Close {
            idc=1607; type=1; style=2;
            x=0.34; y=0.720; w=0.32; h=0.065;
            text="Close";
            action="closeDialog 0";
            font="PuristaMedium"; sizeEx=0.035;
        };
    };
};
