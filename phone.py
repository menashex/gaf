
import requests

url = "https://10.10.20.1:8443/axl/"
payload ="""
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:getPhone sequence="?">
        <!--You have a CHOICE of the next 2 items at this level-->
            <name>SEPAAAAAAAAAAAA</name>
            <returnedTags>
               <name></name>
               <model></model>
               <loadInformation></loadInformation>
            </returnedTags>
        </ns:getPhone>
    </soapenv:Body>
</soapenv:Envelope>
"""
headers = {}

data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
print(data.text)