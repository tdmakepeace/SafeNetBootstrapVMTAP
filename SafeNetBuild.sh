#!/bin/sh


#####################################################################################

clear
echo "###############################################################################"
echo "# The following script is to allow you to prepare a XML file for a Safenet    #"
echo "# Demo                                                                        #"
echo "#                                                                             #"
echo "# If you are using VM and want to bootstrap a licence edit line 95            #"
echo "# Unit must be licenced to accept the bootstrap or the XML file               #"
echo "#                                                                             #"
echo "#                                                                             #"
echo "###############################################################################"
echo " "
echo " "
echo " "

echo "###############################################################################"
echo "Enter the name of the customer for the backup"
echo "###############################################################################"
read name


while :
do
echo "###############################################################################"
echo "           Please select from the following options. "
echo "###############################################################################"
echo "           1.  XML only"
echo "           2.  Bootstrap ISO"
echo "           3.  Change the customer"
echo "           4.  Create a Env-create.txt"
echo "           5.  Setup (one off)"
echo "###############################################################################"
echo "Current customer is: $name "
echo ""
echo -n "           Please enter option [1 - 10] or x to exit :"
read opt


case $opt in

  1)

	
source ./env-create.txt
export PATH=${PATH}:/usr/local/opt/gettext/bin
CONFIG_IN="SN-config-source-$PANOS.xml"
TEMPLATE_OUT="SN-$name-$PANOS.xml"
envsubst < $CONFIG_IN > $TEMPLATE_OUT

 ;;

	2)


source ./env-create.txt
export PATH=${PATH}:/usr/local/opt/gettext/bin
CONFIG_IN="SN-config-source-$PANOS.xml"
TEMPLATE_OUT="SN-$name-$PANOS.xml"
envsubst < $CONFIG_IN > $TEMPLATE_OUT



yes|rm -R ISO

mkdir ISO
cd ISO
mkdir config
mkdir content
mkdir license
mkdir software
cd config

cp ../../$TEMPLATE_OUT bootstrap.xml
cd ..

	echo "type=static" >config/init-cfg.txt
	echo "ip-address=$MGMT_IP" >>config/init-cfg.txt
	echo "default-gateway=$MGMT_DG" >>config/init-cfg.txt
	echo "netmask=$MGMT_MASK" >>config/init-cfg.txt
	echo "ipv6-address=2001:400:f00::1/64" >>config/init-cfg.txt
	echo "ipv6-default-gateway=2001:400:f00::2" >>config/init-cfg.txt
	echo "hostname=$FW_NAME" >>config/init-cfg.txt
	echo "dns-primary=$DNS_1" >>config/init-cfg.txt
	echo "dns-secondary=$DNS_2" >>config/init-cfg.txt
	echo "op-command-modes=multi-vsys,jumbo-frame" >>config/init-cfg.txt
	echo "dhcp-send-hostname=no" >>config/init-cfg.txt
	echo "dhcp-send-client-id=no" >>config/init-cfg.txt
	echo "dhcp-accept-server-hostname=no" >>config/init-cfg.txt
	echo "dhcp-accept-server-domain=no" >>config/init-cfg.txt

## if you are using VM and want to enable the licence activation.
## add the authcode in the " marks on line 98
#cd license
#echo "<authcode>" > authcodes
# cd ..

mkisofs -allow-lowercase -iso-level 4 -o  ../$name.iso ./
echo ""
echo ""
echo ""
echo ""	

cd ..


clear
  
;;


	3)

echo "###############################################################################"
echo "Enter the name of the customer for the backup"
echo "###############################################################################"
read name



