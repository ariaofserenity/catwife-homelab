{ ... }:
{
    services.grocy = {
        enable = true;
        hostName = "nixos-dev";
        dataDir = "/var/lib/grocy";
        settings = {
            currency = "CAD";
        };
    };
}