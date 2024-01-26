/interface bridge
add name=bridge1 port-cost-mode=short
/interface ethernet
set [ find default-name=ether1 ] advertise="10M-baseT-half,10M-baseT-full,100M\
    -baseT-half,100M-baseT-full,1G-baseT-half,1G-baseT-full" comment=wan \
    mac-address=48:A9:8A:D3:C0:45
set [ find default-name=ether2 ] comment=lan mac-address=48:A9:8A:D3:C0:46
set [ find default-name=ether3 ] comment=otros mac-address=48:A9:8A:D3:C0:47
set [ find default-name=ether4 ] mac-address=48:A9:8A:D3:C0:48
set [ find default-name=ether5 ] mac-address=48:A9:8A:D3:C0:49
/interface wifi
add configuration.mode=ap .ssid=wifi_5 disabled=no radio-mac=\
    48:A9:8A:D3:C0:4A security.authentication-types=\
    wpa2-psk,wpa2-eap,wpa3-psk,wpa3-eap
add radio-mac=48:A9:8A:BD:FC:6A
add configuration.mode=ap radio-mac=48:A9:8A:D3:C0:4B
add channel.band=2ghz-g configuration.country=Venezuela .mode=ap .ssid=\
    wifi_2_4 disabled=no radio-mac=48:A9:8A:BD:FC:6B \
    security.authentication-types=wpa2-psk,wpa3-psk
set [ find default-name=wifi2 ] configuration.mode=ap .ssid=wifi_2_4 \
    disabled=no
/interface ovpn-client
add auth=sha256 certificate=cert_ovpn-import1706219415 cipher=aes256-cbc \
    connect-to=87-1-ve.cg-dialup.net mac-address=FE:FC:AD:DF:D5:D4 name=ovpn \
    port=443 protocol=udp route-nopull=yes user=eVBLrCqPzF \
    verify-server-certificate=yes

/interface wireguard
add comment=back-to-home-vpn listen-port=58424 mtu=1420 name=back-to-home-vpn
/interface list
add name=WAN
add name=LAN
/ip hotspot profile
add dns-name=wifi.com hotspot-address=192.168.20.1 login-by=\
    cookie,http-chap,http-pap,mac-cookie name=hsprof1 split-user-domain=yes
/ip pool
add name=dhcp ranges=192.168.20.10-192.168.20.254
add name=vpn ranges=192.168.89.2-192.168.89.255
/ip dhcp-server
add address-pool=dhcp interface=bridge1 name=dhcp1
/ip hotspot
add address-pool=dhcp disabled=no interface=bridge1 name=hotspot1 profile=\
    hsprof1
/ip hotspot user profile
add address-pool=dhcp mac-cookie-timeout=1d name="profile_Nuevo plan-se:hotspo\
    t1-co:1.0-pr:1-lu:5-lp:5-ut:1d-00:00:00-bt:0-kt:true-nu:true-np:true-tp:1" \
    on-login="{local voucher \$user; :if ([/system scheduler find name=\$vouch\
    er]=\"\") do={/system scheduler add comment=\$voucher name=\$voucher inter\
    val=1d on-event=\"/ip hotspot active remove [find user=\$voucher]\r\
    \n/ip hotspot user remove [find name=\$voucher]\r\
    \n/system schedule remove [find name=\$voucher]\"}}" transparent-proxy=\
    yes
/ppp profile
add address-list=BANCOS incoming-filter=input interface-list=LAN name=bancos \
    outgoing-filter=output
set *FFFFFFFE local-address=192.168.89.1 remote-address=vpn
/queue type
set 9 kind=sfq
/routing table
add disabled=no name=to_vpn
/certificate settings
set crl-store=system
/interface bridge port
add bridge=bridge1 interface=ether2 internal-path-cost=10 path-cost=10
add bridge=bridge1 interface=ether3 internal-path-cost=10 path-cost=10
add bridge=bridge1 interface=ether4 internal-path-cost=10 path-cost=10
add bridge=bridge1 interface=ether5 internal-path-cost=10 path-cost=10
add bridge=bridge1 interface=wifi1 internal-path-cost=10 path-cost=10
add bridge=bridge1 interface=wifi2 internal-path-cost=10 path-cost=10
add bridge=bridge1 interface=wifi2 internal-path-cost=10 path-cost=10
/ip neighbor discovery-settings
set discover-interface-list=all
/interface detect-internet
set detect-interface-list=all
/interface l2tp-server server
set use-ipsec=yes
/interface list member
add interface=ether1 list=WAN
add interface=bridge1 list=LAN
/interface wireguard peers
add allowed-address=192.168.216.3/32 comment=\
    "M-tickets-2023 (iPhone 11 Pro Max)" interface=*C public-key=\
    "uZ/4NMH406mKF+/lN/7/dTeAN35fplbZSpnIK61sgQk="