;;


	4)

	echo "###############################################################################"
	echo "Manual creation of the env.txt file"
	echo "###############################################################################"
	echo "Enter the Firewall name:"
	echo "eg VM-Host"
	read FW_NAME
	echo "Enter the Management IP:"
	echo "eg 192.168.2.14"
	read MGMT_IP
	echo "Enter the Netmask:"
	echo "eg 255.255.255.0"
	read MGMT_MASK
	echo "Enter the Defualt Gateway"
	echo "eg 192.168.2.1"
	read MGMT_DG
	echo "Enter the Primary DNS IP:"
	echo "eg 8.8.8.8"
	read DNS1
	echo "Enter the Secondary DNS IP:"
	echo "eg 8.8.4.4"
	read DNS2
	echo "Enter the Primary NTP Soucre name or IP:"
	echo "eg time.nist.gov"
	read NTP1
	echo "Enter the Secondary NTP Soucre name or IP:"
	echo "eg time.nist.gov"
	read NTP2
	echo "Enter the Timezone:"
	echo "eg us/Eastern"
	read TIMEZONE
	echo "Enter the Tap interface:"
	echo "eg ethernet1/5"
	read SLOTPORT
	echo "Enter the IP of the SafeNetwork Server:"
	echo "eg 10.0.0.1"
	read HTTPSERVERIP




	echo "#Palo Alto Networks Variables "> env-create.txt
	echo "#Scott Shoaf & Toby Makepeace ">> env-create.txt
	echo "export PANOS=PANOS-08.0">> env-create.txt
	echo "export FW_NAME=$FW_NAME">> env-create.txt
	echo "export MGMT_IP=$MGMT_IP">> env-create.txt
	echo "export MGMT_MASK=$MGMT_IP">> env-create.txt
	echo "export MGMT_DG=$MGMT_DG">> env-create.txt
	echo "export DNS_1=DNS1">> env-create.txt
	echo "export DNS_2=DNS2">> env-create.txt
	echo "export NTP_1=$NTP1">> env-create.txt
	echo "export NTP_2=$NTP2">> env-create.txt
	echo "export TIMEZONE=$TIMEZONE">> env-create.txt
	echo "export SLOT_PORT=$SLOT_PORT">> env-create.txt
	echo "export HTTP_SERVER_IP=$HTTPSERVERIP">> env-create.txt


;;

	5)
echo "#Palo Alto Networks Variables
#Scott Shoaf

export PANOS=PANOS-08.0
export FW_NAME=PA-Eval
export MGMT_IP=192.168.102.208
export MGMT_MASK=255.255.255.0
export MGMT_DG=192.168.102.1
export DNS_1=8.8.8.8
export DNS_2=8.8.4.4
export NTP_1=time.nist.gov
export NTP_2=time.microsoft.com
export TIMEZONE=US/Eastern
export SLOT_PORT=ethernet1/1
export HTTP_SERVER_IP=192.168.102.9
" > env-create.txt

