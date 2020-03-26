#!/usr/bin/python -u
#coding=UTF-8

# Kopioi USB-asemalta tiedosto muistikortille ja toista se omxplayer-syncillä.
# Huom. Verkko pitää olla asetettuna niin, että masterilla on access point johon slave yhdistää.
# Helpoin tapa on kytkeä laitteet suoraan ethernetin välityksellä.
# Jos halutaan käyttää wifiä, on pystytettävä access point masterilla ja yhdistettävä siihen slavella.

# Copy a file from USB drive on the memory card and play it using omxplayer-sync.
# Note: The network must be set up so that the master has access point and slave connects to it.
# The easiest way is to connect the devices directly via Ethernet.
# To use wifi, set up an access point on the master and connect to it on the slave.

import os
import sys
import time


MEDIAPOLKU = "/media/pi/"
LOKAALI_TIEDOSTO = "/home/pi/Desktop/videot/video"

#Montako kertaa yritetään lukea mediaa ennen kuin käytetään lokaalia tiedostoa
#How many times to try reading the media; after that use a local file
MAX_YRITYKSIA = 10

# Mihin osoitteeseen master lähettää käskyjä
# Tarkasta tämä tarvittaessa ifconfigilla
# What address the master should broadcast to
# Verify this using ifconfig if there is a problem
BROADCASTOSOITE = "192.168.4.255"



def onPiilotiedostoTaiKansio(polku):
	try:
		if os.path.isdir(polku):
			return True
		if polku[0] == ".":
			return True
		return False
	except:
		return False


class c_mediaLataaja:
	liitettyPolku = ""


	# Palauta koko polku tiedostoon. Jos ei löydy, palauta ""
	# Return full path to file. If not found, return ""
	def haeTiedostoMedialta(self):
		try:
			medialuettelo = os.listdir(MEDIAPOLKU)
		except:
			return ""
		medialuettelo.sort()
		if len(medialuettelo) == 0:
			return ""
		for media in medialuettelo:
			polku = MEDIAPOLKU + media + "/"
			try:
				if os.path.isdir(polku) == False:
					continue
				tiedostot = os.listdir(polku)
			except:
				continue
			if len(tiedostot) == 0:
				continue
			tiedostot.sort()
			for tiedosto in tiedostot:
				if onPiilotiedostoTaiKansio(tiedosto):
					continue
				else:
					return polku + tiedosto
					self.liitettyPolku = polku
					break
		return ""


	def irrota(self):
		if self.liitettyPolku == "":
			return
		os.system("umount " + self.liitettyPolku)


mediaLataaja = c_mediaLataaja()



# Jos annettiin argumentti "--master", palauta "master". Muuten palauta "slave"
# If the argumet "--master" was given, return "master". Otherwise return "slave"
def masterVaiSlave():
	if len(sys.argv) > 1:
		if sys.argv[1] == "--master":
			return "master"	
	return "slave"



tila = masterVaiSlave()
print "tila: " + tila
print "mode: " + tila


while True:
	yritys = 0
	while yritys < MAX_YRITYKSIA:
		videotiedostoMedialta = mediaLataaja.haeTiedostoMedialta()
		if videotiedostoMedialta != "":
			print "Kopioidaan tiedosto muistikortille"
			print "Copying file to the local storage"
			os.system("cp -v \"" + videotiedostoMedialta + "\" " + LOKAALI_TIEDOSTO)
			mediaLataaja.irrota()
			break
		else:
			print "Ei löydetty mediaa. Yritetään uudestaan...", \
				yritys+1, "/", MAX_YRITYKSIA
			print "No media found. Trying again..."
		yritys = yritys + 1
		time.sleep(1)
	if os.path.isfile(LOKAALI_TIEDOSTO):
		break	
	else:
		print "Ei ladattua tiedostoa. Jatketaan median hakemista"
		print "No file loaded. Continue searching media"
		time.sleep(5)


#Anna käsky käynnistää omxplayer-sync
#Give command to run omxplayer-sync
print("Toistetaan video " + LOKAALI_TIEDOSTO)
print("Playing video " + LOKAALI_TIEDOSTO)
if masterVaiSlave() == "master":
	args = " -muv -x " + BROADCASTOSOITE + " "
else:
	args = " -luv "
kasky = "omxplayer-sync " + args + LOKAALI_TIEDOSTO
os.system(kasky)