add allowed-address=192.168.216.4/32 comment=\
    "M-tickets-2023 (iPhone 11 Pro Max)" interface=*C public-key=\
    "Au/XV1Bnf3bxZMr+jyASQbniWxJp6P0xWjMGmN+eEHw="
add allowed-address=192.168.216.3/32 comment=\
    "cb1 (iPad Pro (12.9-inch) (3rd generation))" interface=back-to-home-vpn \
    public-key="j0hsWXh5SFnD24uLfnTRK/5jiw55tzxn5jqnM7jXfxE="
/ip address
add address=192.168.20.5/24 interface=bridge1 network=192.168.20.0
/ip cloud
set back-to-home-vpn=enabled ddns-enabled=yes
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=0.0.0.0/24 dns-server=0.0.0.0 gateway=0.0.0.0 netmask=24
add address=192.168.20.0/24 dns-server=192.168.20.5 gateway=192.168.20.5 \
    netmask=24
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall address-list
add address=www.banesco.com list=BANCOS
add address=3.5.0.0/24 comment=Banesco list=BANCOS
add address=3.5.1.0/24 comment=Banesco list=BANCOS
add address=3.5.2.0/24 comment=Banesco list=BANCOS
add address=3.5.3.0/24 comment=Banesco list=BANCOS
add address=3.5.6.0/24 comment=Banesco list=BANCOS
add address=3.5.7.0/24 comment=Banesco list=BANCOS
add address=3.5.8.0/24 comment=Banesco list=BANCOS
add address=3.5.9.0/24 comment=Banesco list=BANCOS
add address=3.5.10.0/24 comment=Banesco list=BANCOS
add address=3.5.11.0/24 comment=Banesco list=BANCOS
add address=3.5.16.0/24 comment=Banesco list=BANCOS
add address=3.5.17.0/24 comment=Banesco list=BANCOS
add address=3.5.19.0/24 comment=Banesco list=BANCOS
add address=3.5.20.0/24 comment=Banesco list=BANCOS
add address=3.5.24.0/24 comment=Banesco list=BANCOS
add address=3.5.25.0/24 comment=Banesco list=BANCOS
add address=3.5.27.0/24 comment=Banesco list=BANCOS
add address=3.5.28.0/24 comment=Banesco list=BANCOS
add address=3.5.29.0/24 comment=Banesco list=BANCOS
add address=3.5.29.167 comment="Banesco App y Pago Movil" list=BANCOS
add address=www.banesconline.com comment=www.banesconline.com list=BANCOS
add address=www.bancodevenezuela.com list=BANCOS
add address=bdvenlineaempresas.banvenez.com list=BANCOS
add address=bdvenlinea.banvenez.com list=BANCOS
add address=186.24.10.0/24 comment="Bicentenario Plataforma Nueva" list=\
    BANCOS
add address=104.198.220.53 comment=Flexipos list=BANCOS
add address=200.109.231.0/24 comment=Credicard list=BANCOS
add address=45.179.13.42 comment="Venezuela Modelo Nuevo" list=BANCOS
add address=www.bancocaroni.com.ve list=BANCOS
add address=186.24.6.206 comment="Platco Inalambrico" list=BANCOS
add address=www.patria.org.ve list=BANCOS
add address=persona.patria.org.ve list=BANCOS
add address=www.banfanb.com.ve list=BANCOS
add address=banfanbenlinea.banfanb.com.ve list=BANCOS
add address=www.provincial.com list=BANCOS
add address=www.tsj.gob.ve list=BANCOS
add address=190.202.148.187 list=BANCOS
add address=www.biopagobdv.com list=BANCOS
add address=www.payall.com.ve list=BANCOS
add address=ucs.gob.ve list=BANCOS
add address=sigae.ucs.gob.ve list=BANCOS
add address=190.202.14.195 list=BANCOS
add address=190.202.57.0/24 comment="Bicentenario Plataforma Vieja" list=\
    BANCOS
