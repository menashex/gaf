import os

ip = input("enter hostname or ip address: ")
command = f"cmd /c \"getmac /s {ip}\" -U user -P pass"
# print(command)
var=os.system(command)
print(var)