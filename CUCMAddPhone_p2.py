import requests
from requests.sessions import dispatch_hook
from urllib3.exceptions import InsecureRequestWarning
import sys
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)


#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################
#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################
#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################
#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################
#################### THIS SECTION IS ALL ABOUT FUNCTIONS ##########################



#################### GET MAC FUNTION #############################
u"""
function to get mac address from user and return it to the program formatted with SEP
"""
from __future__ import absolute_import
def GetMac():
   mac = raw_input(u"please enter a device mac address(AAAABBBBCCCC): ")
   while(len(mac)!=12):
      mac=raw_input(u"invalid mac address length. enter mac address: ")
      mac=mac.upper()
   return mac

##################### GET DISPLAY FUNCTION ########################
u"""
function to get display name from user and return it to program. 
can only be 5 to 12 characters, default value: "Menash"
"""
def GetDisplay():
   display = raw_input(u"enter display name (default: Menash): ")
   if(display == u""):
      return u"Menash"
   while(len(display) > 12 or len(display) < 5):
      print u"display name must be 5 to 12 characters."
      display = raw_input(u"enter display name (default: Menash): ")
   return display

##################### GET DEVICE FUNCTION #########################
u"""
function to get a device type from a list of supported devices, and return it to the user.
"""
def GetDevice():
   devicelist = [u"3905",u"3911",u"3951",u"6901",u"6911",u"6921",u"6941",u"6945",u"6961",
                 u"7811",u"7821",u"7832",u"7841",u"7861",u"7906",u"7911"]

   print u"\n\nsupported device types..."
   for i in devicelist:
      print i,; sys.stdout.write(u"  ")
   
   device = raw_input(u"\nenter device type: Cisco ")
   while(device not in devicelist):
      device = raw_input(u"nonexistant device. enter device type: Cisco ")
   return device

##################### GET NUMBER FUNCTION ##########################
def GetNumber():
   number = raw_input(u"please enter a phone number: ")
   while(len(number) < 3 or len(number) > 5):
      print u"phone number can be 3 to 5 numbers only"
      number = raw_input(u"please enter a phone number: ")

#################### ADDLINE FUNCTION ############################
u""" 
function to add a number line. if line exists, return code is 500 and the whole loop is repeating.
if return code is 200, the loop breaks and creates that line.
"""
def AddLine(number, mac, display):
   url = u"https://10.10.20.1:8443/axl/"
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
   print u"\ncreating line number..."
   data = requests.post(url=url, headers=headers, data=payload,auth=(u"administrator",u"ciscopsdt"), verify=False)
   if(data.ok != True):
      print u"number already exists. please try again."
      return False  
   print f"success! created line number {number}"
   return True
    

######################### ADDPHONE FUCNTION #########################

u""" 
function to add a phone. if mac address exists, return code is 500 and the whole loop is repeating.
if return code is 200, the loop breaks and creates that phone profile.
"""
def AddPhone(line,mac,display,device):
   url = u"https://10.10.20.1:8443/axl/"
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

   print f"\ncreating phone profile {mac} with phone line {number}..."
   data = requests.post(url=url, headers=headers, data=payload,auth=(u"administrator",u"ciscopsdt"), verify=False)
   if(data.ok != True):
        print u"\nphone already exists. please try again."
        return False
   print f"success! created phone {mac} with number {number}"
   return True


######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################
######################## THIS IS WHERE THE PROGRAM STARTS ########################

device = GetDevice()
mac = GetMac()
display = GetDisplay()
number = GetNumber()

addline = AddLine(number,mac,display)
while(addline != True):
   number = GetNumber()
   AddLine(number,mac,display)

addphone = AddPhone(number,mac,display,device)
while(addphone != True):
   mac=GetMac()
   AddPhone(number,mac,display,device)

raw_input(u"\n\npress enter to exit....")