add address=190.202.89.0/24 list=BANCOS
add address=20.119.0.20 comment="Simple Tv" list=BANCOS
add address=159.138.8.5 comment="Venezuela Modelo Nuevo" list=BANCOS
add address=192.168.98.0/24 comment="CPU CENTER" list=BANCOS
add address=200.74.197.118 comment=RAPIDPAGO list=BANCOS
add address=200.74.192.122 list=BANCOS
add address=200.6.27.0/24 comment="Banesco App y Pago Movil" list=BANCOS
add address=201.222.13.4 comment="Platco Plataforma Libre" list=BANCOS
add address=190.217.13.58 comment=intt list=BANCOS
add address=190.202.82.66 comment=intt list=BANCOS
add address=142.250.217.0/24 comment=Gmail list=BANCOS
add address=200.11.221.0/24 list=BANCOS
add address=declaraciones.seniat.gob.ve comment="Portal Seniat" list=BANCOS
add address=www.mercantilbanco.com comment=www.mercantilbanco.com list=BANCOS
add address=www30.mercantilbanco.com comment=www30.mercantilbanco.com list=\
    BANCOS
add address=seniat.gob.ve comment=seniat.gob.ve list=BANCOS
add address=190.202.2.0/24 comment=contribuyente.seniat.gob.ve list=BANCOS
add address=sni.opsu.gob.ve list=BANCOS
add address=autogestionrrhh.me.gob.ve comment=autogestionrrhh.me.gob.ve list=\
    BANCOS
add address=200.11.144.25 comment=CNE list=BANCOS
add address=www.cne.gob.ve comment=www.cne.gob.ve list=BANCOS
add address=sisap.apure.gob.ve comment=sisap.apure.gob.ve list=BANCOS
add address=www.saren.gob.ve comment=www.saren.gob.ve list=BANCOS
add address=190.121.229.137 comment=BNC list=BANCOS
add address=contribuyente.seniat.gob.ve comment=\
    "Seniat Contribuyente Personas" list=BANCOS
add address=200.74.201.0/24 comment="Banco del Sur" list=BANCOS
add address=intt.gob.ve list=BANCOS
add address=plus.simple.com.ve comment=plus.simple.com.ve list=BANCOS
add address=23.9.54.49 comment=www.bbvaprovinet.provincial.com list=BANCOS
add address=www.bicentenariobu.com.ve comment=www.bicentenariobu.com.ve list=\
    BANCOS
add address=23.194.250.107 comment=Provincial list=BANCOS
add address=104.91.133.176 list=BANCOS
add address=10.0.16.0/24 list=BANCOS
add address=10.0.20.0/24 list=BANCOS
add address=137.1.1.0/24 list=BANCOS
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=accept chain=input protocol=icmp
add action=accept chain=input connection-state=established
add action=accept chain=input connection-state=related
add action=accept chain=input comment="allow IPsec NAT" dst-port=4500 \
    protocol=udp
add action=accept chain=input comment="allow IKE" dst-port=500 protocol=udp
add action=accept chain=input comment="allow l2tp" dst-port=1701 protocol=udp
add action=drop chain=input disabled=yes in-interface-list=!LAN
add action=accept chain=input dst-port=21 protocol=tcp
add action=accept chain=input dst-port=21 protocol=tcp
add action=accept chain=input dst-port=21 protocol=tcp
/ip firewall mangle
add action=mark-routing chain=prerouting dst-address-list=BANCOS \
    new-routing-mark=*400 passthrough=no
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment=\
    "ip sec policy trafico dchcp a starlink" ipsec-policy=out,none \
    out-interface-list=WAN
add action=masquerade chain=srcnat out-interface=all-ppp
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.20.0/24
add action=masquerade chain=srcnat comment="masq. vpn traffic" src-address=\
    192.168.89.0/24
/ip hotspot user
add name=a
add name=admin
add name=A
add comment="Creado desde StarTickera | 25-01-2024 15:43:11" limit-uptime=1d \
    name=hdapq profile="profile_Nuevo plan-se:hotspot1-co:1.0-pr:1-lu:5-lp:5-u\
    t:1d-00:00:00-bt:0-kt:true-nu:true-np:true-tp:1" server=hotspot1
/ip hotspot walled-garden
add comment="place hotspot rules here" disabled=yes
/ip hotspot walled-garden ip
add action=accept disabled=no dst-address=192.168.20.5 !dst-address-list \
    dst-port=0-65535 protocol=tcp server=hotspot1 !src-address \
    !src-address-list
add action=accept disabled=no !dst-address !dst-address-list dst-host=\
    eitol.github.io dst-port=0-65535 protocol=tcp server=hotspot1 \
    !src-address !src-address-list
add action=accept disabled=no !dst-address !dst-address-list dst-host=arc.io \
    dst-port=0-65535 protocol=tcp server=hotspot1 !src-address \
    !src-address-list
