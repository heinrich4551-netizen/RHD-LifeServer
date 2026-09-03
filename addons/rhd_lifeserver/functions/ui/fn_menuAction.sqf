params ["_action"];
switch (_action) do {
    case 0: {hint "RHD: Move to a configured harvest zone and use the action menu to gather.";};
    case 1: {hint "RHD: Processing uses the upstream Altis Life ProcessAction configuration.";};
    case 2: {hint "RHD Jobs: Farming | Mining | Deliveries | Contracts | Businesses";};
    case 3: {hint "RHD Services: Vehicle Services | Licenses | Dispatch | Marketplace | Emergency Services";};
};
