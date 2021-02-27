import requests
from CUCM import *

def AddLine(line, mac, display):
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
    print("\ncreating line number...\n")
    data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
    while(data.ok != "True"):
        print("number already exists. please try again.")
        line = input("enter a new number: ")
        data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
    print("\nsuccess! created line number {line}")
    