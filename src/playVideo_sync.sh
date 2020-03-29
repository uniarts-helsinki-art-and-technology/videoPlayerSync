#!/usr/bin/python
# coding=UTF-8
from mediaLoader import mediaLoader
import os
import time
import sys

mediaPath = "/media/pi/"
localFile = "/home/pi/Desktop/videot/video"
broadcastAddress = "192.168.4.255"
maxTries = 10


# Selvitä polku ja lisää lainausmerkit
# Clean the path and add quotes
def cleanPath(path):
	path = path.strip('\"')
	path = os.path.abspath(path)
	path = "\"" + path + "\""
	return path


def masterOrSlave():
	if len(sys.argv) > 1:
		if sys.argv[1] == "--master":
			return "master"	
	return "slave"


mode = masterOrSlave()
print "tila: " + mode
print "mode: " + mode

# Yritä 'maxTries' kertaa kopioida ja toistaa tiedostoa USB-laitteelta.
#   Jos ei löydy yritysten jälkeen, toista lokaalista polusta tiedosto.
#   Jos lokaalia tiedostoakaan ei ole, yritä uudestaan loputtomasti.
#   USB-laite irrotetaan kopioinnin jälkeen.
# Try 'maxTries' times to copy and play file from USB device.
#   If no file is found, play a file from the local path.
#   If there's no file at the local path, try again forever.
#   USB device is unmounted after copying.

USB = mediaLoader()
USB.setMediaMountPath(mediaPath)
print "Haetaan tiedostoa USB-medialta polusta " + cleanPath(mediaPath)
print "Searching for file from USB media in path " + cleanPath(mediaPath)
fileWasCopied = USB.copyFromMediaToFile(localFile)

while True:
	try_i = 0
	while fileWasCopied == False and try_i < maxTries:
		try_i = try_i + 1
		print "Yritetään uudestaan... " + str(try_i) + "/" + str(maxTries)
		print "Trying again... "
		time.sleep(1)
		fileWasCopied = USB.copyFromMediaToFile(localFile)

	if fileWasCopied == True:
		print "Tiedosto kopioitiin"
		print "File was copied"
		USB.unmount()
		# Viive on sitä varten että käyttäjä ehtii lukea tekstipäätteen
		# Sleep so that the user has time to read the text terminal
		time.sleep(5)
	else:
		print "Ei löydetty tiedostoa USB-medialta polussa " + cleanPath(mediaPath)
		print "No file found on USB media in path " + cleanPath(mediaPath)

	print "Toistetaan " + cleanPath(localFile) + "..."
	print "Playing " + cleanPath(localFile) + "..."

	if os.path.isfile(localFile):
		if mode == "master":
			args = "-mu -x " + broadcastAddress
		else:
			args = "-lu"
		command = "omxplayer-sync " + args + " " + cleanPath(localFile)
		
		#Jos omxplayer-sync sulkeutuu, käynnistetään se heti uudestaan
		while True:
			os.system(command)
			print "Toisto keskeytyi. Toistetaan uudelleen..."
			print "Playback interrupted. Playing again..."
			time.sleep(1)
			
		exit(1)
	else:
		print "Tiedostoa " + cleanPath(localFile) + " ei ole."
		print "File " + cleanPath(localFile) + " does not exist."
		time.sleep(1)
