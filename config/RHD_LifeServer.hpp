class RHD_LifeServer
{
    enabled = 1;
    serverName = "RHD LifeServer";
    map = "Altis";

    class Economy
    {
        enabled = 1;
        startingCash = 2500;
        startingBank = 5000;
        dynamicPricing = 1;
        priceUpdateMinutes = 15;
        priceFloorMultiplier = 0.65;
        priceCeilingMultiplier = 1.35;
        shopBuyMultiplier = 1.00;
        shopSellMultiplier = 0.80;
    };

    class Population
    {
        enabled = 1;
        civiliansAtOnePlayer = 115;
        minimumCivilians = 60;
        maximumCivilians = 115;
        scaleWithPlayers = 1;
        despawnDistance = 1200;
    };

    class Jobs
    {
        enabled = 1;
        legalJobs = 1;
        illegalJobs = 1;
        jobCooldownSeconds = 30;
    };

    class Factions
    {
        police = 1;
        medic = 1;
        civilian = 1;
        gangs = 1;
    };

    class Persistence
    {
        enabled = 1;
        saveIntervalMinutes = 5;
        backupIntervalMinutes = 30;
    };

    class Events
    {
        enabled = 1;
        randomEvents = 1;
        eventIntervalMinutes = 30;
    };
};
