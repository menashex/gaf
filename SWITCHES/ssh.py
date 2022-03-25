
from netmiko import ConnectHandler
from getpass import getpass

addresses=["10.0.0.13", "10.0.0.14"]
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


print("hello and welcome to menashe's script.\n")
print("1 - change vlan\n2 - show interface status: ")
action=int(input("what would you like to do?: "))
while(action <= 0 or action >=3):
    action=int(input("1 - change vlan\n2 - show interface status: "))
if(action == 1):
    commands=changevlan()
elif(action == 2):
    commands=showintbrief()

print("supported ip addresses:\n")
for i in addresses:
    print(i+"\n")
ipadd=input("what is the switch's ip address?: ")
while(ipadd not in addresses):
    print("invalid ip address!\n")
    ipadd=input("what is the switch's ip address?: ")


#username = input("enter username: ")
device = {
    "device_type": "cisco_ios",
    "host": ipadd, 
    #"host": "10.0.0.13",
    #"username": username,
    #"password": getpass(),
    "username": "menash",
    "password": "menash",
}

with ConnectHandler(**device) as net_connect:
    output = net_connect.send_config_set(commands)
    output += net_connect.save_config()

print()
print(output)
print()