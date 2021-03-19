import getpass
import sys
import telnetlib

HOST = input("Please enter host ip address: ")
user = raw_input("Enter your telnet username: ")
password = getpass.getpass()

tn = telnetlib.Telnet(HOST)

tn.read_until("Username: ")
tn.write(user + "\n")
if password:
    tn.read_until("Password:  ")
    tn.write(password + "\n")

tn.write("enable\n")
tn.write("end\n")
tn.write("exit\n")

print(tn.read_all())