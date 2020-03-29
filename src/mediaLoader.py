# coding=UTF-8
import os

DEFAULT_MEDIA_PATH = "/media/pi/"


# Selvitä polku ja lisää lainausmerkit
# Clean the path and add quotes
def cleanPath(path):
	path = path.strip('\"')
	path = os.path.abspath(path)
	path = "\"" + path + "\""
	return path


# Palauta True jos annettu tiedosto on kansio tai piilotiedosto.
# Palauta True myös jos lukeminen ei onnistu (esim. oikeuksien takia)
# Return True if the given path is a directory or hidden file.
# Also return True if reading fails (eg. because of permissions)
def isDirectoryOrHiddenFile(path, filename):
	try:
		if os.path.isdir(path+filename):
			return True
		if filename[0] == ".":
			return True
		return False
	except:
		print "Ei voitu lukea: " + path+filename
		print "Could not read file " + path+filename
		return True


class mediaLoader:
	
	# Mistä etsitään liitettyjä medialaitteita. Oletus: /media/pi/
	# Where to look for mounted media devices. Default: /media/pi/
	mediaMountPath = DEFAULT_MEDIA_PATH
	
	# This is set when media file is found, so the media can be unmounted
	# Tämä asetetaan kun mediatiedosto löytyy, jotta media voidaan irrottaa
	pathToUnmount = ""
	
	
	def setMediaMountPath(self, path):
		self.mediaMountPath = path
	
	
	# Etsi tiedosto liitetyltä medialta. Palauta koko polku tiedostoon
	#   tai "" jos ei löydy.
	# Find file from mounted media. Return full path to file
	#   or "" if not found.
	def getFilenameFromMedia(self):
		try:
			mediaList = os.listdir(self.mediaMountPath)
		except:
			print "Ei voitu lukea: " + cleanPath(self.mediaMountPath)
			print "Could not read: " + cleanPath(self.mediaMountPath)
			return ""
		
		for media in mediaList:
			path = self.mediaMountPath + media + "/"
			try:
				if os.path.isdir(path) == False:
					print cleanPath(path) + " ei ole kansio"
					print cleanPath(path) + " is not a directory"
					continue
				files = os.listdir(path)
			except:
				continue
			if len(files) == 0:
				continue
			files.sort()
			for filename in files:
				if isDirectoryOrHiddenFile(path, filename):
					continue
				else:
					self.pathToUnmount = path
					return path + filename
		return ""

	
	# Palauta True jos tiedosto kopioitiin
	# Return True if file was copied
	def copyFromMediaToFile(self, dstFilename):
		filenameFromMedia = self.getFilenameFromMedia()
		if filenameFromMedia == "":
			return False
		
		print 	"Kopioidaan " \
				+ cleanPath(filenameFromMedia) \
				+ " -> " + cleanPath(dstFilename) 
			
		print 	"Copying " \
				+ cleanPath(filenameFromMedia) \
				+ " -> " + cleanPath(dstFilename) 
		
		try:
			cpCommand = "cp " \
						+ cleanPath(filenameFromMedia) \
						+ " " + cleanPath(dstFilename) 
					
			# varmista että kansio on olemassa
			# make sure the directory exists
			mkdirCommand = "mkdir -p " + cleanPath(os.path.dirname(dstFilename))
			print mkdirCommand
			os.system(mkdirCommand)
			os.system(cpCommand)
			
		except:
			print "Kopiointi epäonnistui"
			print "Copying failed"
			return False
		
		return True

	
	def unmount(self):
		if self.pathToUnmount == "":
			return
		try:
			os.system("umount " + cleanPath(self.pathToUnmount) )
		except:
			print "Ei voitu irrottaa: " + self.pathToUnmount
			print "Could not unmount: " + self.pathToUnmount
			return
