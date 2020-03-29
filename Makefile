srcPath = src/
installationPath = /home/pi/Desktop/videoPlayerSync/

autostartSrcPath = config/
autostartMaster = syncplayer-master.desktop
autostartSlave = syncplayer-slave.desktop
autostartPath = /home/pi/.config/autostart/

omxplayerSyncSrc = \
https://github.com/turingmachine/omxplayer-sync/raw/master/omxplayer-sync
omxplayerSyncPath = /usr/bin/omxplayer-sync

all:
	slave

omxplayer_sync:
	sudo wget -O $(omxplayerSyncPath) $(omxplayerSyncSrc)
	sudo chmod 0755 $(omxplayerSyncPath)

master: omxplayer_sync
	rm -f $(autostartPath)$(autostartSlave)
	mkdir -p $(autostartPath)
	cp $(autostartSrcPath)$(autostartMaster) $(autostartPath)
	mkdir -p $(installationPath)
	cp $(srcPath)* $(installationPath)
	chmod +x $(installationPath)*.sh

slave: omxplayer_sync
	rm -f $(autostartPath)$(autostartMaster)
	cp $(autostartSrcPath)$(autostartSlave) $(autostartPath)
	mkdir -p $(installationPath)
	cp $(srcPath)* $(installationPath)
	chmod +x $(installationPath)*.sh

uninstall:
	rm -f $(autostartPath)$(autostartSlave)
	rm -f $(autostartPath)$(autostartMaster)
	rm -rf $(installationPath)
	sudo rm -f $(omxplayerSyncPath)
