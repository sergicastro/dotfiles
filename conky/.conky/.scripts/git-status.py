import os
import sys
import string

if len(sys.argv) < 2:
    raise Exception("insufficient parameters")

if os.access(sys.argv[1], os.F_OK):
    os.chdir(sys.argv[1])
    # print os.getcwd()
    temp=os.popen('git branch | grep \*')
    # branch='branch: '+temp.read()[2:]
    branch=temp.read()[2:]
    temp=os.popen('git status -s | wc -l')
    # changes='changes: '+temp.read()
    changes=temp.read()
    print branch.strip() + "\t" + changes.strip()