add action=accept disabled=no !dst-address !dst-address-list dst-host=\
    tkr.arc.io dst-port=0-65535 protocol=tcp server=hotspot1 !src-address \
    !src-address-list
add action=accept disabled=no !dst-address !dst-address-list dst-host=\
    static.arc.io dst-port=0-65535 protocol=tcp server=hotspot1 !src-address \
    !src-address-list
add action=accept disabled=no !dst-address !dst-address-list dst-host=\
    google-analytics.com dst-port=0-65535 protocol=tcp server=hotspot1 \
    !src-address !src-address-list
add action=accept disabled=no !dst-address !dst-address-list dst-host=\
    warden.arc.io dst-port=0-65535 protocol=tcp server=hotspot1 !src-address \
    !src-address-list
add action=accept disabled=no !dst-address !dst-address-list dst-host=\
    browser.sentry-cdn.com dst-port=0-65535 protocol=tcp server=hotspot1 \
    !src-address !src-address-list
add action=accept disabled=no !dst-address !dst-address-list dst-host=\
    wss://tkr.arc.io dst-port=0-65535 protocol=tcp !src-address \
    !src-address-list
/ip proxy access
add action=deny dst-host=connectivitycheck.gstatic.com
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=ovpn routing-table=\
    to_vpn suppress-hw-offload=no
/ip service
set www-ssl certificate=*7 disabled=no
/ppp secret
add name=vpn
/routing rule
add action=lookup disabled=no dst-address=::/0 interface=ether2 routing-mark=\
    *400 src-address=::/0 table=*400
/system clock
set time-zone-name=America/New_York
/system identity
set name=M-tickets-2023
/system note
set show-at-login=no
/system scheduler
add comment="Added by Back To Home application to remove shared WireGuard peer\
    \_after its expiration date" interval=2635w58m41s name=\
    "autoremove_Au/XV1Bnf3bxZMr+jyASQbniWxJp6P0xWjMGmN+eEHw=" on-event="# The \
    scheduler script has been added by Back To Home application to remove shar\
    ed WireGuard peer after its expiration date.\
    \n/interface/wireguard/peers remove [find public-key=\"Au/XV1Bnf3bxZMr+jyA\
    SQbniWxJp6P0xWjMGmN+eEHw=\"]\
    \n/system/scheduler/ remove [find name=\"autoremove_Au/XV1Bnf3bxZMr+jyASQb\
    niWxJp6P0xWjMGmN+eEHw=\"]\
    \n" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-12-13 start-time=08:28:19
add interval=1h name=mkt_sc_core_user_1 on-event=mkt_sp_core_2 policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add disabled=yes interval=1m name=schedule1 on-event=\
    "/ip hotspot user remove [find where uptime<=limit-uptime]" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-12-14 start-time=18:47:42
