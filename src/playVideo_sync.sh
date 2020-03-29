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


def addQuotes(path):
	return "\"" + path + "\""


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
print "Haetaan tiedostoa USB-medialta polusta " + addQuotes(mediaPath)
print "Searching for file from USB media in path " + addQuotes(mediaPath)
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
		# Viive on sitä varten että ehtii lukea tekstipäätteen
		# Sleep so that the user has time to read the text terminal
		time.sleep(5)
	else:
		print "Ei löydetty tiedostoa USB-medialta polussa " + addQuotes(mediaPath)
		print "No file found on USB media in path " + addQuotes(mediaPath)

	print "Toistetaan " + addQuotes(localFile) + "..."
	print "Playing " + addQuotes(localFile) + "..."

	if os.path.isfile(localFile):
		if mode == "master":
			args = "-mu -x " + broadcastAddress
		else:
			args = "-lu"
		command = "omxplayer-sync " + args + " " + addQuotes(localFile)
		os.system(command)
		exit(0)
	else:
		print "Tiedostoa " + addQuotes(localFile) + " ei ole."
		print "File " + addQuotes(localFile) + " does not exist."
		time.sleep(1)