echo "<?xml version="1.0"?>
<config version="8.0.0" urldb="paloaltonetworks">
  <mgt-config>
    <users>
      <entry name="admin">
        <phash>fnRL/G5lXVMug</phash>
        <permissions>
          <role-based>
            <superuser>yes</superuser>
          </role-based>
        </permissions>
      </entry>
    </users>
  </mgt-config>
  <shared>
    <application/>
    <application-group/>
    <service/>
    <service-group/>
    <botnet>
      <configuration>
        <http>
          <dynamic-dns>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </dynamic-dns>
          <malware-sites>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </malware-sites>
          <recent-domains>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </recent-domains>
          <ip-domains>
            <enabled>yes</enabled>
            <threshold>10</threshold>
          </ip-domains>
          <executables-from-unknown-sites>
            <enabled>yes</enabled>
            <threshold>5</threshold>
          </executables-from-unknown-sites>
        </http>
        <other-applications>
          <irc>yes</irc>
        </other-applications>
        <unknown-applications>
          <unknown-tcp>
            <destinations-per-hour>10</destinations-per-hour>
            <sessions-per-hour>10</sessions-per-hour>
            <session-length>
              <maximum-bytes>100</maximum-bytes>
              <minimum-bytes>50</minimum-bytes>
            </session-length>
          </unknown-tcp>
          <unknown-udp>
            <destinations-per-hour>10</destinations-per-hour>
            <sessions-per-hour>10</sessions-per-hour>
            <session-length>
              <maximum-bytes>100</maximum-bytes>
              <minimum-bytes>50</minimum-bytes>
            </session-length>
          </unknown-udp>
        </unknown-applications>
      </configuration>
      <report>
        <topn>100</topn>
        <scheduled>yes</scheduled>
      </report>
    </botnet>
    <content-preview>
      <application/>
      <application-type>
        <category/>
        <technology/>
      </application-type>
    </content-preview>
    <reports>
      <entry name="dns-total-hits">
        <type>
          <thsum>
            <aggregate-by>
              <member>category-of-threatid</member>
            </aggregate-by>
            <values>
              <member>count</member>
            </values>
          </thsum>
        </type>
        <period>last-calendar-day</period>
        <topn>10</topn>
        <topm>10</topm>
        <caption>dns-total-hits</caption>
        <frequency>daily</frequency>
        <query>(category-of-threatid eq dns) or (category-of-threatid eq dns-wildfire)</query>
      </entry>
      <entry name="dns-signature-hits">
        <type>
          <thsum>
            <sortby>count</sortby>
            <aggregate-by>
              <member>src</member>
              <member>threatid</member>
              <member>category-of-threatid</member>
            </aggregate-by>
            <values>
              <member>count</member>
            </values>
          </thsum>
        </type>
        <period>last-calendar-day</period>
        <topn>10000</topn>
        <topm>10</topm>
        <caption>dns-signature-hits</caption>
        <frequency>daily</frequency>
        <query>(category-of-threatid eq dns) or (category-of-threatid eq dns-wildfire)</query>
      </entry>
      <entry name="edl-signature-hits">
        <type>
          <thsum>
            <sortby>count</sortby>
            <aggregate-by>
              <member>src</member>
              <member>threatid</member>
              <member>category-of-threatid</member>
            </aggregate-by>
            <values>
              <member>count</member>
            </values>
          </thsum>
        </type>
        <period>last-calendar-day</period>
        <topn>10000</topn>
        <topm>10</topm>
        <caption>edl-signature-hits</caption>
        <frequency>daily</frequency>
        <query>(threatid eq 12000000)</query>
      </entry>
      <entry name="dns-top50-by-source">
        <type>
          <thsum>
            <sortby>count</sortby>
            <group-by>src</group-by>
            <aggregate-by>
              <member>threatid</member>
              <member>category-of-threatid</member>
            </aggregate-by>
            <values>
              <member>count</member>
            </values>
          </thsum>
        </type>
        <period>last-calendar-day</period>
        <topn>25</topn>
        <topm>50</topm>
        <caption>dns-top50-by-source</caption>
        <frequency>daily</frequency>
        <query>(category-of-threatid eq dns) or (category-of-threatid eq dns-wildfire)</query>
      </entry>
      <entry name="edl-total-hits">
        <type>
          <thsum>
            <aggregate-by>
              <member>threatid</member>
            </aggregate-by>
            <values>
              <member>count</member>
            </values>
          </thsum>
        </type>
        <period>last-calendar-day</period>
        <topn>10</topn>
        <topm>10</topm>
        <caption>edl-total-hits</caption>
        <frequency>daily</frequency>
        <query>(threatid eq 12000000)</query>
      </entry>
    </reports>
    <log-settings>
      <http>
        <entry name="SN-http">
          <server>
            <entry name="SN-http">
              <address>$HTTP_SERVER_IP</address>
              <http-method>POST</http-method>
              <protocol>HTTP</protocol>
              <port>8808</port>
            </entry>
          </server>
          <format>
            <threat>
              <name>API</name>
              <url-format>/CreateRecord</url-format>
              <headers>
                <entry name="Content-Type">
                  <value>application/json</value>
                </entry>
              </headers>
              <payload>All</payload>
            </threat>
          </format>
        </entry>
      </http>
      <profiles>
        <entry name="SN log forwarding">
          <match-list>
            <entry name="SN log forwarding">
              <send-http>
                <member>SN-http</member>
              </send-http>
              <log-type>threat</log-type>
              <filter>All Logs</filter>
              <send-to-panorama>no</send-to-panorama>
            </entry>
          </match-list>
        </entry>
      </profiles>
    </log-settings>
  </shared>
  <devices>
    <entry name="localhost.localdomain">
      <network>
        <interface>
          <ethernet>
            <entry name="$SLOT_PORT">
              <tap/>
            </entry>
          </ethernet>
          <loopback>
            <units/>
          </loopback>
          <vlan>
            <units/>
          </vlan>
          <tunnel>
            <units/>
          </tunnel>
        </interface>
        <vlan/>
        <virtual-wire/>
        <profiles>
          <monitor-profile>
            <entry name="default">
              <interval>3</interval>
              <threshold>5</threshold>
              <action>wait-recover</action>
            </entry>
          </monitor-profile>
        </profiles>
        <ike>
          <crypto-profiles>
            <ike-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                  <member>3des</member>
                </encryption>
                <hash>
                  <member>sha1</member>
                </hash>
                <dh-group>
                  <member>group2</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <hash>
                  <member>sha256</member>
                </hash>
                <dh-group>
                  <member>group19</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <encryption>
                  <member>aes-256-cbc</member>
                </encryption>
                <hash>
                  <member>sha384</member>
                </hash>
                <dh-group>
                  <member>group20</member>
                </dh-group>
                <lifetime>
                  <hours>8</hours>
                </lifetime>
              </entry>
            </ike-crypto-profiles>
            <ipsec-crypto-profiles>
              <entry name="default">
                <esp>
                  <encryption>
                    <member>aes-128-cbc</member>
                    <member>3des</member>
                  </encryption>
                  <authentication>
                    <member>sha1</member>
                  </authentication>
                </esp>
                <dh-group>group2</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-128">
                <esp>
                  <encryption>
                    <member>aes-128-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group19</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
              <entry name="Suite-B-GCM-256">
                <esp>
                  <encryption>
                    <member>aes-256-gcm</member>
                  </encryption>
                  <authentication>
                    <member>none</member>
                  </authentication>
                </esp>
                <dh-group>group20</dh-group>
                <lifetime>
                  <hours>1</hours>
                </lifetime>
              </entry>
            </ipsec-crypto-profiles>
            <global-protect-app-crypto-profiles>
              <entry name="default">
                <encryption>
                  <member>aes-128-cbc</member>
                </encryption>
                <authentication>
                  <member>sha1</member>
                </authentication>
              </entry>
            </global-protect-app-crypto-profiles>
          </crypto-profiles>
        </ike>
        <qos>
          <profile>
            <entry name="default">
              <class>
                <entry name="class1">
                  <priority>real-time</priority>
                </entry>
                <entry name="class2">
                  <priority>high</priority>
                </entry>
                <entry name="class3">
                  <priority>high</priority>
                </entry>
                <entry name="class4">
                  <priority>medium</priority>
                </entry>
                <entry name="class5">
                  <priority>medium</priority>
                </entry>
                <entry name="class6">
                  <priority>low</priority>
                </entry>
                <entry name="class7">
                  <priority>low</priority>
                </entry>
                <entry name="class8">
                  <priority>low</priority>
                </entry>
              </class>
            </entry>
          </profile>
        </qos>
        <virtual-router>
          <entry name="default">
            <protocol>
              <bgp>
                <enable>no</enable>
                <dampening-profile>
                  <entry name="default">
                    <cutoff>1.25</cutoff>
                    <reuse>0.5</reuse>
                    <max-hold-time>900</max-hold-time>
                    <decay-half-life-reachable>300</decay-half-life-reachable>
                    <decay-half-life-unreachable>900</decay-half-life-unreachable>
                    <enable>yes</enable>
                  </entry>
                </dampening-profile>
              </bgp>
            </protocol>
          </entry>
        </virtual-router>
      </network>
      <deviceconfig>
        <system>
          <ip-address>$MGMT_IP</ip-address>
          <netmask>$MGMT_MASK</netmask>
          <update-server>updates.paloaltonetworks.com</update-server>
          <update-schedule>
            <threats>
              <recurring>
                <hourly>
                  <action>download-and-install</action>
                </hourly>
              </recurring>
            </threats>
            <anti-virus>
              <recurring>
                <hourly>
                  <action>download-and-install</action>
                </hourly>
              </recurring>
            </anti-virus>
            <wildfire>
              <recurring>
                <every-min>
                  <action>download-and-install</action>
                </every-min>
              </recurring>
            </wildfire>
            <statistics-service>
              <passive-dns-monitoring>yes</passive-dns-monitoring>
            </statistics-service>
          </update-schedule>
          <timezone>$TIMEZONE</timezone>
          <service>
            <disable-telnet>yes</disable-telnet>
            <disable-http>yes</disable-http>
          </service>
          <hostname>$FW_NAME</hostname>
          <default-gateway>$MGMT_DG</default-gateway>
          <dns-setting>
            <servers>
              <primary>$DNS_1</primary>
              <secondary>$DNS_2</secondary>
            </servers>
          </dns-setting>
          <type>
            <static/>
          </type>
        </system>
        <setting>
          <config>
            <rematch>yes</rematch>
          </config>
          <management>
            <hostname-type-in-syslog>FQDN</hostname-type-in-syslog>
            <max-rows-in-csv-export>1000000</max-rows-in-csv-export>
          </management>
          <session>
            <timeout-udp>10</timeout-udp>
          </session>
        </setting>
      </deviceconfig>
      <vsys>
        <entry name="vsys1">
          <application/>
          <application-group/>
          <zone>
            <entry name="Tap">
              <network>
                <tap>
                  <member>$SLOT_PORT</member>
                </tap>
              </network>
            </entry>
          </zone>
          <service/>
          <service-group/>
          <schedule/>
          <rulebase>
            <security>
              <rules>
                <entry name="Log dns">
                  <profile-setting>
                    <profiles>
                      <spyware>
                        <member>DNS - alert</member>
                      </spyware>
                      <vulnerability>
                        <member>DNS - alert</member>
                      </vulnerability>
                    </profiles>
                  </profile-setting>
                  <to>
                    <member>Tap</member>
                  </to>
                  <from>
                    <member>Tap</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>dns</member>
                  </application>
                  <service>
                    <member>application-default</member>
                  </service>
                  <hip-profiles>
                    <member>any</member>
                  </hip-profiles>
                  <action>allow</action>
                </entry>
                <entry name="Log non-dns traffic">
                  <profile-setting>
                    <profiles>
                      <vulnerability>
                        <member>DNS - alert</member>
                      </vulnerability>
                    </profiles>
                  </profile-setting>
                  <to>
                    <member>Tap</member>
                  </to>
                  <from>
                    <member>Tap</member>
                  </from>
                  <source>
                    <member>any</member>
                  </source>
                  <destination>
                    <member>any</member>
                  </destination>
                  <source-user>
                    <member>any</member>
                  </source-user>
                  <category>
                    <member>any</member>
                  </category>
                  <application>
                    <member>any</member>
                  </application>
                  <service>
                    <member>any</member>
                  </service>
                  <hip-profiles>
                    <member>any</member>
                  </hip-profiles>
                  <action>allow</action>
                </entry>
              </rules>
            </security>
          </rulebase>
          <import>
            <network>
              <interface>
                <member>$SLOT_PORT</member>
              </interface>
            </network>
          </import>
          <profiles>
            <vulnerability>
              <entry name="DNS - alert">
                <rules>
                  <entry name="alert only">
                    <action>
                      <alert/>
                    </action>
                    <vendor-id>
                      <member>any</member>
                    </vendor-id>
                    <severity>
                      <member>any</member>
                    </severity>
                    <cve>
                      <member>any</member>
                    </cve>
                    <threat-name>any</threat-name>
                    <host>any</host>
                    <category>any</category>
                    <packet-capture>single-packet</packet-capture>
                  </entry>
                </rules>
                <threat-exception>
                  <entry name="36518">
                    <action>
                      <allow/>
                    </action>
                  </entry>
                  <entry name="40040">
                    <action>
                      <default/>
                    </action>
                    <time-attribute>
                      <interval>60</interval>
                      <threshold>10</threshold>
                      <track-by>destination</track-by>
                    </time-attribute>
                  </entry>
                </threat-exception>
              </entry>
            </vulnerability>
            <spyware>
              <entry name="DNS - alert">
                <botnet-domains>
                  <lists>
                    <entry name="default-paloalto-dns">
                      <action>
                        <alert/>
                      </action>
                    </entry>
                  </lists>
                </botnet-domains>
              </entry>
            </spyware>
          </profiles>
        </entry>
      </vsys>
    </entry>
  </devices>
</config>
" > SN-config-source-PANOS-08.0.xml



;;

	x)


	exit 1;;

	*) 
echo "$opt is an invaild option. Please select correct option";
echo "Press [enter] key to continue. . .";
read enterKey;;
esac
done