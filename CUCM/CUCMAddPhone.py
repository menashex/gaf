import requests
from requests.sessions import dispatch_hook
from urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)


#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################
#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################
#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################
#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################
#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################



#################### GET MAC FUNTION #############################
"""
function to get mac address from user and return it to the program formatted with SEP
"""
def GetMac():
   mac = input("please enter a device mac address(AAAABBBBCCCC): ")
   mac = mac.upper()
   while(len(mac)!=12):
      mac=input("invalid mac address length. enter mac address: ")
      mac=mac.upper()
   return mac

##################### GET DISPLAY FUNCTION ########################
"""
function to get display name from user and return it to program. 
can only be 5 to 12 characters, default value: "Menash"
"""
def GetDisplay():
   display = input("enter display name (default: Menash): ")
   if(display == ""):
      return "Menash"
   while(len(display) > 12 or len(display) < 5):
      print("display name must be 5 to 12 characters.")
      display = input("enter display name (default: Menash): ")
   return display

##################### GET DEVICE FUNCTION #########################
"""
function to get a device type from a list of supported devices, and return it to the user.
"""
def GetDevice():
   devicelist = ["3905","3911","3951","6901","6911","6921","6941","6945","6961",
                 "7811","7821","7832","7841","7861","7906","7911"]

   print("\n\nsupported device types...")
   for i in devicelist:
      print(i,end="  ")
   
   device = input("\nenter device type: Cisco ")
   while(device not in devicelist):
      device = input("nonexistant device. enter device type: Cisco ")
   return device

##################### GET NUMBER FUNCTION ##########################
def GetNumber():
   number = input("please enter a phone number: ")
   while(len(number) < 3 or len(number) > 5):
      print("phone number can be 3 to 5 numbers only")
      number = input("please enter a phone number: ")
   return number






#################### ADDLINE FUNCTION ############################
""" 
function to add a number line. if line exists, return code is 500 and the whole loop is repeating.
if return code is 200, the loop breaks and creates that line.
"""
def AddLine(number, mac, display):
   url = "https://10.10.20.1:8443/axl/"
   headers = {}
   payload = f"""
   <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:addLine>
         <line>
            <pattern>{number}</pattern>
            <description>{mac} number</description>
            <usage>Device</usage>
            <alertingName>{display}</alertingName>
            <asciiAlertingName>{display}</asciiAlertingName>
         </line>
      </ns:addLine>
   </soapenv:Body>
   </soapenv:Envelope>
   """
   print("\ncreating line number...")
   data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
   if(data.ok != True):
      print("number already exists. please try again.")
      return False  
   print(f"success! created line number {number}")
   return True
    

######################### ADDPHONE FUCNTION #########################

""" 
function to add a phone. if mac address exists, return code is 500 and the whole loop is repeating.
if return code is 200, the loop breaks and creates that phone profile.
"""
def AddPhone(line,mac,display,device):
   url = "https://10.10.20.1:8443/axl/"
   headers={}
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
            <securityProfileName>Cisco {device} - Standard SCCP Non-Secure Profile</securityProfileName>
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

   print(f"\ncreating phone profile {mac} with phone line {number}...")
   data = requests.post(url=url, headers=headers, data=payload,auth=("administrator","ciscopsdt"), verify=False)
   if(data.ok != True):
        print("\nphone already exists. please try again.")
        return False
   print(f"success! created phone {mac} with number {number}")
   return True


######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################

device = GetDevice()
mac = GetMac()
number = GetNumber()
display = GetDisplay()

addline = AddLine(number,mac,display)
while(addline != True):
   number = GetNumber()
   addline = AddLine(number,mac,display)

addphone = AddPhone(number,mac,display,device)
while(addphone != True):
   mac = GetMac()
   addphone = AddPhone(number,mac,display,device)

input("\n\npress enter to exit....")