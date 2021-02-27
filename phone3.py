
import requests

url = "https://10.10.20.1:8443/axl/"


payload = """
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:addDeviceProfile>
         <deviceProfile>
            <name>SEPAAAAAAAAAACC</name>
            <description>test phone</description>
            <product>Cisco 7911</product>
            <class>Phone</class>
            <protocol>SCCP</protocol>
            <protocolSide>User</protocolSide>
            <securityProfileName>Cisco 7911 - Standard SCCP Non-Secure Profile</securityProfileName>
            <lines>
               <line ctiid="1">
                  <index>1</index>
                  <label>line1</label>
                  <display>menash</display>
                  <dirn uuid="?">
                     <pattern>1122</pattern>
                     <routePartitionName uuid="?">RoutePart</routePartitionName>
                  </dirn>
                  <ringSetting>Ring</ringSetting>
                  <consecutiveRingSetting>Use System Default</consecutiveRingSetting>
                  <ringSettingIdlePickupAlert>Use System Default</ringSettingIdlePickupAlert>
                  <ringSettingActivePickupAlert>Use System Default</ringSettingActivePickupAlert>
                  <displayAscii>menash phone</displayAscii>
                  <mwlPolicy>Use System Policy</mwlPolicy>
                  <maxNumCalls>3</maxNumCalls>
                  <busyTrigger>1</busyTrigger>
                  <callInfoDisplay>
                     <callerName>true</callerName>
                     <callerNumber>true</callerNumber>
                     <redirectedNumber>true</redirectedNumber>
                     <dialedNumber>true</dialedNumber>
                  </callInfoDisplay>
                  <recordingFlag>Call Recording Disabled</recordingFlag>
                  <audibleMwi>Default</audibleMwi>
                  <partitionUsage>General</partitionUsage>
                  <missedCallLogging>true</missedCallLogging>
                  <recordingMediaSource>Gateway Preferred</recordingMediaSource>
               </line>
               <lineIdentifier>
                  <directoryNumber>1122</directoryNumber>
                  <routePartitionName>Global learned E164 Numbers</routePartitionName>
               </lineIdentifier>
            </lines>
            <phoneTemplateName>Standard 7911</phoneTemplateName>
            <alwaysUsePrimeLine>Default</alwaysUsePrimeLine>
            <alwaysUsePrimeLineForVoiceMessage>Default</alwaysUsePrimeLineForVoiceMessage>
            <softkeyTemplateName>Standard User</softkeyTemplateName>
            <callInfoPrivacyStatus>Default</callInfoPrivacyStatus>
         </deviceProfile>
      </ns:addDeviceProfile>
   </soapenv:Body>
</soapenv:Envelope>
"""


headers = {}

data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
print(data.text)