class RHD_Resources {
    class Farming {
        enabled = 1;
        harvestCooldown = 12;
        class Apple { item = "apple"; min = 2; max = 6; process = "apple_juice"; };
        class Grapes { item = "grapes"; min = 2; max = 6; process = "wine"; };
        class Peaches { item = "peaches"; min = 2; max = 6; process = "peach_juice"; };
        class Corn { item = "corn"; min = 2; max = 8; process = "flour"; };
        class Cannabis { item = "cannabis"; min = 1; max = 4; process = "marijuana"; illegal = 1; };
        class Coca { item = "cocaleaf"; min = 1; max = 4; process = "cocaine"; illegal = 1; };
    };
    class Mining {
        enabled = 1;
        harvestCooldown = 18;
        class Iron { item = "ironore"; min = 2; max = 6; process = "iron"; };
        class Copper { item = "copperore"; min = 2; max = 6; process = "copper"; };
        class Gold { item = "goldore"; min = 1; max = 4; process = "gold"; };
        class Diamond { item = "diamond"; min = 1; max = 2; process = "cutdiamond"; };
        class OilSand { item = "oilsand"; min = 2; max = 6; process = "fuel"; };
    };
};