/system script
add dont-require-permissions=no name=mkt_sp_core_2 owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="{\
    \_ :local Cris09nIpuQAso [ /system clock get date ];  :local 5uCheyl3rEQAs\
    o [ /system clock get time ];  :local crU7ipHubunoj5 (\$Cris09nIpuQAso . \
    \" \" . \$5uCheyl3rEQAso);  :foreach rAH1wRe2lGaJOs in [ /ip hotspot user \
    find where disabled=no comment~\"-da:\"] do={ :do { :local q1KUvi2rUpRaDr \
    [ /ip hotspot user get \$rAH1wRe2lGaJOs comment ]; :local name [ /ip hotsp\
    ot user get \$rAH1wRe2lGaJOs name ]; :local posDatetime ([ :find \$q1KUvi2\
    rUpRaDr \"da:\"]); :if ( [ :typeof \$posDatetime ] != \"nil\") do={  :loca\
    l posType ([ :find \$q1KUvi2rUpRaDr \"tp:\"]); :if ( [ :typeof \$posType ]\
    \_!= \"nil\") do={  :set posType (\$posType + 3);  :local type [:pick \$q1\
    KUvi2rUpRaDr \$posType (\$posType + 1)]; :if ( \$type = 2 ) do={  :local p\
    osStart (\$posDatetime + 3);  :local pRobRAhOj5vAfE [:pick \$q1KUvi2rUpRaD\
    r \$posStart (\$posStart + 20)]; :local date1 \$pRobRAhOj5vAfE; :local dat\
    e2 \$crU7ipHubunoj5; :local date1month [:pick \$date1 0 3]; :local date1da\
    y [:pick \$date1 4 6]; :local date1year [:pick \$date1 7 11]; :local date1\
    hours [:pick \$date1 12 14]; :local date1minutes [:pick \$date1 15 17]; :l\
    ocal date1seconds [:pick \$date1 18 20]; :local date2month [:pick \$date2 \
    0 3]; :local date2day [:pick \$date2 4 6]; :local date2year [:pick \$date2\
    \_7 11]; :local date2hours [:pick \$date2 12 14]; :local date2minutes [:pi\
    ck \$date2 15 17]; :local date2seconds [:pick \$date2 18 20]; :local month\
    s (\"jan\",\"feb\",\"mar\",\"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\"\
    ,\"oct\",\"nov\",\"dec\"); :set date1month ([:find \$months \$date1month -\
    1 ] + 1); :set date2month ([:find \$months \$date2month -1 ] + 1); :local \
    globalDiff; :local yearDiff (\$date2year - \$date1year); :local monthDiff \
    (\$date2month - \$date1month); :local dayDiff (\$date2day - \$date1day); :\
    local hoursDiff (\$date2hours - \$date1hours); :local minutesDiff (\$date2\
    minutes - \$date1minutes); :local secondsDiff (\$date2seconds - \$date1sec\
    onds); :local secondsGlobalDiff; :set secondsGlobalDiff ((\$dayDiff * 8640\
    0) + (\$hoursDiff * 3600) + (\$minutesDiff *60) + \$secondsDiff); :set day\
    Diff (\$secondsGlobalDiff / 86400); :set secondsGlobalDiff (\$secondsGloba\
    lDiff - (\$dayDiff * 86400)); :set hoursDiff (\$secondsGlobalDiff / 3600);\
    \_:set secondsGlobalDiff (\$secondsGlobalDiff - (\$hoursDiff * 3600)); :se\
    t minutesDiff (\$secondsGlobalDiff / 60); :set secondsGlobalDiff (\$second\
    sGlobalDiff - (\$minutesDiff * 60)); :set secondsDiff \$secondsGlobalDiff;\
    \_if (\$yearDiff < 0) do={ } else={  if (\$yearDiff = 0) do={  if (\$month\
    Diff <0) do={  } else={ if (\$monthDiff = 0) do={ if (\$dayDiff < 0) do={ \
    } else={ if (\$dayDiff = 0) do={ if (\$hoursDiff < 0) do={ } else={ if (\$\
    hoursDiff = 0) do={  if (\$minutesDiff < 0) do={  } else={  if (\$minutesD\
    iff = 0) do={ if (\$secondsDiff < 0) do={ };  };  }; }; }; }; }; };  };  }\
    ; }; :local isYear1Leap 0; :local isYear2Leap 0; if (((\$date1year / 4) * \
    4) = \$date1year) do={  :set isYear1Leap 1; }; if (((\$date2year / 4) * 4)\
    \_= \$date2year) do={;  :set isYear2Leap 1; }; :if (\$hoursDiff < 0) do={ \
    :set hoursDiff (\$hoursDiff * -1); }; :if (\$minutesDiff < 0) do={ :set mi\
    nutesDiff (\$minutesDiff * -1); }; :if (\$secondsDiff < 0) do={ :set secon\
    dsDiff (\$secondsDiff * -1); }; :local daysInEachMonth (\"31\",\"28\",\"31\
    \",\"30\",\"31\",\"30\",\"31\",\"31\",\"30\",\"31\",\"30\",\"31\"); :local\
    \_daysInEachMonthLeapYear (\"31\",\"29\",\"31\",\"30\",\"31\",\"30\",\"31\
    \",\"31\",\"30\",\"31\",\"30\",\"31\"); :local totalDaysBetweenMonths; if \
    (\$yearDiff = 0 and \$monthDiff >= 1) do={  if (\$isYear1Leap = 0) do={  f\
    or month from=(\$date1month - 1) to=((\$date2month - 1) - 1) step=1 do={ :\
    set totalDaysBetweenMonths (\$totalDaysBetweenMonths + [:pick \$daysInEach\
    Month \$month]);  };  };  if (\$isYear1Leap = 1) do={  for month from=(\$d\
    ate1month - 1) to=((\$date2month - 1) - 1) step=1 do={ :set totalDaysBetwe\
    enMonths (\$totalDaysBetweenMonths + [:pick \$daysInEachMonthLeapYear \$mo\
    nth]);  };  }; }; :local daysInEachMonthConcatenatedYears; if (\$yearDiff \
    >= 1) do={  for year from=\$date1year to=\$date2year step=1 do={  if (((\$\
    year / 4) * 4) = \$year) do={ :set daysInEachMonthConcatenatedYears (\$day\
    sInEachMonthConcatenatedYears, \$daysInEachMonthLeapYear);  } else={ :set \
    daysInEachMonthConcatenatedYears (\$daysInEachMonthConcatenatedYears, \$da\
    ysInEachMonth);  }; };  for month from=(\$date1month - 1) to=((\$date2mont\
    h - 1)+ ((\$yearDiff * 12) - 1)) step=1 do={  :set totalDaysBetweenMonths \
    (\$totalDaysBetweenMonths + [:pick \$daysInEachMonthConcatenatedYears \$mo\
    nth]);  }; }; :local globalDaysDiff (\$totalDaysBetweenMonths + \$dayDiff)\
    ; :if (\$hoursDiff < 10) do={  :set hoursDiff (\"0\" . \$hoursDiff); }; :i\
    f (\$minutesDiff < 10) do={  :set minutesDiff (\"0\" . \$minutesDiff); }; \
    :if (\$secondsDiff < 10) do={  :set secondsDiff (\"0\" . \$secondsDiff); }\
    ; :set globalDiff (\$globalDaysDiff . \"d\$hoursDiff:\$minutesDiff:\$secon\
    dsDiff\"); :local posDay ([ :find \$globalDiff \"d\"]); :local dateDiffDay\
    \_[:pick \$globalDiff 0 (\$posDay)]; :local posTime (\$posDay +1); :local \
    dateDiffHours [:pick \$globalDiff \$posTime (\$posTime + 2)]; :local dateD\
    iffMinutes [:pick \$globalDiff (\$posTime + 3) (\$posTime + 5)]; :local da\
    teDiffSeconds [:pick \$globalDiff (\$posTime + 6) (\$posTime + 8)]; :local\
    \_totalSecondsDateDiff; :set totalSecondsDateDiff ((\$dateDiffDay * 86400)\
    \_+ (\$dateDiffHours * 3600) + (\$dateDiffMinutes * 60) + \$dateDiffSecond\
    s); :local limitUptime [ /ip hotspot user get \$rAH1wRe2lGaJOs limit-uptim\
    e ]; :if ( [ :typeof \$limitUptime ] != \"nil\") do={ :local posDays ([ :f\
    ind \$limitUptime \"d\"]); :local posWeeks ([ :find \$limitUptime \"w\"]);\
    \_:local days 0; :local posTime 0; :if ( [ :typeof \$posDays ] != \"nil\" \
    && [ :typeof \$posWeeks ] != \"nil\") do={ :local numWeeks [:pick \$limitU\
    ptime 0 \$posWeeks]; :local numDays [:pick \$limitUptime (\$posWeeks+1) \$\
    posDays]; :set days ((\$numWeeks*7) + \$numDays); :set posTime (\$posDays \
    +1);  } else={ :if ( [ :typeof \$posDays ] != \"nil\") do={ :set days [:pi\
    ck \$limitUptime 0 \$posDays]; :set posTime (\$posDays +1); } else={ :if (\
    \_[ :typeof \$posWeeks ] != \"nil\") do={ :local numWeeks [:pick \$limitUp\
    time 0 \$posWeeks]; :set days ((\$numWeeks*7) + \$numDays); :set posTime (\
    \$posWeeks +1); }; }; }; :local hours [:pick \$limitUptime \$posTime (\$po\
    sTime + 2)]; :local minutes [:pick \$limitUptime (\$posTime + 3) (\$posTim\
    e + 5)]; :local seconds [:pick \$limitUptime (\$posTime + 6) (\$posTime + \
    8)]; :local totalSecondsUptime ((\$days * 86400) + (\$hours * 3600) + (\$m\
    inutes * 60) + \$seconds);  :if (\$totalSecondsDateDiff >= \$totalSecondsU\
    ptime) do={ [ /ip hotspot user remove \$rAH1wRe2lGaJOs ]; [ /ip hotspot ac\
    tive remove [find where user=\$name] ]; [ /ip hotspot cookie remove [find \
    where user=\$name] ]; }; }; }; }; }; } on-error={ }; }; }; "
