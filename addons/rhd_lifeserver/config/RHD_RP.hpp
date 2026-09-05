class RHD_RP {
    enabled = 1;
    dispatch = 1;
    evidence = 1;
    warrants = 1;
    impounds = 1;
    businesses = 1;
    licenses = 1;
    vehicleServices = 1;
    courts = 1;
    government = 1;
    taxesEnabled = 1;
    phone = 1;
    marketplace = 1;
    serviceRequests = 1;
    hospitalBilling = 1;

    class Fees {
        treatment = 500;
        impoundRelease = 500;
        inspection = 100;
        repair = 750;
        oil = 250;
        tires = 500;
        full = 1500;
        businessStartup = 25000;
    };

    class Taxes {
        enabled = 1;
        salesRate = 0.05;
        businessRate = 0.10;
        incomeRate = 0.10;
        transactionMinimum = 0;
        minimumCharge = 1;
        intervalMinutes = 30;
    };
};
