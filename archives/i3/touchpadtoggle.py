#!/usr/bin/python
import subprocess, sys

status = subprocess.Popen("synclient -l | grep 'TouchpadOff' | cut -d '=' -f 2", shell=True, stdout=subprocess.PIPE).communicate()[0]
status = str(1 - int(status))
subprocess.call(["synclient", "TouchpadOff="+status])
