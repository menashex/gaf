
import requests

devicelist = ["3905","3911","3951","6901","6911","6921","6941","6945","6961",
           "7811","7821","7832","7841","7861","7906","7911"]

mac = input("please enter a device mac address(AAAABBBBCCCC): ")
while(len(mac)!=12):
   mac=input("invalid mac address length. enter mac address: ")
mac=mac.upper()

line = input("please enter phone numer: ")

display = input("enter display name (default: Menash): ")
if(display == ""):
   display = "Menash"
elif(len(display) >= 12):
   print("limit is 12 characters. changing to default value...")
   display = "Menash"

print("\n\nsupported device types...")
for i in devicelist:
   print(i,end="  ")
device = input("\nenter device type: Cisco ")
while(device not in devicelist):
   device = input("nonexistant device. enter device type: Cisco ")
ciscodevice = "Cisco " + device


#REQUEST TO API BELOW

url = "https://10.10.20.1:8443/axl/"
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

data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
print(data)
if(data.ok == False):
   print("number already exists. please try again.")

payload = f"""
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:addPhone>
         <phone>
            <name>SEP{mac}</name>
            <description>{mac} Phone</description>
            <product>Cisco {device}</product>
            <class>Phone</class>
            <protocol>SCCP</protocol>
            <protocolSide>User</protocolSide>
            <devicePoolName>Default</devicePoolName>
            <securityProfileName>{ciscodevice} - Standard SCCP Non-Secure Profile</securityProfileName>
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
            <phoneTemplateName>Standard {device}</phoneTemplateName>
         </phone>
      </ns:addPhone>
   </soapenv:Body>
</soapenv:Envelope>
"""

data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
print(data)
if(data.ok == False):
   print("phone already exists. please try again.")