add dont-require-permissions=no name=mkt_sp_login_1 owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="{\
    \_:local P6oHA7pLvicrO8ub2fa2 [/ip hotspot user get \$user comment]; :loca\
    l t1x3SUqugohIpoc4o3En ([:find \$P6oHA7pLvicrO8ub2fa2 \"Mikroticket\"]);  \
    :if ([:typeof \$t1x3SUqugohIpoc4o3En]!=\"nil\") do={  :local BuPRup63sWlju\
    fuZa4rE ([ :find \$P6oHA7pLvicrO8ub2fa2 \"-da\"]);  :if ([:typeof \$BuPRup\
    63sWljufuZa4rE]=\"nil\") do={ :local St92heguPowumastumlw [/system clock g\
    et date]; :local SpipHeb5xis0iBr4gevu [/system clock get time]; :local is0\
    iBr4gevu \$\"mac-address\"; [/ip hotspot user set \$user comment=(\$P6oHA7\
    pLvicrO8ub2fa2 . \"-da:\" . \$St92heguPowumastumlw . \" \" . \$SpipHeb5xis\
    0iBr4gevu . \"-mc:\" . \$is0iBr4gevu)];  :local serial [/system routerboar\
    d get serial-number];  :local dateAct (\$St92heguPowumastumlw . \" \" . \$\
    SpipHeb5xis0iBr4gevu);  :local url https://fcm.googleapis.com/fcm/send; :l\
    ocal headers \"Authorization:key=AAAAhbL_5Zo:APA91bE5V5EPAnUsD7FNNOqeEIQ9K\
    UTkLTfADIeC-M-m10vEn4jsKAR8Lzsgcp2iZqZeQf3Ij0bFZPzXbgLRt7XxEBVCDV-FgQivVhC\
    1cXHwYZ_rtOQGRM5oxgVHVRxiNx4djBBRkIQR,Content-Type:application/json\";  :l\
    ocal data \"{\\\"registration_ids\\\":[\\\"cL5xOtQzSeCuAQarsqrZ53:APA91bEv\
    Xti-MxPJsRts76Uhk_8voTK3d-DuFbDUQPOx6zesiClNiZlSp55s824hVyTmygzfO2A7SlKVyU\
    7ZSUKqynZpVm4OvvgnpwEvPl0IPy56YCROgCFIrieNugfHXUPig4E7FV4R\\\"],\\\"data\\\
    \":{\\\"TITLE\\\":\\\"MikroTicket\\\",\\\"USER\\\":\\\"\$username\\\",\\\"\
    DATE\\\":\\\"\$dateAct\\\",\\\"TYPE\\\":\\\"MIKROTIK_ONLOGIN\\\",\\\"ROUTE\
    R_SERIAL\\\":\\\"\$serial\\\",\\\"MAC\\\":\\\"\$is0iBr4gevu\\\"}}\";  :do \
    {  /tool fetch url=\$url http-method=post http-data=\$data http-header-fie\
    ld=\$headers keep-result=no;  :log info \"Fetch OK\";  } on-error={ :log i\
    nfo \"Fetch ERROR\"};  }}}"
