{ config, ... }:

{
    homelab.system.dns = {
        enable = true;
        domain = config.homelab.domain;
        network = "192.168.2.0/24";

        records = {
            A = {
                # hosts
                feli = "192.168.2.5";
                marisa = "192.168.2.210";
                nixos-dev = "192.168.2.201";
                nixos-dev2 = "192.168.2.203";
                gay-hq = "192.168.2.10";
                
                # services
                "grocy.catwife.dev" = "192.168.2.210";
                "proxmox01.catwife.dev" = "192.168.2.13";
                "storage01.catwife.dev" = "192.168.2.14";
                "startpage.catwife.dev" = "192.168.2.210";
            };
        };
    };
}