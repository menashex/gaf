import os
import socket
import subprocess
import telnetlib
import time

host = "10.10.10.10"
mac = input("please enter mac address: ")
tn=telnetlib.Telnet(host)
tn.read_until(b"Username: ")
tn.write(b"choshen")
tn.read_until(b"Password: ")
tn.write(b"choshenpass")

tn.write(b"show mac address-table | i ",mac.encode('assci'))

