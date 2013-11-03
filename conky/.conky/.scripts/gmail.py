import sys
import os
import string

USAGE = "USAGE: python " + sys.argv[0] + " username password [OPTION -q / -n / -s / -d <domain>]"
ESPEAK = "espeak 'tienes %(i)s correos en la cuenta %(s)s' -p 20 -v es -a 99"
NOTIFY = "notify-send %(s)s 'tienes %(i)s correos'"

if len(sys.argv) < 3:
    print USAGE 
    exit()

espeak = "-s" in sys.argv
notify = "-n" in sys.argv
usedomain = "-d" in sys.argv
q=""
if "-q" in sys.argv:
    q = "-q "

if usedomain:
    i = sys.argv.index("-d")+1
    if i < len(sys.argv):
        domain = sys.argv[i]
        usedomain = domain != None
        if not usedomain:
            print USAGE
            exit()
    else:
        print USAGE
        exit()

# Enter your username and password below within double quotes
# eg. username="username" and password="password"
username=sys.argv[1]
password=sys.argv[2]

if not usedomain:
    com="wget "+q+"-O - https://"+username+":"+password+"@mail.google.com/mail/feed/atom --no-check-certificate"
else:
    com="wget "+q+"-O - https://mail.google.com/a/"+domain+"/feed/atom --http-user="+username+"@"+domain+" --http-password="+password+" --no-check-certificate"

temp=os.popen(com)
msg=temp.read()

if len(msg) == 0:
    print "401 unauthorized"
    exit()

index=string.find(msg,"<fullcount>")
index2=string.find(msg,"</fullcount>")

acindx=string.find(msg,"<title>")
acindx2=string.find(msg,"</title>")

fc=int(msg[index+11:index2])
ac=msg[acindx+25:acindx2]

if fc==0:
    print "0 new mails  "+ac
else:
    print str(fc)+" new mails  "+ac
    if espeak:
        os.popen(ESPEAK % {'i' : str(fc), 's' : ac})
    if notify:
        os.popen(NOTIFY % {'i' : str(fc), 's' : ac})
