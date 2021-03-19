import os

ip = input("enter hostname or ip address: ")
command = f"cmd /c \"getmac /s {ip}\" -U menashem_nls -P Me12345678"
# print(command)
var=os.system(command)
print(var)