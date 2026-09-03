/* RHD processing recipes. Include into the mission ProcessAction class. */
class ProcessAction {
    class rhd_coca {
        MaterialsReq[] = {{"coca_leaf",1}};
        MaterialsGive[] = {{"cocaine_processed",1}};
        Text = "Process Coca Leaf";
        NoLicenseCost = 1500;
    };

    class rhd_cannabis {
        MaterialsReq[] = {{"cannabis",1}};
        MaterialsGive[] = {{"marijuana",1}};
        Text = "Process Cannabis";
        NoLicenseCost = 500;
    };

    class rhd_gold {
        MaterialsReq[] = {{"gold_ore",1}};
        MaterialsGive[] = {{"gold",1}};
        Text = "Refine Gold Ore";
        NoLicenseCost = 1800;
    };

    class rhd_oil {
        MaterialsReq[] = {{"oil_sand",1}};
        MaterialsGive[] = {{"fuelFull",1}};
        Text = "Refine Oil Sand";
        NoLicenseCost = 1200;
    };
};