add dont-require-permissions=no name=test-date-format owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="{\
    \r\
    \n  :local DATE [/system clock get date];\r\
    \n  :log info \$DATE;\r\
    \n}"
add dont-require-permissions=no name=bancos owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="{\
    \r\
    \n    /ip firewall address-list\r\
    \n    add address=www.banesco.com list=BANCOS\r\
    \n    add address=3.5.0.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.1.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.2.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.3.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.6.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.7.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.8.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.9.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.10.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.11.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.16.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.17.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.19.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.20.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.24.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.25.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.27.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.28.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.29.0/24 comment=Banesco list=BANCOS\r\
    \n    add address=3.5.29.167 comment=\"Banesco App y Pago Movil\" list=BAN\
    COS\r\
    \n    add address=www.banesconline.com comment=www.banesconline.com list=B\
    ANCOS\r\
    \n    add address=www.bancodevenezuela.com list=BANCOS\r\
    \n    add address=bdvenlineaempresas.banvenez.com list=BANCOS\r\
    \n    add address=bdvenlinea.banvenez.com list=BANCOS\r\
    \n    add address=186.24.10.0/24 comment=\"Bicentenario Plataforma Nueva\"\
    \_list=\\\r\
    \n        BANCOS\r\
    \n    add address=104.198.220.53 comment=Flexipos list=BANCOS\r\
    \n    add address=200.109.231.0/24 comment=Credicard list=BANCOS\r\
    \n    add address=45.179.13.42 comment=\"Venezuela Modelo Nuevo\" list=BAN\
    COS\r\
    \n    add address=www.bancocaroni.com.ve list=BANCOS\r\
    \n    add address=186.24.6.206 comment=\"Platco Inalambrico\" list=BANCOS\
    \r\
    \n    add address=www.patria.org.ve list=BANCOS\r\
    \n    add address=persona.patria.org.ve list=BANCOS\r\
    \n    add address=www.banfanb.com.ve list=BANCOS\r\
    \n    add address=banfanbenlinea.banfanb.com.ve list=BANCOS\r\
    \n    add address=www.provincial.com list=BANCOS\r\
    \n    add address=www.tsj.gob.ve list=BANCOS\r\
    \n    add address=190.202.148.187 list=BANCOS\r\
    \n    add address=www.biopagobdv.com list=BANCOS\r\
    \n    add address=www.payall.com.ve list=BANCOS\r\
    \n    add address=ucs.gob.ve list=BANCOS\r\
    \n    add address=sigae.ucs.gob.ve list=BANCOS\r\
    \n    add address=190.202.14.195 list=BANCOS\r\
    \n    add address=190.202.57.0/24 comment=\"Bicentenario Plataforma Vieja\
    \" list=\\\r\
    \n        BANCOS\r\
    \n    add address=190.202.89.0/24 list=BANCOS\r\
    \n    add address=20.119.0.20 comment=\"Simple Tv\" list=BANCOS\r\
    \n    add address=159.138.8.5 comment=\"Venezuela Modelo Nuevo\" list=BANC\
    OS\r\
    \n    add address=192.168.98.0/24 comment=\"CPU CENTER\" list=BANCOS\r\
    \n    add address=200.74.197.118 comment=RAPIDPAGO list=BANCOS\r\
    \n    add address=200.74.192.122 list=BANCOS\r\
    \n    add address=200.6.27.0/24 comment=\"Banesco App y Pago Movil\" list=\
    BANCOS\r\
    \n    add address=201.222.13.4 comment=\"Platco Plataforma Libre\" list=BA\
    NCOS\r\
    \n    add address=190.217.13.58 comment=intt list=BANCOS\r\
    \n    add address=190.202.82.66 comment=intt list=BANCOS\r\
    \n    add address=142.250.217.0/24 comment=Gmail list=BANCOS\r\
    \n    add address=200.11.221.0/24 list=BANCOS\r\
    \n    add address=declaraciones.seniat.gob.ve comment=\"Portal Seniat\" li\
    st=BANCOS\r\
    \n    add address=www.mercantilbanco.com comment=www.mercantilbanco.com li\
    st=BANCOS\r\
    \n    add address=www30.mercantilbanco.com comment=www30.mercantilbanco.co\
    m list=\\\r\
    \n        BANCOS\r\
    \n    add address=seniat.gob.ve comment=seniat.gob.ve list=BANCOS\r\
    \n    add address=190.202.2.0/24 comment=contribuyente.seniat.gob.ve list=\
    BANCOS\r\
    \n    add address=sni.opsu.gob.ve list=BANCOS\r\
    \n    add address=autogestionrrhh.me.gob.ve comment=autogestionrrhh.me.gob\
    .ve list=\\\r\
    \n        BANCOS\r\
    \n    add address=200.11.144.25 comment=CNE list=BANCOS\r\
    \n    add address=www.cne.gob.ve comment=www.cne.gob.ve list=BANCOS\r\
    \n    add address=sisap.apure.gob.ve comment=sisap.apure.gob.ve list=BANCO\
    S\r\
    \n    add address=www.saren.gob.ve comment=www.saren.gob.ve list=BANCOS\r\
    \n    add address=190.121.229.137 comment=BNC list=BANCOS\r\
    \n    add address=contribuyente.seniat.gob.ve comment=\\\r\
    \n        \"Seniat Contribuyente Personas\" list=BANCOS\r\
    \n    add address=200.74.201.0/24 comment=\"Banco del Sur\" list=BANCOS\r\
    \n    add address=intt.gob.ve list=BANCOS\r\
    \n    add address=plus.simple.com.ve comment=plus.simple.com.ve list=BANCO\
    S\r\
    \n    add address=23.9.54.49 comment=www.bbvaprovinet.provincial.com list=\
    BANCOS\r\
    \n    add address=www.bicentenariobu.com.ve comment=www.bicentenariobu.com\
    .ve list=\\\r\
    \n        BANCOS\r\
    \n    add address=23.194.250.107 comment=Provincial list=BANCOS\r\
    \n    add address=104.91.133.176 list=BANCOS\r\
    \n    add address=10.0.16.0/24 list=BANCOS\r\
    \n    add address=10.0.20.0/24 list=BANCOS\r\
    \n    add address=137.1.1.0/24 list=BANCOS\r\
    \n}"
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
