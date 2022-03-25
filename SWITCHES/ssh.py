
from netmiko import ConnectHandler
from getpass import getpass
import sys

addresses=["10.0.0.13", "10.0.0.14", "10.0.0.15"]

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
        else:
            print("not in "+i+"...")
    #sys.exit()

def noshut():
    interface = input("enter interface with the following format: gix/x or fax/x:  ")
    command = ['int ' + interface, 'shut', 'no shut']
    return command

def findvlan():
    interface = input("enter interface with the following format: gix/x or fax/x:  ")
    command = ['do show int ' + interface + ' switchport | inc Access|Voice']
    return command

print("######################################\n")
print("hello and welcome to menashe's script!\n")
print("######################################\n")
username=input("please enter username: ")
password=getpass()
while(1):
    print("\n1 - change vlan\n2 - show interface status\n3 - find device\n4 - no shut interface\n5 - find vlan of port")
    action=int(input("\nwhat would you like to do?: "))
    while(action <= 0 or action >=6):
        action=int(input("1 - change vlan\n2 - show interfaces status\n3 - find device\n4 - no shut interface\n5 - find vlan of port: "))
    if(action == 1):
        commands=changevlan()
        ipadd=getip()
        connect()
    elif(action == 2):
        commands=showintbrief()
        ipadd=getip()
        connect()
    elif(action == 3):
        commands=finddevice()
    elif(action == 4):
        commands=noshut()
        ipadd=getip()
        connect()
    elif(action == 5):
        commands=findvlan()
        ipadd=getip()
        connect()