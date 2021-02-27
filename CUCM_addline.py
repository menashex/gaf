
import requests

url = "https://10.10.20.1:8443/axl/"
headers = {}


payload = """
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:addLine>
         <line>
            <pattern>2222</pattern>
            <description>testline</description>
            <usage>Phone line</usage>
         </line>
      </ns:addLine>
   </soapenv:Body>
</soapenv:Envelope>
"""

data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
print(data.text)

payload = """
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:addPhone>
         <phone>
            <name>SEPAAAAAAAAAACC</name>
            <description>test phone</description>
            <product>Cisco 7911</product>
            <class>Phone</class>
            <protocol>SCCP</protocol>
            <protocolSide>User</protocolSide>
            <devicePoolName>Default</devicePoolName>
            <securityProfileName>Cisco 7911 - Standard SCCP Non-Secure Profile</securityProfileName>
            <lines>
               <line>
                  <index>1</index>
                  <label>Test phone</label>
                  <display>menash phone</display>
                  <dirn>
                     <pattern>2222</pattern>
                     <routePartitionName></routePartitionName>
                  </dirn>
                  <displayAscii>Menash</displayAscii>
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
                  <directoryNumber>2222</directoryNumber>
               </lineIdentifier>
            </lines>
            <phoneTemplateName>Standard 7911</phoneTemplateName>
         </phone>
      </ns:addPhone>
   </soapenv:Body>
</soapenv:Envelope>
"""

data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
print(data.text)