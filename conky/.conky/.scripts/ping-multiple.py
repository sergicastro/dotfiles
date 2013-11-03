import os
import re
import sys
from optparse import OptionParser
from threading import Thread

ip = "ip"
name = "name"
hosts = [{ip:"10.60.12.191", name:"Environment"},
        {ip:"10.60.12.240", name:"RS centos"},
        # {ip:"10.60.12.244", name:"KVM"},
        # {ip:"10.60.12.245", name:"KVM"},
        # {ip:"10.60.12.246", name:"VirtualBox"},
        {ip:"10.60.1.245", name:"scastro machine"},
        {ip:"optimus", name:"Optimus Prime"},
        {ip:"raspbmc", name:"Raspbmc"}]

parser = OptionParser(usage="ping.py <option>")
parser.add_option("-c", "--conky",
        action="store_true", dest="conky",
        help="returns output ready to use in conky")
(options, args) = parser.parse_args(sys.argv)
conky = options.conky


class testit(Thread):
    def __init__(self, host):
        Thread.__init__(self)
        self.ip = host['ip']
        self.name = host['name']
        self.status = -1

    def run(self):
        pingaling = os.popen("ping -q -c2 " + self.ip, "r")
        while 1:
            line = pingaling.readline()
            if not line:
                break
            igot = re.findall(testit.lifeline, line)
            if igot:
                self.status = int(igot[0])

testit.lifeline = re.compile(r"(\d) received")
if conky:
    alignr = "${alignr}"
    report = ("${color FF0000}No response${color}",
        "${color FFCC00}Partial response${color}",
        "${color 00FF00}Alive${color}")
else:
    alignr = " "
    report = ("No response", "Partial Response", "Alive")

# print time.ctime()

pinglist = []

for host in hosts:
    current = testit(host)
    pinglist.append(current)
    current.start()

for pingle in pinglist:
    pingle.join()
    print pingle.ip, "[", pingle.name, "]", \
        alignr, report[pingle.status]

# print time.ctime()
