
import requests

url = "https://10.10.20.1:8443/axl/"


payload= """
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:addPhone sequence="?">
         <phone ctiid="?">
            <name>SEPAAAAAAAAAABD</name>
            <!--Optional:-->
            <description>nick is gay</description>
            <product>Cisco 7911</product>
            <class>Phone</class>
            <protocol>SCCP</protocol>
            <protocolSide>User</protocolSide>
            <!--Optional:-->
            <devicePoolName uuid="?">Default</devicePoolName>
         </phone>
      </ns:addPhone>
   </soapenv:Body>
</soapenv:Envelope>
"""
"""

headers = {}

data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
print(data.text)