
from netmiko import ConnectHandler
from getpass import getpass
import sys
import os

addresses=["10.0.0.13", "10.0.0.14", "10.0.0.15"]
actions=["1 - find vlan of port","2 - change vlan","3 - show interfaces status","4 - no shut interface","5 - find device","6 - get mac", "7 - DNS lookup", "8 - Shutdown PC", "9 - mipui"]

def connect():
    device = {
        "device_type": "cisco_ios",
        "host": ipadd, 
        "username": username,
        "password": password,
    }
    with ConnectHandler(**device) as net_connect:
        output = net_connect.send_config_set(commands)
        output += net_connect.save_config()
    print()
    print(output)
    print()

def getip():
    print("supported ip addresses:")
    for i in addresses:
        print(i)
    address=input("\nwhat is the switch's ip address?: ")
    while(address not in addresses):
        print("invalid ip address!\n")
        address=input("what is the switch's ip address?: ")
    return address

def changevlan():
    interface = input("enter interface with the following format: gix/x or fax/x:  ")
    vlan = input("enter desired vlan number: ")
    phone = input("is a phone attached? y/n: ")
    while(phone != 'y' and phone != 'n'):
        print("invalid input!\n")
        phone = input("is a phone attached? y/n: ")
    if(phone == "y"):
        command = ['int ' + interface, 'switchport access vlan ' + vlan, "switchport voice vlan 310"]
    else:
        command = ['int ' + interface, 'switchport access vlan ' + vlan]
    return command

def showintbrief():
    command = ['do show ip int brief']
    return command

def finddevice():
    mac=input("enter last 4 digits of mac address: ")
    for i in addresses:
        device = {
        "device_type": "cisco_ios",
        "host": i, 
        "username": username,
        "password": password,
        }
        commands = ['do show mac add | inc ' + mac]
        print("searching "+i+"...")
        with ConnectHandler(**device) as net_connect:
            output = net_connect.send_config_set(commands)
        if("DYNAMIC" in output):
            print("\n"+output)
            if("SW1" in output):
                print("\n###############\nswitch " +i+" is located at B-C05-U24\n###############\n")
            elif("SW2" in output):
                print("\n###############\nswitch " +i+" is located at A-C05-U24\n###############\n")
            elif("SW3" in output):
                print("\n###############\nswitch " +i+" is located at F-C03-U24\n###############\n")
        else:
            print("not in "+i+".")
    #sys.exit()

def noshut():
    interface = input("enter interface with the following format: gix/x or fax/x:  ")
    command = ['int ' + interface, 'shut', 'no shut']
    return command

def findvlan():
    interface = input("enter interface with the following format: gix/x or fax/x:  ")
    command = ['do show int ' + interface + ' switchport | inc Access|Voice']
    return command

def getmac():
    print()
    hostname=input("enter ip or hostname: ")
    os.system('cmd /c "getmac /s "'+hostname)

def nslookup():
    print()
    hostname=input("enter ip or hostname: ")
    os.system('cmd /c "nslookup "'+hostname)

def shutdown():
    print()
    hostname=input("enter ip or hostname: ")
    os.system('cmd /c "shutdown /r /m '+hostname+"\"")

def mipui():
    for i in addresses:
        device = {
        "device_type": "cisco_ios",
        "host": i, 
        "username": username,
        "password": password,
        }
        print("\n###################\n Switch "+i+"\n###################\n")
        commands = ['do show cdp neigh detail | inc ID|Interface|Entry|Management add|IP\n\n']
        with ConnectHandler(**device) as net_connect:
            output = net_connect.send_config_set(commands)
        print(output)

print("######################################\n")
print("hello and welcome to menashe's script!\n")
print("######################################\n")
username=input("please enter username: ")
password=getpass()
while(1):
    action=0
    print()
    while(action <= 0 or action > len(actions)):
        for i in actions:
            print(i)
        action=int(input("\nwhat would you like to do?: "))
    if (action == 5):
        commands=finddevice()
    elif (action == 6):
        getmac()
    elif (action == 7):
        nslookup() 
    elif (action == 8):
        shutdown() 
    elif (action == 9):
        mipui()
    else:
        if(action == 1):
            commands=findvlan()
        elif(action == 2):
            commands=changevlan()
        elif(action == 3):
            commands=showintbrief()
        elif(action == 4):
            commands=noshut()
        ipadd=getip()
        connect()