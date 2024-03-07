## Retrieve a list of DNS Records

This example shows how you can retrieve a list of DNS Records from a specific zone and return only desired fields.
```powershell
PS> Get-B1Record -Zone my.zone -Fields absolute_name_spec,type,dns_rdata | ft -AutoSize

absolute_name_spec     type dns_rdata                                                         id
------------------     ---- ---------                                                         --
my.zone.               NS   ns.b1ddi.my.zone.                                                 dns/record/fdshjffg-a234-ea07-ie15-mv9d87fr3nd9
my.zone.               NS   b101.my.zone.                                                     dns/record/jsiifsnf-b345-fb29-jc05-nz33stgfhfgb
my.zone.               NS   b102.my.zone.                                                     dns/record/fgghjuli-c567-g641-k1cd-oggh65u567ug
my.zone.               SOA  ns.b1ddi.my.zone. hostmaster.my.zone. 14 10800 3600 2419200 900   dns/record/bbvkolpi-d678-hf24-lfdd-pfert4t5y56d
my.zone.               A    10.10.10.100                                                      dns/record/sf5g45gr-gdfg-dfgf-y5hv-gfdreg5gdhyj
...
```

This example shows how you can retrieve a list of 1000 DNS Records with pagination.
```powershell
PS> Get-B1Record -Limit 1000 -Offset 1000 | ft -AutoSize

type  absolute_name_spec           absolute_zone_name        comment       created_at           delegation disabled dns_absolute_name_spec      dns_name_in_zone dns_rdata
----  ------------------           ------------------        -------       ----------           ---------- -------- ----------------------      ---------------- ---------
NS    my.home.                     my.home.                  NS Record     6/12/2021 12:53:39AM               False my.home.                                     ns.b1ddi.my.home.                                              
SOA   my.home.                     my.home.                  SOA Record    9/7/2020 3:30:11PM                 False my.home.                                     ns.b1ddi.my.home. hostmaster.my.home. 11 10800 3600 2419200 900
SOA   public.com.                  public.com.               SOA Record    9/3/2022 9:18:34AM                 False public.com.                                  a.ns.public.com. ns1.public.com. 2015065715 1800 1800 2592000 900
A     Mats-iPhone.my.home.         my.home.                  My iPhone     8/1/2021 11:05:50AM                False Mats-iPhone.my.home.         Mats-iPhone     192.168.1.54
CNAME friendlyname.my.home.        my.home.                                6/12/2021 12:53:42AM               False friendlyname.my.home.                        webserver.my.home.
...
```