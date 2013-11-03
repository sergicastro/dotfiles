import os
import re
import sys
from optparse import OptionParser
from threading import Thread

ip = "ip"
name = "name"

parser = OptionParser(usage="ping.py <option>")
parser.add_option("-c", "--conky",
        action="store_true", dest="conky",
        help="returns output ready to use in conky")
parser.add_option("-l", "--host",
        action="store", dest="host",
        help="the host name or ip to check")
parser.add_option("-n", "--name",
        action="store", dest="name",
        help="human readable name of the host")
(options, args) = parser.parse_args(sys.argv)
conky = options.conky
host = options.host
name = options.name


class testit(Thread):
    def __init__(self, host):
        Thread.__init__(self)
        self.ip = host
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

pingle = testit(host)
pingle.start()
pingle.join()
print host, " [%s]" % name if name else "", alignr, report[pingle.status]

# print time.ctime()
