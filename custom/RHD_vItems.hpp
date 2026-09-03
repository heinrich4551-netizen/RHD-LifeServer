/*
    RHD-LifeServer virtual items.

    Include this file from the Altis Life mission's Config_vItems.hpp
    AFTER the upstream VirtualItems class begins, or include it as a
    separate config fragment containing the VirtualItems class extension.

    These classes are intentionally limited to items not supplied by the
    upstream Framework v5.X.X. Existing upstream items such as apple, peach,
    cannabis, iron_unrefined and copper_unrefined remain upstream-owned.
*/
class VirtualItems {
    class grape {
        variable = "grape";
        displayName = "Grapes";
        weight = 1;
        buyPrice = 60;
        sellPrice = 140;
        illegal = false;
        edible = 5;
        drinkable = -1;
        icon = "\A3\ui_f\data\igui\cfg\actions\gear_ca.paa";
    };

    class corn {
        variable = "corn";
        displayName = "Corn Cob";
        weight = 1;
        buyPrice = 45;
        sellPrice = 110;
        illegal = false;
        edible = 5;
        drinkable = -1;
        icon = "\A3\ui_f\data\igui\cfg\actions\gear_ca.paa";
    };

    class coca_leaf {
        variable = "cocaLeaf";
        displayName = "Coca Leaf";
        weight = 1;
        buyPrice = -1;
        sellPrice = 500;
        illegal = true;
        edible = -1;
        drinkable = -1;
        icon = "\A3\ui_f\data\igui\cfg\actions\gear_ca.paa";
    };

    class gold_ore {
        variable = "goldOre";
        displayName = "Gold Ore";
        weight = 6;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "\A3\ui_f\data\igui\cfg\actions\gear_ca.paa";
    };

    class gold {
        variable = "gold";
        displayName = "Gold";
        weight = 4;
        buyPrice = -1;
        sellPrice = 1500;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "\A3\ui_f\data\igui\cfg\actions\gear_ca.paa";
    };

    class oil_sand {
        variable = "oilSand";
        displayName = "Oil Sand";
        weight = 6;
        buyPrice = -1;
        sellPrice = -1;
        illegal = false;
        edible = -1;
        drinkable = -1;
        icon = "\A3\ui_f\data\igui\cfg\actions\gear_ca.paa";
    };
};
