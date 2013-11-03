#!/usr/bin/env python

 
import sys,os,dbus

if sys.argv[1] == "--help":
	print("Usage: <script> --artist | --name | --album | --percent | --track")
else:
	rc = os.system( "ps -ef | grep -v grep | grep -c 'banshee' > /dev/null" )

	if rc == 0:


	    bus = dbus.SessionBus()
	    banshee = bus.get_object("org.bansheeproject.Banshee", "/org/bansheeproject/Banshee/PlayerEngine")
    
	    state = banshee.GetCurrentState()

	    if state == 'playing':
   
        	if sys.argv[1] == "--artist":
	            print(banshee.GetCurrentTrack()['artist'])

	        elif sys.argv[1] == "--name":
	            print(banshee.GetCurrentTrack()['name'])

	        elif sys.argv[1] == "--album":
	            print(banshee.GetCurrentTrack()['album'])

	        elif sys.argv[1] == "--percent":
	            print(100*banshee.GetPosition()/banshee.GetLength())
	            
	        elif sys.argv[1] == "--track":
	            print(banshee.GetCurrentTrack()['track-number'])

	        elif sys.argv[1] == "--status":
	            print(state)	
	    else:
	        if sys.argv[1] == "--status":
	            print(state)
	else:
	        print "Banshee not running"
