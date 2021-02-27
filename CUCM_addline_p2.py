
from __future__ import absolute_import
import requests
import sys

devicelist = [u"3905",u"3911",u"3951",u"6901",u"6911",u"6921",u"6941",u"6945",u"6961",
           u"7811",u"7821",u"7832",u"7841",u"7861",u"7906",u"7911"]

mac = raw_input(u"please enter a device mac address(AAAABBBBCCCC): ")
while(len(mac)!=12):
   mac=raw_input(u"invalid mac address length. enter mac address: ")
mac=mac.upper()

line = raw_input(u"please enter phone numer: ")

display = raw_input(u"enter display name (default: Menash): ")
if(display == u""):
   display = u"Menash"
elif(len(display) >= 12):
   print u"limit is 12 characters. changing to default value..."
   display = u"Menash"

print u"supported device types..."
for i in devicelist:
   print i,; sys.stdout.write(u"  ")
device = raw_input(u"\nenter device type: Cisco ")
while(device not in devicelist):
   device = raw_input(u"nonexistant device. enter device type: ")
device = u"Cisco " + device

#REQUEST TO API BELOW

url = u"https://10.10.20.1:8443/axl/"
headers = {}

payload = f"""
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:addLine>
         <line>
            <pattern>{line}</pattern>
            <description>{mac} number</description>
            <usage>Device</usage>
            <alertingName>{display}</alertingName>
            <asciiAlertingName>{display}</asciiAlertingName>
         </line>
      </ns:addLine>
   </soapenv:Body>
</soapenv:Envelope>
"""

data = requests.post(url=url, headers=headers, data=payload,auth=(u"administrator",u"ciscopsdt"), verify=False)
print data.text

payload = f"""
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:addPhone>
         <phone>
            <name>SEP{mac}</name>
            <description>{mac} Phone</description>
            <product>Cisco 7911</product>
            <class>Phone</class>
            <protocol>SCCP</protocol>
            <protocolSide>User</protocolSide>
            <devicePoolName>Default</devicePoolName>
            <securityProfileName>Cisco 7911 - Standard SCCP Non-Secure Profile</securityProfileName>
            <lines>
               <line>
                  <index>1</index>
                  <label>Phone Line</label>
                  <display>{display}</display>
                  <dirn>
                     <pattern>{line}</pattern>
                     <routePartitionName></routePartitionName>
                  </dirn>
                  <displayAscii>{display}</displayAscii>
                  <e164Mask></e164Mask>
                  <busyTrigger>1</busyTrigger>
                  <callInfoDisplay>
                     <callerName>true</callerName>
                     <callerNumber>true</callerNumber>
                     <redirectedNumber>true</redirectedNumber>
                     <dialedNumber>true</dialedNumber>
                  </callInfoDisplay>
                  <missedCallLogging>true</missedCallLogging>
               </line>
               <lineIdentifier>
                  <directoryNumber>{line}</directoryNumber>
               </lineIdentifier>
            </lines>
            <phoneTemplateName>Standard 7911</phoneTemplateName>
         </phone>
      </ns:addPhone>
   </soapenv:Body>
</soapenv:Envelope>
"""

data = requests.post(url=url, headers=headers, data=payload,auth=(u"administrator",u"ciscopsdt"), verify=False)
print data.text