import os
import socket
import subprocess
import telnetlib
import time

def gethostname(hostname):
	return socket.gethostbyname(hostname)


HostOrIp = input("enter \'hostname\' to search by hostname, enter \'ip\' to search by ip address: ")
while(HostOrIp!= 'ip' and HostOrIp!='hostname'):
	print("invalid input")
	HostOrIp=input("enter 1 to search by hostname, enter 2 to search by ip address")

    if(HostOrIp == 'ip'):
	    host=input("enter ip address: ")
    elif(HostOrIp == 'hostname'):
    	host=gethostname(input("enter hostname: "))

ping = "ping -n 1 " + host
os.system(ping)
time.sleep(1)

cmd = 'arp -a ' + host + ' | findstr ' + host
returned_output = subprocess.check_output((cmd),shell=True,stderr=subprocess.STDOUT)
parse=str(returned_output).split(' ',1)
ipadd=parse[1].split(' ')
for i in range(len(ipadd)):
	if(len(ipadd[i]) == 17):
		mac = ipadd[i]
		break

print("mac address: ", mac)

tn=telnetlib.Telnet(host)
tn.read_until(b"Username: ")
tn.write(b"choshen")
tn.read_until(b"Password: ")
tn.write(b"choshenpass")

tn.write(b"show mac address-table | i ",mac.encode('assci'))
tn.write(b"show mac address-table address " ,mac.encode('ascii'))